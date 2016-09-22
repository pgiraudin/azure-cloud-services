@echo off
PowerShell -Command "Set-ExecutionPolicy Unrestricted" >> "%TEMP%\setupOneAgentLog.txt" 2>&1
PowerShell ".\Install.ps1 %ENVIRONMENTID% %TOKEN%" >> "%TEMP%\setupOneAgentLog.txt" 2>&1

%StartupLocalStorage%\oneagent-installer-latest.exe /quiet
echo %StartupLocalStorage% > %userprofile%\1.txt
EXIT /B 0
