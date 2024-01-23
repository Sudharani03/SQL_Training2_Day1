select * from authors;

create procedure Proc_GetAllAuthors
as
select * from authors

exec Proc_GetAllAuthors

create proc proc_GetAuthorFromGivenState(@statename varchar(5))
as
Select * from authors where state=@statename

exec proc_GetAuthorFromGivenState 'CA'

alter proc proc_GetAuthorFromGivenState(@statename varchar(5))
as
begin 
declare @authorcount int
set @authorcount = (select count(*) from authors where state=@statename)
if (@authorcount = 0)
	select 'No Authors from given state'
else
	select * from authors where state=@statename

end

exec proc_GetAuthorFromGivenState 'CA'

exec proc_GetAuthorFromGivenState 'FA'

--create a proc that will take min and max price and fetch all the books in given price range
select * from titles


create procedure Proc_GetBooksWithinPriceRange(@minPrice float ,@maxPrice float)
as
begin
	declare @booksCount int
	set @booksCount = (select count(*) from titles where price between @minPrice and @maxPrice)
	if (@booksCount = 0)
		select 'No books are found within given range'
	else
		select * from titles where price between @minPrice and @maxPrice
end 

exec Proc_GetBooksWithinPriceRange 8,15

--create a stored proc that ll print the number of books for every publisher 
select * from publishers
select * from titles

create procedure Proc_GetNoOfBooksOfEveryPublishers
as
begin 
	select publishers.pub_id , publishers.pub_name , count(titles.title) as noOfBooksPuublished from 
	publishers join titles 
	on
	publishers.pub_id = titles.pub_id
	group by publishers.pub_id,publishers.pub_name 
end 

exec Proc_GetNoOfBooksOfEveryPublishers
----
create proc proc_CountBookForEveyPublisher
as
  select pub_id,count(title_id) 'Number of books published' from titles group by pub_id

  exec proc_CountBookForEveyPublisher

--create a procedure that will print the number of books for every publisher only if published more than 5 books

create procedure proc_CountBookForEveyPublisherWithMin(@min int)
as 
begin
	select pub_id,count(title_id) 'Number of books published' from titles group by pub_id having count(title_id) > @min
end

exec proc_CountBookForEveyPublisherWithMin 5

--Create a  procedure that takes a min number and fetches the count of books that are 
--priced higher than the given min for every pulisher
--Only if theyhave published more than 2 books
--in desending order of count

create procedure proc_GetPublishersCountAccToPrice(@minPrice float)
as 
begin
	select pub_id,count(title_id) as BOOKCOUNT from titles where price>@minPrice
	group by pub_id
	having count(title_id) > 2
	order by BOOKCOUNT desc
end

alter procedure proc_GetPublishersCountAccToPrice(@minPrice float)
as 
begin
	select pub_id,count(title_id) as PUBLISHEDBOOKCOUNT from titles where price>@minPrice
	group by pub_id
	having count(title_id) > 2
	order by PUBLISHEDBOOKCOUNT desc
end

exec proc_GetPublishersCountAccToPrice 1

--Create a stored procedure that takes skill name , skill description , employee id , skill level and inserts that data into skills table 
--and employeeskills table 

use dbCompany17Jan2024

create proc proc_InsertSkillAndEmployeeSkill
(@sname varchar(50),@sdescription varchar(1000),@eid int,@slevel float)
as
begin
declare 
	 @scount int,
	@ecount int
	set @scount = (Select count(*) from skills where skillname = @sname)
	if(@scount=0)
		insert into skills values(@sname,@sdescription)
	else
		select 'Skill already present'
	set @ecount = (Select count(*) from employees where id = @eid)
	if(@ecount >0)
		insert into employeeSkills values(@eid,@sname,@slevel)
	else
		select 'No such Employee'
end

select * from EmployeeSkills
select * from Skills

exec proc_InsertSkillAndEmployeeSkill 'Java', 'Web', 104,6
