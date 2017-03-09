@echo off
PowerShell -Command "Set-ExecutionPolicy Unrestricted" >> "%TEMP%\setupOneAgentLog.txt" 2>&1
PowerShell ".\Install.ps1 %ENVIRONMENTID% %TOKEN%" %CONNECTIONPOINT% >> "%TEMP%\setupOneAgentLog.txt" 2>&1

echo %StartupLocalStorage% > %userprofile%\1.txt
EXIT /B 0
