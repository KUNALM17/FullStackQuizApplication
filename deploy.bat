@echo off
echo ================================================================
echo Google Cloud VM Deployment for FullStackQuizApplication
echo Project ID: extended-arcana-318009
echo Instance: instance-20250829-101008
echo Zone: asia-south2-c
echo User: kunalmani10
echo ================================================================
echo.

echo Starting PowerShell deployment script...
powershell.exe -ExecutionPolicy Bypass -File "deploy-to-gcloud.ps1"

echo.
echo Deployment completed!
pause
