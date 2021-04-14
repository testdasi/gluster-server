## gluster-server
A docker running gluster server. This primarily targets users of Unraid (and similar NAS OS) for which gluster cannot be installed but docker can. It then allows the host to run just like a normal gluster peer (e.g. to use Unraid as persistent storage for Kubernetes / Docker Swarm).

## Bits and bobs:
* Built for both Unraid and Raspberry Pi 4 but should work in other Linux amd64 / arm32v7 / arm32v6 / i386 docker environments.
* I have only tested (and used) this with privileged=true. This is frowned upon by some as a very bad case of misconfiguration (e.g. wrong volume map) may harm the host, which kinda defeats the purpose of using docker. Of course, those folks haven't tried to install gluster on Slackware (e.g. Unraid), which is impossible.
  * Apparently, you can use volume "z" instead of "rw" to avoid needing privileged but I haven't tested that since privileged works well for me.
* I recommend running with host network for best performance and having to avoid mapping the gazillion ports that gluster requires.
  * The docker exposes some selected ports e.g. for bridge mode which may or may not be sufficient for all use cases.
    * BRICK_PORT_RANGE variable will default to 49152-49162, which is usually more than enough for most uses. Keep in mind that gluster requires 1 dedicated port per brick.
* Volume mappings:
  * /etc/glusterfs (for config)
  * /var/lib/glusterd (for metadata)
  * /var/log/glusterfs (for logs)
  * /etc/hosts (for persistent hosts file (not to be confused with docker host!) so you don't have to refer to peers with ip - because a lot of the gluster guides out there seem to be allergic to ip addresses) - optional
  * A folder for the brick (to allow easy access to the gluster bricks e.g. storing gluster bricks on Unraid cache drive - which is the main reason I built this)
    * CRITICAL: Do NOT let anything make changes directly to the brick folder (both host and container!).
* Based on Debian Buster base image mainly because Raspbian Buster is derived from the same. This allows easier development, testing and building on my end.

## Bonus (experimental) feature:
* Now let's say you have got your Unraid server in a swarm but magic doesn't work because Unraid can't mount the gluster volume. Now if only you have got a gluster client somewhere... :D
  * Map a folder the same folder in the container to Unraid e.g. /mnt/cache/swarm
    * Make sure to pick rw [+ shared].
    * In case it's not obvious, your swarm services should be mapping to the same path too (e.g. /mnt/cache/swarm/nginx).
  * Set MOUNT_PATH = the container folder (e.g. /mnt/cache/swarm) [NO TRAILING SLASH!]
  * Set GLUSTER_VOL = comma-separated list of gluster volume names (e.g. vol01,vol02,vol03) [NO SPACE!]
  * Start the docker and after the server is loaded, those volumes will also be mounted and visible from Unraid i.e. your services should now be able to access the same storage location (e.g. /mnt/cache/swarm/vol01,/mnt/cache/swarm/vol02,/mnt/cache/swarm/vol03).
    * Your services should now be able to freely jump around the nodes, including Unraid.

## Unraid example
    docker run -d \
        --name='Gluster-server' \
        --net='host' \
        --privileged=true \
        -e TZ="Europe/London" \
        -e HOST_OS="Unraid" \
        -e BRICK_PORT_RANGE="49152-49162" \
        -e MOUNT_PATH="/mnt/cache/swarm" \
        -e GLUSTER_VOL="vol01,vol02,vol03" \
        -v '/mnt/user/appdata/gluster-server/metadata/':'/var/lib/glusterd':'rw' \
        -v '/mnt/user/appdata/gluster-server/log/':'/var/log/glusterfs':'rw' \
        -v '/mnt/user/appdata/gluster-server/config/':'/etc/glusterfs':'rw' \
        -v '/mnt/user/appdata/gluster-server/hosts':'/etc/hosts':'rw' \
        -v '/mnt/user/appdata/gluster-server/data/':'/gluster':'rw' \
        -v '/mnt/cache/swarm/':'/mnt/cache/swarm':'rw,shared' \
        'testdasi/gluster-server:latest'

## Notes
* I code for fun and my personal uses; hence, these niche functionalties that nobody asks for. ;)
* If you like my work, [a donation to my burger fund](https://paypal.me/mersenne) is very much appreciated.

[![Donate](https://raw.githubusercontent.com/testdasi/testdasi-unraid-repo/master/donate-button-small.png)](https://paypal.me/mersenne). 
