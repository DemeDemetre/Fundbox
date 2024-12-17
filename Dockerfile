# Use Python base image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy application files
COPY app.py /app/
COPY config.json /app/

# Install Flask and pytz
RUN pip install Flask pytz

# Expose port 5000
EXPOSE 5000

# Run the Flask application
CMD ["python", "app.py"]
