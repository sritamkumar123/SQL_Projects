-- Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category, sum(order_details.quantity) as Total_quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by Total_quantity desc;

-- Determine the distribution of orders by hour of the day.

SELECT hour(order_time) as hours, count(order_id) as order_count from pizzahut.orders
group by hours  order by order_count desc;

-- Join relevant tables to find the category-wise distribution of pizzas.

select category , count(name) as name_count from pizza_types
group by category order by name_count desc ;

-- Group the orders by date and calculate the average number of pizzas ordered per day.


select round(avg(total_quantity),0) from 
(select orders.order_date , sum(order_details.quantity) as total_quantity
from orders join order_details
on orders.order_id = order_details.order_id
group by orders.order_date) as order_quantity;

-- Determine the top 3 most ordered pizza types based on revenue.

select pizza_types.name, sum(order_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by revenue desc limit 3;


