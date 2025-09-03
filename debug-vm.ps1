# PowerShell script to run debugging on Google Cloud VM

param(
    [string]$VMUser = "kunalmani10",
    [string]$VMInstance = "instance-20250829-101008",
    [string]$Zone = "asia-south2-c",
    [string]$Project = "extended-arcana-318009"
)

Write-Host "🔍 Starting VM Debugging Session..." -ForegroundColor Green
Write-Host "=================================================="

# Check gcloud installation
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

# Check VM status
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

# Commit and push debug script
Write-Host "📤 Pushing debug script to repository..." -ForegroundColor Blue
git add debug-vm.sh
git commit -m "Add comprehensive VM debugging script" 2>$null
git push origin main

# SSH to VM and run debugging
Write-Host "🔗 Connecting to VM and running debug script..." -ForegroundColor Blue
Write-Host "This will take several minutes..." -ForegroundColor Yellow

$sshCommand = @"
cd FullStackQuizApplication && 
git pull origin main && 
chmod +x debug-vm.sh && 
./debug-vm.sh
"@

try {
    gcloud compute ssh $VMUser@$VMInstance --zone=$Zone --command=$sshCommand
    
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Green
    Write-Host "🎯 DEBUGGING COMPLETED!" -ForegroundColor Green
    Write-Host "================================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "🌐 Try accessing your application:" -ForegroundColor Cyan
    Write-Host "   Frontend: http://$vmIP:3000" -ForegroundColor White
    Write-Host "   Backend:  http://$vmIP:8080" -ForegroundColor White
    Write-Host ""
    
    # Test connectivity
    Write-Host "🧪 Testing connectivity..." -ForegroundColor Blue
    try {
        $frontendTest = Invoke-WebRequest -Uri "http://$vmIP:3000" -TimeoutSec 10 -UseBasicParsing 2>$null
        Write-Host "✅ Frontend is accessible!" -ForegroundColor Green
    } catch {
        Write-Host "❌ Frontend is not accessible: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    try {
        $backendTest = Invoke-WebRequest -Uri "http://$vmIP:8080/api/questions/allQuestions" -TimeoutSec 10 -UseBasicParsing 2>$null
        Write-Host "✅ Backend is accessible!" -ForegroundColor Green
    } catch {
        Write-Host "❌ Backend is not accessible: $($_.Exception.Message)" -ForegroundColor Red
    }
    
} catch {
    Write-Host "❌ Error during debugging: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "💡 Try running the debug script manually on VM" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "📋 Next Steps if still not working:" -ForegroundColor Yellow
Write-Host "1. Check firewall rules in Google Cloud Console" -ForegroundColor White
Write-Host "2. Verify VM has external IP assigned" -ForegroundColor White
Write-Host "3. Check container logs: docker logs quiz-frontend" -ForegroundColor White
Write-Host "4. Restart services: docker-compose restart" -ForegroundColor White
