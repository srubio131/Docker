# Imagen basada en Windows Nanoserver
FROM microsoft/nanoserver:latest

MAINTAINER Pepito Palotes (esePepitoh@gmail.com)

# Codificacion
ENV LANG C.UTF-8

# Indicar que los comandos que se lanzan con RUN van sobre powershell
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Variables globales
ENV INSTALL_PATH C:/MiEntorno

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
COPY ./java/miCertificado/ $JAVA_HOME/jre/lib/security/

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

##################
#   Defaults
##################

# Setear el directorio por defecto al arrancar la imagen
WORKDIR $INSTALL_PATH

# Comando por defecto que se ejecuta al arrancar la imagen. Si se proporciona otro en el comando "docker run"
# se ejecutará este último en vez del indicado en la instrucción CMD
CMD ["powershell"]