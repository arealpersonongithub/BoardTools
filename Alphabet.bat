:: Alphabet V0.1a
:: String to APNG converter. 
:: FONT LIBRARY SPECIFICATION:
:: Needs A-Z and blank files (optional: 0-9, special; modify :loop accordingly)
:: Library extension needs to be set manually (line 28)
:: For a general understanding on how to produce a library, see :installScript. 
:: OUTPUT:
:: By default, output is to APNG. If you have better luck using h/vstack while preserving transparancy
:: (or don't care for transparency) edit the FFmpeg command manually to process to GIF.
:: TODO:
:: - Paragraph mode [break string into substrings of n chars, process substrings, vstack substrings]
:: - Menu [set persistent ext var, allow string review before processing, paragraph mode setup]
:: - Allow for multiple libraries to be stored in Alphabet\

@ECHO OFF
SETLOCAL EnableExtensions EnableDelayedExpansion
:: SET FLAGS=%1
:: IF NOT DEFINED FLAGS GOTO :help CONTENT=%2
IF NOT EXIST Alphabet (
	ECHO Font library missing. Run install script?
	CHOICE
	IF ERRORLEVEL 2 ECHO Exiting. & EXIT /B 0
	IF ERRORLEVEL 1 GOTO installScript
	ECHO Something went wrong. & EXIT /B
	)
FOR /F "tokens=* USEBACKQ" %%A IN (`"WHERE ffmpeg"`) DO (SET "ffmpegPath=%%A")
IF NOT DEFINED ffmpegPath ECHO(Script requires FFmpeg to be installed and in PATH. ) & EXIT /B 1
SET EXT=gif
SET COUNTER=0
SET outputString= 

ECHO Please enter content to be alphabetized. 
ECHO Only A-Z and spaces are allowed at this time.
SET /P inputString=
ECHO Set output filename.
SET /P fileOut=
CALL :strLen "%inputString%" strLength
SET /A strCheck=strLength+1


:loop - Parse each character in the string into a _temp variable
:: If variable is a special char, replace it with a predefined filename
:: Then prefix each _temp with -i and .gif and append to an output variable
:: TODO: Find a way that doesn't rely on a thousand IF checks per character

IF DEFINED inputString (
	IF %counter% EQU %strCheck% GOTO :endloop
	SET /A counter+=1
    SET _temp%counter%=!inputString:~%counter%,1!
	IF "!_temp%counter%!"==" " (SET _temp%counter%=blank)
	IF "!_temp%counter%!"=="^" (SET _temp%counter%=halfblank)
	IF "!_temp%counter%!"=="!" (SET _temp%counter%=exclaim)
	IF "!_temp%counter%!"=="@" (SET _temp%counter%=at)
	IF "!_temp%counter%!"=="?" (SET _temp%counter%=question)
	IF "!_temp%counter%!"=="$" (SET _temp%counter%=dollar)
	SET passVar=-i !_temp%counter%!.%ext% 
	SET outputString=%outputString%%passVar%
	
    GOTO loop
)

:endloop
PUSHD Alphabet\
ffmpeg -hide_banner -v warning %outputString% -plays 0 -filter_complex hstack=inputs=%strLength% ..\%fileOut%.apng
ECHO File created successfully. Exiting.

EXIT /B 0

:strLen [courtesy of https://ss64.com/nt/syntax-strlen.html]
Set "s=#%~1"
Set "len=0"
For %%N in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
  if "!s:~%%N,1!" neq "" (
    set /a "len+=%%N"
    set "s=!s:~%%N!"
  )
)
If "%~2" neq "" (set %~2=%len%) else echo %len%
goto :eof

:: :help - Prints assorted info | TODO

:installScript - DLs basic library, processes w/ gifsicle, sets up directories
:: Basic principle: Find yourself a font. Doublecheck that the HEIGHT is consistent across all font files (width is OK, FFmpeg freaks out w/ inconsistent heights)
:: Heavy certutil abuse. Might trigger AVs? If it doesn't, get a better AV honestly
ECHO;
ECHO Downloading sample image set.
ECHO This may take a second.
mkdir Alphabet & PUSHD Alphabet\

:: Download the sample image set
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-a-25-tr-real-y.gif" a.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-b-25-tr-real0-y.gif" b.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-c-25-tr-real-y.gif" c.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-d-25-tr-real-y.gif" d.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-e-25-tr-real-y.gif" e.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-f-25-trans-y.gif" f.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-g-25-tr-real-y.gif" g.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-h-25-tr-real-y.gif" h.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-i-25-tr-real-y.gif" i.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-j-25-trans-y.gif" j.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-k-25-tr-real-y.gif" k.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-l-25-tr-real-y.gif" l.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-M-25-trans-0-y.gif" m.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-n-25-tr-real-y.gif" n.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-o-25-tr-real-y.gif" o.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/ARG-p-25-tr0ans-y.gif" p.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-q-25-4frame-trans-y.gif" q.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-r-25-trans-y.gif" r.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-s-25-tr-real-y.gif" s.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-t-25-tr-real-y.gif" t.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-u-25-tr-rea0l-y.gif" u.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-v-25-trans-y.gif" v.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-w-25-trans-y.gif" w.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-x-25-trans-y.gif" x.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-y-25-tr-real-y.gif" y.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-z-25-trans-y.gif" z.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-0-25-trans-y.gif" 0.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-1-25-trans-y.gif" 1.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-2-25-trans-y.gif" 2.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-3-25-trans-y.gif" 3.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-4-25-trans-y.gif" 4.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-5-25-trans-y.gif" 5.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-6-25-trans-y.gif" 6.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-7-25-trans-y.gif" 7.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-8-25-trans-y.gif" 8.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-9-25-trans-y.gif" 9.gif >nul
certutil -urlcache -split -f "https://www.artiestick.com/toons/alphabet/ralph/yellow/25_p/arg-exclaim-25-tr-real-y.gif" exclaim.gif >nul

:: Download Gifsicle
:: 32bit Gifsicle crashes harder than a firebomb onto Dresden.
:: So we'll grab the 16bit port and hope for the best

ECHO Sample files downloaded. Processing images now.

REG Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT
IF %OS%==32BIT GOTO :32bitDL
IF %OS%==64BIT GOTO :64bitDL
ECHO Unable to determine OS bitness, defaulting to 32bit download! & GOTO :32bitDL

:32bitDL
certutil -urlcache -split -f "http://www.bttr-software.de/ports/gifs192b.zip" gifsicle.zip >nul
GOTO afterDL

:64bitDL
certutil -urlcache -split -f "https://eternallybored.org/misc/gifsicle/releases/gifsicle-1.92-win64.zip" gifsicle.zip >nul
GOTO afterDL

:afterDL
:: Drop a VBS helperscript to unzip Gifsicle
ECHO(Set fso = CreateObject("Scripting.FileSystemObject"):Set objShell = CreateObject("Shell.Application"):Set FilesInZip=objShell.NameSpace("%cd%\gifsicle.zip").items:objShell.NameSpace("%cd%").CopyHere(FilesInZip):Set fso = Nothing:Set objShell = Nothing>helpscript.vbs
cscript //B helpscript.vbs

IF %OS%==32BIT COPY gifs192b\gifsicle.exe gifsicle.exe >nul
IF %OS%==64BIT COPY gifsicle-1.92\gifsicle.exe gifsicle.exe >nul

:: Resize the images to a common height. Here manually set to 80px.
:: Flattens the delays to make for a smoother alphabetizing experience.
gifsicle.exe -b --unoptimize --resize-height 80 -d 20 --resize-method lanczos3 *.gif

:: Download transparent seed file
certutil -urlcache -split -f "https://upload.wikimedia.org/wikipedia/commons/c/ce/Transparent.gif" seed.gif >nul

:: Process seed file into space and halfspace files
gifsicle.exe --resize 20x80 seed.gif > halfblank.gif
gifsicle.exe --resize 40x80 seed.gif > blank.gif

:: Cleanup 
DEL helpscript.vbs & DEL Blob0_0.key & DEL gifsicle.zip & DEL seed.gif

:: Done!
ECHO;
ECHO Setup complete: exiting.
GOTO :EOF
