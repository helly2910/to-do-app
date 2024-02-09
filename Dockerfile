FROM python:3.10 AS build

# Set working directory
WORKDIR /app

# Create a virtual environment
RUN python3 -m venv venv

# Activate the virtual environment and install dependencies
ENV PATH="/app/venv/bin:$PATH"
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy project files
COPY todo /app

FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Copy virtual environment from the previous stage
COPY --from=build /app/venv /app/venv

# Copy project files from the previous stage
COPY --from=build /app /app

# Expose port
EXPOSE 8000

# Set environment variables
ENV DJANGO_SETTINGS_MODULE=todo.settings

# Run Django server
CMD ["venv/bin/python", "manage.py", "runserver", "0.0.0.0:8000"]

