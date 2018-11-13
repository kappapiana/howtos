Impostare la variabile di sistema

    FILE=[nomefile]

Estrarre  mp3 da pulire

    ffmpeg -i "${FILE}" -vn -ab 128k -ar 44100 -y "temp_${FILE%.webm}.mp3";

Elaborare il suono (es con Audacity:
    - import
    - Selezionare un'area di silenzio
    - effect ‒ noise reduction
    - Get noise profile
    - Selezionare tutto
    - effect ‒ noise reduction
    - export

Estrarre file webm senza suono

    ffmpeg -i "${FILE}" -c copy -an temp_"${FILE%.webm}"-nosound.webm;

Convertire in video

    ffmpeg -i temp_"${FILE%.webm}"-nosound.webm -c:v libx264 temp_video.mp4;

Unire

    ffmpeg -i temp_video.mp4 -i "temp_${FILE%.webm}.mp3" -c:v copy -c:a copy clean${FILE%.webm}.mp4;

Cancellare

    rm temp_*
