#!/bin/bash

echo "🧹 COMPLETE VM CLEANUP - Removing ALL Docker data"
echo "⚠️  WARNING: This will remove ALL containers, images, volumes, and networks!"
echo "Proceeding in 5 seconds... Press Ctrl+C to cancel"
sleep 5

echo "🛑 Stopping ALL running containers..."
docker stop $(docker ps -aq) 2>/dev/null || true

echo "🗑️  Removing ALL containers..."
docker rm $(docker ps -aq) 2>/dev/null || true

echo "🖼️  Removing ALL images..."
docker rmi $(docker images -q) -f 2>/dev/null || true

echo "💾 Removing ALL volumes..."
docker volume rm $(docker volume ls -q) 2>/dev/null || true

echo "🌐 Removing ALL networks (except default)..."
docker network rm $(docker network ls --filter type=custom -q) 2>/dev/null || true

echo "🔄 Pruning Docker system..."
docker system prune -a -f --volumes

echo "📊 Docker status after cleanup:"
echo "Containers:"
docker ps -a
echo "Images:"
docker images
echo "Volumes:"
docker volume ls
echo "Networks:"
docker network ls

echo "✅ Complete cleanup finished!"
echo "🚀 Ready for fresh deployment"
