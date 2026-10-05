# 🧩 Components

## 🌐 MediaWiki

**Semantic knowledge management and ontology platform**

MediaWiki provides the main knowledge-management interface of the platform.

It can be used to:

* Create and manage structured knowledge
* Develop and populate ontologies
* Define templates and schemas
* Collect structured information
* Provide a human-facing interface for knowledge management
* Expose structured information to other components

### Semantic extensions

The default configuration can include extensions such as:

* **Cargo** — Store and query structured data
* **PageForms** — Provide forms for structured data entry
* **PageSchemas** — Define schemas for pages and forms
* **VisualEditor** — WYSIWYG editing
* **Arrays** — Array manipulation in templates
* **Variables** — Advanced template programming

Additional MediaWiki extensions can be configured through:

```text
services/mediawiki/extensions.config
```

---

## 🗄️ MariaDB

**MediaWiki relational database**

MariaDB is used as the primary database backend for MediaWiki.

It stores:

* Wiki content
* User information
* MediaWiki configuration data
* Structured data managed by MediaWiki extensions

The database is normally exposed only inside the Docker network.

---

## 🐘 PostgreSQL

**Relational data storage**

PostgreSQL provides a separate relational database that can be used by other Observatory components.

Keeping PostgreSQL separate from MediaWiki's MariaDB database allows the platform to maintain distinct data domains and services.

---

## 🏭 Apache Hop Web

**Data integration and ETL**

Apache Hop provides the data integration layer of the platform.

It can be used to:

* Import external datasets
* Process CSV files
* Clean and transform data
* Connect to external databases and APIs
* Normalise data
* Prepare data for ingestion into other platform components
* Automate repeatable data-processing workflows

### Directory structure

```text
services/hop-web/
│
├── projects/
│   └── Source data and project files
│
└── pipelines/
    ├── *.hpl
    └── *.hwf
```

These directories are mounted into the Apache Hop container.

---

## 🪣 MinIO

**Object storage**

MinIO provides S3-compatible object storage for files, datasets, artefacts, and other objects used by the platform.

It can be used as a storage layer independently from the relational databases.

---

## 📝 Strapi

**Content and API layer**

Strapi can be used when a traditional headless CMS or API-oriented content management layer is required.

Its inclusion in the stack is optional and can be adapted according to the requirements of a particular Observatory deployment.

