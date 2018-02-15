# Imagen basada en Alpine Linux
FROM alpine:latest

MAINTAINER Pepiton (esepepi@gmail.com)

# Codificacion
ENV LANG C.UTF-8

# Variables globales
ENV INSTALL_PATH /home/miEntorno

# Crear nuevo usuario
RUN adduser -D -u 1000 miEntorno

##################
#   Aplications
##################

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
# Copiar mis certificados
COPY java/miCertificado/ $JRE_HOME/lib/security/

### Apache Maven
##################

# Setear variable de entorno
ENV MAVEN_VERSION 3.5.2-r0
# Instalar maven
RUN set -x && \
    apk add --update --no-cache maven="$MAVEN_VERSION" && \
    mkdir -p $INSTALL_PATH/apache-maven-repository
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