# S3 File Manager API

A simple REST API for managing files in an S3-compatible bucket (e.g., MinIO).

## Prerequisites

- Go 1.25.5 or later
- MinIO server or AWS S3 (for production)

## Setup

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd devops-bedrock/application
   ```

2. Install dependencies:
   ```bash
   go mod tidy
   ```

3. Configure environment variables. You can set them directly or use a `.env` file (optional):
   ```
   S3_ENDPOINT=http://localhost:9000
   S3_REGION=us-east-1
   S3_ACCESS_KEY=your-access-key
   S3_SECRET_KEY=your-secret-key
   BUCKET=your-bucket-name
   LOG_BUCKET=log-bucket
   PORT=3000
   ```

4. Start MinIO (if using local):
   ```bash
   docker run -p 9000:9000 minio/minio server /data
   ```

5. Build and run the application:
   ```bash
   go build ./cmd/app
   ./app
   ```

## API Endpoints

- `GET /health` - Health check
- `GET /files` - List files in bucket
- `POST /upload` - Upload file (multipart/form-data)
- `DELETE /files/{key}` - Delete file by key
- `GET /swagger/*` - API documentation
- `GET /metrics` - Prometheus metrics

## Logging

Application logs, including HTTP requests, are written to both stdout for real-time visibility and a local log file. On application shutdown, the log file is automatically uploaded to the configured S3 log bucket for persistence.

## Development

Run with hot reload (if using air or similar):
```bash
go run ./cmd/app
```
