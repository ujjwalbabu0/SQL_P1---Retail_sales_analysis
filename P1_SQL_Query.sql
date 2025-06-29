-- 1. Database Setup

-- Database creation
use sql_project_p1;

-- Table creation
create table retail_Sales
	(
    transactions_id int primary key,
    sale_date date,
    sale_time time,
    customer_id int,
    gender varchar(10),
    age int,
    category varchar(15),
    quantity int,
    price_per_unit float,
    cogs int,
    total_sale float
    );



-- 2. Data Exploration & Cleaning

-- Record Count: Determine the total number of records in the dataset.
select count(*) from retail_Sales;

-- Customer Count: Find out how many unique customers are in the dataset.
select count(distinct customer_id) from retail_sales;

-- Category Count: Identify all unique product categories in the dataset.
select count(distinct category) from retail_Sales;

-- Null Value Check: Check for any null values in the dataset and delete records with missing data.
select * from retail_Sales 
where
	sale_date is null or sale_time is null or customer_id is null or
    category is null or quantity is null or
    price_per_unit is null or cogs is null or total_Sale is null;
    
delete FROM retail_sales
WHERE
  sale_date IS NULL OR
  sale_time IS NULL OR
  customer_id IS NULL OR
  category IS NULL OR
  quantity IS NULL OR
  price_per_unit IS NULL OR
  cogs IS NULL OR
  total_sale IS NULL;

-- 3. Data Analysis & Findings

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of November 2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out the best-selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example: Morning <=12, Afternoon Between 12 & 17, Evening >17)



-- (1)Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select * from retail_sales
where sale_Date = '2022-11-05';

-- (2)Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
select * from retail_sales
where category = 'clothing' and 
	quantity >4 and 
    date_format(sale_date, "%Y-%m") = '2022-11';

-- (3)Write a SQL query to calculate the total sales (total_sale) for each category.:
select 
	category, 
    sum(total_sale) 
from retail_sales
group by category;

-- (4)Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
select 
	round(avg(age),2) as cx_acg_age 
from retail_sales 
where category = 'beauty';

-- (5)Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select * 
from retail_sales 
where total_sale > 1000;

-- (6)Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
select
	category, 
    gender, 
    count(*) as ttl_transactions 
from retail_sales 
group by category, gender;

-- (7)Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
select year, month, ttl_sale
from (
select
	year(sale_date) as year,
    month(sale_date) as month,
    round(avg(total_sale),2) as ttl_Sale,
    rank() over(partition by year(sale_Date) order by avg(total_sale) desc) as rn
from retail_sales
group by year(sale_Date), month(sale_date)) rn1
where rn =1;

-- (8)**Write a SQL query to find the top 5 customers based on the highest total sales **:
select
	customer_id,
    sum(total_sale) as ttl_sale from retail_Sales
group by customer_id
order by ttl_sale desc
limit 5;

-- (9)Write a SQL query to find the number of unique customers who purchased items from each category.:
select 
	category, 
    count(distinct customer_id) as ttl_unq_cs 
from retail_sales
group by category;

-- (10)Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
select
	case
		when hour(sale_time) < 12 then 'morning'
        when hour(sale_time) between 12 and 17 then 'afternoon'
        else 'evening' end as shift,
        count(*) as no_of_orders
from retail_sales
group by shift;
