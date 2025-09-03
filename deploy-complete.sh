#!/bin/bash

# ================================================================
# Complete Google Cloud Configuration Script
# Project ID: extended-arcana-318009
# Project Name: My First Project
# Instance: instance-20250829-101008
# Location: asia-south2-c
# User: kunalmani10
# OS: Ubuntu 22.04.5 LTS
# ================================================================

# Set your project configuration
export PROJECT_ID="extended-arcana-318009"
export PROJECT_NAME="My First Project"
export VM_INSTANCE="instance-20250829-101008"
export VM_ZONE="asia-south2-c"
export VM_USER="kunalmani10"

echo "🚀 Complete Google Cloud VM Configuration"
echo "=================================================="
echo "📋 Project ID: $PROJECT_ID"
echo "📋 Project Name: $PROJECT_NAME"
echo "🖥️  Instance: $VM_INSTANCE"
echo "📍 Zone: $VM_ZONE"
echo "👤 User: $VM_USER"
echo "=================================================="

# Function to print colored output
print_status() {
    echo -e "\033[0;32m✅ $1\033[0m"
}

print_info() {
    echo -e "\033[0;34mℹ️  $1\033[0m"
}

print_warning() {
    echo -e "\033[1;33m⚠️  $1\033[0m"
}

# Set Google Cloud project
print_info "Setting Google Cloud project..."
gcloud config set project $PROJECT_ID

# Get VM external IP
print_info "Getting VM external IP..."
VM_EXTERNAL_IP=$(gcloud compute instances describe $VM_INSTANCE \
    --zone=$VM_ZONE \
    --project=$PROJECT_ID \
    --format="get(networkInterfaces[0].accessConfigs[0].natIP)")

if [ -z "$VM_EXTERNAL_IP" ]; then
    print_warning "Could not get VM external IP. VM might be stopped."
    print_info "Starting VM..."
    gcloud compute instances start $VM_INSTANCE --zone=$VM_ZONE --project=$PROJECT_ID
    sleep 30
    
    VM_EXTERNAL_IP=$(gcloud compute instances describe $VM_INSTANCE \
        --zone=$VM_ZONE \
        --project=$PROJECT_ID \
        --format="get(networkInterfaces[0].accessConfigs[0].natIP)")
fi

print_status "VM External IP: $VM_EXTERNAL_IP"

# Update environment configuration
print_info "Updating production environment configuration..."
cat > quiz-frontend/.env.production << EOF
REACT_APP_API_BASE_URL=http://$VM_EXTERNAL_IP:8080
NODE_ENV=production
EOF

# Update docker-compose.prod.yml
if [ -f "docker-compose.prod.yml" ]; then
    sed -i "s/34\.0\.14\.17/$VM_EXTERNAL_IP/g" docker-compose.prod.yml
    sed -i "s/REACT_APP_API_BASE_URL=http:\/\/[0-9.]*:8080/REACT_APP_API_BASE_URL=http:\/\/$VM_EXTERNAL_IP:8080/g" docker-compose.prod.yml
    print_status "Updated docker-compose.prod.yml"
fi

# Check/Create firewall rules
print_info "Checking firewall rules..."

# Check if firewall rules exist, create if not
if ! gcloud compute firewall-rules describe allow-quiz-frontend --project=$PROJECT_ID >/dev/null 2>&1; then
    print_info "Creating firewall rule for frontend (port 3000)..."
    gcloud compute firewall-rules create allow-quiz-frontend \
        --allow tcp:3000 \
        --source-ranges 0.0.0.0/0 \
        --description "Allow access to Quiz Frontend" \
        --project=$PROJECT_ID
    print_status "Created firewall rule: allow-quiz-frontend"
else
    print_status "Firewall rule allow-quiz-frontend already exists"
fi

if ! gcloud compute firewall-rules describe allow-quiz-backend --project=$PROJECT_ID >/dev/null 2>&1; then
    print_info "Creating firewall rule for backend (port 8080)..."
    gcloud compute firewall-rules create allow-quiz-backend \
        --allow tcp:8080 \
        --source-ranges 0.0.0.0/0 \
        --description "Allow access to Quiz Backend" \
        --project=$PROJECT_ID
    print_status "Created firewall rule: allow-quiz-backend"
else
    print_status "Firewall rule allow-quiz-backend already exists"
fi

# SSH to VM and deploy
print_info "Connecting to VM and deploying application..."

# Create deployment command
DEPLOY_COMMAND="cd FullStackQuizApplication && git pull origin main && chmod +x gcloud-deploy.sh && ./gcloud-deploy.sh"

# Execute deployment on VM
gcloud compute ssh $VM_USER@$VM_INSTANCE \
    --zone=$VM_ZONE \
    --project=$PROJECT_ID \
    --command="$DEPLOY_COMMAND"

# Final status
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
print_info "🌐 Access your Quiz Application:"
echo "   URL: http://$VM_EXTERNAL_IP:3000"
echo ""

# Show additional commands for management
print_info "📋 Useful Management Commands:"
echo ""
echo "# SSH to VM:"
echo "gcloud compute ssh $VM_USER@$VM_INSTANCE --zone=$VM_ZONE --project=$PROJECT_ID"
echo ""
echo "# Check VM status:"
echo "gcloud compute instances describe $VM_INSTANCE --zone=$VM_ZONE --project=$PROJECT_ID"
echo ""
echo "# Stop VM (to save costs):"
echo "gcloud compute instances stop $VM_INSTANCE --zone=$VM_ZONE --project=$PROJECT_ID"
echo ""
echo "# Start VM:"
echo "gcloud compute instances start $VM_INSTANCE --zone=$VM_ZONE --project=$PROJECT_ID"
echo ""

print_status "Configuration complete!"
