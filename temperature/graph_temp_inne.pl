#!/usr/bin/perl

use RRDs;

my $cur_time = time();
my $start_time = $cur_time - 86400;     # set end time to 24 hours ago 
                
RRDs::graph "/var/www/graph_temp_inne.png",   
			"--start= $start_time",
			"--end= $cur_time",
			"--title= Temperatur Inomhus",
			"--height= 300",
			"--width= 500",
			"--vertical-label= °C",
	      "DEF:InneTemp=/root/temp/inne_temp.rrd:InneTemp:AVERAGE",                          
			"COMMENT:\t\t\t\tNu     Medel    Max    Min\\n",
			"HRULE:0#0000FF",         
	      "LINE2:InneTemp#0000FF:Inne\t\t\t",    
			"GPRINT:InneTemp:LAST:%6.1lf",
			"GPRINT:InneTemp:AVERAGE:%6.1lf",
			"GPRINT:InneTemp:MAX:%6.1lf",
			"GPRINT:InneTemp:MIN:%6.1lf\\n";

my $err=RRDs::error;
if ($err) {print "problem generating the graph: $err\n";}

print "Done!\n"