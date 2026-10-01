# ACME Pay

An HR salary workspace for 10,000 synthetic employees. See [requirements](requirements.md) and [design notes](docs/design.md).

## Stack

Rails 7.1 API, PostgreSQL, React + Vite UI, and RSpec request/model specs. All seed records are synthetic. Amounts are integer minor units and are only summarized within the same currency.

## Local setup

Requires Ruby 3.1+, Node 20+, and PostgreSQL. Create `acme_salary_development` and `acme_salary_test` databases (or set `DATABASE_URL`), install gems and JS dependencies, then run the API and UI in separate terminals:

```sh
bundle install
bin/rails db:prepare
bin/rails db:seed
npm --prefix frontend install
npm --prefix frontend run dev
```

The seed is deterministic and safe to rerun. It resets only this app's employee and salary-change tables. API: `/api/v1/employees`, `/api/v1/insights`, `/api/v1/employees/:id/salary_changes`.

## Tests

```sh
bundle exec rspec
npm --prefix frontend test -- --run
```

## AI use

AI assistance was used for initial requirements/design decomposition, scaffolding, and implementation review. All domain rules and generated changes are intended to be reviewed by the author. See [decision log](docs/ai-and-tradeoffs.md).

## Demo

Record a short walkthrough after deployment: search/filter, inspect salary and currency, make a reasoned salary edit, then compare insights grouped by currency. A hosted URL and recording are added here once deployment is configured.
