#!/bin/bash

IW='sudo /sbin/iwlist'
API='https://location.services.mozilla.com/v1/search'

echo $(echo -n '{ "wifi": [' ;\
$IW $1 scan |\
grep -e Address: -e level= -e Frequency -e Channel: |\
sed \
-e 's/.*Cell .* Address: \(.*\)/{"key":"\1",/' -e 's/.*Channel:\(.*\)/"channel":\1,/' -e 's/.*Frequency:\([0-9]\)\.\([0-9]*\)/"frequency":\1\2,/' -e 's/ GHz (.*)//' -e 's/.*level=//' -e 's/\(-[0-9]*\) dBm/"signal":"\1"},/' |\
tr -d '  \n' |\
sed s/,$// ;\
echo -n ']}') |\
curl --silent --data @- $API |\
jq '.'

