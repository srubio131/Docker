## Molar�a que se hicieran comprobaciones, pero esto es un ejemplo de los comandos a utilizar desde un host linux

IMAGE = "firefox-linux"
VERSION = ":latest"

docker build -t $IMAGE$VERSION .

docker run -ti --rm \
           -e DISPLAY=$DISPLAY \
           -v /tmp/.X11-unix:/tm/.X11-unix \
           --name $IMAGE \
           $IMAGE$VERSION

# Ojo cuidao: Al terminar e usar el contenedor habr�a que cerrarlo para que no se quede hasta el infinito y m�s all�
#docker stop $IMAGE