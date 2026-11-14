@echo off
rem Starts Eddy OS on a Windows shop computer and restarts it if it stops.
rem Needs Node 22+ installed. Put this file's folder anywhere; it runs from the project root.
cd /d "%~dp0.."
set STORE_ID=eddy
set PORT=3000
set SEED_DEMO=0
rem Optional: copy backups to a second drive or a cloud-synced folder
rem set BACKUP_DIR=D:\EddyBackups
if not exist logs mkdir logs
:loop
node --disable-warning=ExperimentalWarning server.js >> logs\app.log 2>&1
echo %date% %time% app stopped, restarting >> logs\app.log
timeout /t 3 /nobreak >nul
goto loop
