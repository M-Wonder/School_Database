#Connect to the Database

docker exec -it school_postgres_db psql -U school_admin -d school_db

#List All Tables
\dt

#Describe Table Structure
-- See students table structure
\d students

-- See exam_results table structure
\d exam_results

-- See all tables structure
\d+

#View All Data from Tables
-- View all students
SELECT * FROM students;

-- View all grades
SELECT * FROM grades;

-- View all subjects
SELECT * FROM subjects;

-- View all exam results
SELECT * FROM exam_results;


# Show Student Count
SELECT COUNT(*) as total_students FROM students;