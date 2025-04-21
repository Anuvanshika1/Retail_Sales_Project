-- SQL RETAIL SALES ANALYSIS
-- Create Database
create database sql_project_p2;
use sql_project_p2;

-- CREATE A TABLE

drop table if exists retail_sales; 
CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sales_date DATE,
    sales_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
-- to check the data

select * from retail_sales;

-- to check the total records in the dataset
select count(*) as total 
from retail_sales;

-- data cleaning

-- to check any null values exists for every column
select * from retail_sales
where transactions_id is null;
-- now rather than writing code for every single column we can use all columns in OR statement to check all 
select * from retail_sales
where transactions_id is null
or sales_date is null
or sales_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantity is null
or price_per_unit is null
or cogs is null
or total_sale is null;
-- now we can delete the null columns from the table
delete from retail_sales
where transactions_id is null
or sales_date is null
or sales_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantity is null
or price_per_unit is null
or cogs is null
or total_sale is null;

-- data exploration 

-- how many sales we have?
SELECT 
    COUNT(*) AS total_sales
FROM
    retail_sales;
-- how many customers we have?
SELECT 
    COUNT(DISTINCT customer_id) AS total_customers
FROM
    retail_sales;
-- how many total categories we have?
SELECT 
    COUNT(DISTINCT category) AS total_category
FROM
    retail_sales;
-- what are the names of the category
SELECT DISTINCT
    category
FROM
    retail_sales;

-- Data Analysis or Business key problems and answers
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT 
    *
FROM
    retail_sales
WHERE
    sales_date = '2022-11-05';
    
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT 
    *
FROM
    retail_sales
WHERE
    category = 'Clothing'
        AND sales_date BETWEEN '2022-11-01' AND '2022-11-30'

;
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
    category, SUM(quantity) AS total_sales
FROM
    retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
    ROUND(AVG(age), 2) AS avg_age
FROM
    retail_sales
WHERE
    category = 'Beauty'
GROUP BY category;

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT 
    *
FROM
    retail_sales
WHERE
    total_sale > 1000;
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
    gender,
    category,
    COUNT(transactions_id) AS total_transactions
FROM
    retail_sales
GROUP BY gender , category
ORDER BY gender;
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
with cte as
(
	select a.sales_year,
	a.sales_month,
	a.avg_total,
	row_number()over(partition by a.sales_year order by a.avg_total desc) as rn 
from 
( 
	select year(sales_date) as sales_year,
	month(sales_date) as sales_month,
	round(avg(total_sale),2) as avg_total
	from retail_sales
	group by sales_year,sales_month
	order by avg_total desc) a 
)
select sales_year,sales_month,avg_total
from cte where rn=1
;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
    customer_id, SUM(total_sale) AS max_sale
FROM
    retail_sales
GROUP BY customer_id
ORDER BY max_sale DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    category, COUNT(DISTINCT customer_id) AS unique_customer
FROM
    retail_sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
SELECT 
		CASE
        WHEN HOUR(sales_time) <= 12 THEN 'Morning'
        WHEN HOUR(sales_time) BETWEEN '12' AND '17' THEN 'Afternoon'
        WHEN HOUR(sales_time) > '17' THEN 'Evening'
    END AS Shift,
    count(*) as total_orders
FROM
    retail_sales
group by shift
