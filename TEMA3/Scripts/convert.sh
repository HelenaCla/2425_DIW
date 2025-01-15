#!/usr/bin/env bash

# Ajusta estos parámetros a tu gusto
BITRATE_LOW_MP3="128k"
BITRATE_HIGH_MP3="320k"
QUALITY_LOW_OGG=4
QUALITY_HIGH_OGG=8

# Si le pasas una carpeta al script, irá allí; si no, trabaja en la carpeta actual
cd "${1:-.}"

# Recorre todos los archivos .wav que haya en la carpeta
for wavFile in *.wav; do
    if [[ -f "$wavFile" ]]; then
        # Quitamos la extensión .wav para usarlo de "base"
        baseName="${wavFile%.wav}"

        echo "Convirtiendo: $wavFile"

        # Versión MP3 (bitrate bajo)
        ffmpeg -i "$wavFile" -vn -ar 44100 -ac 2 -b:a "$BITRATE_LOW_MP3" "${baseName}_low.mp3"

        # Versión MP3 (bitrate alto)
        ffmpeg -i "$wavFile" -vn -ar 44100 -ac 2 -b:a "$BITRATE_HIGH_MP3" "${baseName}_high.mp3"

        # Versión OGG (calidad baja)
        ffmpeg -i "$wavFile" -vn -ar 44100 -ac 2 -qscale:a "$QUALITY_LOW_OGG" "${baseName}_low.ogg"

        # Versión OGG (calidad alta)
        ffmpeg -i "$wavFile" -vn -ar 44100 -ac 2 -qscale:a "$QUALITY_HIGH_OGG" "${baseName}_high.ogg"

        echo "¡Listo! Archivos generados: ${baseName}_low.mp3, ${baseName}_high.mp3, ${baseName}_low.ogg, ${baseName}_high.ogg"
        echo "-----------------------------------"
    fi
done
