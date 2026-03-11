# Full Stack Quiz Application 🧠

> A production-ready, containerized quiz platform with **role-based authentication**, built with **React**, **Spring Boot**, and **PostgreSQL** — fully deployable with a single Docker Compose command.

[![Java](https://img.shields.io/badge/Java-21-orange?logo=openjdk)](https://openjdk.org/projects/jdk/21/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.5.3-brightgreen?logo=springboot)](https://spring.io/projects/spring-boot)
[![React](https://img.shields.io/badge/React-19-blue?logo=react)](https://reactjs.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-316192?logo=postgresql)](https://www.postgresql.org/)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker)](https://docs.docker.com/compose/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 📋 Table of Contents

1. [Overview](#-overview)
2. [Features](#-features)
3. [Tech Stack](#️-tech-stack)
4. [Prerequisites](#-prerequisites)
5. [Installation & Setup](#-installation--setup)
6. [Project Structure](#-project-structure)
7. [Database Setup](#️-database-setup)
8. [API Documentation](#-api-documentation)
9. [Running the Application](#-running-the-application)
10. [Docker Support](#-docker-support)
11. [Configuration](#️-configuration)
12. [Contributing](#-contributing)
13. [License](#-license)
14. [Support & Contact](#-support--contact)

---

## 🌐 Overview

The **Full Stack Quiz Application** is a complete, production-ready web platform that allows users to register, log in, browse quizzes, and test their knowledge across multiple technology categories. Administrators have a dedicated dashboard to manage questions, create quizzes, and control user roles — all secured with **JWT-based authentication** and **Spring Security role-based access control**.

### Architecture

```
┌──────────────────────┐      HTTP/REST       ┌──────────────────────┐      JDBC       ┌──────────────────────┐
│    React Frontend    │ ◄─────────────────► │  Spring Boot API     │ ◄────────────► │     PostgreSQL       │
│  (Nginx · Port 3000) │                      │  (Java 21 · Port 8080│                │   (Port 5432)        │
└──────────────────────┘                      └──────────────────────┘                └──────────────────────┘
         │                                             │
    Tailwind CSS                          JWT + Spring Security
    Role-Based UI                         Role-Based Endpoints
```

---

## ✨ Features

### For Users
- 🔐 **Secure Registration & Login** — JWT token authentication with 24-hour expiry
- 📋 **Browse Quiz Catalog** — View all available quizzes in a responsive card grid
- 🎯 **Interactive Quiz Taking** — Navigate through questions with Previous/Next controls
- ✅ **Instant Score Results** — Get your score immediately upon submission

### For Administrators
- 🛠️ **Question Bank Management** — Add, update, and delete questions with category and difficulty tagging
- 📚 **Quiz Creation & Deletion** — Generate quizzes from any category with a configurable number of random questions
- 👥 **User Management** — Create users and assign roles (ADMIN / USER)
- 📊 **Category Filtering** — Filter and browse questions by category

### Platform-Wide
- 🔒 **Role-Based Access Control** — Strict separation between ADMIN and USER endpoints
- 🐳 **One-Command Deployment** — Full Docker Compose setup with health checks
- 🌐 **CORS Support** — Pre-configured for local and production origins
- 📈 **Health Monitoring** — Spring Boot Actuator health endpoint
- 📝 **Structured Logging** — Application logs written to file and console

---

## 🛠️ Tech Stack

### Backend
| Technology | Version | Purpose |
|---|---|---|
| Java | 21 | Programming language |
| Spring Boot | 3.5.3 | Application framework |
| Spring Security | 6.x | Authentication & authorization |
| Spring Data JPA | 3.x | ORM / data persistence |
| Hibernate | 6.x | JPA implementation |
| PostgreSQL Driver | Latest | Database connectivity |
| JJWT | 0.11.5 | JWT token generation & validation |
| Lombok | Latest | Boilerplate reduction |
| Maven | 3.x | Build & dependency management |
| Spring Boot Actuator | 3.x | Health checks & monitoring |

### Frontend
| Technology | Version | Purpose |
|---|---|---|
| React | 19.1.1 | UI component library |
| Tailwind CSS | 3.4.3 | Utility-first CSS styling |
| JavaScript | ES6+ | Programming language |
| npm | Latest | Package management |

### DevOps & Infrastructure
| Technology | Version | Purpose |
|---|---|---|
| Docker | Latest | Containerization |
| Docker Compose | V2 | Multi-container orchestration |
| PostgreSQL | 15-alpine | Relational database |
| Nginx | Alpine | Frontend static server & reverse proxy |
| Eclipse Temurin | JDK 21 | JVM runtime |

---

## 📦 Prerequisites

Before you begin, ensure you have the following installed:

| Tool | Minimum Version | Notes |
|---|---|---|
| [Docker Desktop](https://www.docker.com/products/docker-desktop/) | 24.0+ | Includes Docker Compose V2 |
| [Git](https://git-scm.com/) | 2.x | For cloning the repository |
| [Java JDK](https://adoptium.net/) | 21 | For local backend development only |
| [Node.js](https://nodejs.org/) | 18.x LTS | For local frontend development only |
| [npm](https://www.npmjs.com/) | 9.x+ | Bundled with Node.js |
| [PostgreSQL](https://www.postgresql.org/) | 15.x | For local development only (not needed for Docker) |

> **Note:** For running with Docker, only Docker Desktop and Git are required.

---

## 🚀 Installation & Setup

### Option 1: Docker (Recommended)

The fastest way to get the full application running.

```bash
# 1. Clone the repository
git clone https://github.com/KUNALM17/FullStackQuizApplication.git
cd FullStackQuizApplication

# 2. Build and start all services
docker compose up --build

# 3. Access the application
#    Frontend:  http://localhost:3000
#    Backend:   http://localhost:8080
#    Database:  localhost:5432
```

---

### Option 2: Local Development Setup

#### Backend Setup

```bash
# 1. Start only the database via Docker
docker compose up database -d

# 2. Verify the database is ready
docker compose ps

# 3. Configure the local application properties
#    Edit src/main/resources/application.properties:
#    spring.datasource.url=jdbc:postgresql://localhost:5432/NewQuizAppdb
#    spring.datasource.username=postgres
#    spring.datasource.password=<your-password>

# 4. Build and run the Spring Boot application
./mvnw spring-boot:run
# Windows:
mvnw.cmd spring-boot:run

# Backend will be available at: http://localhost:8080
```

#### Frontend Setup

```bash
# 1. Navigate to the frontend directory
cd quiz-frontend

# 2. Install all dependencies
npm install

# 3. (Optional) Set API URL for local development
#    The default is already set in .env.development:
#    REACT_APP_API_BASE_URL=http://localhost:8080

# 4. Start the development server
npm start

# Frontend will be available at: http://localhost:3000
```

---

## 📁 Project Structure

```
FullStackQuizApplication/
│
├── src/                                        # Backend Spring Boot source
│   ├── main/
│   │   ├── java/com/example/demo/
│   │   │   ├── Controller/
│   │   │   │   ├── QuestionController.java     # Admin: question CRUD
│   │   │   │   ├── QuizController.java         # Quiz management & submission
│   │   │   │   └── UserQuestionController.java # User-facing endpoints
│   │   │   ├── Service/
│   │   │   │   ├── QuestionService.java        # Question business logic
│   │   │   │   └── QuizService.java            # Quiz business logic
│   │   │   ├── Model/
│   │   │   │   ├── Question.java               # Question entity
│   │   │   │   ├── Quiz.java                   # Quiz entity
│   │   │   │   ├── QuestionWrapper.java        # Safe DTO (no answer field)
│   │   │   │   └── Response.java               # User answer submission DTO
│   │   │   ├── Dao/
│   │   │   │   ├── QuestionDao.java            # Question JPA repository
│   │   │   │   └── QuizDao.java                # Quiz JPA repository
│   │   │   ├── security/
│   │   │   │   ├── controller/
│   │   │   │   │   └── AuthController.java     # Register & login endpoints
│   │   │   │   ├── service/
│   │   │   │   │   └── CustomUserDetailsService.java
│   │   │   │   ├── jwt/
│   │   │   │   │   ├── JwtUtil.java            # Token generation & validation
│   │   │   │   │   └── JwtRequestFilter.java   # JWT request interceptor
│   │   │   │   ├── model/
│   │   │   │   │   ├── User.java               # User entity
│   │   │   │   │   └── Role.java               # Role entity
│   │   │   │   ├── repo/
│   │   │   │   │   ├── UserRepository.java
│   │   │   │   │   └── RoleRepository.java
│   │   │   │   └── config/
│   │   │   │       ├── SecurityConfig.java     # Spring Security filter chain
│   │   │   │       └── DataInitializer.java    # Seeds ADMIN & USER roles
│   │   │   └── NewQuizApplication.java         # Main Spring Boot entry point
│   │   └── resources/
│   │       ├── application.properties          # Local development config
│   │       └── application-docker.properties   # Docker profile config
│   └── test/
│       └── java/com/example/demo/
│           └── NewQuizApplicationTests.java
│
├── quiz-frontend/                              # React frontend application
│   ├── public/
│   │   └── index.html
│   ├── src/
│   │   ├── App.js                             # Main app component (all pages)
│   │   ├── index.js                           # React entry point
│   │   └── index.css                          # Global styles
│   ├── .env.development                       # Dev environment variables
│   ├── .env.production                        # Production environment variables
│   ├── tailwind.config.js
│   ├── postcss.config.js
│   ├── package.json
│   └── Dockerfile                             # Frontend container (Node + Nginx)
│
├── Dockerfile                                 # Backend container (Maven + JRE)
├── docker-compose.yml                         # Multi-service orchestration
├── init.sql                                   # Database seed data
├── pom.xml                                    # Maven project configuration
├── mvnw / mvnw.cmd                            # Maven wrapper scripts
└── .gitignore
```

---

## 🗄️ Database Setup

### Automatic Setup (Docker)

When running with Docker Compose, the PostgreSQL database is automatically created and initialized. The `init.sql` script seeds sample questions on first startup.

### Manual Setup (Local Development)

```sql
-- Create the database for local development
-- (matches application.properties: spring.datasource.url=jdbc:postgresql://localhost:5432/NewQuizAppdb)
CREATE DATABASE "NewQuizAppdb";
GRANT ALL PRIVILEGES ON DATABASE "NewQuizAppdb" TO postgres;
```

> **Note:** The Docker environment uses `quiz_db` (configured in `docker-compose.yml` and `application-docker.properties`). For local development, the database name is `NewQuizAppdb` as set in `src/main/resources/application.properties`. Update the datasource URL in `application.properties` if you prefer a different name.

### Schema

Tables are **auto-created by Hibernate** (`spring.jpa.hibernate.ddl-auto=update`). The schema is as follows:

| Table | Description |
|---|---|
| `question` | Stores all quiz questions with options and answers |
| `quiz` | Stores quiz metadata (id, title) |
| `quiz_question` | Many-to-many join table linking quizzes to questions |
| `users` | Stores registered user accounts |
| `roles` | Stores role definitions (ADMIN, USER) |
| `user_roles` | Many-to-many join table linking users to roles |

#### `question` Table

```
id              SERIAL PRIMARY KEY
question_title  VARCHAR
option1         VARCHAR
option2         VARCHAR
option3         VARCHAR
option4         VARCHAR
right_answer    VARCHAR
difficult_level VARCHAR   -- Easy | Medium | Hard
category        VARCHAR   -- Java | Python | JavaScript | etc.
```

#### `users` Table

```
id        BIGSERIAL PRIMARY KEY
username  VARCHAR UNIQUE NOT NULL
password  VARCHAR NOT NULL           -- BCrypt hashed
email     VARCHAR                    -- Optional
```

### Seed Data (`init.sql`)

The `init.sql` file inserts 5 sample questions (Java, Python, JavaScript) if the table is empty:

```sql
-- Example seed entry
INSERT INTO question (id, category, difficult_level, option1, option2, option3, option4, question_title, right_answer)
SELECT 1, 'Java', 'Easy', 'class', 'interface', 'extends', 'implements',
       'Which Java keyword is used to create a subclass?', 'extends'
WHERE NOT EXISTS (SELECT 1 FROM question WHERE id = 1);
```

---

## 📚 API Documentation

All protected endpoints require a `Bearer` JWT token in the `Authorization` header:

```
Authorization: Bearer <your_jwt_token>
```

### Authentication Endpoints

| Method | Endpoint | Auth | Description | Request Body |
|---|---|---|---|---|
| `POST` | `/auth/register` | Public | Register a new USER account | `{ "username", "password", "email" }` |
| `POST` | `/auth/admin/register` | `ADMIN` | Register a user with a specific role | `{ "username", "password", "email", "roles": ["ADMIN"] }` |
| `POST` | `/auth/login` | Public | Authenticate and receive a JWT token | `{ "username", "password" }` |

**Login Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "roles": ["ROLE_USER"]
}
```

---

### Question Endpoints (Admin Only)

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| `GET` | `/admin/question/allQuestions` | `ADMIN` | Retrieve all questions |
| `GET` | `/admin/question/categories` | `ADMIN` | Retrieve all distinct categories |
| `GET` | `/admin/question/category/{category}` | `ADMIN` | Retrieve questions by category |
| `GET` | `/admin/question/id/{id}` | `ADMIN` | Retrieve a question by ID |
| `POST` | `/admin/question/addQuestions` | `ADMIN` | Create a new question |
| `PUT` | `/admin/question/update/{id}` | `ADMIN` | Update an existing question |
| `DELETE` | `/admin/question/delete/{id}` | `ADMIN` | Delete a question by ID |

**Create Question — Request Body:**
```json
{
  "questionTitle": "Which Java keyword is used to create a subclass?",
  "option1": "class",
  "option2": "interface",
  "option3": "extends",
  "option4": "implements",
  "rightAnswer": "extends",
  "category": "Java",
  "difficultylevel": "Easy"
}
```

---

### Quiz Endpoints

| Method | Endpoint | Auth | Description | Query Params |
|---|---|---|---|---|
| `GET` | `/user/quiz/all` | `USER` / `ADMIN` | Get all available quizzes | — |
| `GET` | `/user/quiz/get/{id}` | `USER` / `ADMIN` | Get quiz questions (answers hidden) | — |
| `POST` | `/user/quiz/submit/{id}` | `USER` / `ADMIN` | Submit answers and receive score | — |
| `POST` | `/admin/quiz/create` | `ADMIN` | Create a quiz from a category | `category`, `numQ`, `title` |
| `DELETE` | `/admin/quiz/delete/{id}` | `ADMIN` | Delete a specific quiz | — |
| `DELETE` | `/admin/quiz/delete/all` | `ADMIN` | Delete all quizzes | — |

**Create Quiz — Example Request:**
```bash
POST /admin/quiz/create?category=Java&numQ=10&title=Java%20Basics
Authorization: Bearer <admin_token>
```

**Submit Quiz — Request Body:**
```json
[
  { "id": 1, "response": "extends" },
  { "id": 2, "response": "All of the above" }
]
```

**Submit Quiz — Response:**
```json
{ "score": 2 }
```

---

### Health Check

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| `GET` | `/actuator/health` | Public | Spring Boot health status |

---

## ▶️ Running the Application

### With Docker Compose (Full Stack)

```bash
# Start all services (database, backend, frontend)
docker compose up --build

# Start in detached (background) mode
docker compose up --build -d

# Stop all services
docker compose down

# Stop and remove volumes (wipes database data)
docker compose down -v
```

Access the services:
- **Frontend (UI):** http://localhost:3000
- **Backend API:** http://localhost:8080
- **Database:** `localhost:5432` (credentials: `quiz_user` / `quiz_password`)

### Local Development (Individual Services)

```bash
# Backend only (requires local PostgreSQL or Docker DB)
./mvnw spring-boot:run

# Frontend only (requires backend running)
cd quiz-frontend && npm start

# Database only (via Docker)
docker compose up database -d
```

---

## 🐳 Docker Support

The application uses a **three-service Docker Compose** setup with multi-stage Dockerfiles for optimized image sizes and proper dependency ordering via health checks.

### Services

| Service | Image | Port | Description |
|---|---|---|---|
| `database` | `postgres:15-alpine` | `5432` | PostgreSQL database with persistent volume |
| `backend` | Custom (Maven + JRE 21) | `8080` | Spring Boot REST API |
| `frontend` | Custom (Node 18 + Nginx) | `3000` | React SPA served by Nginx |

### Startup Order

```
database (health: pg_isready)
    └── backend (health: /actuator/health)
            └── frontend (serves after backend is healthy)
```

### View Logs

```bash
# All services
docker compose logs -f

# Individual service
docker compose logs -f backend
docker compose logs -f frontend
docker compose logs -f database
```

### Rebuild a Single Service

```bash
docker compose up --build backend
docker compose up --build frontend
```

### Troubleshooting Docker

| Issue | Solution |
|---|---|
| Port conflict on 3000/8080/5432 | Stop conflicting services or change ports in `docker-compose.yml` |
| Backend fails to connect to DB | Wait for DB health check; run `docker compose ps` to verify |
| Old cache causing build issues | Run `docker system prune -f` then rebuild |
| JWT errors on login | Ensure `JWT_SECRET` is at least 32 characters |

---

## ⚙️ Configuration

### Backend Environment Variables

Set these in `docker-compose.yml` or export them before running locally:

| Variable | Default (Docker) | Description |
|---|---|---|
| `SPRING_PROFILES_ACTIVE` | `docker` | Active Spring profile |
| `SPRING_DATASOURCE_URL` | `jdbc:postgresql://database:5432/quiz_db` | Database JDBC URL |
| `SPRING_DATASOURCE_USERNAME` | `quiz_user` | Database username |
| `SPRING_DATASOURCE_PASSWORD` | `quiz_password` | Database password |
| `JWT_SECRET` | `myVerySecureSecretKey...` | Secret for signing JWT tokens (min 32 chars) |
| `JWT_EXPIRATION` | `86400` | Token expiry in seconds (default: 24 hours) |

### Frontend Environment Variables

Defined in `quiz-frontend/.env.development` and `quiz-frontend/.env.production`:

| Variable | Development Value | Description |
|---|---|---|
| `REACT_APP_API_BASE_URL` | `http://localhost:8080` | Backend API base URL |

### Local Backend Configuration (`application.properties`)

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/NewQuizAppdb
spring.datasource.username=postgres
spring.datasource.password=<your-password>
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
jwt.secret=mySecretKeyThatIsAtLeast256BitsLongForHS256Algorithm
jwt.expiration-ms=86400000
```

### Security Notes

- **Change `JWT_SECRET`** before deploying to production — use a randomly generated 256-bit key
- Passwords are stored as **BCrypt hashes** (10 rounds)
- JWT tokens expire after **24 hours** by default
- CORS is pre-configured for `http://localhost:3000` and can be extended in `SecurityConfig.java`

---

## 🤝 Contributing

Contributions are welcome! Follow these steps:

1. **Fork** the repository on GitHub
2. **Clone** your fork:
   ```bash
   git clone https://github.com/<your-username>/FullStackQuizApplication.git
   ```
3. **Create a feature branch:**
   ```bash
   git checkout -b feature/your-feature-name
   ```
4. **Make your changes** and write clear commit messages:
   ```bash
   git commit -m "feat: add question import from CSV"
   ```
5. **Push** to your branch:
   ```bash
   git push origin feature/your-feature-name
   ```
6. **Open a Pull Request** against the `main` branch

### Code Guidelines

- Follow existing Java package structure (`Controller`, `Service`, `Model`, `Dao`)
- Use Lombok annotations to reduce boilerplate
- All admin endpoints must be under `/admin/**` path
- All user endpoints must be under `/user/**` path
- Frontend state management stays within `App.js` until component splitting is needed

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

```
MIT License — Copyright (c) 2026 Kunal M
```

---

## 💬 Support & Contact

| Channel | Link |
|---|---|
| 🐛 **Bug Reports** | [Open a GitHub Issue](https://github.com/KUNALM17/FullStackQuizApplication/issues) |
| 💡 **Feature Requests** | [GitHub Issues](https://github.com/KUNALM17/FullStackQuizApplication/issues) |
| 👨‍💻 **Author** | [KUNAL M — @KUNALM17](https://github.com/KUNALM17) |

---

<div align="center">
  <strong>Happy Quizzing! 🎉</strong><br/>
  If you find this project useful, please consider giving it a ⭐ on GitHub!
</div>
