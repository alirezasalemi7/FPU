@echo off
ECHO Installing MPMATH library for windows
ECHO Extracting source files ...

setlocal
cd /d %~dp0
Call :UnZipFile "%CD%\MPMATH_LIBRARY" "%CD%\mpmath-1.1.0.zip"
cd "MPMATH_LIBRARY\mpmath-1.1.0"
python setup.py install
cd "..\.."
exit /b

:UnZipFile <ExtractTo> <newzipfile>
set vbs="%temp%\_.vbs"
set vbs=".\_.vbs"
if exist %vbs% del /f /q %vbs%
>%vbs%  echo Set fso = CreateObject("Scripting.FileSystemObject")
>>%vbs% echo If NOT fso.FolderExists(%1) Then
>>%vbs% echo fso.CreateFolder(%1)
>>%vbs% echo End If
>>%vbs% echo set objShell = CreateObject("Shell.Application")
>>%vbs% echo set FilesInZip=objShell.NameSpace(%2).items
>>%vbs% echo objShell.NameSpace(%1).CopyHere(FilesInZip)
>>%vbs% echo Set fso = Nothing
>>%vbs% echo Set objShell = Nothing
cscript //Nologo %vbs%
if exist %vbs% del /f /q %vbs%
