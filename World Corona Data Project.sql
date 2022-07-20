--Data analysis on World Coronavirus (COVID 19) Deaths Statistics using Microsoft SQL

select * from CoronaDataProject..CovidDeaths where continent is not null order by 3, 4



select * from CoronaDataProject..CovidVaccinations order by 3, 4



select location, date, total_cases, new_cases, total_deaths, population from CovidDeaths order by 1,2



select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage from CovidDeaths where location like 'ind%' order by 1, 2 



select location, date, population, total_cases, (total_cases/population)*100 as DeathPercentage from CovidDeaths where location like 'ind%' order by 1, 2



select location, population from CovidDeaths where location like 'india' order by population



select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected from CovidDeaths group by location, population order by 1,2



select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected from CovidDeaths group by location, population order by PercentPopulationInfected desc



select location, MAX(cast (Total_deaths as int)) as TotalDeathCount From CovidDeaths where continent is not null group by location order by TotalDeathCount desc



select continent, MAX(cast(total_deaths as int)) as TotalDeathCount from CovidDeaths where continent is not null group by continent order by TotalDeathCount desc



select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage from CovidDeaths where continent is not null group by date order by 1,2



select * from CovidDeaths dea join CovidVaccinations vac on dea.location = vac.location and dea.date = vac.date



select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations from CovidDeaths dea join CovidVaccinations vac on dea.location = vac.location and dea.date = vac.date where dea.continent is not null order by 1,2,3



select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations from CovidDeaths dea join CovidVaccinations vac on dea.location = vac.location and dea.date = vac.date where dea.continent is not null order by 1,2,3



select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated 
from CovidDeaths dea join CovidVaccinations vac on dea.location = vac.location and dea.date = vac.date where dea.continent is not null order by 2,3



with PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated) as 
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated 
from CovidDeaths dea join CovidVaccinations vac on dea.location = vac.location and dea.date = vac.date where dea.continent is not null)
select *, (RollingPeopleVaccinated/Population)*100 as VaccinatedPercent from PopvsVac