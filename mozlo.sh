#!/bin/bash

function getStationsNetworkManager {
    nmcli -fields BSSID,FREQ,SIGNAL device wifi | grep -v SSID | sed 's/ MHz//' |\
    awk '{print "{\"key\":\""$1"\",\"frequency\":"$2",\"level\":"$3"},"}' |\
    tr -d '  \n' |\
    sed s/,$// ;\
}

function getStationsWicd {
    wicd-cli --wireless --list-networks | grep -v SSID | sed 's/ MHz//' |\
    awk '{print "{\"key\":\""$2"\",\"channel\":"$3"},"}' |\
    tr -d '  \n' |\
    sed s/,$// ;\
}

function getStationsIwlist {
    sudo /sbin/iwlist scanning 2>&1 |\
    grep -e Address: -e level= -e Frequency -e Channel: |\
    sed \
    -e 's/.*Cell .* Address: \(.*\)/{"key":"\1",/' -e 's/.*Channel:\(.*\)/"channel":\1,/' -e 's/.*Frequency:\([0-9]\)\.\([0-9]*\)/"frequency":\1\2,/' -e 's/ GHz (.*)//' -e 's/.*level=//' -e 's/\(-[0-9]*\) dBm/"signal":"\1"},/' |\
    tr -d '  \n' |\
    sed s/,$// ;\
}

function getStationsAirport {
    /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s | grep -v SSID |\
    awk '{print "{\"key\":\""$2"\",\"channel\":"\"$4\"",\"level\":"$3"},"}' |\
    tr -d '  \n' |\
    sed s/,$// ;\
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

data='{ "wifi": ['$data']}'

echo "Send to API"
echo -e "$data" | jq '.'
response=$(echo $data | curl --silent --data @- $API)
status=$(echo $response | jq '.status' | sed 's/"//g')
lon=$(echo $response | jq '.lon')
lat=$(echo $response | jq '.lat')

if [ "$status" = "ok" ]
then
    echo "Received"
    echo $response | jq '.'
    echo "http://www.openstreetmap.org/#map=16/$lat/$lon"
fi


