## gluster-server
A docker running gluster server. This primarily targets users of Unraid (and similar NAS OS) for which gluster cannot be installed but docker can. It then allows the host to run just like a normal gluster peer (e.g. to use Unraid as persistent storage for Kubernetes / Docker Swarm)

## Bits and bobs:
* Built for both Unraid and Raspberry Pi 4 but should work in other Linux amd64 / arm32v7 / arm32v6 / i386 docker environments.
* I have only tested (and used) this with privileged=true. This is frowned upon by some as a very bad case of misconfiguration (e.g. wrong volume map) may harm the host, which kinda defeats the purpose of using docker. Of course, those folks haven't tried to install gluster on Slackware (e.g. Unraid), which is impossible.
  * Apparently, you can use volume "z" instead of "rw" to avoid needing privileged but I haven't tested that since privileged works well for me.
* I recommend running with host network for best performance and having to avoid mapping the gazillion ports that gluster requires.
  * The docker exposes some selected ports e.g. for bridge mode which may or may not be sufficient for all use cases.
    * BRICK_PORT_RANGE variable will default to 49152-49162, which is usually more than enough for most uses. Keep in mind that gluster requires 1 dedicated port per brick.
* Make sure to map these 3 volumes to host
  * /etc/glusterfs (for config)
  * /var/lib/glusterd (for metadata)
  * /var/log/glusterfs (for logs)
* Optionally, also map these
  * /etc/hosts (for persistent hosts file (not to be confused with docker host!) so you don't have to refer to peers with ip - because a lot of the gluster guides out there seem to be allergic to ip addresses)
  * A folder for the brick (to allow easy access to the gluster bricks e.g. storing gluster bricks on Unraid cache drive - which is the main reason I built this)
* Based on Debian Buster base image mainly because Raspbian Buster is derived from the same. This allows easier development, testing and building on my end.

## Unraid example
    docker run -d \
        --name='Gluster-server' \
        --net='host' \
        --privileged=true \
        -e TZ="Europe/London" \
        -e HOST_OS="Unraid" \
        -v '/mnt/user/appdata/gluster-server/metadata/':'/var/lib/glusterd':'rw' \
        -v '/mnt/user/appdata/gluster-server/log/':'/var/log/glusterfs':'rw' \
        -v '/mnt/user/appdata/gluster-server/config/':'/etc/glusterfs':'rw' \
        -v '/mnt/user/appdata/gluster-server/hosts':'/etc/hosts':'rw' \
        -v '/mnt/user/appdata/gluster-server/data/':'/gluster':'rw' \
        'testdasi/gluster-server:latest'

## Notes
* I code for fun and my personal uses; hence, these niche functionalties that nobody asks for. ;)
* If you like my work, [a donation to my burger fund](https://paypal.me/mersenne) is very much appreciated.

[![Donate](https://raw.githubusercontent.com/testdasi/testdasi-unraid-repo/master/donate-button-small.png)](https://paypal.me/mersenne). 
