#!/usr/bin/perl
# By Peter Andersson peter@it-slav.net
# rrd_tempsensor.pl
use RRDs;
use OW;
# define location of rrdtool databases
my $rrd = '/root/temp/rrd/';
# define location of images
my $img = '/var/www/';
# process data for each interface (add/delete as required)
&ProcessSensor(0, "Temperatur Ute", "localhost" , "4304" , "ute");
&ProcessSensor(1, "Temperatur Inne", "localhost",4304, "inne");
#&ProcessSensor(2, "Temperatur ute", "localhost",4304,"10.DEF05F010800");
sub ProcessSensor
{
# process sensor
# inputs: $_[0]: sensor number (ie, 0/1/2/etc)
#         $_[1]: sensor description
        print "number:$_[0] desc:$_[1], server:$_[2] port:$_[3], id: $_[4]\n";
        my $owserver = "$_[2]:$_[3]";
        unless(OW::init($owserver)) {
            $status = $ERRORS{CRIT};
            $message = "OWServer not running at $owserver\n";
            exit $status;
        }
        # get temperature from sensor
        my $handle = OW::get("$_[4]/temperature");
#       print "handle=$handle\n";
        $handle =~ s/^\s*(.*?)\s*$/$1/;
        ## Check if input is an integer or decimal
        unless (($handle =~ /^-?(?:\d+(?:\.\d*)?|\.\d+)$/) || ($handle =~ /^[+-]?\d+$/))
        {
                print "Not an integer or a decimal\n";
                return($ERRORS{CRITICAL});
        }
        $temp=$handle;
        # remove eol chars
        chomp($temp);
        print "sensor $_[0]: $temp degrees C\n";
        # if rrdtool database doesn't exist, create it
        if (! -e "$rrd/temp$_[0].rrd")
        {
                print "creating rrd database for temp sensor $_[0]...\n";
                RRDs::create "$rrd/temp$_[0].rrd",
                        "-s 300",
                        "DS:temp:GAUGE:600:U:U",
                        "RRA:AVERAGE:0.5:1:2016",
                        "RRA:AVERAGE:0.5:6:1344",
                        "RRA:AVERAGE:0.5:24:2190",
                        "RRA:AVERAGE:0.5:144:3650";
        }
        if ($ERROR = RRDs::error) { print "$0: failed to create $_[0] database file: $ERROR\n"; }
        # check for error code from temp sensor
        if (int $temp eq 85)
        {
                print "failed to read value from sensor $_[0]\n";
        }
        else
        {
                # insert values into rrd
                RRDs::update "$rrd/temp$_[0].rrd",
                        "-t", "temp",
                        "N:$temp";
                if ($ERROR = RRDs::error) { print "$0: failed to insert $_[0] data into rrd: $ERROR\n"; }
        }
        # create graphs for current sensor
        &CreateGraph($_[0], "day", $_[1]);
        &CreateGraph($_[0], "week", $_[1]);
        &CreateGraph($_[0], "month", $_[1]);
        &CreateGraph($_[0], "year", $_[1]);
}
sub CreateGraph
{
# creates graph
# inputs: $_[0]: sensor number (ie, 0/1/2/etc)
#         $_[1]: interval (ie, day, week, month, year)
#         $_[2]: sensor description
        RRDs::graph "$img/temp$_[0]-$_[1].png",
                "-s -1$_[1]",
                "-t $_[2]",
                "-h", "150", "-w", "475",
                "-a", "PNG",
                "-v tux.snusk.nu",
                "--slope-mode",
                "DEF:temp=$rrd/temp$_[0].rrd:temp:AVERAGE",
                "LINE2:temp#FF0000::",
                "CDEF:tempavarage=temp,86400,TREND",
                "LINE1:tempavarage#000088::",
                "GPRINT:temp:MIN:  Min\\: %6.1lf",
                "GPRINT:temp:MAX:  Max\\: %6.1lf",
                "GPRINT:temp:AVERAGE: Snitt\\: %6.1lf",
                "GPRINT:temp:LAST: Nuvarande\\: %6.1lf grader C\\n";
        if ($ERROR = RRDs::error) { print "$0: unable to generate sensor $_[0] $_[1] graph: $ERROR\n"; }
}
