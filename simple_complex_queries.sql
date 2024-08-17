
# top 10 highest revenue product

select product_id,round(sum(sale_price),3) as sales from order_data.order_details
group by product_id
order by sales desc limit 10;

# top 5 highest selling product in each region  or any specific region

select sum(sale_price) as sales, region , product_id from order_data.order_details
group by product_id,region
having region = 'East'
order by sales desc limit 10;

--  advance query 

with CTE as 
(select sum(sale_price) as sales, region , product_id from order_data.order_details
group by product_id,region
order by sales desc limit 10)
select * from (
select *, rank() over(partition by region order by sales desc) as rn
from CTE) A
where rn<=5;

-- find month over month growth comparison for 2022 and 2023 sales eg: jan 2022 vs jan 2023

with CTE as 
(select year(order_date) as order_year, month(order_date) as order_month,round(sum(sale_price),3) as sales
from order_data.order_details
group by order_year, order_month
order by order_year desc, order_month desc)
select order_month,
sum(case when order_year= 2022 then sales else 0 end) as order_year_2022,
sum(case when order_year= 2023  then sales else 0 end) as order_year_2023
from CTE
group by order_month
having order_month=1;

-- for each category for which month had highest sales 

with CTE as (select round(sum(sale_price),3) as sales, category, DATE_FORMAT(STR_TO_DATE(order_date, '%Y-%m-%d'), '%Y%m') AS formatted_order_date
from order_data.order_details
group by category, formatted_order_date
order by sales desc)

 select * from (select  * , rank() over(partition by category order by sales desc) as rn
from CTE ) as a
where rn=1;

-- which sub category had highest growth by profit in 2023 compared to 2022

with CTE as (SELECT 
    sub_category,
    ROUND(SUM(sale_price), 3) AS sales,
    year(order_date)as order_year
FROM 
    order_data.order_details
GROUP BY 
    sub_category, order_year),
 CTE2  as (select sub_category ,
sum(case when order_year = 2023 then sales else 0 end) as sales_2023,
sum(case when order_year=2022 then sales else 0 end) as sales_2022
from CTE
group by sub_category)

select *, 
round((sales_2023 - sales_2022)/sales_2022 *100,3) as grow_percent,
round((sales_2023-sales_2022),3)as growth 
from CTE2
-- order by grow_percent desc
order by growth desc
limit 1;
