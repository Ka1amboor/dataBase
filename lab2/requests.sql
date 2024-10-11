-- Таблица клиентов
CREATE TABLE Clients (
    client_id INT PRIMARY KEY,
    name VARCHAR(100),
    surname VARCHAR(100),
    address VARCHAR(255),
    phone_number VARCHAR(20),
    email VARCHAR(100)
);

-- Таблица финансовых продуктов
CREATE TABLE FinancialProducts (
    product_id INT PRIMARY KEY,
    type VARCHAR(50),
    conditions TEXT,
    bet FLOAT
);

-- Таблица договоров
CREATE TABLE Contracts (
    contract_id INT PRIMARY KEY,
    client_id INT,
    product_id INT,
    data DATE,
    total_sum FLOAT
);

--

-- Заполнение таблицы клиентов
INSERT INTO Clients (client_id, name, surname, address, phone_number, email) VALUES
(1, 'Иван', 'Воскресенский', 'Россия, Санкт-Петербуррг, ул. Стремянная, 1', '+79525525252', 'ivanov@example.com'),
(2, 'Петр', 'Петров', 'Россия, Санкт-Петербург, ул. Пушкина, 2', '+79522223344', 'petrov@example.com');

-- Заполнение таблицы финансовых продуктов
INSERT INTO FinancialProducts (product_id, type, conditions, bet) VALUES
(1, 'Кредиты', 'Срок до 5 лет, ставка 10%', 10.0),
(2, 'Депозиты', 'Ставка 5% годовых', 5.0),
(3, 'Страхование', 'Застраховать автомобиль или имущество', 3.0);

-- Заполнение таблицы договоров
INSERT INTO Contracts (contract_id, client_id, product_id, data, total_sum) VALUES
(1, 1, 1, '2023-01-01', 5000000.00),
(2, 1, 2, '2023-02-01', 1000000.00),
(3, 2, 1, '2023-03-01', 3000000.00),
(4, 2, 3, '2023-04-01', 200000.00);
