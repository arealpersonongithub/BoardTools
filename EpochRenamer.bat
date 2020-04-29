::Epoch renamer V0.1
::Renames all files in directory with epoch filenames in a predefined time range.
::Literally just a VBS wrapper.
::Save in ANSI if Japanese characters used at any point.
::TODO: Call Hasher to produce booru-style filenames instead
::V0.1 28-04-20
@ECHO OFF
SETLOCAL EnableExtensions EnableDelayedExpansion
SET "MinDate=%1" & SET "MaxDate=%2" & SET "TargetDirectory=%3"
IF NOT DEFINED MinDate GOTO :syntaxisfucked
IF NOT DEFINED MaxDate GOTO :syntaxisfucked
IF NOT DEFINED TargetDirectory GOTO :syntaxisfucked

SET TmpDir=tmp\
SET ScriptName=%TmpDir%Helper.vbs
IF EXIST %TmpDir% (SET TmpDirWasThere=true) ELSE MKDIR %TmpDir%

::TODO: Implement this in pure batch
::Epoch filenames are 32bit+ values - split into intermediates and carry over?
ECHO Set fso = CreateObject("Scripting.FileSystemObject"):sDir = fso.GetAbsolutePathName(%TargetDirectory%):dtmStartDate = DateValue("%MinDate%"):dtmEndDate = DateValue("%MaxDate%"):For Each oFile In fso.GetFolder(sDir).Files:Randomize:dtmRandomDate = DateValue((dtmEndDate - dtmStartDate + 1) * Rnd + dtmStartDate):dtmStartTime = TimeValue("0:00:00"):dtmEndTime = TimeValue("23:59:59"):Randomize:dtmRandomTime = TimeValue((dtmEndTime - dtmStartTime + 1) * Rnd + dtmStartTime):dtmRandomDateTime = CDate(dtmRandomDate ^& " " ^& dtmRandomTime):dtmRDTtoS = DateDiff("s", "12/31/1969 00:00:00", dtmRandomDateTime):randomNumber = Int( (999 - 100 + 1) * Rnd + 100):dtmOutput = (dtmRDTtoS ^& randomNumber):EXT = fso.GetExtensionName(oFile):oFile.Name = dtmOutput^&"."^&EXT:Next>%ScriptName%

cscript //B %ScriptName%

IF TmpDirWasThere==true (DEL %ScriptName%) ELSE RMDIR /Q /S %TmpDir%
EXIT /B

:syntaxisfucked
ECHO EpochRenamer v0.1
ECHO Changes all filenames in directory to random epoch timestamps from given time period.
ECHO;
ECHO Usage:
ECHO %0 [start date] [end date] [full path to directory]
ECHO;
ECHO Example:
ECHO %0 01/01/2010 04/12/2020 "C:\cutegirls\nodoka"
EXIT /B
