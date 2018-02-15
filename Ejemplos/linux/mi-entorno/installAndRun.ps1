$IMAGE = "mientorno-linux"
$VERSION = ":latest"

$existeImagen = docker images | Where-Object { $_ -like "*$($IMAGE)*" }
# Construir imagen "appPHP" si no existe ya..
if ([string]::IsNullOrEmpty($existeImagen)) { 
  docker build -t $IMAGE$VERSION .
}

# Lanzar contenedor con esta imagen
$existeContenedor = docker container ls --filter "status=running" | Where-Object { $_ -like "*$($IMAGE)*" }
if ([string]::IsNullOrEmpty($existeContenedor)) {
  docker run -it --name $IMAGE --rm $IMAGE$VERSION
} else {
  docker start $IMAGE
}


# Ojo cuidao: Al terminar de usar el contenedor habría que cerrarlo para que no se quede hasta el infinito y más allá
#docker stop $IMAGE