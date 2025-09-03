#!/bin/bash

echo "🔧 FIXING GIT CONFLICT AND DEPLOYING"
echo "===================================="

# Step 1: Handle git conflict
echo "📝 Resolving git conflict..."
git stash
git pull origin main
git stash pop

# Step 2: If conflict persists, force update
if [ $? -ne 0 ]; then
    echo "⚠️  Force updating repository..."
    git reset --hard origin/main
    git pull origin main
fi

# Step 3: Deploy fresh containers
echo "🚀 Deploying fresh containers..."
docker compose up --build -d

# Step 4: Check deployment status
echo "📊 Checking deployment status..."
sleep 10
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "🌐 Application should be available at:"
echo "   Frontend: http://34.0.14.17"
echo "   Backend: http://34.0.14.17:8080"
