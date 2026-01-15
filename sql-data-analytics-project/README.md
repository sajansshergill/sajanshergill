# SQL Data Analytics Project

A comprehensive, end-to-end SQL data analytics project demonstrating advanced SQL techniques for data exploration, analysis, and reporting. This project includes a complete data warehouse setup with customer and product analytics, executive dashboards, and automated deployment scripts.

## 🎯 Project Overview

This project provides a complete analytics solution including:

- **Data Warehouse Setup** - Automated database initialization with dimension and fact tables
- **Exploratory Data Analysis** - Comprehensive scripts for data exploration
- **Advanced Analytics** - Ranking, segmentation, time-series, and performance analysis
- **Executive Reports** - Pre-built customer and product reports with KPIs
- **Dashboard Summary** - High-level business metrics view
- **Docker Deployment** - One-command setup with Docker Compose

## ✨ Features

- 📊 **14 Analysis Scripts** covering all major analytical patterns
- 🎯 **3 Report Views** (Customers, Products, Dashboard Summary)
- 🐳 **Docker Support** for easy deployment
- 📈 **Key Performance Indicators** (KPIs) pre-calculated
- 🔄 **Automated Setup** with shell scripts
- 📚 **Comprehensive Documentation**

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Git (to clone the repository)

### Option 1: Automated Setup (Recommended)

```bash
# Clone the repository
git clone <repository-url>
cd sql-data-analytics-project

# Make setup script executable
chmod +x setup.sh

# Run automated setup
./setup.sh
```

The script will:
1. Start SQL Server container
2. Initialize the database
3. Load all data
4. Run all analytics scripts
5. Create reports and dashboard
6. Verify installation

### Option 2: Docker Compose

```bash
# Start SQL Server
docker-compose up -d

# Wait for SQL Server to be ready (30-60 seconds)
docker logs -f sql-data-analytics

# Initialize database
docker exec -i sql-data-analytics /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P "YourStrong@Passw0rd" \
  -i /scripts/00_init_database.sql

# Run all analytics
docker exec -i sql-data-analytics /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P "YourStrong@Passw0rd" \
  -d DataWarehouseAnalytics \
  -i /scripts/99_run_all_scripts.sql
```

### Option 3: Manual Setup

See [SETUP.md](SETUP.md) for detailed manual setup instructions.

## 📁 Project Structure

```
sql-data-analytics-project/
├── datasets/
│   ├── csv-files/                    # Source CSV data files
│   │   ├── gold.dim_customers.csv
│   │   ├── gold.dim_products.csv
│   │   └── gold.fact_sales.csv
│   └── DataWarehouseAnalytics.bak    # Database backup (optional)
├── scripts/
│   ├── 00_init_database.sql          # Database initialization (RUN FIRST!)
│   ├── 01_database_exploration.sql   # Database structure exploration
│   ├── 02_dimensions_exploration.sql # Dimension table analysis
│   ├── 03_date_range_exploration.sql # Date range analysis
│   ├── 04_measures_exploration.sql   # Key metrics calculation
│   ├── 05_magnitude_analysis.sql     # Magnitude and scale analysis
│   ├── 06_ranking_analysis.sql       # Top/bottom performers
│   ├── 07_change_over_time_analysis.sql # Time-series trends
│   ├── 08_cumulative_analysis.sql    # Cumulative metrics
│   ├── 09_performance_analysis.sql   # Performance benchmarking
│   ├── 10_data_segmentation.sql     # Customer/product segmentation
│   ├── 11_part_to_whole_analysis.sql # Composition analysis
│   ├── 12_report_customers.sql       # Customer report view
│   ├── 13_report_products.sql        # Product report view
│   ├── 98_dashboard_summary.sql      # Executive dashboard
│   └── 99_run_all_scripts.sql        # Master script runner
├── docs/                             # Project documentation
├── docker-compose.yml                # Docker Compose configuration
├── setup.sh                          # Automated setup script
├── SETUP.md                          # Detailed setup guide
└── README.md                         # This file
```

## 📊 Available Reports and Views

### 1. Dashboard Summary (`gold.dashboard_summary`)

Executive-level overview with key business metrics:

```sql
SELECT * FROM gold.dashboard_summary;
```

**Includes:**
- Total revenue, orders, customers, products
- Customer segmentation (VIP, Regular, New)
- Product performance categories
- Average order value, customer lifetime value
- Monthly revenue trends

### 2. Customer Report (`gold.report_customers`)

Comprehensive customer analytics:

```sql
SELECT TOP 10 * FROM gold.report_customers
ORDER BY total_sales DESC;
```

**Includes:**
- Customer demographics (age, age groups)
- Customer segments (VIP, Regular, New)
- Purchase history (total orders, sales, quantity)
- KPIs (recency, average order value, monthly spend)
- Customer lifespan

### 3. Product Report (`gold.report_products`)

Comprehensive product analytics:

```sql
SELECT TOP 10 * FROM gold.report_products
ORDER BY total_sales DESC;
```

**Includes:**
- Product details (name, category, subcategory, cost)
- Product segments (High-Performer, Mid-Range, Low-Performer)
- Sales metrics (orders, revenue, quantity, customers)
- KPIs (recency, average order revenue, monthly revenue)
- Product lifespan

## 🔍 Analysis Scripts Overview

| Script | Purpose | Key Techniques |
|--------|---------|----------------|
| 01 | Database Exploration | Table structure, relationships |
| 02 | Dimensions Exploration | Dimension table analysis |
| 03 | Date Range Analysis | Time-based filtering |
| 04 | Measures Exploration | Aggregations (SUM, AVG, COUNT) |
| 05 | Magnitude Analysis | Scale and distribution analysis |
| 06 | Ranking Analysis | TOP, RANK(), DENSE_RANK() |
| 07 | Change Over Time | Time-series, period comparisons |
| 08 | Cumulative Analysis | Running totals, cumulative metrics |
| 09 | Performance Analysis | Benchmarking, comparisons |
| 10 | Data Segmentation | CASE statements, grouping |
| 11 | Part-to-Whole | Composition, percentages |

## 🔧 Connection Details

**Default Settings:**
- **Server:** `localhost`
- **Port:** `1433`
- **Username:** `sa`
- **Password:** `YourStrong@Passw0rd`
- **Database:** `DataWarehouseAnalytics`

**Change Password:**

Update `docker-compose.yml`:
```yaml
environment:
  - MSSQL_SA_PASSWORD=YourNewPassword123!
```

## 📈 Sample Queries

### View Top 10 Customers by Revenue

```sql
SELECT TOP 10
    customer_name,
    total_sales,
    total_orders,
    customer_segment,
    avg_order_value
FROM gold.report_customers
ORDER BY total_sales DESC;
```

### View Top 10 Products by Revenue

```sql
SELECT TOP 10
    product_name,
    category,
    total_sales,
    total_orders,
    product_segment
FROM gold.report_products
ORDER BY total_sales DESC;
```

### Get Business Overview

```sql
SELECT 
    total_revenue,
    total_orders,
    active_customers,
    revenue_per_customer,
    avg_monthly_revenue
FROM gold.dashboard_summary;
```

### Customer Segmentation Analysis

```sql
SELECT 
    customer_segment,
    COUNT(*) AS customer_count,
    AVG(total_sales) AS avg_revenue,
    AVG(avg_order_value) AS avg_aov
FROM gold.report_customers
GROUP BY customer_segment;
```

## 🛠️ Troubleshooting

### SQL Server Container Issues

```bash
# Check container status
docker ps -a | grep sql-data-analytics

# View logs
docker logs sql-data-analytics

# Restart container
docker-compose restart
```

### Connection Issues

```bash
# Test connection
docker exec sql-data-analytics /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P "YourStrong@Passw0rd" \
  -Q "SELECT @@VERSION"
```

### Reset Everything

```bash
# Stop and remove everything
docker-compose down -v

# Start fresh
./setup.sh
```

## 📚 Documentation

- **[SETUP.md](SETUP.md)** - Detailed setup instructions
- **Script Comments** - Each script includes detailed comments explaining purpose and techniques
- **Inline Documentation** - SQL comments explain query logic

## 🎓 Learning Resources

This project demonstrates:

- **Data Warehouse Design** - Star schema, dimensions, facts
- **SQL Best Practices** - Efficient queries, proper indexing
- **Analytical Patterns** - Common business analytics patterns
- **Report Design** - Creating reusable report views
- **Docker Deployment** - Containerized database setup

## 🔒 Security Notes

- ⚠️ **Change default password** before production use
- Use environment variables for sensitive credentials
- Consider SQL Server authentication with limited permissions
- Never commit passwords to version control

## 📝 License

This project is licensed under the [MIT License](LICENSE).

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

For issues or questions:
1. Check the [SETUP.md](SETUP.md) troubleshooting section
2. Review script comments for detailed explanations
3. Check Docker logs: `docker logs sql-data-analytics`

## ✅ Verification Checklist

After setup, verify:

- [ ] Database `DataWarehouseAnalytics` exists
- [ ] Tables populated (check row counts)
- [ ] Views created (dashboard_summary, report_customers, report_products)
- [ ] Can query dashboard summary successfully
- [ ] All scripts executed without errors

## 🎯 Next Steps

1. **Explore the Data** - Run sample queries above
2. **Customize Reports** - Modify views for your needs
3. **Connect BI Tools** - Use views as data sources for Power BI, Tableau, etc.
4. **Extend Analysis** - Add your own analysis scripts
5. **Production Deployment** - Follow security best practices

---

**Happy Analyzing! 🎉**

For detailed setup instructions, see [SETUP.md](SETUP.md)
