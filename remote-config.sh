#!/bin/bash

# Remote Configuration Script
# Run this from your local machine to configure Google Cloud settings

# Configuration Variables (UPDATE THESE)
PROJECT_ID="your-project-id"           # Replace with your actual project ID
VM_NAME="quiz-app-vm"                  # Replace with your VM name
VM_ZONE="us-central1-a"                # Replace with your VM zone
VM_EXTERNAL_IP="34.0.14.17"           # Your current VM IP

echo "🔧 Configuring Google Cloud for FullStackQuizApplication..."

# Set the project
gcloud config set project $PROJECT_ID

# Create firewall rules
echo "Creating firewall rules..."

gcloud compute firewall-rules create allow-quiz-frontend \
    --allow tcp:3000 \
    --source-ranges 0.0.0.0/0 \
    --description "Allow access to Quiz Frontend" \
    --project=$PROJECT_ID

gcloud compute firewall-rules create allow-quiz-backend \
    --allow tcp:8080 \
    --source-ranges 0.0.0.0/0 \
    --description "Allow access to Quiz Backend" \
    --project=$PROJECT_ID

gcloud compute firewall-rules create allow-quiz-db \
    --allow tcp:5432 \
    --source-ranges 0.0.0.0/0 \
    --description "Allow access to Quiz Database" \
    --project=$PROJECT_ID

# Add network tags to VM
echo "Adding network tags to VM..."
gcloud compute instances add-tags $VM_NAME \
    --zone=$VM_ZONE \
    --tags=http-server,https-server,quiz-app \
    --project=$PROJECT_ID

# Copy setup script to VM and execute
echo "Deploying setup script to VM..."
gcloud compute scp complete-setup.sh $VM_NAME:~/ \
    --zone=$VM_ZONE \
    --project=$PROJECT_ID

echo "Executing setup on VM..."
gcloud compute ssh $VM_NAME \
    --zone=$VM_ZONE \
    --project=$PROJECT_ID \
    --command="chmod +x ~/complete-setup.sh && ~/complete-setup.sh"

echo "✅ Remote configuration complete!"
echo "🌐 Your application should be available at: http://$VM_EXTERNAL_IP:3000"
