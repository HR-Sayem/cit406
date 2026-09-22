# PostgreSQL Data Type Selection Exercise

| # | Column | PostgreSQL Data Type | Justification |
|---|--------|----------------------|---------------|
| 1 | student_id | `integer GENERATED ALWAYS AS IDENTITY` | It is a whole-number ID that PostgreSQL can automatically generate as students are added. |
| 2 | first_name | `varchar(50)` | A first name is text and the question says most names are fewer than 50 characters. |
| 3 | email_address | `varchar(255)` | An email address is text and 255 characters provides enough space for normal email addresses. |
| 4 | date_of_birth | `date` | Only the student's birthday is needed, so a date without a time is appropriate. |
| 5 | account_balance | `numeric(10,2)` | `numeric(10,2)` stores money accurately with two decimal places. |
| 6 | is_active | `boolean` | The account can have only two states, active or inactive, which maps to true or false. |
| 7 | event_start | `timestamptz` | The event needs an exact date and time, and participants may be in different time zones. |
| 8 | event_description | `text` | The description can contain several paragraphs and has no fixed maximum length. |
| 9 | maximum_attendees | `integer` | The maximum number of attendees is a whole number. |
| 10 | student_attended | `boolean` | Attendance has only two possible values, Yes or No. |
| 11 | phone_number | `varchar(25)` | A phone number should be stored as text so symbols such as +, -, spaces, and parentheses can be preserved. |
| 12 | postal_code | `varchar(10)` | A postal code is an identifier, so text preserves formatting and leading zeros. |
| 13 | event_status | `varchar(20)` | The event status is text and varchar allows additional status values to be added later. |
| 14 | student_number | `varchar(10)` | Text preserves leading zeros in values such as 001245. |