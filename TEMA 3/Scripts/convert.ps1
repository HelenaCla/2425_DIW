Param(
    [string]$InputFolder = ".",
    [string]$BitrateLowMP3 = "128k",
    [string]$BitrateHighMP3 = "320k",
    [int]$QualityLowOgg = 4,
    [int]$QualityHighOgg = 8
)

# Cambia al directorio indicado
Set-Location $InputFolder

# Obtiene todos los archivos .wav en el directorio
Get-ChildItem -Path . -Filter *.wav | ForEach-Object {
    $wavFile = $_.FullName
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($wavFile)

    # Versión MP3 con Bitrate Bajo
    $mp3LowOutput = "$($baseName)_low.mp3"
    ffmpeg -i $wavFile -vn -ar 44100 -ac 2 -b:a $BitrateLowMP3 $mp3LowOutput

    # Versión MP3 con Bitrate Alto
    $mp3HighOutput = "$($baseName)_high.mp3"
    ffmpeg -i $wavFile -vn -ar 44100 -ac 2 -b:a $BitrateHighMP3 $mp3HighOutput

    # Versión OGG con calidad baja
    $oggLowOutput = "$($baseName)_low.ogg"
    ffmpeg -i $wavFile -vn -ar 44100 -ac 2 -qscale:a $QualityLowOgg $oggLowOutput

    # Versión OGG con calidad alta
    $oggHighOutput = "$($baseName)_high.ogg"
    ffmpeg -i $wavFile -vn -ar 44100 -ac 2 -qscale:a $QualityHighOgg $oggHighOutput
}
