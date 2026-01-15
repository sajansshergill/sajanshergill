-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p2;


-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM retail_sales
LIMIT 10


    

SELECT 
    COUNT(*) 
FROM retail_sales

-- Data Cleaning
SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- 
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many unique customers we have ?

SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales



SELECT DISTINCT category FROM retail_sales


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale > 1000


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1
    
-- ORDER BY 1, 3 DESC

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.


SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category



-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

-- End of project

-- Contributed by Sajan
-- Data Analysis & Business Key Problems & Answers 

-- MY analysis and Findings
-- Q.11 What is the average quantity purchased per transaction for each category?
-- Q.12 Which category has the highest average price per unit, and how does it contribute to overall sales?
-- Q.13 How many customers made more than one purchase (i.e., repeat customers)?
-- Q.14 At what hour of the day is the average transaction value the highest?
-- Q.15 What percentage of total sales comes from customers aged between 18 and 30?
-- Q.16 What is the month-over-month growth rate of total sales?
-- Q.17 What is the average transaction value by gender?
-- Q.18 Which are the top 3 categories contributing to total sales each month?
-- Q.19 For each customer, what was their highest single transaction value and the category purchased?
-- Q.20 What is the distribution of total sales across different customer age groups (e.g., <18, 18–30, 31–45, 46–60, 60+)?



-- Q.11 What is the average quantity purchased per transaction for each category?

SELECT 
    category,
    ROUND(AVG(quantity), 2) as avg_quantity
FROM retail_sales
GROUP BY category;


-- Q.12 Which category has the highest average price per unit, and how does it contribute to overall sales?

SELECT
    category,
    ROUND(AVG(price_per_unit), 2) avg_price,
    SUM(total_sale) AS total_sales
FROM
    retail_sales
GROUP BY category
ORDER BY avg_price DESC
LIMIT 1;

-- Q.13 How many customers made more than one purchase (i.e., repeat customers)?

SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT customer_id
    FROM retail_sales
    GROUP BY customer_id
    HAVING COUNT(*) > 1
) AS t;

-- Q.14 At what hour of the day is the average transaction value the highest?

SELECT
    EXTRACT (HOUR FROM sale_time) AS hour,
    ROUND(AVG(total_sale), 2) AS avg_transaction_value
FROM retail_sales
GROUP BY hour
ORDER BY avg_transaction_value DESC
LIMIT 1;

-- Q.15 What percentage of total sales comes from customers aged between 18 and 30?

SELECT
    ROUND(SUM(CASE WHEN age BETWEEN 18 AND 30 THEN total_sale ELSE 0 END) * 100 / SUM(total_sales), 2) AS pct_sales_18_30
FROM 
    retail_sales;

-- Q.16 What is the month-over-month growth rate of total sales?

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', sale_date) AS month,
        SUM(total_sale) AS total_sales
    FROM retail_sales
    GROUP BY month
),
growth_calc AS (
    SELECT
        month,
        total_sales,
        LAG(total_sales) OVER (ORDER BY month) AS prev_month_sales
    FROM
        monthly_sales
)
SELECT
    month,
    total_sales,
    prev_month_sales,
    ROUND(((total_sales - prev_month_sales) / prev_month_sales) * 100, 2) AS growth_rate_pct
FROM growth_calc
WHERE prev_month_sales IS NOT NULL;


-- Q.17 What is the average transaction value by gender?

SELECT
    gender,
    ROUND(AVG(total_sale), 2) AS avg_transaction_value
FROM retail_sales
GROUP BY gender;


-- Q.18 Which are the top 3 categories contributing to total sales each month?

WITH monthly_category_sales AS (
    SELECT
        DATE_TRUNC('month', sale_date) AS month,
        category,
        SUM(total_sale) AS total_sales,
        RANK() OVER (PARTITION BY DATE_TRUNC('month', sale_date) ORDER BY SUM(total_sale) DESC) as rank
    FROM retail_sales
    GROUP BY month, category
)
SELECT
    month,
    category,
    total_sales
FROM monthly_category_sales
WHERE rank <= 3
ORDER BY month, rank;


-- Q.19 For each customer, what was their highest single transaction value and the category purchased?

SELECT DISCTINCT ON (customer_id)
    customer_id,
    total_sale,
    category
FROM retail_sales
ORDER BY customer_id, total_sale DESC;


-- Q.20 What is the distribution of total sales across different customer age groups (e.g., <18, 18–30, 31–45, 46–60, 60+)?

SELECT
    CASE
        WHEN age < 18 THEN '<18'
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 45 THEN '31-45'
        ELSE '60+'
    END AS age_group,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY age_group
ORDER BY age_group;