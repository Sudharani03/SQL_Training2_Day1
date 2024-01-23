Create table Employee (id int Primary key not null ,
Name varchar(50) not null,
Area varchar(50) not null);

Create table EmployeeSkill (id int not null ,
Skill varchar(50) not null,
SkillLevel varchar(50) not null,
primary key(id,Skill));

Create table Skills (Skill varchar(50) not null ,
SkillDescription varchar(50) not null);

Create table EmployeeArea (Area varchar(50) ,
ZipCode int);

Insert into Employee values(101,'Ramu','abc');

Create database dbCompany17Jan2024

use dbCompany17Jan2024

create table Areas
(area varchar(50) primary key,
zipcode char(6))

create table Employees
(id int identity(101,1) constraint pk_employeeId primary key,
name varchar(50),
employee_area varchar(50) constraint fk_employee_area foreign key references Areas(area))

create table Skills
(Skillname varchar(50) primary key,
SkillDescription varchar(1000))

create table EmployeeSkills
(EmployeeId int foreign key references Employees(id),
Skill varchar(50) references Skills(SkillName),
SkillLevel float default 1 check (SkillLevel between 1 and 10),
primary key(EmployeeId,Skill))

INSERT INTO Areas (area, zipcode) VALUES 
('Delhi', 14011), 
('Noida', 14012);

INSERT INTO Employees (name, employee_area) VALUES 
( 'Ramu', 'Delhi'),
( 'Raja', 'Noida');

INSERT INTO Skills (Skillname, skilldescription) VALUES 
('C#', '.NET'),
('C++', 'Basics of C++');

INSERT INTO EmployeeSkills (EmployeeId, skill, skilllevel) VALUES 
(101, 'C++', 7)

select * from EmployeeSkills
select * from Skills;
select * from Employees;
select * from Areas;