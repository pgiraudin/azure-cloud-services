@echo off
PowerShell -Command "Set-ExecutionPolicy Unrestricted" >> "%TEMP%\setupRuxitLog.txt" 2>&1
PowerShell ".\Install.ps1 %TENANT% %TOKEN%" >> "%TEMP%\setupRuxitLog.txt" 2>&1

%StartupLocalStorage%\ruxit-agent-installer-latest.exe /quiet
echo %StartupLocalStorage% > %userprofile%\1.txt
EXIT /B 0