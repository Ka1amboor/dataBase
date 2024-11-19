create table flights (
id_flight int primary key,
flight_number varchar(50) unique not null, 
status varchar(50),
departure_time timestamp,
arrival_time timestamp);

create table tickets(
id_ticket int primary key,
flight_number_fl varchar(50) not null,
passenger_name varchar(255),
ticket_class varchar(50),
baggage_weight float,
foreign key (flight_number_fl) references flights(flight_number) on delete cascade);

INSERT INTO flights (id_flight, flight_number, status, departure_time, arrival_time) VALUES
(1, 'FL1001', 'Scheduled', '2023-10-15 10:00:00', '2023-10-15 14:00:00'),
(2, 'FL1002', 'Scheduled', '2023-10-16 12:30:00', '2023-10-16 16:30:00'),
(3, 'FL1003', 'Delayed', '2023-10-17 08:30:00', '2023-10-17 12:00:00'),
(4, 'FL1004', 'Canceled', '2023-10-18 15:00:00', '2023-10-18 19:00:00'),
(5, 'FL1005', 'Scheduled', '2023-10-19 09:00:00', '2023-10-19 13:00:00');

INSERT INTO tickets (id_ticket, flight_number_fl, passenger_name, ticket_class, baggage_weight) VALUES
(1, 'FL1001', 'John', 'Economy', 20.5),
(2, 'FL1001', 'Jane', 'Business', 18.0),
(3, 'FL1001', 'Emily', 'Economy', 25.0),
(4, 'FL1002', 'Michael', 'First Class', 22.0),
(5, 'FL1002', 'Anna', 'Economy', 19.0),
(6, 'FL1003', 'Serena', 'Business', 24.0),
(7, 'FL1003', 'Emma', 'Economy', 23.5),
(8, 'FL1004', 'Lucas', 'Economy', 20.0),
(9, 'FL1005', 'Sophia', 'First Class', 15.0),
(10, 'FL1005', 'Chuck', 'Business', 17.0),
(11, 'FL1005', 'Liam', 'Economy', 27.0),
(12, 'FL1001', 'Mia', 'Economy', 21.0),
(13, 'FL1001', 'Lily', 'Business', 19.5),
(14, 'FL1002', 'Noah', 'Economy', 19.0),
(15, 'FL1003', 'Dorota', 'First Class', 16.0),
(16, 'FL1003', 'Ethan', 'Economy', 22.5),
(17, 'FL1004', 'Blair', 'Business', 18.5),
(18, 'FL1005', 'Mason', 'Economy', 23.0),
(19, 'FL1005', 'Harper', 'First Class', 20.0),
(20, 'FL1005', 'Ella', 'Economy', 26.0);

--function ----- calculate cost baggage
CREATE OR REPLACE FUNCTION calculate_baggage_cost(baggage_weight FLOAT, ticket_class VARCHAR)
RETURNS FLOAT AS $$
DECLARE
    cost FLOAT;
BEGIN
    IF ticket_class = 'Economy' THEN
        IF baggage_weight <= 20 THEN
            cost := 0;
        ELSE
            cost := (baggage_weight - 20) * 10;
        END IF;
    ELSIF ticket_class = 'Business' THEN
        IF baggage_weight <= 30 THEN
            cost := 0;
        ELSE
            cost := (baggage_weight - 30) * 8;
        END IF;
    ELSIF ticket_class = 'First Class' THEN
        IF baggage_weight <= 40 THEN
            cost := 0;
        ELSE
            cost := (baggage_weight - 40) * 5;
        END IF;
    ELSE
        cost := 0; -- Default cost if ticket class is unknown
    END IF;
    RETURN cost;
END;
$$ LANGUAGE plpgsql;

--function ----- check status flight
CREATE OR REPLACE FUNCTION get_flight_status(flight_no VARCHAR)
RETURNS VARCHAR AS $$
DECLARE
    status VARCHAR;
BEGIN
    SELECT status INTO status FROM flights WHERE flight_number = flight_no;
    RETURN status;
END;
$$ LANGUAGE plpgsql;

--table logs----

CREATE TABLE logs (
    id SERIAL PRIMARY KEY,
    action_time TIMESTAMP DEFAULT NOW(),
    action_type VARCHAR(50),
    description TEXT
);

-- function logs -- 

CREATE OR REPLACE FUNCTION log_ticket_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO logs (action_type, description)
    VALUES ('INSERT', 'Добавлен новый билет ' || NEW.id_ticket || ' для рейса ' || NEW.flight_number_fl);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- treagger --

CREATE TRIGGER log_ticket_insert_trigger
AFTER INSERT ON tickets
FOR EACH ROW EXECUTE FUNCTION log_ticket_insert();

-- treagger for update status --

CREATE OR REPLACE FUNCTION log_flight_status_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO logs (action_type, description)
    VALUES ('UPDATE', 'Статус рейса ' || OLD.flight_number || ' изменён с ' || OLD.status || ' на ' || NEW.status);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- treagger -- 

CREATE TRIGGER log_flight_status_update_trigger
AFTER UPDATE OF status ON flights
FOR EACH ROW EXECUTE FUNCTION log_flight_status_update();

CREATE VIEW top_flights AS
SELECT flight_number_fl, COUNT(*) AS ticket_count
FROM tickets
GROUP BY flight_number_fl
ORDER BY ticket_count DESC
LIMIT 10;


-- roles 

CREATE VIEW manager_view AS
SELECT f.flight_number, f.status, t.passenger_name, t.ticket_class, t.baggage_weight
FROM flights f
JOIN tickets t ON f.flight_number = t.flight_number_fl;


CREATE VIEW admin_view AS
SELECT * FROM flights;

CREATE VIEW customer_view AS
SELECT t.passenger_name, t.flight_number_fl, f.status, t.ticket_class
FROM tickets t
JOIN flights f ON t.flight_number_fl = f.flight_number;

CREATE VIEW seller_view AS
SELECT t.flight_number_fl, t.passenger_name, t.ticket_class
FROM tickets t;

-- поверка работы тригеров и логов region

INSERT INTO tickets (id_ticket, flight_number_fl, passenger_name, ticket_class, baggage_weight) VALUES
(21, 'FL1005', 'Alex', 'Economy', 20.5);

UPDATE flights
SET status = 'Delayed'
WHERE flight_number = 'FL1001';


