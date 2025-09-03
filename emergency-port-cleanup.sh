#!/bin/bash

echo "🚨 EMERGENCY PORT CLEANUP - Run this on your VM"
echo "=============================================="

# Stop all running containers
echo "🛑 Stopping ALL containers..."
docker stop $(docker ps -q) 2>/dev/null

# Remove all containers  
echo "🗑️ Removing ALL containers..."
docker rm $(docker ps -aq) 2>/dev/null

# Check what's using port 5432 and kill it
echo "🔍 Checking port 5432..."
sudo lsof -ti:5432 | xargs sudo kill -9 2>/dev/null

# Check what's using port 8080 and kill it
echo "🔍 Checking port 8080..."
sudo lsof -ti:8080 | xargs sudo kill -9 2>/dev/null

# Check what's using port 80 and kill it
echo "🔍 Checking port 80..."
sudo lsof -ti:80 | xargs sudo kill -9 2>/dev/null

echo "✅ Ports cleared! Now run: docker compose up --build -d"
