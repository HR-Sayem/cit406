-- Reusable university registration logic (PostgreSQL)
CREATE OR REPLACE VIEW university_registration.v_section_roster AS
SELECT s.section_id,c.course_code,c.course_name,s.section_number,st.student_id,
 st.first_name,st.last_name,e.enrollment_status,e.grade
FROM university_registration.section s JOIN university_registration.course c USING(course_id)
JOIN university_registration.enrollment e USING(section_id)
JOIN university_registration.student st USING(student_id);
CREATE OR REPLACE VIEW university_registration.v_section_capacity AS
SELECT s.section_id,c.course_code,s.maximum_capacity,
 COUNT(e.enrollment_id) FILTER (WHERE e.enrollment_status='Enrolled') AS enrolled_count,
 s.maximum_capacity-COUNT(e.enrollment_id) FILTER (WHERE e.enrollment_status='Enrolled') AS available_seats
FROM university_registration.section s JOIN university_registration.course c USING(course_id)
LEFT JOIN university_registration.enrollment e USING(section_id)
GROUP BY s.section_id,c.course_code;
CREATE OR REPLACE FUNCTION university_registration.available_seats(p_section_id INTEGER)
RETURNS BIGINT LANGUAGE SQL STABLE AS $$
SELECT available_seats FROM university_registration.v_section_capacity WHERE section_id=p_section_id;
$$;
CREATE TABLE IF NOT EXISTS university_registration.enrollment_audit (
 audit_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 enrollment_id INTEGER NOT NULL, old_status VARCHAR(20), new_status VARCHAR(20),
 changed_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(), changed_by TEXT NOT NULL DEFAULT current_user
);
CREATE OR REPLACE FUNCTION university_registration.audit_enrollment_status() RETURNS TRIGGER
LANGUAGE plpgsql AS $$ BEGIN
 INSERT INTO university_registration.enrollment_audit(enrollment_id,old_status,new_status)
 VALUES(NEW.enrollment_id,OLD.enrollment_status,NEW.enrollment_status);
 RETURN NEW; END $$;
DROP TRIGGER IF EXISTS trg_enrollment_status_audit ON university_registration.enrollment;
CREATE TRIGGER trg_enrollment_status_audit AFTER UPDATE OF enrollment_status ON university_registration.enrollment
FOR EACH ROW WHEN (OLD.enrollment_status IS DISTINCT FROM NEW.enrollment_status)
EXECUTE FUNCTION university_registration.audit_enrollment_status();
