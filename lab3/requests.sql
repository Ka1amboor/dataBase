create table companies(
company_id int primary key,
name varchar(255) not null);

create table positions(
position_id int primary key,
name varchar(255) not null);

create table employees(
 employee_id int primary key,
 name varchar(255) not null,
 surname varchar(255) not null,
 date_of_birth date not null,
 gender varchar(255) not null check (gender in ('ж','м')),
 position_id INT REFERENCES Positions(position_id),
 company_id INT REFERENCES Companies(company_id));

create table skills(
skills_id int primary key,
name varchar(255) not null,
employee_id int references Employees(employee_id));

create table vacations(
vacation_id int primary key,
date_of_start date not null,
date_of_end date not null,
employee_id int references employees(employee_id));

create table business_trips(
business_trip_id int primary key,
date_of_start date not null,
date_of_end date not null,
direction varchar(255) not null,
employee_id int references employees(employee_id));
 

INSERT INTO companies (company_id, name) VALUES
(1, 'yandex'),
(2, 'sber'),
(3, 'vk'),
(4, 'google');

INSERT INTO positions (position_id, name) VALUES
(1, 'middle'),
(2, 'senior'),
(3, 'june'),
(4, 'HR_Specialist');

INSERT INTO employees (employee_id, name, surname, date_of_birth, gender, position_id, company_id) VALUES
(1, 'Alice', 'Smith', '1988-05-12', 'ж', 1, 1),
(2, 'John', 'Doe', '1990-07-23', 'м', 2, 2),
(3, 'Emma', 'Johnson', '1993-11-11', 'ж', 3, 3),
(4, 'Michael', 'Brown', '1985-02-17', 'м', 1, 4),
(5, 'Olivia', 'Davis', '1991-04-22', 'ж', 4, 1);

INSERT INTO skills (skills_id, name, employee_id) VALUES
(1, 'Java', 1),
(2, 'C++', 2),
(3, 'C', 3),
(4, 'Python', 1),
(5, 'data_base', 5),
(6, 'Communication', 4);

INSERT INTO vacations (vacation_id, date_of_start, date_of_end, employee_id) VALUES
(1, '2023-06-15', '2023-06-25', 1),
(2, '2023-08-01', '2023-08-10', 2),
(3, '2023-07-10', '2023-07-20', 3),
(4, '2023-12-01', '2023-12-15', 4),
(5, '2023-09-25', '2023-10-05', 5);

INSERT INTO business_trips (business_trip_id, date_of_start, date_of_end, direction, employee_id) VALUES
(1, '2023-05-01', '2023-05-07', 'New York', 1),
(2, '2023-06-10', '2023-06-15', 'London', 3),
(3, '2023-08-05', '2023-08-12', 'Tokyo', 2),
(4, '2023-11-20', '2023-11-27', 'Sydney', 4),
(5, '2023-07-25', '2023-08-02', 'Berlin', 5);


