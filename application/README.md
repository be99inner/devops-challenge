# S3 File Manager API

A simple REST API for managing files in an S3-compatible bucket (e.g., MinIO).

## Prerequisites

- Go 1.21 or later
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

3. Configure environment variables. Copy `.env` and update values:
   ```
   S3_ENDPOINT=http://localhost:9000
   S3_REGION=us-east-1
   S3_ACCESS_KEY=your-access-key
   S3_SECRET_KEY=your-secret-key
   BUCKET=your-bucket-name
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

## Development

Run with hot reload (if using air or similar):
```bash
go run ./cmd/app
```
