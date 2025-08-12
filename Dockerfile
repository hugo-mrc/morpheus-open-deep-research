FROM python:3.11-slim

# Ensure Python output is not buffered and no .pyc files are written
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Install minimal build tooling for any wheels that may need compilation
RUN apt-get update \
  && apt-get install -y --no-install-recommends build-essential curl \
  && rm -rf /var/lib/apt/lists/*

# Copy project files
COPY pyproject.toml README.md LICENSE ./
COPY src ./src
COPY tests ./tests
COPY langgraph.json ./langgraph.json

# Install the project (includes langgraph-cli[inmem])
RUN pip install --no-cache-dir --upgrade pip \
  && pip install --no-cache-dir .

# Railway provides $PORT; bind to 0.0.0.0
EXPOSE 8080

# Do not set defaults for env vars; Railway sets PORT
CMD ["sh", "-c", "langgraph dev --allow-blocking --host 0.0.0.0 --port $PORT"]

