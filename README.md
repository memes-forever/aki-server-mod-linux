# aki-server-mod-linux
Bash script for install Aki Server mod for linux

***

before using in console: `chmod +x ./run.sh`

***

* For install node `./run.sh node_install`
* For install zerotier `./run.sh zerotier_install`
* For join zerotier `./run.sh zerotier_join <hash_server>`
* For build server `./run.sh build`
* For build coop mod `./run.sh build_coop`
* For fix server mod files `./run.sh mods_fix` \
Before run server, change ip in *run.sh* (`DEFAULT_IP=x.x.x.x`)
* For run server `./run.sh server`
* For run server in background `./run.sh server_d`
* For status server `./run.sh status`
* For kill server  `./run.sh kill`

Works great on Rock PI 4A \
https://wiki.radxa.com/Rock4 \
![alt text](https://wiki.radxa.com/mw/images/thumb/e/e9/ROCK_4AB.gif/300px-ROCK_4AB.gif)
