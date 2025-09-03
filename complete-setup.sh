#!/bin/bash

# FullStackQuizApplication - Complete VM Setup Script
# This script configures everything needed for deployment

set -e  # Exit on any error

echo "🚀 FullStackQuizApplication - Complete Setup Starting..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Get VM metadata
print_status "Getting VM metadata..."
VM_EXTERNAL_IP=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)
VM_INTERNAL_IP=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip)
VM_NAME=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/name)
VM_ZONE=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/zone | cut -d'/' -f4)
PROJECT_ID=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/project/project-id)

print_success "VM Details:"
echo "  External IP: $VM_EXTERNAL_IP"
echo "  Internal IP: $VM_INTERNAL_IP"
echo "  VM Name: $VM_NAME"
echo "  Zone: $VM_ZONE"
echo "  Project ID: $PROJECT_ID"

# Check if running as root or with sudo
check_privileges() {
    if [[ $EUID -eq 0 ]]; then
        print_warning "Running as root"
        SUDO=""
    else
        print_status "Checking sudo privileges..."
        if sudo -n true 2>/dev/null; then
            SUDO="sudo"
            print_success "Sudo privileges confirmed"
        else
            print_error "This script requires sudo privileges"
            exit 1
        fi
    fi
}

# Install required packages
install_dependencies() {
    print_status "Installing required packages..."
    
    # Update package list
    $SUDO apt-get update -y
    
    # Install Docker if not present
    if ! command -v docker &> /dev/null; then
        print_status "Installing Docker..."
        $SUDO apt-get install -y docker.io
        $SUDO systemctl start docker
        $SUDO systemctl enable docker
        $SUDO usermod -aG docker $USER
        print_success "Docker installed"
    else
        print_success "Docker already installed"
    fi
    
    # Install Docker Compose if not present
    if ! command -v docker-compose &> /dev/null; then
        print_status "Installing Docker Compose..."
        $SUDO curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        $SUDO chmod +x /usr/local/bin/docker-compose
        print_success "Docker Compose installed"
    else
        print_success "Docker Compose already installed"
    fi
    
    # Install other utilities
    $SUDO apt-get install -y curl wget git net-tools
    print_success "Dependencies installed"
}

# Configure firewall rules
configure_firewall() {
    print_status "Configuring firewall rules..."
    
    # Create firewall rules for the application
    gcloud compute firewall-rules create allow-quiz-frontend \
        --allow tcp:3000 \
        --source-ranges 0.0.0.0/0 \
        --description "Allow access to Quiz Frontend" \
        --quiet 2>/dev/null || print_warning "Firewall rule 'allow-quiz-frontend' may already exist"
    
    gcloud compute firewall-rules create allow-quiz-backend \
        --allow tcp:8080 \
        --source-ranges 0.0.0.0/0 \
        --description "Allow access to Quiz Backend" \
        --quiet 2>/dev/null || print_warning "Firewall rule 'allow-quiz-backend' may already exist"
    
    gcloud compute firewall-rules create allow-quiz-database \
        --allow tcp:5432 \
        --source-ranges 0.0.0.0/0 \
        --description "Allow access to Quiz Database" \
        --quiet 2>/dev/null || print_warning "Firewall rule 'allow-quiz-database' may already exist"
    
    print_success "Firewall rules configured"
}

# Add network tags to VM
configure_vm_tags() {
    print_status "Adding network tags to VM..."
    
    gcloud compute instances add-tags $VM_NAME \
        --zone=$VM_ZONE \
        --tags=http-server,https-server,quiz-app \
        --quiet 2>/dev/null || print_warning "Network tags may already be set"
    
    print_success "VM tags configured"
}

# Clone or update repository
setup_repository() {
    print_status "Setting up repository..."
    
    if [ -d "FullStackQuizApplication" ]; then
        print_status "Repository exists, pulling latest changes..."
        cd FullStackQuizApplication
        git pull origin main
    else
        print_status "Cloning repository..."
        git clone https://github.com/KUNALM17/FullStackQuizApplication.git
        cd FullStackQuizApplication
    fi
    
    print_success "Repository ready"
}

# Configure environment
configure_environment() {
    print_status "Configuring environment..."
    
    # Update production docker-compose with current VM IP
    if [ -f "docker-compose.prod.yml" ]; then
        sed -i "s/34\.0\.14\.17/$VM_EXTERNAL_IP/g" docker-compose.prod.yml
        print_success "Production config updated with VM IP: $VM_EXTERNAL_IP"
    fi
    
    # Create environment file
    cat > .env << EOF
# Production Environment Configuration
VM_EXTERNAL_IP=$VM_EXTERNAL_IP
VM_INTERNAL_IP=$VM_INTERNAL_IP
VM_NAME=$VM_NAME
VM_ZONE=$VM_ZONE
PROJECT_ID=$PROJECT_ID

# Database Configuration
POSTGRES_DB=quizdb
POSTGRES_USER=quiz_user
POSTGRES_PASSWORD=quiz_password

# Application Configuration
SPRING_PROFILES_ACTIVE=prod
SERVER_PORT=8080
REACT_APP_API_BASE_URL=http://$VM_EXTERNAL_IP:8080
EOF
    
    print_success "Environment configured"
}

# Deploy application
deploy_application() {
    print_status "Deploying application..."
    
    # Stop existing containers
    docker-compose down 2>/dev/null || true
    
    # Clean up old images
    docker system prune -f
    
    # Build and start services
    if [ -f "docker-compose.prod.yml" ]; then
        docker-compose -f docker-compose.prod.yml up --build -d
    else
        docker-compose up --build -d
    fi
    
    print_success "Application deployed"
}

# Health checks
perform_health_checks() {
    print_status "Performing health checks..."
    
    # Wait for services to start
    sleep 30
    
    # Check container status
    print_status "Container Status:"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    
    # Test endpoints
    print_status "Testing endpoints..."
    
    # Test backend
    backend_status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/api/questions/allQuestions || echo "000")
    if [ "$backend_status" = "200" ]; then
        print_success "Backend is healthy (HTTP $backend_status)"
    else
        print_warning "Backend health check failed (HTTP $backend_status)"
    fi
    
    # Test frontend
    frontend_status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 || echo "000")
    if [ "$frontend_status" = "200" ]; then
        print_success "Frontend is healthy (HTTP $frontend_status)"
    else
        print_warning "Frontend health check failed (HTTP $frontend_status)"
    fi
    
    # Test database
    if docker exec quiz-database pg_isready -U quiz_user -d quizdb >/dev/null 2>&1; then
        print_success "Database is healthy"
    else
        print_warning "Database health check failed"
    fi
}

# Show final status
show_final_status() {
    print_success "🎉 Setup Complete!"
    echo ""
    echo "🌐 Access URLs:"
    echo "  Frontend: http://$VM_EXTERNAL_IP:3000"
    echo "  Backend API: http://$VM_EXTERNAL_IP:8080"
    echo "  Database: $VM_EXTERNAL_IP:5432"
    echo ""
    echo "📊 Application Status:"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    echo ""
    echo "📋 Useful Commands:"
    echo "  View logs: docker logs <container-name>"
    echo "  Restart app: docker-compose restart"
    echo "  Stop app: docker-compose down"
    echo "  Update app: git pull && docker-compose up --build -d"
    echo ""
    print_success "Your FullStackQuizApplication is ready! 🚀"
}

# Main execution
main() {
    print_status "Starting FullStackQuizApplication setup..."
    
    check_privileges
    install_dependencies
    configure_firewall
    configure_vm_tags
    setup_repository
    configure_environment
    deploy_application
    perform_health_checks
    show_final_status
}

# Run main function
main "$@"
