::Random filename picker.
::Outputs random filename in current directory to clipboard.
::For use with renamer.bat.
::24-04-20
@echo off
SET ListFile=!RANDOM!.tmp
FOR /F "tokens=*" %%A IN ('DIR /A:-D /B') DO (ECHO %%A >> %ListFile%)
FOR /F %%C IN ('^< "%ListFile%" find /C /V ""') DO SET "COUNT=%%C"
SET /A "NUMBER=%RANDOM%%%%COUNT%"
IF %NUMBER% gtr 0 (set "SKIP=skip=%NUMBER%") ELSE (set "SKIP=")
FOR /F usebackq^ %SKIP:skip=skip^%^ delims^=^ eol^= %%L IN ("%ListFile%") DO (
    ECHO(%%L | clip 
    GOTO :NEXT
)
:NEXT
DEL %ListFile%