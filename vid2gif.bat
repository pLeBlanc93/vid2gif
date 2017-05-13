@ECHO off
REM since GIFs can only use 256 colors, ffmpeg analyzes the image to determine the best 256 colors to use
REM an output palette image is created in memory and passed to a separate ffmpeg process during conversion
REM see http://blog.pkh.me/p/21-high-quality-gif-with-ffmpeg.html
Setlocal EnableDelayedExpansion

REM default values
SET s=0
SET e=9999
REM set to 1 to prompt for start/end time of video.. by default, convert entire file
IF 0 == 1 (
    SET /p s="Enter start time in seconds s.S (default is start of video)"
    SET /p e="Enter end time in seconds s.S (default is end of video)"
)

.\bin\ffmpeg.exe -y -i "%~1" -vf fps=20,scale=iw:-1:flags=lanczos,palettegen -f image2pipe -vcodec png - | ^
.\bin\ffmpeg.exe -y -i "%~1" -i - -ss !s! -to !e! -filter_complex "fps=20,scale=iw:-1:flags=lanczos[x];[x][1:v]paletteuse" "%~n1.gif"
PAUSE