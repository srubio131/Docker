Guía Docker *(Host Windows)*
---

Docker sirve para empaquetar una o varias aplicaciones (con sus requisitos) dentro de un contenedor que se ejecuta independientemente desde un ordenador (host). Es decir, un contenedor de docker es una caja negra que contiene lo necesario para que una aplicación funcione independiende del sistema donde se lanza.

También se puede crear un contenedor basado en un sistema operativo (windows o linux) que contenga las aplicaciones que quieras y acceder a ese contenedor a través de un shell.

## **0. Instalación Docker**

[Descargar Docker desde la web oficial](https://docs.docker.com/docker-for-windows/install/)

Este enlace es para windows pero en el menú de la izquierda dentro de &quot;Docker CE&quot; hay  enlaces a las instrucciones para instalar en Mac, Windows, Ubuntu, etc.
Seguir las instrucciones y pa&#39; lante.

*Nota.: En windows hay que activar Hyper-v en la BIOS y quizás nos pida activar algunas características avanzadas del sistema:*

*Ir a:*

*Panel de control --&gt; Programas --&gt; Programas y características --&gt; Activar o desactivar las características de Windows*

*En la lista que aparece activar &quot;Hyper-V&quot; y &quot;Contenedores&quot;, aceptar, reiniciar y ya debería funcionar el demonio de Docker.*

Una vez instalado el demonio de Docker en la máquina host, solo podemos lanzar contenedores si están basado en windows o en linux. Al parecer no se pueden lanzar a la vez contenedores de diferente sistema operativo.

[¿Cómo cambiar entre contenedores de windows y linux?](https://docs.docker.com/docker-for-windows/#switch-between-windows-and-linux-containers)

## **1. Conceptos**

- **Imagen:** Es un componente donde está nuestra aplicación o aplicaciones docker. Se pueden construir una nueva imagen con el comando &quot;docker build&quot; y un fichero Dockerfile. También se pueden descargar imágenes de la comunidad desde: &quot; [https://store.docker.com/](https://store.docker.com/)&quot;.
- **Contenedor:** Es una caja negra sobre la que se ejecuta una imagen o varias.
- **Tag:** Es un identificador que se asigna a una imagen
- **Volumen:** Es un identificador que monta un directorio del host dentro de la imagen docker. Sirve para persistencia de datos. Hay varias opciones, aquí se explica:
 [https://thenewstack.io/methods-dealing-container-storage/](https://thenewstack.io/methods-dealing-container-storage/)


## **2.** Comandos útiles (Demonio docker)

Desde el sistema host donde está corriendo el demonio de Docker se puede lanzar comandos que nos ayudan a construir imagenes, lanzar contenedores o ver el estado del demonio.

Alguno comandos útiles:

- Ver lista de imágenes

            docker images

- Ver lista de contenedores activos

            docker container ls

- Construir una imagen (Dentro del directorio donde este el Dockerfile)

            docker build -t <nombre_imagen> .

- Ponerle un tag a una imagen (docker tag image username/repository:tag)

            docker tag friendlyhello prueba:1.0

- Eliminar tag ó imagen

            docker rmi -f <repository>:<image_id>;

- Parar todos los contenedores

            docker stop $(docker ps -a -q)

- Eliminar todos los contenedores

            docker rm -f $(docker ps -a -q)

- Eliminar todas las imagenes

            docker rmi -f $(docker images -q)

- Lanzar imagen en background en un contenedor mapeando el puerto 4000 de la maquina local con el 80 del contenedor

            docker run -d -p 4000:80 <nombre_imagen>;

- Lanzar un contenedor  
 -it: Lanza el contenedor en modo interactivo  
 --rm: Elimina un contenedor anterior (si hubiese)  
 /bin/sh: Comando que se ejecutará cuando se lance el contenedor. (Sobreescribe al indicado en el CMD del Dockerfile)

            docker run -it --rm <nombre_imagen> /bin/sh

- Loguearse en oracle, para poder instalar weblogic

            docker login container-registry.oracle.com


## **3. Dockerfile**

Toda la info de la configuración en un dockerfile aquí:

[https://docs.docker.com/engine/reference/builder/](https://docs.docker.com/engine/reference/builder/)

El fichero Dockerfile es donde se indica como se va a construir una imagen. Algunos ejemplos:

- **App php corriendo en apache (linux)**
```dockerfile
# Descarga imagen de un apache con php7 ya dockerizado de la store de docker
FROM php:7.0-apache

# Persona de contacto (creador del Dockerfile)
MAINTAINER Pepito Palotes (esepepiton@gmail.com)

# Codificacion
ENV LANG C.UTF-8

# Copia todos los ficheros de la carpeta "app" a la ruta dentro de docker "/var/www/html/"
COPY app/ /var/www/html/
```

- **App php corriendo en wamp (windows)**
```dockerfile
# Descarga imagen de un wamp con php7 ya dockerizado de la store de docker
FROM nanoserver/wamp

# Persona de contacto (creador del Dockerfile)
MAINTAINER Pepito Palotes (esepepiton@gmail.com)

# Codificacion
ENV LANG C.UTF-8

# Ejecuta un comando windows, porque este docker está basado en nanoserver. Eliminar todo el directorio htdocs
RUN del /F /S /Q "C:/Apache24/htdocs/"

# Copia todos los ficheros de la carpeta "app/" a la ruta dentro de docker "C:/Apache24/htdocs/"
COPY ./resources/ C:/Apache24/htdocs/
```

- **Alpine (linux) + entorno (open-jdk, maven y nodejs)**
```dockerfile
# Imagen basada en Alpine Linux
FROM alpine:latest

# Codificacion
ENV LANG C.UTF-8

# Variables globales
ENV INSTALL_PATH /home/usuario

# Crear nuevo usuario
RUN adduser -D -u 1000 usuario

### Java
##################

# Setear variables de entorno
ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk \
         JRE_HOME=/usr/lib/jvm/java-1.8-openjdk/jre \
         PATH=$PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin \
         JAVA_VERSION=8u151 \
         JAVA_ALPINE_VERSION=8.151.12-r0

# Instalar java jdk y jre
RUN set -x && apk add --update --no-cache openjdk8="$JAVA_ALPINE_VERSION"

# Copiar certificados
COPY java/certificado/ $JRE_HOME/lib/security/

### Apache Maven
##################

# Setear variable de entorno
ENV MAVEN_VERSION 3.5.2-r0

# Instalar maven
RUN set -x && \
    apk add --update --no-cache maven="$MAVEN_VERSION" && \
    mkdir -p $INSTALL_PATH/data/apache-maven-repository

# Copiar ficheros de configuración
COPY maven/conf/ /usr/share/java/maven-3/conf/

### NodeJS
##################

# Setear variable de entorno
ENV NODEJS_VERSION 8.9.3-r0

# Instalar nodejs
RUN set -x && \
    apk add --update --no-cache nodejs-npm="$NODEJS_VERSION"

##################
#   Defaults
##################

# Setear el directorio por defecto al arrancar la imagen
WORKDIR $INSTALL_PATH

# Comando por defecto que se ejecuta al arrancar la imagen. Si se proporciona otro en el comando "docker run"
# se ejecutará este último en vez del indicado en la instrucción CMD
CMD ["/bin/sh"]
```

- **Windows (nanoserver) + entorno (open-jdk, maven y nodejs)**
```dockerfile
# Imagen basada en Windows Nanoserver
FROM microsoft/nanoserver:latest

# Codificacion
ENV LANG C.UTF-8

# Indicar que los comandos que se lanzan con RUN van sobre powershell
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Variables globales
ENV INSTALL_PATH C:/

##################
#   Aplicaciones
##################

### Java OpenJDK
##################

ENV JAVA_HOME $INSTALL_PATH/ojdkbuild

RUN $newPath = ('{0}\bin;{1}' -f $env:JAVA_HOME, $env:PATH); \
    Write-Host ('Updating PATH: {0}' -f $newPath); \
# Nano Server does not have "[Environment]::SetEnvironmentVariable()"
    setx /M PATH $newPath;

# https://github.com/ojdkbuild/ojdkbuild/releases
ENV JAVA_VERSION 8u161
ENV JAVA_OJDKBUILD_VERSION 1.8.0.161-1
ENV JAVA_OJDKBUILD_ZIP java-1.8.0-openjdk-1.8.0.161-1.b14.ojdkbuild.windows.x86_64.zip
ENV JAVA_OJDKBUILD_SHA256 7fcd9909173ed19f4ae6c0bba8b32b1e6bece2d49eb9d87271828be8121fc31b

RUN $url = ('https://github.com/ojdkbuild/ojdkbuild/releases/download/{0}/{1}' -f $env:JAVA_OJDKBUILD_VERSION, $env:JAVA_OJDKBUILD_ZIP); \
    Write-Host ('Descargando {0} ...' -f $url); \
    Invoke-WebRequest -Uri $url -OutFile 'ojdkbuild.zip'; \
    Write-Host ('Verificando sha256 ({0}) ...' -f $env:JAVA_OJDKBUILD_SHA256); \
    if ((Get-FileHash ojdkbuild.zip -Algorithm sha256).Hash -ne $env:JAVA_OJDKBUILD_SHA256) { \
      Write-Host 'ERROR!'; \
      exit 1; \
    }; \
    \
    Write-Host 'Descomprimiendo ...'; \
    Expand-Archive ojdkbuild.zip -DestinationPath $env:INSTALL_PATH; \
    \
    Write-Host 'Renombrando ...'; \
    Move-Item \
      -Path ('{0}\{1}' -f $env:INSTALL_PATH, ($env:JAVA_OJDKBUILD_ZIP -Replace '.zip$', '')) \
      -Destination $env:JAVA_HOME \
    ; \
    \
    Write-Host 'Verificando instalación ...'; \
    Write-Host '  java -version'; java -version; \
    Write-Host '  javac -version'; javac -version; \
    \
    Write-Host 'Eliminando ...'; \
    Remove-Item ojdkbuild.zip -Force; \
    \
    Write-Host 'Completado.';

# Copiar certificados
COPY ./java/certificado/ $JAVA_HOME/jre/lib/security/

### Apache Maven
##################

ENV MAVEN_VERSION 3.3.9
ENV M2_INSTALL_HOME $INSTALL_PATH

RUN $newPath = ('{0}/apache-maven-{1}/bin;{2}' -f $env:M2_INSTALL_HOME, $env:MAVEN_VERSION, $env:PATH); \
    Write-Host ('Actualizando PATH: {0}' -f $newPath); \
    # Nano Server does not have "[Environment]::SetEnvironmentVariable()"
    setx /M PATH $newPath; \
    setx /M M2_HOME ('{0}/apache-maven-{1}' -f $env:M2_INSTALL_HOME, $env:MAVEN_VERSION); \
    setx /M MAVEN_HOME ('{0}/apache-maven-{1}' -f $env:M2_INSTALL_HOME, $env:MAVEN_VERSION)

ENV MAVEN_ZIP $M2_INSTALL_HOME/maven-bin.zip

RUN $url = ('http://apache.rediris.es/maven/maven-3/{0}/binaries/apache-maven-{0}-bin.zip' -f $env:MAVEN_VERSION); \
    Write-Host ('Descargando {0} ...' -f $url); \
    Invoke-WebRequest -Uri $url -OutFile $env:MAVEN_ZIP; \
    \
    Write-Host 'Extrayendo ...'; \
    Expand-Archive $env:MAVEN_ZIP -DestinationPath $env:M2_INSTALL_HOME; \
    \
    Write-Host 'Verificando instalación ...'; \
    Write-Host '  mvn -v'; mvn -v; \
    \
    Write-Host 'Eliminando instalador ...'; \
    Remove-Item $env:MAVEN_ZIP -Force; \
    \
    Write-Host 'Completado.'

# Copiar ficheros de configuración
COPY ./maven/conf/ $M2_INSTALL_HOME/apache-maven-$MAVEN_VERSION/conf
COPY ./maven/apache-maven-repository/ $M2_INSTALL_HOME/apache-maven-repository/


### NodeJS
##################

ENV NODE_VERSION 8.9.4
ENV NODE_INSTALL_HOME $INSTALL_PATH
ENV NODE_HOME $INSTALL_PATH/node-v$NODE_VERSION-win-x64

RUN $newPath = ('{0};{1}' -f $env:NODE_HOME, $env:PATH); \
    Write-Host ('Actualizando PATH: {0}' -f $newPath); \
    # Nano Server does not have "[Environment]::SetEnvironmentVariable()"
    setx /M PATH $newPath

ENV NODE_ZIP $NODE_INSTALL_HOME/node-bin.zip

RUN $url = ('https://nodejs.org/dist/v{0}/node-v{0}-win-x64.zip' -f $env:NODE_VERSION); \
    Write-Host ('Descargando {0} ...' -f $url); \
    Invoke-WebRequest -Uri $url -OutFile $env:NODE_ZIP; \
    \
    Write-Host 'Extrayendo ...'; \
    Expand-Archive $env:NODE_ZIP -DestinationPath $env:NODE_INSTALL_HOME; \
    \
    Write-Host 'Verificando instalación ...'; \
    Write-Host '  node -v'; node -v; \
    \
    Write-Host 'Eliminando instalador ...'; \
    Remove-Item $env:NODE_ZIP -Force; \
    \
    Write-Host 'Completado.'

####################################
#   Preparación del entorno
####################################

# Creación de directorios
RUN mkdir -p $INSTALL_PATH/despliegues; \
    mkdir -p $INSTALL_PATH/coco; \
    mkdir -p $INSTALL_PATH/comandos

# Copiar ficheros
COPY ./weblogic/coco/ $INSTALL_PATH/coco/
COPY ./weblogic/Oracle/ $INSTALL_PATH/Oracle/
COPY ./comandos/ $INSTALL_PATH/comandos/

##################
#   Defaults
##################

# Setear el directorio por defecto al arrancar la imagen
WORKDIR $INSTALL_PATH

# Comando por defecto que se ejecuta al arrancar la imagen. Si se proporciona otro en el comando "docker run"

# se ejecutará este último en vez del indicado en la instrucción CMD
CMD ["powershell"]
```

## **4. docker-compose.yml**

Docker-compose es una aplicación que se instala junto con Docker que sirve para unificar el arranque de imagenes en un contenedor, compilar las imagenes (si no lo estaban antes).

Para más info: [https://docs.docker.com/compose/reference/overview/](https://docs.docker.com/compose/reference/overview/)

```dockerfile
version: '3.3';

services :
  myService:
    build: ./codigoDeMiServicio
    image: miservicio:1.4.2
    ports:
      - "8234:80";

  linux:
    build: ./milinux
    image: alpine:latest
    ports:
      - "27001:7001"
    volumes:
      - C:/SVN:C:/milinux/SVN
```