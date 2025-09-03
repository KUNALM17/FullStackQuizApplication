#!/bin/bash

echo "📚 INSERTING 100 QUIZ QUESTIONS"
echo "==============================="

echo "🔗 Connecting to database and inserting questions..."

docker exec quiz-database psql -U quiz_user -d quiz_db -c "
-- Programming Questions (20 questions)
INSERT INTO question (question_text, option1, option2, option3, option4, right_answer, difficulty_level, category) VALUES
('Which programming language is known for \"Write Once, Run Anywhere\"?', 'Python', 'Java', 'C++', 'JavaScript', 'Java', 'MEDIUM', 'Programming'),
('What does HTML stand for?', 'Hypertext Markup Language', 'High Tech Modern Language', 'Home Tool Markup Language', 'Hyperlink Text Markup Language', 'Hypertext Markup Language', 'EASY', 'Programming'),
('Which of the following is NOT a programming language?', 'Python', 'Java', 'HTML', 'C++', 'HTML', 'EASY', 'Programming'),
('What is the correct way to declare a variable in JavaScript?', 'var myVar;', 'variable myVar;', 'v myVar;', 'declare myVar;', 'var myVar;', 'EASY', 'Programming'),
('Which symbol is used for comments in Python?', '//', '#', '/* */', '--', '#', 'EASY', 'Programming'),
('What does SQL stand for?', 'Structured Query Language', 'Simple Query Language', 'Standard Query Language', 'Sequential Query Language', 'Structured Query Language', 'EASY', 'Programming'),
('Which of these is a NoSQL database?', 'MySQL', 'PostgreSQL', 'MongoDB', 'Oracle', 'MongoDB', 'MEDIUM', 'Programming'),
('What is the main purpose of CSS?', 'Database management', 'Styling web pages', 'Server-side scripting', 'Data analysis', 'Styling web pages', 'EASY', 'Programming'),
('Which HTTP method is used to update data?', 'GET', 'POST', 'PUT', 'DELETE', 'PUT', 'MEDIUM', 'Programming'),
('What is the time complexity of binary search?', 'O(n)', 'O(log n)', 'O(n²)', 'O(1)', 'O(log n)', 'MEDIUM', 'Programming'),
('Which design pattern is used to create a single instance of a class?', 'Factory', 'Observer', 'Singleton', 'Strategy', 'Singleton', 'MEDIUM', 'Programming'),
('What does API stand for?', 'Application Programming Interface', 'Advanced Programming Interface', 'Automated Programming Interface', 'Application Process Interface', 'Application Programming Interface', 'EASY', 'Programming'),
('Which of these is NOT a valid HTTP status code?', '200', '404', '500', '999', '999', 'MEDIUM', 'Programming'),
('What is Git used for?', 'Database management', 'Version control', 'Web hosting', 'Code compilation', 'Version control', 'EASY', 'Programming'),
('Which of these is a JavaScript framework?', 'Django', 'React', 'Laravel', 'Spring', 'React', 'EASY', 'Programming'),
('What does OOP stand for?', 'Object-Oriented Programming', 'Optimized Operation Programming', 'Organized Object Programming', 'Original Operation Programming', 'Object-Oriented Programming', 'EASY', 'Programming'),
('Which data structure uses LIFO principle?', 'Queue', 'Stack', 'Array', 'Linked List', 'Stack', 'MEDIUM', 'Programming'),
('What is the default port for HTTP?', '443', '80', '8080', '3000', '80', 'EASY', 'Programming'),
('Which of these is NOT a relational database?', 'MySQL', 'PostgreSQL', 'MongoDB', 'SQLite', 'MongoDB', 'MEDIUM', 'Programming'),
('What does JSON stand for?', 'JavaScript Object Notation', 'Java Standard Object Notation', 'JavaScript Oriented Notation', 'Java Script Object Network', 'JavaScript Object Notation', 'EASY', 'Programming'),

-- Science Questions (20 questions)
('What is the chemical symbol for gold?', 'Go', 'Gd', 'Au', 'Ag', 'Au', 'EASY', 'Science'),
('Which planet is known as the Red Planet?', 'Venus', 'Mars', 'Jupiter', 'Saturn', 'Mars', 'EASY', 'Science'),
('What is the speed of light in vacuum?', '300,000 km/s', '3,000,000 km/s', '30,000 km/s', '3,000 km/s', '300,000 km/s', 'MEDIUM', 'Science'),
('Which gas makes up about 78% of Earth\'s atmosphere?', 'Oxygen', 'Carbon Dioxide', 'Nitrogen', 'Argon', 'Nitrogen', 'MEDIUM', 'Science'),
('What is the hardest natural substance on Earth?', 'Diamond', 'Quartz', 'Iron', 'Granite', 'Diamond', 'EASY', 'Science'),
('Which scientist developed the theory of relativity?', 'Newton', 'Einstein', 'Galileo', 'Darwin', 'Einstein', 'EASY', 'Science'),
('What is the chemical formula for water?', 'H2O', 'CO2', 'O2', 'CH4', 'H2O', 'EASY', 'Science'),
('Which organ in the human body produces insulin?', 'Liver', 'Kidney', 'Pancreas', 'Heart', 'Pancreas', 'MEDIUM', 'Science'),
('What is the study of earthquakes called?', 'Geology', 'Seismology', 'Meteorology', 'Oceanography', 'Seismology', 'MEDIUM', 'Science'),
('Which blood type is known as the universal donor?', 'A', 'B', 'AB', 'O', 'O', 'MEDIUM', 'Science'),
('What is the smallest unit of matter?', 'Molecule', 'Atom', 'Cell', 'Electron', 'Atom', 'EASY', 'Science'),
('Which scientist is famous for the laws of motion?', 'Einstein', 'Newton', 'Galileo', 'Kepler', 'Newton', 'EASY', 'Science'),
('What is the process by which plants make food?', 'Respiration', 'Photosynthesis', 'Digestion', 'Fermentation', 'Photosynthesis', 'EASY', 'Science'),
('Which element has the atomic number 1?', 'Helium', 'Hydrogen', 'Carbon', 'Oxygen', 'Hydrogen', 'EASY', 'Science'),
('What is the largest organ in the human body?', 'Liver', 'Brain', 'Skin', 'Lungs', 'Skin', 'MEDIUM', 'Science'),
('Which force keeps planets in orbit around the sun?', 'Magnetic force', 'Gravity', 'Electric force', 'Nuclear force', 'Gravity', 'EASY', 'Science'),
('What is the chemical symbol for carbon?', 'Ca', 'C', 'Co', 'Cr', 'C', 'EASY', 'Science'),
('Which part of the cell contains DNA?', 'Cytoplasm', 'Nucleus', 'Mitochondria', 'Ribosome', 'Nucleus', 'MEDIUM', 'Science'),
('What is the study of living organisms called?', 'Chemistry', 'Physics', 'Biology', 'Geology', 'Biology', 'EASY', 'Science'),
('Which gas is essential for photosynthesis?', 'Oxygen', 'Nitrogen', 'Carbon Dioxide', 'Hydrogen', 'Carbon Dioxide', 'MEDIUM', 'Science'),

-- Geography Questions (20 questions)
('What is the capital of France?', 'London', 'Berlin', 'Paris', 'Madrid', 'Paris', 'EASY', 'Geography'),
('Which is the largest continent?', 'Africa', 'Asia', 'North America', 'Europe', 'Asia', 'EASY', 'Geography'),
('What is the longest river in the world?', 'Amazon', 'Nile', 'Mississippi', 'Yangtze', 'Nile', 'MEDIUM', 'Geography'),
('Which country has the most time zones?', 'USA', 'Russia', 'China', 'Canada', 'Russia', 'MEDIUM', 'Geography'),
('What is the smallest country in the world?', 'Monaco', 'Vatican City', 'San Marino', 'Liechtenstein', 'Vatican City', 'EASY', 'Geography'),
('Which mountain range contains Mount Everest?', 'Alps', 'Rockies', 'Himalayas', 'Andes', 'Himalayas', 'EASY', 'Geography'),
('What is the capital of Australia?', 'Sydney', 'Melbourne', 'Canberra', 'Perth', 'Canberra', 'MEDIUM', 'Geography'),
('Which desert is the largest in the world?', 'Sahara', 'Gobi', 'Antarctic', 'Arabian', 'Antarctic', 'MEDIUM', 'Geography'),
('What is the deepest ocean trench?', 'Mariana Trench', 'Puerto Rico Trench', 'Peru-Chile Trench', 'Java Trench', 'Mariana Trench', 'MEDIUM', 'Geography'),
('Which country is known as the Land of the Rising Sun?', 'China', 'Japan', 'Korea', 'Thailand', 'Japan', 'EASY', 'Geography'),
('What is the capital of Canada?', 'Toronto', 'Vancouver', 'Ottawa', 'Montreal', 'Ottawa', 'MEDIUM', 'Geography'),
('Which strait separates Europe and Asia?', 'Bering Strait', 'Strait of Gibraltar', 'Bosphorus Strait', 'Strait of Hormuz', 'Bosphorus Strait', 'MEDIUM', 'Geography'),
('What is the largest island in the world?', 'Australia', 'Greenland', 'New Guinea', 'Borneo', 'Greenland', 'MEDIUM', 'Geography'),
('Which river flows through London?', 'Thames', 'Seine', 'Rhine', 'Danube', 'Thames', 'EASY', 'Geography'),
('What is the highest waterfall in the world?', 'Niagara Falls', 'Angel Falls', 'Victoria Falls', 'Iguazu Falls', 'Angel Falls', 'MEDIUM', 'Geography'),
('Which country has the longest coastline?', 'Russia', 'Canada', 'Norway', 'Australia', 'Canada', 'MEDIUM', 'Geography'),
('What is the capital of Brazil?', 'Rio de Janeiro', 'São Paulo', 'Brasília', 'Salvador', 'Brasília', 'MEDIUM', 'Geography'),
('Which sea is the saltiest?', 'Red Sea', 'Dead Sea', 'Black Sea', 'Caspian Sea', 'Dead Sea', 'MEDIUM', 'Geography'),
('What is the southernmost continent?', 'Australia', 'South America', 'Antarctica', 'Africa', 'Antarctica', 'EASY', 'Geography'),
('Which country is both in Europe and Asia?', 'Russia', 'Turkey', 'Kazakhstan', 'All of the above', 'All of the above', 'MEDIUM', 'Geography'),

-- History Questions (20 questions)
('In which year did World War II end?', '1944', '1945', '1946', '1947', '1945', 'EASY', 'History'),
('Who was the first President of the United States?', 'Thomas Jefferson', 'George Washington', 'Abraham Lincoln', 'John Adams', 'George Washington', 'EASY', 'History'),
('Which ancient wonder of the world was located in Alexandria?', 'Colossus of Rhodes', 'Lighthouse of Alexandria', 'Hanging Gardens', 'Statue of Zeus', 'Lighthouse of Alexandria', 'MEDIUM', 'History'),
('Who painted the Mona Lisa?', 'Vincent van Gogh', 'Pablo Picasso', 'Leonardo da Vinci', 'Michelangelo', 'Leonardo da Vinci', 'EASY', 'History'),
('In which year did the Berlin Wall fall?', '1987', '1988', '1989', '1990', '1989', 'MEDIUM', 'History'),
('Who wrote \"Romeo and Juliet\"?', 'Charles Dickens', 'William Shakespeare', 'Jane Austen', 'Mark Twain', 'William Shakespeare', 'EASY', 'History'),
('Which empire was ruled by Julius Caesar?', 'Greek Empire', 'Roman Empire', 'Byzantine Empire', 'Persian Empire', 'Roman Empire', 'EASY', 'History'),
('When did the Titanic sink?', '1910', '1911', '1912', '1913', '1912', 'EASY', 'History'),
('Who was known as the \"Iron Lady\"?', 'Queen Elizabeth II', 'Margaret Thatcher', 'Golda Meir', 'Indira Gandhi', 'Margaret Thatcher', 'MEDIUM', 'History'),
('Which revolution began in 1789?', 'American Revolution', 'French Revolution', 'Russian Revolution', 'Industrial Revolution', 'French Revolution', 'EASY', 'History'),
('Who was the last Pharaoh of Egypt?', 'Cleopatra', 'Tutankhamun', 'Ramesses II', 'Akhenaten', 'Cleopatra', 'MEDIUM', 'History'),
('In which year did India gain independence?', '1946', '1947', '1948', '1949', '1947', 'EASY', 'History'),
('Who invented the printing press?', 'Johannes Gutenberg', 'Benjamin Franklin', 'Thomas Edison', 'Alexander Graham Bell', 'Johannes Gutenberg', 'MEDIUM', 'History'),
('Which war was fought between the North and South in America?', 'Revolutionary War', 'Civil War', 'War of 1812', 'Spanish-American War', 'Civil War', 'EASY', 'History'),
('Who was the first man to walk on the moon?', 'Buzz Aldrin', 'Neil Armstrong', 'John Glenn', 'Alan Shepard', 'Neil Armstrong', 'EASY', 'History'),
('Which ancient civilization built Machu Picchu?', 'Aztec', 'Maya', 'Inca', 'Olmec', 'Inca', 'MEDIUM', 'History'),
('When did World War I begin?', '1913', '1914', '1915', '1916', '1914', 'EASY', 'History'),
('Who was the first woman to win a Nobel Prize?', 'Marie Curie', 'Mother Teresa', 'Jane Addams', 'Bertha von Suttner', 'Marie Curie', 'MEDIUM', 'History'),
('Which city was the first to be attacked with an atomic bomb?', 'Nagasaki', 'Hiroshima', 'Tokyo', 'Kyoto', 'Hiroshima', 'MEDIUM', 'History'),
('Who founded Microsoft?', 'Steve Jobs', 'Bill Gates', 'Mark Zuckerberg', 'Larry Page', 'Bill Gates', 'EASY', 'History'),

-- Mathematics Questions (20 questions)
('What is 15 + 28?', '43', '42', '44', '41', '43', 'EASY', 'Mathematics'),
('What is the square root of 64?', '6', '7', '8', '9', '8', 'EASY', 'Mathematics'),
('What is 12 × 7?', '84', '82', '86', '88', '84', 'EASY', 'Mathematics'),
('What is the value of π (pi) approximately?', '3.14', '3.16', '3.12', '3.18', '3.14', 'EASY', 'Mathematics'),
('What is 144 ÷ 12?', '11', '12', '13', '14', '12', 'EASY', 'Mathematics'),
('What is 25% of 200?', '25', '50', '75', '100', '50', 'EASY', 'Mathematics'),
('What is the area of a circle with radius 5? (Use π = 3.14)', '78.5', '79.5', '77.5', '76.5', '78.5', 'MEDIUM', 'Mathematics'),
('What is 2³ (2 to the power of 3)?', '6', '8', '9', '12', '8', 'EASY', 'Mathematics'),
('What is the perimeter of a square with side length 6?', '24', '36', '18', '12', '24', 'EASY', 'Mathematics'),
('Solve: 3x + 9 = 21', 'x = 3', 'x = 4', 'x = 5', 'x = 6', 'x = 4', 'MEDIUM', 'Mathematics'),
('What is the sum of angles in a triangle?', '180°', '360°', '90°', '270°', '180°', 'EASY', 'Mathematics'),
('What is 0.75 as a fraction?', '3/4', '2/3', '4/5', '5/6', '3/4', 'MEDIUM', 'Mathematics'),
('What is the next number in the sequence: 2, 4, 8, 16, ...?', '24', '28', '32', '20', '32', 'MEDIUM', 'Mathematics'),
('What is the volume of a cube with side length 4?', '16', '48', '64', '12', '64', 'MEDIUM', 'Mathematics'),
('What is 45% of 80?', '36', '35', '38', '40', '36', 'MEDIUM', 'Mathematics'),
('What is the greatest common divisor of 24 and 36?', '6', '8', '12', '4', '12', 'MEDIUM', 'Mathematics'),
('What is the slope of the line y = 3x + 5?', '3', '5', '8', '2', '3', 'MEDIUM', 'Mathematics'),
('What is log₁₀(100)?', '1', '2', '10', '100', '2', 'MEDIUM', 'Mathematics'),
('What is the factorial of 5 (5!)?', '120', '100', '140', '60', '120', 'MEDIUM', 'Mathematics'),
('What is the hypotenuse of a right triangle with sides 3 and 4?', '5', '6', '7', '8', '5', 'MEDIUM', 'Mathematics');

SELECT 'Questions inserted successfully!' as status;
SELECT COUNT(*) as total_questions FROM question;
SELECT category, COUNT(*) as count FROM question GROUP BY category ORDER BY category;
"

echo ""
echo "✅ 100 questions inserted successfully!"
echo "📊 Questions breakdown:"
echo "   - Programming: 20 questions"
echo "   - Science: 20 questions"
echo "   - Geography: 20 questions"
echo "   - History: 20 questions"
echo "   - Mathematics: 20 questions"
echo ""
echo "🎯 Total: 100 questions ready for quiz creation!"
