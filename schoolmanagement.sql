-- Create Database
CREATE DATABASE academic_management;
USE academic_management;

-- 1. students table
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    date_of_birth DATE,
    phone_number VARCHAR(20),
    address TEXT,
    department_id INT,
    enrollment_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample students
INSERT INTO students (first_name, last_name, email, password_hash, date_of_birth, phone_number, address, department_id, enrollment_date) VALUES
('John', 'Smith', 'john.smith@student.edu', 'hashed_password_123', '2000-05-15', '+1234567890', '123 Main St, Cityville', 1, '2023-09-01'),
('Sarah', 'Johnson', 'sarah.johnson@student.edu', 'hashed_password_456', '2001-02-20', '+1234567891', '456 Oak Ave, Townsville', 2, '2023-09-01'),
('Michael', 'Brown', 'michael.brown@student.edu', 'hashed_password_789', '1999-11-08', '+1234567892', '789 Pine Rd, Villagetown', 1, '2023-09-01'),
('Emily', 'Davis', 'emily.davis@student.edu', 'hashed_password_101', '2000-07-30', '+1234567893', '321 Elm St, Cityville', 3, '2023-09-01');

-- 2. departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    department_code VARCHAR(10) UNIQUE NOT NULL,
    faculty VARCHAR(100),
    head_of_department VARCHAR(100),
    established_date DATE,
    description TEXT
);

-- Insert sample departments
INSERT INTO departments (department_name, department_code, faculty, head_of_department, established_date, description) VALUES
('Computer Science', 'CS', 'Engineering & Technology', 'Dr. Alice Johnson', '2005-01-01', 'Department focusing on computer programming, algorithms, and software development'),
('Business Administration', 'BUS', 'Business School', 'Dr. Robert Chen', '1998-01-01', 'Department specializing in business management and administration'),
('Electrical Engineering', 'EE', 'Engineering & Technology', 'Dr. Maria Gonzalez', '2002-01-01', 'Department covering electrical systems and electronics');

-- 3. units table
CREATE TABLE units (
    unit_id INT PRIMARY KEY AUTO_INCREMENT,
    unit_code VARCHAR(20) UNIQUE NOT NULL,
    unit_name VARCHAR(100) NOT NULL,
    department_id INT,
    credits INT NOT NULL,
    semester INT,
    description TEXT,
    lecturer VARCHAR(100),
    prerequisites VARCHAR(200),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Insert sample units
INSERT INTO units (unit_code, unit_name, department_id, credits, semester, description, lecturer, prerequisites) VALUES
('CS101', 'Introduction to Programming', 1, 3, 1, 'Fundamentals of programming and algorithms', 'Dr. Alice Johnson', 'None'),
('CS201', 'Data Structures', 1, 4, 2, 'Advanced data structures and algorithms', 'Dr. Alice Johnson', 'CS101'),
('CS301', 'Database Systems', 1, 4, 3, 'Database design and management', 'Dr. David Wilson', 'CS201'),
('BUS101', 'Principles of Management', 2, 3, 1, 'Introduction to business management', 'Dr. Robert Chen', 'None'),
('BUS201', 'Financial Accounting', 2, 4, 2, 'Accounting principles and practices', 'Prof. Sarah Miller', 'BUS101'),
('EE101', 'Circuit Analysis', 3, 4, 1, 'Basic electrical circuit analysis', 'Dr. Maria Gonzalez', 'None'),
('EE201', 'Digital Electronics', 3, 4, 2, 'Digital logic and electronic systems', 'Dr. James Brown', 'EE101');

-- 4. registrations table
CREATE TABLE registrations (
    registration_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    unit_id INT,
    academic_year YEAR,
    semester INT,
    registration_date DATE,
    status ENUM('registered', 'completed', 'dropped') DEFAULT 'registered',
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (unit_id) REFERENCES units(unit_id),
    UNIQUE KEY unique_registration (student_id, unit_id, academic_year, semester)
);

-- Insert sample registrations
INSERT INTO registrations (student_id, unit_id, academic_year, semester, registration_date, status) VALUES
(1, 1, 2024, 1, '2024-01-15', 'registered'),
(1, 3, 2024, 1, '2024-01-15', 'registered'),
(1, 4, 2024, 1, '2024-01-15', 'registered'),
(2, 4, 2024, 1, '2024-01-16', 'registered'),
(2, 5, 2024, 1, '2024-01-16', 'registered'),
(3, 1, 2024, 1, '2024-01-15', 'registered'),
(3, 2, 2024, 1, '2024-01-15', 'registered'),
(4, 6, 2024, 1, '2024-01-17', 'registered'),
(4, 7, 2024, 1, '2024-01-17', 'registered');

-- 5. payments table
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE,
    payment_method ENUM('credit_card', 'bank_transfer', 'cash', 'online') DEFAULT 'online',
    transaction_id VARCHAR(100),
    academic_year YEAR,
    semester INT,
    payment_type ENUM('tuition', 'registration', 'library', 'other') DEFAULT 'tuition',
    status ENUM('pending', 'completed', 'failed', 'refunded') DEFAULT 'completed',
    balance DECIMAL(10,2) DEFAULT 0,
    description TEXT,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- Insert sample payments
INSERT INTO payments (student_id, amount, payment_date, payment_method, transaction_id, academic_year, semester, payment_type, status, balance, description) VALUES
(1, 1500.00, '2024-01-10', 'online', 'TXN001234', 2024, 1, 'tuition', 'completed', 0.00, 'Tuition fee for Spring 2024'),
(1, 100.00, '2024-01-12', 'credit_card', 'TXN001235', 2024, 1, 'registration', 'completed', 0.00, 'Registration fee'),
(2, 1500.00, '2024-01-11', 'bank_transfer', 'TXN001236', 2024, 1, 'tuition', 'completed', 0.00, 'Tuition fee for Spring 2024'),
(3, 1200.00, '2024-01-13', 'online', 'TXN001237', 2024, 1, 'tuition', 'completed', 300.00, 'Partial tuition payment'),
(4, 1500.00, '2024-01-14', 'credit_card', 'TXN001238', 2024, 1, 'tuition', 'completed', 0.00, 'Tuition fee for Spring 2024');

-- 6. grades table
CREATE TABLE grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    unit_id INT,
    academic_year YEAR,
    semester INT,
    marks DECIMAL(5,2),
    grade VARCHAR(2),
    grade_points DECIMAL(3,2),
    status ENUM('pass', 'fail', 'incomplete') DEFAULT 'pass',
    assessment_date DATE,
    lecturer_notes TEXT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (unit_id) REFERENCES units(unit_id),
    UNIQUE KEY unique_grade (student_id, unit_id, academic_year, semester)
);

-- Insert sample grades (for previous semester)
INSERT INTO grades (student_id, unit_id, academic_year, semester, marks, grade, grade_points, status, assessment_date, lecturer_notes) VALUES
(1, 1, 2023, 2, 85.50, 'A', 4.00, 'pass', '2023-12-15', 'Excellent performance'),
(1, 2, 2023, 2, 78.00, 'B+', 3.50, 'pass', '2023-12-18', 'Good understanding of concepts'),
(2, 4, 2023, 2, 92.00, 'A+', 4.00, 'pass', '2023-12-16', 'Outstanding work'),
(3, 1, 2023, 2, 65.00, 'C', 2.00, 'pass', '2023-12-15', 'Satisfactory, needs improvement'),
(3, 3, 2023, 2, 72.50, 'B', 3.00, 'pass', '2023-12-20', 'Good progress');

-- 7. users table (for admin/lecturer management)
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role ENUM('admin', 'lecturer', 'staff') DEFAULT 'lecturer',
    department_id INT,
    phone_number VARCHAR(20),
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Insert sample users
INSERT INTO users (username, email, password_hash, first_name, last_name, role, department_id, phone_number, is_active) VALUES
('admin.john', 'admin.john@university.edu', 'hashed_admin_pass', 'John', 'Admin', 'admin', NULL, '+1234567800', TRUE),
('lecturer.alice', 'alice.johnson@university.edu', 'hashed_lecturer_pass', 'Alice', 'Johnson', 'lecturer', 1, '+1234567801', TRUE),
('lecturer.robert', 'robert.chen@university.edu', 'hashed_lecturer_pass2', 'Robert', 'Chen', 'lecturer', 2, '+1234567802', TRUE),
('lecturer.maria', 'maria.gonzalez@university.edu', 'hashed_lecturer_pass3', 'Maria', 'Gonzalez', 'lecturer', 3, '+1234567803', TRUE),
('staff.registrar', 'registrar@university.edu', 'hashed_staff_pass', 'Sarah', 'Wilson', 'staff', NULL, '+1234567804', TRUE);

-- Create indexes for better performance
CREATE INDEX idx_students_email ON students(email);
CREATE INDEX idx_students_department ON students(department_id);
CREATE INDEX idx_units_department ON units(department_id);
CREATE INDEX idx_registrations_student ON registrations(student_id);
CREATE INDEX idx_registrations_unit ON registrations(unit_id);
CREATE INDEX idx_grades_student ON grades(student_id);
CREATE INDEX idx_grades_unit ON grades(unit_id);
CREATE INDEX idx_payments_student ON payments(student_id);
CREATE INDEX idx_users_role ON users(role);