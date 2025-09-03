#!/bin/bash

# VM Deployment Script for FullStackQuizApplication
# Run this script on your Google Cloud VM

echo "🚀 Starting FullStackQuizApplication Deployment..."

# Get VM External IP
VM_EXTERNAL_IP=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)
echo "📍 VM External IP: $VM_EXTERNAL_IP"

# Update docker-compose.prod.yml with current VM IP
sed -i "s/34\.0\.14\.17/$VM_EXTERNAL_IP/g" docker-compose.prod.yml

# Stop any existing containers
echo "🛑 Stopping existing containers..."
docker-compose down

# Build and start services
echo "🔨 Building and starting services..."
docker-compose -f docker-compose.prod.yml up --build -d

# Wait for services to start
echo "⏳ Waiting for services to start..."
sleep 60

# Check container status
echo "📊 Container Status:"
docker ps

# Check container logs
echo "📋 Backend Logs:"
docker logs quiz-backend --tail 20

echo "📋 Frontend Logs:"
docker logs quiz-frontend --tail 20

# Test endpoints
echo "🧪 Testing endpoints..."
echo "Backend Health: $(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/api/questions/allQuestions)"
echo "Frontend Status: $(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000)"

echo "✅ Deployment Complete!"
echo "🌐 Access your application at: http://$VM_EXTERNAL_IP:3000"
echo "📡 Backend API available at: http://$VM_EXTERNAL_IP:8080"

# Show firewall rules reminder
echo ""
echo "🔥 IMPORTANT: Make sure firewall rules allow traffic on ports 3000 and 8080"
echo "Run these commands if needed:"
echo "gcloud compute firewall-rules create allow-quiz-frontend --allow tcp:3000 --source-ranges 0.0.0.0/0"
echo "gcloud compute firewall-rules create allow-quiz-backend --allow tcp:8080 --source-ranges 0.0.0.0/0"
