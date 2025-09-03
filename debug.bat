@echo off
echo ================================================================
echo COMPREHENSIVE VM DEBUGGING FOR FULLSTACKQUIZAPPLICATION
echo ================================================================
echo Project ID: extended-arcana-318009
echo Instance: instance-20250829-101008
echo Zone: asia-south2-c
echo User: kunalmani10
echo ================================================================
echo.

echo Starting comprehensive debugging...
echo This will:
echo 1. Check VM status
echo 2. Update and deploy application
echo 3. Run comprehensive diagnostics
echo 4. Test all services
echo 5. Provide detailed troubleshooting info
echo.

pause

powershell.exe -ExecutionPolicy Bypass -File "debug-vm.ps1"

echo.
echo Debugging completed!
echo Check the output above for any issues.
pause
