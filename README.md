mozlosh
=======

**Moz**illa **lo**cation **sh**ell**:** mozlosh

## Description

Bash script to get location from WiFi with [Mozilla location service](http://location.services.mozilla.com/).

What this script does :

 - runs a command to get wireless stations around
 - retrieves BSSID, channel, frequency and signal power (depends of command)
 - uses Mozilla location service API to get the position

Mozilla API : https://mozilla-ichnaea.readthedocs.org/en/latest/api/search.html

Tested on GNU & Linux, the script could work on MacOS, feedback needed.


## Dependencies

 - `jq` http://stedolan.github.io/jq/

and one of
 - `iwlist` (needs `sudo`) (GNU & Linux)
 - `nmcli` from network-manager (GNU & Linux)
 - `wicd-cli` from wicd (GNU & Linux)
 - `airport` (mac)

Mozilla API accepts :

 - key : BSSID
 - channel
 - frequency
 - signal level in dbm

All commands don't show all informations

 - `iwlist` : all fields
 - `nmcli` : BSSID, frequency
 - `wicd-cli` : BSSID, channel
 - `airport` : BSSID, channel, signal level

`nmcli` shows signal level but not in DBM, I can't find the unit ;-)

## TODO

 - better output with [jq](http://stedolan.github.io/jq/)
