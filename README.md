# ACME Pay

An HR salary workspace for 10,000 synthetic employees. See [requirements](requirements.md) and [design notes](docs/design.md).

## Stack

Rails 7.1 API, PostgreSQL, React + Vite UI, and RSpec request/model specs. All seed records are synthetic. Amounts are integer minor units and are only summarized within the same currency.

## Local setup

Requires Ruby 3.1+, Node 20+, and PostgreSQL. Create `acme_salary_development` and `acme_salary_test` databases (or set `DATABASE_URL`), install gems and JS dependencies, then run the API and UI in separate terminals:

```sh
bundle install
cp config/application.yml.example config/application.yml
bin/rails db:prepare
bin/rails db:seed
npm --prefix frontend ci
npm --prefix frontend run dev
```

The seed is deterministic and safe to rerun; it creates records only on an empty database and preserves existing salary data. API: `GET /api/v1/employees`, `GET /api/v1/insights`, `POST /api/v1/employees/:employee_id/salary_changes`, and `GET /api/v1/employees/:id/salary_history`.

## Tests

```sh
RAILS_ENV=test bin/rails db:schema:load
bundle exec rspec
npm --prefix frontend test
npm --prefix frontend run build
bundle exec rubocop
```

The test database is schema-loaded without demo seeds so factory records remain isolated. Figaro loads local settings from the ignored `config/application.yml`; deployment configuration is supplied through environment variables. API JSON is serialized with Blueprinter, salary writes go through `SalaryUpdater`, and currency support is configured through `SUPPORTED_CURRENCIES`.

## Deployment

`render.yaml` provisions a PostgreSQL database and a Docker web service that serves both the Rails API and built React UI. Connect the repository to Render, then deploy; Render supplies `SECRET_KEY_BASE` and the pre-deploy step migrates and seeds an empty database. The hosted URL and a short demo recording can be added here after deployment.

## AI use

AI assistance was used for initial requirements/design decomposition, scaffolding, and implementation review. All domain rules and generated changes are intended to be reviewed by the author. See [decision log](docs/ai-and-tradeoffs.md).

## Demo

Record a short walkthrough after deployment: search/filter, inspect salary and currency, make a reasoned salary edit, then compare insights grouped by currency. A hosted URL and recording are added here once deployment is configured.
