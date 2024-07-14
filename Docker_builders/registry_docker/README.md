# Docker registry

Crea un contenedor registry local, 

## Ejecucion
La ejecucion del scipt deve de ser de la siguiente manera:

> sudo sh docker_registry.sh user pass

Sustituir user y pass

## Post-Instalacion
Para la documentacion se usara como ejemplo el nombre registry.local.com, pero este debe de cambiar dependiendo del nombre que se le asigne

Agrega el nombre de tu registry en tu archivo hosts
> echo "127.0.0.1 registry.local.com" >> /etc/hosts

Copiar el certicado generado en la siguiente ruta, y con el nombre ca.crt
> /etc/docker/certs.d/registry.local.com:5000/ca.crt

Es necesario iniciar sesion en el registry, aqui colocaras el user pass que hayas elegido
> docker login registry.local.com:5000

## Conexion remota
En los hosts que se vayan a conectar al registry es necesario realizar lo siguiente
### Archivo hosts
En el archivo hosts hay que agregar el servidor y el nombre del registry
> echo "192.168.0.2 registry.local.com"
### Copiar certificado
En los hosts se debe de copiar el certicado generado en la siguiente ruta, y con el nombre ca.crt
> /etc/docker/certs.d/registry.local.com:5000/ca.crt
