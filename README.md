# BoardTools
Windows tools for comfier imageboard use.

Contents:
-EpochRenamer.bat
-Hasher.bat
-RndCutie2Clip.bat

----
EpochRenamer.bat
Renames all files in a given directory with epoch time filenames in a predefined time range.
Usage: EpochRenamer [start date] [end date] [full path to directory]
Example: EpochRenamer 01/01/2010 04/12/2020 "C:\cutegirls\nodoka"
Date format is fluid (can be any DD/MM/YYYY combination, as long as start and end date formats match)
Attempting to rename to dates before 01/01/1970 is not recommended.
Dependencies: none

----
Hasher.bat
Calls CertUtil to get MD5 hash of all files in directory.
Usage:
Hasher [full path to directory] [output file name (OPT)] [debug level (OPT)]
Example:
Hasher "C:\cutegirls\nodoka" HashOutput.txt 1
More information available when calling Hasher --h
Dependencies: CertUtil (Windows built-in)

----
RndCutie2Clip.bat
Fetches random filename from current directory and outputs to clipboard.
Usage: RndCutie2Clip
Dependencies: none
