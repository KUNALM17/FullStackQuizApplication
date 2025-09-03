#!/bin/bash

echo "🔐 CREATING ADMIN USER VIA DATABASE"
echo "=================================="

echo "📊 Current users in database:"
docker exec quiz-database psql -U quiz_user -d quiz_db -c "SELECT username, role FROM users;"

echo ""
echo "🔨 Creating admin user..."

# Create admin user with BCrypt hashed password
# Password "123456" hashed with BCrypt (rounds=10)
docker exec quiz-database psql -U quiz_user -d quiz_db -c "
INSERT INTO users (username, password, role, created_at) 
VALUES (
    'admin', 
    '\$2a\$10\$N.zmdr9k7uOCQb376NoUnuTJ8iKtnF.QbdqJO.JvexNBdyVYQwDma', 
    'ROLE_ADMIN', 
    CURRENT_TIMESTAMP
) 
ON CONFLICT (username) DO UPDATE SET 
    password = EXCLUDED.password,
    role = EXCLUDED.role,
    created_at = EXCLUDED.created_at;
"

echo ""
echo "✅ Admin user created successfully!"
echo ""
echo "📋 Login Credentials:"
echo "   Username: admin"
echo "   Password: 123456"
echo "   Role: ROLE_ADMIN"
echo ""
echo "🌐 Login at: http://34.0.14.17"
echo ""
echo "📊 Updated users list:"
docker exec quiz-database psql -U quiz_user -d quiz_db -c "SELECT username, role, created_at FROM users;"
