:: Alphabet V0.1
:: String to APNG converter. 
:: FONT LIBRARY SPECIFICATION:
:: For each character desired, provide a file [char].[ext] in directory Alphabet relative to batch location.
:: For spaces, provide a blank character blank.[ext]
:: Library extension needs to be set manually (line 22)
:: OUTPUT:
:: By default, output is to APNG. If you have better luck using h/vstack while preserving transparancy
:: (or don't care for transparency) edit the FFmpeg command manually to process to GIF.
:: SAMPLE INPUT:
:: Sample GIF alphabet available at https://www.artiestick.com/credits.htm (manual DL required)
:: Any alphabet will do, but for usability purposes files no bigger than 75x75px are recommended
:: TODO:
:: - Paragraph mode [break string into substrings of n chars, process substrings, vstack substrings]
:: - Menu [set persistent ext var, allow string review before processing, paragraph mode setup]

@ECHO OFF
SETLOCAL EnableExtensions EnableDelayedExpansion
IF NOT EXIST Alphabet ECHO(Script requires Alphabet animation library to be present in Alphabet directory.) & EXIT /B 1
FOR /F "tokens=* USEBACKQ" %%A IN (`"WHERE ffmpeg"`) DO (SET "ffmpegPath=%%A")
IF NOT DEFINED ffmpegPath ECHO(Script requires FFmpeg to be installed and in PATH. ) & EXIT /B 1
SET EXT=gif
SET COUNTER=0
SET outputString= 

::Get user generated string
ECHO Please enter content to be alphabetized. 
ECHO Only A-Z and spaces are allowed at this time.
SET /P inputString=
ECHO Set output filename.
SET /P fileOut=
CALL :strLen "%inputString%" strLength
SET /A strCheck=strLength+1

::Parse each character in the string into a _temp variable
::Then prefix each _temp with -i and .gif and append to an output variable
::Finally replace spaces with blank
:loop
IF DEFINED inputString (
	IF %counter% EQU %strCheck% GOTO :endloop
	SET /A counter+=1
    SET _temp%counter%=!inputString:~%counter%,1!
	IF "!_temp%counter%!"==" " (SET _temp%counter%=blank)
	SET passVar=-i !_temp%counter%!.%ext% 
	SET outputString=%outputString%%passVar%
    goto loop
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