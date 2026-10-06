# AI prompts and review notes

These examples summarize the prompts used during the assessment; they are not a verbatim conversation export.

## Representative prompts

- "Before building, write a one-page requirements doc covering goal, scope, deliberate exclusions, and why they are excluded."
- "Build end-to-end employee salary management for 10,000 employees with a relational backend, React UI, deterministic seed data, and meaningful tests."
- "Keep salary changes auditable; validate values and reasons; do not combine different currencies without an FX policy."
- "Review the failed CI output, find root causes, make targeted changes, and verify the checks."
- "Create a new combined submission repository; include the React and Rails source, preserve the existing repositories, and address the review points."

## How AI output was reviewed

- Reviewed salary writes, the fixed audit label, append-only history, validation failures, and currency grouping against specs.
- Reviewed directory page limits, eager loading, and SQL aggregation in the implementation.
- Used RuboCop and Brakeman locally and GitHub Actions for CI verification. The combined repository adds frontend tests/build to the same workflow.
- Checked setup and Docker instructions against the repository configuration. A Render blueprint is present, but deployment and a recorded demo remain outstanding.

These are representative summaries of the work instructions, not a verbatim conversation export.
