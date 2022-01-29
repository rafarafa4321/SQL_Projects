
-- Data Source: https://covid19.who.int/info

-- A query that sorts countries by total Covid-19 deaths
-- The US has the highest death count in the world 

with tmp as(
select 
	  country, max(cumulative_cases) sum_of_cases, 
	  max(cumulative_deaths) sum_of_deaths

from
	who_covid
group by
	country)
select *
from
	tmp
order by
	sum_of_deaths desc;


-- The first documented infection cases
-- Asian countries were primarily the first ones infected: China, Thailand, and S Korea
-- The US' first infection case was reported on Jan 20 2020

select top 20 
date_reported, Country, New_cases, New_deaths

from
	who_covid
where new_cases >0
order by
date_reported asc;


-- A query that sorts countries by death rates

with tmp as(
select 
	  country, max(cumulative_cases) sum_of_cases, 
	  max(cumulative_deaths) sum_of_deaths,
	  round(max(cumulative_deaths)/max(cumulative_cases), 4) as infection_death_rates

from
	who_covid
where 
cumulative_cases >0
group by
	country)
select *
from
	tmp

order by
	infection_death_rates desc;


--The code below creates a procedure that retrieves a country’s latest infection info by a user inputting a country's name 

drop procedure if exists latest_info;

create procedure latest_info @country_name varchar(255)
as

select 
	country, 
	max(cumulative_cases) latest_total_number_of_cases, 
	max(cumulative_deaths) latest_total_number_of_deaths,
	round(max(cumulative_deaths)/max(cumulative_cases), 4) as latest_infection_death_rates
from
	who_covid
where 
cumulative_cases >0 and country = @country_name
group by
country

GO
;

--Executes the procedure created above

exec latest_info @country_name = 'Puerto Rico'


--After importing vaccination data table I ensured that countries' names were consistent with the infection data table, so I added a new column -‘country’- and copied the 'location' column’s values into it

alter table covid_vax$
add Country varchar(255)
;

update covid_vax$
set country = coalesce(country, location)


--Since the infection data has the US as 'United States of America' instead of 'United States', I added ' of America' to every row

update covid_vax$
set country = country + ' of America'

from
	covid_vax$
where country = 'United States'
;


--Created a new column for each table - infections data & vaccines data - to standardize the date format

alter table covid_vax$
add date_2 date

update  covid_vax$
set date_2 = convert(date, date)

alter table who_covid
add date_2 date

update  who_covid
set date_2 = convert(date, date_reported)
;


--This query retrieves every country's cumulative positivity rate and infection death rates

select cv.country, max(cast(cv.positive_rate as float)) positivity_rate,
		round(max(wc.cumulative_deaths)/max(wc.cumulative_cases), 4) as infection_death_rates
from
covid_vax$ cv
join
who_covid wc on wc.country = cv.country
where wc.cumulative_cases >0
group by
cv.country
order by
positivity_rate desc;

