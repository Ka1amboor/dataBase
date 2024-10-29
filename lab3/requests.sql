CREATE TABLE Companies(
    company_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE Positions(
    position_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE Employees(
    employee_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(100) NOT NULL CHECK (gender IN ('м', 'ж')),
    position_id INT REFERENCES Positions(position_id),
    company_id BIGINT REFERENCES Companies(company_id)
);

CREATE TABLE Vacations(
    vacation_id INT PRIMARY KEY,
    employee_id INT REFERENCES Employees(employee_id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

CREATE TABLE Business_trips(
    buissness_trip_id INT PRIMARY KEY,
    employee_id BIGINT REFERENCES Employees(employee_id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    direction VARCHAR(100) NOT NULL
);

CREATE TABLE Skills(
    skill_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);


INSERT INTO Companies (company_id, name)
VALUES (1, 'Company A'), (2, 'Company B'), (3, 'Company C');


INSERT INTO Positions (position_id, name)
VALUES (1, 'Manager'), (2, 'Developer'), (3, 'Designer');

INSERT INTO Employees (employee_id, name, surname, date_of_birth, gender, position_id, company_id)
VALUES 
  (1, 'John', 'Doe', '1990-01-01', 'м', 1, 1),
  (2, 'Jane', 'Smith', '1992-05-10', 'ж', 2, 2),
  (3, 'Mark', 'Johnson', '1985-12-15', 'м', 3, 2);
  
INSERT INTO Vacations (vacation_id, employee_id, start_date, end_date)
VALUES 
  (1, 1, '2022-07-01', '2022-07-15'),
  (2, 2, '2022-08-15', '2022-08-31'),
  (3, 3, '2022-06-10', '2022-06-20');

INSERT INTO Business_trips (buissness_trip_id, employee_id, start_date, end_date, direction)
VALUES 
  (1, 1, '2022-04-01', '2022-04-07', 'New York'),
  (2, 2, '2022-03-15', '2022-03-20', 'London'),
  (3, 3, '2022-05-10', '2022-05-15', 'Tokyo');

 INSERT INTO Skills (skill_id, name)
VALUES 
  (1, 'C'), 
  (2, 'C++'), 
  (3, 'Java');
 
 

