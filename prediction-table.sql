CREATE TABLE prediction.profession (
id SERIAL PRIMARY KEY,
firstName varchar(50),
lastName varchar(50),
sex varchar(50),
doj date,
currentDate date,
designation varchar(50),
age int,
salary int,
unit varchar(50),
leavesUsed int,
leavesRemaining int,
ratings int,
pastExp int
);

COPY prediction.profession(firstName,lastName,sex,doj,currentDate,designation,age,salary,unit,leavesUsed,leavesRemaining,ratings,pastExp) from 'C:\Users\user\Downloads\archive\Salary Prediction of Data Professions.csv' DELIMITER ',' CSV HEADER;
SELECT * FROM prediction.profession ORDER BY id ASC;

-- Common Table Expressions (CTEs):
-- Question 1: Calculate the average salary by department for all Analysts.
WITH analyst_avg_salary AS
(
	SELECT p.unit, ROUND(AVG(p.salary)) FROM prediction.profession p
	WHERE p.designation = 'Analyst'
	GROUP BY p.unit
)
	SELECT * FROM analyst_avg_salary;
	
-- Question 2: List all employees who have used more than 10 leaves.
WITH employee_with_used_leaves AS
(
	SELECT * FROM prediction.profession p
	WHERE p.leavesused>10
)
	SELECT * FROM employee_with_used_leaves;
	
	
-- Views:
-- Question 3: Create a view to show the details of all Senior Analysts.
CREATE VIEW prediction.senior_analyst_details AS 
SELECT * FROM prediction.profession
WHERE designation = 'Senior Analyst'
;
SELECT * FROM senior_analyst_details;

-- Materialized Views:
-- Question 4: Create a materialized view to store the count of employees by department.
CREATE MATERIALIZED VIEW prediction.employee_count AS 
SELECT p.unit,COUNT(p.id) FROM prediction.profession p
GROUP BY p.unit;
SELECT * FROM employee_count;

-- Procedures (Stored Procedures):
-- Question 6: Create a procedure to update an employee's salary by their first name and last name.
CREATE OR REPLACE PROCEDURE update_salary_by_name(
   first_name VARCHAR(50),
   last_name VARCHAR(50), 
   updated_salary int
)
LANGUAGE plpgsql    
AS $$
BEGIN
    UPDATE prediction.profession p
    SET salary = updated_salary 
    WHERE first_name = p.firstname AND last_name = p.lastname;
	
    COMMIT;
END;$$;

CALL update_salary_by_name('TOMASA','ARMEN',10000);

-- Question 7: Create a procedure to calculate the total number of leaves used across all departments.
CREATE OR REPLACE PROCEDURE prediction.total_leaves()
LANGUAGE plpgsql    
AS $$
BEGIN
	CREATE VIEW prediction.total_leaves_view AS
	SELECT SUM(leavesUsed) FROM prediction.profession;
END;$$;

CALL prediction.total_leaves();
SELECT * FROM prediction.total_leaves_view;