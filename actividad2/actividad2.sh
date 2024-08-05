#!/bin/bash


# Leer la variable GITHUB_USER
echo "Ingrese el nombre de usuario de GitHub:" # echo -> encausador de info, acá la salida es la impresion en consola, pero podemos cambiarlo
read GITHUB_USER # read -> lee la entrada del usuario y la guarda en la variable GITHUB_USER


# Consultar la URL y obtener los datos del usuario
# curl -s: -s es para ejecutar curl en modo silencioso.
# el símbolo $ se usa para acceder al valor de una variable.
USER_DATA=$(curl -s "https://api.github.com/users/$GITHUB_USER") # Usa curl para hacer una solicitud a la API de GitHub y guarda la respuesta JSON en USER_DATA


# Validar si la consulta fue exitosa

if [[ $? -ne 0 || $(echo $USER_DATA | jq -r .message) == "Not Found" ]]; then
   
    # $? -ne 0 -> Verifica si el comando curl falló
        # $? es una variable especial en Bash que contiene el código de salida del último comando ejecutado. Un código de salida de 0 indica éxito, mientras que cualquier otro valor indica un error.
        # -ne significa "not equal" (no igual)
        # Entonces, if [[ $? -ne 0 ]] significa "si el último comando no se ejecutó exitosamente".
 
    # $(echo $USER_DATA | jq -r .message) == "Not Found" ->  Verifica si la respuesta JSON contiene un mensaje "Not Found", lo que indicaría que el usuario no existe.
        # echo ( $USER_DATA | jq -r .message ) viendolo como funciones, el echo se aplica sobre el resultado del pipe
        # $(...) es una sustitución de comando que ejecuta el comando dentro de los paréntesis y reemplaza la expresión completa con su salida.
        # echo $USER_DATA imprime el contenido de USER_DATA.
        # | es un pipe que redirige la salida de echo al comando jq.
        # jq -r .message es un comando que procesa el JSON contenido en USER_DATA y extrae el valor del campo message.
        # or defecto, jq imprime los valores de las cadenas entre comillas. La opción -r elimina estas comillas y proporciona la salida en bruto
        # == "Not Found" compara el resultado con la cadena "Not Found".
   
    # || es un operador lógico OR, que significa que si cualquiera de las dos condiciones es verdadera, el bloque if se ejecutará.
 
echo "Error: No se pudo obtener datos del usuario $GITHUB_USER"  #Imprime un mensaje de error indicando que no se pudieron obtener los datos del usuario de GitHub
  # Termina el script inmediatamente con un código de salida 1, que generalmente indica que hubo un error.
  exit 1
fi


# Extraer datos del JSON
USER_ID=$(echo $USER_DATA | jq -r '.id') # Extrae el campo 'id' del JSON y lo guarda en USER_ID
CREATED_AT=$(echo $USER_DATA | jq -r '.created_at') # Extrae el campo 'created_at' del JSON y lo guarda en CREATED_AT


# Imprimir el mensaje
echo "Hola $GITHUB_USER. User ID: $USER_ID. Cuenta fue creada el: $CREATED_AT." # Imprime el mensaje con los datos extraídos

# Obtener la fecha actual
CURRENT_DATE=$(date +%Y-%m-%d) # Obtiene la fecha actual en formato YYYY-MM-DD y la guarda en CURRENT_DATE

# Crear el directorio de logs
LOG_DIR="/tmp/$CURRENT_DATE" # Define la ruta del directorio de logs usando la fecha actual
mkdir -p $LOG_DIR # Crea el directorio de logs, -p asegura que todos los directorios padres necesarios sean creados

# Crear el archivo de log
LOG_FILE="$LOG_DIR/saludos.log" # Define la ruta del archivo de log
echo "Hola $GITHUB_USER. User ID: $USER_ID. Cuenta fue creada el: $CREATED_AT." >> $LOG_FILE # Añade el mensaje al archivo de log


# Crear el cronjob
#(crontab -l 2>/dev/null; echo "*/5 * * * * /path/to/your/script.sh") | crontab -