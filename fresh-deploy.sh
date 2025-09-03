#!/bin/bash

# ================================================================
# COMPLETE VM CLEANUP AND FRESH DEPLOYMENT SCRIPT
# This will remove old containers and deploy the latest version
# ================================================================

echo "🔥 COMPLETE CLEANUP AND FRESH DEPLOYMENT"
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_success() {
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

print_header() {
    echo -e "\n${BLUE}========== $1 ==========${NC}"
}

# Get VM IP
VM_EXTERNAL_IP=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)
print_info "VM External IP: $VM_EXTERNAL_IP"

print_header "STEP 1: STOPPING ALL CONTAINERS"

# Stop and remove ALL containers (old and new)
print_info "Stopping all running containers..."
docker stop $(docker ps -q) 2>/dev/null || true

print_info "Removing all containers..."
docker rm $(docker ps -aq) 2>/dev/null || true

print_success "All containers stopped and removed"

print_header "STEP 2: COMPLETE DOCKER CLEANUP"

# Remove all images, networks, volumes
print_info "Removing all Docker images..."
docker rmi $(docker images -q) 2>/dev/null || true

print_info "Removing all Docker networks..."
docker network rm $(docker network ls -q) 2>/dev/null || true

print_info "Removing all Docker volumes..."
docker volume rm $(docker volume ls -q) 2>/dev/null || true

print_info "System-wide Docker cleanup..."
docker system prune -a -f --volumes

print_success "Complete Docker cleanup finished"

print_header "STEP 3: UPDATING REPOSITORY"

# Make sure we're in the right directory
if [ ! -d "FullStackQuizApplication" ]; then
    print_info "Cloning repository..."
    git clone https://github.com/KUNALM17/FullStackQuizApplication.git
fi

cd FullStackQuizApplication

print_info "Pulling latest changes..."
git fetch origin
git reset --hard origin/main
git clean -fd

print_success "Repository updated to latest version"

print_header "STEP 4: ENVIRONMENT CONFIGURATION"

# Create fresh environment file
print_info "Creating production environment file..."
cat > quiz-frontend/.env.production << EOF
REACT_APP_API_BASE_URL=http://$VM_EXTERNAL_IP:8080
NODE_ENV=production
EOF

# Update docker-compose.prod.yml
if [ -f "docker-compose.prod.yml" ]; then
    print_info "Updating docker-compose.prod.yml..."
    sed -i "s/34\.0\.14\.17/$VM_EXTERNAL_IP/g" docker-compose.prod.yml
    sed -i "s/REACT_APP_API_BASE_URL=http:\/\/[0-9.]*:8080/REACT_APP_API_BASE_URL=http:\/\/$VM_EXTERNAL_IP:8080/g" docker-compose.prod.yml
    print_success "Updated docker-compose.prod.yml"
    COMPOSE_FILE="docker-compose.prod.yml"
else
    print_warning "Using default docker-compose.yml"
    COMPOSE_FILE="docker-compose.yml"
fi

print_header "STEP 5: INSTALLING/UPDATING DOCKER COMPOSE"

# Check and install docker-compose
if ! command -v docker-compose >/dev/null 2>&1; then
    print_info "Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    
    # Add to PATH
    echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
    export PATH="/usr/local/bin:$PATH"
    
    print_success "Docker Compose installed"
else
    print_success "Docker Compose is available"
fi

# Verify docker-compose works
if /usr/local/bin/docker-compose --version >/dev/null 2>&1; then
    DOCKER_COMPOSE_CMD="/usr/local/bin/docker-compose"
elif docker-compose --version >/dev/null 2>&1; then
    DOCKER_COMPOSE_CMD="docker-compose"
elif docker compose version >/dev/null 2>&1; then
    DOCKER_COMPOSE_CMD="docker compose"
else
    print_error "Docker Compose is not working properly"
    exit 1
fi

print_success "Using Docker Compose: $DOCKER_COMPOSE_CMD"

print_header "STEP 6: FRESH BUILD AND DEPLOYMENT"

print_info "Building containers from scratch..."
if [ "$COMPOSE_FILE" = "docker-compose.prod.yml" ]; then
    $DOCKER_COMPOSE_CMD -f docker-compose.prod.yml build --no-cache --pull
else
    $DOCKER_COMPOSE_CMD build --no-cache --pull
fi

if [ $? -ne 0 ]; then
    print_error "Container build failed"
    exit 1
fi

print_success "Containers built successfully"

print_info "Starting services..."
if [ "$COMPOSE_FILE" = "docker-compose.prod.yml" ]; then
    $DOCKER_COMPOSE_CMD -f docker-compose.prod.yml up -d
else
    $DOCKER_COMPOSE_CMD up -d
fi

if [ $? -ne 0 ]; then
    print_error "Failed to start services"
    exit 1
fi

print_success "Services started"

print_header "STEP 7: WAITING FOR SERVICES TO INITIALIZE"

print_info "Waiting 2 minutes for services to fully initialize..."
sleep 120

# Check container status
print_info "Container status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

print_header "STEP 8: CONNECTIVITY TESTS"

# Test backend health
print_info "Testing backend API..."
for i in {1..15}; do
    if curl -f http://localhost:8080/api/questions/allQuestions >/dev/null 2>&1; then
        print_success "Backend API is responding"
        break
    else
        print_warning "Attempt $i/15: Backend API not ready yet..."
        sleep 10
    fi
done

# Test frontend
print_info "Testing frontend..."
for i in {1..10}; do
    if curl -f http://localhost:3000 >/dev/null 2>&1; then
        print_success "Frontend is responding"
        break
    else
        print_warning "Attempt $i/10: Frontend not ready yet..."
        sleep 10
    fi
done

# Test external access
print_info "Testing external access..."
if curl -f "http://$VM_EXTERNAL_IP:3000" >/dev/null 2>&1; then
    print_success "Frontend is accessible externally"
else
    print_warning "Frontend external access test failed"
fi

if curl -f "http://$VM_EXTERNAL_IP:8080/api/questions/allQuestions" >/dev/null 2>&1; then
    print_success "Backend is accessible externally"
else
    print_warning "Backend external access test failed"
fi

print_header "STEP 9: FINAL STATUS"

echo ""
print_success "🎉 FRESH DEPLOYMENT COMPLETED!"
echo ""
print_info "🌐 ACCESS YOUR UPDATED APPLICATION:"
echo "   Frontend: http://$VM_EXTERNAL_IP:3000"
echo "   Backend:  http://$VM_EXTERNAL_IP:8080"
echo "   Health:   http://$VM_EXTERNAL_IP:8080/api/questions/allQuestions"
echo ""
print_info "🔐 DEFAULT CREDENTIALS:"
echo "   Username: admin"
echo "   Password: admin123"
echo ""
print_info "📊 CURRENT CONTAINERS:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

# Clear browser cache notice
print_warning "🔄 IMPORTANT: Clear your browser cache or try incognito mode"
print_warning "   The old cached version might still show otherwise"
echo ""

print_info "📋 CONTAINER LOGS (if needed):"
echo "   Backend:  docker logs quiz-backend"
echo "   Frontend: docker logs quiz-frontend"
echo "   Database: docker logs quiz-database"

print_success "Deployment script completed!"
