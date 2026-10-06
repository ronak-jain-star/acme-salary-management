# AI prompts and review notes

These examples summarize the prompts used during the assessment; they are not a verbatim conversation export.

## Representative prompts

- Turn the supplied assessment brief into a one-page requirements document before implementation. State the goal, scope, deliberate exclusions, and assumptions.
- Build a working employee salary management vertical slice with a Rails backend, React UI, relational storage, 10,000 synthetic employees, and focused tests.
- Keep salary edits auditable, validate the amount and reason, and avoid combining or comparing totals across currencies without conversion rules.
- Review the failed CI output, identify the root causes, make targeted fixes, and verify the resulting checks.
- Keep the React UI changes in the designated frontend repository and make the backend Docker build consume a pinned frontend revision.

## How AI output was reviewed

- Checked salary write behavior against model and request specs, including validation failures and salary history records.
- Reviewed employee filtering, pagination limits, and currency-grouped insights in the implementation and specs.
- Ran RuboCop and Brakeman locally; the GitHub Actions checks were used to verify CI fixes.
- Reviewed generated setup and deployment instructions against the repository configuration. Deployment and a recorded demo are still outstanding.
