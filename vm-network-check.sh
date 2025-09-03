#!/bin/bash

echo "🔍 CHECKING VM NETWORK AND BACKEND ACCESS"
echo "========================================"

# Check if containers are running
echo "📊 Container Status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "🌐 Testing Backend Access:"

# Test localhost access (should work)
echo "Testing localhost access:"
curl -I http://localhost:8080/actuator/health 2>/dev/null || echo "❌ Backend not accessible on localhost"

# Test external access (this might fail due to firewall)
echo "Testing external access:"
curl -I http://34.0.14.17:8080/actuator/health 2>/dev/null || echo "❌ Backend not accessible externally"

echo ""
echo "🔥 Firewall Status:"
sudo ufw status

echo ""
echo "📋 Open Ports:"
sudo netstat -tlnp | grep :8080

echo ""
echo "🚀 Firewall Fix Commands (if needed):"
echo "sudo ufw allow 8080"
echo "sudo ufw allow 80"
echo "sudo ufw reload"
