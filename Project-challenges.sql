-- Task: Create a list of all the different (distinct) replacement costs of the films.
-- Question: What's the lowest replacement cost?

select distinct replacement_cost
from public.film
order by replacement_cost;


-- Task: Write a query that gives an overview of how many films have replacements costs in the following cost ranges
-- low: 9.99 - 19.99
-- medium: 20.00 - 24.99
-- high: 25.00 - 29.99
-- Question: How many films have a replacement cost in the "low" group?

select 
case
	when replacement_cost between 9.99 and 19.99 then 'low'
	when replacement_cost between 20.00 and 24.99 then 'medium'
	when replacement_cost between 25.00 and 29.99 then 'high'
end as Category,count(*)
from public.film
group by Category
;


-- 
-- Task: Create a list of the film titles including their title, length, and category name ordered descendingly by length. Filter the results to only the movies in the category 'Drama' or 'Sports'.

-- Question: In which category is the longest film and how long is it?
select *
from public.category
	;
select title,length,name
from public.film as f1
join  public.film_category as f2
	on f1.film_id = f2.film_id
join public.category as f3
	on f2.category_id = f3.category_id
where name = 'Drama' or name = 'Sports'
order by length desc;


-- Task: Create an overview of how many movies (titles) there are in each category (name).
-- Question: Which category (name) is the most common among the films?

select name,count(*)
from public.film as f1
join public.film_category as f2
	on f1.film_id = f2.film_id
join public.category as f3
	on f2.category_id = f3.category_id
group by name
	order by count(*) desc;


-- Task: Create an overview of the actors' first and last names and in how many movies they appear in.
-- Question: Which actor is part of most movies??
select *
from public.actor;

select first_name,last_name,count(*)
from public.actor as a
join public.film_actor as a1
	on a.actor_id = a1.actor_id
join public.film as a2
	on a1.film_id = a2.film_id
group by first_name,last_name
order by count(*) desc;


-- Task: Create an overview of the addresses that are not associated to any customer.

-- Question: How many addresses are that?
select *
from public.address;

select *
from public.customer
where last_name is null;


select a2.address_id,count(*)
from public.address as a
left join public.customer as a2
	on a.address_id = a2.address_id
group by a2.address_id
order by count(*) desc
;


-- Task: Create the overview of the sales  to determine the from which city (we are interested in the city in which the customer lives, not where the store is) most sales occur.

-- Question: What city is that and how much is the amount?
select city,sum(amount)
from public.city as c1
join public.address as c2
	on c1.city_id = c2.city_id
join public.customer as c3
	on c2.address_id = c3.address_id
join public.payment as c4
	on c3.customer_id = c4.customer_id
group by city
order by sum(amount) desc;


-- Task: Create an overview of the revenue (sum of amount) grouped by a column in the format "country, city".

-- Question: Which country, city has the least sales?
select country,city,sum(amount)
from public.country as c
join public.city as c1
	on c.country_id = c1.country_id
join public.address as c2
	on c1.city_id = c2.city_id
join public.customer as c3
	on c2.address_id = c3.address_id
join public.payment as c4
	on c3.customer_id = c4.customer_id
group by country,city
order by sum(amount) asc;


-- Task: Create a list with the average of the sales amount each staff_id has per customer.

-- Question: Which staff_id makes on average more revenue per customer?
select *
from payment;


select staff_id,avg(total_amount)
from (select sum(amount) as total_amount,customer_id,staff_id from payment 
	group by customer_id,staff_id
		) as agg_table
group by staff_id;


-- Task: Create a query that shows average daily revenue of all Sundays.

-- Question: What is the daily average revenue of all Sundays?

select avg(total_amount)
from (select date(payment_date),extract(dow from payment_date),sum(amount) as total_amount
from payment
where extract(dow from payment_date) = 0
group by date(payment_date),extract(dow from payment_date)) as agg_table3
;






-- Task: Create a list of movies - with their length and their replacement cost - that are longer than the average length in each replacement cost group.

-- Question: Which two movies are the shortest on that list and how long are they?
select length,replacement_cost,title
from public.film as e1
where length>(select avg(length) from public.film as e2 where e1.replacement_cost = e2.replacement_cost)
order by length asc
limit 2;


-- Task: Create a list that shows the "average customer lifetime value" grouped by the different districts.

-- Example:
-- If there are two customers in "District 1" where one customer has a total (lifetime) spent of $1000 and the second customer has a total spent of $2000 then the "average customer lifetime spent" in this district is $1500.

-- So, first, you need to calculate the total per customer and then the average of these totals per district.

-- Question: Which district has the highest average customer lifetime value?
select district,avg(total_amount)
from(
select district,c.customer_id,sum(amount) as total_amount
from public.address as a
join public.customer as c
	on a.address_id = c.address_id
join public.payment as p
	on c.customer_id = p.customer_id
group by district,c.customer_id) as agg_table
group by district
order by avg(total_amount) desc;



-- Task: Create a list that shows all payments including the payment_id, amount, and the film category (name) plus the total amount that was made in this category. Order the results ascendingly by the category (name) and as second order criterion by the payment_id ascendingly.

-- Question: What is the total revenue of the category 'Action' and what is the lowest payment_id in that category 'Action'?



select name,payment_id,amount,(select sum(amount) from (select * from payment as p join public.rental as s
	on p.rental_id = s.rental_id
join public.inventory as i
	on s.inventory_id = i.inventory_id
join public.film_category as fc
	on i.film_id = fc.film_id
join public.category as c
	on fc.category_id = c.category_id ) as agg_table1
where agg_table1.name = c.name 	 )
from payment as p
join public.rental as s
	on p.rental_id = s.rental_id
join public.inventory as i
	on s.inventory_id = i.inventory_id
join public.film_category as fc
	on i.film_id = fc.film_id
join public.category as c
	on fc.category_id = c.category_id
group by name,payment_id,amount
order by name asc,payment_id asc;



-- Task: Create a list with the top overall revenue of a film title (sum of amount per title) for each category (name).

-- Question: Which is the top-performing film in the animation category?

select name,title,(select sum(amount) from (select * from public.film as f
join public.film_category as c
	on f.film_id = c.film_id
join public.category as c1
	on c.category_id = c1.category_id
join public.inventory as i
	on c.film_id = i.film_id
join public.rental as r
	on i.inventory_id = r.inventory_id
join public.payment as p
	on r.rental_id = p.rental_id
) as agg_table2
where c1.name = agg_table2.name and f.title = agg_table2.title)
from public.film as f
join public.film_category as c
	on f.film_id = c.film_id
join public.category as c1
	on c.category_id = c1.category_id
join public.inventory as i
	on c.film_id = i.film_id
join public.rental as r
	on i.inventory_id = r.inventory_id
join public.payment as p
	on r.rental_id = p.rental_id
group by name,title
having name = 'Animation'
order by sum(amount) desc;









