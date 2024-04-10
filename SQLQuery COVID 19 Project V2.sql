Select Location,Date,population,MAX(total_cases) as HigestInfectionCount,(total_cases/population)*100 as PercentofPopulationGotCovid
From [Porfolio Project].[dbo].[CovidDeaths$]
--Where location like '%states%'
Group by Location,Date,population,total_cases
Order by   PercentofPopulationGotCovid Desc
--the highest total death of countries

Select Location,MAX(cast(total_deaths as int)) as HigestDeath
From [Porfolio Project].[dbo].[CovidDeaths$]
--Where location like '%states%'
Where continent is not null
Group by Location
Order by  HigestDeath  Desc

---Let's see the total death by continent 

Select continent,MAX(cast(total_deaths as int)) as HigestDeath
From [Porfolio Project].[dbo].[CovidDeaths$]
--Where location like '%states%'
Where continent is not null
Group by continent
Order by  HigestDeath  Desc


--Global Numbers

Select  SUM(new_cases ), SUM(cast(new_deaths as int)), SUM(cast(new_deaths as int))/SUM
(new_cases )*100 as DeathPercentage
From [Porfolio Project].[dbo].[CovidDeaths$]
--Where location like '%states%'
Where continent is not null
--Group by date
Order by  1,2


Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
Sum(cast(vac.new_vaccinations as int)) Over(Partition by dea.location order by dea.location , dea.date) as RollingVaccination
From [Porfolio Project].[dbo].[CovidDeaths$] as Dea Join [Porfolio Project].[dbo].[CovidVaccinations$] as Vac
On Dea.date=Vac.date and dea.location=vac.location
where dea.continent is not null
order by 2,3


-- Let's use CTE

With popvsVac (continent,location,date,population,new_vaccinations,RollingVaccination)
as
(
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
Sum(cast(vac.new_vaccinations as int)) Over(Partition by dea.location order by dea.location , dea.date) as RollingVaccination
From [Porfolio Project].[dbo].[CovidDeaths$] as Dea Join [Porfolio Project].[dbo].[CovidVaccinations$] as Vac
On Dea.date=Vac.date and dea.location=vac.location
where dea.continent is not null
--order by 2,3
)

Select * ,(RollingVaccination/population)*100 
From popvsVac
--


---Temp Table 
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continetnt nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingVaccination numeric
)

insert into  #PercentPopulationVaccinated
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
Sum(cast(vac.new_vaccinations as int)) Over(Partition by dea.location order by dea.location , dea.date) as RollingVaccination
From [Porfolio Project].[dbo].[CovidDeaths$] as Dea Join [Porfolio Project].[dbo].[CovidVaccinations$] as Vac
On Dea.date=Vac.date and dea.location=vac.location
--where dea.continent is not null
--order by 2,3

Select * , (RollingVaccination/population)*100 
From #PercentPopulationVaccinated
--End the project