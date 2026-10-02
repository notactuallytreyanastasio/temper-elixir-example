# Everything runs in the toolchain container; the host needs only Docker.

# the compose plugin (Docker Desktop), or the standalone docker-compose
COMPOSE := $(shell docker compose version >/dev/null 2>&1 && echo "docker compose" || echo docker-compose)
BACKEND ?= elixir

.PHONY: up down run test shell gen

up:            ## the app at http://localhost:4000, rebuilt as Temper sources change
	$(COMPOSE) up --build

down:
	$(COMPOSE) down

run:           ## run scratch/src/main.temper.md (BACKEND=elixir by default)
	$(COMPOSE) run --rm --no-deps temper sh -c 'cd scratch && temper run -b $(BACKEND) --library scratch -w .'

test:          ## textkit's Temper tests on the BEAM, then the app's tests
	$(COMPOSE) run --rm --no-deps temper sh -c 'cd temper && temper test -b elixir -w .'
	$(COMPOSE) run --rm --no-deps temper bin/temper-gen
	$(COMPOSE) run --rm --no-deps web sh -c 'mix deps.get >/dev/null && mix test'

gen:           ## regenerate temper/out once
	$(COMPOSE) run --rm --no-deps temper bin/temper-gen

shell:         ## a shell in the toolchain
	$(COMPOSE) run --rm --no-deps temper bash
