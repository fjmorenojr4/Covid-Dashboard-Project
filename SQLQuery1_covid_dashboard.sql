


-- Select *
--FRom Portfolio_Project..Covid_Vaccinations
--Order by 3,4


-- Select Data taht we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Portfolio_Project..Covid_Death
order by 1,2                      -- Orders by location and date

--Looking at total cases vs. total deaths
-- Shows the likelihood of dying if you contract Covid in your country
Select location, date, total_cases, total_deaths, (total_deaths/total_cases) *100 as DeathPercentage
FROM Portfolio_Project..Covid_Death
where location like '%States%'
Order by 1,2


-- Looking at total cases vs. population
-- Shows what percentage of population got Covid
Select location, date, total_cases, population, (total_cases/population) *100 as PercentPopulationInfected
FROM Portfolio_Project..Covid_Death
Order by 1,2


--Looking at Countries with Highest Infection Rate compared to Population
SELECT location, MAX(cast(total_cases as int)) as HighestInfectionCount, MAX((total_cases/population))*100 As percentpopulationinfected
FROM Portfolio_Project..Covid_Death
Group by location, population
Order by percentpopulationinfected desc

--Breaking numbers down by continent
Select location,MAX(cast(Total_deaths as int)) as TotalDeathCount
From Portfolio_Project..Covid_Death
where continent is null
group by location
order by TotalDeathCount desc



--Showing the countries with the Highest Death Count per Population
Select location, Max(cast(total_deaths as INT)) AS TotalDeathCount                     --Total Deaths value is Varchar need to cast to int
From Portfolio_Project..Covid_Death
Where continent is null                                                -- IF not null isnt entered it will show locations such as world and asia
and location like 'Asia'
or location like 'Africa'
or location like 'North America'
or location like 'South America'
or location like 'Europe'
or location like 'Oceania'
Group by Location
Order by TotalDeathCount desc



--Showing the continent with the highest death count per  population
Select location,MAX(cast(Total_deaths as int)) as TotalDeathCount
From Portfolio_Project..Covid_Death
where continent is null
group by location
order by TotalDeathCount desc

-- Global numbers

Select date,  SUM(new_cases) as total_cases, SUM(cast(New_deaths as int)) as total_deaths, SUM(cast(New_deaths as int))/Sum(New_cases)*100 as DeathPercentage
FROM Portfolio_Project..Covid_Death
--where location like '%States%'
where continent is not null
Group by date
Order by 1,2


-- Shows the death percentage around the world

Select   SUM(new_cases) as total_cases, SUM(cast(New_deaths as int)) as total_deaths, SUM(cast(New_deaths as int))/Sum(New_cases)*100 as DeathPercentage
FROM Portfolio_Project..Covid_Death
--where location like '%States%'
where continent is not null
Order by 1,2



--Joining of th two tables

SELECT *
FROM Portfolio_Project..Covid_Death dea
Join Portfolio_Project..Covid_Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date

	


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM Portfolio_Project..Covid_Death dea
Join Portfolio_Project..Covid_Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


--Looking at Total Population vs. Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Convert(bigint, vac.new_vaccinations)) OVER(Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From portfolio_project..Covid_Death dea
Join Portfolio_Project..Covid_Vaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
FROM Portfolio_Project..Covid_Death
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc