--Anjali Negi
--Case Study 01
--School


create database ManageSchool;
use [ManageSchool];

--creating tables

--coursemaster table

drop table [dbo].[EnrollmentMaster];
drop table [dbo].[StudentMaster];
drop table [dbo].[CourseMaster];

create table CourseMaster
(
CID int primary key,
CourseName varchar(40) not null,
Category char(1) check (Category in('B','I','A')) ,
Fee smallmoney not null check(Fee>=0)
);


--studentMaster table

create table StudentMaster
(
SID tinyint primary key,
StudentName varchar(40) not null,
origin char(1) not null check(origin in ('L','F')),
Type char(1) not null check(Type in('U','G'))
);

--enrollmaster table

create table EnrollmentMaster
(
CID int not null foreign key (CID) references [dbo].[CourseMaster]([CID]),
SID tinyint not null foreign key (SID) references [dbo].[StudentMaster]([SID]),
DOE datetime not null,
FWF bit not null,
Grade char(1) check(Grade in('O','A','B','C'))
primary key (CID,SID)
);


--inserting data

insert into CourseMaster (CID, CourseName, Category, Fee)
values
(1, 'Mathematics 101', 'B', 100.00),
(2, 'Computer Science Basics', 'I', 150.00),
(3, 'Advanced Physics', 'A', 200.00),
(4, 'English Literature', 'B', 120.00),
(5, 'History Overview', 'I', 180.00),
(6, 'Programming in Java', 'A', 220.00),
(7, 'Spanish Language', 'B', 130.00),
(8, 'Data Structures', 'I', 160.00);


insert into StudentMaster (SID, StudentName, Origin, Type)
values
(13, 'Rai Johnson', 'L', 'U');
(2, 'Bob Smith', 'F', 'G'),
(3, 'Charlie Brown', 'L', 'G'),
(4, 'Diana Miller', 'F', 'U'),
(5, 'Eva Davis', 'L', 'G'),
(6, 'Frank White', 'F', 'U'),
(7, 'Grace Robinson', 'L', 'G'),
(8, 'Henry Lee', 'F', 'U'),
(9, 'Ivy Garcia', 'L', 'G'),
(10, 'Jack Turner', 'F', 'U'),
(11, 'Kelly Moore', 'L', 'G'),
(12, 'Leo Martin', 'F', 'U');


insert into EnrollmentMaster (CID, SID, DOE, FWF, Grade)
values
(1, 13, '2023-01-10 09:00:00', 1, 'O');
(2, 2, '2023-02-15 10:30:00', 1, 'B'),
(3, 3, '2023-03-20 11:45:00', 0, 'C'),
(4, 4, '2023-04-25 13:15:00', 1, 'A'),
(5, 5, '2023-05-30 14:30:00', 0, 'B'),
(6, 6, '2023-06-05 15:45:00', 1, 'C'),
(7, 7, '2023-07-10 09:00:00', 0, 'A'),
(7, 8, '2023-08-15 10:30:00', 1, 'B'),
(3, 9, '2023-09-20 11:45:00', 0, 'C'),
(1, 10, '2023-10-25 13:15:00', 1, 'A'),
(3, 11, '2023-11-30 14:30:00', 0, 'B'),
(5, 12, '2023-12-05 15:45:00', 1, 'C');

update [dbo].[EnrollmentMaster] set DOE='2023-10-05 15:45:00' where DOE ='2023-12-05 15:45:00';

--1. List the course wise total no. of Students enrolled. Provide the information only for students of foreign origin and 
--only if the total exceeds 10.
select CM.[CourseName], count(EM.[SID]) from  [dbo].[CourseMaster] as CM 
join [dbo].[EnrollmentMaster] as EM on EM.[CID]=CM.[CID]
join [dbo].[StudentMaster] as SM on SM.[SID]=EM.[SID]
--where SM.[origin]='F'
group by CM.[CourseName];



--2. List the names of the Students who have not enrolled for Java course.

select SM.[StudentName] from [dbo].[StudentMaster] as SM
join [dbo].[EnrollmentMaster] as EM on EM.[SID]=SM.[SID]
join [dbo].[CourseMaster] as CM on CM.[CID]=EM.[CID]
where CM.CourseName not like '%java%';

--3. List the name of the advanced course where the enrollment by foreign students is the highest.


select CM.[CourseName] from [dbo].[CourseMaster] as CM
join [dbo].[EnrollmentMaster] as EM on EM.[CID]=CM.[CID]
join [dbo].[StudentMaster] as SM on SM.[SID]=SM.[SID]
where CM.[Category]='A' and SM.[origin]='F'
group by CM.[CourseName] 
order by count(EM.[SID]) desc;


-- 4.List the names of the students who have enrolled for at least one basic course in the current month.   A

select SM.[StudentName] from [dbo].[StudentMaster] as SM
join [dbo].[EnrollmentMaster] as EM on EM.[SID]=SM.[SID]
join [dbo].[CourseMaster] as CM on CM.[CID]=EM.[CID]
where CM.Category='B' and month(EM.DOE)=month(getdate());


--5. List the names of the Undergraduate, local students who have got a “C” grade in any basic course.   A

select SM.[StudentName] from [dbo].[StudentMaster] as SM
join [dbo].[EnrollmentMaster] as EM on EM.[SID]=SM.[SID]
join [dbo].[CourseMaster] as CM on CM.[CID]=EM.[CID]
where SM.[Type]='U'and SM.[origin]='L' and EM.Grade='C' and CM.Category='B';


--6. List the names of the courses for which no student has enrolled in the month of May 2020.

select CM.[CourseName], year(EM.[DOE]) as yearOfEn from [dbo].[CourseMaster] as CM
join [dbo].[EnrollmentMaster] as EM on EM.[CID]=CM.[CID]
join [dbo].[StudentMaster] as SM on SM.[SID]=EM.[SID]
where EM.[SID] not in 
(select EM.[SID] where YEAR(EM.[DOE])='2020' and MONTH(EM.[DOE])='05');


-- 7. List name, Number of Enrollments and Popularity for all Courses. Popularity has to be displayed as
--“High” if number of enrollments is higher than 50, “Medium” if greater than or equal to 20 
--and less than 50, and “Low” if the no.  Is less than 20.

select CM.[CourseName], count(EM.[SID]) as totalEnroll,
case
when count(EM.[SID])>50 then 'High'
when count(EM.[SID])>20 then 'Medium'
else 'Low' end as popularity 
from [dbo].[CourseMaster] as CM
join [dbo].[EnrollmentMaster] as EM on EM.[CID]= CM.[CID]
group by CM.[CourseName];

--8. List the most recent enrollment details with information on Student Name, Course name and age of enrollment in days.

select SM.[StudentName], CM.[CourseName], datediff(day, EM.[DOE], getdate())
as AgeOfEn from [dbo].[StudentMaster] as SM
join [dbo].[EnrollmentMaster] as EM on EM.[SID]=SM.[SID]
join [dbo].[CourseMaster] as CM on CM.[CID]=EM.[CID]
order by AgeOfEn
offset 0 rows
fetch next 1 rows only;

--9. List the names of the Local students who have enrolled for exactly 3 basic courses. 

select SM.[StudentName] from [dbo].[StudentMaster] as SM
join [dbo].[EnrollmentMaster] as EM on EM.[SID]=SM.[SID]
join [dbo].[CourseMaster] as CM on CM.[CID]=EM.[CID]
where SM.[origin]='L' and CM.[Category]='B'
group by SM.[StudentName]
having count(CM.[CID])=3;


--10. List the names of the Courses enrolled by all (every) students.

select SM.[StudentName],CM.[CourseName] from [dbo].[StudentMaster] as SM
join [dbo].[EnrollmentMaster] as EM on EM.[SID]=SM.[SID]
join [dbo].[CourseMaster] as CM on CM.[CID]=EM.[CID]
group by SM.[StudentName], CM.[CourseName];



--11. For those enrollments for which fee have been waived, provide the names of students who have got ‘O’ grade.

select SM.[StudentName] from [dbo].[StudentMaster] as SM
join [dbo].[EnrollmentMaster] as EM on EM.SID=SM.SID
where EM.FWF='1' and EM.Grade='O';

--12. List the names of the foreign, undergraduate students who have got grade ‘C’ in any basic course.     A

select SM.[StudentName] from [dbo].[StudentMaster] as SM
join [dbo].[EnrollmentMaster] as EM on EM.[SID]=SM.[SID]
join [dbo].[CourseMaster] as CM on CM.[CID]=EM.[CID]
where SM.[Type]='U'and SM.[origin]='F' and EM.Grade='C' and CM.Category='B';

--13. List the course name, total no. of enrollments in the current month.
select CM.[CourseName], count(EM.[SID]) as totalEn from [dbo].[CourseMaster] as CM
join [dbo].[EnrollmentMaster] as EM on EM.[CID]=CM.[CID]
where MONTH(EM.DOE)=MONTH(getdate())
group by CM.CourseName;
