#!/bin/bash

# ================================================================
# COMPREHENSIVE DEBUGGING SCRIPT FOR GOOGLE CLOUD VM
# This script will diagnose and fix all deployment issues
# ================================================================

echo "🔍 STARTING COMPREHENSIVE DEBUGGING..."
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "\n${BLUE}========== $1 ==========${NC}"
}

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

# Check if we're on the VM
print_header "STEP 1: ENVIRONMENT CHECK"

if curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/name >/dev/null 2>&1; then
    print_success "Running on Google Cloud VM"
    VM_NAME=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/name)
    VM_ZONE=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/zone | cut -d'/' -f4)
    VM_EXTERNAL_IP=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)
    
    print_info "VM Name: $VM_NAME"
    print_info "VM Zone: $VM_ZONE"
    print_info "External IP: $VM_EXTERNAL_IP"
else
    print_error "Not running on Google Cloud VM or metadata service unavailable"
    exit 1
fi

# Check basic system info
print_header "STEP 2: SYSTEM INFORMATION"
print_info "OS: $(lsb_release -d | cut -f2)"
print_info "Kernel: $(uname -r)"
print_info "Uptime: $(uptime -p)"
print_info "Memory: $(free -h | grep Mem | awk '{print $3"/"$2}')"
print_info "Disk: $(df -h / | tail -1 | awk '{print $3"/"$2" ("$5" used)"}')"

# Check if we're in the right directory
print_header "STEP 3: PROJECT DIRECTORY CHECK"
if [ ! -d "FullStackQuizApplication" ]; then
    print_error "FullStackQuizApplication directory not found"
    print_info "Cloning repository..."
    git clone https://github.com/KUNALM17/FullStackQuizApplication.git
    if [ $? -eq 0 ]; then
        print_success "Repository cloned successfully"
    else
        print_error "Failed to clone repository"
        exit 1
    fi
fi

cd FullStackQuizApplication
print_success "In project directory: $(pwd)"

# Check git status
print_header "STEP 4: GIT STATUS CHECK"
git status --porcelain
if [ $? -eq 0 ]; then
    print_success "Git repository is healthy"
    print_info "Current branch: $(git branch --show-current)"
    print_info "Latest commit: $(git log -1 --pretty=format:'%h %s')"
else
    print_warning "Git repository has issues"
fi

# Update repository
print_info "Pulling latest changes..."
git pull origin main

# Check Docker installation
print_header "STEP 5: DOCKER CHECK"
if command -v docker >/dev/null 2>&1; then
    print_success "Docker is installed"
    print_info "Docker version: $(docker --version)"
    
    if docker ps >/dev/null 2>&1; then
        print_success "Docker daemon is running"
    else
        print_error "Docker daemon is not running"
        print_info "Starting Docker..."
        sudo systemctl start docker
        sudo systemctl enable docker
    fi
else
    print_error "Docker is not installed"
    print_info "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    print_warning "You may need to log out and back in for Docker group membership to take effect"
fi

# Check Docker Compose
if command -v docker-compose >/dev/null 2>&1 || docker compose version >/dev/null 2>&1; then
    print_success "Docker Compose is available"
else
    print_error "Docker Compose is not available"
    print_info "Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Check current containers
print_header "STEP 6: CURRENT CONTAINER STATUS"
echo "Current containers:"
docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Check for port conflicts
print_header "STEP 7: PORT AVAILABILITY CHECK"
ports_to_check=(3000 8080 5432)
for port in "${ports_to_check[@]}"; do
    if netstat -tuln | grep ":$port " >/dev/null 2>&1; then
        process=$(sudo lsof -ti:$port)
        if [ ! -z "$process" ]; then
            print_warning "Port $port is in use by process $process"
            ps -p $process -o pid,ppid,cmd
        else
            print_warning "Port $port appears to be in use"
        fi
    else
        print_success "Port $port is available"
    fi
done

# Stop existing containers
print_header "STEP 8: CLEANUP EXISTING CONTAINERS"
print_info "Stopping existing containers..."
docker-compose down 2>/dev/null || docker compose down 2>/dev/null
print_success "Stopped existing containers"

print_info "Cleaning up Docker system..."
docker system prune -f
print_success "Docker cleanup completed"

# Check environment files
print_header "STEP 9: ENVIRONMENT CONFIGURATION"
if [ -f "quiz-frontend/.env.production" ]; then
    print_success "Production environment file exists"
    echo "Content:"
    cat quiz-frontend/.env.production
else
    print_warning "Creating production environment file..."
    cat > quiz-frontend/.env.production << EOF
REACT_APP_API_BASE_URL=http://$VM_EXTERNAL_IP:8080
NODE_ENV=production
EOF
    print_success "Created production environment file"
fi

# Update docker-compose with correct IP
print_header "STEP 10: DOCKER COMPOSE CONFIGURATION"
if [ -f "docker-compose.prod.yml" ]; then
    print_info "Updating docker-compose.prod.yml with VM IP..."
    sed -i "s/34\.0\.14\.17/$VM_EXTERNAL_IP/g" docker-compose.prod.yml
    sed -i "s/REACT_APP_API_BASE_URL=http:\/\/[0-9.]*:8080/REACT_APP_API_BASE_URL=http:\/\/$VM_EXTERNAL_IP:8080/g" docker-compose.prod.yml
    print_success "Updated docker-compose.prod.yml"
    COMPOSE_FILE="docker-compose.prod.yml"
else
    print_warning "docker-compose.prod.yml not found, using docker-compose.yml"
    COMPOSE_FILE="docker-compose.yml"
fi

# Check firewall rules
print_header "STEP 11: FIREWALL CHECK"
print_info "Checking if ports are accessible externally..."

# Test if we can bind to the ports
for port in 3000 8080; do
    if timeout 5 bash -c "</dev/tcp/0.0.0.0/$port" 2>/dev/null; then
        print_warning "Port $port might be blocked or already in use"
    else
        print_success "Port $port appears to be available for binding"
    fi
done

# Build and start services
print_header "STEP 12: BUILDING AND STARTING SERVICES"
print_info "Building containers..."
if [ "$COMPOSE_FILE" = "docker-compose.prod.yml" ]; then
    docker-compose -f docker-compose.prod.yml build --no-cache
else
    docker-compose build --no-cache
fi

if [ $? -eq 0 ]; then
    print_success "Containers built successfully"
else
    print_error "Container build failed"
    exit 1
fi

print_info "Starting services..."
if [ "$COMPOSE_FILE" = "docker-compose.prod.yml" ]; then
    docker-compose -f docker-compose.prod.yml up -d
else
    docker-compose up -d
fi

if [ $? -eq 0 ]; then
    print_success "Services started"
else
    print_error "Failed to start services"
    exit 1
fi

# Wait for services to start
print_header "STEP 13: WAITING FOR SERVICES"
print_info "Waiting 60 seconds for services to initialize..."
sleep 60

# Check container status
print_info "Container status after startup:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Check container health
print_header "STEP 14: HEALTH CHECKS"
containers=("quiz-database" "quiz-backend" "quiz-frontend")
for container in "${containers[@]}"; do
    if docker ps | grep "$container" >/dev/null; then
        print_success "$container is running"
        
        # Check container logs for errors
        error_count=$(docker logs "$container" 2>&1 | grep -i error | wc -l)
        if [ $error_count -gt 0 ]; then
            print_warning "$container has $error_count error messages in logs"
        else
            print_success "$container logs look clean"
        fi
    else
        print_error "$container is not running"
        print_info "Checking logs for $container:"
        docker logs "$container" --tail 20
    fi
done

# Test internal connectivity
print_header "STEP 15: CONNECTIVITY TESTS"

# Test database
print_info "Testing database connection..."
if docker exec quiz-database pg_isready -U quiz_user -d quizdb >/dev/null 2>&1; then
    print_success "Database is ready"
else
    print_error "Database is not ready"
fi

# Test backend API
print_info "Testing backend API..."
sleep 10
if curl -f http://localhost:8080/api/questions/allQuestions >/dev/null 2>&1; then
    print_success "Backend API is responding"
else
    print_warning "Backend API is not responding yet, checking logs..."
    docker logs quiz-backend --tail 20
fi

# Test frontend
print_info "Testing frontend..."
if curl -f http://localhost:3000 >/dev/null 2>&1; then
    print_success "Frontend is responding"
else
    print_warning "Frontend is not responding yet, checking logs..."
    docker logs quiz-frontend --tail 20
fi

# Test external connectivity
print_header "STEP 16: EXTERNAL ACCESS TEST"
print_info "Testing external access to frontend..."
if curl -f "http://$VM_EXTERNAL_IP:3000" >/dev/null 2>&1; then
    print_success "Frontend is accessible externally"
else
    print_error "Frontend is NOT accessible externally"
    print_info "This could be due to:"
    print_info "  1. Firewall rules blocking the port"
    print_info "  2. Container not binding to external interface"
    print_info "  3. Service still starting up"
fi

print_info "Testing external access to backend..."
if curl -f "http://$VM_EXTERNAL_IP:8080/api/questions/allQuestions" >/dev/null 2>&1; then
    print_success "Backend is accessible externally"
else
    print_error "Backend is NOT accessible externally"
fi

# Show final status
print_header "STEP 17: FINAL STATUS REPORT"
echo ""
print_info "🌐 ACCESS INFORMATION:"
echo "   Frontend: http://$VM_EXTERNAL_IP:3000"
echo "   Backend:  http://$VM_EXTERNAL_IP:8080"
echo "   Health Check: http://$VM_EXTERNAL_IP:8080/api/questions/allQuestions"
echo ""

print_info "🔐 DEFAULT CREDENTIALS:"
echo "   Username: admin"
echo "   Password: admin123"
echo ""

print_info "📊 CURRENT STATUS:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

print_info "💾 DISK USAGE:"
docker system df
echo ""

# Show logs if there are issues
if ! curl -f "http://$VM_EXTERNAL_IP:3000" >/dev/null 2>&1; then
    print_header "TROUBLESHOOTING LOGS"
    print_info "Backend logs (last 30 lines):"
    docker logs quiz-backend --tail 30
    echo ""
    print_info "Frontend logs (last 30 lines):"
    docker logs quiz-frontend --tail 30
    echo ""
fi

print_header "DEBUG COMPLETE"
print_info "If services are still not accessible, check:"
print_info "1. Google Cloud firewall rules"
print_info "2. VM network tags"
print_info "3. Container logs: docker logs <container-name>"
print_info "4. Port availability: netstat -tuln | grep -E ':3000|:8080'"
