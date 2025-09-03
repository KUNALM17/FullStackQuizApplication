-- Initialize the quiz database with sample data

-- Create tables will be handled by JPA/Hibernate DDL

-- Insert sample questions (these will be created after tables are auto-generated)
-- This script will run only if tables exist

DO $$
BEGIN
    -- Check if questions table exists and insert sample data
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'question') THEN
        -- Insert sample questions only if table is empty
        INSERT INTO question (id, category, difficult_level, option1, option2, option3, option4, question_title, right_answer)
        SELECT 1, 'Java', 'Easy', 'class', 'interface', 'extends', 'implements', 'Which Java keyword is used to create a subclass?', 'extends'
        WHERE NOT EXISTS (SELECT 1 FROM question WHERE id = 1);
        
        INSERT INTO question (id, category, difficult_level, option1, option2, option3, option4, question_title, right_answer)
        SELECT 2, 'Java', 'Medium', 'ArrayList', 'LinkedList', 'Vector', 'All of the above', 'Which of the following implements List interface?', 'All of the above'
        WHERE NOT EXISTS (SELECT 1 FROM question WHERE id = 2);
        
        INSERT INTO question (id, category, difficult_level, option1, option2, option3, option4, question_title, right_answer)
        SELECT 3, 'Python', 'Easy', 'def', 'function', 'define', 'func', 'Which keyword is used to define a function in Python?', 'def'
        WHERE NOT EXISTS (SELECT 1 FROM question WHERE id = 3);
        
        INSERT INTO question (id, category, difficult_level, option1, option2, option3, option4, question_title, right_answer)
        SELECT 4, 'JavaScript', 'Medium', 'var', 'let', 'const', 'All of the above', 'Which of the following can be used to declare variables in JavaScript?', 'All of the above'
        WHERE NOT EXISTS (SELECT 1 FROM question WHERE id = 4);
        
        INSERT INTO question (id, category, difficult_level, option1, option2, option3, option4, question_title, right_answer)
        SELECT 5, 'Java', 'Hard', 'JVM', 'JRE', 'JDK', 'All are same', 'What does JVM stand for?', 'JVM'
        WHERE NOT EXISTS (SELECT 1 FROM question WHERE id = 5);
    END IF;
END $$;
