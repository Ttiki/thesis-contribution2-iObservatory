## 🏗️ Architecture

```text
iObservatory/
│
├── 🐳 docker-compose.yml
├── 📋 Makefile
├── 🔧 .env.example
├── 🚫 .gitignore
│
└── services/
    │
    ├── 🌐 mediawiki/
    │   ├── 🐳 MediaWiki.Dockerfile
    │   ├── ⚙️ LocalSettings.php
    │   ├── 🔧 .env.example
    │   ├── 📦 composer.local.json
    │   ├── 📋 extensions.config
    │   └── 🔌 extensions/
    │
    ├── 🗄️ mariadb/
    │   └── 🔧 .env.example
    │
    ├── 🐘 postgres/
    │   └── 🔧 .env.example
    │
    ├── 🏭 hop-web/
    │   ├── 🔧 .env.example
    │   ├── 📁 projects/
    │   ├── 📁 pipelines/
    │   └── 🐱 tomcat/
    │
    ├── 📝 strapi/
    │   └── ...
    │
    └── 🪣 minio/
        └── ...
```

The exact set of services may evolve with the template. The architecture is intentionally modular so that additional components can be introduced without changing the overall deployment workflow.
