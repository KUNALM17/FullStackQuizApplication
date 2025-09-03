#!/bin/bash

echo "🔐 CREATING ADMIN USER VIA DATABASE"
echo "=================================="

# Configuration
DB_CONTAINER="fullstackquiz-postgres-1"
ADMIN_USERNAME="admin"
ADMIN_PASSWORD="123456"
# BCrypt hash for "123456" (rounds=10)
BCRYPT_HASH='$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd6RleH8qSBOcLTy'

# Check current users
echo "📊 Current users in database:"
docker exec -i $DB_CONTAINER psql -U postgres -d quizdb -c "
SELECT u.username, array_agg(r.role_name) as roles 
FROM users u 
LEFT JOIN user_roles ur ON u.id = ur.user_id 
LEFT JOIN roles r ON ur.role_name = r.role_name 
GROUP BY u.username, u.id;"

echo ""
echo "🔨 Creating admin user..."

# First, ensure ADMIN role exists in roles table
docker exec -i $DB_CONTAINER psql -U postgres -d quizdb -c "
INSERT INTO roles (role_name) 
VALUES ('ROLE_ADMIN') 
ON CONFLICT (role_name) DO NOTHING;
"

# Create admin user
docker exec -i $DB_CONTAINER psql -U postgres -d quizdb -c "
INSERT INTO users (username, password, email) 
VALUES ('$ADMIN_USERNAME', '$BCRYPT_HASH', 'admin@quiz.com')
ON CONFLICT (username) DO NOTHING;
"

# Get the user ID and assign ADMIN role
docker exec -i $DB_CONTAINER psql -U postgres -d quizdb -c "
INSERT INTO user_roles (user_id, role_name)
SELECT u.id, 'ROLE_ADMIN'
FROM users u 
WHERE u.username = '$ADMIN_USERNAME'
AND NOT EXISTS (
    SELECT 1 FROM user_roles ur 
    WHERE ur.user_id = u.id AND ur.role_name = 'ROLE_ADMIN'
);
"

echo ""
echo "✅ Admin user created successfully!"
echo ""
echo "📋 Login Credentials:"
echo "   Username: $ADMIN_USERNAME"
echo "   Password: $ADMIN_PASSWORD"
echo "   Role: ROLE_ADMIN"
echo ""
echo "🌐 Login at: http://34.0.14.17"

# Show updated users list
echo ""
echo "📊 Updated users list:"
docker exec -i $DB_CONTAINER psql -U postgres -d quizdb -c "
SELECT u.username, array_agg(r.role_name) as roles, u.email
FROM users u 
LEFT JOIN user_roles ur ON u.id = ur.user_id 
LEFT JOIN roles r ON ur.role_name = r.role_name 
GROUP BY u.username, u.id, u.email;"
