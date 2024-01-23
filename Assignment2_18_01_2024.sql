--========================================================================
--ASSIGNMENT 2------------------------------------------------------------
--========================================================================
select * from authors
---1) Print all the author details sorted by their lastname in descending order then by firstname in ascending order

select * from authors 
order by au_lname desc , au_fname asc

----2) Print the number of books by every author(id)

select a.au_lname +a.au_fname 'Author Name',count(ta.title_id)  'Number Of Books'
from authors a join titleauthor ta 
on a.au_id = ta.au_id
group by a.au_lname +a.au_fname

----3) print the number of author for every book(id)

select t.title 'Book',count(ta.au_id)  'NumberOfAuthors'
from titleauthor ta
join titles t on ta.title_id = t.title_id
group by  t.title

----4) print the highest priced book by every publisher id
select * from titles
select * from publishers

select p.pub_id 'Publisher ID',p.pub_name 'Publisher Name',t.title 'Book Title',t.price 'Book Price'
from titles t join publishers p 
on t.pub_id = p.pub_id
where t.price is not null
and t.price = (select max(price) from titles where pub_id = t.pub_id)

----5) print the first 5 heighest quantity sales

select * from sales 
select * from titles

select top 5 t.title 'Books' , s.qty 'Quantity' 
from sales s join titles t 
on s.title_id = t.title_id
order by s.qty desc

----6) print the books that are priced not more than 25 not less than 10

select title 'Books' , price 'Price' from titles 
where price between 10 and 25
order by price

----7) Print the books that are price higher than the books that are of type 'cook'

select title 'Books',price 'Price',type 'Type'
from titles t1
where price > (select max(price) from titles where type in ('mod_cook', 'trad_cook'))

----8) print the books that have 'e' and 'a' in their name

select title 'Books' from titles 
where title like '%e%' and title like '%a%' 

----9) print the number  and the sum of their price of books that have been published by authors from 'CA'

select count(t.title_id)  'Number Of Books',sum(t.price) 'Total Price'
from titles t join titleauthor ta 
on t.title_id = ta.title_id
join authors a on ta.au_id = a.au_id
where a.state = 'CA'

----10) print the publisher name and the average of books published

select p.pub_name PublisherName,avg(t.price) AverageBookPrice
from publishers p join titles t 
on p.pub_id = t.pub_id
group by p.pub_name

----11) Create a procedure that takes the title id and prints the total amount of sale for it
select * from sales

create procedure proc_GetTotalSalesById(@TitleId varchar(50))
as
begin
	select sum(s.qty*t.price) 'Total Sales' 
	from sales s , titles t
	where s.title_id = t.title_id and t.title_id = @TitleId
end

exec proc_GetTotalSalesById 'TC7777'

----12) Create a function that takes the author last name and print his last name and the book name authored

create function  func_GetAuthorandWorks(@LastName varchar(100))
returns table
as
	return (select au_lname,title from authors a join titleauthor ta 
			on a.au_id = ta.au_id
			join titles t on ta.title_id = t.title_id
			where a.au_lname = @LastName)


select * from dbo.func_GetAuthorandWorks('Blotchet-Halls')


----13) Create a procedure that will take the price and prints the count of book that are priced less than that

create procedure proc_GetAllBooksLessThanPrice(@price decimal(10, 2))
as
begin 
	select count(*) 'Book Count' from titles where price<@price
end

exec proc_GetAllBooksLessThanPrice 20.00

----14) Find a way to ensure that the price of books are not updated if the price is below 7

create procedure proc_UpdateBookPrice(@yourTitleId varchar(10),@newPrice DECIMAL(10, 2))
as
begin
    begin transaction

    if(select price from titles where title_id = @yourTitleId) >= 7
    begin
        update titles
        set price = @newPrice
        where title_id = @yourTitleId

        commit
        print 'Update successful';
    end
    else
    begin
        rollback
        print 'Update failed. Price must be 7 or higher.';
    end
end

exec proc_UpdateBookPrice 'MC3021', '10.99'

----15) Create a set of queries that will take the insert for sale but of the price is greater than 40 then the insert should not happen

create procedure InsertSale (@stor_id int,@ord_num int,@ord_date date,@qty int,@payterms varchar(50),@title_id varchar(10))
as
begin
    begin transaction

    if (select price from titles where title_id = @title_id) <= 1
    begin
        insert into sales (stor_id, ord_num, ord_date, qty, payterms, title_id)
        values (@stor_id, @ord_num, @ord_date, @qty, @payterms, @title_id);

        commit
        print 'Insert successful';
    end
    else
    begin
        rollback
        print 'Insert failed. Price must be 40 or lower.';
    end
end

exec InsertSale 7066, 1003, '2022-01-01', 5, 'Net 30', 'BU1032';