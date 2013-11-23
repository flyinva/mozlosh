#!/bin/bash

function getStationsNetworkManager {
    echo $(echo -n '{ "wifi": [' ;\
    nmcli -fields BSSID,FREQ,SIGNAL device wifi | grep -v SSID | sed 's/ MHz//' |\
    awk '{print "{\"key\":\""$1"\",\"frequency\":"$2",\"level\":"$3"},"}' |\
    tr -d '  \n' |\
    sed s/,$// ;\
    echo -n ']}')
}

function getStationsWicd {
    echo $(echo -n '{ "wifi": [' ;\
    wicd-cli --wireless --list-networks | grep -v SSID | sed 's/ MHz//' |\
    awk '{print "{\"key\":\""$2"\",\"channel\":"$3"},"}' |\
    tr -d '  \n' |\
    sed s/,$// ;\
    echo -n ']}')
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
    /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport | grep -v SSID |\
    awk '{print "{\"key\":\""$2"\",\"channel\":"$4",\"level\":"$3"},"}' |\
    tr -d '  \n' |\
    sed s/,$// ;\
    echo -n ']}')
}

API='https://location.services.mozilla.com/v1/search'

cmd=${1:-iwlist}

case $cmd in
    nmcli)
        data=$(getStationsNetworkManager)
        ;;
    wicd)
        data=$(getStationsWicd)
        ;;
    iwlist)
        data=$(getStationsIwlist)
        ;;
    airport)
        data=$(getStationsAirport)
        ;;
esac

echo -e "$data"
#echo $data | curl --silent --data @- $API | jq '.'

