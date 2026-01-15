# Quick Start Guide

Get up and running in 5 minutes!

## 🚀 One-Command Setup

```bash
./setup.sh
```

That's it! The script handles everything automatically.

## 📊 Verify It Works

```bash
# View the dashboard
docker exec -it sql-data-analytics /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P "YourStrong@Passw0rd" \
  -d DataWarehouseAnalytics \
  -Q "SELECT * FROM gold.dashboard_summary"
```

## 🎯 Common Queries

### Top 10 Customers
```sql
SELECT TOP 10 * FROM gold.report_customers
ORDER BY total_sales DESC;
```

### Top 10 Products
```sql
SELECT TOP 10 * FROM gold.report_products
ORDER BY total_sales DESC;
```

### Business Overview
```sql
SELECT * FROM gold.dashboard_summary;
```

## 🛑 Stop Everything

```bash
docker-compose down
```

## 🔄 Start Again

```bash
docker-compose up -d
```

## 📚 Need More Help?

See [SETUP.md](SETUP.md) for detailed instructions.

---

**That's it! You're ready to analyze data! 🎉**
