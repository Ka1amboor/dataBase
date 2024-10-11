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
