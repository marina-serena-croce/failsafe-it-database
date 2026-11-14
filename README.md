# failsafe-it-database
SQL Server database for FailSafe IT to manage clients, consultants, projects and assignments.

## ER diagram
[View the FailSafe IT ER diagram in Lucidchart](https://lucid.app/lucidchart/93d93899-9094-48fb-9605-1a443eef6f98/edit?view_items=XHGMYBc8e5ZD&page=0_0&invitationId=inv_ac1efd06-8d58-429f-b7ba-54d57c91b42d)

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
