-- Foreign-key and common lookup indexes (primary keys and UNIQUE already indexed)
CREATE INDEX IF NOT EXISTS idx_student_department ON university_registration.student(department_id);
CREATE INDEX IF NOT EXISTS idx_instructor_department ON university_registration.instructor(department_id);
CREATE INDEX IF NOT EXISTS idx_course_department ON university_registration.course(department_id);
CREATE INDEX IF NOT EXISTS idx_section_course_semester ON university_registration.section(course_id,semester_id);
CREATE INDEX IF NOT EXISTS idx_section_instructor ON university_registration.section(instructor_id);
CREATE INDEX IF NOT EXISTS idx_section_classroom ON university_registration.section(classroom_id);
CREATE INDEX IF NOT EXISTS idx_enrollment_student ON university_registration.enrollment(student_id);
CREATE INDEX IF NOT EXISTS idx_enrollment_section_status ON university_registration.enrollment(section_id,enrollment_status);
