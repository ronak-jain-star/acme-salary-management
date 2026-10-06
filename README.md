# ACME Pay

An HR salary workspace for 10,000 synthetic employees. See [requirements](requirements.md) and [design notes](docs/design.md).

> **Demo status:** Not deployed yet. Live URL and video walkthrough are pending.

## Stack

Rails 8.1 API, PostgreSQL, and RSpec request/model specs. The React + Vite source lives in the separate [acme-salary-management-webui repository](https://github.com/ronak-jain-star/acme-salary-management-webui); the Docker build checks out a pinned frontend revision, builds it, and packages its static assets into this Rails app. Render serves the UI and API from one web service. All seed records are synthetic. Amounts are integer minor units and are only summarized within the same currency.

## Local setup

Requires Ruby 3.4+, Node 20+, and PostgreSQL. Clone both repositories as sibling directories. Create `acme_salary_development` and `acme_salary_test` databases (or set `DATABASE_URL`) and install gems:

```sh
git clone https://github.com/ronak-jain-star/acme-salary-management-webui.git ../acme-salary-management-webui
```

```sh
bundle install
cp config/application.yml.example config/application.yml
cp config/database.yml.sample config/database.yml
bin/rails db:prepare
bin/rails db:seed
```

Run the API with `bin/rails server`, then run the UI from the `acme-salary-management-webui` directory in a second terminal with `npm ci && npm run dev`.

The seed is deterministic and safe to rerun; it creates records only on an empty database and preserves existing salary data. API: `GET /api/v1/employees`, `GET /api/v1/insights`, `POST /api/v1/employees/:employee_id/salary_changes`, and `GET /api/v1/employees/:id/salary_history`.

## Tests

```sh
RAILS_ENV=test bin/rails db:schema:load
bundle exec rspec
bundle exec rubocop
```

Run the frontend checks from its repository with `npm test` and `npm run build`.

The test database is schema-loaded without demo seeds so factory records remain isolated. Figaro loads local settings from the ignored `config/application.yml`; deployment configuration is supplied through environment variables. API JSON is serialized with Blueprinter, salary writes go through `SalaryUpdater`, and currency support is configured through `SUPPORTED_CURRENCIES`.

## Deployment

`render.yaml` provisions a PostgreSQL database and a Docker web service. Connect this repository to Render; Render supplies `SECRET_KEY_BASE` and the pre-deploy step migrates and seeds an empty database. Update `FRONTEND_REF` in `Dockerfile` when releasing a frontend change. The hosted app and video walkthrough are not available yet; add their links at the top of this README after deployment and recording.

## AI use

AI assistance was used for initial requirements/design decomposition, scaffolding, and implementation review. All domain rules and generated changes are intended to be reviewed by the author. See the [AI workflow and trade-offs](docs/ai-and-tradeoffs.md) and [representative prompts](docs/ai-prompts.md).
