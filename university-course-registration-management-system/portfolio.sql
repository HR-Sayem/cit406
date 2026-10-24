-- Atlantis University
-- CIT 406 - Database Design
-- Module 5: Assignment 2 - Project Query Portfolio
-- Project: University Course Registration and Department Management System
-- Group Members: Shivam Birat Yadav, Bishnu Bahadur GC, Swastika Poudel
-- Date: October 1, 2026

-- ============================================================
-- QUERY 1: Which courses and sections is each student enrolled in, and during which semester?
-- ============================================================
SELECT
    s.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    c.course_code,
    c.course_name,
    sec.section_number,
    sem.semester_name,
    sem.academic_year,
    e.enrollment_status
FROM university_registration.student s
JOIN university_registration.enrollment e
    ON s.student_id = e.student_id
JOIN university_registration.section sec
    ON e.section_id = sec.section_id
JOIN university_registration.course c
    ON sec.course_id = c.course_id
JOIN university_registration.semester sem
    ON sec.semester_id = sem.semester_id
ORDER BY s.student_id, c.course_code;

-- ============================================================
-- QUERY 2: How many distinct students are enrolled in each course?
-- ============================================================
SELECT
    c.course_code,
    c.course_name,
    COUNT(DISTINCT e.student_id) AS total_students
FROM university_registration.course c
JOIN university_registration.section sec
    ON c.course_id = sec.course_id
LEFT JOIN university_registration.enrollment e
    ON sec.section_id = e.section_id
GROUP BY
    c.course_id,
    c.course_code,
    c.course_name
ORDER BY total_students DESC, c.course_code;

-- ============================================================
-- QUERY 3: What courses are offered by each department?
-- ============================================================
SELECT
    d.department_name,
    c.course_code,
    c.course_name,
    c.credit_hours
FROM university_registration.department d
JOIN university_registration.course c
    ON d.department_id = c.department_id
ORDER BY d.department_name, c.course_code;

-- ============================================================
-- QUERY 4: Which instructors are assigned to teach each course section?
-- ============================================================
SELECT
    i.first_name || ' ' || i.last_name AS instructor_name,
    c.course_code,
    c.course_name,
    sec.section_number,
    sem.semester_name,
    sem.academic_year
FROM university_registration.instructor i
JOIN university_registration.section sec
    ON i.instructor_id = sec.instructor_id
JOIN university_registration.course c
    ON sec.course_id = c.course_id
JOIN university_registration.semester sem
    ON sec.semester_id = sem.semester_id
ORDER BY instructor_name, c.course_code;

-- ============================================================
-- QUERY 5: How many student enrollment records are associated with each semester?
-- ============================================================
SELECT
    sem.semester_name,
    sem.academic_year,
    COUNT(e.enrollment_id) AS total_enrollments
FROM university_registration.semester sem
JOIN university_registration.section sec
    ON sem.semester_id = sec.semester_id
LEFT JOIN university_registration.enrollment e
    ON sec.section_id = e.section_id
GROUP BY
    sem.semester_id,
    sem.semester_name,
    sem.academic_year
ORDER BY
    sem.academic_year,
    sem.semester_name;

-- ============================================================
-- QUERY 6: Which students have more than one enrollment record?
-- ============================================================
SELECT
    s.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    COUNT(e.enrollment_id) AS total_enrollments
FROM university_registration.student s
JOIN university_registration.enrollment e
    ON s.student_id = e.student_id
GROUP BY
    s.student_id,
    s.first_name,
    s.last_name
HAVING COUNT(e.enrollment_id) > 1
ORDER BY total_enrollments DESC, student_name;

-- ============================================================
-- QUERY 7: How many students are enrolled in each course section?
-- ============================================================
SELECT
    c.course_code,
    c.course_name,
    sec.section_number,
    sem.semester_name,
    sem.academic_year,
    COUNT(e.enrollment_id) AS total_enrollments
FROM university_registration.section sec
JOIN university_registration.course c
    ON sec.course_id = c.course_id
JOIN university_registration.semester sem
    ON sec.semester_id = sem.semester_id
LEFT JOIN university_registration.enrollment e
    ON sec.section_id = e.section_id
GROUP BY
    sec.section_id,
    c.course_code,
    c.course_name,
    sec.section_number,
    sem.semester_name,
    sem.academic_year
ORDER BY total_enrollments DESC, c.course_code;

-- ============================================================
-- QUERY 8: Which students are enrolled in CIT406 Database Design?
-- ============================================================
SELECT
    s.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    c.course_code,
    c.course_name,
    sem.semester_name,
    sem.academic_year
FROM university_registration.student s
JOIN university_registration.enrollment e
    ON s.student_id = e.student_id
JOIN university_registration.section sec
    ON e.section_id = sec.section_id
JOIN university_registration.course c
    ON sec.course_id = c.course_id
JOIN university_registration.semester sem
    ON sec.semester_id = sem.semester_id
WHERE c.course_code = 'CIT 406'
ORDER BY student_name, sem.semester_name;

-- ============================================================
-- QUERY 9: Which courses have more credit hours than the average credit hours of all courses?
-- ============================================================
SELECT
    c.course_code,
    c.course_name,
    c.credit_hours
FROM university_registration.course c
WHERE c.credit_hours > (
    SELECT AVG(credit_hours)
    FROM university_registration.course
)
ORDER BY c.credit_hours DESC, c.course_code;

-- ============================================================
-- QUERY 10: Where and during which semester is each course section scheduled?
-- ============================================================
SELECT
    c.course_code,
    c.course_name,
    sec.section_number,
    sem.semester_name,
    sem.academic_year,
    cl.building_name,
    cl.room_number
FROM university_registration.section sec
JOIN university_registration.course c
    ON sec.course_id = c.course_id
JOIN university_registration.semester sem
    ON sec.semester_id = sem.semester_id
JOIN university_registration.classroom cl
    ON sec.classroom_id = cl.classroom_id
ORDER BY
    sem.academic_year,
    sem.semester_name,
    c.course_code;

