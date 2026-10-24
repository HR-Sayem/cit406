# Migrations

`006_enrollment_status.up.sql` and `.down.sql` document a compatibility upgrade for a prior version of the database that did not include `enrollment_status`. The up migration adds the column and its allowed-value constraint; existing rows receive the default `Enrolled`. The down migration drops that constraint and column, so it discards stored statuses. Back up first.

The clean baseline in `../001_schema.sql` already defines `enrollment_status`. Therefore, do not run this compatibility migration in the standard fresh rebuild sequence. Apply the up migration only once to an older schema after confirming the column is absent.
