HASH ?= $(shell git rev-parse --short HEAD)
VERSION ?= $(shell git describe --tags 2>/dev/null)
PROJECT_NAME ?= $(shell basename "$(PWD)")
BUILDOUT ?= $(PROJECT_NAME)

all:: help

help ::
	@grep -E '^[a-zA-Z_-]+\s*:.*?## .*$$' ${MAKEFILE_LIST} | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'

run :: ## Run service
	@echo "  > Starting service"
	@go run main.go

check :: ## Check everything is ok to move forward within next pipeline step
	@echo "  > Checking conventions and code standards"
	@golangci-lint run --timeout=3m0s

build :: ## Build a binary in current path
	@echo "  > Building binary"
	@CGO_ENABLED=0 GOOS=linux go build \
		-ldflags "-extldflags -static -X main.hash=${HASH} -X main.version=${VERSION}" \
		-o ${BUILDOUT}
