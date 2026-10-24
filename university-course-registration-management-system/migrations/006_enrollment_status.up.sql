BEGIN;

ALTER TABLE university_registration.enrollment
ADD COLUMN enrollment_status VARCHAR(20) NOT NULL DEFAULT 'Enrolled';

ALTER TABLE university_registration.enrollment
ADD CONSTRAINT enrollment_status_valid
CHECK (enrollment_status IN ('Enrolled', 'Completed', 'Dropped'));

COMMIT;
