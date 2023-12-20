--Anjali Negi
--Case Study 02
--ECOM



create database Ecommerce;
use [Ecommerce];

--creating tables

--customer table

create table customers
(
customer_id int Primary Key identity(1,1),
firstName varchar (20),
lastName varchar(20),
email varchar(50),
address varchar(100)
);


--products table

create table products
(
product_id int Primary Key identity(1,1),
name varchar(30),
description varchar(100),
price decimal (10,2),
stockQuantity int
);


--cart table

create table cart
(
cart_id int Primary Key identity(1,1),
customer_id int Foreign Key (customer_id) references [dbo].[customers] ([customer_id]),
product_id int Foreign Key (product_id) references [dbo].[products] ([product_id]),
quantity int
);


--orders table

create table orders
(
order_id int Primary Key identity(1,1),
customer_id int Foreign Key (customer_id) references [dbo].[customers] ([customer_id]), 
order_date date,
total_price decimal (10,2), 
shipping_address varchar(50)
);


--order item

create table order_items
(
order_item_id int Primary Key identity(1,1),
order_id int Foreign Key (order_id) references [dbo].[orders] ([order_id]),
product_id int Foreign Key (product_id) references [dbo].[products]([product_id]),
quantity int,
item_amount decimal(10,2)
);



--inserting data into tables

--customer table

insert into [dbo].[customers]([firstName],[lastName],[email],[address])
values
('John', 'Doe', 'johndoe@example.com', '123 Main St, City'),
('Jane', 'Smith', 'janesmith@example.com', '456 Elm St, Town'),
('Robert', 'Johnson', 'robert@example.com', '789 Oak St, Village'),
('Sarah', 'Brown', 'sarah@example.com', '101 Pine St, Suburb'),
('David', 'Lee', 'david@example.com', '234 Cedar St, District'),
('Laura', 'Hall', 'laura@example.com', '567 Birch St, County'),
('Michael', 'Davis', 'michael@example.com', '890 Maple St, State'),
('Emma', 'Wilson', 'emma@example.com', '321 Redwood St, Country'),
('William', 'Taylor', 'william@example.com', '432 Spruce St, Province'),
('Olivia', 'Adams', 'olivia@example.com', '765 Fir St, Territory');


--products table

insert into [dbo].[products] ([name],[description],[price],[stockQuantity])
values
('Laptop', 'High-performance laptop', 800.00, 10),
('Smartphone', 'Latest smartphone', 600.00, 15),
('Tablet', 'Portable tablet', 300.00, 20),
('Headphones', 'Noise-canceling', 150.00, 30),
('TV', '4K Smart TV', 900.00, 5),
('Coffee Maker', 'Automatic coffee maker', 50.00, 25),
('Refrigerator', 'Energy-efficient', 700.00, 10),
('Microwave', 'Oven Countertop microwave', 80.00, 15),
('Blender', 'High-speed blender', 70.00, 20),
('Vacuum Cleaner', 'Bagless vacuum cleaner', 120.00, 10);


--cart table

insert into [dbo].[cart]([customer_id],[product_id],[quantity])
values
(5,1,1);
(1, 1, 2),
(1, 3, 1),
(2, 2, 3),
(3, 4, 4),
(3, 5, 2),
(4, 6, 1),
(5, 1, 1),
(6, 10,2),
(6, 9, 3),
(7, 7, 2);


--orders table

insert into [dbo].[orders]([customer_id],[order_date],[total_price])
values
(1, '2023-01-05', 1200.00),
(2, '2023-02-10', 900.00),
(3, '2023-03-15', 300.00),
(4, '2023-04-20', 150.00),
(5, '2023-05-25', 1800.00),
(6, '2023-06-30', 400.00),
(7, '2023-07-05', 700.00),
(8, '2023-08-10', 160.00),
(9, '2023-09-15', 140.00),
(10,'2023-10-20', 1400.00);



--order_items table

insert into [dbo].[order_items] ([order_id],[product_id],[quantity],[item_amount])
values
(1, 1, 2, 1600.00),
(1, 3, 1, 300.00),
(2, 2, 3, 1800.00),
(3, 5, 2, 1800.00),
(4, 4, 4, 600.00),
(4, 6, 1, 50.00),
(5, 1, 1, 800.00),
(5, 2, 2, 1200.00),
(6, 10, 2, 240.00),
(6, 9, 3, 210.00);


select * from [dbo].[customers];
select * from [dbo].[products];
select * from [dbo].[orders];
select * from [dbo].[order_items];
select * from [dbo].[cart];


-- 1. Update refrigerator product price to 800.

update [dbo].[products] set [price]=800 where [name]='Refrigerator';


--2. Remove all cart items for a specific customer

declare @custID int;
set @custID=3;
delete from [dbo].[cart] where [customer_id]=@custID;


--3. Retrieve Products Priced Below $100.

select * from [dbo].[products] where [price]<100;


--4. Find Products with Stock Quantity Greater Than 5.

select * from [dbo].[products] where [stockQuantity]>5;


--5. Retrieve Orders with Total Amount Between $500 and $1000.

select * from [dbo].[orders] where [total_price] between 500 and 1000;


--6. Find Products which name end with letter ‘r’.
select * from  [dbo].[products] where [name] like '%r';


--7. Retrieve Cart Items for Customer 5.
select * from [dbo].[cart] where [customer_id]=5;


--8. Find Customers Who Placed Orders in 2023.

select C.[customer_id],C.[firstName],C.[lastName] from [dbo].[customers] as C
inner join [dbo].[orders] as O on C.[customer_id]=O.[customer_id]
where year(O.[order_date])='2023';


--9. Determine the Minimum Stock Quantity for Each Product Category.

select [product_id],[name], min([stockQuantity]) as min_stock_quantity from [dbo].[products]
group by [product_id],[name];


--10. Calculate the Total Amount Spent by Each Customer.

select C.[customer_id],C.[firstName],C.[lastName],sum(OI.[quantity]*OI.[item_amount]) as total_amount_spent from [dbo].[customers] as C
inner join [dbo].[orders] as O on O.[customer_id]=C.[customer_id]
inner join [dbo].[order_items] as OI on OI.[order_id]=O.[order_id]
group by C.[customer_id],C.[firstName],C.[lastName];

--11. Find the Average Order Amount for Each Customer.
select C.[customer_id],C.[firstName],C.[lastName],avg(O.[total_price]) as average_order_amount from [dbo].[customers] as C
inner join [dbo].[orders] as O on O.[customer_id]=C.[customer_id]
group by C.[customer_id],C.[firstName],C.[lastName];

--12. Count the Number of Orders Placed by Each Customer.
select C.[customer_id],C.[firstName],C.[lastName],count(O.[order_id]) as number_of_orders from [dbo].[customers] as C
inner join [dbo].[orders] as O on O.[customer_id]=C.[customer_id]
inner join [dbo].[order_items] as OI on OI.[order_id]=O.[order_id]
group by C.[customer_id],C.[firstName],C.[lastName];



--13. Find the Maximum Order Amount for Each Customer.
select C.[customer_id],C.[firstName],C.[lastName],max(O.[total_price]) as max_order_amount from [dbo].[customers] as C
inner join [dbo].[orders] as O on O.[customer_id]=C.[customer_id]
group by C.[customer_id],C.[firstName],C.[lastName];

--14. Get Customers Who Placed Orders Totaling Over $1000.
select C.[customer_id],C.[firstName],C.[lastName] from [dbo].[customers] as C
inner join [dbo].[orders] as O on O.[customer_id]=C.[customer_id]
where O.total_price>1000;

--15. Subquery to Find Products Not in the Cart
select [product_id],[name] from [dbo].[products]
where [product_id] not in(select [product_id] from [dbo].[cart]); 

--16. Subquery to Find Customers Who Haven't Placed Orders.
select * from [dbo].[customers]
where [customer_id] not in (select [customer_id] from [dbo].[orders]);


--17. Subquery to Calculate the Percentage of Total Revenue for a Product.


--18. Subquery to Find Products with Low Stock.
select [product_id],[name] from [dbo].[products]
where [stockQuantity]<(select avg([stockQuantity]) from [dbo].[products]);


--19. Subquery to Find Customers Who Placed High-Value Orders.

select C.[customer_id],C.[firstName],C.[lastName] from [dbo].[customers] as C
where C.[customer_id] in (select O.customer_id from [dbo].[orders] as O
where O.[total_price] > (SELECT avg(total_price) from [dbo].[orders]));


