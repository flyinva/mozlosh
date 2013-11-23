#!/bin/bash

function whichOs {
    if [ -x /sbin/iwlist ]
    then
        os='linux'
    elif [ -x /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport ]
    then
        os='apple'
    fi
}

function getStationsIwlist {
    echo $(echo -n '{ "wifi": [' ;\
    sudo /sbin/iwlist scanning 2>&1 |\
    grep -e Address: -e level= -e Frequency -e Channel: |\
    sed \
    -e 's/.*Cell .* Address: \(.*\)/{"key":"\1",/' -e 's/.*Channel:\(.*\)/"channel":\1,/' -e 's/.*Frequency:\([0-9]\)\.\([0-9]*\)/"frequency":\1\2,/' -e 's/ GHz (.*)//' -e 's/.*level=//' -e 's/\(-[0-9]*\) dBm/"signal":"\1"},/' |\
    tr -d '  \n' |\
    sed s/,$// ;\
    echo -n ']}') 
}

function getStationsAirport {
    echo $(echo -n '{ "wifi": [' ;\
    cat /tmp/airport | grep -v SSID |\
    awk '{print "{\"key\":\""$2"\",\"channel\":"$4",\"level\":"$3"},"}' |\
    tr -d '  \n' |\
    sed s/,$// ;\
    echo -n ']}')
}

API='https://location.services.mozilla.com/v1/search'

whichOs

case $os in
    linux)
        data=$(getStationsIwlist)
        ;;
    apple)
        data=$(getStationsAirport)
        ;;
esac

echo -e "$data"
echo $data | curl --silent --data @- $API | jq '.'

