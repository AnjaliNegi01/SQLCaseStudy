--Anjali Negi
--Case Study :04

CREATE DATABASE Car1;
USE [Car1];

--Creating table Vehicle
CREATE TABLE Vehicle
(
vehicleID INT Primary Key IDENTITY(1,1),
make VARCHAR (20),
model VARCHAR(20),
year INT ,
dailyRate DECIMAL(10,2),
status CHAR(1),
passengerCapacity INT,
engineCapacity INT
);

--Creating Customer table
CREATE TABLE Customer
(
customerID INT Primary Key IDENTITY (1,1),
firstName VARCHAR(20),
lastName VARCHAR(20),
email VARCHAR(50),
phoneNumber CHAR(10)
);

--creating lease table
CREATE TABLE Lease
(
leaseID INT Primary Key IDENTITY(1,1),
vehicleID INT Foreign Key (vehicleID) references [dbo].[Vehicle] ([vehicleID]),
customerID INT Foreign Key (customerID) references [dbo].[Customer] ([customerID]),
startDate DATE,
endDate DATE,
type VARCHAR(20)
);

--Creating Payment table
CREATE TABLE Payment
(
paymentID INT Primary Key IDENTITY(1,1),
leaseID INT Foreign Key (leaseID) references [dbo].[Lease] ([leaseID]),
paymentDate DATE,
amount DECIMAL(10,2)
);

--inserting data into tables
--vehicle
INSERT INTO [dbo].[Vehicle]([make],[model],[year],[dailyRate],[status],[passengerCapacity],[engineCapacity])
VALUES
('Toyota', 'Camry', 2022, 50.00, 1, 4, 1450),
('Honda', 'Civic', 2023, 45.00, 1, 7, 1500),
('Ford', 'Focus', 2022, 48.00, 0, 4, 1400),
('Nissan', 'Altima', 2023, 52.00, 1, 7, 1200),
('Chevrolet', 'Malibu', 2022, 47.00, 1, 4, 1800),
('Hyundai', 'Sonata', 2023, 49.00, 0, 7, 1400),
('BMW' ,'3 Series', 2023, 60.00, 1, 7, 2499),
('Mercedes', 'C-Class', 2022, 58.00, 1, 8, 2599),
('Audi', 'A4', 2022, 55.00, 0, 4, 2500),
('Lexus', 'ES', 2023, 54.00, 1, 4, 2500);



INSERT INTO [dbo].[Customer]([firstName],[lastName],[email],[phoneNumber])
VALUES
('John', 'Doe', 'johndoe@example.com', '5555555555'),
('Jane', 'Smith', 'janesmith@example.com', '5551234567'),
('Robert', 'Johnson', 'robert@example.com', '5557891234'),
('Sarah', 'Brown', 'sarah@example.com', '5554567890'),
('David', 'Lee', 'david@example.com', '5559876543'),
('Laura', 'Hall', 'laura@example.com', '5552345678'),
('Michael', 'Davis', 'michael@example.com', '5558765432'),
('Emma', 'Wilson', 'emma@example.com', '5554321098'),
('William', 'Taylor', 'william@example.com', '5553216547'),
('Olivia', 'Adams' ,'olivia@example.com', '5557654321');

INSERT INTO [dbo].[Lease]([vehicleID],[customerID],[startDate],[endDate],[type])
VALUES
(1, 1, '2023-01-01', '2023-01-05', 'Daily'),
(2, 2, '2023-02-15', '2023-02-28', 'Monthly'),
(3, 3, '2023-03-10', '2023-03-15', 'Daily'),
(4, 4, '2023-04-20', '2023-04-30', 'Monthly'),
(5, 5, '2023-05-05', '2023-05-10', 'Daily'),
(4, 3, '2023-06-15', '2023-06-30', 'Monthly'),
(7, 7, '2023-07-01', '2023-07-10', 'Daily'),
(8, 8, '2023-08-12', '2023-08-15', 'Monthly'),
(3, 3, '2023-09-07', '2023-09-10', 'Daily'),
(10,10, '2023-10-10', '2023-10-31', 'Monthly');

INSERT INTO [dbo].[Payment]([leaseID],[paymentDate],[amount])
VALUES
(1, '2023-01-03', 200.00),
(2, '2023-02-20' ,1000.00),
(3, '2023-03-12', 75.00),
(4,'2023-04-25', 900.00),
(5, '2023-05-07', 60.00);

INSERT INTO [dbo].[Payment]([leaseID],[paymentDate],[amount])
VALUES
(6, '2023-06-18', 1200.00),
(7, '2023-07-03' ,40.00),
(8, '2023-08-14', 1100.00),
(9,'2023-09-09', 80.00),
(10, '2023-10-25', 1500.00);

SELECT * FROM [dbo].[Vehicle];
--1)
UPDATE [dbo].[Vehicle] SET [dailyRate]=68 WHERE [make]='Mercedes';

--2)
DELETE FROM Payment
WHERE leaseID IN (SELECT leaseID FROM Lease WHERE customerID = 5);
DELETE FROM Lease
WHERE customerID = 5;
DELETE FROM Customer
WHERE customerID =5;

--3)

--4)
SELECT * FROM [dbo].[Customer]
WHERE [email] = 'johndoe@example.com';
--5)
SELECT L.[leaseID], V.make, V.model, V.year
FROM Lease AS L
INNER JOIN Vehicle AS V ON L.vehicleID = V.vehicleID
WHERE L.customerID = '7'
  AND L.startDate <= '2023-09-12' 
  AND L.endDate >= '2023-12-31';

--6)
SELECT P.[paymentID], L.startDate, L.endDate, V.make, V.model
FROM Payment AS P
JOIN Lease AS L ON P.leaseID = L.leaseID
JOIN Customer AS C ON L.customerID = C.customerID
JOIN Vehicle AS V ON L.vehicleID = V.vehicleID
WHERE C.phoneNumber = '5554567890';

--7) 
SELECT AVG([dailyRate]) AS [AverageDailyRate]
FROM [dbo].[Vehicle]
WHERE status = '1';

--8) 
SELECT * FROM [dbo].[Vehicle]
ORDER BY dailyRate DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY;

--9)
SELECT V.*
FROM [dbo].[Vehicle] AS V
JOIN [dbo].Lease AS L ON V.vehicleID = L.vehicleID
WHERE L.customerID = 8;
--10)
SELECT * FROM Lease
ORDER BY endDate DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY;

--11)
SELECT * FROM Payment
WHERE YEAR(paymentDate) = 2023;

--12) 
SELECT C.*
FROM [dbo].[Customer] AS C
LEFT JOIN Lease AS L ON C.customerID = L.customerID
LEFT JOIN Payment AS P ON L.leaseID = P.leaseID
WHERE P.paymentID IS NULL;

--13)
SELECT V.make,V.model, V.year, SUM(P.amount) AS TotalPayments
FROM [dbo].[Vehicle] AS V
INNER JOIN Lease AS L ON V.vehicleID = L.vehicleID
INNER JOIN Payment AS P ON L.leaseID = P.leaseID
GROUP BY V.make, V.model, V.year;

--14)
SELECT C.customerID, C.firstName, C.lastName, SUM(P.amount) AS TotalPayments
FROM [dbo].[Customer] AS C
INNER JOIN Lease AS L ON C.customerID = L.customerID
INNER JOIN Payment AS P ON L.leaseID = P.leaseID
GROUP BY C.customerID, C.firstName, C.lastName;

--15)
SELECT L.leaseID,V.make, V.model,V.year,L.startDate,L.endDate
FROM [dbo].[Lease] AS L
INNER JOIN [dbo].[Vehicle] AS V  ON L.vehicleID = V.vehicleID;

--16)
SELECT L.leaseID, V.make, V.model,V.year,C.firstName,C.lastName,L.startDate,L.endDate
FROM [dbo].[Lease] AS L
INNER JOIN [dbo].[Vehicle] AS V ON L.vehicleID = V.vehicleID
INNER JOIN [dbo].[Customer] AS C ON L.customerID = C.customerID
WHERE L.startDate <= GETDATE() AND L.endDate >= GETDATE();

--17)
SELECT C.customerID,C.firstName,C.lastName,SUM(P.amount) AS TotalSpentOnLeases
FROM [dbo].[Customer] AS C
JOIN [dbo].[Lease] AS L ON C.customerID = L.customerID
JOIN [dbo].[Payment] AS P ON L.leaseID = P.leaseID
GROUP BY C.customerID, C.firstName, C.lastName
ORDER BY TotalSpentOnLeases DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY;

--18)
SELECT V.vehicleID, V.make,V.model,V.year, L.leaseID,L.startDate, L.endDate, C.firstName, C.lastName
FROM [dbo].[Vehicle] AS V
LEFT JOIN [dbo].[Lease] AS L ON V.vehicleID = L.vehicleID
LEFT JOIN [dbo].[Customer] AS C ON L.customerID = C.customerID
WHERE L.endDate >= GETDATE() OR L.endDate IS NULL;
