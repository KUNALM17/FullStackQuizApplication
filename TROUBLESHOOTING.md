# FullStackQuizApplication - Troubleshooting Guide

## 🔍 Common Issues and Solutions

### Issue 1: "This site can't be reached" (ERR_CONNECTION_TIMED_OUT)

**Symptoms:**
- Cannot access `http://VM_IP:3000` 
- Browser shows connection timeout

**Solutions:**
1. **Check Firewall Rules:**
   ```bash
   gcloud compute firewall-rules list --filter="name~allow-quiz"
   ```

2. **Verify VM Network Tags:**
   ```bash
   gcloud compute instances describe YOUR_VM_NAME --zone=YOUR_ZONE --format="get(tags.items)"
   ```

3. **Check Container Status:**
   ```bash
   docker ps -a
   docker logs quiz-frontend
   docker logs quiz-backend
   ```

### Issue 2: Frontend loads but API calls fail

**Symptoms:**
- Frontend loads but shows errors
- Network tab shows 404/500 errors for API calls

**Solutions:**
1. **Check Backend Container:**
   ```bash
   docker logs quiz-backend --tail 50
   ```

2. **Verify API URL Configuration:**
   ```bash
   # Check if environment variable is set correctly
   docker exec quiz-frontend env | grep REACT_APP_API_BASE_URL
   ```

3. **Test Backend Directly:**
   ```bash
   curl http://localhost:8080/api/questions/allQuestions
   ```

### Issue 3: Database Connection Issues

**Symptoms:**
- Backend logs show database connection errors
- Error: "Connection to localhost:5432 refused"

**Solutions:**
1. **Check Database Container:**
   ```bash
   docker logs quiz-database
   docker exec quiz-database pg_isready -U quiz_user -d quizdb
   ```

2. **Verify Database Network:**
   ```bash
   docker network ls
   docker network inspect fullstackquiz_quiz-network
   ```

### Issue 4: Containers Keep Restarting

**Symptoms:**
- `docker ps` shows containers with "Restarting" status
- Application intermittently unavailable

**Solutions:**
1. **Check Container Health:**
   ```bash
   docker inspect quiz-frontend | grep -A 10 Health
   docker inspect quiz-backend | grep -A 10 Health
   ```

2. **Check Resource Usage:**
   ```bash
   docker stats
   free -h
   df -h
   ```

3. **Increase VM Resources:**
   ```bash
   # Stop containers
   docker-compose down
   
   # Upgrade VM machine type
   gcloud compute instances set-machine-type VM_NAME \
     --machine-type=e2-standard-2 \
     --zone=ZONE
   
   # Restart containers
   docker-compose up -d
   ```

## 🛠️ Diagnostic Commands

### Quick Health Check
```bash
#!/bin/bash
echo "=== Container Status ==="
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo -e "\n=== Service Health ==="
echo "Frontend: $(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000)"
echo "Backend: $(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/api/questions/allQuestions)"
echo "Database: $(docker exec quiz-database pg_isready -U quiz_user -d quizdb && echo "OK" || echo "FAIL")"

echo -e "\n=== Network Info ==="
curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip
```

### View All Logs
```bash
echo "=== Frontend Logs ==="
docker logs quiz-frontend --tail 20

echo -e "\n=== Backend Logs ==="
docker logs quiz-backend --tail 20

echo -e "\n=== Database Logs ==="
docker logs quiz-database --tail 20
```

### Reset Everything
```bash
#!/bin/bash
echo "🔄 Resetting application..."

# Stop and remove all containers
docker-compose down -v

# Remove all images
docker rmi $(docker images -q) -f

# Clean system
docker system prune -af

# Rebuild and start
docker-compose up --build -d

echo "✅ Reset complete"
```

## 📋 Configuration Checklist

### Google Cloud Setup
- [ ] Project ID configured
- [ ] VM instance running
- [ ] External IP assigned
- [ ] Firewall rules created for ports 3000, 8080, 5432
- [ ] Network tags added (http-server, https-server)
- [ ] Docker and Docker Compose installed

### Application Setup
- [ ] Repository cloned
- [ ] Environment variables set
- [ ] Docker containers running
- [ ] Database initialized
- [ ] Frontend building successfully
- [ ] Backend API responding

### Security Setup
- [ ] Database password set
- [ ] JWT secret configured
- [ ] CORS enabled for frontend domain
- [ ] Firewall rules restricted to necessary ports

## 🚨 Emergency Recovery

If everything fails:

1. **Complete Reset:**
   ```bash
   cd FullStackQuizApplication
   ./complete-setup.sh
   ```

2. **Manual Step-by-Step:**
   ```bash
   # Update repository
   git pull origin main
   
   # Stop everything
   docker-compose down -v
   
   # Get VM IP
   VM_IP=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)
   
   # Update configuration
   sed -i "s/34\.0\.14\.17/$VM_IP/g" docker-compose.prod.yml
   
   # Rebuild
   docker-compose -f docker-compose.prod.yml up --build -d
   ```

## 📞 Support Information

If you're still having issues:

1. Run the diagnostic commands above
2. Check the logs for specific error messages
3. Verify your Google Cloud configuration
4. Ensure your VM has sufficient resources (2GB+ RAM recommended)

## 🔗 Useful Links

- [Google Cloud Firewall Rules](https://cloud.google.com/vpc/docs/firewalls)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [React Environment Variables](https://create-react-app.dev/docs/adding-custom-environment-variables/)
