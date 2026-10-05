## Requirements

Before installing the platform, make sure the host system has:

* Docker
* Docker Compose
* Git
* OpenSSL
* Make

Verify the installation:

```bash
docker --version
docker compose version
git --version
openssl version
make --version
```

---

## 1. Clone the repository

```bash
git clone <repository-url>
cd <repository-directory>
```

---

## 2. Configure the environment

The repository uses `.env.example` files as configuration templates.

The installation process automatically searches for `.env.example` files and creates the corresponding `.env` files.

For example:

```text
.env.example
services/mediawiki/.env.example
services/mariadb/.env.example
```

becomes:

```text
.env
services/mediawiki/.env
services/mariadb/.env
```

Existing `.env` files are not overwritten.

You can therefore initialise the environment independently with:

```bash
make init-env
```

Review the generated files and configure any deployment-specific values before starting the platform.

---

## 3. First-time installation

Once the environment has been configured:

```bash
make install
```

The installation pipeline performs the following steps:

```text
┌──────────────────────────┐
│ make install             │
└────────────┬─────────────┘
             │
             ▼
     Initialise .env files
             │
             ▼
      Generate credentials
             │
             ▼
     Install MediaWiki
        extensions
             │
             ▼
       Build containers
             │
             ▼
       Start services
             │
             ▼
      Wait for services
             │
             ▼
     Install MediaWiki
             │
             ▼
    Install dependencies
             │
             ▼
    Update MediaWiki DB
             │
             ▼
    Generate connection info
```

At the end of the installation, a:

```text
connection-info.txt
```

file is generated containing the main access information.

> 🔐 `connection-info.txt` contains credentials and must **not** be committed to version control.

---

# 🔧 Configuration

## Root environment

The root `.env` contains deployment-level configuration.

Example:

```env
HOSTNAME=<SERVER_IP_OR_HOSTNAME>
OBSERVATORY_NAME=<OBSERVATORY_NAME>
```

Do not commit sensitive values.

---

## MediaWiki environment

MediaWiki-specific configuration is stored in:

```text
services/mediawiki/.env
```

Example:

```env
MEDIAWIKI_ADMIN_USER=admin

MEDIAWIKI_ADMIN_PWD=
MEDIAWIKI_SECRET_KEY=
MEDIAWIKI_UPGRADE_KEY=

MYSQL_DATABASE=my_wiki
MYSQL_USER=wikiuser
MYSQL_PASSWORD=
MYSQL_ROOT_PASSWORD=
```

Security-sensitive values can be generated automatically by:

```bash
make credentials
```

During the first installation, credentials are generated automatically.

---

# 📦 Managing MediaWiki Extensions

MediaWiki extensions are divided into two main categories.

## Git-based extensions

Extensions listed in:

```text
services/mediawiki/extensions.config
```

are downloaded by:

```bash
make extensions
```

The configured MediaWiki branch/version is controlled by:

```makefile
DEFAULT_EXT_VERSION := REL1_43
```

Extensions can therefore be centrally managed without manually cloning repositories.

---

## Composer dependencies

Some extensions and MediaWiki components require Composer dependencies.

Composer has its own Make targets.

### Install dependencies

Use:

```bash
make composer-install
```

This installs dependencies according to the existing lock file.

### Update dependencies

Use:

```bash
make composer
```

This updates Composer dependencies.

This distinction is important:

```text
composer-install
    ↓
Reproduce existing dependency versions

composer
    ↓
Resolve and update dependency versions
```

---

# ➕ Adding a New Extension

For a Git-based MediaWiki extension:

### 1. Add it to

```text
services/mediawiki/extensions.config
```

### 2. Download it

```bash
make extensions
```

### 3. If required, install/update Composer dependencies

```bash
make composer
```

### 4. If the extension introduces database changes

```bash
make mediawiki-update
```

The general workflow is therefore:

```text
Add extension
     │
     ▼
make extensions
     │
     ├───────────────┐
     ▼               ▼
Composer required?   No
     │
     ▼
make composer
     │
     ▼
Database update required?
     │
     ▼
make mediawiki-update
```

---
