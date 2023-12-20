--Anjali Negi
--Case study: 03
--Crime analysis and reporting system

create database crimeAnalysis;
use crimeAnalysis;


--creating table

create table Victims(
VictimID int Primary Key,
FirstName varchar (30),
LastName varchar (20),
DateOfBirth date,
Gender char(1),
Phone char(10),
Address varchar (50),
);

--suspect table

create table Suspects(
SuspectID int Primary Key,
FirstName varchar(20),
LastName varchar(20),
DateOfBirth date,
Gender char(1),
Phone char(10),
Address varchar(50)
);



--LawEnforcementAgency

create table LawEnforcementAgency(
AgencyID int Primary Key,
AgencyName varchar (50),
Jurisdiction varchar (30),
Phone char(10),
Email varchar(30),
Address varchar(50),
);

--incidents table 
drop table [dbo].[Incidents];
create table Incidents(
IncidentID int Primary Key,
IncidentType varchar (30),
IncidentDate datetime,
Location varchar (30),
Description varchar (100),
Status varchar (20),
VictimID int Foreign Key (VictimID) references [dbo].[Victims] ([VictimID]),
SuspectId int Foreign Key (SuspectId) references [dbo].[Suspects] ([SuspectId]),
AgencyId int Foreign key (AgencyId) references [dbo].[LawEnforcementAgency] ([AgencyId])
);

--Officers
create table Officers(
OfficerID int Primary Key,
FirstName varchar (20),
LastName varchar (20),
BadgeNumber int,
Rank varchar (10),
Phone char(10),
email varchar(30),
address varchar (30),
AgencyID int Foreign Key (AgencyID) references [dbo].[LaWEnforcementAgency] ([AgencyID])
);


--Evidence 
create table Evidence(
EvidenceID int Primary Key,
Description varchar (50),
LocationFound varchar (30),
IncidentID int Foreign Key (IncidentID) references [dbo].[Incidents] ([IncidentID])
);

--Reports
create table Reports(
ReportID int Primary Key,
IncidentID int Foreign Key (IncidentID) references  [dbo].[Incidents] ([IncidentID]),
OfficerID int Foreign Key (OfficerID) references [dbo].[Officers] ([OfficerId]),
ReportDate datetime,
Status varchar(20)
);