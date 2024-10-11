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

    -- Добавление внешнего ключа для таблицы Contracts
    ALTER TABLE Contracts 
    ADD CONSTRAINT fk_client
    FOREIGN KEY (client_id) 
    REFERENCES Clients(client_id) 
    ON DELETE CASCADE; -- Удалить договоры, если клиент удалён
    
    ALTER TABLE Contracts 
    ADD CONSTRAINT fk_product
    FOREIGN KEY (product_id) 
    REFERENCES FinancialProducts(product_id) 
    ON DELETE CASCADE; -- Удалить договоры, если продукт удалён




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
WHERE type = 'Депозиты' AND bet::numeric BETWEEN 4.0 AND 6.0;

--6. Рассчитать общую сумму всех договоров для каждого клиента и записать результаты.
--- создание новой таблицы?

--7.Определите, сколько договоров было заключено по каждому типу финансовых продуктов.!!!!!
--создание новой таблицы?

--8.Выведите клиентов, которые заключили договора на сумму, превышающую определённое значение.
SELECT c.client_id, c.name, c.surname, c.address, c.phone_number, c.email
FROM Clients c, Contracts ct
WHERE c.client_id = ct.client_id
GROUP BY c.client_id, c.name, c.surname, c.address, c.phone_number, c.email
HAVING SUM(ct.total_sum::numeric) > 1000000;


--9. Обновите условия депозитов для одного из типов финансовых продуктов.
UPDATE FinancialProducts
SET conditions = 'Обновленные усл'
WHERE type = 'Депозиты';

--10. Удалите записи о договорах, которые были заключены более года назад.
DELETE FROM Contracts
WHERE date_of_conclusion < (CURRENT_DATE - INTERVAL '1 year');


--11. Найдите договора по кредитам с определёнными условиями.
---


--12. Выведите первые пять записей о заключённых договорах, пропустив несколько первых записей.
SELECT contract_id, client_id, product_id, date_of_conclusion , total_sum
FROM Contracts
ORDER BY date_of_conclusion 
LIMIT 5 OFFSET 2;


--13. Подсчитайте среднюю сумму депозитов для каждого клиента и запишите результаты.
SELECT client_id, AVG(total_sum::numeric) AS average_deposit
FROM Contracts
GROUP BY client_id;


--14. Отсортируйте договора по дате их заключения, используя только данные из одной таблицы.
SELECT contract_id, client_id, product_id, date_of_conclusion , total_sum 
FROM Contracts
ORDER BY date_of_conclusion;

--15. Выведите список клиентов, заключивших наибольшее количество договоров.
---








