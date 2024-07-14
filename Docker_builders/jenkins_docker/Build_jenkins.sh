#!/bin/bash

# Vars
host_jenkinshome="$(pwd)/jenkins_home"
ansible_path="$(pwd)/ansible"
registry="my.registry:5000"
new_image_tag="my.registry:5000/jenkins:latest"
container_name="jenkins"
custom_jenkinshome="$(pwd)/jenkins_home.tar"
custom_image="$(pwd)/jenkins_image.tar"
custom_image_name="jenkins"
plugins="$(pwd)/plugins/"

# Install dependencies
apt-get install -y jq python3

# Build a new image with a custom Dockerfile
new_image() {
	docker pull jenkins/jenkins:latest
	docker build --tag $new_image_tag .
}

# In case of build a new image, you need to update your local plugins
update_plugins(){
	local plugins_old="$(pwd)/plugins_$(date +%I%M%S)"
	if [ -d $plugins ];then
		curl  https://updates.jenkins.io/current/update-center.actual.json | jq '.' > actualpluginversion.json
		mv $plugins $plugins_old
		mkdir -p $plugins
		for n in $(ls $plugins_old | awk -F "." '{print $1}')
		do
			local_plugin="$(sha256sum $plugins_old/$n.hpi | awk '{print $1}')"
			update_plugin="$(jq -r '.plugins."'"${n}"'".sha256' actualpluginversion.json | python3 -c 'import base64, sys; print(base64.b64decode(sys.stdin.read().strip()).hex())')"
			if [ "$local_plugin" == "$update_plugin" ];then
				cp -v $plugins_old/$n.hpi $plugins
			else
				wget -q --show-progress https://updates.jenkins-ci.org/latest/$n.hpi -P $plugins
			fi
		done
	fi
}

registry_certs(){
	if [ -f "/etc/docker/certs.d/$registry/ca.crt" ]; then
		cp /etc/docker/certs.d/$registry/ca.crt $(pwd)/.
}

apache_jenkins() {
	apt install apache2
	a2enmod proxy
	a2enmod proxy_http
	a2enmod proxy_balancer
	a2enmod lbmethod_byrequests
	cp ./jenkins.local.com.conf /etc/apache2/sites-available/
	a2ensite jenkins.local.com
}

#########################################################################################################

# Create jenkins directories in Host
mkdir -p $host_jenkinshome
chmod 777 $host_jenkinshome
mkdir -p $ansible_path

# Create jenkins image
if [ -f "$custom_image" ]; then
	cat $custom_image | docker load
	image=$custom_image_name
else
	update_plugins
	registry_certs
	new_image
	image=$new_image_tag
fi

# Use a custom jenkins_home?
[ -f "$custom_jenkinshome" ] && tar xvf $custom_jenkinshome -C $host_jenkinshome

# Is running?
isRegistryRunning=$(docker ps | grep -w "$container_name")
[ -z "$isRegistryRunning" ] &&
	docker run -d \
	--privileged \
	--restart=always \
	-p 8080:8080 \
	-p 50000:50000 \
	--name $container_name \
	-v $host_jenkinshome:/var/jenkins_home \
	-v $ansible_path:/var/jenkins_home/ansible \
	-v /var/run/docker.sock:/var/run/docker.sock \
	$image || echo "I am running!!!"

#apache_jenkins