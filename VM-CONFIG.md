# Google Cloud VM Configuration Reference
# Your Exact Configuration Details

## Project Information
- **Project ID**: `extended-arcana-318009`
- **Project Name**: My First Project
- **Billing Account**: Active (required for VM operation)

## VM Instance Details
- **Instance Name**: `instance-20250829-101008`
- **Zone**: `asia-south2-c` (Mumbai, India)
- **Machine Type**: `e2-medium` (2 vCPUs, 4 GB Memory)
- **Boot Disk**: Ubuntu 22.04.5 LTS (50 GB)
- **Network**: Default VPC
- **External IP**: Dynamic (auto-assigned)

## Access Information
- **SSH Username**: `kunalmani10`
- **SSH Keys**: Configured and working
- **Serial Console**: Disabled
- **OS Login**: Disabled

## Network & Firewall
- **VPC Network**: default
- **Subnet**: default (asia-south2)
- **Internal IP**: 10.190.0.4
- **Firewall Tags**: http-server, https-server, web-server
- **Firewall Rules**:
  - allow-http-web-traffic (tcp:80)
  - allow-port-3000 (tcp:3000) - for frontend
  - default-allow-http (tcp:80)
  - default-allow-https (tcp:443)

## Application URLs (after deployment)
- **Frontend**: `http://[EXTERNAL_IP]:3000`
- **Backend API**: `http://[EXTERNAL_IP]:8080`
- **Health Check**: `http://[EXTERNAL_IP]:8080/api/questions/allQuestions`

## Quick Commands

### Connect to VM
```bash
gcloud compute ssh kunalmani10@instance-20250829-101008 --zone=asia-south2-c --project=extended-arcana-318009
```

### Get VM External IP
```bash
gcloud compute instances describe instance-20250829-101008 --zone=asia-south2-c --project=extended-arcana-318009 --format="get(networkInterfaces[0].accessConfigs[0].natIP)"
```

### Start VM
```bash
gcloud compute instances start instance-20250829-101008 --zone=asia-south2-c --project=extended-arcana-318009
```

### Stop VM
```bash
gcloud compute instances stop instance-20250829-101008 --zone=asia-south2-c --project=extended-arcana-318009
```

### Check VM Status
```bash
gcloud compute instances list --project=extended-arcana-318009
```

## Deployment Options

### Option 1: Windows Batch File (Easiest)
```cmd
deploy.bat
```

### Option 2: PowerShell (Recommended)
```powershell
.\deploy-to-gcloud.ps1
```

### Option 3: Bash Script (Advanced)
```bash
./deploy-complete.sh
```

### Option 4: Manual SSH
```bash
gcloud compute ssh kunalmani10@instance-20250829-101008 --zone=asia-south2-c --project=extended-arcana-318009
cd FullStackQuizApplication
git pull origin main
chmod +x gcloud-deploy.sh
./gcloud-deploy.sh
```

## Default Application Credentials
- **Admin Username**: admin
- **Admin Password**: admin123
- **User Registration**: Available at frontend

## Cost Optimization
- **Stop VM when not in use**: Saves compute costs
- **Disk is persistent**: Data preserved when VM is stopped
- **External IP**: Dynamic (free when VM is running)

## Support & Troubleshooting
- Check `GCLOUD-GUIDE.md` for detailed troubleshooting
- Check container logs: `docker logs quiz-backend`
- Check VM logs in Google Cloud Console
- Verify firewall rules are properly configured
