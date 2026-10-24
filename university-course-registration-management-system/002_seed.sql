-- Bishnu Bahadur GC and Swastika Poudel · CIT 406
-- Run after schema.sql. Fictional academic records; no real student data.
-- Explicit keys make relationships easy to inspect in Supabase.
BEGIN;

INSERT INTO university_registration.department (department_id, department_name, office_location, phone_number) VALUES
  (1, 'Computer Science', 'Technology Hall 201', '555-0101'),
  (2, 'Mathematics', 'Science Hall 110', '555-0102');

INSERT INTO university_registration.semester (semester_id, semester_name, academic_year, start_date, end_date) VALUES
  (1, 'Fall', 2026, '2026-09-01', '2026-12-18');

INSERT INTO university_registration.classroom (classroom_id, building_name, room_number, capacity) VALUES
  (1, 'Technology Hall', '204', 32),
  (2, 'Science Hall', '115', 28);

INSERT INTO university_registration.student (student_id, first_name, last_name, email, phone, date_of_birth, department_id) VALUES
  (1, 'Maya', 'Rai', 'maya.rai@example.edu', '555-1001', '2004-05-12', 1),
  (2, 'Alex', 'Chen', 'alex.chen@example.edu', '555-1002', '2003-11-03', 2),
  (3, 'Nina', 'Patel', 'nina.patel@example.edu', NULL, '2005-02-08', 1);

INSERT INTO university_registration.instructor (instructor_id, first_name, last_name, email, phone, department_id) VALUES
  (1, 'Jordan', 'Lee', 'jordan.lee@example.edu', '555-2001', 1),
  (2, 'Amara', 'Singh', 'amara.singh@example.edu', '555-2002', 2);

INSERT INTO university_registration.course (course_id, course_code, course_name, credit_hours, description, department_id) VALUES
  (1, 'CIT 406', 'Database Design', 3, 'Relational database design and implementation', 1),
  (2, 'MAT 210', 'Discrete Mathematics', 3, 'Logic, sets, and discrete structures', 2);

INSERT INTO university_registration.section (section_id, section_number, schedule, maximum_capacity, course_id, instructor_id, semester_id, classroom_id) VALUES
  (1, '01', 'Mon/Wed 10:00-11:15', 25, 1, 1, 1, 1),
  (2, '01', 'Tue/Thu 13:00-14:15', 25, 2, 2, 1, 2);

INSERT INTO university_registration.enrollment (enrollment_id, student_id, section_id, enrollment_date, enrollment_status, grade) VALUES
  (1, 1, 1, '2026-08-20', 'Enrolled', NULL),
  (2, 2, 1, '2026-08-21', 'Enrolled', NULL),
  (3, 2, 2, '2026-08-21', 'Enrolled', NULL),
  (4, 3, 1, '2026-08-22', 'Enrolled', NULL);

-- Advance identity sequences so future inserts receive unused IDs.
SELECT setval(pg_get_serial_sequence('university_registration.department','department_id'), (SELECT max(department_id) FROM university_registration.department));
SELECT setval(pg_get_serial_sequence('university_registration.semester','semester_id'), (SELECT max(semester_id) FROM university_registration.semester));
SELECT setval(pg_get_serial_sequence('university_registration.classroom','classroom_id'), (SELECT max(classroom_id) FROM university_registration.classroom));
SELECT setval(pg_get_serial_sequence('university_registration.student','student_id'), (SELECT max(student_id) FROM university_registration.student));
SELECT setval(pg_get_serial_sequence('university_registration.instructor','instructor_id'), (SELECT max(instructor_id) FROM university_registration.instructor));
SELECT setval(pg_get_serial_sequence('university_registration.course','course_id'), (SELECT max(course_id) FROM university_registration.course));
SELECT setval(pg_get_serial_sequence('university_registration.section','section_id'), (SELECT max(section_id) FROM university_registration.section));
SELECT setval(pg_get_serial_sequence('university_registration.enrollment','enrollment_id'), (SELECT max(enrollment_id) FROM university_registration.enrollment));
COMMIT;
