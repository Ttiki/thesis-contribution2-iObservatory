# iObservatory Boilerplate Stack

A Docker-based boilerplate for building **data-driven Observatory platforms**.

The stack combines open-source services for knowledge management, data integration, databases, and data storage. It is designed as a **generic starting point** that can be adapted to different Observatory use cases, domains, organisations, and data infrastructures.

The platform is modular: individual services can be configured, extended, replaced, or removed depending on the needs of the deployment.

> **⚠️ This repository is a template, not a plug-and-play application.**
>
> The first installation automatically creates environment files, generates credentials, installs configured extensions, builds the Docker stack, and initialises MediaWiki. Deployment-specific configuration may still be required.

---

# 🏗️ Architecture

See [ARCHITECTURE.md](docs/ARCHITECTURE.md) for a detailed overview of the stack architecture, services, and components.

---

# 🧩 Components

See [SERVICE.md](docs/SERVICE.md) for a description of the individual services and their roles in the stack.

---

# 🚀 Installation

See [SETUP.md](docs/SETUP.md) for a step-by-step installation guide.

---


# 🐳 Docker Lifecycle

The Makefile provides shortcuts around Docker Compose.

## Start

```bash
make up
```

Starts all services in the background.

## Stop

```bash
make down
```

Stops and removes the Compose containers.

## Restart

```bash
make restart
```

Restarts the running services.

## Build

```bash
make build
```

Builds the Docker images.

## Rebuild without cache

```bash
make rebuild
```

Useful after changes to Dockerfiles or dependencies.

## Pull images

```bash
make pull
```

Pulls the latest configured Docker images.

## Status

```bash
make status
```

Displays the current container status.

## Logs

```bash
make logs
```

Follows the latest container logs.

---

# 🔄 Maintenance

After the initial installation, **do not run `make install` again**.

The normal maintenance command is:

```bash
make update
```

The update pipeline is designed for an already-installed platform.

It can perform:

```text
Pull latest images
       ↓
Synchronise extensions
       ↓
Rebuild containers
       ↓
Start services
       ↓
Update Composer dependencies
       ↓
Update MediaWiki database
```

For more controlled maintenance, the individual commands can be executed separately.

For example:

```bash
make extensions
make composer
make mediawiki-update
```

---

# 🛠️ MediaWiki Maintenance

## Update the database

```bash
make mediawiki-update
```

Runs the MediaWiki database update process.

## Open a MediaWiki shell

```bash
make shell
```

This opens a shell inside the MediaWiki container.

This is useful for debugging and running MediaWiki commands manually.

---

# 💾 Database Backups

See [BACKUP.md](docs/BACKUP.md) for instructions on creating and managing MariaDB/PostgreSQL backups.

---

# 🌐 Accessing the Platform

The exact URLs depend on the values configured in the root `.env` and Docker Compose configuration.

The default services include:

| Service        |          Default port | Purpose                           |
| -------------- | --------------------: | --------------------------------- |
| MediaWiki      |                `8080` | Knowledge and ontology management |
| Apache Hop Web |                `8081` | Data integration and ETL          |
| MariaDB        |                `3306` | MediaWiki database                |
| PostgreSQL     | Configured in Compose | Relational data                   |
| MinIO          | Configured in Compose | Object storage                    |

After installation, the generated:

```text
connection-info.txt
```

contains the configured access information.

You can inspect it with:

```bash
cat connection-info.txt
```

---

# 🔐 Security

This repository contains infrastructure capable of handling potentially sensitive data.

Never commit:

```text
.env
connection-info.txt
```

or other files containing credentials.

Only commit the corresponding:

```text
.env.example
```

templates.

The `.gitignore` should therefore exclude environment files, generated credentials, database backups, and other deployment-specific artefacts.

---

# 📋 Makefile Command Reference

Run:

```bash
make help
```

to display the commands available in the current version of the platform.

The main commands are:

### First installation

```bash
make install
```

Complete first-time installation.

```bash
make init-env
```

Create missing `.env` files.

```bash
make credentials
```

Generate missing security credentials.

You should only run the `make install` command as it performs the initial setup of the platform and call the other commands. After that, use `make update` for maintenance.

### MediaWiki

```bash
make extensions
make composer-install
make composer
make mediawiki-install
make mediawiki-update
```

### Docker

```bash
make build
make rebuild
make up
make down
make restart
make pull
make status
make logs
```

### Maintenance

```bash
make update
make backup-mariadb
make shell
```

---

# 🧭 Typical Workflows

## First deployment

```bash
git clone <repository-url>
cd <repository-directory>

make init-env
# Review and configure .env files

make install
```

---

## Everyday use

```bash
make up
```

Then access the required services.

When finished:

```bash
make down
```

---

## Adding a MediaWiki extension

```bash
# Edit services/mediawiki/extensions.config

make extensions
make composer              # if required
make mediawiki-update     # if required
```

---

## Updating the platform

```bash
make update
```

---

## Troubleshooting

Check service status:

```bash
make status
```

View logs:

```bash
make logs
```

Open the MediaWiki container:

```bash
make shell
```

Rebuild the Docker images:

```bash
make rebuild
```

---

# 📐 Design Philosophy

iObservatory is intended to provide a **reusable technical foundation**, rather than a fixed application.

The stack therefore follows several principles:

* **Modularity** — services can be added, removed, or replaced.
* **Extensibility** — MediaWiki extensions and data-processing pipelines can be added independently.
* **Separation of concerns** — knowledge management, relational storage, ETL, and object storage are provided by separate services.
* **Automation** — repetitive deployment and maintenance tasks are exposed through the Makefile.
* **Configuration through environment files** — deployment-specific values remain outside the application template.
* **Reproducibility** — `.env.example`, Docker Compose, extension configuration, and Make targets provide a repeatable deployment process.
* **Privacy-conscious deployment** — the stack is designed to support self-hosted infrastructure and local control of data.

The objective is to provide a foundation on which different Observatory platforms can be developed without requiring the underlying deployment architecture to be redesigned from scratch.
