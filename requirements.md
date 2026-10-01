# ACME Salary Management — requirements (v1)

**Goal.** Replace spreadsheet-based salary tracking for ACME's 10,000 employees with a small, dependable HR workspace. An HR manager should find an employee, understand salary distribution by country and department, and make an auditable salary change.

**Users and assumptions.** One authorized HR manager persona. Salary is an annual gross base amount, stored as integer minor units with an ISO 4217 currency code; values in different currencies are never added or ranked together. Each employee has one current salary. The supplied brief does not specify authorization, approval, historical pay periods, or FX policy; v1 makes no claim to solve those.

**In scope.** Search and paginate the employee directory by name, ID, country, and department; view employee salary and currency; edit current annual salary with validation and a reason; record who/when/old/new/reason in an immutable change history; answer aggregate questions with headcount, average, median, minimum, and maximum by country/currency and department; seed 10,000 deterministic synthetic employees; responsive UI; automated tests for core behavior.

**Out of scope (and why).** Payroll runs, tax/deductions, benefits, compensation bands, FX conversion, bulk spreadsheet import/export, multiple roles/SSO, approval workflows, and production compliance controls. These require policy and security decisions absent from the prompt; shipping guesses would be unsafe. Production use requires authentication, authorization, encryption/key management, backups, audit retention, and privacy review before real salary data is loaded.

**Success checks.** Seed produces exactly 10,000 repeatable synthetic employees; directory requests are bounded and searchable; salary changes validate input and preserve an append-only audit record; aggregate results remain separated by currency; UI makes currency explicit and exposes search, employee detail/edit, and insights.
