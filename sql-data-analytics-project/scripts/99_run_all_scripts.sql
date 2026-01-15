/*
===============================================================================
Master Script - Run All Analytics Scripts
===============================================================================
Purpose:
    This script executes all analytics scripts in the correct order to set up
    and analyze the complete data warehouse.

Execution Order:
    1. Database initialization (00_init_database.sql) - Run separately first
    2. Exploration scripts (01-04)
    3. Analysis scripts (05-11)
    4. Report generation (12-13)
    5. Summary dashboard (98_dashboard_summary.sql)

NOTE: Run 00_init_database.sql FIRST before executing this script!
===============================================================================
*/

PRINT '===============================================================================';
PRINT 'Starting SQL Data Analytics Project - Master Script Execution';
PRINT '===============================================================================';
PRINT '';

USE DataWarehouseAnalytics;
GO

-- =============================================================================
-- Phase 1: Database Exploration
-- =============================================================================
PRINT 'Phase 1: Database Exploration...';
PRINT 'Executing: 01_database_exploration.sql';
:r ./01_database_exploration.sql
GO

PRINT 'Executing: 02_dimensions_exploration.sql';
:r ./02_dimensions_exploration.sql
GO

PRINT 'Executing: 03_date_range_exploration.sql';
:r ./03_date_range_exploration.sql
GO

PRINT 'Executing: 04_measures_exploration.sql';
:r ./04_measures_exploration.sql
GO

-- =============================================================================
-- Phase 2: Advanced Analysis
-- =============================================================================
PRINT '';
PRINT 'Phase 2: Advanced Analysis...';
PRINT 'Executing: 05_magnitude_analysis.sql';
:r ./05_magnitude_analysis.sql
GO

PRINT 'Executing: 06_ranking_analysis.sql';
:r ./06_ranking_analysis.sql
GO

PRINT 'Executing: 07_change_over_time_analysis.sql';
:r ./07_change_over_time_analysis.sql
GO

PRINT 'Executing: 08_cumulative_analysis.sql';
:r ./08_cumulative_analysis.sql
GO

PRINT 'Executing: 09_performance_analysis.sql';
:r ./09_performance_analysis.sql
GO

PRINT 'Executing: 10_data_segmentation.sql';
:r ./10_data_segmentation.sql
GO

PRINT 'Executing: 11_part_to_whole_analysis.sql';
:r ./11_part_to_whole_analysis.sql
GO

-- =============================================================================
-- Phase 3: Report Generation
-- =============================================================================
PRINT '';
PRINT 'Phase 3: Report Generation...';
PRINT 'Executing: 12_report_customers.sql';
:r ./12_report_customers.sql
GO

PRINT 'Executing: 13_report_products.sql';
:r ./13_report_products.sql
GO

-- =============================================================================
-- Phase 4: Summary Dashboard
-- =============================================================================
PRINT '';
PRINT 'Phase 4: Generating Summary Dashboard...';
:r ./98_dashboard_summary.sql
GO

PRINT '';
PRINT '===============================================================================';
PRINT 'All scripts executed successfully!';
PRINT '===============================================================================';
PRINT '';
PRINT 'Next Steps:';
PRINT '1. Review the generated reports: gold.report_customers and gold.report_products';
PRINT '2. Query the dashboard summary view: gold.dashboard_summary';
PRINT '3. Explore the analysis results from the executed scripts';
PRINT '===============================================================================';
