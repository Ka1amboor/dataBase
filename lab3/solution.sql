
--Вывести для каждой компании средний возраст всех сотрудников, 
--количество женщин и мужчин и распределение по должностям

--join
SELECT 
    c.name AS company_name,
    AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, e.date_of_birth))) AS average_age,
    COUNT(CASE WHEN e.gender = 'ж' THEN 1 END) AS female_count,
    COUNT(CASE WHEN e.gender = 'м' THEN 1 END) AS male_count,
    p.name AS position_name
FROM 
    companies c
JOIN 
    employees e ON c.company_id = e.company_id
JOIN 
    positions p ON e.position_id = p.position_id
GROUP BY 
    c.name, p.name
ORDER BY 
    c.name, p.name;


--подзапросы
SELECT 
    c.name AS company_name,
    (SELECT AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, e1.date_of_birth)))
     FROM employees e1
     WHERE e1.company_id = c.company_id) AS average_age,
    (SELECT COUNT(*)
     FROM employees e2
     WHERE e2.company_id = c.company_id AND e2.gender = 'ж') AS female_count,
    (SELECT COUNT(*)
     FROM employees e3
     WHERE e3.company_id = c.company_id AND e3.gender = 'м') AS male_count,
    p.name AS position_name,
    (SELECT COUNT(*)
     FROM employees e4
     WHERE e4.company_id = c.company_id AND e4.position_id = p.position_id) AS position_count
FROM 
    companies c
JOIN 
    positions p ON p.position_id IN (SELECT position_id FROM employees WHERE company_id = c.company_id)
ORDER BY 
    c.name, p.name;

--Для каждого сотрудника вывести максимальное и среднее время отпуска, 
--а также максимальное и среднее время командировок. 
--Также нужно вывести наиболее частое направление для командировок.
--join
SELECT 
    e.name AS employee_name,
    e.surname AS employee_surname,
    COALESCE(MAX(vac.date_of_end - vac.date_of_start), 0) AS max_vacation_days,
    COALESCE(AVG(vac.date_of_end - vac.date_of_start), 0) AS avg_vacation_days,
    COALESCE(MAX(bt.date_of_end - bt.date_of_start), 0) AS max_trip_days,
    COALESCE(AVG(bt.date_of_end - bt.date_of_start), 0) AS avg_trip_days,
    COALESCE(
        (SELECT bt1.direction
         FROM business_trips bt1
         WHERE bt1.employee_id = e.employee_id
         GROUP BY bt1.direction
         ORDER BY COUNT(bt1.direction) DESC
         LIMIT 1), 'Нет') AS frequent_trip_direction
FROM 
    employees e
LEFT JOIN 
    vacations vac ON e.employee_id = vac.employee_id
LEFT JOIN 
    business_trips bt ON e.employee_id = bt.employee_id
GROUP BY 
    e.employee_id;

--select
SELECT 
    e.name AS employee_name,
    e.surname AS employee_surname,
    (SELECT COALESCE(MAX(vac.date_of_end - vac.date_of_start), 0)
     FROM vacations vac
     WHERE vac.employee_id = e.employee_id) AS max_vacation_days,
    (SELECT COALESCE(AVG(vac.date_of_end - vac.date_of_start), 0)
     FROM vacations vac
     WHERE vac.employee_id = e.employee_id) AS avg_vacation_days,
    (SELECT COALESCE(MAX(bt.date_of_end - bt.date_of_start), 0)
     FROM business_trips bt
     WHERE bt.employee_id = e.employee_id) AS max_trip_days,
    (SELECT COALESCE(AVG(bt.date_of_end - bt.date_of_start), 0)
     FROM business_trips bt
     WHERE bt.employee_id = e.employee_id) AS avg_trip_days,
    (SELECT COALESCE(direction, 'Нет')
     FROM (
         SELECT bt1.direction
         FROM business_trips bt1
         WHERE bt1.employee_id = e.employee_id
         GROUP BY bt1.direction
         ORDER BY COUNT(bt1.direction) DESC
         LIMIT 1
     ) AS frequent_direction) AS frequent_trip_direction
FROM 
    employees e;


--Вывести рейтинг компании по средней продолжительности работы сотрудников.
--- я забыла вставить в таблицу начало работы ;(






--Для каждой компании вывести интервал, когда больше всего работников находилось в отпуске, 
--а также количество сотрудников в отпуске и на работе в этот момент.
--join
WITH vacation_intervals AS (
    SELECT
        e.company_id,
        v.date_of_start,
        v.date_of_end,
        COUNT(e.employee_id) AS num_on_vacation
    FROM 
        employees e
    JOIN 
        vacations v ON e.employee_id = v.employee_id
    GROUP BY 
        e.company_id, v.date_of_start, v.date_of_end
),
max_vacation_intervals AS (
    SELECT 
        vi.company_id,
        MAX(vi.num_on_vacation) AS max_on_vacation
    FROM 
        vacation_intervals vi
    GROUP BY 
        vi.company_id
)
SELECT 
    c.name AS company_name,
    vi.date_of_start,
    vi.date_of_end,
    vi.num_on_vacation,
    COUNT(e.employee_id) - vi.num_on_vacation AS num_not_on_vacation
FROM 
    vacation_intervals vi
JOIN 
    max_vacation_intervals mv ON vi.company_id = mv.company_id AND vi.num_on_vacation = mv.max_on_vacation
JOIN 
    companies c ON vi.company_id = c.company_id
JOIN 
    employees e ON e.company_id = c.company_id
GROUP BY 
    c.name, vi.date_of_start, vi.date_of_end, vi.num_on_vacation
ORDER BY 
    c.name;


--select
SELECT 
    c.name AS company_name,
    vi.date_of_start,
    vi.date_of_end,
    vi.num_on_vacation,
    total_employees.num_employees - vi.num_on_vacation AS num_not_on_vacation
FROM 
    (
        SELECT
            e.company_id,
            v.date_of_start,
            v.date_of_end,
            COUNT(e.employee_id) AS num_on_vacation
        FROM 
            employees e
        JOIN 
            vacations v ON e.employee_id = v.employee_id
        GROUP BY 
            e.company_id, v.date_of_start, v.date_of_end
    ) AS vi
JOIN 
    (
        SELECT 
            company_id,
            MAX(num_on_vacation) AS max_on_vacation
        FROM 
            (
                SELECT
                    e.company_id,
                    COUNT(e.employee_id) AS num_on_vacation
                FROM 
                    employees e
                JOIN 
                    vacations v ON e.employee_id = v.employee_id
                GROUP BY 
                    e.company_id, v.date_of_start, v.date_of_end
            ) AS inner_vi
        GROUP BY 
            company_id
    ) AS mv ON vi.company_id = mv.company_id AND vi.num_on_vacation = mv.max_on_vacation
JOIN 
    companies c ON vi.company_id = c.company_id
JOIN 
    (
        SELECT 
            company_id,
            COUNT(employee_id) AS num_employees
        FROM 
            employees
        GROUP BY 
            company_id
    ) AS total_employees ON vi.company_id = total_employees.company_id
ORDER BY 
    c.name;

