#!/bin/bash

echo "🔍 DIAGNOSING VM DEPLOYMENT STATUS"
echo "=================================="

echo "📊 Current Docker containers:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "📊 All containers (including stopped):"
docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "🌐 Testing connectivity:"
echo "Port 80 (HTTP):"
curl -I http://localhost:80 2>/dev/null || echo "❌ Port 80 not responding"

echo "Port 8080 (Backend):"
curl -I http://localhost:8080 2>/dev/null || echo "❌ Port 8080 not responding"

echo ""
echo "📋 Container logs (last 10 lines each):"
echo "--- Frontend logs ---"
docker logs quiz-frontend --tail 10 2>/dev/null || echo "❌ Frontend container not found"

echo "--- Backend logs ---"
docker logs quiz-backend --tail 10 2>/dev/null || echo "❌ Backend container not found"

echo "--- Database logs ---"
docker logs quiz-database --tail 10 2>/dev/null || echo "❌ Database container not found"

echo ""
echo "🔧 If containers are not running, use:"
echo "docker compose up --build -d"
