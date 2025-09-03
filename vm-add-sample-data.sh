#!/bin/bash

echo "🗄️ DATABASE DATA INSERTION SCRIPT"
echo "================================="

echo "📊 Current Docker containers:"
docker ps --format "table {{.Names}}\t{{.Status}}"

echo ""
echo "🔗 Connecting to PostgreSQL database..."

# Connect to database container and run SQL commands
docker exec -it quiz-database psql -U quiz_user -d quiz_db -c "
-- Insert sample questions
INSERT INTO question (question_text, option1, option2, option3, option4, right_answer, difficulty_level, category) VALUES
('What is the capital of France?', 'London', 'Berlin', 'Paris', 'Madrid', 'Paris', 'EASY', 'Geography'),
('Which programming language is known for \"Write Once, Run Anywhere\"?', 'Python', 'Java', 'C++', 'JavaScript', 'Java', 'MEDIUM', 'Programming'),
('What is 2 + 2?', '3', '4', '5', '6', '4', 'EASY', 'Math'),
('Who wrote Romeo and Juliet?', 'Charles Dickens', 'William Shakespeare', 'Jane Austen', 'Mark Twain', 'William Shakespeare', 'MEDIUM', 'Literature'),
('What is the largest planet in our solar system?', 'Earth', 'Mars', 'Jupiter', 'Saturn', 'Jupiter', 'EASY', 'Science');

-- Check inserted data
SELECT COUNT(*) as total_questions FROM question;
SELECT question_text, category, difficulty_level FROM question LIMIT 3;
"

echo ""
echo "✅ Sample questions inserted!"
echo "🌐 Now you can create quizzes using the admin panel at: http://34.0.14.17"
