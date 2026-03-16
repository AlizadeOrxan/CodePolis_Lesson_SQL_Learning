-- Yeni database yaradib oradan da davam etmek olar

CREATE DATABASE example_db;
DROP DATABASE IF EXISTS example_db;


DROP TABLE IF EXISTS departments CASCADE ;
DROP TABLE IF EXISTS employee_projects CASCADE ;
DROP TABLE IF EXISTS employees cascade ;
DROP TABLE IF EXISTS locations CASCADE ;
DROP TABLE IF EXISTS projects CASCADE ;



CREATE TABLE locations (
                           location_id INT PRIMARY KEY,
                           city VARCHAR(50) NOT NULL,
                           country VARCHAR(50) NOT NULL,
                           address VARCHAR(100)
);


CREATE TABLE departments (
                             department_id INT PRIMARY KEY,
                             department_name VARCHAR(50) NOT NULL,
                             location_id INT,
                             manager_id INT,
                             budget DECIMAL(12,2),
                             FOREIGN KEY (location_id) REFERENCES locations(location_id)
);


CREATE TABLE employees (
                           employee_id INT PRIMARY KEY,
                           first_name VARCHAR(50) NOT NULL,
                           last_name VARCHAR(50) NOT NULL,
                           email VARCHAR(100) UNIQUE,
                           hire_date DATE NOT NULL,
                           department_id INT,
                           manager_id INT,
                           job_title VARCHAR(100),
                           phone VARCHAR(20),
                           FOREIGN KEY (department_id) REFERENCES departments(department_id),
                           FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);


CREATE TABLE projects (
                          project_id INT PRIMARY KEY,
                          project_name VARCHAR(100) NOT NULL,
                          start_date DATE,
                          end_date DATE,
                          budget DECIMAL(12,2),
                          status VARCHAR(20) DEFAULT 'ACTIVE',
                          department_id INT,
                          FOREIGN KEY (department_id) REFERENCES departments(department_id)
);


CREATE TABLE employee_projects (
                                   employee_id INT,
                                   project_id INT,
                                   role VARCHAR(50),
                                   hours_allocated INT,
                                   PRIMARY KEY (employee_id, project_id),
                                   FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
                                   FOREIGN KEY (project_id) REFERENCES projects(project_id)
);


-- Insertionlar ederek her bir table-lara datalar veririk

-- locations uchun ( moterizede eger yazsaq ki , Insert Into locations(city,country) ve primary key-de serial olarsa , avtomatik artan olacaq )
INSERT INTO locations VALUES
                          (1,'Baku','Azerbaijan','Nizami 15'),
                          (2,'Ganja','Azerbaijan','Ataturk 22'),
                          (3,'Sumgait','Azerbaijan','Heydar 10'),
                          (4,'Istanbul','Turkey','Taksim 5');



-- department
INSERT INTO departments VALUES
                            (10,'IT',1,101,500000),
                            (20,'HR',1,102,200000),
                            (30,'Finance',2,103,300000),
                            (40,'Marketing',3,NULL,150000);

-- employees
INSERT INTO employees VALUES
                          (101,'Nicat','Aliyev','n@ex.com','2022-01-10',10,NULL,'Manager','050111'),
                          (102,'Aysel','Mammadova','a@ex.com','2022-03-12',20,101,'HR Lead','050222'),
                          (103,'Elvin','Hesenli','e@ex.com','2023-02-01',30,101,'Accountant','050333'),
                          (104,'Murad','Quliyev','m@ex.com','2023-05-10',10,101,'Developer','050444'),
                          (105,'Orxan','Ismayilov','o@ex.com','2024-01-01',NULL,NULL,'Freelancer','050555');

INSERT INTO employees(employee_id,salary) VALUES
                                              (101, 6000.00),
                                              (102, 4500.00),
                                              (103, 5200.00),
                                              (104, 3000.00),
                                              (105, 7000.00);

SELECT * FROM employees;
SELECT * FROM departments;

-- projects
INSERT INTO projects VALUES
                         (1001,'ERP System','2024-01-01',NULL,200000,'ACTIVE',10),
                         (1002,'HR Portal','2024-02-01',NULL,80000,'ACTIVE',20),
                         (1003,'Finance Audit','2023-10-01','2024-01-01',50000,'DONE',30),
                         (1004,'Ads Campaign','2024-03-01',NULL,60000,'ACTIVE',40);

-- employee_projects
INSERT INTO employee_projects VALUES
                                  (101,1001,'Lead',120),
                                  (104,1001,'Developer',160),
                                  (102,1002,'Coordinator',80),
                                  (103,1003,'Auditor',100);


-- En chox istifade olunan SQL commands .
-------------------------------

SELECT * FROM employees;
SELECT * FROM projects;
SELECT * FROM locations;
SELECT  * FROM employee_projects;
SELECT  * FROM departments;


-- WHERE
SELECT * FROM employees WHERE department_id = 10;
SELECT * FROM employees WHERE first_name = 'Orxan';

SELECT * FROM employees WHERE salary > 4000;
SELECT * FROM projects WHERE status = 'ACTIVE';
SELECT * FROM employees WHERE department_id IS NULL;

SELECT * FROM employees
WHERE department_id = 10 AND job_title = 'Developer';

SELECT * FROM projects
WHERE status = 'ACTIVE' AND budget > 100000;

SELECT * FROM employees
WHERE hire_date > '2023-01-01' AND department_id IS NOT NULL;

SELECT * FROM departments
WHERE budget > 200000 AND location_id = 1;

SELECT * FROM employees
WHERE department_id = 10 OR department_id = 20;

SELECT * FROM locations
WHERE city = 'Baku' OR country = 'Turkey';

-- Not istifadesi Logical olaraq
SELECT * FROM employees
WHERE NOT department_id = 20;

SELECT * FROM projects
WHERE NOT status = 'ACTIVE';

-- And ve Or istifadesi
SELECT * FROM projects
WHERE status = 'ACTIVE' AND budget > 50000
   OR department_id = 40;

SELECT * FROM employees
WHERE department_id = 20 OR department_id = 30
    AND hire_date > '2022-01-01';


-- Between ve And
SELECT * FROM employees WHERE hire_date BETWEEN '2023-01-01' AND '2024-01-01';

SELECT * FROM departments WHERE budget BETWEEN 150000 AND 400000;

SELECT * FROM employee_projects WHERE hours_allocated BETWEEN 80 AND 150;


-- In istifadesi

SELECT * FROM employees WHERE department_id IN (30,10);

SELECT * FROM projects WHERE status = 'DONE';

SELECT * FROM locations WHERE city IN ('Baku','Ganja');

SELECT * FROM employees WHERE last_name IN ('Aliyev','Quliyev');

-- Exist Not exist
SELECT * FROM departments d
WHERE EXISTS (
    SELECT 1 FROM projects p
    WHERE p.department_id = d.department_id
);

SELECT * FROM projects p
WHERE NOT EXISTS (
    SELECT 1 FROM employee_projects ep
    WHERE ep.project_id = p.project_id
);
-------------------------------


-- DISTINCT
SELECT DISTINCT department_id FROM employees;
SELECT * FROM employees;
SELECT DISTINCT city FROM locations;
SELECT DISTINCT job_title FROM employees;
SELECT DISTINCT status FROM projects;
SELECT * FROM projects;
-------------------------------


-- LIKE
SELECT * FROM employees WHERE first_name LIKE '%a%';--daxilinde
SELECT * FROM employees WHERE first_name LIKE 'E%'; -- bashlangicda
SELECT first_name, last_name FROM employees WHERE last_name LIKE '%v';--sonunda

SELECT * FROM projects WHERE project_name LIKE '%System%';
SELECT * FROM locations WHERE city LIKE '%a%';
SELECT * FROM employees WHERE email LIKE '%@ex.com';
-------------------------------


-- AS (Alias)

SELECT first_name AS adlar , last_name AS soyadlari FROM employees;
SELECT department_name AS dept FROM departments;
SELECT COUNT(*) AS total_emp FROM employees;
SELECT SUM(budget) AS total_budget FROM projects;


-------------------------------

-- ORDER BY
SELECT * FROM employees ORDER BY hire_date;
SELECT * FROM projects ORDER BY project_name ASC ;
SELECT * FROM employees ORDER BY department_id DESC;
SELECT * FROM locations ORDER BY city DESC ;

-------------------------------



-- COUNT
SELECT COUNT(*) FROM employees;
SELECT COUNT(*) FROM projects;
SELECT COUNT(department_id) FROM employees;
SELECT COUNT(DISTINCT department_id) FROM employees;
SELECT * FROM employees;


-------------------------------


-- SUM
SELECT SUM(budget) FROM projects;
SELECT SUM(hours_allocated) FROM employee_projects;
SELECT SUM(budget) FROM departments;
SELECT SUM(salary) FROM employees;
-------------------------------


-- GROUP BY
SELECT department_id, COUNT(*) FROM employees GROUP BY department_id;
SELECT status, COUNT(*) FROM projects GROUP BY status;
SELECT * FROM projects;
SELECT department_id, SUM(budget) FROM projects GROUP BY department_id;
SELECT location_id, COUNT(*) FROM departments GROUP BY location_id;
SELECT * FROM departments;
SELECT * FROM locations;
SELECT * FROM employees
-------------------------------


--INNER JOIN
SELECT e.first_name, d.department_name
FROM employees e
         INNER JOIN departments d ON e.department_id = d.department_id;

SELECT p.project_name, d.department_name
FROM projects p
         INNER JOIN departments d ON p.department_id = d.department_id;

SELECT ep.employee_id, p.project_name
FROM employee_projects ep
         INNER JOIN projects p ON ep.project_id = p.project_id;

SELECT e.first_name, l.city
FROM employees e
         INNER JOIN departments d ON e.department_id = d.department_id
         INNER JOIN locations l ON d.location_id = l.location_id;
-------------------------------


--  LEFT JOIN
SELECT e.first_name, d.department_name
FROM employees e LEFT JOIN departments d
                           ON e.department_id = d.department_id;

SELECT d.department_name, p.project_name
FROM departments d LEFT JOIN projects p
                             ON d.department_id = p.department_id;

SELECT e.first_name, ep.project_id
FROM employees e LEFT JOIN employee_projects ep
                           ON e.employee_id = ep.employee_id;

SELECT d.department_name, l.city
FROM departments d LEFT JOIN locations l
                             ON d.location_id = l.location_id;
-------------------------------


-- RIGHT JOIN
SELECT e.first_name, d.department_name
FROM employees e RIGHT JOIN departments d
                            ON e.department_id = d.department_id;

SELECT p.project_name, d.department_name
FROM projects p RIGHT JOIN departments d
                           ON p.department_id = d.department_id;

SELECT ep.employee_id, p.project_name
FROM employee_projects ep RIGHT JOIN projects p
                                     ON ep.project_id = p.project_id;

SELECT d.department_name, l.city
FROM locations l RIGHT JOIN departments d
                            ON l.location_id = d.location_id;
-------------------------------


-- MULTIPLE JOIN (3+ cedvel istifade ederek )
SELECT e.first_name, d.department_name, l.city
FROM employees e
         JOIN departments d ON e.department_id = d.department_id
         JOIN locations l ON d.location_id = l.location_id;

SELECT * FROM locations;
SELECT * FROM departments;



SELECT e.first_name,d.department_name , p.project_name,l.city
FROM employees e
         JOIN departments d ON e.department_id = d.department_id
         JOIN projects p ON d.department_id = p.department_id
         JOIN locations l ON d.location_id = l.location_id ;



SELECT e.first_name, p.project_name, ep.role
FROM employees e
         JOIN employee_projects ep ON e.employee_id = ep.employee_id
         JOIN projects p ON ep.project_id = p.project_id;

SELECT d.department_name, p.project_name, p.budget
FROM departments d
         JOIN projects p ON d.department_id = p.department_id
         JOIN locations l ON d.location_id = l.location_id;

SELECT e.first_name, d.department_name, p.project_name
FROM employees e
         JOIN departments d ON e.department_id = d.department_id
         JOIN projects p ON d.department_id = p.department_id;
-------------------------------


-- Having

-- Orta ish saati 100-den chox olan ishchiler
SELECT employee_id, AVG(hours_allocated)
FROM employee_projects
GROUP BY employee_id
HAVING AVG(hours_allocated) > 100;


-- Layihelere xerclenilmish umumi meblegin 5000 den chox olan shobeleri chixaracaq
SELECT department_id,SUM(budget)
FROM projects
GROUP BY department_id
HAVING SUM(budget) > 50000;

SELECT * FROM departments;
SELECT * FROM projects;

-- Layihesi olan shobeleri chixaraca q
SELECT d.department_name, COUNT(p.project_id)
FROM departments d
         LEFT JOIN projects p ON d.department_id = p.department_id
GROUP BY d.department_name
HAVING COUNT(p.project_id) > 0;


---------------------------------


--  UPDATE
UPDATE employees SET job_title='Senior Dev' WHERE first_name= 'Nicat';
SELECT *FROM employees;

UPDATE projects SET status='DONE' WHERE project_id=1001;
UPDATE departments SET budget=budget+50000 WHERE department_id=10;
UPDATE employees SET department_id=20 WHERE employee_id=105;

--  ALTER
ALTER TABLE employees ADD COLUMN salary DECIMAL(10,2);
ALTER TABLE employees DROP COLUMN phone;
ALTER TABLE projects ADD COLUMN priority INT;
ALTER TABLE departments ALTER COLUMN budget TYPE DECIMAL(14,2);

-- DELETE
DELETE FROM employees WHERE department_id IS NULL;
DELETE FROM projects WHERE status='DONE';
DELETE FROM employee_projects WHERE hours_allocated < 100;
DELETE FROM departments WHERE budget < 100000;
-------------------------------



