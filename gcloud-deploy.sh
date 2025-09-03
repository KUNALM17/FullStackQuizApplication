#!/bin/bash

# ================================================================
# Google Cloud VM Deployment Script for FullStackQuizApplication
# Project ID: extended-arcana-318009
# Project Name: My First Project
# Instance: instance-20250829-101008
# Location: asia-south2-c
# User: kunalmani10
# OS: Ubuntu 22.04.5 LTS
# ================================================================

echo "🚀 Starting Google Cloud VM Deployment..."
echo "📋 Project ID: extended-arcana-318009"
echo "📋 Project Name: My First Project"
echo "🖥️  Instance: instance-20250829-101008"
echo "📍 Location: asia-south2-c"
echo "👤 User: kunalmani10"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Get VM External IP automatically
print_info "Detecting VM External IP..."
VM_EXTERNAL_IP=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)

if [ -z "$VM_EXTERNAL_IP" ]; then
    print_error "Could not detect VM External IP. Please check your network configuration."
    exit 1
fi

print_status "VM External IP detected: $VM_EXTERNAL_IP"

# Check if we're in the right directory
if [ ! -f "docker-compose.yml" ]; then
    print_error "docker-compose.yml not found. Make sure you're in the FullStackQuizApplication directory."
    exit 1
fi

print_status "Found docker-compose.yml"

# Update API URL in environment files
print_info "Updating API configuration for production..."

# Create production environment file
cat > quiz-frontend/.env.production << EOF
REACT_APP_API_BASE_URL=http://$VM_EXTERNAL_IP:8080
NODE_ENV=production
EOF

print_status "Created production environment file"

# Update docker-compose.prod.yml with actual VM IP
if [ -f "docker-compose.prod.yml" ]; then
    sed -i "s/34\.0\.14\.17/$VM_EXTERNAL_IP/g" docker-compose.prod.yml
    print_status "Updated docker-compose.prod.yml with VM IP"
else
    print_warning "docker-compose.prod.yml not found, using default docker-compose.yml"
fi

# Stop any existing containers
print_info "Stopping existing containers..."
docker-compose down 2>/dev/null

# Clean up Docker system
print_info "Cleaning up Docker system..."
docker system prune -f

# Build and start services
print_info "Building and starting services..."
if [ -f "docker-compose.prod.yml" ]; then
    docker-compose -f docker-compose.prod.yml up --build -d
else
    docker-compose up --build -d
fi

# Wait for services to start
print_info "Waiting for services to initialize..."
sleep 30

# Check container status
print_info "Checking container status..."
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Function to check service health
check_service() {
    local service_name=$1
    local url=$2
    local max_attempts=10
    local attempt=1

    print_info "Checking $service_name health..."
    
    while [ $attempt -le $max_attempts ]; do
        if curl -s -f "$url" >/dev/null 2>&1; then
            print_status "$service_name is healthy!"
            return 0
        fi
        
        print_warning "Attempt $attempt/$max_attempts: $service_name not ready yet..."
        sleep 10
        ((attempt++))
    done
    
    print_error "$service_name failed to start properly"
    return 1
}

# Wait a bit more for services to fully start
sleep 30

# Check backend health
check_service "Backend API" "http://localhost:8080/api/questions/allQuestions"

# Check frontend health
check_service "Frontend" "http://localhost:3000"

# Show container logs for troubleshooting
print_info "Recent container logs:"
echo ""
echo "=== Backend Logs ==="
docker logs quiz-backend --tail 20
echo ""
echo "=== Frontend Logs ==="
docker logs quiz-frontend --tail 20
echo ""
echo "=== Database Logs ==="
docker logs quiz-database --tail 10

# Final status check
print_info "Final deployment status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Network connectivity test
print_info "Testing network connectivity..."
if netstat -tlnp 2>/dev/null | grep -E ':3000|:8080' >/dev/null; then
    print_status "Ports 3000 and 8080 are listening"
else
    print_warning "Port binding check failed - services might still be starting"
fi

# Display access information
echo ""
echo "================================================================"
print_status "🎉 DEPLOYMENT COMPLETED!"
echo "================================================================"
echo ""
print_info "📱 Frontend Application: http://$VM_EXTERNAL_IP:3000"
print_info "🔧 Backend API: http://$VM_EXTERNAL_IP:8080"
print_info "📊 API Health Check: http://$VM_EXTERNAL_IP:8080/api/questions/allQuestions"
echo ""
print_info "🔑 Default Admin Credentials:"
echo "   Username: admin"
echo "   Password: admin123"
echo ""
print_info "👥 Register new users at: http://$VM_EXTERNAL_IP:3000"
echo ""

# Show firewall reminder
print_warning "🔥 FIREWALL REMINDER:"
echo "   Make sure these firewall rules exist:"
echo "   - allow-http-web-traffic (port 80)"
echo "   - allow-port-3000 (for frontend)"
echo "   - default-allow-http (port 8080)"
echo ""

# Troubleshooting information
print_info "🛠️  TROUBLESHOOTING:"
echo "   - Check logs: docker-compose logs -f"
echo "   - Restart services: docker-compose restart"
echo "   - Rebuild: docker-compose up --build -d"
echo "   - Check VM firewall: gcloud compute firewall-rules list"
echo ""

print_status "Deployment script completed!"
