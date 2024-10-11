FROM python:3.10.2-slim-bullseye

# Environment variables to configure Python behavior
ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Set the working directory
WORKDIR /code

# Copy the requirements.txt first to cache dependencies
COPY ./requirements.txt .

# Install curl, netcat, nodejs, and Python dependencies
RUN apt-get update && \
    apt-get install -y curl netcat && \
    curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    pip install --upgrade pip && \
    pip install -r requirements.txt

# Verify Node.js and npm versions
RUN echo "NODE Version:" && node --version && \
    echo "NPM Version:" && npm --version

# Copy the entrypoint script and make it executable
COPY ./entrypoint.sh .
RUN chmod +x /code/entrypoint.sh

# Copy the rest of the application code
COPY . .

# Set the entrypoint
ENTRYPOINT ["/code/entrypoint.sh"]
