$existeImagen = docker images | Where-Object {$_ -like "appPHP*"}
# Construir imagen "appPHP" si no existe ya..
if ([string]::IsNullOrEmpty($existeImagen)) { 
  docker build -t myphpapp:latest .
} 
docker run -d --rm myphpapp:latest ;

# Cerrar el contenedor docker para que no se quede hasta el infinito y más allá
"Parando el contenedor docker" ;
docker stop myphpapp:latest