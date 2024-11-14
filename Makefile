BINARY_NAME := storage-check
DOCKER_IMAGE := hlatimer266/dp-kh-pv
VERSION := latest

# Default target to build and push
.PHONY: all
all: build docker-build docker-push

# Build the Go binary
build:
	@echo "Building Go binary..."
	GOOS=linux GOARCH=amd64 go build -v -o $(BINARY_NAME) ./cmd/storage-check/

# Build the Docker image
docker-build:
	@echo "Building Docker image..."
	docker build -t $(DOCKER_IMAGE):$(VERSION) .

# Push the Docker image to the repository
docker-push:
	@echo "Pushing Docker image..."
	docker push $(DOCKER_IMAGE):$(VERSION)

apply:
	kubectl apply -f deploy/storage-check.yaml 

delete:
	kubectl delete -f deploy/storage-check.yaml

# Clean up the binary
clean:
	@echo "Cleaning up..."
	rm -f $(BINARY_NAME)

