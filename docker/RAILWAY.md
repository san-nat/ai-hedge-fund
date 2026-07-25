# Deploying to Railway

This project deploys as two separate Railway services from this one repo:

1. **Backend** (`app/backend`, FastAPI) — built from the repo root using
   `docker/backend.Dockerfile`, configured by the root `railway.json`.
2. **Frontend** (`app/frontend`, Vite/React) — built from `app/frontend`
   using its own `Dockerfile`, configured by `app/frontend/railway.json`.

## Setup

1. Create a new Railway project and link it to this repo/branch.
2. **Backend service**
   - Root directory: repo root (leave default).
   - Railway will pick up `railway.json` automatically (build via
     `docker/backend.Dockerfile`, healthcheck on `/`).
   - Environment variables: copy the keys you need from `.env.example`
     (e.g. `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, `FINANCIAL_DATASETS_API_KEY`),
     plus `CORS_ORIGINS` set to the frontend service's public URL once you
     have it (e.g. `https://<frontend>.up.railway.app`).
   - Note: the backend stores its SQLite database on the container's local
     disk (`app/backend/hedge_fund.db`), which is wiped on every redeploy.
     For anything beyond a demo, either attach a Railway volume mounted at
     `/app/app/backend`, or migrate to Postgres.
3. **Frontend service**
   - Root directory: `app/frontend`.
   - Railway will pick up `app/frontend/railway.json` automatically.
   - Build variable: `VITE_API_URL` set to the backend service's public URL
     (e.g. `https://<backend>.up.railway.app`). This is baked in at build
     time, so redeploy the frontend if the backend URL changes.
4. Once both services have public domains, set `CORS_ORIGINS` on the
   backend to the frontend's URL (and redeploy the backend) so the browser
   is allowed to call the API.

## Local Docker Compose

The existing `docker/docker-compose.yml` is unrelated to this Railway setup —
it runs the CLI hedge fund/backtester (`src/main.py`, `src/backtester.py`),
not the web app.
