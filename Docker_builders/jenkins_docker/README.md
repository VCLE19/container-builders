
# jENKINS BUILDER
Este constructor se encarga de crear un contenedor jenkins con las siguientes tecnologias instaladas

1. sudo. Tiene de manera predeterminada el uso de los siguientes comandos sin solicitud de contraseña:
    - sudo 
    - docker
    - sh

2. docker cli. Te permite usar los comandos docker
    - sudo docker login my.registry:5000
    - sudo docker build
    - sudo docker pull my.registry:5000/image:latest
3. ansible. Util para crear paybooks de manera locall en un directorio montado en la immagen 

4. Compatible con registry. Tiene la posibilidad de comunicarse con el registry local, esto por medio de un certificado creado previamente para el registry.

# Pre install
## Script Build_jenkins.sh
Edita solo las primeras variables del script, en caso de no usar alguna de esas, dejarlasa en blanco _var=""_  

## Dockerfile
Las ultimmas 2 instrucciones comentadas tienen la siguiente utilidad y se recomienda descomentarlas solo en su necesario uso
- COPY ca.crt /etc/docker/certs.d/my.registry:5000/. Esta instruccion se usa en caso de tener un registry y que la conexion a este sea segura por medio de un certificado
- RUN echo "root:password" | chpasswd. Esta instruccion le asigna un password a root para que podamos usarlo dentro del contenedor 

## Apache site conf
Este contenedor ya tiene por defecto el uso de apache con el dominio jenkins.local.com, pereo puedes cambiarlo en el archivo de configuracion jenkins.local.conf

## Post install script
postinstall.sh  es un script encargado de agregar al archivo hosts el host del registry, en este caso, usando su puerta de enlace.
Tambien es el encargado de ejecutar el inicio de sesion en el registry.

# Instalacion
Ejecua el script Build_jenkins.sh
> sudo ./Build_jenkis.sh

# Post install
Luego de la creacion del contenedor sera necesario ingresar y correr el siguiente script:
> sudo sh postinstall.sh

Pedira tu usuario y contraseña para iniciar sesion en el local registry