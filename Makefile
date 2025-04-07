.PHONY: build bumpversion coverage test help
.DEFAULT_GOAL := help

PYTHON_VERSION=py37

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

args = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`

help:  ## help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?##"; \
	printf "\n\
	Targets:\n"}; \
	{printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'

docker-clean-unused: ## docker system prune --all --force --volumes
	docker system prune --all --force --volumes

docker-clean-all:  ## docker container stop $(docker container ls -a -q) && docker system prune -a -f --volumes
	docker container stop $$(docker container ls -a -q) && docker system prune -a -f --volumes

build: ## Build the 'ia_sc_eda' Docker image.
	docker build --tag ia_sc_eda .

jupyter: ## Start jupyter notebook server.
	@docker run --publish 8888:8888 --volume $$(PWD)/:/workspace/ \
	           --workdir=/workspace \
	           --env ENVIRONMENT=$(ENVIRONMENT)\
	           --env SNOWFLAKE_PASSWORD=$(SNOWFLAKE_PASSWORD) \
	           --env SNOWFLAKE_USER=$(SNOWFLAKE_USER) \
	           --env SNOWFLAKE_ACCOUNT=$(SNOWFLAKE_ACCOUNT) \
	           --env SNOWFLAKE_WAREHOUSE=$SNOWFLAKE_WAREHOUSE \
               --env SNOWFLAKE_DATABASE=$SNOWFLAKE_DATABASE \
               --env SNOWFLAKE_SCHEMA=$SNOWFLAKE_SCHEMA \
               --env SNOWFLAKE_ROLE=$SNOWFLAKE_ROLE \
	           --detach ia_sc_eda jupyter
	       echo "Go to http://localhost:8888/."



run: ## Run src/main.py inside the 'ia_sc_eda' container.
	docker run ia_sc_eda python /app/src/main.py


bash: ## Open up a bash in terminal ia_sc_eda.
	docker run --interactive --tty ia_sc_eda /bin/sh

stop: ## Stop the 'ia_sc_eda' container.
	docker container stop $$(docker ps -q --filter ancestor=ia_sc_eda)
