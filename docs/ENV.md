# Environment Configuration

Each service has its own `.env` file under:

services/<service>/.env


Do **not** commit actual `.env` files — use the `.env.example` templates provided.

---

## Global `.env` (used by all)

| Variable             | Description                     |
|----------------------|---------------------------------|
| `DOMAIN_NAME`        | Base domain (e.g. unitapedia.univ-unita.eu) |
| `LETSENCRYPT_EMAIL`  | SSL registration email          |
| `OBSERVATORY_NAME`   | Name shown in apps (e.g. wiki)  |

---

## Examples

- MediaWiki uses:
  - `MEDIAWIKI_DB_NAME`, `MEDIAWIKI_ADMIN_USER`
- Strapi uses:
  - `DATABASE_HOST`, `APP_KEYS`, `JWT_SECRET`
- PostgreSQL uses:
  - `POSTGRES_DB`, `POSTGRES_USER`

See `services/<service>/.env.example` for full reference.
