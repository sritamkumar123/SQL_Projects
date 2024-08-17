-- Calculate the percentage contribution of each pizza type to total revenue.

select pizza_types.category, round((sum(order_details.quantity * pizzas.price) /(select sum(order_details.quantity * pizzas.price) as total_revenue from 
order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id)) * 100,3) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by revenue desc ;

-- Analyze the cumulative revenue generated over time.

select sales.order_date, 
ROUND(sum(sales.revenue) over ( order by sales.order_date),2) as cum_revenue
from
(select orders.order_date, 
sum(order_details.quantity * pizzas.price) as revenue
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id
join orders
on orders.order_id = order_details.order_id
group by orders.order_date) as sales;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.


select name, revenue, category, rn from

(select cat_revenue.category, cat_revenue.name, cat_revenue.revenue,
rank() over(partition by category order by revenue desc) as rn

from

(select pizza_types.category, pizza_types.name,
sum(order_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details 
on order_details.pizza_id= pizzas.pizza_id
group by pizza_types.category, pizza_types.name) as cat_revenue) as forTop3
where rn <= 3;


