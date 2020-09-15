#!/bin/bash
# ==========================================================
# Script name : portainer-ce 2.x.x
# Author : Carpe Diem a
# Production date : 2020.09.15
# e-mail : by.infofun@gmail.com
# ==========================================================
# Option Description
#
# portainer.sh -m -p -n -v -d
# -m <install/update/delete or i/u/d> (default: install)
# -p <Host Port:Guest Port> (default: 9000:9000)
# -n <container name> (default: portainer)
# -v <portainer-ce tags> (default: latest)
# -d <data path> (default: portainer_data)
# ==========================================================

mode='install'
port="9000:9000"
name='portainer'
tags='latest'
dpath='portainer_data'
help='1';

usage() {
  echo ""
  echo "=================== portainer-ce 2.x.x ==================="
  echo ""
  echo "$0 -m -p -n -v -d"
  echo "-m <install/update/delete or i/u/d> (default: install)"
  echo "-p <Host Port:Guest Port> (default: 9000:9000)"
  echo "-n <container name> (default: portainer)"
  echo "-v <portainer-ce tags> (default: latest)"
  echo "-d <data path> (default: portainer_data)"
  echo ""
  echo "=========================================================="
  echo "" 1>&2; exit 1;
}

while getopts ":m:p:n:v:d:h:" o; do
    case "${o}" in
        m)
            mode=${OPTARG}
            ((mode == 'install' || mode == 'update' || mode == 'delete' || mode == 'i' || mode == 'u' || mode == 'd')) || usage
            ;;
        p)
            port=${OPTARG}
            ;;
		n)
            name=${OPTARG}
            ;;
		v)
            tags=${OPTARG}
            ;;
		d)
            dpath=${OPTARG}
            ;;
		h)
            help=2
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${mode}" ] || [ -z "${port}" ] || [ -z "${name}" ] || [ -z "${tags}" ] || [ -z "${dpath}" ] || [ "${help}" == 2 ]; then
    usage
fi

if [ "${mode}" == 'install' ] || [ "${mode}" == 'i' ]; then

    if [ "${dpath}" == 'portainer_data' ]; then
        sudo docker volume create portainer_data
		sudo docker pull portainer/portainer-ce:${tags}
        sudo docker run -d -p ${port} -v /var/run/docker.sock:/var/run/docker.sock -v ${dpath}:/data --restart=always --name ${name} portainer/portainer-ce:${tags}
        echo "install completed."
    else
        sudo mkdir ${dpath}
		sudo docker pull portainer/portainer-ce:${tags}
        sudo docker run -d -p ${port} -v /var/run/docker.sock:/var/run/docker.sock -v ${dpath}:/data --restart=always --name ${name} portainer/portainer-ce:${tags}
		echo "install completed."
    fi

elif [ "${mode}"  == 'update' ] || [ "${mode}"  == 'u' ]; then
    sudo docker stop ${name}
    sudo docker rm ${name}
    sudo docker rmi portainer/portainer-ce:${tags}
    sudo docker pull portainer/portainer-ce:${tags}
    sudo docker run -d -p ${port} -v /var/run/docker.sock:/var/run/docker.sock -v ${dpath}:/data --restart=always --name ${name} portainer/portainer-ce:${tags}
    echo "update completed."
elif [ "${mode}"  == 'delete' ] || [ "${mode}"  == 'd' ]; then
    sudo docker stop ${name}
    sudo docker rm ${name}
    sudo docker rmi portainer/portainer-ce:${tags}
	echo "delete complete."
fi

exit 0