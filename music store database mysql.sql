show databases;

create database music_database;
use music_database;
show tables;

CREATE TABLE music_database.album 
(
album_id int8 PRIMARY KEY,
title varchar(255),
artist_id int8
);

SELECT * FROM album;

/*     WHY ERROR??????
COPY album(album_id, title, artist_id)
FROM 'C:\Users\anand\Downloads\music store data (csv)\music store data\album.csv'
DELIMITER ','
CSV HEADER;
*/

CREATE TABLE artist 
(
artist_id int PRIMARY KEY,
name varchar(255)
);

CREATE TABLE customer
(
customer_id	int PRIMARY KEY,
first_name varchar(255),
last_name varchar(255),
company	varchar(255),
address varchar(255),
city varchar(255),	
state varchar(255),	
country varchar(255),	
postal_code	varchar(255),
phone varchar(255),	
fax	varchar(255),
email varchar(255),	
support_rep_id int
);

CREATE TABLE employee 
(
employee_id	int PRIMARY KEY,
last_name varchar(255),	
first_name varchar(255),	
title varchar(255),	
reports_to int,	
levels varchar(255),	
birthdate DATETIME,	
hire_date DATETIME,
address varchar(255),	
city varchar(255),	
state varchar(255),	
country varchar(255),	
postal_code varchar(255),	
phone varchar(255),	
fax	varchar(255),
email varchar(255)
);

-- DOUBT - Why?????? This is done??? because of presence of null value in table?????
use music_database;
show tables;
INSERT INTO employee values(1	,'Adams'	,'Andrew'	,'General Manager'	,9	,'L6'	,'1962-02-18 00:00'	,'2016-08-14 00:00',	'11120 Jasper Ave NW',	'Edmonton',	'AB',	'Canada'	,'T5K 2N1',	'+1 (780) 428-9482',	'+1 (780) 428-3457',	'andrew@chinookcorp.com');
INSERT INTO employee values(2	,'Edwards'	,'Nancy'	,'Sales Manager'	,1	,'L4'	,'1958-12-08 00:00',	'2016-05-01 00:00'	,'825 8 Ave SW',	'Calgary'	,'AB'	,'Canada'	,'T2P 2T3',	'+1 (403) 262-3443',	'+1 (403) 262-3322',	'nancy@chinookcorp.com');
INSERT INTO employee values(3	,'Peacock'	,'Jane'	,'Sales Support Agent',	2	,'L1'	,'1973-08-29 00:00',	'2017-04-01 00:00',	'1111 6 Ave SW',	'Calgary',	'AB'	,'Canada'	,'T2P 5M5'	,'+1 (403) 262-3443'	,'+1 (403) 262-6712'	,'jane@chinookcorp.com');
INSERT INTO employee values(4	,'Park'	,'Margaret'	,'Sales Support Agent'	,2	,'L1'	,'1947-09-19 00:00'	,'2017-05-03 00:00'	,'683 10 Street SW',	'Calgary',	'AB'	,'Canada',	'T2P 5G3'	,'+1 (403) 263-4423'	,'+1 (403) 263-4289'	,'margaret@chinookcorp.com');
INSERT INTO employee values(5	,'Johnson'	,'Steve'	,'Sales Support Agent',	2	,'L1'	,'1965-03-03 00:00'	,'2017-10-17 00:00'	,'7727B 41 Ave'	,'Calgary'	,'AB'	,'Canada'	,'T3B 1Y7'	,'1 (780) 836-9987'	,'1 (780) 836-9543'	,'steve@chinookcorp.com');
INSERT INTO employee values(6	,'Mitchell'	,'Michael'	,'IT Manager'	,1	,'L3'	,'1973-07-01 00:00'	,'2016-10-17 00:00'	,'5827 Bowness Road NW'	,'Calgary'	,'AB'	,'Canada'	,'T3B 0C5'	,'+1 (403) 246-9887'	,'+1 (403) 246-9899'	,'michael@chinookcorp.com');
INSERT INTO employee values(7	,'King'	,'Robert',	'IT Staff',	6	,'L2',	'1970-05-29 00:00',	'2017-01-02 00:00',	'590 Columbia Boulevard West'	,'Lethbridge'	,'AB'	,'Canada'	,'T1K 5N8'	,'+1 (403) 456-9986'	,'+1 (403) 456-8485'	,'robert@chinookcorp.com');
INSERT INTO employee values(8	,'Callahan'	,'Laura'	,'IT Staff'	,6,	'L2'	,'1968-01-09 00:00'	,'2017-03-04 00:00'	,'923 7 ST NW'	,'Lethbridge'	,'AB'	,'Canada'	,'T1H 1Y8'	,'+1 (403) 467-3351'	,'+1 (403) 467-8772'	,'laura@chinookcorp.com');
INSERT INTO employee(employee_id	,last_name	,first_name	,title ,levels	,birthdate	,hire_date	,address	,city	,state	,country	,postal_code	,phone	,fax	,email) values(9	,'Madan'	,'Mohan'	,'Senior General Manager'		,'L7'	,'1961-01-26 00:00'	,'2016-01-14 00:00',	'1008 Vrinda Ave MT'	,'Edmonton'	,'AB'	,'Canada'	,'T5K 2N1'	,'+1 (780) 428-9482'	,'+1 (780) 428-3457'	,'madan.mohan@chinookcorp.com');

DELETE FROM employee WHERE employee_id = 9;


CREATE TABLE genre
(
genre_id int PRIMARY KEY,	
name varchar(255)
);

CREATE TABLE invoice 
(
invoice_id int PRIMARY KEY,	
customer_id	int,
invoice_date TIMESTAMP,	
billing_address	varchar(255),
billing_city varchar(255),	
billing_state varchar(255),	
billing_country varchar(255),
billing_postal_code	varchar(255),
total Decimal(4,2)
);

CREATE TABLE invoice_line 
(
invoice_line_id	int PRIMARY KEY,
invoice_id int,
track_id int,	
unit_price Decimal(3,2),	
quantity int
);

CREATE TABLE media_type 
(
media_type_id int PRIMARY KEY,	
name varchar(255)
);

CREATE TABLE playlist
(
playlist_id	int PRIMARY KEY,
name varchar(255)
);

CREATE TABLE playlist_track
(
playlist_id	int,
track_id int
);

CREATE TABLE track 
(
track_id int PRIMARY KEY,	
name varchar(255),	
album_id int,	
media_type_id int,	
genre_id int,	
composer varchar(255),	
milliseconds int,	
bytes int,	
unit_price Decimal(3,2)
);

-- ---------------------------------------------------------------------------------------------------
