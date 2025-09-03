#!/bin/bash

echo "🔍 DATABASE INSPECTION SCRIPT"
echo "============================="

echo "📊 Database connection test:"
docker exec quiz-database psql -U quiz_user -d quiz_db -c "SELECT version();"

echo ""
echo "📋 Database tables:"
docker exec quiz-database psql -U quiz_user -d quiz_db -c "\dt"

echo ""
echo "📈 Data counts:"
docker exec quiz-database psql -U quiz_user -d quiz_db -c "
SELECT 'Users' as table_name, COUNT(*) as count FROM users
UNION ALL
SELECT 'Questions' as table_name, COUNT(*) as count FROM question
UNION ALL
SELECT 'Quizzes' as table_name, COUNT(*) as count FROM quiz;
"

echo ""
echo "👥 Users in database:"
docker exec quiz-database psql -U quiz_user -d quiz_db -c "SELECT username, role FROM users;"

echo ""
echo "❓ Questions in database:"
docker exec quiz-database psql -U quiz_user -d quiz_db -c "SELECT id, question_text, category, difficulty_level FROM question LIMIT 5;"
