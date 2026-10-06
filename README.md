# ACME Pay

> **Live app:** Pending deployment · **Demo video:** Pending recording

[![CI](https://github.com/ronak-jain-star/acme-salary-management/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/ronak-jain-star/acme-salary-management/actions/workflows/ci.yml)

An end-to-end salary management workspace for an HR manager supporting 10,000 employees. This repository contains the Rails API, React UI, database schema and seed data, tests, and design artifacts.

## Product scope

Search and filter the employee directory, inspect each employee's current salary and currency, record a salary update with a reason, review its history, and view salary distributions grouped by country, department, and currency. Synthetic seed data is used throughout. Amounts are integer minor units; the app never combines salary values across currencies.

See [requirements](requirements.md), [architecture and trade-offs](docs/ai-and-tradeoffs.md), [design notes](docs/design.md), and [AI prompts and review notes](docs/ai-prompts.md).

## Stack

- **API:** Ruby 3.4, Rails 8.1, PostgreSQL
- **UI:** React 18, TypeScript, Vite
- **Tests and analysis:** RSpec, Node's test runner, RuboCop, Brakeman
- **Deployment:** one Docker web service serves the built React files and Rails API

## Run locally

Requires Ruby 3.4+, Node.js 20+, and PostgreSQL.

```sh
git clone https://github.com/ronak-jain-star/acme-salary-management.git
cd acme-salary-management
bundle install
npm ci --prefix frontend
cp config/application.yml.example config/application.yml
cp config/database.yml.sample config/database.yml
bin/rails db:prepare
bin/rails db:seed
```

Start Rails in one terminal and Vite in another:

```sh
bin/rails server
npm run dev --prefix frontend
```

Vite serves the UI at `http://localhost:5173` and proxies `/api` to Rails at `http://localhost:3000`. The deterministic seed creates 10,000 synthetic employees only when the database is empty.

## Check locally

```sh
RAILS_ENV=test bin/rails db:schema:load
bundle exec rspec
bundle exec rubocop
gem install brakeman --no-document
brakeman --no-pager
npm test --prefix frontend
npm run build --prefix frontend
```

The suite currently has 13 RSpec examples and 2 frontend unit tests. GitHub Actions runs backend specs, frontend tests and build, RuboCop, and Brakeman for pull requests and on `main`. The test schema is loaded without demo seeds so factory data remains isolated.

## Deployment and demo

`render.yaml` describes the Rails/PostgreSQL deployment. A Render service has not yet been provisioned, so there is no live URL or recorded walkthrough to link. Those are explicit remaining submission items; do not treat the blueprint as a deployed app. When available, add both links to the status line at the top of this README. The walkthrough should cover employee search/filter, salary and currency details, an auditable salary edit, and currency-separated insights.

## Security boundary

This assessment uses synthetic data and has no authentication or role-based access. The salary history currently records the fixed actor label `HR Manager`; it does not establish a verified identity. Do not load real salary data before adding authentication, authorization, secret/key management, backups, retention policy, and a privacy/security review. See the deliberate exclusions in [requirements](requirements.md).

## AI use

AI was used to assist with scaffolding, test ideas, and review. The prompts artifact summarizes representative instructions and records the checks used to assess the output; it is explicitly not a verbatim conversation transcript. The implementation and its trade-offs are documented in the linked artifacts above.
