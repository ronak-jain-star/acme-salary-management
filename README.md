# ACME Salary Management Web UI

React and TypeScript frontend for the ACME Salary Management API. The UI is developed and versioned independently from the Rails API.

## Local development

Requirements: Node.js 20+ and the Rails API running at `http://localhost:3000`.

```sh
npm ci
npm run dev
```

Vite serves the app at `http://localhost:5173` and proxies `/api` requests to Rails. The API and UI remain same-origin in the combined production container.

## Checks

```sh
npm test
npm run build
```
