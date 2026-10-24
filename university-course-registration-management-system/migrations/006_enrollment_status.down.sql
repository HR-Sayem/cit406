BEGIN;

ALTER TABLE university_registration.enrollment
DROP CONSTRAINT IF EXISTS enrollment_status_valid;

ALTER TABLE university_registration.enrollment
DROP COLUMN IF EXISTS enrollment_status;

COMMIT;
