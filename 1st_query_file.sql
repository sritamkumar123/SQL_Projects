-- Retrieve the total number of orders placed.

select count(order_id) as Total_orders from orders; 

-- Calculate the total revenue generated from pizza sales.

select round(sum(order_details.quantity * pizzas.price),2) as Total_Sales
from order_details join pizzas
on pizzas.pizza_id = order_details.pizza_id;


-- Identify the highest-priced pizza.

select pizza_types.name, pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id= pizzas.pizza_type_id
order by pizzas.price desc limit 1;


-- Identify the most common pizza size ordered.
select pizzas.size, count(order_details.order_details_id) as Total_Order_Count
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size order by Total_Order_Count desc;

-- List the top 5 most ordered pizza types along with their quantities.
select pizza_types.name, sum(order_details.quantity) as total_quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by total_quantity desc
limit 5;

