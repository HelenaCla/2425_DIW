#!/usr/bin/env bash
#
# Ejemplo de script Bash que muestra un menú con 5 opciones
# para procesar un archivo de audio con ffmpeg.

# Si no indicas archivo al llamar al script,
# te pedirá que lo ingreses después.
input_file="$1"

# Si no se proporcionó un archivo por parámetro, pedimos uno al usuario.
if [ -z "$input_file" ]; then
  read -rp "Ingresa la ruta del archivo de audio de entrada: " input_file
fi

# Comprobamos que el archivo existe
if [ ! -f "$input_file" ]; then
  echo "El archivo '$input_file' no existe. Saliendo..."
  exit 1
fi

# Obtenemos el nombre base del archivo (sin extensión)
# y la extensión original
base_name="${input_file%.*}"
ext="${input_file##*.}"

# Mostramos el menú
echo "========================================="
echo "       MENÚ DE OPERACIONES DE AUDIO"
echo "========================================="
echo "1) Convertir a MP3 (bitrate 192k)"
echo "2) Convertir a OGG (calidad 5)"
echo "3) Aumentar volumen en +5 dB"
echo "4) Acelerar el audio (speed 1.25x)"
echo "5) Recortar los primeros 10 segundos"
echo "-----------------------------------------"
read -rp "Elige una opción [1-5]: " opcion

# Creamos una salida base para los archivos resultantes
output_file=""

case "$opcion" in
  1)
    # 1) Convertir a MP3 (bitrate 192k)
    output_file="${base_name}_out.mp3"
    ffmpeg -i "$input_file" -vn -ar 44100 -ac 2 -b:a 192k "$output_file"
    echo "Archivo convertido a MP3 => $output_file"
    ;;
  2)
    # 2) Convertir a OGG (calidad 5)
    output_file="${base_name}_out.ogg"
    ffmpeg -i "$input_file" -vn -ar 44100 -ac 2 -qscale:a 5 "$output_file"
    echo "Archivo convertido a OGG => $output_file"
    ;;
  3)
    # 3) Aumentar volumen en +5 dB
    #   ffmpeg usa filtros de audio, en este caso 'volume=5dB'
    output_file="${base_name}_volplus5dB.${ext}"
    ffmpeg -i "$input_file" -af "volume=5dB" "$output_file"
    echo "Volumen aumentado +5 dB => $output_file"
    ;;
  4)
    # 4) Acelerar el audio (speed 1.25x)
    #    Usamos el filtro 'atempo', que permite cambiar la velocidad.
    #    atempo 1.25 => 25% más rápido
    output_file="${base_name}_faster.${ext}"
    ffmpeg -i "$input_file" -filter:a "atempo=1.25" "$output_file"
    echo "Audio acelerado (1.25x) => $output_file"
    ;;
  5)
    # 5) Recortar los primeros 10 segundos
    #    Para saltarnos los 10 primeros segundos se usa '-ss 10'
    #    y copiamos el resto.
    output_file="${base_name}_skip10s.${ext}"
    ffmpeg -ss 10 -i "$input_file" -c copy "$output_file"
    echo "Se han recortado los primeros 10 seg => $output_file"
    ;;
  *)
    echo "Opción no válida. Saliendo..."
    exit 1
    ;;
esac

echo "-----------------------------------------"
echo "¡Operación finalizada!"
echo "-----------------------------------------"
