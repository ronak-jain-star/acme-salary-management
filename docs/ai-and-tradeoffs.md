# Architecture decisions and trade-offs

## Decisions

- **Rails API and React UI in one repository and deployment.** One submission checkout gives reviewers the end-to-end feature and keeps API/UI changes together. The UI remains a separate `frontend/` source directory, but Docker builds it locally into Rails' `public/` directory. This gives up independent frontend releases, which are unnecessary for this single-assessment app.
- **PostgreSQL rather than SQLite.** PostgreSQL matches the deployment and CI database and provides `PERCENTILE_CONT` for exact median calculation. SQLite would reduce local setup, but would not exercise the same production SQL or aggregation behavior.
- **Integer minor units rather than floating point.** Integer storage avoids binary floating-point rounding for money. It requires currency-aware formatting at the UI boundary; currency codes are always carried with amounts.
- **Offset pagination rather than keyset pagination.** The directory has stable name ordering, a 100-row page cap, and a 10,000-row target. Offset pagination keeps the page-number UI simple. Deep-page latency is a known trade-off; use keyset pagination if measured response times no longer meet the target.
- **Aggregate in PostgreSQL rather than the browser.** `SalaryInsights` computes grouped count, average, median (`PERCENTILE_CONT`), minimum, and maximum in SQL. The browser receives a small grouped result instead of loading all salary rows. Every group includes currency, preventing accidental cross-currency totals.
- **`SalaryUpdater` service object rather than controller-owned writes.** It validates the inputs and updates current salary plus its history row inside one transaction. That keeps the audit behavior testable and atomic, at the cost of a small domain service alongside Active Record models.
- **Deterministic row-by-row seed inside a transaction rather than bulk import tooling.** `db/seeds.rb` creates synthetic employees and salaries using ordinary validations. The trade-off is slower seeding than bulk insert; for 10,000 demo rows the simpler path is acceptable until measured seed time says otherwise.

## Performance considerations

- Directory results include current salary in one query path to avoid an N+1 salary lookup. Page size is capped at 100.
- Indexes support unique employee-number lookup, country/department filters, employee-to-current-salary joins, currency/amount queries, and employee history ordered by creation time.
- Insights return grouped aggregates from PostgreSQL and do not materialize 10,000 salary records in Rails.
- Requirements set measurement targets of p95 under 500 ms for directory responses and under 1 second for insights on a documented 2-vCPU/4-GB PostgreSQL environment. These have **not** been benchmarked yet, so no achieved timing is claimed.

## AI use and review

AI assisted scaffolding, test ideas, code review, and remediation of CI findings. The author reviewed and steered the implementation. A concrete review correction is the audit actor: because there is no authentication, the API now writes a fixed `HR Manager` label and ignores a caller-supplied `changed_by` value; the request spec checks this. It is a placeholder label, not verified identity. Salary history model callbacks reject update and delete attempts.

Other checks include request specs for currency-separated insight groups, salary validation, transaction outcomes, and the audit row; CI runs RSpec, frontend tests/build, RuboCop, and Brakeman. See [representative prompts and review notes](ai-prompts.md). The prompts file is a summary, not a verbatim AI transcript.

## Limits and deferred decisions

Authentication/authorization, identity-provider choice, approval flow, compensation bands, payroll/tax rules, pay period, FX rate source and effective-date policy, CSV import/export, retention, backups, encryption/key management, and privacy review remain open. Synthetic demo data only; adding real salary records requires those controls and organization policy decisions first.
