/*

Today's Topic: Stored Procedures

*/

-- CREATE PROCEDURE TEST
-- AS
-- Select * 
-- FROM EmployeeDemographics


-- EXEC TEST

CREATE PROCEDURE Temp_Employee
AS
DROP TABLE IF EXISTS #temp_employee
Create table #temp_employee (
JobTitle varchar(100),
EmployeesPerJob int ,
AvgAge int,
AvgSalary int
)


Insert into #temp_employee
SELECT JobTitle, Count(JobTitle), Avg(Age), AVG(salary)
FROM SQLTutorial..EmployeeDemographics emp
JOIN SQLTutorial..EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
group by JobTitle

select *
from #temp_employee


EXEC Temp_Employee @JobTitle = 'Salesman'