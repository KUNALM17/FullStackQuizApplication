# Docker Setup Instructions

This document provides instructions for running the Full Stack Quiz Application using Docker containers.

## Prerequisites

- Docker Desktop installed on your system
- Docker Compose installed (usually comes with Docker Desktop)

## Project Structure

```
FullStackQuiz/
├── Dockerfile                          # Backend Dockerfile
├── docker-compose.yml                  # Docker Compose configuration
├── .dockerignore                       # Backend Docker ignore
├── init.sql                           # Database initialization script
├── src/main/resources/
│   └── application-docker.properties   # Docker-specific configuration
└── quiz-frontend/
    ├── Dockerfile                      # Frontend Dockerfile
    └── .dockerignore                  # Frontend Docker ignore
```

## Services

The application consists of three services:

1. **Database (PostgreSQL)**: Stores quiz questions and user data
2. **Backend (Spring Boot)**: REST API server
3. **Frontend (React/Nginx)**: User interface

## Getting Started

### 1. Build and Run All Services

```bash
# Clone the repository (if not already done)
git clone <repository-url>
cd FullStackQuiz

# Build and start all services
docker-compose up --build
```

### 2. Access the Application

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8080
- **Database**: localhost:5432 (if you need direct access)

### 3. Stop the Application

```bash
# Stop all services
docker-compose down

# Stop and remove volumes (will delete database data)
docker-compose down -v
```

## Individual Service Commands

### Backend Only
```bash
# Build backend image
docker build -t quiz-backend .

# Run backend container
docker run -p 8080:8080 --name quiz-backend quiz-backend
```

### Frontend Only
```bash
# Navigate to frontend directory
cd quiz-frontend

# Build frontend image
docker build -t quiz-frontend .

# Run frontend container
docker run -p 3000:80 --name quiz-frontend quiz-frontend
```

### Database Only
```bash
# Run PostgreSQL container
docker run -d \
  --name quiz-database \
  -e POSTGRES_DB=quiz_db \
  -e POSTGRES_USER=quiz_user \
  -e POSTGRES_PASSWORD=quiz_password \
  -p 5432:5432 \
  postgres:15-alpine
```

## Environment Variables

The following environment variables can be customized in `docker-compose.yml`:

### Database
- `POSTGRES_DB`: Database name (default: quiz_db)
- `POSTGRES_USER`: Database user (default: quiz_user)
- `POSTGRES_PASSWORD`: Database password (default: quiz_password)

### Backend
- `SPRING_PROFILES_ACTIVE`: Spring profile (default: docker)
- `SPRING_DATASOURCE_URL`: Database connection URL
- `SPRING_DATASOURCE_USERNAME`: Database username
- `SPRING_DATASOURCE_PASSWORD`: Database password
- `JWT_SECRET`: JWT secret key for authentication
- `JWT_EXPIRATION`: JWT token expiration time in seconds

## Volumes and Data Persistence

- **Database Data**: Stored in Docker volume `postgres_data`
- **Application Logs**: Mounted to `./logs` directory on host

## Health Checks

All services include health checks:

- **Database**: PostgreSQL ready check
- **Backend**: Spring Boot Actuator health endpoint
- **Frontend**: HTTP response check

## Troubleshooting

### Common Issues

1. **Port Already in Use**
   ```bash
   # Check what's using the port
   netstat -an | grep :8080
   
   # Kill the process or change port in docker-compose.yml
   ```

2. **Database Connection Issues**
   ```bash
   # Check database logs
   docker-compose logs database
   
   # Check backend logs
   docker-compose logs backend
   ```

3. **Frontend API Connection Issues**
   - Ensure backend is running and healthy
   - Check network connectivity between containers
   - Verify API proxy configuration in frontend Dockerfile

### Useful Commands

```bash
# View logs for all services
docker-compose logs

# View logs for specific service
docker-compose logs backend

# Follow logs in real-time
docker-compose logs -f

# Check service status
docker-compose ps

# Restart specific service
docker-compose restart backend

# Rebuild specific service
docker-compose up --build backend

# Execute command in running container
docker-compose exec backend bash
```

### Database Access

To access the PostgreSQL database directly:

```bash
# Connect to database container
docker-compose exec database psql -U quiz_user -d quiz_db

# Or from host (if PostgreSQL client is installed)
psql -h localhost -p 5432 -U quiz_user -d quiz_db
```

## Production Considerations

For production deployment, consider:

1. **Security**:
   - Change default passwords
   - Use secrets management
   - Enable HTTPS
   - Configure proper CORS settings

2. **Performance**:
   - Use production database
   - Configure connection pooling
   - Set appropriate JVM heap size
   - Use CDN for static assets

3. **Monitoring**:
   - Set up logging aggregation
   - Configure monitoring tools
   - Set up alerting

4. **Scaling**:
   - Use container orchestration (Kubernetes)
   - Configure load balancing
   - Set up auto-scaling policies

## Development

For development with hot reloading:

```bash
# Start only database
docker-compose up database

# Run backend and frontend locally with your IDE
# Configure application.properties to connect to database at localhost:5432
```
