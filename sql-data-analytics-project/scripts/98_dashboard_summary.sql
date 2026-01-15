/*
===============================================================================
Dashboard Summary View
===============================================================================
Purpose:
    - Provides a comprehensive overview of key business metrics
    - Aggregates data from customers, products, and sales
    - Useful for executive dashboards and quick insights

Key Metrics:
    1. Overall Business Metrics (Total Sales, Orders, Customers, Products)
    2. Customer Metrics (Segmentation, Average Values)
    3. Product Metrics (Performance, Categories)
    4. Time-based Metrics (Date Ranges, Trends)
===============================================================================
*/

-- =============================================================================
-- Create Dashboard Summary View
-- =============================================================================
IF OBJECT_ID('gold.dashboard_summary', 'V') IS NOT NULL
    DROP VIEW gold.dashboard_summary;
GO

CREATE VIEW gold.dashboard_summary AS

WITH business_metrics AS (
    SELECT 
        COUNT(DISTINCT f.order_number) AS total_orders,
        COUNT(DISTINCT f.customer_key) AS active_customers,
        COUNT(DISTINCT f.product_key) AS active_products,
        SUM(f.sales_amount) AS total_revenue,
        SUM(f.quantity) AS total_quantity_sold,
        AVG(CAST(f.sales_amount AS FLOAT) / NULLIF(f.quantity, 0)) AS avg_unit_price,
        MIN(f.order_date) AS first_order_date,
        MAX(f.order_date) AS last_order_date,
        DATEDIFF(month, MIN(f.order_date), MAX(f.order_date)) AS business_lifespan_months
    FROM gold.fact_sales f
    WHERE f.order_date IS NOT NULL
),
customer_metrics AS (
    SELECT 
        COUNT(DISTINCT c.customer_key) AS total_customers,
        COUNT(DISTINCT CASE WHEN ca.customer_segment = 'VIP' THEN c.customer_key END) AS vip_customers,
        COUNT(DISTINCT CASE WHEN ca.customer_segment = 'Regular' THEN c.customer_key END) AS regular_customers,
        COUNT(DISTINCT CASE WHEN ca.customer_segment = 'New' THEN c.customer_key END) AS new_customers,
        AVG(ca.total_sales) AS avg_customer_lifetime_value,
        AVG(ca.avg_order_value) AS avg_order_value,
        AVG(ca.recency) AS avg_customer_recency_months
    FROM gold.dim_customers c
    LEFT JOIN gold.report_customers ca ON c.customer_key = ca.customer_key
),
product_metrics AS (
    SELECT 
        COUNT(DISTINCT p.product_key) AS total_products,
        COUNT(DISTINCT CASE WHEN pr.product_segment = 'High-Performer' THEN p.product_key END) AS high_performer_products,
        COUNT(DISTINCT CASE WHEN pr.product_segment = 'Mid-Range' THEN p.product_key END) AS mid_range_products,
        COUNT(DISTINCT CASE WHEN pr.product_segment = 'Low-Performer' THEN p.product_key END) AS low_performer_products,
        COUNT(DISTINCT p.category) AS total_categories,
        COUNT(DISTINCT p.subcategory) AS total_subcategories,
        AVG(pr.total_sales) AS avg_product_revenue,
        AVG(pr.avg_order_revenue) AS avg_product_order_revenue
    FROM gold.dim_products p
    LEFT JOIN gold.report_products pr ON p.product_key = pr.product_key
),
time_metrics AS (
    SELECT 
        YEAR(f.order_date) AS order_year,
        COUNT(DISTINCT f.order_number) AS orders_per_year,
        SUM(f.sales_amount) AS revenue_per_year
    FROM gold.fact_sales f
    WHERE f.order_date IS NOT NULL
    GROUP BY YEAR(f.order_date)
)

SELECT 
    -- Business Overview
    bm.total_orders,
    bm.active_customers,
    bm.active_products,
    bm.total_revenue,
    bm.total_quantity_sold,
    bm.avg_unit_price,
    bm.first_order_date,
    bm.last_order_date,
    bm.business_lifespan_months,
    
    -- Customer Metrics
    cm.total_customers,
    cm.vip_customers,
    cm.regular_customers,
    cm.new_customers,
    ROUND(cm.avg_customer_lifetime_value, 2) AS avg_customer_lifetime_value,
    ROUND(cm.avg_order_value, 2) AS avg_order_value,
    ROUND(cm.avg_customer_recency_months, 1) AS avg_customer_recency_months,
    
    -- Product Metrics
    pm.total_products,
    pm.high_performer_products,
    pm.mid_range_products,
    pm.low_performer_products,
    pm.total_categories,
    pm.total_subcategories,
    ROUND(pm.avg_product_revenue, 2) AS avg_product_revenue,
    ROUND(pm.avg_product_order_revenue, 2) AS avg_product_order_revenue,
    
    -- Calculated KPIs
    ROUND(bm.total_revenue / NULLIF(bm.total_orders, 0), 2) AS revenue_per_order,
    ROUND(bm.total_revenue / NULLIF(bm.active_customers, 0), 2) AS revenue_per_customer,
    ROUND(bm.total_revenue / NULLIF(bm.business_lifespan_months, 0), 2) AS avg_monthly_revenue,
    ROUND(CAST(bm.active_customers AS FLOAT) / NULLIF(cm.total_customers, 0) * 100, 2) AS customer_activation_rate
    
FROM business_metrics bm
CROSS JOIN customer_metrics cm
CROSS JOIN product_metrics pm;
GO

-- Display the dashboard summary
SELECT * FROM gold.dashboard_summary;
GO

PRINT 'Dashboard summary view created successfully!';
PRINT 'Query: SELECT * FROM gold.dashboard_summary;';
GO
