#!/bin/bash

echo "🚀 FRESH VM DEPLOYMENT - FullStackQuiz"
echo "========================================="

# Get latest code
echo "📥 Pulling latest code from repository..."
git pull origin main

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Build and deploy new containers
echo "🔨 Building and deploying fresh containers..."
docker compose up --build -d

# Wait for services to start
echo "⏳ Waiting for services to start..."
sleep 30

# Check container status
echo "📊 Container Status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Check health status
echo ""
echo "🏥 Health Check Status:"
echo "Backend Health:"
curl -s http://localhost:8080/actuator/health || echo "Backend not ready yet"
echo ""
echo "Frontend Health:"
curl -s -o /dev/null -w "%{http_code}" http://localhost:80 || echo "Frontend not ready yet"

echo ""
echo "✅ Deployment complete!"
echo "🌐 Your application is available at:"
echo "   Frontend: http://34.0.14.17 (port 80)"
echo "   Backend API: http://34.0.14.17:8080"
echo ""
echo "📝 To view logs:"
echo "   docker logs quiz-frontend"
echo "   docker logs quiz-backend"
echo "   docker logs quiz-database"
