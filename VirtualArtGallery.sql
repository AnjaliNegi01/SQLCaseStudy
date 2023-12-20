--Anjali Negi
--Case Study
--Virtual Art Gallery

create database VRGallery;
use [VRGallery];


--creating tables

-- artwork table

create table Artwork
(
ArtworkID int primary key,
Title varchar(50),
Description varchar(200),
Medium varchar(100),
ImageURL varchar(100),
ArtistID int foreign key (ArtistID) references [dbo].[Artwork] ([ArtistID])
);


--Artist table
create table Artist
(
ArtistID int primary key,
Name varchar(50),
Biography varchar(200),
BirthDate date,
Nationality varchar(100),
Website varchar(100),
Phone char(10),
Email varchar(30)
);


--user table

create table users
(
UserID int Primary Key,
Username varchar (50),
Password varchar(20),
Email varchar (30),
First_Name varchar(20),
Last_Name varchar(20),
Date_of_Birth date,
Profile_Picture bit,
ArtworkID int foreign key (ArtworkId) references [dbo].[Artwork] ([ArtworkID])
);

--gallery table
 create table Gallery(
GalleryID int Primary Key,
Name varchar (20),
Description varchar (100),
Location varchar (30),
ArtistID int foreign key (ArtistID) references [dbo].[Artist] ([ArtistID]),
OpeningHours datetime
);


create table User_Favorite_Artwork
(
UserID int foreign key (UserID) references [dbo].[users] ([UserID]),
ArtworkID int foreign key (ArtworkID) references [dbo].[Artwork] ([ArtworkID])
);

create table Artwork_Gallery
(
ArtworkID int foreign key (ArtworkID) references [dbo].[Artwork] ([ArtworkID]),
GalleryID int foreign key (GalleryID) references [dbo].[Gallery]([GalleryID])
);
