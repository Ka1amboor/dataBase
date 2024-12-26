create table flights(
flight_id int primary key,
destination varchar(100) not null,
departure_time timestamp not null,
status varchar(50)
);

create table passengers (
passenger_id int primary key,
name  varchar(100) not null,
email varchar(100) not null,
baggage_weight float check (baggage_weight >= 0)
);

create table tickets (
ticket_id int primary key,
passenger_id int references passengers(passenger_id) on delete cascade,
flight_id int references flights(flight_id) on delete cascade,
class varchar(20) check (class in ('Economy', 'Business', 'First')) not null,
price money
);

CREATE TABLE logs (
log_id bigserial PRIMARY KEY,
ACTION varchar(100) NOT NULL,
time_action timestamp DEFAULT now(),
details text
);

create table passenger_flights (
passenger_id int references passengers(passenger_id) on delete cascade,
flight_id int references flights(flight_id) on delete cascade,
primary key (passenger_id, flight_id)
);
-- Функция: Логирование изменений
create or replace function log_changes() returns trigger as $$
begin 
	insert into logs (action, details) values (TG_OP || ' on '|| TG_TABLE_NAME, row_to_json(NEW)::TEXT);
	return new;
end;
$$ language plpgsql;

-- Триггер: Логирование изменений в Flights
create trigger log_flights_changes
after insert or update or delete on flights
for each row execute function log_changes();




-- Функция: Расчет стоимости багажа
create or replace function calculate_baggage_cost(weight float, ticket_class varchar) returns money as $$
begin 
	if ticket_class = 'Economy' then 
		return case when weight > 20 then (weight - 20) * 10 else 0 end;
	elseif ticket_class = 'Business' then
		return case when weight > 30 then (weight - 30) * 8 else 0 end;
	elseif ticket_class = 'First' then
		return case when weight > 40 then (weight - 40 ) * 5 else 0 end;
	else
		return 0;
	end if;
	
end;
$$ language plpgsql;

-- Представления для ролей пользователей
-- Менеджер
create or replace view manager_view as
select flight_id, destination, departure_time, status
from flights;

-- Администратор
create or replace view admin_view as 
select * from flights;

-- Покупатель
create or replace view customer_view as
select passenger_id, name, baggage_weight
from passengers;

-- Продавец
create or replace view seller_view as
select t.flight_id, t.passenger_id, t.class
from tickets t;

INSERT INTO flights (flight_id, destination, departure_time, status) VALUES
(1, 'New York', '2023-10-01 10:00:00', 'On Time'),
(2, 'Los Angeles', '2023-10-01 12:30:00', 'Delayed'),
(3, 'Chicago', '2023-10-01 15:45:00', 'Cancelled');

INSERT INTO passengers (passenger_id, name, email, baggage_weight) VALUES
(1, 'Ivan Ivanov', 'ivan@example.com', 25.0),
(2, 'Maria Petrova', 'maria@example.com', 15.0),
(3, 'John Smith', 'john@example.com', 35.0);

INSERT INTO tickets (ticket_id, passenger_id, flight_id, class, price) VALUES
(1, 1, 1, 'Economy', 150.00),
(2, 2, 2, 'Business', 300.00),
(3, 3, 3, 'First', 500.00);

-- Функция: Проверка статуса рейса
create or replace function check_flights_status(flight_id_param int) returns text as $$
declare 
 flight_status text;
begin
 select status into flight_status from flights where flight_id = flight_id_param;
 return flight_status;
end;
$$ language plpgsql;

--проверка функции
select check_flights_status(1);

SELECT calculate_baggage_cost(25, 'Economy');


SELECT * FROM manager_view;

INSERT INTO flights (flight_id, destination, departure_time, status) VALUES
(5, 'Moscow', '2024-10-03 08:00:00', 'Scheduled');

UPDATE flights SET status = 'Delayed' WHERE flight_id = 1;

DELETE FROM flights WHERE flight_id = 2;

SELECT * FROM logs;
