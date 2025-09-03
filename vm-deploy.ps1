# VM Deployment Script for FullStackQuiz
Write-Host "🚀 Starting VM deployment..." -ForegroundColor Green

# Stop and remove old containers
Write-Host "🧹 Cleaning up old containers..." -ForegroundColor Yellow
docker stop quizpro-backend quizpro-frontend quizpro-db 2>$null
docker rm quizpro-backend quizpro-frontend quizpro-db 2>$null

# Remove old images
Write-Host "🗑️  Removing old images..." -ForegroundColor Yellow
docker rmi fullstackquiz-backend:latest fullstackquiz-frontend:latest 2>$null

# Pull latest code (if not already done)
Write-Host "📥 Ensuring latest code..." -ForegroundColor Blue
git pull origin main

# Build and deploy new containers
Write-Host "🔨 Building and deploying new containers..." -ForegroundColor Cyan
docker compose -f docker-compose.yml up --build -d

# Check container status
Write-Host "📊 Container Status:" -ForegroundColor Magenta
docker ps

Write-Host "✅ Deployment complete!" -ForegroundColor Green
Write-Host "🌐 Your application should be available at:" -ForegroundColor White
Write-Host "   Frontend: http://34.0.14.17:3000" -ForegroundColor Cyan
Write-Host "   Backend API: http://34.0.14.17:8080" -ForegroundColor Cyan
