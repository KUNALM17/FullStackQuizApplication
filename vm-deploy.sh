#!/bin/bash

# VM Deployment Script for FullStackQuiz
echo "🚀 Starting VM deployment..."

# Stop and remove old containers
echo "🧹 Cleaning up old containers..."
docker stop quizpro-backend quizpro-frontend quizpro-db 2>/dev/null || true
docker rm quizpro-backend quizpro-frontend quizpro-db 2>/dev/null || true

# Remove old images
echo "🗑️  Removing old images..."
docker rmi fullstackquiz-backend:latest fullstackquiz-frontend:latest 2>/dev/null || true

# Pull latest code (if not already done)
echo "📥 Ensuring latest code..."
git pull origin main

# Build and deploy new containers
echo "🔨 Building and deploying new containers..."
docker compose -f docker-compose.yml up --build -d

# Check container status
echo "📊 Container Status:"
docker ps

echo "✅ Deployment complete!"
echo "🌐 Your application should be available at:"
echo "   Frontend: http://34.0.14.17:3000"
echo "   Backend API: http://34.0.14.17:8080"
