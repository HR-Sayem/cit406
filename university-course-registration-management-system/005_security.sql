-- Defense-in-depth: deny anonymous access; enable RLS on sensitive tables.
-- Run as database owner. PostgreSQL owners and privileged service roles may bypass RLS.
REVOKE ALL ON SCHEMA university_registration FROM PUBLIC;
REVOKE ALL ON ALL TABLES IN SCHEMA university_registration FROM PUBLIC;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA university_registration FROM PUBLIC;
ALTER TABLE university_registration.student ENABLE ROW LEVEL SECURITY;
ALTER TABLE university_registration.instructor ENABLE ROW LEVEL SECURITY;
ALTER TABLE university_registration.enrollment ENABLE ROW LEVEL SECURITY;
ALTER TABLE university_registration.enrollment_audit ENABLE ROW LEVEL SECURITY;
-- No public policies: default deny for non-owner roles. Application-specific policies
-- must be added only after an authenticated user-to-student identity mapping exists.
-- Do not grant broad access to roster views: PostgreSQL views can execute as their owner.
-- Security Policies for University Registration System
-- CIT 406 Database Design
-- Atlantis University

-- Student table: deny access to non-owner roles
DROP POLICY IF EXISTS student_access_policy
ON university_registration.student;

CREATE POLICY student_access_policy
ON university_registration.student
AS RESTRICTIVE
FOR ALL
TO PUBLIC
USING (false)
WITH CHECK (false);

-- Instructor table: deny access to non-owner roles
DROP POLICY IF EXISTS instructor_access_policy
ON university_registration.instructor;

CREATE POLICY instructor_access_policy
ON university_registration.instructor
AS RESTRICTIVE
FOR ALL
TO PUBLIC
USING (false)
WITH CHECK (false);

-- Enrollment table: deny access to non-owner roles
DROP POLICY IF EXISTS enrollment_access_policy
ON university_registration.enrollment;

CREATE POLICY enrollment_access_policy
ON university_registration.enrollment
AS RESTRICTIVE
FOR ALL
TO PUBLIC
USING (false)
WITH CHECK (false);

-- Enrollment audit table: protect audit records
DROP POLICY IF EXISTS audit_access_policy
ON university_registration.enrollment_audit;

CREATE POLICY audit_access_policy
ON university_registration.enrollment_audit
AS RESTRICTIVE
FOR ALL
TO PUBLIC
USING (false)
WITH CHECK (false);
