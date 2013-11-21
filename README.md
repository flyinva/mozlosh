mozlosh
=======

Bash script to get location from WiFi with [http://location.services.mozilla.com/](Mozilla location service).

What this script does :

 - runs `iwlist` to get wireless stations around
 - retreiveis BSSID, channel, frequency and signal power
 - uses Mozilla location service to get position

Wireless interface is given as first argument.

Mozilla API : https://mozilla-ichnaea.readthedocs.org/en/latest/api/search.html


Dependencies :
 - `iwlist` (needs `sudo`)
 - `jq` http://stedolan.github.io/jq/

TODO : 
 - try with wicd-cli
 - better output with [http://stedolan.github.io/jq/](jq)

mozlosh comes from **Moz**illa **lo**cation **sh**ell


