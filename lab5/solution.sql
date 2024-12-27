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
 date_of_start_work date not null,
 date_of_end_work date,
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

INSERT INTO employees (employee_id, name, surname, date_of_birth, date_of_start_work, date_of_end_work, gender, position_id, company_id) VALUES
(1, 'Иван', 'Иванов', '1990-01-01', '2020-01-10', NULL, 'м', 1, 1),
(2, 'Алексей', 'Петров', '1988-02-15', '2019-02-15', '2023-06-30', 'м', 2, 2),
(3, 'Мария', 'Сидорова', '1992-03-20', '2021-03-05', NULL, 'ж', 3, 3),
(4, 'Ольга', 'Кузнецова', '1991-04-25', '2018-04-01', '2022-12-31', 'ж', 1, 4),
(5, 'Дмитрий', 'Волков', '1989-05-30', '2022-05-20', NULL, 'м', 2, 1);

INSERT INTO skills (skills_id, name, employee_id) VALUES
(1, 'Java', 1),
(2, 'Python', 1),
(3, 'SQL', 2),
(4, 'Data Analysis', 2),
(5, 'HTML', 3),
(6, 'CSS', 3),
(7, 'JavaScript', 3),
(8, 'Communication', 4),
(9, 'Recruitment', 4),
(10, 'Project Management', 5);

INSERT INTO vacations (vacation_id, date_of_start, date_of_end, employee_id) VALUES
(1, '2021-07-01', '2021-07-15', 1),
(2, '2022-08-05', '2022-08-20', 2),
(3, '2023-09-10', '2023-09-25', 3),
(4, '2020-06-15', '2020-06-30', 4),
(5, '2023-10-01', '2023-10-15', 5);

INSERT INTO business_trips (business_trip_id, date_of_start, date_of_end, direction, employee_id) VALUES
(1, '2021-11-01', '2021-11-05', 'Москва', 1),
(2, '2022-04-10', '2022-04-15', 'Санкт-Петербург', 2),
(3, '2023-05-20', '2023-05-25', 'Новосибирск', 3),
(4, '2019-09-05', '2019-09-10', 'Казань', 4),
(5, '2021-12-01', '2021-12-05', 'Екатеринбург', 5);
--рейтинг компаний по количеству сотрудников
SELECT 
    c.name AS company_name,
    COUNT(e.employee_id) AS employee_count,
    RANK() OVER (ORDER BY COUNT(e.employee_id) DESC) AS rank
FROM 
    companies c
LEFT JOIN 
    employees e ON c.company_id = e.company_id
GROUP BY 
    c.company_id, c.name;

  --  Рейтинг сотрудников по средней продолжительности командировок
  SELECT 
    e.name AS employee_name,
    e.surname AS employee_surname,
    AVG(bt.date_of_end - bt.date_of_start) AS avg_trip_duration,
    RANK() OVER (ORDER BY AVG(bt.date_of_end - bt.date_of_start) DESC) AS rank
FROM 
    employees e
JOIN 
    business_trips bt ON e.employee_id = bt.employee_id
GROUP BY 
    e.employee_id, e.name, e.surname;

   
   --Количество сотрудников каждой компании в отпуске по сезонам
   SELECT 
    c.name AS company_name,
    CASE 
        WHEN EXTRACT(MONTH FROM v.date_of_start) IN (12, 1, 2) THEN 'Winter'
        WHEN EXTRACT(MONTH FROM v.date_of_start) IN (3, 4, 5) THEN 'Spring'
        WHEN EXTRACT(MONTH FROM v.date_of_start) IN (6, 7, 8) THEN 'Summer'
        WHEN EXTRACT(MONTH FROM v.date_of_start) IN (9, 10, 11) THEN 'Fall'
    END AS season,
    COUNT(DISTINCT e.employee_id) AS employee_count
FROM 
    companies c
JOIN 
    employees e ON c.company_id = e.company_id
JOIN 
    vacations v ON e.employee_id = v.employee_id
WHERE 
    v.date_of_start <= v.date_of_end 
GROUP BY 
    c.company_id, c.name, season;



