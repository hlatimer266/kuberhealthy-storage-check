# Stage 1: Build the Go binary
FROM golang:1.22-bullseye AS builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go.mod and go.sum files
COPY go.mod go.sum ./

# Download Go modules. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source code into the container
COPY cmd/storage-check .

# Build the Go binary
RUN GOARCH=amd64 go build -v -o storage-check

# Stage 2: Create a minimal image to run the Go binary
FROM ubuntu:20.04 

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy the Go binary from the builder stage
COPY --from=builder /app/storage-check .

# Command to run the Go binary
ENTRYPOINT ["/app/storage-check"]
