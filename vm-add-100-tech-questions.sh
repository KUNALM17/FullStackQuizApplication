#!/bin/bash

echo "📚 INSERTING 100 TECHNICAL QUESTIONS"
echo "===================================="
echo "Categories: JAVA, PYTHON, OS, CN, C++, SPRINGBOOT"
echo "Distribution: ~17 questions per category"

echo "🔗 Connecting to database and inserting questions..."

docker exec -i quiz-database psql -U quiz_user -d quiz_db -c "
-- JAVA Questions (17 questions)
INSERT INTO question (question_title, option1, option2, option3, option4, right_answer, difficultylevel, category) VALUES
('Which of the following is NOT a Java primitive data type?', 'int', 'String', 'boolean', 'char', 'String', 'EASY', 'JAVA'),
('What is the default value of an int variable in Java?', '0', '1', 'null', 'undefined', '0', 'EASY', 'JAVA'),
('Which method is the entry point of a Java application?', 'start()', 'main()', 'run()', 'init()', 'main()', 'EASY', 'JAVA'),
('What does JVM stand for?', 'Java Virtual Machine', 'Java Variable Method', 'Java Version Manager', 'Java Visual Model', 'Java Virtual Machine', 'EASY', 'JAVA'),
('Which access modifier makes a member accessible only within the same package?', 'private', 'protected', 'public', 'default', 'default', 'MEDIUM', 'JAVA'),
('What is the correct syntax to create an ArrayList in Java?', 'ArrayList<String> list = new ArrayList<String>();', 'ArrayList list = new ArrayList();', 'List<String> list = new List<String>();', 'Array<String> list = new Array<String>();', 'ArrayList<String> list = new ArrayList<String>();', 'MEDIUM', 'JAVA'),
('Which keyword is used to prevent inheritance in Java?', 'static', 'final', 'abstract', 'private', 'final', 'MEDIUM', 'JAVA'),
('What is the difference between == and .equals() in Java?', '== compares references, .equals() compares values', '== compares values, .equals() compares references', 'They are the same', 'Only == can be used for strings', '== compares references, .equals() compares values', 'MEDIUM', 'JAVA'),
('Which collection allows duplicate elements in Java?', 'Set', 'HashSet', 'ArrayList', 'TreeSet', 'ArrayList', 'MEDIUM', 'JAVA'),
('What is the purpose of the ''synchronized'' keyword in Java?', 'Memory management', 'Thread safety', 'Performance optimization', 'Error handling', 'Thread safety', 'HARD', 'JAVA'),
('Which design pattern ensures only one instance of a class exists?', 'Factory', 'Singleton', 'Observer', 'Builder', 'Singleton', 'MEDIUM', 'JAVA'),
('What is the time complexity of searching in a HashMap in Java?', 'O(1)', 'O(log n)', 'O(n)', 'O(n²)', 'O(1)', 'MEDIUM', 'JAVA'),
('Which exception is thrown when accessing an array with invalid index?', 'NullPointerException', 'ArrayIndexOutOfBoundsException', 'IllegalArgumentException', 'ClassCastException', 'ArrayIndexOutOfBoundsException', 'EASY', 'JAVA'),
('What is the correct way to handle exceptions in Java?', 'try-catch', 'if-else', 'switch-case', 'for-loop', 'try-catch', 'EASY', 'JAVA'),
('Which interface must a class implement to be used in a for-each loop?', 'Serializable', 'Comparable', 'Iterable', 'Cloneable', 'Iterable', 'MEDIUM', 'JAVA'),
('What is the purpose of the ''static'' keyword in Java?', 'Makes variables constant', 'Allows access without creating instance', 'Prevents inheritance', 'Enables multithreading', 'Allows access without creating instance', 'MEDIUM', 'JAVA'),
('Which Java version introduced Lambda expressions?', 'Java 6', 'Java 7', 'Java 8', 'Java 9', 'Java 8', 'MEDIUM', 'JAVA'),

-- PYTHON Questions (17 questions)
('Which of the following is the correct way to create a list in Python?', 'list = []', 'list = {}', 'list = ()', 'list = ''''', 'list = []', 'EASY', 'PYTHON'),
('What is the output of print(type([]))?', '<class ''list''>', '<class ''array''>', '<class ''tuple''>', '<class ''dict''>', '<class ''list''>', 'EASY', 'PYTHON'),
('Which keyword is used to define a function in Python?', 'function', 'def', 'func', 'define', 'def', 'EASY', 'PYTHON'),
('What is the correct way to import a module in Python?', 'include module', 'import module', 'require module', 'use module', 'import module', 'EASY', 'PYTHON'),
('Which data type is mutable in Python?', 'tuple', 'string', 'list', 'int', 'list', 'EASY', 'PYTHON'),
('What is the output of ''2'' + ''3'' in Python?', '5', '23', 'Error', '2 3', '23', 'EASY', 'PYTHON'),
('Which method is used to add an element to the end of a list?', 'add()', 'append()', 'insert()', 'push()', 'append()', 'EASY', 'PYTHON'),
('What is a lambda function in Python?', 'A named function', 'An anonymous function', 'A built-in function', 'A class method', 'An anonymous function', 'MEDIUM', 'PYTHON'),
('Which of the following is used for exception handling in Python?', 'try-except', 'catch-throw', 'handle-error', 'exception-catch', 'try-except', 'MEDIUM', 'PYTHON'),
('What is the difference between ''is'' and ''=='' in Python?', '''is'' compares values, ''=='' compares identity', '''is'' compares identity, ''=='' compares values', 'They are the same', 'Only ''=='' works with strings', '''is'' compares identity, ''=='' compares values', 'MEDIUM', 'PYTHON'),
('Which Python feature allows a function to call itself?', 'Iteration', 'Recursion', 'Inheritance', 'Polymorphism', 'Recursion', 'MEDIUM', 'PYTHON'),
('What is the purpose of __init__ method in Python?', 'To destroy objects', 'To initialize objects', 'To copy objects', 'To compare objects', 'To initialize objects', 'MEDIUM', 'PYTHON'),
('Which decorator is used to create a static method in Python?', '@static', '@staticmethod', '@classmethod', '@property', '@staticmethod', 'MEDIUM', 'PYTHON'),
('What is the Global Interpreter Lock (GIL) in Python?', 'A security feature', 'A memory management tool', 'A mechanism that prevents multiple threads from executing Python code simultaneously', 'A debugging tool', 'A mechanism that prevents multiple threads from executing Python code simultaneously', 'HARD', 'PYTHON'),
('Which module is used for regular expressions in Python?', 'regex', 're', 'regexp', 'pattern', 're', 'MEDIUM', 'PYTHON'),
('What is the time complexity of list.append() operation in Python?', 'O(1)', 'O(log n)', 'O(n)', 'O(n²)', 'O(1)', 'MEDIUM', 'PYTHON'),
('Which Python data structure is implemented as a hash table?', 'list', 'tuple', 'set', 'string', 'set', 'MEDIUM', 'PYTHON'),

-- Operating Systems Questions (17 questions)
('What is the main function of an operating system?', 'Compile programs', 'Manage hardware and software resources', 'Create applications', 'Design user interfaces', 'Manage hardware and software resources', 'EASY', 'OS'),
('Which of the following is NOT an operating system?', 'Windows', 'Linux', 'macOS', 'Microsoft Office', 'Microsoft Office', 'EASY', 'OS'),
('What is a process in operating systems?', 'A running program', 'A file on disk', 'A hardware component', 'A network connection', 'A running program', 'EASY', 'OS'),
('Which algorithm is used for process scheduling?', 'Bubble Sort', 'Round Robin', 'Binary Search', 'Depth First Search', 'Round Robin', 'MEDIUM', 'OS'),
('What is virtual memory?', 'Memory that doesn''t exist', 'RAM expansion technique', 'A type of cache', 'Network storage', 'RAM expansion technique', 'MEDIUM', 'OS'),
('Which of the following can cause deadlock?', 'Mutual exclusion', 'Hold and wait', 'No preemption', 'All of the above', 'All of the above', 'HARD', 'OS'),
('What is the difference between preemptive and non-preemptive scheduling?', 'Preemptive can interrupt processes', 'Non-preemptive is faster', 'They are the same', 'Preemptive uses more memory', 'Preemptive can interrupt processes', 'MEDIUM', 'OS'),
('Which command is used to list files in Unix/Linux?', 'dir', 'ls', 'list', 'show', 'ls', 'EASY', 'OS'),
('What is a semaphore in operating systems?', 'A hardware component', 'A synchronization primitive', 'A type of memory', 'A file system', 'A synchronization primitive', 'MEDIUM', 'OS'),
('Which memory allocation algorithm minimizes fragmentation?', 'First Fit', 'Best Fit', 'Worst Fit', 'Next Fit', 'Best Fit', 'MEDIUM', 'OS'),
('What is thrashing in operating systems?', 'Excessive paging activity', 'CPU overheating', 'Memory leakage', 'Network congestion', 'Excessive paging activity', 'HARD', 'OS'),
('Which file system is commonly used in Linux?', 'NTFS', 'FAT32', 'ext4', 'HFS+', 'ext4', 'MEDIUM', 'OS'),
('What is the purpose of system calls?', 'To call other programs', 'To interface with OS kernel', 'To handle interrupts', 'To manage memory', 'To interface with OS kernel', 'MEDIUM', 'OS'),
('Which scheduling algorithm gives shortest average waiting time?', 'FCFS', 'SJF', 'Round Robin', 'Priority', 'SJF', 'MEDIUM', 'OS'),
('What is a mutex in operating systems?', 'Multiple processes', 'Mutual exclusion lock', 'Memory management unit', 'Message passing interface', 'Mutual exclusion lock', 'MEDIUM', 'OS'),
('Which interrupt has the highest priority?', 'Hardware interrupt', 'Software interrupt', 'Timer interrupt', 'I/O interrupt', 'Hardware interrupt', 'MEDIUM', 'OS'),
('What is the difference between process and thread?', 'Threads share memory space', 'Processes are faster', 'They are the same', 'Threads use more memory', 'Threads share memory space', 'MEDIUM', 'OS'),

-- Computer Networks Questions (17 questions)
('What does TCP stand for?', 'Transfer Control Protocol', 'Transmission Control Protocol', 'Transport Control Protocol', 'Terminal Control Protocol', 'Transmission Control Protocol', 'EASY', 'CN'),
('Which layer of OSI model handles routing?', 'Physical', 'Data Link', 'Network', 'Transport', 'Network', 'MEDIUM', 'CN'),
('What is the default port number for HTTP?', '21', '23', '80', '443', '80', 'EASY', 'CN'),
('Which protocol is connectionless?', 'TCP', 'UDP', 'FTP', 'SMTP', 'UDP', 'MEDIUM', 'CN'),
('What does IP stand for?', 'Internet Protocol', 'Internal Protocol', 'Intermediate Protocol', 'Information Protocol', 'Internet Protocol', 'EASY', 'CN'),
('Which device operates at the Physical layer?', 'Switch', 'Router', 'Hub', 'Bridge', 'Hub', 'MEDIUM', 'CN'),
('What is the purpose of ARP protocol?', 'Resolve IP to MAC address', 'Route packets', 'Encrypt data', 'Compress data', 'Resolve IP to MAC address', 'MEDIUM', 'CN'),
('Which topology connects all devices to a central hub?', 'Bus', 'Ring', 'Star', 'Mesh', 'Star', 'EASY', 'CN'),
('What is the maximum length of UTP cable?', '50 meters', '100 meters', '200 meters', '500 meters', '100 meters', 'MEDIUM', 'CN'),
('Which protocol is used for email transfer?', 'HTTP', 'FTP', 'SMTP', 'SNMP', 'SMTP', 'MEDIUM', 'CN'),
('What is DHCP used for?', 'Domain name resolution', 'Automatic IP assignment', 'File transfer', 'Web browsing', 'Automatic IP assignment', 'MEDIUM', 'CN'),
('Which algorithm is used by distance vector routing?', 'Dijkstra', 'Bellman-Ford', 'Floyd-Warshall', 'Kruskal', 'Bellman-Ford', 'HARD', 'CN'),
('What is the purpose of NAT?', 'Network Address Translation', 'Network Access Terminal', 'Network Administration Tool', 'Network Allocation Table', 'Network Address Translation', 'MEDIUM', 'CN'),
('Which protocol provides reliable data transfer?', 'IP', 'UDP', 'TCP', 'ICMP', 'TCP', 'MEDIUM', 'CN'),
('What is the difference between switch and hub?', 'Switch creates collision domains', 'Hub is faster', 'They are the same', 'Switch stores MAC addresses', 'Switch stores MAC addresses', 'MEDIUM', 'CN'),
('Which port does HTTPS use?', '80', '443', '21', '25', '443', 'EASY', 'CN'),
('What is VLAN?', 'Virtual Local Area Network', 'Variable Length Area Network', 'Verified Local Access Network', 'Virtual Link Area Network', 'Virtual Local Area Network', 'MEDIUM', 'CN'),

-- C++ Questions (16 questions)
('Which operator is used for dynamic memory allocation in C++?', 'malloc', 'new', 'alloc', 'create', 'new', 'EASY', 'C++'),
('What is the correct syntax to declare a pointer in C++?', 'int ptr*', 'int *ptr', 'int ptr&', '*int ptr', 'int *ptr', 'EASY', 'C++'),
('Which header file is required for input/output operations in C++?', '<stdio.h>', '<iostream>', '<conio.h>', '<fstream>', '<iostream>', 'EASY', 'C++'),
('What is the difference between struct and class in C++?', 'No difference', 'struct members are public by default', 'class is faster', 'struct cannot have methods', 'struct members are public by default', 'MEDIUM', 'C++'),
('Which concept allows multiple functions with the same name?', 'Inheritance', 'Polymorphism', 'Function overloading', 'Encapsulation', 'Function overloading', 'MEDIUM', 'C++'),
('What is a destructor in C++?', 'Creates objects', 'Destroys objects', 'Copies objects', 'Compares objects', 'Destroys objects', 'MEDIUM', 'C++'),
('Which access specifier makes members accessible only within the class?', 'public', 'private', 'protected', 'internal', 'private', 'EASY', 'C++'),
('What is virtual function in C++?', 'A function that doesn''t exist', 'A function that enables runtime polymorphism', 'A static function', 'A template function', 'A function that enables runtime polymorphism', 'HARD', 'C++'),
('Which operator cannot be overloaded in C++?', '+', '-', '::', '[]', '::', 'MEDIUM', 'C++'),
('What is the purpose of const keyword in C++?', 'Makes variables faster', 'Prevents modification', 'Allocates memory', 'Defines templates', 'Prevents modification', 'MEDIUM', 'C++'),
('Which container is part of STL in C++?', 'array', 'vector', 'list', 'All of the above', 'All of the above', 'MEDIUM', 'C++'),
('What is RAII in C++?', 'Resource Acquisition Is Initialization', 'Random Access Iterator Implementation', 'Runtime Application Interface', 'Recursive Algorithm Implementation', 'Resource Acquisition Is Initialization', 'HARD', 'C++'),
('Which keyword is used for inheritance in C++?', 'extends', 'inherits', ':', 'implements', ':', 'MEDIUM', 'C++'),
('What is the difference between reference and pointer?', 'Reference can be null', 'Pointer must be initialized', 'Reference cannot be reassigned', 'They are the same', 'Reference cannot be reassigned', 'MEDIUM', 'C++'),
('Which exception handling mechanism is used in C++?', 'try-catch', 'handle-error', 'exception-catch', 'error-handle', 'try-catch', 'MEDIUM', 'C++'),
('What is template in C++?', 'A design pattern', 'Generic programming feature', 'Memory management tool', 'File handling mechanism', 'Generic programming feature', 'MEDIUM', 'C++'),

-- Spring Boot Questions (16 questions)
('What is Spring Boot?', 'A web server', 'A framework that simplifies Spring development', 'A database', 'An IDE', 'A framework that simplifies Spring development', 'EASY', 'SPRINGBOOT'),
('Which annotation is used to mark a class as Spring Boot main class?', '@SpringBootApplication', '@SpringBoot', '@MainClass', '@Application', '@SpringBootApplication', 'EASY', 'SPRINGBOOT'),
('What is the default port for Spring Boot application?', '8080', '9090', '3000', '80', '8080', 'EASY', 'SPRINGBOOT'),
('Which annotation is used to create REST endpoints?', '@Controller', '@RestController', '@Endpoint', '@Service', '@RestController', 'MEDIUM', 'SPRINGBOOT'),
('What is Spring Boot Starter?', 'A tutorial', 'Pre-configured dependency sets', 'A development tool', 'A testing framework', 'Pre-configured dependency sets', 'MEDIUM', 'SPRINGBOOT'),
('Which file is used for configuration in Spring Boot?', 'config.xml', 'application.properties', 'settings.json', 'app.config', 'application.properties', 'EASY', 'SPRINGBOOT'),
('What is dependency injection in Spring?', 'A design pattern for providing dependencies', 'A testing technique', 'A deployment strategy', 'A security feature', 'A design pattern for providing dependencies', 'MEDIUM', 'SPRINGBOOT'),
('Which annotation is used for automatic dependency injection?', '@Inject', '@Autowired', '@Dependency', '@Wire', '@Autowired', 'MEDIUM', 'SPRINGBOOT'),
('What is Spring Boot Actuator?', 'A database tool', 'Production-ready features for monitoring', 'A testing framework', 'A deployment tool', 'Production-ready features for monitoring', 'MEDIUM', 'SPRINGBOOT'),
('Which annotation is used to mark a class as a service?', '@Component', '@Service', '@Repository', '@Bean', '@Service', 'MEDIUM', 'SPRINGBOOT'),
('What is the purpose of @Entity annotation?', 'Marks REST endpoint', 'Marks JPA entity', 'Marks service class', 'Marks configuration', 'Marks JPA entity', 'MEDIUM', 'SPRINGBOOT'),
('Which annotation is used for validation in Spring Boot?', '@Valid', '@Validate', '@Check', '@Verify', '@Valid', 'MEDIUM', 'SPRINGBOOT'),
('What is Spring Data JPA?', 'A web framework', 'Data access abstraction', 'A security module', 'A testing tool', 'Data access abstraction', 'MEDIUM', 'SPRINGBOOT'),
('Which annotation is used to handle HTTP GET requests?', '@Get', '@GetMapping', '@RequestGet', '@HttpGet', '@GetMapping', 'MEDIUM', 'SPRINGBOOT'),
('What is the purpose of @Configuration annotation?', 'Marks entity class', 'Marks configuration class', 'Marks service class', 'Marks controller class', 'Marks configuration class', 'MEDIUM', 'SPRINGBOOT'),
('Which embedded server does Spring Boot use by default?', 'Jetty', 'Tomcat', 'Undertow', 'Netty', 'Tomcat', 'MEDIUM', 'SPRINGBOOT');

SELECT 'Technical questions inserted successfully!' as status;
SELECT COUNT(*) as total_questions FROM question;
SELECT category, COUNT(*) as count FROM question GROUP BY category ORDER BY category;
"

echo ""
echo "✅ 100 technical questions inserted successfully!"
echo "📊 Questions breakdown:"
echo "   - JAVA: 17 questions"
echo "   - PYTHON: 17 questions"  
echo "   - OS (Operating Systems): 17 questions"
echo "   - CN (Computer Networks): 17 questions"
echo "   - C++: 16 questions"
echo "   - SPRINGBOOT: 16 questions"
echo ""
echo "🎯 Total: 100 technical questions ready for quiz creation!"
echo "🚀 You can now create quizzes from these categories in your admin panel!"
