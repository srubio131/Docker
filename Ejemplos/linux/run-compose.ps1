# Construye las imágenes del docker-compose.yml (si no estaban ya contruidas), ejecuta el contenedor "mientorno".
# Cuando se salga del contenedor "mientorno" se parara el contenedor para que no se quede hasta el infinito
docker-compose up -d ; docker-compose run mientorno ; docker-compose stop