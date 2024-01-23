
----stored procedure which returns a value------------
create proc proc_GetAuthorFullnamebyId(@authid char(11),@authname varchar(100) out)
as
  set @authname = (select concat(au_fname,' ',au_lname) 'Author Name' from authors where au_id = @authid)

declare 
  @aname varchar(100)
begin
  exec proc_GetAuthorFullnamebyId '172-32-1176', @aname out
  print @aname
end
----------------------joins-----------------

--cross join - used for probability (gives all possible combinations)

select * from publishers cross join stores
--Left outer join --(all records from left side table + matching records from ryt side table) lly we have ryt outer join

select pub_name,title from publishers left outer join titles
on publishers.pub_id = titles.pub_id

-- if we want all recirds from both tables without any matching use full outer join 

select pub_name,title from publishers full outer join titles
on publishers.pub_id = titles.pub_id

--order to be followed while writing a join query with condition where clause 


select pub_name, count(title) No_of_Books from publishers left outer join titles
on publishers.pub_id = titles.pub_id
where type in ('business','psychology')
group by pub_name
having count(title)>2
order by count(title) desc

------------------------Functions-------------------

create function fn_sample()
returns varchar(15)
as
begin
  return 'Hello World';
end
--execution of function - using select keyword we execyute the function

select dbo.fn_sample()

----function that calculates price 

create function function_CalculatingPrice(@price float,@qty int)
returns float
as
begin 
declare @totalPrice float
	set @totalPrice = @price*@qty
	set @totalPrice = @totalPrice+(@totalPrice*12.36/100)
	return @totalPrice
end

select dbo.function_CalculatingPrice(12.25,100)

--Using the above function to calculate price of all books 

select title, sum(dbo.function_CalculatingPrice(t.price,s.qty)) 'total price '
from titles t inner join sales s
on t.title_id = s.title_id
group by title
order by 1

--create a function that can be used to calculate the royalty to be paid for every book (royalty% in title table)
--USe the function to print the total royalty for everybook

create function func_CalculatingRoyalityPercentage(@Price float , @qty int , @RoyalityPercentage int)
returns float
as
begin 
	declare @Royality float
	set @Royality = (@price * @qty * @RoyalityPercentage)
	set @Royality = @TotalRoyality+(@Royality/100)
	return @Royality
end

select title, sum(dbo.func_CalculatingRoyalityPercentage(t.price,s.qty,t.royalty)) 'total Royality '
from titles t inner join sales s
on t.title_id = s.title_id
group by title
order by 1 

select * from titles

create function CalculateRoyalty(@price DECIMAL(10, 2), @royaltyPercentage DECIMAL(5, 2))
returns DECIMAL(10, 2) 
as 
begin
DECLARE @royaltyamount DECIMAL(10, 2);
	SET @royaltyamount = @price * @royaltyPercentage / 100; 
	return @royaltyamount; 
end; 

select title,price,royalty, dbo.CalculateRoyalty(price, royalty) as TotalRoyalty from titles


-----------------Triggers

--create trigger on particular table 

create table tbl1(f1 int,f2 varchar(10))

create or alter trigger trg_Insert
on tbl1
for insert
as
begin
  declare @name varchar(10)
  set @name = (select f2 from inserted)
  print concat('hello ',@name)
end

insert into tbl1 values(3,'ABC')

--------------------------------------------------------------------------------

select * from sales where ord_num = '6899'

create or alter trigger trg_InsertOrder
on sales
instead of insert
as
begin
    declare @myqty int
	set @myqty = (select qty from inserted)
	if(@myqty<0)
		set @myqty = 0-@myqty
	INSERT INTO [dbo].[sales]
           ([stor_id]
           ,[ord_num]
           ,[ord_date]
           ,[qty]
           ,[payterms]
           ,[title_id])
     VALUES
           ((select stor_id from inserted)
           ,(select ord_num from inserted)
           ,SYSDATETIME()
           ,@myqty
           ,(select payterms from inserted)
           ,(select title_id from inserted))
end

INSERT INTO [dbo].[sales]
           ([stor_id]
           ,[ord_num]
           ,[ord_date]
           ,[qty]
           ,[payterms]
           ,[title_id])
     VALUES
           ('6380'
           ,'6899'
           ,SYSDATETIME()
           ,-3
           ,'ON invoice'
           ,'BU1032')


------------------triggers ex 3

select * from Employees

create trigger trg_EmployeeInsert
on Employees
instead of insert
as
begin
   declare @area varchar(20),@name varchar(20)
   set @area = (select employee_area from inserted)
   set @name = (select name from inserted)
   if((select count(*) from areas where area = @area)>0)
	  insert into Employees(name,employee_area) values(@name,@area)
   else
      print 'Invalid area'
end

insert into Employees(name,employee_area) values('Komu','hsfd')