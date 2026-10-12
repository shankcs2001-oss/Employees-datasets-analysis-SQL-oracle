-------------------------Basic---------------------------
--Display all employees.
SELECT * FROM EMPLOYEES;

--Find employees from the IT department.
SELECT * FROM EMPLOYEES
WHERE DEPARTMENT ='IT';

--Find employees earning more than 100,000.
SELECT FULLNAME 
FROM EMPLOYEES
WHERE ANNUAL_SAL > 100000;

--Find employees hired after 2020.
SELECT FULLNAME 
FROM EMPLOYEES
WHERE HIRE_DATE > date '2019-12-31';

--Sort employees by salary from highest to lowest.
SELECT FULLNAME, ANNUAL_SAL
FROM EMPLOYEES
ORDER BY ANNUAL_SAL DESC;

---------------------Intermediate------------------------
--Count total employees.
SELECT COUNT(*) FROM EMPLOYEES;

--Find average, maximum, and minimum salary.
SELECT AVG(ANNUAL_SAL)AS AVG_SAL, MAX(ANNUAL_SAL) AS MAX_SAL, MIN(ANNUAL_SAL)AS MIN_SAL
FROM EMPLOYEES;

--Count employees in each department.
SELECT DEPARTMENT, COUNT(*)
FROM EMPLOYEES
GROUP BY DEPARTMENT;

--Find average salary for each department.
SELECT DEPARTMENT, AVG(ANNUAL_SAL)
FROM EMPLOYEES
GROUP BY DEPARTMENT;

--Find departments having more than 2 employees.
SELECT DEPARTMENT ,COUNT(*) AS COUNT_EMP
FROM EMPLOYEES
GROUP BY DEPARTMENT
HAVING COUNT(*)>2;

--Find the highest-paid employee.
SELECT FULLNAME 
FROM EMPLOYEES
WHERE ANNUAL_SAL >= (SELECT MAX(ANNUAL_SAL) FROM EMPLOYEES);

--Find employees earning above the overall average salary.
SELECT FULLNAME,ANNUAL_SAL FROM EMPLOYEES
WHERE ANNUAL_SAL>(SELECT AVG(ANNUAL_SAL) FROM EMPLOYEES);

-----------------------Advanced--------------------------
--Find the second-highest salary.
SELECT FULLNAME,ANNUAL_SAL
FROM EMPLOYEES
WHERE ANNUAL_SAL=(SELECT MAX(ANNUAL_SAL) FROM EMPLOYEES
                  WHERE ANNUAL_SAL < (SELECT MAX(ANNUAL_SAL) FROM EMPLOYEES));
                  
--Find the highest-paid employee in each department.
SELECT DEPARTMENT, FULLNAME,ANNUAL_SAL AS HIGHEST_PAID
FROM EMPLOYEES
WHERE (DEPARTMENT,ANNUAL_SAL) IN(SELECT DEPARTMENT,MAX(ANNUAL_SAL) FROM EMPLOYEES GROUP BY DEPARTMENT);

--Find employees earning more than their department's average salary.   //correlated subquery
SELECT FULLNAME,DEPARTMENT,ANNUAL_SAL
FROM EMPLOYEES E1  
WHERE ANNUAL_SAL > (SELECT AVG(ANNUAL_SAL) 
                    FROM EMPLOYEES E2 
                    WHERE E2.DEPARTMENT = E1.DEPARTMENT);
                    
--Rank employees by salary within each department.
SELECT FULLNAME,DEPARTMENT,ANNUAL_SAL,
DENSE_RANK() OVER(PARTITION BY DEPARTMENT ORDER BY ANNUAL_SAL DESC) AS RANK
FROM EMPLOYEES;

--Find the top 2 highest-paid employees in each department.
SELECT FULLNAME, DEPARTMENT, ANNUAL_SAL
FROM EMPLOYEES E
WHERE ANNUAL_SAL >= (SELECT MAX(ANNUAL_SAL) FROM EMPLOYEES E2
                     WHERE E2.DEPARTMENT = E.DEPARTMENT);
                     
--Use a CTE to calculate department-wise average salary and filter departments above 100,000.
WITH DEPART_WISE AS(
             SELECT DEPARTMENT, AVG(ANNUAL_SAL) AS AVG_ANNUAL_SAL
             FROM EMPLOYEES
             GROUP BY DEPARTMENT)
             
SELECT DEPARTMENT,AVG_ANNUAL_SAL
FROM DEPART_WISE
WHERE AVG_ANNUAL_SAL > 100000;

