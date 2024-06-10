.DEFAULT_GOAL := help

PKG  := $(shell go list ./... | grep -v vendor)
TEST := $(shell go list ./... | grep -v vendor)

JIRA_URL      ?= http://127.0.0.1:2990/jira
JIRA_USER     ?= admin
JIRA_PASSWORD ?= admin

.PHONY: help
help: ## List targets & descriptions
	@cat Makefile* | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: deps
deps: ## Download dependencies
	go mod download

.PHONY: build
build: ## Build
	go build .

.PHONY: release
release: ## Build the go binaries for various platform
	./scripts/release.sh

.PHONY: test
test: ## Run tests
	TF_ACC=1 JIRA_URL="$(JIRA_URL)" JIRA_PASSWORD="$(JIRA_PASSWORD)" JIRA_USER="$(JIRA_USER)" go test -v $(TEST)
