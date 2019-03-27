USE sakila;
-- Display the first and last names of all actors from the table actor.
select first_name, last_name from actor;
-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select upper(concat(first_name," ", last_name))as `Actor Name`
from actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
select actor_id, first_name, last_name 
from actor where first_name = "Joe";
-- 2b. Find all actors whose last name contain the letters GEN:
select * from actor 
where last_name like '%GEN%';
-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select last_name, first_name from actor 
where last_name like '%LI%' order by last_name;
-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country 
from country where country in ('Afghanistan', 'Bangladesh', 'China');
-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
-- so create a column in the table actor named description and use the data type BLOB.
alter table actor add column description 
BLOB after last_update;
select * from actor;
-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
alter table actor drop column description;
select * from actor;
-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(*) as 'Last Name Count'
from actor group by last_name;
-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(last_name) as 'Last Name Count'
from actor group by last_name having count(last_name)> 1;
-- 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
SET SQL_SAFE_UPDATES = 0;
update actor set first_name= "HARPO" where first_name= "Groucho";
select * from actor where last_name = "Williams";
-- * 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
update actor set first_name= "Groucho" where first_name= "harpo";
select * from actor where last_name = "Williams";
-- * 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
show create table address;
select * from address;
-- * 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
select * from address inner join staff using (address_id);
-- * 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
select sum(amount) as "sum", first_name, last_name from payment 
inner join staff using (staff_id) where payment_date like "2005-08%";
-- * 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
select count(film_id) as "actor count" , title from film 
inner join film_actor using(film_id) group by title;
-- * 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
select count(film_id) from film inner join inventory
using (film_id) where title = "Hunchback Impossible";
-- * 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
select sum(amount), last_name from payment
 inner join customer using(customer_id) group by last_name;
 -- * 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
 select title from film where title like"k%" or title like "Q%"and language_id in (
 select language_id from language where name ="English");
 -- * 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
 select first_name,last_name from actor where actor_id in(
 select actor_id from film_actor where film_id in(
 select film_id from film where title= "Alone Trip"));
 -- * 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
 select first_name, last_name,email from customer inner join address using (address_id) 
 inner join city using (city_id) inner join country using (country_id) 
 where country = "Canada";
 -- * 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.
select title from film where film_id in(
select film_id from film_category where category_id in (
select category_id from category where name= "family"));
-- * 7e. Display the most frequently rented movies in descending order.
select title, count(rental_id) from rental
inner join inventory using(inventory_id)
inner join film using (film_id)
group by title
order by count(rental_id) desc;
-- * 7f. Write a query to display how much business, in dollars, each store brought in.
select store_id, sum(amount) from payment
inner join rental using (rental_id)
inner join inventory using (inventory_id)
inner join store using (store_id)
group by store_id;
-- * 7g. Write a query to display for each store its store ID, city, and country.
select store_id, city, country from country
inner join city using (country_id)
inner join address using (city_id)
inner join store using (address_id)
group by store_id;
-- * 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select sum(amount) as "Gross Revenue" , name from category
inner join film_category using (category_id)
inner join inventory using (film_id)
inner join rental using (inventory_id)
inner join payment using (rental_id)
group by name order by sum(amount) desc limit 5;
-- * 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
create view  top_genre_by_gross_revenue as
select sum(amount) as "Gross Revenue" , name from category
inner join film_category using (category_id)
inner join inventory using (film_id)
inner join rental using (inventory_id)
inner join payment using (rental_id)
group by name order by sum(amount) desc limit 5;
-- * 8b. How would you display the view that you created in 8a?
select * from top_genre_by_gross_revenue;
-- * 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
drop view top_genre_by_gross_revenue;












 



