# portainer
portainer 2.x.x install &amp; update &amp; delete

chmod 755 portainer.sh

help : portainer.sh -h

portainer.sh -m -p -n -v -d

-m <install/update/delete or i/u/d> (default: install)
-p <Host Port:Guest Port> (default: 9000:9000)
-n <container name> (default: portainer)
-v <portainer-ce tags> (default: latest)
-d <data path> (default: portainer_data)
  
========================================================
Run without options
default : install

portainer.sh

When run it runs like the following

docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data --restart=always --name portainer portainer/portainer-ce:latest
========================================================

install
portainer.sh
portainer.sh -m install
portainer.sh -m i

update
portainer.sh -m update
portainer.sh -m u

delete
portainer.sh -m delete
portainer.sh -m d
