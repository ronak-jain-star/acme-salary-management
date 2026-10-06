# ACME Pay: requirements (v1)

## Goal and user

Replace spreadsheet-based salary tracking for ACME's 10,000 employees with a web workspace for the HR manager. Help the HR manager find employees, understand how salary is distributed, and record a salary change with a reason.

## Questions this version answers

- How many employees are in each country and department? The insights view reports headcount by country, department, and currency.
- Within a country, department, and currency group, what are the average, median, minimum, and maximum salaries? The insights endpoint calculates these values in the database and keeps currencies separate.
- What is an employee's current salary and currency, and why was it changed? The directory/detail views show current pay and the salary history shows old/new amounts, reason, timestamp, and a fixed `HR Manager` actor label.

## Assumptions and scope

- Salary means annual gross base pay. Store it as integer minor units with a three-letter currency code. Never add, compare, or rank amounts from different currencies.
- Each employee has one current salary. The seed supplies a job title, but v1 has no standardized level taxonomy and does not filter or group insights by title.
- The assessment has one HR manager persona and no identity provider. `changed_by` is a fixed `HR Manager` label in this demo, not a verified person or authentication mechanism.
- In scope: searchable, paginated employee directory; country and department filters; salary and currency display; validated salary edits with a reason; append-only salary history; grouped headcount and distribution statistics; responsive React UI; deterministic seed of 10,000 synthetic employees; automated checks for the core paths.

## Deliberate exclusions

- **Authentication, roles, and SSO:** the brief defines one persona but no identity provider, role policy, or access lifecycle. This is a blocking prerequisite before real compensation data is used.
- **Payroll, taxes, deductions, benefits, approvals, and historical pay periods:** these require compensation and compliance policies beyond the questions in this version.
- **FX conversion:** no authoritative rate source, effective-date policy, or rounding/display rule was supplied. The safe v1 behavior is to keep currencies separate. A later version could add an explicitly indicative cross-currency view with a named rate source and effective date.
- **Bulk CSV import/export:** useful operationally, but not needed to replace the core lookup and insight workflow; imports also need validation, permissions, and error-recovery rules.
- **Compensation bands and title/level analytics:** no approved job architecture or band data was supplied. Titles are seeded as descriptive employee fields only.
- **Production privacy and operations controls:** encryption/key management, backups, retention, monitoring, and a security review require deployment-specific decisions. The synthetic-data assessment is not ready for production salary records.

## Success and performance checks

- Seed exactly 10,000 repeatable synthetic employees in an empty database.
- Return no more than 100 directory rows per request and support name/ID search plus country/department filters.
- Validate every salary edit and atomically update current pay while appending a history row.
- Keep every aggregate grouped by currency; specs exercise records with different currencies.
- Performance targets to measure on a documented 2-vCPU/4-GB PostgreSQL environment with 10,000 seeded employees: p95 directory response under 500 ms and insights response under 1 second. These are targets, not claimed measurements; record benchmark results before presenting them as achieved.
