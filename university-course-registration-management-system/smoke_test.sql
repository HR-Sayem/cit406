SELECT COUNT(*) AS departments FROM university_registration.department;
SELECT COUNT(*) AS students FROM university_registration.student;
SELECT COUNT(*) AS enrollments FROM university_registration.enrollment;
SELECT * FROM university_registration.v_section_capacity ORDER BY section_id;
SELECT * FROM university_registration.v_section_roster ORDER BY section_id,student_id;
SELECT university_registration.available_seats(1) AS section_one_seats;
