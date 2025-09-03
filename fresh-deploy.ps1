# PowerShell script for complete fresh deployment

param(
    [string]$VMUser = "kunalmani10",
    [string]$VMInstance = "instance-20250829-101008",
    [string]$Zone = "asia-south2-c",
    [string]$Project = "extended-arcana-318009"
)

Write-Host "🔥 COMPLETE FRESH DEPLOYMENT" -ForegroundColor Red
Write-Host "This will completely remove old containers and deploy the latest version" -ForegroundColor Yellow
Write-Host "=================================================="

# Confirm action
$confirm = Read-Host "This will stop and remove ALL containers on your VM. Continue? (y/N)"
if ($confirm -ne "y" -and $confirm -ne "Y") {
    Write-Host "❌ Operation cancelled" -ForegroundColor Red
    exit 0
}

# Check gcloud
try {
    $gcloudVersion = gcloud version 2>$null
    if (-not $gcloudVersion) {
        Write-Host "❌ Google Cloud SDK not found" -ForegroundColor Red
        exit 1
    }
    Write-Host "✅ Google Cloud SDK found" -ForegroundColor Green
} catch {
    Write-Host "❌ Error checking gcloud: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Set project
Write-Host "🔧 Setting project to $Project..." -ForegroundColor Blue
gcloud config set project $Project

# Check VM status and start if needed
Write-Host "🖥️  Checking VM status..." -ForegroundColor Blue
$vmStatus = gcloud compute instances describe $VMInstance --zone=$Zone --format="get(status)" 2>$null

if ($vmStatus -eq "RUNNING") {
    Write-Host "✅ VM is running" -ForegroundColor Green
} elseif ($vmStatus -eq "TERMINATED") {
    Write-Host "⚠️  VM is stopped. Starting VM..." -ForegroundColor Yellow
    gcloud compute instances start $VMInstance --zone=$Zone
    Write-Host "⏳ Waiting for VM to start..." -ForegroundColor Blue
    Start-Sleep 30
} else {
    Write-Host "❌ VM status unknown: $vmStatus" -ForegroundColor Red
    exit 1
}

# Get VM IP
$vmIP = gcloud compute instances describe $VMInstance --zone=$Zone --format="get(networkInterfaces[0].accessConfigs[0].natIP)" 2>$null
Write-Host "📍 VM External IP: $vmIP" -ForegroundColor Cyan

# Commit and push fresh deployment script
Write-Host "📤 Pushing fresh deployment script to repository..." -ForegroundColor Blue
git add fresh-deploy.sh fresh-deploy.ps1
git commit -m "Add complete fresh deployment script for old container cleanup" 2>$null
git push origin main

# SSH to VM and run fresh deployment
Write-Host "🔗 Connecting to VM and running COMPLETE FRESH DEPLOYMENT..." -ForegroundColor Blue
Write-Host "⚠️  This will take 5-10 minutes..." -ForegroundColor Yellow
Write-Host "🔄 Steps: Stop all containers → Clean Docker → Update code → Fresh build → Deploy" -ForegroundColor Cyan

$sshCommand = @"
cd FullStackQuizApplication && 
git pull origin main && 
chmod +x fresh-deploy.sh && 
./fresh-deploy.sh
"@

try {
    gcloud compute ssh $VMUser@$VMInstance --zone=$Zone --command=$sshCommand
    
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Green
    Write-Host "🎉 FRESH DEPLOYMENT COMPLETED!" -ForegroundColor Green
    Write-Host "================================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "🌐 Your UPDATED application is now available at:" -ForegroundColor Cyan
    Write-Host "   Frontend: http://$vmIP:3000" -ForegroundColor White
    Write-Host "   Backend:  http://$vmIP:8080" -ForegroundColor White
    Write-Host ""
    Write-Host "🔄 IMPORTANT BROWSER STEPS:" -ForegroundColor Yellow
    Write-Host "   1. Clear browser cache (Ctrl+Shift+Delete)" -ForegroundColor White
    Write-Host "   2. Or open in incognito/private mode" -ForegroundColor White
    Write-Host "   3. Hard refresh with Ctrl+F5" -ForegroundColor White
    Write-Host ""
    
    # Test connectivity
    Write-Host "🧪 Testing new deployment..." -ForegroundColor Blue
    Start-Sleep 30
    
    try {
        $frontendTest = Invoke-WebRequest -Uri "http://$vmIP:3000" -TimeoutSec 15 -UseBasicParsing 2>$null
        Write-Host "✅ NEW Frontend is accessible!" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  Frontend might still be starting up..." -ForegroundColor Yellow
    }
    
    try {
        $backendTest = Invoke-WebRequest -Uri "http://$vmIP:8080/api/questions/allQuestions" -TimeoutSec 15 -UseBasicParsing 2>$null
        Write-Host "✅ NEW Backend is accessible!" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  Backend might still be starting up..." -ForegroundColor Yellow
    }
    
    # Open browser to the application
    Write-Host ""
    $choice = Read-Host "🌐 Open updated application in browser? (y/N)"
    if ($choice -eq "y" -or $choice -eq "Y") {
        Start-Process "http://$vmIP:3000"
    }
    
} catch {
    Write-Host "❌ Deployment failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "💡 Check VM logs and try again" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "📋 If you still see the old version:" -ForegroundColor Yellow
Write-Host "1. Clear ALL browser data for the site" -ForegroundColor White
Write-Host "2. Try a different browser" -ForegroundColor White
Write-Host "3. Wait 5-10 minutes for services to fully start" -ForegroundColor White
Write-Host "4. Check container logs: SSH to VM and run 'docker logs quiz-frontend'" -ForegroundColor White
