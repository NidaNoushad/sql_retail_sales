-- create table retail_sales(
-- transactions_id INT PRIMARY KEY,
-- sale_date DATE,
-- sale_time TIME,
-- customer_id INT,
-- gender VARCHAR(30),
-- age INT,
-- category VARCHAR(30),
-- quantiy INT,
-- price_per_unit FLOAT,
-- cogs FLOAT,
-- total_sale FLOAT
-- )
SELECT * FROM retail_sales LIMIT 5;
SELECT count(*) FROM retail_sales;
SELECT * FROM retail_sales LIMIT 10;

-- identifying null values (data cleaning)
SELECT * FROM retail_sales
where 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

DELETE FROM retail_sales
where 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- DATA EXPLORATION

-- How many sales we have?
select count(*) as total_sale from retail_sales; 

-- how many UNIQUE customers we have?
select count(DISTINCT customer_id) as customer_id from retail_sales;

-- HOW MANY CATEGORIES WE HAVE?
select count(DISTINCT category) as UNIQUE_CATEGORY from retail_sales;

-- WHCH ARE THE DISTICT CATEGORIES?
SELECT DISTINCT category as CATEGORY_NAME from retail_sales;

-- data analysis & business key problems and answers

-- 1)write a sql query to retrive all columns for sales made on '2022-11-05'
select * from retail_sales where sale_date='2022-11-05';
-- select count(*) from retail_sales where sale_date='2022-11-05';

/*2) retrive all transaction where the category is clothing and the qunatity sold is more 
that 10 in the month of nov-2022 */
select * from retail_sales where category='Clothing' AND quantiy>3 AND TO_CHAR(sale_date,'YYYY-MM')='2022-11';

-- 3)Calculate total sales for each category
select category, sum(total_sale) as total_sales, COUNT(*) AS number_of_order from retail_sales
GROUP BY category
ORDER BY category DESC;

-- 4)average age of customers who purchase items from the 'beauty ' categorty
select * from retail_sales limit 2;
select ROUND(avg(age),2) AS avg_age from retail_sales where category='Beauty' ;

-- 5) all transaction where the total sale is greater than 1000
select * from retail_sales where total_sale>1000;

-- 6)total number of transactions(transaction_id) made by each gender in each category
select category,gender,count(*) as number_of_transaction from retail_sales GROUP BY gender,category
ORDER BY count(*) DESC;

-- 7)calculate the avg sale for each month.find the best selling month in each year
select * from retail_sales limit 3;
select years,months,avg_sales from (
  select
	EXTRACT(YEAR from sale_date) as years,
	EXTRACT(MONTH from sale_date) as months,
	ROUND(AVG(total_sale)::NUMERIC, 2) AS avg_sales,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY ROUND(AVG(total_sale)::NUMERIC, 2) DESC) as rank
from retail_sales
GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)) as t1 where rank=1;
-- ORDER BY years DESC,avg_sales DESC

-- 8)find the top 5 customer based on the highest total sales
select customer_id,sum(total_sale) as total from retail_sales group by 1 ORDER BY 2 DESC limit 5;

-- 9)find the number of unique customer who purchased items from each category
select category,count(DISTINCT customer_id) as number_0f_UNIQUEcustomers from retail_sales group by 1;

-- 10)CREATE EACH SHIFT AND NUMBER OF ORDERS(EXAMPLE MORNING <=12,AFTERNOON BETWEEN 12 & 17,EVENING>17)
WITH hourly_sale 
AS
(
SELECT *,
CASE
WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17  THEN 'AfterNoon'
ELSE 'Evening'
END AS shift
FROM retail_sales)
SELECT shift,count(*) FROM hourly_sale group by shift;






	
