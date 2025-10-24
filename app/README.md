# Simple Go API

A lightweight HTTP server written in Go that provides basic endpoints for health checking and time display.

## Features

- Health check endpoint for monitoring
- Time display with current server time
- Docker containerization
- No external dependencies (uses standard library only)

## API Endpoints

### GET /
Returns a greeting message with current server time.

**Response:**
```json
{
  "message": "Hello World. Now time is 14:30:25"
}
```

### GET /health
Health check endpoint for monitoring and load balancers.

**Response:**
```json
{
  "status": "ok",
  "version": "1.0.0",
  "timestamp": "2025-10-24T01:26:21Z"
}
```

## Quick Start

### Using Docker (Recommended)

```bash
# Build the image
docker build -t my-go-app .

# Run the container
docker run -p 8080:8080 my-go-app
```

### Local Development

```bash
# Navigate to source directory
cd src

# Run directly (requires Go 1.21+)
go run main.go
```

## Testing

```bash
# Test the main endpoint
curl http://localhost:8080/

# Test health check
curl http://localhost:8080/health
```

## Project Structure

```
my-go-app/
└── app/
    ├── src/
    │   ├── main.go      # Main application code
    │   └── go.mod       # Go module definition
    ├── Dockerfile       # Docker configuration
    └── README.md        # This file
```

## Requirements

- Go 1.21+ (for local development)
- Docker (for containerized deployment)

## Port Configuration

The application runs on port 8080 by default. You can change this by modifying the `port` variable in `main.go`.

## License

MIT
