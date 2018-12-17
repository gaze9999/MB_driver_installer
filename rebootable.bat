@echo off
title Insert Title Here

call :Resume
goto %current%
goto :eof

:one
::Add script to Run key
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v "%~n0" /d "%~dpnx0" /f
echo two >%~dp0current.txt
shutdown -r -t 0
goto :eof

:two
echo three >%~dp0current.txt
shutdown -r -t 0
goto :eof

:three
::Remove script from Run key
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v "%~n0" /f
del %~dp0current.txt
goto :eof

:resume
if exist %~dp0current.txt (
    set /p current=<%~dp0current.txt
) else (
    set current=one
)