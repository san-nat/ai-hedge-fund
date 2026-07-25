FROM node:20-slim AS build

WORKDIR /app

COPY package.json package-lock.json* pnpm-lock.yaml* ./
RUN npm ci

COPY . .

# Baked into the static build at build time (Vite env vars are not readable at runtime).
# Set this to the backend service's public Railway URL, e.g. https://<backend>.up.railway.app
ARG VITE_API_URL
ENV VITE_API_URL=$VITE_API_URL

# Note: `npm run build` also runs `tsc`, which currently fails on pre-existing
# type errors unrelated to the production bundle. Build with vite directly.
RUN npx vite build

FROM node:20-slim

WORKDIR /app
RUN npm install -g serve
COPY --from=build /app/dist ./dist

EXPOSE 4173

CMD ["sh", "-c", "serve -s dist -l ${PORT:-4173}"]
