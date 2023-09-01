# Don't use it! Look: [aki-server-docker](https://github.com/memes-forever/aki-server)

## aki-server-mod-linux
Bash script for install Aki Server mod for linux

***

before using in console: `chmod +x ./run.sh`

***

### Prepare to build AKI Server
* install node `./run.sh node_install`
* install zerotier `./run.sh zerotier_install`
* join zerotier `./run.sh zerotier_join <hash_server>`

### Build AKI Server
* build server `./run.sh build`
* build coop mod `./run.sh build_coop`
* fix server mod files `./run.sh mods_fix`

### Run
* Beefore run server, change ip in *run.sh* (`DEFAULT_IP=x.x.x.x`)
* run server `./run.sh server`
* run server in background `./run.sh server_d`
* status server `./run.sh status`
* kill server  `./run.sh kill`

### Backup profiles
* backup profiles  `./run.sh backup_profiles`
* backup list  `./run.sh backup_list`
* unzip profiles  `./run.sh backup_restore backup-<date>.tar`


***

### Cron example

* Kill server every day `55 10 * * * cd /home/xxxx/server && ./run.sh kill`
* Run server every 15 min, if not run `*/15 * * * * cd /home/xxxx/server && ./run.sh server_d`
* Run backup `1 * * * * cd /home/xxxx/server && ./run.sh backup_profiles`

***


Works great on Rock PI 4A \
https://wiki.radxa.com/Rock4 \
![rock pi4a](https://wiki.radxa.com/mw/images/thumb/e/e9/ROCK_4AB.gif/300px-ROCK_4AB.gif)
