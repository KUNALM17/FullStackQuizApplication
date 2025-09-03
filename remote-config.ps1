# PowerShell Script for Google Cloud Configuration
# Run this from your local Windows machine

# Configuration Variables (UPDATE THESE)
$PROJECT_ID = "your-project-id"           # Replace with your actual project ID
$VM_NAME = "quiz-app-vm"                  # Replace with your VM name  
$VM_ZONE = "us-central1-a"                # Replace with your VM zone
$VM_EXTERNAL_IP = "34.0.14.17"           # Your current VM IP

Write-Host "🔧 Configuring Google Cloud for FullStackQuizApplication..." -ForegroundColor Blue

# Set the project
Write-Host "Setting project..." -ForegroundColor Yellow
gcloud config set project $PROJECT_ID

# Create firewall rules
Write-Host "Creating firewall rules..." -ForegroundColor Yellow

try {
    gcloud compute firewall-rules create allow-quiz-frontend `
        --allow tcp:3000 `
        --source-ranges 0.0.0.0/0 `
        --description "Allow access to Quiz Frontend" `
        --project=$PROJECT_ID
    Write-Host "✅ Frontend firewall rule created" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Frontend firewall rule may already exist" -ForegroundColor Yellow
}

try {
    gcloud compute firewall-rules create allow-quiz-backend `
        --allow tcp:8080 `
        --source-ranges 0.0.0.0/0 `
        --description "Allow access to Quiz Backend" `
        --project=$PROJECT_ID
    Write-Host "✅ Backend firewall rule created" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Backend firewall rule may already exist" -ForegroundColor Yellow
}

try {
    gcloud compute firewall-rules create allow-quiz-db `
        --allow tcp:5432 `
        --source-ranges 0.0.0.0/0 `
        --description "Allow access to Quiz Database" `
        --project=$PROJECT_ID
    Write-Host "✅ Database firewall rule created" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Database firewall rule may already exist" -ForegroundColor Yellow
}

# Add network tags to VM
Write-Host "Adding network tags to VM..." -ForegroundColor Yellow
try {
    gcloud compute instances add-tags $VM_NAME `
        --zone=$VM_ZONE `
        --tags=http-server,https-server,quiz-app `
        --project=$PROJECT_ID
    Write-Host "✅ Network tags added" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Network tags may already exist" -ForegroundColor Yellow
}

# Instructions for manual VM setup
Write-Host "`n📋 Next Steps:" -ForegroundColor Cyan
Write-Host "1. SSH into your VM:" -ForegroundColor White
Write-Host "   gcloud compute ssh $VM_NAME --zone=$VM_ZONE --project=$PROJECT_ID" -ForegroundColor Gray

Write-Host "`n2. Run these commands on your VM:" -ForegroundColor White
Write-Host "   git clone https://github.com/KUNALM17/FullStackQuizApplication.git" -ForegroundColor Gray
Write-Host "   cd FullStackQuizApplication" -ForegroundColor Gray
Write-Host "   chmod +x complete-setup.sh" -ForegroundColor Gray
Write-Host "   ./complete-setup.sh" -ForegroundColor Gray

Write-Host "`n🌐 Your application will be available at: http://$VM_EXTERNAL_IP`:3000" -ForegroundColor Green
Write-Host "📡 Backend API will be available at: http://$VM_EXTERNAL_IP`:8080" -ForegroundColor Green

Write-Host "`n✅ Local configuration complete!" -ForegroundColor Green
