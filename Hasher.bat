::Hasher V0.1
::Concurrent file hash dumper. 
::TODO:
:: - Automate duplicate file review
:: - Fix handling of files cont. nonstandard characters (" ","&", etc.)
:: - Fix certutil parser (have it remove last line w/o calling cleanup later)
:: - General cleanup (file is messy)
::29-04-20. 

@SETLOCAL EnableExtensions EnableDelayedExpansion
@SET "TargetDirectory=%1" & SET "OutputFile=%2" & SET "OutputFileInternal=%~dpnx2" & SET "DebugLevel=%3" & SET LogFile="%~dp0Hasher.log"
@IF NOT DEFINED DebugLevel SET DebugLevel=0
@IF DebugLevel NEQ 2 ECHO OFF
IF NOT DEFINED TargetDirectory GOTO :syntaxisfucked
IF %TargetDirectory%==--h GOTO :help
IF NOT DEFINED OutputFile SET OutputFile=HasherOutput.txt & SET "OutputFileInternal=%~dp0HasherOutput.txt"
IF EXIST %LogFile% DEL %LogFile%
SET ListFile=!RANDOM!.tmp
PUSHD %TargetDirectory%

IF EXIST tmp\ RMDIR /Q /S tmp\
MKDIR tmp\
SET FileAmt=0
SET CurrentLineNum=0

SET "Debug1=IF %DebugLevel% GEQ 1"
FOR /F "tokens=* USEBACKQ" %%C IN (`"WHERE cmd.exe"`) DO (SET "CMDPath=%%C")
FOR /F "tokens=* USEBACKQ" %%C IN (`"WHERE certutil.exe"`) DO (SET "CertUtilPath=%%C")
IF NOT DEFINED CMDPath GOTO :nocmd
IF NOT DEFINED CertUtilPath GOTO :nocertutil
SET "HL=%Debug1% ECHO ************************************ >>%LogFile% "

CALL :enum
%Debug1% CALL :printer

::Main controller
FOR /L %%i IN (1,1,%FileAmt%) DO CALL :loop %%i
GOTO :cleanup

::Check file amt & build filename array
:enum
	SET Timer=%TIME%
	ECHO [%Timer%] Enumerating files.
	FOR /F "delims=" %%f IN ('dir /a:-d /b') DO (
		SET /a "FileAmt+=1"
		SET "FileName[!FileAmt!]=%%~ff"
	)
	SET Timer=%TIME%
	ECHO [%Timer%] %FileAmt% files found.
	GOTO :eof

::Log array elements (debug)
:printer
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
	ECHO Starting main hashing loop: >> %LogFile%
	GOTO :eof

::Supplementary logging
:logloop
	ECHO Processing %CurrentFile% into tempfile %TmpFile%>> %LogFile%
	GOTO :eof
	
::Define tmpfile, pull filename from array, push hash of filename into tmpfile
:loop
	SET /A CurrentLineNum+=1
	SET TmpFile=hash-%RANDOM%-%TIME:~6,5%.hashtmp
	FOR /F "tokens=* USEBACKQ" %%C IN (`ECHO "!FileName[%CurrentLineNum%]!"`) DO (SET "CurrentFile=%%C")
	%Debug1% CALL :logloop 
	%CMDPath% /Q /C "FOR /F "skip=1delims=" %%B IN ('"%CertUtilPath% -hashfile %CurrentFile% MD5"') DO ECHO %%B	%CurrentFile% >> tmp\%TmpFile%"
	GOTO :eof

:cleanup
	%HL%
	SET Timer=%TIME%
	%Debug1% ECHO [%Timer%] Hashing done. >> %LogFile%
	ECHO [%Timer%] Hashing complete. Waiting for remaining processes.
	TIMEOUT /T 5 /nobreak
	SET Timer=%TIME%
	ECHO [%Timer%] Cleaning up...
	PUSHD %TargetDirectory%\tmp
	FOR /F "delims=" %%f IN ('dir /a:-d /b') DO (TYPE "%%f" >> "%ListFile%")
	find /i /v "certutil" < "%ListFile%" | sort > "%OutputFileInternal%"
	PUSHD %TargetDirectory%
	IF %DebugLevel% EQU 0 RMDIR /Q /S tmp\
	SET Timer=%TIME%
	%Debug1% ECHO [%Timer%] Cleanup done.>> %LogFile%
	ECHO [%Timer%] Output available at %OutputFile%
	Echo Exiting.
	EXIT /B 0

:nocmd
ECHO No CMD or unable to locate CMD in PATH (How have you managed this?). Exiting.
EXIT /B

:nocertutil
ECHO No CertUtil or unable to locate CertUtil in PATH. Exiting.
EXIT /B

:syntaxisfucked
ECHO Usage: %0 [full path to directory] [output file name (OPT)] [debug level (OPT)]
ECHO For detailed help, try %0 --h
EXIT /B	

:help
ECHO Hasher v0.1
ECHO Prints all MD5 hashes of files in directory into file.
ECHO;
ECHO Usage:
ECHO %0 [full path to directory] [output file name (OPT)] [debug level (OPT)]
ECHO Example:
ECHO %0 "C:\cutegirls\nodoka"
ECHO %0 "C:\cutegirls\nodoka" HashOutput.txt 1
ECHO;
ECHO Output name MUST be manually specified if enabling debug.
ECHO Output supports full path if desired.
ECHO;
ECHO Available debug levels: 1 - normal, 2 - turns off ECHO (use with redirection)
ECHO Modes higher than 1 preserve temp files
ECHO Logs print to %LogFile% in batch directory
ECHO;
ECHO If you're getting errors with Japanese filenames
ECHO make sure batch is saved in ANSI mode.
EXIT /B