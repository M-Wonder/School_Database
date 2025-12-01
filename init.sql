-- Create database schema for school management system

-- Students table
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address TEXT,
    enrollment_date DATE DEFAULT CURRENT_DATE
);

-- Grades/Classes table
CREATE TABLE grades (
    grade_id SERIAL PRIMARY KEY,
    grade_name VARCHAR(20) NOT NULL UNIQUE,
    grade_level INTEGER NOT NULL,
    section VARCHAR(10)
);

-- Subjects table
CREATE TABLE subjects (
    subject_id SERIAL PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL,
    subject_code VARCHAR(20) UNIQUE NOT NULL
);

-- Student grade assignment (many-to-many)
CREATE TABLE student_grades (
    student_id INTEGER REFERENCES students(student_id) ON DELETE CASCADE,
    grade_id INTEGER REFERENCES grades(grade_id) ON DELETE CASCADE,
    academic_year VARCHAR(9) NOT NULL,
    PRIMARY KEY (student_id, grade_id, academic_year)
);

-- Exam results
CREATE TABLE exam_results (
    result_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(student_id) ON DELETE CASCADE,
    subject_id INTEGER REFERENCES subjects(subject_id) ON DELETE CASCADE,
    grade_id INTEGER REFERENCES grades(grade_id) ON DELETE CASCADE,
    exam_date DATE NOT NULL,
    exam_type VARCHAR(50) NOT NULL,
    score DECIMAL(5,2) NOT NULL CHECK (score >= 0 AND score <= 100),
    max_score DECIMAL(5,2) DEFAULT 100,
    remarks TEXT
);

-- Create indexes for better query performance
CREATE INDEX idx_students_name ON students(last_name, first_name);
CREATE INDEX idx_exam_results_student ON exam_results(student_id);
CREATE INDEX idx_exam_results_subject ON exam_results(subject_id);
CREATE INDEX idx_student_grades_student ON student_grades(student_id);

-- Insert sample data

-- Insert grades
INSERT INTO grades (grade_name, grade_level, section) VALUES
('Grade 1-A', 1, 'A'),
('Grade 2-A', 2, 'A'),
('Grade 3-A', 3, 'A'),
('Grade 4-A', 4, 'A'),
('Grade 5-A', 5, 'A'),
('Grade 6-A', 6, 'A');

-- Insert subjects
INSERT INTO subjects (subject_name, subject_code) VALUES
('Mathematics', 'MATH101'),
('English Language', 'ENG101'),
('Science', 'SCI101'),
('History', 'HIST101'),
('Geography', 'GEO101'),
('Physical Education', 'PE101'),
('Art', 'ART101'),
('Music', 'MUS101');

-- Insert sample students
INSERT INTO students (first_name, last_name, date_of_birth, email, phone, address, enrollment_date) VALUES
('John', 'Smith', '2010-05-15', 'john.smith@school.com', '+254712345678', '123 Main St, Nairobi', '2020-01-15'),
('Emily', 'Johnson', '2011-08-22', 'emily.johnson@school.com', '+254723456789', '456 Oak Ave, Nairobi', '2020-01-15'),
('Michael', 'Williams', '2010-03-10', 'michael.williams@school.com', '+254734567890', '789 Pine Rd, Nairobi', '2020-01-15'),
('Sarah', 'Brown', '2011-11-05', 'sarah.brown@school.com', '+254745678901', '321 Elm St, Nairobi', '2020-01-15'),
('David', 'Jones', '2010-07-18', 'david.jones@school.com', '+254756789012', '654 Maple Dr, Nairobi', '2020-01-15'),
('Emma', 'Garcia', '2011-02-28', 'emma.garcia@school.com', '+254767890123', '987 Cedar Ln, Nairobi', '2021-01-15'),
('James', 'Martinez', '2010-09-14', 'james.martinez@school.com', '+254778901234', '147 Birch Ct, Nairobi', '2021-01-15'),
('Olivia', 'Rodriguez', '2011-06-30', 'olivia.rodriguez@school.com', '+254789012345', '258 Spruce Way, Nairobi', '2021-01-15'),
('William', 'Lopez', '2010-12-25', 'william.lopez@school.com', '+254790123456', '369 Willow Rd, Nairobi', '2021-01-15'),
('Sophia', 'Wilson', '2011-04-12', 'sophia.wilson@school.com', '+254701234567', '741 Ash Blvd, Nairobi', '2021-01-15');

-- Assign students to grades
INSERT INTO student_grades (student_id, grade_id, academic_year) VALUES
(1, 6, '2024-2025'),
(2, 5, '2024-2025'),
(3, 6, '2024-2025'),
(4, 5, '2024-2025'),
(5, 6, '2024-2025'),
(6, 5, '2024-2025'),
(7, 6, '2024-2025'),
(8, 5, '2024-2025'),
(9, 6, '2024-2025'),
(10, 5, '2024-2025');

-- Insert exam results
INSERT INTO exam_results (student_id, subject_id, grade_id, exam_date, exam_type, score, remarks) VALUES
-- John Smith (student_id: 1)
(1, 1, 6, '2024-11-15', 'Midterm', 85.5, 'Excellent performance'),
(1, 2, 6, '2024-11-16', 'Midterm', 78.0, 'Good effort'),
(1, 3, 6, '2024-11-17', 'Midterm', 92.0, 'Outstanding'),
(1, 4, 6, '2024-11-18', 'Midterm', 88.5, 'Very good'),

-- Emily Johnson (student_id: 2)
(2, 1, 5, '2024-11-15', 'Midterm', 76.0, 'Good work'),
(2, 2, 5, '2024-11-16', 'Midterm', 89.5, 'Excellent'),
(2, 3, 5, '2024-11-17', 'Midterm', 82.0, 'Well done'),
(2, 4, 5, '2024-11-18', 'Midterm', 79.5, 'Good'),

-- Michael Williams (student_id: 3)
(3, 1, 6, '2024-11-15', 'Midterm', 91.0, 'Outstanding'),
(3, 2, 6, '2024-11-16', 'Midterm', 87.5, 'Very good'),
(3, 3, 6, '2024-11-17', 'Midterm', 94.0, 'Excellent'),
(3, 4, 6, '2024-11-18', 'Midterm', 90.0, 'Outstanding'),

-- Sarah Brown (student_id: 4)
(4, 1, 5, '2024-11-15', 'Midterm', 73.5, 'Satisfactory'),
(4, 2, 5, '2024-11-16', 'Midterm', 81.0, 'Good'),
(4, 3, 5, '2024-11-17', 'Midterm', 77.5, 'Good effort'),
(4, 4, 5, '2024-11-18', 'Midterm', 84.0, 'Very good'),

-- David Jones (student_id: 5)
(5, 1, 6, '2024-11-15', 'Midterm', 88.0, 'Very good'),
(5, 2, 6, '2024-11-16', 'Midterm', 92.5, 'Outstanding'),
(5, 3, 6, '2024-11-17', 'Midterm', 86.0, 'Excellent'),
(5, 4, 6, '2024-11-18', 'Midterm', 89.0, 'Very good');

-- Create useful views
CREATE VIEW student_performance AS
SELECT 
    s.student_id,
    s.first_name,
    s.last_name,
    g.grade_name,
    sub.subject_name,
    er.score,
    er.exam_type,
    er.exam_date,
    er.remarks
FROM students s
JOIN exam_results er ON s.student_id = er.student_id
JOIN grades g ON er.grade_id = g.grade_id
JOIN subjects sub ON er.subject_id = sub.subject_id
ORDER BY s.last_name, s.first_name, er.exam_date;

CREATE VIEW student_averages AS
SELECT 
    s.student_id,
    s.first_name,
    s.last_name,
    g.grade_name,
    ROUND(AVG(er.score), 2) as average_score,
    COUNT(er.result_id) as total_exams
FROM students s
JOIN exam_results er ON s.student_id = er.student_id
JOIN grades g ON er.grade_id = g.grade_id
GROUP BY s.student_id, s.first_name, s.last_name, g.grade_name
ORDER BY average_score DESC;