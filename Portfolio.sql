-- SELECT * FROM CovidVaccinations
-- SELECT * FROM CovidDeaths

Select Location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER by 1,2


-- looking at total cases vs total deaths
SELECT Location, date, total_cases, total_deaths, ((CAST(total_deaths as float))/total_cases)*100 as DeathPerc
from CovidDeaths
where location like '%states%'
ORDER by 1,2


-- looking at total cases vs population
-- shows what perc of the populations got covid
SELECT Location, date, total_cases, population, ((CAST(total_cases as float))/population)*100 as infected
from CovidDeaths
-- where location like '%states%'
ORDER by 1,2

--countries with highest infection rate compared to population

SELECT Location, population, MAX(total_cases) as highestInfection, MAX(((CAST(total_deaths as float))/total_cases))*100 as percentOfPopInfected
from CovidDeaths
GROUP BY location, population
ORDER by percentOfPopInfected DESC


-- countries with the highest death count per population

SELECT location, MAX(Total_deaths) as TotalDeathcount
from CovidDeaths
where continent is not null
GROUP by location
ORDER BY TotalDeathcount DESC

-- LET'S BREAK THING DOWN BY CONINENT

SELECT location, MAX(Total_deaths) as TotalDeathcount
from CovidDeaths
where continent is null
GROUP by location
ORDER BY TotalDeathcount DESC


-- showing the continent with the highest death count
select continent, Max(Total_deaths) 
from CovidDeaths
where continent is not NULL
group by continent

-- Global numbers 

SELECT SUM(cast(new_cases as int)) as totalCase, SUM(new_deaths) as totaldeath, (SUM(new_deaths)/SUM(CAST(new_cases as float)))*100 as deathperc
from CovidDeaths
-- where location like '%states%'
where continent is not null
-- GROUP by date
ORDER by 1,2



-- looking at total population vs vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated,
from CovidDeaths dea
join CovidVaccinations vac
    on dea.location =vac.location
    and dea.date = vac.date
where dea.continent is not NULL
order by 1,2,3

-- USE CTE
with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
    on dea.location =vac.location
    and dea.date = vac.date
where dea.continent is not NULL
--order by 1,2,3
)

select *, (CAST(RollingPeopleVaccinated as int)/CAST(population as float))*100
FROM PopvsVac


--USING TEMP TABLE
DROP TABLE if EXISTS #percentPopulationVaccinated
CREATE TABLE #percentPopulationVaccinated
(
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    DATE DATETIME,
    population NUMERIC,
    New_vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
)

INSERT INTO #percentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
    on dea.location =vac.location
    and dea.date = vac.date
where dea.continent is not NULL
--order by 1,2,3

select *, (CAST(RollingPeopleVaccinated as int)/CAST(population as float))*100
FROM #percentPopulationVaccinated



-- creating view to store data for later visualization

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
    on dea.location =vac.location
    and dea.date = vac.date
where dea.continent is not NULL
-- order by 1,2,3

SELECT * from PercentPopulationVaccinated