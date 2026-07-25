FROM python:3.11-slim

WORKDIR /app

# Set PYTHONPATH so `app.backend.*` imports resolve from the repo root
ENV PYTHONPATH=/app

RUN pip install poetry==1.7.1

# Copy only dependency files first for better layer caching
COPY pyproject.toml poetry.lock* /app/

RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi --without dev

# Copy the rest of the repo (backend imports from src/, v2/, app/)
COPY . /app/

EXPOSE 8000

# Railway injects $PORT at runtime; default to 8000 for local `docker run`
CMD ["sh", "-c", "uvicorn app.backend.main:app --host 0.0.0.0 --port ${PORT:-8000}"]
