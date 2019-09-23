#!/usr/bin/perl

use RRDs;

my $cur_time = time();
my $start_time = $cur_time - 86400;     # set end time to 24 hours ago 
                
RRDs::graph "/var/www/graph_temp_ute.png",   
			"--start= $start_time",
			"--end= $cur_time",
			"--title= Temperatur Utomhus",
			"--height= 300",
			"--width= 500",
			"--vertical-label= °C",
	      "DEF:UteTemp=/root/temp/ute_temp.rrd:UteTemp:AVERAGE",                          
			"COMMENT:\t\t\t\tNu     Medel    Max    Min\\n",
			"HRULE:0#0000FF",         
	      "LINE2:UteTemp#0000FF:Ute\t\t\t",    
			"GPRINT:UteTemp:LAST:%6.1lf",
			"GPRINT:UteTemp:AVERAGE:%6.1lf",
			"GPRINT:UteTemp:MAX:%6.1lf",
			"GPRINT:UteTemp:MIN:%6.1lf\\n";

my $err=RRDs::error;
if ($err) {print "problem generating the graph: $err\n";}

print "Done!\n"