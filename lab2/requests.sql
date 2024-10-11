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

    --Изменение таблиц:
   -- Изменение имени столбца я некорректно указала имя аттрибута
   ALTER TABLE contracts 
   RENAME COLUMN data TO date_of_conclusion;
    -- Изменение типа данных аттрибута
    ALTER TABLE contracts 
    ALTER COLUMN total_sum TYPE money 
    USING (total_sum::numeric::money);

    -- Изменение типа данных аттрибута
    ALTER TABLE financialproducts 
    ALTER COLUMN bet TYPE money 
    USING (bet::numeric::money);




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

-- Задания
-- 3. Вывести список всех клиентов, отсортированных по сумме заключённых договоров.
--можно решить двумя селектами либо джоином

-- 4. Найти клиентов, которые заключили договора в определённый период времени.
SELECT DISTINCT name, surname, address, phone_number, email
FROM Clients, Contracts
WHERE Clients.client_id = Contracts.client_id
AND contracts.date_of_conclusion BETWEEN '2023-01-01' AND '2023-12-31';

--5. Вывести депозиты с условиями, попадающими в указанные границы.
SELECT product_id, type, conditions, bet
FROM FinancialProducts
WHERE тип = 'Депозиты' AND bet BETWEEN 4.0 AND 6.0;

--6. Рассчитать общую сумму всех договоров для каждого клиента и записать результаты.
CREATE TABLE TotalSumContracts AS
SELECT client_id, SUM(сумма) AS total_sum
FROM Contracts
GROUP BY client_id;

--7.Определите, сколько договоров было заключено по каждому типу финансовых продуктов.!!!!!
CREATE TABLE NumContractsByProduct AS
SELECT product_id, (SELECT COUNT(*) FROM Contracts WHERE Contracts.product_id = FinancialProducts.product_id) AS num_contracts
FROM FinancialProducts;

--8.Выведите клиентов, которые заключили договора на сумму, превышающую определённое значение.
SELECT client_id, name, surname, address, phone_number, email
FROM Clients
WHERE client_id IN (
    SELECT client_id
    FROM Contracts
    GROUP BY client_id
    HAVING SUM(total_sum) > 2000000
);

--9. Обновите условия депозитов для одного из типов финансовых продуктов.
UPDATE FinancialProducts
SET conditions = 'Обновленные усл'
WHERE type = 'Депозиты';

--10. Удалите записи о договорах, которые были заключены более года назад.
DELETE FROM Contracts
WHERE data < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

--11. Найдите договора по кредитам с определёнными условиями.!!!!!!!!
SELECT contract_id, client_id, product_id, data, total_sum
FROM Contracts
WHERE product_id IN (
    SELECT product_id
    FROM FinancialProducts
    WHERE тип = 'Кредиты' AND ставка < 12.0
);

--12. Выведите первые пять записей о заключённых договорах, пропустив несколько первых записей.
SELECT contract_id, client_id, product_id, дата заключения, total_sum
FROM Contracts
ORDER BY data
LIMIT 5 OFFSET 2;

--13. Подсчитайте среднюю сумму депозитов для каждого клиента и запишите результаты.!!!!!
CREATE TABLE AverageDeposits AS
SELECT client_id, AVG(сумма) AS avg_deposit
FROM Contracts
WHERE product_id IN (
    SELECT product_id
    FROM FinancialProducts
    WHERE тип = 'Депозиты'
)
GROUP BY client_id;

--14. Отсортируйте договора по дате их заключения, используя только данные из одной таблицы.
SELECT contract_id, client_id, product_id, дата заключения, сумма
FROM Contracts
ORDER BY data;

--15. Выведите список клиентов, заключивших наибольшее количество договоров.
SELECT client_id, name, surname, address, phone_number, email
FROM Clients
WHERE client_id IN (
    SELECT client_id
    FROM Contracts
    GROUP BY client_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);








