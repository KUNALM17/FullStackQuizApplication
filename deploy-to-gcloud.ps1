# ================================================================
# PowerShell Script to Sync and Deploy to Google Cloud VM
# Project: My First Project
# Instance: instance-20250829-101008
# Location: asia-south2-c
# User: kunalmani10
# ================================================================

param(
    [string]$VMUser = "kunalmani10",
    [string]$VMInstance = "instance-20250829-101008",
    [string]$Zone = "asia-south2-c",
    [string]$Project = "extended-arcana-318009"
)

Write-Host "🚀 Google Cloud VM Deployment Manager" -ForegroundColor Green
Write-Host "📋 Project ID: $Project" -ForegroundColor Blue
Write-Host "📋 Project Name: My First Project" -ForegroundColor Blue
Write-Host "🖥️  Instance: $VMInstance" -ForegroundColor Blue
Write-Host "📍 Zone: $Zone" -ForegroundColor Blue
Write-Host "👤 User: $VMUser" -ForegroundColor Blue
Write-Host ""

# Function to execute commands on VM
function Invoke-VMCommand {
    param([string]$Command)
    
    Write-Host "🔧 Executing on VM: $Command" -ForegroundColor Yellow
    gcloud compute ssh $VMUser@$VMInstance --zone=$Zone --project=$Project --command="$Command"
}

# Function to copy files to VM
function Copy-ToVM {
    param([string]$LocalPath, [string]$RemotePath)
    
    Write-Host "📁 Copying $LocalPath to VM:$RemotePath" -ForegroundColor Cyan
    gcloud compute scp $LocalPath $VMUser@${VMInstance}:$RemotePath --zone=$Zone --project=$Project --recurse
}

try {
    # Check if gcloud is installed
    $gcloudVersion = gcloud version 2>$null
    if (-not $gcloudVersion) {
        Write-Host "❌ Google Cloud SDK not found. Please install it first." -ForegroundColor Red
        Write-Host "Download from: https://cloud.google.com/sdk/docs/install" -ForegroundColor Yellow
        exit 1
    }
    
    Write-Host "✅ Google Cloud SDK found" -ForegroundColor Green
    
    # Set the project
    Write-Host "🔧 Setting Google Cloud project..." -ForegroundColor Blue
    gcloud config set project $Project

    # Get VM external IP
    Write-Host "🔍 Getting VM external IP..." -ForegroundColor Blue
    $vmIP = gcloud compute instances describe $VMInstance --zone=$Zone --project=$Project --format="get(networkInterfaces[0].accessConfigs[0].natIP)" 2>$null
    
    if (-not $vmIP) {
        Write-Host "❌ Could not get VM IP. Check if VM is running." -ForegroundColor Red
        exit 1
    }
    
    Write-Host "✅ VM External IP: $vmIP" -ForegroundColor Green

    # Update production environment with VM IP
    Write-Host "📝 Updating production configuration..." -ForegroundColor Blue
    $prodEnvContent = @"
REACT_APP_API_BASE_URL=http://${vmIP}:8080
NODE_ENV=production
"@
    $prodEnvContent | Out-File -FilePath "quiz-frontend\.env.production" -Encoding UTF8
    
    # Update docker-compose.prod.yml if it exists
    if (Test-Path "docker-compose.prod.yml") {
        (Get-Content "docker-compose.prod.yml") -replace "34\.0\.14\.17", $vmIP | Set-Content "docker-compose.prod.yml"
        Write-Host "✅ Updated docker-compose.prod.yml" -ForegroundColor Green
    }

    # Commit and push changes
    Write-Host "📤 Pushing updated configuration to Git..." -ForegroundColor Blue
    git add .
    git commit -m "Update production config for VM IP: $vmIP" 2>$null
    git push origin main

    # Connect to VM and deploy
    Write-Host "🚀 Starting VM deployment..." -ForegroundColor Green
    
    # Update repository on VM
    Invoke-VMCommand "cd FullStackQuizApplication && git pull origin main"
    
    # Make deployment script executable and run it
    Invoke-VMCommand "cd FullStackQuizApplication && chmod +x gcloud-deploy.sh && ./gcloud-deploy.sh"
    
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Green
    Write-Host "🎉 DEPLOYMENT COMPLETED SUCCESSFULLY!" -ForegroundColor Green
    Write-Host "================================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "📱 Access your application at: http://$vmIP:3000" -ForegroundColor Cyan
    Write-Host "🔧 Backend API at: http://$vmIP:8080" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "🔑 Default Admin Login:" -ForegroundColor Yellow
    Write-Host "   Username: admin" -ForegroundColor White
    Write-Host "   Password: admin123" -ForegroundColor White
    Write-Host ""
    
    # Open browser to the application
    $choice = Read-Host "🌐 Open application in browser? (y/N)"
    if ($choice -eq "y" -or $choice -eq "Y") {
        Start-Process "http://$vmIP:3000"
    }
    
} catch {
    Write-Host "❌ Deployment failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "💡 Check VM status and firewall rules" -ForegroundColor Yellow
    exit 1
}
