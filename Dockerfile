# Use an official lightweight Python image
FROM python:3.10-slim

# Set working directory inside container
WORKDIR /app

# Copy dependencies file
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy all source code into container
COPY . .

# Expose port for FastAPI
EXPOSE 8000

# Run the FastAPI app from nested path
CMD ["uvicorn", "Summative.API.app:app", "--host", "0.0.0.0", "--port", "8000"]
