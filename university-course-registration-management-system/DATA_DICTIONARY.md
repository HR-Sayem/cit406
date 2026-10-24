# Data dictionary

Schema: `university_registration`. Types and constraints below describe the clean baseline created by `001_schema.sql`; `enrollment_audit` is created by `003_logic.sql`.

## `department`

| Column | Type | Nullability / constraints | Description |
|---|---|---|---|
| `department_id` | `INTEGER` | NOT NULL, identity, primary key | Unique department identifier. |
| `department_name` | `VARCHAR(100)` | NOT NULL, UNIQUE | Department's name. |
| `office_location` | `VARCHAR(100)` | Nullable | Office or building location. |
| `phone_number` | `VARCHAR(30)` | Nullable | Department contact number. |

## `student`

| Column | Type | Nullability / constraints | Description |
|---|---|---|---|
| `student_id` | `INTEGER` | NOT NULL, identity, primary key | Unique student identifier. |
| `first_name` | `VARCHAR(80)` | NOT NULL | Student's first name. |
| `last_name` | `VARCHAR(80)` | NOT NULL | Student's last name. |
| `email` | `VARCHAR(255)` | NOT NULL, UNIQUE | Student email address. |
| `phone` | `VARCHAR(30)` | Nullable | Student contact number. |
| `date_of_birth` | `DATE` | Nullable | Student date of birth. |
| `department_id` | `INTEGER` | NOT NULL, foreign key to `department.department_id` | Student's department or major. |

## `instructor`

| Column | Type | Nullability / constraints | Description |
|---|---|---|---|
| `instructor_id` | `INTEGER` | NOT NULL, identity, primary key | Unique instructor identifier. |
| `first_name` | `VARCHAR(80)` | NOT NULL | Instructor's first name. |
| `last_name` | `VARCHAR(80)` | NOT NULL | Instructor's last name. |
| `email` | `VARCHAR(255)` | NOT NULL, UNIQUE | Instructor email address. |
| `phone` | `VARCHAR(30)` | Nullable | Instructor contact number. |
| `department_id` | `INTEGER` | NOT NULL, foreign key to `department.department_id` | Instructor's department. |

## `course`

| Column | Type | Nullability / constraints | Description |
|---|---|---|---|
| `course_id` | `INTEGER` | NOT NULL, identity, primary key | Unique catalog course identifier. |
| `course_code` | `VARCHAR(20)` | NOT NULL, UNIQUE | Catalog code, such as `CIT 406`. |
| `course_name` | `VARCHAR(150)` | NOT NULL | Course title. |
| `credit_hours` | `INTEGER` | NOT NULL, CHECK 1–6 | Number of credits awarded. |
| `description` | `TEXT` | Nullable | Course description. |
| `department_id` | `INTEGER` | NOT NULL, foreign key to `department.department_id` | Owning department. |

## `semester`

| Column | Type | Nullability / constraints | Description |
|---|---|---|---|
| `semester_id` | `INTEGER` | NOT NULL, identity, primary key | Unique semester identifier. |
| `semester_name` | `VARCHAR(40)` | NOT NULL; unique with `academic_year` | Term name, such as Fall. |
| `academic_year` | `INTEGER` | NOT NULL, CHECK 2000–2200; unique with `semester_name` | Academic year. |
| `start_date` | `DATE` | NOT NULL | First date of the term. |
| `end_date` | `DATE` | NOT NULL, CHECK not earlier than `start_date` | Last date of the term. |

## `classroom`

| Column | Type | Nullability / constraints | Description |
|---|---|---|---|
| `classroom_id` | `INTEGER` | NOT NULL, identity, primary key | Unique classroom identifier. |
| `building_name` | `VARCHAR(100)` | NOT NULL; unique with `room_number` | Building name. |
| `room_number` | `VARCHAR(20)` | NOT NULL; unique with `building_name` | Room number within the building. |
| `capacity` | `INTEGER` | NOT NULL, CHECK greater than 0 | Physical room capacity. |

## `section`

| Column | Type | Nullability / constraints | Description |
|---|---|---|---|
| `section_id` | `INTEGER` | NOT NULL, identity, primary key | Unique section offering identifier. |
| `section_number` | `VARCHAR(20)` | NOT NULL; unique within course and semester | Section label, such as `01`. |
| `schedule` | `VARCHAR(120)` | NOT NULL | Meeting days and time. |
| `maximum_capacity` | `INTEGER` | NOT NULL, CHECK greater than 0 | Intended enrollment limit; not enforced against enrollment rows. |
| `course_id` | `INTEGER` | NOT NULL, foreign key to `course.course_id` | Course offered by the section. |
| `instructor_id` | `INTEGER` | NOT NULL, foreign key to `instructor.instructor_id` | Instructor assigned to the section. |
| `semester_id` | `INTEGER` | NOT NULL, foreign key to `semester.semester_id` | Term in which the section is offered. |
| `classroom_id` | `INTEGER` | NOT NULL, foreign key to `classroom.classroom_id` | Room assigned to the section. |

Unique constraint: `(course_id, semester_id, section_number)`.

## `enrollment`

| Column | Type | Nullability / constraints | Description |
|---|---|---|---|
| `enrollment_id` | `INTEGER` | NOT NULL, identity, primary key | Unique registration record identifier. |
| `student_id` | `INTEGER` | NOT NULL, foreign key to `student.student_id` | Student registered in the section. |
| `section_id` | `INTEGER` | NOT NULL, foreign key to `section.section_id` | Section selected by the student. |
| `enrollment_date` | `DATE` | NOT NULL | Date the registration was recorded. |
| `enrollment_status` | `VARCHAR(20)` | NOT NULL, CHECK in `Enrolled`, `Completed`, `Dropped` | Current registration state. |
| `grade` | `VARCHAR(3)` | Nullable, CHECK in `A`, `A-`, `B+`, `B`, `B-`, `C+`, `C`, `C-`, `D`, `F`, `W` | Final grade or withdrawal marker. |

Unique constraint: `(student_id, section_id)` prevents duplicate registration by one student in a section.

## `enrollment_audit`

Created by `003_logic.sql` to record enrollment status changes. `enrollment_id` is intentionally not a foreign key so the log keeps the identifier independently of enrollment-row lifecycle.

| Column | Type | Nullability / constraints | Description |
|---|---|---|---|
| `audit_id` | `BIGINT` | NOT NULL, identity, primary key | Unique audit event identifier. |
| `enrollment_id` | `INTEGER` | NOT NULL | Identifier of the changed enrollment. |
| `old_status` | `VARCHAR(20)` | Nullable | Status before the update. |
| `new_status` | `VARCHAR(20)` | Nullable | Status after the update. |
| `changed_at` | `TIMESTAMPTZ` | NOT NULL, default `clock_timestamp()` | Timestamp when the trigger recorded the change. |
| `changed_by` | `TEXT` | NOT NULL, default `current_user` | Database role that performed the update. |
