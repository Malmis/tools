#!/bin/sh
SMSC="+6281100000"
MSG=`cat template.txt`
for i in `cat phones.txt`; do
 echo "$MSG" | gnokii --sendsms $i --smsc $SMSC
done
