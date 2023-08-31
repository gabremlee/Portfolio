-- Topic:    Subqueries



select * 
From EmployeeSalary



-- In the Select 


select EmployeeID, Salary, (select AVG(Salary) from EmployeeSalary) as AllAverageSalary
From EmployeeSalary

-- How to do it with partition by

select EmployeeID, Salary, AVG(Salary) OVER (PARTITION By Salary) as Averagesalary
From EmployeeSalary


-- Why group BY doesnt work

select EmployeeID, Salary, AVG(Salary) Averagesalary
From EmployeeSalary
Group BY EmployeeID, Salary
ORDER BY 1,2

-- Subquery in the from

SELECT a.EmployeeID, AllAverageSalary
from (select EmployeeID, Salary, AVG(Salary) OVER () as AllAverageSalary
from EmployeeSalary) a

-- Subqueries in the where 

Select EmployeeID, JobTitle, Salary 
FROM EmployeeSalary
WHERE EmployeeID in (
    select EmployeeID
    from EmployeeDemographics
    WHERE Age > 30
)

