# University Course Registration and Department Management System

**Course:** CIT 406 Database Design  
**Institution:** Atlantis University  
**Project team:** Shivam Birat Yadav, Bishnu Bahadur GC, and Swastika Poudel  
**Release documentation:** October 2026

## Project contents

- `001_schema.sql` creates the eight core tables in the `university_registration` schema.
- `002_seed.sql` inserts fictional sample records and sets identity sequences.
- `003_logic.sql` creates the roster and capacity views, available-seat function, audit table, and status-change trigger.
- `004_indexes.sql` creates indexes for common joins and lookups.
- `005_security.sql` revokes PUBLIC privileges and enables restrictive row-level security policies on sensitive tables.
- `migrations/` contains the forward and reverse migration for older databases that lack `enrollment_status`.
- `DATA_DICTIONARY.md` documents every table and column.
- `ERD.mmd` describes the current tables and foreign-key relationships.
- `smoke_test.sql` runs basic checks after setup.
- `portfolio.sql` contains example queries for the course project.

## Rebuild from scratch with pgAdmin

Use a new, empty PostgreSQL database. The scripts create a project schema named `university_registration` inside that database.

1. In pgAdmin, connect to the PostgreSQL server. Right-click **Databases → Create → Database** and give the new database a name such as `university_registration_db`.
2. Select the new database and open **Tools → Query Tool**.
3. Open and execute each SQL file below, one at a time, using the Query Tool's **Open File** button and **F5**. Check the **Messages** panel after each file before continuing:
   1. `001_schema.sql`
   2. `002_seed.sql`
   3. `003_logic.sql`
   4. `004_indexes.sql`
   5. `005_security.sql`
4. Open and run `smoke_test.sql` to confirm the sample rows, views, and function return results.
5. Open and run `portfolio.sql` to explore the example queries.
6. Open `ERD.mmd` in a Mermaid-compatible Markdown viewer to view the entity relationship diagram.

The seed file uses explicit IDs and is intended to run once in a clean schema. Do not run it repeatedly; duplicate-key errors are expected if its sample records are already present. For a disposable database only, a full reset is possible with `DROP SCHEMA IF EXISTS university_registration CASCADE;` followed by steps 3–5. This command permanently deletes all objects and data in that schema.

### Rebuild with psql

From the project directory, set `DATABASE_URL` to a connection string for the new database, then run:

```sh
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f 001_schema.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f 002_seed.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f 003_logic.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f 004_indexes.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f 005_security.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f smoke_test.sql
```

Never commit passwords or connection strings containing credentials.

## Migration notes

`001_schema.sql` already includes `enrollment_status` for a clean rebuild. The scripts in `migrations/` are a compatibility upgrade for an older deployed version of this project whose `enrollment` table did not yet have that column. Apply `006_enrollment_status.up.sql` **only** if the column is absent. Do not run it after a clean rebuild. The `.down.sql` file removes the status constraint and column; back up the database first and use it only when intentionally reversing that upgrade. Do not run the `.down.sql` during the standard rebuild.

## Security and design notes

- Foreign keys preserve relationships among departments, students, instructors, courses, semesters, classrooms, sections, and enrollments. Delete behavior is restrictive where deleting a referenced record could erase academic history.
- `enrollment` is the associative table connecting students to sections. It also stores registration date, status, and grade.
- `v_section_roster` presents enrollment and student details. `v_section_capacity` reports enrollment counts and remaining seats. `available_seats(section_id)` returns the reported seats for a section.
- The trigger writes status changes to `enrollment_audit`. The audit table's `enrollment_id` is a recorded identifier, not a declared foreign key.
- The security migration intentionally provides no end-user access policies. RLS therefore denies access to these protected tables for ordinary roles. Database owners and privileged service roles can bypass RLS; application-specific least-privilege grants and verified user-to-student policies are needed before student-facing use.

## Limitations

The capacity view reports seats but does not prevent over-enrollment. Cross-row schedule conflicts are not enforced. Add transactional enforcement and application-specific security policies before production use. Views and their privileges also require a deliberate review in a deployed application.

## Verification record

During the guided pgAdmin session, the user confirmed that `003_logic.sql`, `004_indexes.sql`, and `005_security.sql` completed successfully. The capacity view returned three sections with available seats, `available_seats(1)` returned 28, and `v_section_roster` returned four enrollment rows. Those checks were against an existing database with an older baseline and a compatibility migration; they are not a clean-room execution of this repository's seeded rebuild. Run `smoke_test.sql` against a fresh database before submission to verify the exact packaged seed data.
