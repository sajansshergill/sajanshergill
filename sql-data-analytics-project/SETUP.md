# SQL Data Analytics Project - Setup Guide

## 🚀 Quick Start

This guide will help you set up and run the complete SQL Data Analytics project end-to-end.

## Prerequisites

- **Docker** and **Docker Compose** installed
- **SQL Server Command Line Tools** (sqlcmd) - Optional, for direct execution
- **Git** (to clone the repository)

## 📋 Setup Options

### Option 1: Docker Compose (Recommended - Easiest)

This is the simplest way to get started. Docker Compose will handle everything automatically.

#### Step 1: Start SQL Server Container

```bash
cd sql-data-analytics-project
docker-compose up -d
```

This will:
- Start SQL Server 2022 in a container
- Mount the CSV files directory
- Expose SQL Server on port 1433
- Wait for SQL Server to be ready (health check)

#### Step 2: Wait for SQL Server to be Ready

```bash
# Check container status
docker ps

# Check logs to ensure SQL Server started successfully
docker logs sql-data-analytics
```

Wait until you see: `SQL Server is now ready for client connections`

#### Step 3: Initialize the Database

```bash
# Using sqlcmd (if installed)
sqlcmd -S localhost -U sa -P "YourStrong@Passw0rd" -i scripts/00_init_database.sql

# Or using Docker exec
docker exec -i sql-data-analytics /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P "YourStrong@Passw0rd" \
  -i /scripts/00_init_database.sql
```

#### Step 4: Run All Analytics Scripts

```bash
# Using sqlcmd
sqlcmd -S localhost -U sa -P "YourStrong@Passw0rd" -i scripts/99_run_all_scripts.sql

# Or using Docker exec
docker exec -i sql-data-analytics /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P "YourStrong@Passw0rd" \
  -i /scripts/99_run_all_scripts.sql
```

### Option 2: Manual Docker Setup

If you prefer more control:

#### Step 1: Start SQL Server Container

```bash
docker run -e "ACCEPT_EULA=Y" \
  -e "MSSQL_SA_PASSWORD=YourStrong@Passw0rd" \
  -p 1433:1433 \
  -v "$(pwd)/datasets/csv-files:/csv-files:ro" \
  -v "$(pwd)/scripts:/scripts:ro" \
  --name sql-data-analytics \
  -d mcr.microsoft.com/mssql/server:2022-latest
```

#### Step 2-4: Same as Option 1

### Option 3: Local SQL Server Instance

If you have SQL Server installed locally:

1. Update the CSV file paths in `00_init_database.sql` to your local paths
2. Run scripts using SQL Server Management Studio (SSMS) or sqlcmd
3. Execute scripts in order: `00_init_database.sql` → `99_run_all_scripts.sql`

## 📊 Verify Installation

After running the setup, verify everything works:

```sql
-- Check database exists
SELECT name FROM sys.databases WHERE name = 'DataWarehouseAnalytics';

-- Check tables are populated
SELECT COUNT(*) AS customer_count FROM gold.dim_customers;
SELECT COUNT(*) AS product_count FROM gold.dim_products;
SELECT COUNT(*) AS sales_count FROM gold.fact_sales;

-- View dashboard summary
SELECT * FROM gold.dashboard_summary;

-- Check reports are created
SELECT TOP 10 * FROM gold.report_customers;
SELECT TOP 10 * FROM gold.report_products;
```

## 📁 Project Structure

```
sql-data-analytics-project/
├── datasets/
│   ├── csv-files/          # Source CSV data files
│   └── DataWarehouseAnalytics.bak  # Database backup (optional)
├── scripts/
│   ├── 00_init_database.sql        # Database initialization (RUN FIRST!)
│   ├── 01-04_*.sql                 # Exploration scripts
│   ├── 05-11_*.sql                 # Analysis scripts
│   ├── 12_report_customers.sql     # Customer report view
│   ├── 13_report_products.sql      # Product report view
│   ├── 98_dashboard_summary.sql     # Executive dashboard
│   └── 99_run_all_scripts.sql       # Master script runner
├── docs/                            # Project documentation
├── docker-compose.yml               # Docker Compose configuration
├── SETUP.md                         # This file
└── README.md                        # Project overview
```

## 🔧 Connection Details

**Default Connection Settings:**
- **Server:** `localhost` (or container IP)
- **Port:** `1433`
- **Username:** `sa`
- **Password:** `YourStrong@Passw0rd`
- **Database:** `DataWarehouseAnalytics`

**Change Password (Recommended for Production):**

1. Update `docker-compose.yml`:
   ```yaml
   environment:
     - MSSQL_SA_PASSWORD=YourNewStrongPassword123!
   ```

2. Update all script execution commands with the new password

## 📝 Script Execution Order

**IMPORTANT:** Always run scripts in this order:

1. **00_init_database.sql** - Creates database, tables, and loads data
2. **99_run_all_scripts.sql** - Runs all analysis scripts in sequence
   - Or run individual scripts 01-13 in order

## 🎯 Key Views and Reports

After setup, you'll have access to:

- **gold.dashboard_summary** - Executive dashboard with key metrics
- **gold.report_customers** - Comprehensive customer analytics
- **gold.report_products** - Comprehensive product analytics

## 🛠️ Troubleshooting

### SQL Server Container Won't Start

```bash
# Check if port 1433 is already in use
lsof -i :1433

# Stop existing containers
docker stop sql-data-analytics
docker rm sql-data-analytics
```

### BULK INSERT Fails

- Ensure CSV files are in `datasets/csv-files/` directory
- Check Docker volume mount is correct
- Verify file permissions (should be readable)

### Connection Timeout

```bash
# Wait longer for SQL Server to initialize (can take 30-60 seconds)
sleep 30
docker logs sql-data-analytics
```

### Reset Everything

```bash
# Stop and remove container
docker-compose down -v

# Remove database (if using local SQL Server)
# Run: DROP DATABASE DataWarehouseAnalytics;

# Start fresh
docker-compose up -d
```

## 📚 Next Steps

1. **Explore the Data:**
   ```sql
   SELECT * FROM gold.dashboard_summary;
   ```

2. **Run Custom Queries:**
   - Use the analysis scripts as templates
   - Modify queries for your specific needs

3. **Connect BI Tools:**
   - Connect Power BI, Tableau, or other tools
   - Use the report views as data sources

4. **Extend the Project:**
   - Add more analysis scripts
   - Create additional reports
   - Integrate with other data sources

## 🔒 Security Notes

- **Change the default password** before deploying to production
- Use environment variables for sensitive credentials
- Consider using SQL Server authentication with limited permissions
- Never commit passwords to version control

## 📞 Support

For issues or questions:
1. Check the troubleshooting section above
2. Review script comments for detailed explanations
3. Check Docker logs: `docker logs sql-data-analytics`

## ✅ Verification Checklist

- [ ] Docker container is running
- [ ] Database `DataWarehouseAnalytics` exists
- [ ] Tables are populated (check row counts)
- [ ] Views are created (dashboard_summary, report_customers, report_products)
- [ ] Can query dashboard summary successfully

---

**Happy Analyzing! 🎉**
