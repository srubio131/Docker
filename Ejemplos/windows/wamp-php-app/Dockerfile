# Windows wamp
FROM nanoserver/wamp

# Codificacion
ENV LANG C.UTF-8

# Eliminar todo el directorio htdocs
RUN del /F /S /Q "C:/Apache24/htdocs/"

# Copiar la churrera en el servidor
COPY ./myphpapp/ C:/Apache24/htdocs/
