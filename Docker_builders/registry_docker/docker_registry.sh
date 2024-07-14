#!/bin/bash

user=$1
password=$2
registry_name="my.registry"
container_path="/srv/containers/$registry_name"

registry=$(docker images -q registry:latest)
httpd=$(docker images -q httpd:2)
[[ -z "$registry" ]] && docker pull registry:latest
[[ -z "$httpd" ]] && docker pull httpd:2
# Si se cuenta con las imagenes en tar:
#[[ -z "$registry" ]] && cat `pwd`/registry.tar | docker load
#[[ -z "$httpd" ]] && cat `pwd`/httpd2.tar | docker load

[[ ! -d $container_path/registry ]] && mkdir -p $container_path/registry

[[ ! -d $container_path/auth ]] && mkdir -p $container_path/auth
if [[ ! -f $container_path/auth/htpasswd ]]; then
      docker run --entrypoint htpasswd --name httpd httpd:2 -Bbn $user $password > $container_path/auth/htpasswd
      docker container stop httpd
      docker rm httpd
fi

[[ ! -d $container_path/certs ]] && mkdir -p $container_path/certs
[[ ! -f $container_path/certs/$registry_name.key ]] && openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $container_path/certs/$registry_name.key -out $container_path/certs/$registry_name.crt -subj "/C=MX/ST=CDMX/L=Alcaldia/O=Organizacion/OU=IT Department/CN=$registry_name"

[[ ! -d /etc/docker/certs.d/$registry_name:5000 ]] && mkdir -p /etc/docker/certs.d/$registry_name:5000
cp $container_path/certs/$registry_name.crt /etc/docker/certs.d/$registry_name:5000/ca.crt

isRegistryRunning=$(docker ps | grep -w "registry")
[ -z "$isRegistryRunning" ] && \
docker run -d \
  -p 5000:5000 \
  --restart=always \
  --name registry \
  -v $container_path/auth:/auth \
  -e "REGISTRY_AUTH=htpasswd" \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  -v $container_path/certs:/certs \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/$registry_name.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/$registry_name.key \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:5000 \
  -v $container_path/registry:/var/lib/registry \
  registry:latest || echo "I am running!!!"