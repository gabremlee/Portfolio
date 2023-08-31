CREATE TABLE EmployeeErrors (
    EmployeeID varchar(50),
    FirstName varchar(50),
    LastName varchar(50)
)
 
-- Using Trim, Ltrim and Rtrim
select EmployeeId, TRIM(EmployeeID) as IDTRIM
from EmployeeErrors
select EmployeeId, LTRIM(EmployeeID) as IDTRIM
from EmployeeErrors
select EmployeeId, RTRIM(EmployeeID) as IDTRIM
from EmployeeErrors

-- Using Replace
select LastName, REPLACE(LastName, '- Fired', '') as LastNameFixed
from EmployeeErrors

--Using Substring
select SUBSTRING(FirstName,1,3)
from EmployeeErrors

select err.FirstName, dem.FirstName
from EmployeeErrors err
join EmployeeDemographics dem
    on SUBSTRING(err.FirstName,1,3) = SUBSTRING(dem.FirstName,1,3)


-- Using Upper and Lower
select Upper(FirstName)
from EmployeeErrors