create database pizza_insights;
use pizza_insights;

-- creating table orders and importing data into it 
create table orders (
order_id int primary key,
order_date date not null,
order_time time not null
);
select*from orders;



-- preview tables
select * from pizzas;
select * from order_details;
select * from pizza_types;


-- 1) total number of orders placed.
select count(*) as Total_orders 
from orders;


-- 2) total revenue generated from pizza sales.

select round(sum(p.price*od.quantity),2) as total_revenue
from 
order_details od
join 
pizzas p
on od.pizza_id = p.pizza_id;


-- 3)highest-priced pizza.

SELECT * FROM pizzas
WHERE price = (SELECT MAX(price) FROM pizzas);

-- 4)Most expensive pizza by size

SELECT pizza_id, pizza_type_id, size, price
FROM (
    SELECT *, RANK() OVER ( PARTITION BY size ORDER BY price DESC) AS rnk
    FROM pizzas
) AS rank_pizza
WHERE rnk = 1;


-- 5) category wise distribution of pizzas
select category, count(name) from
pizza_types
group by category
order by category desc;



-- 6)most common pizza size ordered.

SELECT 
    p.size, COUNT(*) AS ordered_count
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY ordered_count DESC
LIMIT 1;


-- 7)List the top 5 most ordered pizzas along with their quantities

select pt.name, sum(od.quantity) as quantity_ordered
from pizzas p
join order_details od
on p.pizza_id = od.pizza_id
join pizza_types pt
on p.pizza_type_id = pt.pizza_type_id
group by pt.name
order by quantity_ordered desc
limit 5;




-- 8)top 5 most ordered pizza by the categories along with quantity ordered

select pt.category, sum(od.quantity) as quantity_ordered
from pizzas p
join order_details od
on p.pizza_id = od.pizza_id
join pizza_types pt
on p.pizza_type_id = pt.pizza_type_id
group by pt.category
order by quantity_ordered desc
limit 5;


-- 9)Determine the distribution of orders by hour of the day.
select hour(order_time) as time_in_hours, count(order_id) as order_quantity
from orders
group by time_in_hours;

-- 10) Group the orders by date and calculate the average number of pizzas ordered per day.

select round(avg(quantity),0) as average_orders_per_day from 
	(select o.order_date, sum(od.quantity) as quantity
	from
	order_details od
	join orders o
	on od.order_id = o.order_id
	group by o.order_date) as ordered_quantity;
 
 
-- 11)  top 3 most ordered pizzas by revenue

select pt.name, sum(od.quantity*p.price) as revenue
from pizza_types pt
join pizzas p
on pt.pizza_type_id = p.pizza_type_id
join order_details od
on od.pizza_id = p.pizza_id
group by pt.name
order by revenue desc
limit 3;


-- 12) top 5 least sold pizzas
SELECT pt.name, SUM(od.quantity) AS total_quantity_sold
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY total_quantity_sold ASC
LIMIT 5;


 -- 13) top 3 busiest days 
 SELECT DAYNAME(order_date) AS day_of_week, COUNT(order_id) AS total_orders
FROM orders
GROUP BY day_of_week
ORDER BY total_orders DESC
LIMIT 3;

-- 14) top 5 largest bills 

SELECT od.order_id, ROUND(SUM(p.price * od.quantity), 2) AS total_bill
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY od.order_id
ORDER BY total_bill DESC
LIMIT 5;

-- 15) Average number of pizzas orderd per order
SELECT ROUND(AVG(total_pizzas), 0) AS avg_pizzas_per_order
FROM (
    SELECT order_id, SUM(quantity) AS total_pizzas
    FROM order_details
    GROUP BY order_id
) AS order_summary;





