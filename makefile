# ==============================================================================
# iObservatory - Makefile
# ==============================================================================
#
# Generic deployment template for an iObservatory platform.
#
# The Makefile provides commands for:
#
#   • First-time installation
#   • Environment initialisation
#   • Credential generation
#   • MediaWiki extension management
#   • Composer dependency management
#   • Docker lifecycle management
#   • MediaWiki maintenance
#   • Database backups
#
# Run:
#
#   make help
#
# to display all available commands.
#
# ==============================================================================


# ==============================================================================
# CONFIGURATION
# ==============================================================================

SHELL := /bin/bash

DC := docker compose

DC_INSTALL := docker compose -f docker-compose.install.yml

MEDIAWIKI_SERVICE := mediawiki

DEFAULT_EXT_VERSION := REL1_42

# ==============================================================================
# Environment
# ==============================================================================

ENV_FILES := \
	.env \
	services/etl/hop-server/.env \
	services/etl/hop-web/.env \
	services/mariadb/.env \
	services/mediawiki/.env \
	services/minio/.env \
	services/pma/.env \
	services/postgres/.env \
	services/strapi/.env

# Ignore missing files during the first Make parsing.
# They will be created by `make init-env`.
-include $(ENV_FILES)

# ==============================================================================
# TERMINAL COLORS
# ==============================================================================

RESET   := \033[0m
BOLD    := \033[1m

RED     := \033[31m
GREEN   := \033[32m
YELLOW  := \033[33m
BLUE    := \033[34m
MAGENTA := \033[35m
CYAN    := \033[36m
WHITE   := \033[37m


# ==============================================================================
# UI HELPERS
# ==============================================================================

define header
	@printf "\n$(BOLD)$(CYAN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)\n"
	@printf "$(BOLD)$(CYAN)  %s$(RESET)\n" "$(1)"
	@printf "$(BOLD)$(CYAN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)\n"
endef

define success
	@printf "  $(GREEN)✔$(RESET) %s\n" "$(1)"
endef

define warning
	@printf "  $(YELLOW)⚠$(RESET) %s\n" "$(1)"
endef

define info
	@printf "  $(BLUE)➜$(RESET) %s\n" "$(1)"
endef

define failure
	@printf "  $(RED)✖$(RESET) %s\n" "$(1)"
endef


# ==============================================================================
# DEFAULT TARGET
# ==============================================================================

.DEFAULT_GOAL := help

# ==============================================================================
# PLATFORM
# ==============================================================================

UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Darwin)
    SED_INPLACE := sed -i ''
else
    SED_INPLACE := sed -i
endif

# ==============================================================================
# HELP
# ==============================================================================

.PHONY: help

help: ## Show available commands
	@printf "\n"
	@printf "$(BOLD)$(CYAN)"
	@printf "██\  ██████\  ██\                                                         ██\                                    \n"
	@printf "\__|██  __██\ ██ |                                                        ██ |                                   \n"
	@printf "██\ ██ /  ██ |███████\   ███████\  ██████\   ██████\ ██\    ██\ ██████\ ██████\    ██████\   ██████\  ██\   ██\  \n"
	@printf "██ |██ |  ██ |██  __██\ ██  _____|██  __██\ ██  __██\\██\    ██  |\____██\\_██  _|  ██  __██\ ██  __██\ ██ |  ██ | \n"
	@printf "██ |██ |  ██ |██ |  ██ |\██████\  ████████ |██ |  \__|\██\██  / ███████ | ██ |    ██ /  ██ |██ |  \__|██ |  ██ | \n"
	@printf "██ |██ |  ██ |██ |  ██ | \____██\ ██   ____|██ |       \███  / ██  __██ | ██ |██\ ██ |  ██ |██ |      ██ |  ██ | \n"
	@printf "██ | ██████  |███████  |███████  |\███████\ ██ |        \█  /  \███████ | \████  |\██████  |██ |      \███████ | \n"
	@printf "\__| \______/ \_______/ \_______/  \_______|\__|         \_/    \_______|  \____/  \______/ \__|       \_______| \n"
	@printf "                                                                                                      ██\   ██ | \n"
	@printf "                                                                                                       \██████ | \n"
	@printf "                                                                                                        \______/ \n"
	@printf "$(RESET)\n"

	@printf "$(BOLD)$(WHITE)Generic Observatory Platform$(RESET)\n\n"

	@printf "$(BOLD)$(MAGENTA)First-time installation$(RESET)\n"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| grep -E 'install|init-env|credentials' \
		| awk 'BEGIN {FS = ":.*?## "}; \
		       {printf "  $(CYAN)%-24s$(RESET) %s\n", $$1, $$2}'

	@printf "\n$(BOLD)$(MAGENTA)Docker$(RESET)\n"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| grep -E 'build|rebuild|up|down|restart|logs|status|pull' \
		| awk 'BEGIN {FS = ":.*?## "}; \
		       {printf "  $(CYAN)%-24s$(RESET) %s\n", $$1, $$2}'

	@printf "\n$(BOLD)$(MAGENTA)MediaWiki$(RESET)\n"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| grep -E 'mediawiki|extensions|composer' \
		| awk 'BEGIN {FS = ":.*?## "}; \
		       {printf "  $(CYAN)%-24s$(RESET) %s\n", $$1, $$2}'

	@printf "\n$(BOLD)$(MAGENTA)Maintenance$(RESET)\n"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| grep -E 'update|backup|connection|shell|clean' \
		| awk 'BEGIN {FS = ":.*?## "}; \
		       {printf "  $(CYAN)%-24s$(RESET) %s\n", $$1, $$2}'

	@printf "\n"


# ==============================================================================
# FIRST-TIME INSTALLATION
# ==============================================================================

.PHONY: install

install: ## 🚀 Install the platform for the first time
	$(call header,🚀  FIRST-TIME INSTALLATION)

	$(call info,Initialising environment files...)
	@$(MAKE) --no-print-directory init-env

	$(call info,Generating secure credentials...)
	@$(MAKE) --no-print-directory credentials

	$(call info,Installing MediaWiki extensions...)
	@$(MAKE) --no-print-directory extensions

	$(call info,Building containers...)
	@$(MAKE) --no-print-directory DC="$(DC_INSTALL)" build

	$(call info,Starting services...)
	@$(MAKE) --no-print-directory DC="$(DC_INSTALL)" up

	$(call info,Waiting for services...)
	@$(MAKE) --no-print-directory wait

	$(call info,Installing MediaWiki...)
	@$(MAKE) --no-print-directory mediawiki-install

	$(call info,Restoring normal MediaWiki configuration...)
	@$(MAKE) --no-print-directory up

	$(call info,Updating MediaWiki...)
	@$(MAKE) --no-print-directory mediawiki-update

	@printf "\n"
	@printf "$(BOLD)$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)\n"
	@printf "$(BOLD)$(GREEN)  🎉 Installation completed successfully!$(RESET)\n"
	@printf "$(BOLD)$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)\n\n"


# ==============================================================================
# ENVIRONMENT
# ==============================================================================

.PHONY: init-env

init-env: ## ⚙️ Create missing .env files from .env.example
	@printf "\n$(CYAN)⚙️  Initialising environment...$(RESET)\n"
	@find . -type f -name '.env.example' -print0 | \
	while IFS= read -r -d '' example; do \
		target="$${example%.example}"; \
		if [ ! -f "$$target" ]; then \
			cp "$$example" "$$target"; \
			printf "  $(GREEN)✔ Created$(RESET) %s\n" "$$target"; \
		else \
			printf "  $(YELLOW)↪ Exists$(RESET)  %s\n" "$$target"; \
		fi; \
	done

# ==============================================================================
# CREDENTIALS
# ==============================================================================

.PHONY: credentials

credentials: ## 🔐 Generate missing secure credentials
	@printf "  $(BLUE)🔐 Checking secure credentials...$(RESET)\n"
	@NEW_ADMIN_PWD=$$(openssl rand -base64 24 | tr -d '=+/' | cut -c1-20); \
	NEW_HOP_PWD=$$(openssl rand -base64 24 | tr -d '=+/' | cut -c1-20); \
	NEW_SECRET_KEY=$$(openssl rand -hex 32); \
	NEW_UPGRADE_KEY=$$(openssl rand -base64 12 | tr -d '=+/'); \
	NEW_MEDIAWIKI_DB_PWD=$$(openssl rand -base64 24 | tr -d '=+/' | cut -c1-20); \
	NEW_MARIADB_ROOT_PWD=$$(openssl rand -base64 24 | tr -d '=+/' | cut -c1-20); \
	\
	if grep -q '^MEDIAWIKI_ADMIN_PWD=$$' services/mediawiki/.env; then \
		$(SED_INPLACE) "s/^MEDIAWIKI_ADMIN_PWD=.*/MEDIAWIKI_ADMIN_PWD=$$NEW_ADMIN_PWD/" \
			services/mediawiki/.env; \
		printf "     $(GREEN)✔$(RESET) MediaWiki admin password generated\n"; \
	else \
		printf "     $(YELLOW)•$(RESET) MediaWiki admin password already exists\n"; \
	fi; \
	\
	if grep -q '^MEDIAWIKI_SECRET_KEY=$$' services/mediawiki/.env; then \
		$(SED_INPLACE) "s/^MEDIAWIKI_SECRET_KEY=.*/MEDIAWIKI_SECRET_KEY=$$NEW_SECRET_KEY/" \
			services/mediawiki/.env; \
		printf "     $(GREEN)✔$(RESET) MediaWiki secret key generated\n"; \
	else \
		printf "     $(YELLOW)•$(RESET) MediaWiki secret key already exists\n"; \
	fi; \
	\
	if grep -q '^MEDIAWIKI_UPGRADE_KEY=$$' services/mediawiki/.env; then \
		$(SED_INPLACE) "s/^MEDIAWIKI_UPGRADE_KEY=.*/MEDIAWIKI_UPGRADE_KEY=$$NEW_UPGRADE_KEY/" \
			services/mediawiki/.env; \
		printf "     $(GREEN)✔$(RESET) MediaWiki upgrade key generated\n"; \
	else \
		printf "     $(YELLOW)•$(RESET) MediaWiki upgrade key already exists\n"; \
	fi; \
	\
	if grep -q '^HOP_SERVER_PASS=$$' services/etl/hop-server/.env; then \
		$(SED_INPLACE) "s/^HOP_SERVER_PASS=.*/HOP_SERVER_PASS=$$NEW_HOP_PWD/" \
			services/etl/hop-server/.env; \
		printf "     $(GREEN)✔$(RESET) HOP admin password generated\n"; \
	else \
		printf "     $(YELLOW)•$(RESET) HOP admin password already exists\n"; \
	fi;\
  \
	if grep -q '^MEDIAWIKI_DB_PWD=$$' services/mediawiki/.env; then \
		$(SED_INPLACE) "s/^MEDIAWIKI_DB_PWD=.*/MEDIAWIKI_DB_PWD=$$NEW_MEDIAWIKI_DB_PWD/" \
			services/mediawiki/.env; \
		printf "     $(GREEN)✔$(RESET) MediaWiki database password generated\n"; \
	else \
		printf "     $(YELLOW)•$(RESET) MediaWiki database password already exists\n"; \
	fi; \
	\
	if grep -q '^MYSQL_PASSWORD=$$' services/mariadb/.env; then \
		$(SED_INPLACE) "s/^MYSQL_PASSWORD=.*/MYSQL_PASSWORD=$$NEW_MEDIAWIKI_DB_PWD/" \
			services/mariadb/.env; \
		printf "     $(GREEN)✔$(RESET) MariaDB user password generated\n"; \
	else \
		printf "     $(YELLOW)•$(RESET) MariaDB user password already exists\n"; \
	fi; \
	\
	if grep -q '^MYSQL_ROOT_PASSWORD=$$' services/mariadb/.env; then \
		$(SED_INPLACE) "s/^MYSQL_ROOT_PASSWORD=.*/MYSQL_ROOT_PASSWORD=$$NEW_MARIADB_ROOT_PWD/" \
			services/mariadb/.env; \
		printf "     $(GREEN)✔$(RESET) MariaDB root password generated\n"; \
	else \
		printf "     $(YELLOW)•$(RESET) MariaDB root password already exists\n"; \
	fi;



	$(call success,Credential check complete)


# ==============================================================================
# MEDIAWIKI EXTENSIONS
# ==============================================================================

.PHONY: extensions

extensions: ## 📦 Install configured MediaWiki extensions
	@printf "  $(BLUE)📦 Installing MediaWiki extensions...$(RESET)\n"

	@mkdir -p services/mediawiki/extensions

	@while read -r type ext url; do \
		[ -z "$$type" ] && continue; \
		case "$$type" in \#*) continue ;; esac; \
		\
		printf "     $(CYAN)%-30s$(RESET)" "$$ext"; \
		\
		if [ "$$type" = "gerrit" ]; then \
			if [ -d "services/mediawiki/extensions/$$ext" ]; then \
				printf "$(GREEN)already exists$(RESET)\n"; \
			elif git clone --depth 1 \
				--branch $(DEFAULT_EXT_VERSION) \
				"https://gerrit.wikimedia.org/r/mediawiki/extensions/$$ext" \
				"services/mediawiki/extensions/$$ext" \
				> /dev/null 2>&1; then \
				printf "$(GREEN)✔ installed$(RESET)\n"; \
			else \
				printf "$(RED)✖ failed$(RESET)\n"; \
				exit 1; \
			fi; \
		\
		elif [ "$$type" = "github" ]; then \
			if [ -d "services/mediawiki/extensions/$$ext" ]; then \
				printf "$(GREEN)already exists$(RESET)\n"; \
			elif git clone --depth 1 "$$url" \
				"services/mediawiki/extensions/$$ext" \
				> /dev/null 2>&1; then \
				printf "$(GREEN)✔ installed$(RESET)\n"; \
			else \
				printf "$(RED)✖ failed$(RESET)\n"; \
				exit 1; \
			fi; \
		else \
			printf "$(RED)✖ unknown source$(RESET)\n"; \
			exit 1; \
		fi; \
	done < services/mediawiki/extensions.config

	$(call success,All extensions installed successfully)


# ==============================================================================
# COMPOSER
# ==============================================================================

.PHONY: composer

composer: ## 📦 Update Composer dependencies
	@printf "  $(BLUE)📦 Updating Composer dependencies...$(RESET)\n"
	@$(DC) exec $(MEDIAWIKI_SERVICE) \
		composer update \
		--no-dev \
		--prefer-dist \
		--optimize-autoloader \
		--no-scripts
	$(call success,Composer dependencies updated)


.PHONY: composer-install

composer-install: ## 📦 Install Composer dependencies from lock file
	@printf "  $(BLUE)📦 Installing Composer dependencies...$(RESET)\n"
	@$(DC) exec $(MEDIAWIKI_SERVICE) \
		composer install \
		--no-dev \
		--prefer-dist \
		--optimize-autoloader \
		--no-scripts
	$(call success,Composer dependencies installed)


# ==============================================================================
# DOCKER
# ==============================================================================

.PHONY: build

build: ## 🔨 Build Docker images
	@printf "  $(BLUE)🔨 Building Docker images...$(RESET)\n"
	@$(DC) build
	$(call success,Docker build complete)


.PHONY: rebuild

rebuild: ## 🔨 Rebuild Docker images without cache
	@printf "  $(BLUE)🔨 Rebuilding Docker images without cache...$(RESET)\n"
	@$(DC) build --no-cache
	$(call success,Docker rebuild complete)


.PHONY: up

up: ## 🚀 Start all containers
	@printf "  $(BLUE)🚀 Starting containers...$(RESET)\n"
	@$(DC) up -d
	$(call success,All containers started)


.PHONY: down

down: ## 🛑 Stop all containers
	@printf "  $(YELLOW)🛑 Stopping containers...$(RESET)\n"
	@$(DC) down
	$(call success,All containers stopped)


.PHONY: restart

restart: ## 🔄 Restart all containers
	@printf "  $(CYAN)🔄 Restarting containers...$(RESET)\n"
	@$(DC) restart
	$(call success,All containers restarted)


.PHONY: logs

logs: ## 📜 Follow container logs
	@printf "$(BOLD)$(CYAN)📜 Container logs$(RESET)\n\n"
	@$(DC) logs -f --tail=100


.PHONY: status

status: ## 📊 Show container status
	@printf "$(BOLD)$(CYAN)📊 Container status$(RESET)\n\n"
	@$(DC) ps


.PHONY: pull

pull: ## ⬇️ Pull latest Docker images
	@printf "  $(BLUE)⬇️  Pulling Docker images...$(RESET)\n"
	@$(DC) pull
	$(call success,Docker images pulled)


# ==============================================================================
# MEDIAWIKI
# ==============================================================================


.PHONY: mediawiki-install
mediawiki-install: ## 🔄 Update an existing MediaWiki installation
	@printf "  $(BLUE)🔄 Updating MediaWiki...$(RESET)\n"

	@$(MAKE) --no-print-directory composer-install

	@$(DC) -f docker-compose.install.yml exec $(MEDIAWIKI_SERVICE) \
		php maintenance/run.php install \
			--confpath=/tmp \
			--dbtype=mysql \
			--dbserver=mariadb \
			--dbname="$(MEDIAWIKI_DB_NAME)" \
			--dbuser="$(MEDIAWIKI_DB_USER)" \
			--dbpass="$(MEDIAWIKI_DB_PWD)" \
			--scriptpath="" \
			--lang=en \
			--pass="$(MEDIAWIKI_ADMIN_PWD)" \
			"$(OBSERVATORY_NAME)" \
			"admin"
	$(call success,MediaWiki database initialised)


.PHONY: mediawiki-update

mediawiki-update: ## 🔄 Update MediaWiki database schema
	@printf "  $(BLUE)🔄 Updating MediaWiki database...$(RESET)\n"
	@$(DC) exec $(MEDIAWIKI_SERVICE) \
		php maintenance/run.php update --quick
	$(call success,MediaWiki database updated)


# ==============================================================================
# MAINTENANCE
# ==============================================================================

.PHONY: update

update: ## 🔄 Perform a complete platform maintenance update
	$(call header,🔄  PLATFORM UPDATE)

	$(call info,Pulling latest Docker images...)
	@$(MAKE) --no-print-directory pull

	$(call info,Synchronising extensions...)
	@$(MAKE) --no-print-directory extensions

	$(call info,Rebuilding containers...)
	@$(MAKE) --no-print-directory build

	$(call info,Starting services...)
	@$(MAKE) --no-print-directory up

	$(call info,Updating Composer dependencies...)
	@$(MAKE) --no-print-directory composer

	$(call info,Updating MediaWiki...)
	@$(MAKE) --no-print-directory mediawiki-update

	@printf "\n$(BOLD)$(GREEN)✔ Platform update complete$(RESET)\n\n"


# ==============================================================================
# DATABASE
# ==============================================================================

.PHONY: backup-mariadb

backup-mariadb: ## 💾 Create a MariaDB database backup
	@mkdir -p services/mariadb/backups
	@printf "  $(BLUE)💾 Creating MariaDB backup...$(RESET)\n"
	@$(DC) exec mariadb sh -c \
		'mysqldump -u"$$MARIADB_USER" -p"$$MARIADB_PASSWORD" "$$MARIADB_DATABASE"' \
		> services/mariadb/backups/backup_$$(date +%F_%H-%M-%S).sql
	$(call success,Database backup created)

.PHONY: backup-postgres

backup-postgres: ## 💾 Create a PostgreSQL database backup
	@mkdir -p services/postgres/backups
	@printf "  $(BLUE)💾 Creating PostgreSQL backup...$(RESET)\n"
	@$(DC) exec postgres sh -c \
		'pg_dump -U"$$POSTGRES_USER" -d"$$POSTGRES_DB"' \
		> services/postgres/backups/backup_$$(date +%F_%H-%M-%S).sql
	$(call success,Database backup created)


# ==============================================================================
# DEVELOPMENT / DEBUGGING
# ==============================================================================

.PHONY: shell

shell: ## 🐚 Open a shell inside the MediaWiki container
	@$(DC) exec $(MEDIAWIKI_SERVICE) bash


.PHONY: wait

wait: ## ⏳ Wait for services to start
	@printf "  $(CYAN)⏳ Waiting for services"
	@for i in 1 2 3 4 5 6 7 8 9 10; do \
		printf "."; \
		sleep 1; \
	done
	@printf " $(GREEN)✔$(RESET)\n"


.PHONY: clean

clean: ## 🧹 Stop containers and remove orphaned resources
	@printf "  $(YELLOW)🧹 Cleaning Docker resources...$(RESET)\n"
	@$(DC) down --remove-orphans
	$(call success,Cleanup complete)
