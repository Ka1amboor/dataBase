SELECT 
    c.name AS company_name,
    AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, e.date_of_birth))) AS average_age,
    COUNT(CASE WHEN e.gender = 'ж' THEN 1 END) AS female_count,
    COUNT(CASE WHEN e.gender = 'м' THEN 1 END) AS male_count,
    p.name AS position_name,
    COUNT(e.employee_id) AS position_count
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
