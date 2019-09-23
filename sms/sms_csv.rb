#!/usr/bin/env ruby
msg=ARGV[0]
file_name=ARGV[1]
p "your contact book name is : #{file_name} \n"
file=File.open("#{file_name}","r")
file.each do |contact|
contact.chomp!
contact_detail=contact.split(/,/)
system("echo    '#{msg}'   | gnokii --sendsms  '#{contact_detail[1]}' ")
print " msg sent to  #{contact_detail[0]}  :  #{contact_detail[1]}    \n "
sleep(10)
end
file.close
print "Msg Sent To All  Members Successfully \n"
print "Bye\n"
#End of Prog
