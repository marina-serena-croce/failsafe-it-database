# failsafe-it-database
SQL Server database for FailSafe IT to manage clients, consultants, projects and assignments.
####
Normalisation
####
**First normal form (1NF).** Each field holds a single value.
For example, each assignment stores one `ConsultantId`.
If several consultants work on the same project, each has a separate assignment row.

**Second normal form (2NF).** The candidate keys are single columns.
Each table has an `Id` primary key, and the unique organisation number and personal number also identify rows in their respective tables.
There is no multi-column key for a field to depend on only part of.

**Third normal form (3NF).** Client details are stored in `Clients`, consultant details in `Consultants`, and project details in `Projects`.
An assignment stores its `ProjectId`, and the project stores its `ClientId`.
This means the client is recorded once for each project, avoiding conflicting client IDs across its assignments.
