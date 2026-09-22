### Exact PostgreSQL error

ERROR: 23502: null value in column "email" of relation "club_members" violates not-null constraint
DETAIL: Failing row contains (30, Test, Student, null, Cybersecurity, 2026-09-18).

### My explanation

PostgreSQL rejected this row because email was defined with NOT NULL, which means every club member must have an email address.