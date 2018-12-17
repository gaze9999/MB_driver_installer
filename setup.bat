@echo off
title Motherboard Driver Installer 0.1

call :Resume
goto %current%
goto :eof

:one
::Add script to Run key
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v "%~n0" /d "%~dpnx0" /f
echo two >%~dp0current.txt

ECHO.
ECHO ================= Installing Intel Chipset Drivers =================
ECHO.
%~dp0\Drivers\Chipset\SetupChipset.exe -s -norestart
timeout /t 3 /nobreak

ECHO.
ECHO ================ Installing Intel VGA Drivers ================
ECHO.
%~dp0\Drivers\Intel_vga_kbl\setup.exe -s
timeout /t 3 /nobreak

ECHO ============ Installing Realtek Audio Drivers ================
ECHO.
%~dp0\Drivers\Realtek_Audio\Setup.exe -s
timeout /t 3 /nobreak

ECHO.
ECHO ============= Installing Realtek LAN Drivers =================
ECHO.
%~dp0\Drivers\Realtek_Lan\Setup.exe -s
timeout /t 3 /nobreak

ECHO.
ECHO ============== Installing Intel USB Drivers ===================
ECHO.
%~dp0\Drivers\Intel_USB3.0\Setup.exe -s
timeout /t 3 /nobreak

ECHO.
ECHO ============== Installing Intel Serial IO Drivers ===================
ECHO.
%~dp0\Drivers\Intel_Serial_IO\SetupSerialIO.exe -s
timeout /t 3 /nobreak

ECHO.
ECHO ============== Installing ME Hotfix ===================
ECHO.
wusa.exe %~dp0\Drivers\ME\KB2685811-x64.msu /quiet /norestart
timeout /t 3 /nobreak

shutdown -r -t 0
goto :eof

:two
::Remove script from Run key
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v "%~n0" /f
del %~dp0current.txt

ECHO.
ECHO ============== Installing Intel Rapid Storage Technology Driver ===================
ECHO.
%~dp0\Drivers\IRST\SetupRST.exe -s
timeout /t 3 /nobreak

ECHO.
ECHO ============== Installing Intel ME Drivers ===================
ECHO.
%~dp0\Drivers\ME\SetupME.exe -s
timeout /t 3 /nobreak

wmic useraccount where "Name='User'" set PasswordExpires=FALSE

ECHO.
ECHO ================== Change Power Plan ==================
ECHO.
powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg -x -monitor-timeout-ac 0
powercfg -x -monitor-timeout-dc 0
regedit -s %~dp0\Buffer\Disable_Sleep.reg
regedit -s %~dp0\Buffer\Disable_Sleep_win7.reg
powercfg -h off

ECHO.
ECHO ================== Enable Desktop Icon ==================
ECHO.
regedit -s %~dp0\Buffer\Add_All_Desktop_Icon_All_Users.reg
regedit -s %~dp0\Buffer\Show_Seconds_In_System_Clock.reg

goto :eof

:resume
if exist %~dp0current.txt (
    set /p current=<%~dp0current.txt
) else (
    set current=one
)