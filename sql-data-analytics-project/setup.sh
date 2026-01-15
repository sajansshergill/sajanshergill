#!/bin/bash

# SQL Data Analytics Project - Automated Setup Script
# This script automates the setup and execution of the SQL Data Analytics project

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
SQL_SERVER="localhost"
SQL_USER="sa"
SQL_PASSWORD="YourStrong@Passw0rd"
SQL_DATABASE="DataWarehouseAnalytics"
CONTAINER_NAME="sql-data-analytics"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}SQL Data Analytics Project Setup${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo -e "${YELLOW}Checking prerequisites...${NC}"

if ! command_exists docker; then
    echo -e "${RED}Error: Docker is not installed. Please install Docker first.${NC}"
    exit 1
fi

if ! command_exists docker-compose; then
    echo -e "${RED}Error: Docker Compose is not installed. Please install Docker Compose first.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Docker and Docker Compose are installed${NC}"
echo ""

# Step 1: Start Docker containers
echo -e "${YELLOW}Step 1: Starting SQL Server container...${NC}"
cd "$SCRIPT_DIR"

if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Container exists. Stopping and removing..."
    docker stop "$CONTAINER_NAME" 2>/dev/null || true
    docker rm "$CONTAINER_NAME" 2>/dev/null || true
fi

docker-compose up -d

echo -e "${GREEN}✓ SQL Server container started${NC}"
echo ""

# Step 2: Wait for SQL Server to be ready
echo -e "${YELLOW}Step 2: Waiting for SQL Server to be ready...${NC}"
echo "This may take 30-60 seconds..."

MAX_ATTEMPTS=30
ATTEMPT=0

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    if docker exec "$CONTAINER_NAME" /opt/mssql-tools/bin/sqlcmd \
        -S localhost -U "$SQL_USER" -P "$SQL_PASSWORD" \
        -Q "SELECT 1" >/dev/null 2>&1; then
        echo -e "${GREEN}✓ SQL Server is ready!${NC}"
        break
    fi
    
    ATTEMPT=$((ATTEMPT + 1))
    echo -n "."
    sleep 2
done

if [ $ATTEMPT -eq $MAX_ATTEMPTS ]; then
    echo -e "\n${RED}Error: SQL Server did not become ready in time.${NC}"
    echo "Check logs with: docker logs $CONTAINER_NAME"
    exit 1
fi

echo ""

# Step 3: Initialize database
echo -e "${YELLOW}Step 3: Initializing database and loading data...${NC}"

if docker exec -i "$CONTAINER_NAME" /opt/mssql-tools/bin/sqlcmd \
    -S localhost -U "$SQL_USER" -P "$SQL_PASSWORD" \
    -i /scripts/00_init_database.sql; then
    echo -e "${GREEN}✓ Database initialized successfully${NC}"
else
    echo -e "${RED}Error: Database initialization failed${NC}"
    exit 1
fi

echo ""

# Step 4: Run analytics scripts
echo -e "${YELLOW}Step 4: Running analytics scripts...${NC}"
echo "This may take a few minutes..."

# Run scripts individually (more reliable than :r in master script)
SCRIPTS=(
    "01_database_exploration.sql"
    "02_dimensions_exploration.sql"
    "03_date_range_exploration.sql"
    "04_measures_exploration.sql"
    "05_magnitude_analysis.sql"
    "06_ranking_analysis.sql"
    "07_change_over_time_analysis.sql"
    "08_cumulative_analysis.sql"
    "09_performance_analysis.sql"
    "10_data_segmentation.sql"
    "11_part_to_whole_analysis.sql"
    "12_report_customers.sql"
    "13_report_products.sql"
    "98_dashboard_summary.sql"
)

for script in "${SCRIPTS[@]}"; do
    echo "  Running $script..."
    if docker exec -i "$CONTAINER_NAME" /opt/mssql-tools/bin/sqlcmd \
        -S localhost -U "$SQL_USER" -P "$SQL_PASSWORD" \
        -d "$SQL_DATABASE" \
        -i "/scripts/$script" >/dev/null 2>&1; then
        echo -e "  ${GREEN}✓${NC} $script"
    else
        echo -e "  ${YELLOW}⚠${NC} $script (non-critical, continuing...)"
    fi
done

echo -e "${GREEN}✓ Analytics scripts executed${NC}"
echo ""

# Step 5: Verify installation
echo -e "${YELLOW}Step 5: Verifying installation...${NC}"

VERIFY_QUERY="
SELECT 
    'Database' AS check_item,
    CASE WHEN COUNT(*) > 0 THEN 'OK' ELSE 'FAIL' END AS status
FROM sys.databases WHERE name = '${SQL_DATABASE}'
UNION ALL
SELECT 
    'Customers Table',
    CASE WHEN COUNT(*) > 0 THEN 'OK' ELSE 'FAIL' END
FROM ${SQL_DATABASE}.gold.dim_customers
UNION ALL
SELECT 
    'Products Table',
    CASE WHEN COUNT(*) > 0 THEN 'OK' ELSE 'FAIL' END
FROM ${SQL_DATABASE}.gold.dim_products
UNION ALL
SELECT 
    'Sales Table',
    CASE WHEN COUNT(*) > 0 THEN 'OK' ELSE 'FAIL' END
FROM ${SQL_DATABASE}.gold.fact_sales
UNION ALL
SELECT 
    'Dashboard View',
    CASE WHEN OBJECT_ID('${SQL_DATABASE}.gold.dashboard_summary', 'V') IS NOT NULL THEN 'OK' ELSE 'FAIL' END
"

if docker exec "$CONTAINER_NAME" /opt/mssql-tools/bin/sqlcmd \
    -S localhost -U "$SQL_USER" -P "$SQL_PASSWORD" \
    -Q "$VERIFY_QUERY" -W -h -1 | grep -q "OK"; then
    echo -e "${GREEN}✓ Installation verified successfully${NC}"
else
    echo -e "${YELLOW}⚠ Some verification checks failed, but setup may still be functional${NC}"
fi

echo ""

# Final summary
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Setup Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Connection Details:"
echo "  Server:   $SQL_SERVER"
echo "  Port:     1433"
echo "  Username: $SQL_USER"
echo "  Password: $SQL_PASSWORD"
echo "  Database: $SQL_DATABASE"
echo ""
echo "Quick Start Commands:"
echo "  View Dashboard:"
echo "    docker exec -it $CONTAINER_NAME /opt/mssql-tools/bin/sqlcmd \\"
echo "      -S localhost -U $SQL_USER -P '$SQL_PASSWORD' \\"
echo "      -d $SQL_DATABASE -Q 'SELECT * FROM gold.dashboard_summary'"
echo ""
echo "  View Customer Report:"
echo "    docker exec -it $CONTAINER_NAME /opt/mssql-tools/bin/sqlcmd \\"
echo "      -S localhost -U $SQL_USER -P '$SQL_PASSWORD' \\"
echo "      -d $SQL_DATABASE -Q 'SELECT TOP 10 * FROM gold.report_customers'"
echo ""
echo "  Stop Container:"
echo "    docker-compose down"
echo ""
echo -e "${GREEN}Happy Analyzing! 🎉${NC}"
