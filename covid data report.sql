select * from PortfolioProject..coviddeaths
WHERE continent is not null
order by 3,4
select * from PortfolioProject..CovidVaccinations
order by 3,4

select location, date, total_cases, new_cases, total_deaths,population
from PortfolioProject..coviddeaths
order by 1,2

-- LOOKING AT TOTAL CASES VS TOTAL DEATHS
-- SHOWS LIKLIHOOD OF DYING IF CONTRACT COVID IN INDIA OR ANY OTHER STATES

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_percentage
from PortfolioProject..coviddeaths
where location like'%india%'
order by 1,2

-- TOTAL CASES VS POPULATION
-- SHOWS WHAT PERCENTAGE OF POPULATION GOT COVID

select location, date, total_cases, POPULATION, (total_cases/POPULATION)*100 as Death_percentage
from PortfolioProject..coviddeaths
where location like'%india%'
order by 1,2

--LOOKING AT COUNTRY WITH HIGHEST INFECTION RATE COMPARED TO POPULATION

select location, population, MAX (total_cases) as Highest_infection_count,
max((total_cases/POPULATION)*100) as Percent_of_population_infected
from PortfolioProject..coviddeaths
--where location like'%india%'
group by location , population
order by Percent_of_population_infected desc

-- SHOWING THE COUNTRIES WITH THE HIGHEST DEATH COUNT PER POPULATION

select location, population, MAX (CAST(total_deaths AS INT)) as TOTAL_DEATH_count
from PortfolioProject..coviddeaths
--where location like'%india%'
WHERE continent is not null
group by location , population
order by TOTAL_DEATH_count desc

-- BREAKING DOWN THE DATA WITH RESPECT TO THE CONTINENTS
-- SHWOING THE CONTINENT WITH THE HIGHEST DEATH COUNT

select location, MAX (CAST(total_deaths AS INT)) as TOTAL_DEATH_count
from PortfolioProject..coviddeaths
--where location like'%india%'
WHERE continent is  null
group by location
order by TOTAL_DEATH_count desc

-- GLOBAL NUMBERS
select  date SUM( new_cases) , SUM(CAST(NEW_DEATHS AS INT)) , SUM(CAST (NEW_DEATHs as int ))/SUM(NEW_CASES)*100  AS  Death_percentage
from PortfolioProject..coviddeaths
--where location like'%india%'
WHERE continent IS NOT NULL 
GROUP BY date
order by 1,2

-- TOTAL CASES 
select SUM( new_cases) AS TOTAL_CASES , SUM(CAST(NEW_DEATHS AS INT)) AS TOTAL_DEATHS , 
SUM(CAST (NEW_DEATHs as int ))/SUM(NEW_CASES)*100  AS  Death_percentage
from PortfolioProject..coviddeaths
--where location like'%india%'
--WHERE continent IS NOT NULL 
--GROUP BY date
order by 1,2

select*from
PortfolioProject..CovidVaccinations

-- join the tables and looking at total population vs vaccines
select*from
PortfolioProject..coviddeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date=vac.date

select 
dea.continent , dea.location , dea.date , dea.population ,
vac.new_vaccinations
from PortfolioProject..coviddeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date=vac.date
where dea.continent is not null 
order by 2,3

-- to add the vaccine deatails
With PopvsVac (Continent, location, date, population , new_vaccinations , rolling_vaccination)
as
(
select 
dea.continent , dea.location , dea.date , dea.population ,
vac.new_vaccinations , 
sum(convert(int , vac.new_vaccinations ))
over (partition by dea.LoCAtion ORDER BY DEA.LOCATION, dea.date) as rolling_vaccination
--(rolling_vaccination/population)*100
From PortfolioProject..coviddeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date=vac.date
where dea.continent is not null 
)
select * , (rolling_vaccination/population)*100
from PopvsVac

-- using cte in above
-- with population vs vaccine(continent , location, rolling_vaciine)

--temp table

drop table if exists #percent_population_vaccinate
create table #percent_population_vaccinate
(continent nvarchar (255),
loaction nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
rolling_vaccination numeric
)
insert into #percent_population_vaccinate


select 
dea.continent , dea.location , dea.date , dea.population ,
vac.new_vaccinations , 
sum(convert(int , vac.new_vaccinations ))
over (partition by dea.LoCAtion ORDER BY DEA.LOCATION, dea.date) as rolling_vaccination
--(rolling_vaccination/population)*100
From PortfolioProject..coviddeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date=vac.date
--where dea.continent is null

select * , (rolling_vaccination/population)*100
from #percent_population_vaccinate

--createing views to store data for later visualization

create view percent_population_vaccinate as 
select 
dea.continent , dea.location , dea.date , dea.population ,
vac.new_vaccinations , 
sum(convert(int , vac.new_vaccinations ))
over (partition by dea.LoCAtion ORDER BY DEA.LOCATION, dea.date) as rolling_vaccination
--(rolling_vaccination/population)*100
From PortfolioProject..coviddeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date=vac.date
where dea.continent is null
--order by 2,3































