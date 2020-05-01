# BoardTools<br>
Windows tools for comfier imageboard use.<br>

Contents:<br>
-EpochRenamer.bat<br>
-Hasher.bat<br>
-RndCutie2Clip.bat<br>

----
EpochRenamer.bat<br>
Renames all files in a given directory with epoch time filenames in a predefined time range.<br>
Usage: EpochRenamer [start date] [end date] [full path to directory]<br>
Example: EpochRenamer 01/01/2010 04/12/2020 "C:\cutegirls\nodoka"<br>
Date format is fluid (can be any DD/MM/YYYY combination, as long as start and end date formats match)<br>
Attempting to rename to dates before 01/01/1970 is not recommended.<br>
Dependencies: none<br>

----
Hasher.bat<br>
Calls CertUtil to get MD5 hash of all files in directory.<br>
Usage:<br>
Hasher [full path to directory] [output file name (OPT)] [debug level (OPT)]<br>
Example:<br>
Hasher "C:\cutegirls\nodoka" HashOutput.txt 1<br>
More information available when calling Hasher --h<br>
Dependencies: CertUtil (Windows built-in)<br>

----
RndCutie2Clip.bat<br>
Fetches random filename from current directory and outputs to clipboard.<br>
Usage: RndCutie2Clip<br>
Dependencies: none<br>
