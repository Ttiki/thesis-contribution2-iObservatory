# 💾 Database Backups

## MariaDB Backup
Create a MariaDB backup with:

```bash
make backup-mariadb
```

Backups are stored in:

```text
services/mariadb/backups/
```

with filenames similar to:

```text
backup_2026-08-12_10-30-00.sql
```

Regular backups should be configured according to the deployment's operational requirements.

## PostgreSQL Backup
Create a PostgreSQL backup with:
```bash
make backup-postgres
```

Backups are stored in:

```text
services/postgres/backups/
```

with filenames similar to:

```text
backup_2026-08-12_10-30-00.sql
```

Regular backups should be configured according to the deployment's operational requirements.
