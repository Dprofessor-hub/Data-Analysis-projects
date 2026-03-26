-- SECTION A – DDL (Database Design)
--  1. Create database company_db.
-- 2. Create tables: departments, employees, projects, employee_project with proper Primary
-- Keys and Foreign Keys.
-- 3. Add NOT NULL, UNIQUE and CHECK constraints wherever applicable.
-- 4. Add an index on employee salary column.

-- created database for assigment 
CREATE DATABASE company_db;

-- used that database
USE company_db;

-- CREATING STRUCTURE FOR TABLE DEPARTMENT
CREATE TABLE department(
	dept_id INT NOT NULL,
    dept_name VARCHAR(50) NOT NULL,
    primary key(dept_id)
    );
    
-- imported data from csv file.
SELECT * FROM department;

-- CREATING STRUCTURE FOR TABLE EMPLOYEE
CREATE TABLE employee(
	emp_id INT NOT NULL,
    emp_name VARCHAR(30) NOT NULL,
    dept_id INT,
    designation VARCHAR(20) NOT NULL,
    salary FLOAT DEFAULT 0,
    hire_date DATE DEFAULT '2026-02-02',
    primary key(emp_id),
    FOREIGN KEY(dept_id) REFERENCES department(dept_id) ON DELETE CASCADE
);
-- imported data from csv file.

-- checking table is data is extracted or not
SELECT * FROM employee;

-- CREATING STRUCTURE FOR TABLE PROJECTS
CREATE TABLE project(
	pro_id INT NOT NULL,
    pro_name VARCHAR(30) NOT NULL,
    dept_id INT,
    budget INT DEFAULT 0,
    PRIMARY KEY(pro_id),
    FOREIGN KEY(dept_id) REFERENCES department(dept_id) ON DELETE CASCADE 	
);
-- imported data from csv file.

SELECT * FROM project;



-- CREATING STRUCTURE FOR TABLE EMPLOYEE PROJECT
CREATE TABLE employee_project(
	assign_id INT NOT NULL,
    emp_id INT,
    pro_id INT,
    hour_work INT,
    PRIMARY KEY(assign_id),
    FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(pro_id) REFERENCES project(pro_id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- imported data from csv file.

SELECT * FROM employee_project;

SELECT * FROM employee;
SELECT * FROM department;

-- CREATED INDEX FRO SMOOTH RETRIVAL OF RECORDS ON SALARY COLUMN.
CREATE INDEX idx_emp_sal ON employee(salary);




-- --------------------------------------------------------------------------------------------------------------------------------------
 
 
--  SECTION B – DML (Data Manipulation)
--  5. Insert at least 5 new employees manually.
--  6. Update salary of employees in IT department by 10%.
--  7. Delete employees who have salary less than 30000.
SELECT * FROM employee;

-- INSEARTING 5 ROWS INTO EMPLOYEE TABLE
INSERT INTO employee VALUES
(101,"Rajkumar Rao", 1,"Analyst",50000,curdate()),
(102,"jasmin Feranndis", 2,"Senior Analyst",100000,curdate()),
(103,"Fara Khan", 3,"Manager",80000,curdate()),
(104,"Amitab Bachachan", 4,"CEO",1500000,curdate()),
(105,"Shardha Kapoor", 5,"Engineer",100000,curdate());


-- ADDING SALARY OF EMPLOYEE IN EMPLOYEE TABLE BY 10%
UPDATE employee 
SET salary =  salary*1.10
where dept_id = (SELECT dept_id FROM department WHERE dept_name = "IT");

-- change the safe update mode to off because it is not allowing us to delete data from employee table.
SET sql_safe_updates = false;

-- DELETING EMPLOYEE WHERE SALARY IS LESS THAN 30000
DELETE  from employee where salary < 30000;

-- checking if data present or not in emplyee table or not
SELECT * FROM employee where salary < 30000;

--  checking if data is deleted or not from table 
SELECT count(*) FROM employee;




-- --------------------------------------------------------------------------------------------------------------------------------------


-- SECTION C – DQL (Queries)
-- 8. Display all employees hired after 2022.
--  9. Find average salary department-wise.
--  10. Find total hours worked per project.
--  11. Find highest paid employee in each department.

-- checking employee table
SELECT * FROM employee;
SELECT * FROM department;

-- Displayed all employee data where hired date is greater than 2022-01-01
SELECT * FROM employee where hire_date > '2022-01-01';

-- Find average salary department-wise.
SELECT d.dept_name, ROUND(AVG(e.salary),1) as avg_salary 
FROM employee as e
JOIN department as d
on e.emp_id = d.dept_id
GROUP BY d.dept_name
ORDER BY d.dept_name;

SELECT * FROM project;
SELECT * FROM employee_project;

-- Find total hours worked per project.
SELECT p.pro_name, sum(ep.hour_work) as total_hour FROM project as p
JOIN employee_project as ep
ON p.pro_id = ep.pro_id
GROUP BY p.pro_id
ORDER BY p.pro_id;

-- Find highest paid employee in each department.
SELECT e.emp_name, d.dept_name, e.salary 
FROM employee as e
JOIN department as d
	ON e.dept_id = d.dept_id
WHERE e.salary = (
	SELECT max(e2.salary) 
    FROM employee as e2
    WHERE e2.dept_id = e.dept_id
);




-- --------------------------------------------------------------------------------------------------------------------------------------


-- SECTION D – JOINS
--  12. Display employee name with department name.
-- 13. Show project name with total hours worked using JOIN.
-- 14. List employees who are not assigned to any project.

-- Display employee name with department name.
SELECT e.emp_id,e.emp_name, d.dept_name 
FROM employee as e
LEFT JOIN department as d
	on e.dept_id = d.dept_id
    ORDER BY d.dept_name;

-- Show project name with total hours worked using JOIN.
SELECT p.pro_name, sum(ep.hour_work) as total_hour FROM project as p
LEFT JOIN employee_project as ep
	ON p.pro_id = ep.pro_id
group by p.pro_name
order by p.pro_name;
    

-- List employees who are not assigned to any project.
SELECT e.* 
from employee as e
left join employee_project as ep
on e.emp_id = ep.emp_id
where ep.emp_id is null;




-- --------------------------------------------------------------------------------------------------------------------------------------



-- SECTION E – VIEWS
-- 15. Create a view showing department-wise total salary expense.
-- 16. Create a view for employees earning above average salary.

CREATE VIEW dept_salary_expense AS
SELECT 
	d.dept_name,
	ROUND(sum(e.salary),1) AS total_salary
FROM department AS d
LEFT JOIN employee AS e
	ON d.dept_id = e.dept_id
GROUP BY d.dept_name
ORDER BY d.dept_name asc;

--  Delete the view to modify changes
drop view dept_salary_expense;

-- checking if view is created or not successfully or not
select * from dept_salary_expense;


-- Create a view for employees earning above average salary.
create view employee_above_salary as
select e.*
from employee as e
where e.salary > (select avg(salary) from employee)
ORDER BY emp_name;

--  Delete the view to modify changes
DROP VIEW employee_above_salary;

-- checking if view is created or not successfully or not
select * from employee_above_salary;



-- --------------------------------------------------------------------------------------------------------------------------------------




-- SECTION F – STORED PROCEDURES & FUNCTIONS
-- 17. Create a stored procedure to get employees by department_id.
-- 18. Create a stored procedure to increase salary by given percentage.
-- 19. Create a function to calculate annual salary


-- This code is generated using stored procedures
-- 17. Create a stored procedure to get employees by department_id.

-- CREATE DEFINER=`root`@`localhost` PROCEDURE `get_employee_by_dept`(in p_dept_id int)
-- BEGIN
-- 	select * 
--     from employee as e 
--     where e.dept_id = p_dept_id;
-- END



-- This code is generated using stored procedures
-- 18. Create a stored procedure to increase salary by given percentage. BY GIVING employee id and increment value.

-- CREATE DEFINER=`root`@`localhost` PROCEDURE `increase_salary_by_input`(in id INT ,increment FLOAT)
-- BEGIN
-- 	UPDATE employee
--     SET salary = salary + (salary * increment /100)
--     WHERE emp_id = id;
-- END

-- 19. Create a function to calculate annual salary
-- This code is generated using functions directly
-- CREATE DEFINER=`root`@`localhost` FUNCTION `annual_salary`(p_salary float) RETURNS float
--     DETERMINISTIC
-- BEGIN
-- 	return p_salary*12;
-- END

-- checking if increment is done or not
SELECT * FROM employee;


-- --------------------------------------------------------------------------------------------------------------------------------------




-- SECTION G – WINDOW FUNCTIONS
-- 20. Rank employees based on salary within each department.
-- 21. Find second highest salary in each department.
-- 22. Calculate running total of salaries department-wise.

-- 20. Rank employees based on salary within each department.
SELECT e.emp_id, e.emp_name, d.dept_name, e.salary,
RANK() OVER(
PARTITION BY d.dept_id 
ORDER BY e.salary DESC) AS salary_rank
FROM 
employee AS e
LEFT JOIN department AS d
	ON e.dept_id = d.dept_id;


-- 21. Find second highest salary in each department.
SELECT * FROM 
	(SELECT 
		emp_id, emp_name, dept_id, salary,
		DENSE_RANK() 
		OVER(PARTITION BY dept_id
		ORDER BY salary DESC) AS rnk
	FROM employee) X
WHERE rnk = 2;

-- 22. Calculate running total of salaries department-wise.
SELECT e.emp_id,
e.emp_name,
d.dept_name,
e.salary,
SUM(e.salary)
OVER (PARTITION BY d.dept_id ORDER BY e.salary DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total 
FROM employee AS e
LEFT JOIN department AS d
	ON e.dept_id = d.dept_id;


select * FROM employee;
