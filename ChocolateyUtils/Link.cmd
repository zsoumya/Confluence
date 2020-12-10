@echo off

if [%1] == [] GOTO help
if [%2] == [] GOTO help

C:\ProgramData\chocolatey\tools\shimgen -o=%1 -p=%2 -i=%2

GOTO :eof

:help
echo.
echo Link creates shims of executables using the ShimGen command
echo.
echo %~n0 {alias} {target}
echo Example: %~n0 C:\tools\np.exe "C:\Program Files\Notepad3\Notepad3.exe"
