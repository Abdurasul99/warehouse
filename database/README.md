# Warehouse PostgreSQL

Local database for the warehouse mobile app.

## Run

```bash
docker compose up -d postgres
```

Connection:

```text
postgresql://sales_system:sales_system_pass@localhost:5432/sales_system_warehouse
```

The Flutter app still uses in-memory mock data until a backend API is added.
