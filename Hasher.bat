:: Hasher V0.1
:: Concurrent file hash dumper. 
:: TODO:
::  - Automate duplicate file review
::  - Fix handling of files cont. nonstandard characters (" ","&", etc.)

@SETLOCAL EnableExtensions EnableDelayedExpansion
@SET "TargetDirectory=%1" & SET "OutputFile=%2" & SET "OutputFileInternal=%~dpnx2" & SET "DebugLevel=%3" & SET LogFile="%~dp0Hasher.log"
@IF NOT DEFINED DebugLevel SET DebugLevel=0
@IF DebugLevel NEQ 2 ECHO OFF

:: Check if required components are there and load paths to memory
FOR /F "tokens=* USEBACKQ" %%C IN (`"WHERE cmd.exe"`) DO (SET "CMDPath=%%C") & IF NOT DEFINED CMDPath ECHO No CMD or unable to locate CMD in PATH (How have you managed this?). Exiting. & EXIT /B 1
FOR /F "tokens=* USEBACKQ" %%C IN (`"WHERE certutil.exe"`) DO (SET "CertUtilPath=%%C") & IF NOT DEFINED CertUtilPath ECHO No CertUtil or unable to locate CertUtil in PATH. Exiting. & EXIT /B 1

:: Is help needed
IF %1=="--h" GOTO :help
IF NOT %1=="" GOTO :setup
ECHO;
ECHO Usage: %~n0 [path to dir] [output] [debug]
ECHO;
ECHO E.g. %~n0 "C:\cutegirls\nodoka"
ECHO %~n0 "C:\cutegirls\nodoka" HashOutput.txt 1
ECHO;
ECHO For more help, try %~n0 --h
GOTO :eof

:main
PUSHD %TargetDirectory%
IF EXIST tmp\ RMDIR /Q /S tmp\
MKDIR tmp\
CALL :enum

FOR /L %%i IN (1,1,%FileAmt%) DO CALL :hashloop %%i
%HL%
SET Timer=%TIME%
%Debug1% ECHO [%Timer%] Hashing done. Waiting 5 seconds. >> %LogFile%
ECHO [%Timer%] Hashing complete. Waiting for remaining processes.
TIMEOUT /T 5 /nobreak
SET Timer=%TIME%
ECHO [%Timer%] Cleaning up...
PUSHD %TargetDirectory%\tmp
FOR /F "delims=" %%f IN ('dir /a:-d /b') DO (TYPE "%%f" >> %ListFile%)
PUSHD %TargetDirectory%
IF %DebugLevel% EQU 0 RMDIR /Q /S tmp\
SET Timer=%TIME%
%Debug1% ECHO [%Timer%] Cleanup done.>> %LogFile%
ECHO [%Timer%] Output available at %OutputFile%
ECHO Exiting.

GOTO :eof

:: -------------------------
:: Functions below this line

:setup - Set up variables, paths & aliases
	IF NOT DEFINED OutputFile SET OutputFile=HasherOutput.txt & SET "OutputFileInternal=%~dp0HasherOutput.txt"
	IF EXIST %LogFile% DEL %LogFile%
	SET ListFile=!RANDOM!.tmp
	SET TmpFile2=!RANDOM!.tmp
	SET "Debug1=IF %DebugLevel% GEQ 1"
	SET "HL=%Debug1% ECHO ************************************ >>%LogFile% "
	SET FileAmt=0
	SET CurrentLineNum=0
	
	GOTO :main

:enum - Check file amt & build filename array
	SET Timer=%TIME%
	ECHO [%Timer%] Enumerating files.
	FOR /F "delims=" %%f IN ('dir /a:-d /b') DO (
		SET /a "FileAmt+=1"
		SET "FileName[!FileAmt!]=%%~ff"
	)
	SET Timer=%TIME%
	ECHO [%Timer%] %FileAmt% files found.
	%Debug1% CALL :printer
	
	GOTO :eof

:printer - Log array elements (debug)
	ECHO [%Timer%] Enumeration successful! >> %LogFile%
	ECHO CMD path: "%CMDPath%" >> %LogFile%
	ECHO CertUtil path: "%CertUtilPath%" >> %LogFile%
	ECHO Printing file array: >> %LogFile%
	%HL%
	FOR /L %%i IN (1,1,%FileAmt%) DO (
		( 
		ECHO( [%%i] "!FileName[%%i]!"
		)>> %LogFile%
	)
	%HL%
	ECHO Starting hashing loop. >> %LogFile%
	
	GOTO :eof
	
:hashloop - Define tmpfile, pull filename from array, push hash of filename into tmpfile
	SET /A CurrentLineNum+=1
	SET TmpFile=hash-%RANDOM%-%TIME:~6,5%.hashtmp
	%CMDPath% /Q /C "FOR /F "skip=1delims=" %%B IN ('"%CertUtilPath% -hashfile "!FileName[%CurrentLineNum%]!" MD5 ^| findstr /V /R /C:"CertUtil""') DO ECHO %%B	!FileName[%CurrentLineNum%]! >> tmp\%TmpFile%"
	
	GOTO :eof
	
:help - Prints assorted info
	ECHO;
	ECHO Hasher v0.1
	ECHO Prints all MD5 hashes of files in directory into file.
	ECHO;
	ECHO Usage:
	ECHO %~n0 [full path to directory] [output file name (OPT)] [debug level (OPT)]
	ECHO;
	ECHO Example:
	ECHO %~n0 "C:\cutegirls\nodoka"
	ECHO %~n0 "C:\cutegirls\nodoka" HashOutput.txt 1
	ECHO;
	ECHO Output name MUST be manually specified if enabling debug.
	ECHO Output supports full path if desired.
	ECHO;
	ECHO Available debug levels: 1 - normal, 2 - turns on ECHO (use with redirection)
	ECHO Modes higher than 1 preserve temp files
	ECHO Logs currently print to %LogFile%
	ECHO (this is relative to batch file location)
	ECHO;
	ECHO If you're getting errors with Japanese filenames
	ECHO make sure batch is saved in ANSI mode.
	
	GOTO :eof