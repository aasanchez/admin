current-dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
DATE := $(shell date +%Y)
SHELL = /bin/bash

ifneq (,$(findstring xterm,${TERM}))
	BLACK        := $(shell tput -Txterm setaf 0)
	RED          := $(shell tput -Txterm setaf 1)
	GREEN        := $(shell tput -Txterm setaf 2)
	YELLOW       := $(shell tput -Txterm setaf 3)
	LIGHTPURPLE  := $(shell tput -Txterm setaf 4)
	PURPLE       := $(shell tput -Txterm setaf 5)
	BLUE         := $(shell tput -Txterm setaf 6)
	WHITE        := $(shell tput -Txterm setaf 7)
	RESET        := $(shell tput -Txterm sgr0)
else
	BLACK        := ""
	RED          := ""
	GREEN        := ""
	YELLOW       := ""
	LIGHTPURPLE  := ""
	PURPLE       := ""
	BLUE         := ""
	WHITE        := ""
	RESET        := ""
endif

default: help

##@ Helpers
help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n  make \033[1;34m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[1;34m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Building
bootstrap: ## is used solely for fulfilling dependencies of the project
	@./scripts/prerequisites.sh

up: bootstrap ## is used to start the application
	@docker compose up -d

down: ## is used to start the application
	@docker compose stop

clean:
	@docker compose down --rmi all --volumes --remove-orphans
	@sudo rm -rf docker/volumes/*
	@docker compose down && docker compose rm -f
	@docker ps -aq --filter "label=com.docker.compose.project=$(basename $(pwd))" | xargs docker rm -f
	@docker compose down --volumes
	@rm -rf ./docker/data/mongo
