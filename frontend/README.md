# React UI

The React and JavaScript client is built with Vite and lives in this repository's `frontend/` directory.

## Local development

Requires Node.js 20+ and the Rails API running at `http://localhost:3000`.

```sh
npm ci
npm run dev
```

Vite serves the app at `http://localhost:5173` and proxies `/api` requests to Rails. The root README documents the complete API-plus-UI setup.

## Checks

```sh
npm test
npm run build
```
