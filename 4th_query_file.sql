-- self join 

select e1.product_category, e2.product_id , e1.product_name_length as length
 from ecommerce.products e1,  ecommerce.products e2 
 where e1.product_id = e2.product_id;
 
 -- join statements 
 
 with CTE as (select products.product_category , 
 round(sum(payment.payment_value),3) as sales 
 from products join order_items
 on products.product_id = order_items.product_id
 join payment 
 on payment.order_id = order_items.order_id
 group by  product_category
 order by sales desc)
 
 select product_category, sales from CTE
 order by sales desc limit 1;
 
 
 -- case statements 
  
  with CTE as (select products.product_category , 
 round(sum(payment.payment_value),3) as sales 
 from products join order_items
 on products.product_id = order_items.product_id
 join payment 
 on payment.order_id = order_items.order_id
 group by  product_category
 order by sales desc)
 
 select *, case 
 when sales < 5000 then 'low'
 when sales > 100000 then 'high'
 else 'medium'
 end as sale_type
 from CTE;
 
 -- window functions 

select order_date, 
sum(sales) over(order by order_date) from
(select Date(orders.order_purchase_timestamp) as order_date,
sum(payment.payment_value) as sales 
from orders join payment
on orders.order_id = payment.order_id
 group by order_date)
 as sub_query;
 
 -- comex CTE 
 
 with CTE1 as (select products.product_category , 
 round(sum(payment.payment_value),3) as sales 
 from products join order_items
 on products.product_id = order_items.product_id
 join payment 
 on payment.order_id = order_items.order_id
 group by  product_category),
 
 CTE2 as (select product_category ,sales,  rank() over(order by sales desc) as rk from CTE1)
 
 select product_category, sales, rk from CTE2
 where rk <= 3;
 
 
 

 