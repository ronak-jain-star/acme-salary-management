# AI workflow and trade-offs

1. Converted the supplied prompt into a one-page requirements brief before implementation.
2. Chose the smallest architecture that demonstrates a full vertical slice: Rails JSON API, relational persistence, React UI, and deterministic seed data.
3. Used AI to draft scaffolding and test ideas, then reviewed for currency-safe aggregation, bounded queries, input validation, and audit atomicity.
4. Iteration commits are intentionally separated into product framing, backend/domain, and UI/docs so the history communicates the work sequence.

**Open questions deferred explicitly:** whether salary means base or total compensation; pay frequency; FX conversion rules; identity provider and access roles; approval/retention policy; import/export format. The v1 assumptions are documented in requirements.md and should be confirmed with ACME before production.
