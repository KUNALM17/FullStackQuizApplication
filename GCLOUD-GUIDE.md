# Google Cloud VM Troubleshooting Guide
# Project ID: extended-arcana-318009
# Project Name: My First Project
# Instance: instance-20250829-101008
# Location: asia-south2-c

## Quick Deployment Commands

### Option 1: Run from Windows (Recommended)
```powershell
# Run this in PowerShell as Administrator
.\deploy-to-gcloud.ps1
```

### Option 2: Manual SSH to VM
```bash
# SSH to your VM
gcloud compute ssh kunalmani10@instance-20250829-101008 --zone=asia-south2-c --project=extended-arcana-318009

# Navigate to project and deploy
cd FullStackQuizApplication
git pull origin main
chmod +x gcloud-deploy.sh
./gcloud-deploy.sh
```

## Your VM Configuration
- **Project ID**: extended-arcana-318009
- **Project Name**: My First Project
- **Instance**: instance-20250829-101008
- **Zone**: asia-south2-c
- **User**: kunalmani10
- **OS**: Ubuntu 22.04.5 LTS
- **Machine Type**: e2-medium (2 vCPUs, 4 GB Memory)

## Common Issues & Solutions

### 1. Connection Timeout (ERR_CONNECTION_TIMED_OUT)
**Symptoms**: Cannot access http://VM_IP:3000 or http://VM_IP:8080

**Solutions**:
```bash
# Check if containers are running
docker ps

# Check if ports are listening
sudo netstat -tlnp | grep -E ':3000|:8080'

# Restart Docker services
docker-compose restart
```

### 2. Container Health Issues
**Symptoms**: Containers showing as "unhealthy"

**Solutions**:
```bash
# Check container logs
docker logs quiz-backend --tail 50
docker logs quiz-frontend --tail 50
docker logs quiz-database --tail 50

# Restart specific container
docker restart quiz-backend
docker restart quiz-frontend

# Rebuild if needed
docker-compose up --build -d
```

## Quick Access URLs
- Frontend: http://YOUR_VM_IP:3000
- Backend API: http://YOUR_VM_IP:8080
- Health Check: http://YOUR_VM_IP:8080/api/questions/allQuestions
