#!/usr/bin/perl

sleep 25;

use RRDs;

my $cur_time = time();
my $start_time = $cur_time - 604800;     # set end time to 7*24 hours ago

RRDs::graph "/var/www/graph_temp_w.png",
         "--start= $start_time",
         "--end= $cur_time",
         "--title= Temp Ute/Inne",
         "--height= 300",
         "--width= 500",
         "--vertical-label= °C",
         "DEF:UteTemp=/root/temp/ute_temp.rrd:UteTemp:AVERAGE",
         "DEF:InneTemp=/root/temp/inne_temp.rrd:InneTemp:AVERAGE",
         "COMMENT:\t\t\t\tNu     Medel    Max    Min\\n",
         "HRULE:0#FF00FF",
         "LINE2:UteTemp#0000FF:Ute\t\t\t",
         "GPRINT:UteTemp:LAST:%6.1lf",
         "GPRINT:UteTemp:AVERAGE:%6.1lf",
         "GPRINT:UteTemp:MAX:%6.1lf",
         "GPRINT:UteTemp:MIN:%6.1lf\\n",
         "HRULE:18#FFFF00",
         "LINE2:InneTemp#00FF00:Inne\t\t",
         "GPRINT:InneTemp:LAST:%6.1lf",
         "GPRINT:InneTemp:AVERAGE:%6.1lf",
         "GPRINT:InneTemp:MAX:%6.1lf",
         "GPRINT:InneTemp:MIN:%6.1lf\\n";

my $err=RRDs::error;
if ($err) {print "problem generating the graph: $err\n";}

print "Done!\n"
