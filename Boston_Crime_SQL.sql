
--Boston Crime Data
--Data Source: https://data.boston.gov/dataset/crime-incident-reports-august-2015-to-date-source-new-system?ref=hackernoon.com

--A list of every type of crime for 2020; This was done to get a sense of the types of crimes included in this table

use boston_crime;


select distinct OFFENSE_DESCRIPTION from boston_2020;




--The 2018 table had NULL values for when a shooting did not take place and 'Y' for when a shooting took place, 
--so I created a new column that returns 1 for Y and 0 for NULLs

alter table boston_2018
add shooting_2 int;

update boston_2018
set shooting_2 = case when shooting = 'Y' then 1 else 0 end;



--Total murders per year: separated by murders with shooting & murders with no shooting

select OFFENSE_DESCRIPTION, count(OFFENSE_DESCRIPTION) total_murders,
sum(shooting) murders_by_shooting, sum(case when shooting = 0 then 1 else 0 end) murders_no_shooting
from 
	boston_2021
where OFFENSE_DESCRIPTION like 'MURDER%'
group by OFFENSE_DESCRIPTION;


select OFFENSE_DESCRIPTION, count(OFFENSE_DESCRIPTION) total_murders,
sum(shooting) murders_by_shooting, sum(case when shooting = 0 then 1 else 0 end) murders_no_shooting
from 
	boston_2020
where OFFENSE_DESCRIPTION like 'MURDER%'
group by OFFENSE_DESCRIPTION;


select OFFENSE_DESCRIPTION '2019', count(OFFENSE_DESCRIPTION) total_murders,
sum(shooting) murders_by_shooting, sum(case when shooting = 0 then 1 else 0 end) murders_no_shooting
from 
	boston_2019
where OFFENSE_DESCRIPTION like 'MURDER%'
group by OFFENSE_DESCRIPTION;

select OFFENSE_DESCRIPTION '2018', count(OFFENSE_DESCRIPTION) total_murders,
sum(shooting_2) murders_by_shooting, sum(case when shooting_2 = 0 then 1 else 0 end) murders_no_shooting
from 
	boston_2018
where OFFENSE_DESCRIPTION like 'MURDER%'
group by OFFENSE_DESCRIPTION;


--Count of all major crimes in 2020

select OFFENSE_DESCRIPTION, count(OFFENSE_DESCRIPTION) as count_
from
	boston_2020
where OFFENSE_DESCRIPTION like '%burglary%' or
OFFENSE_DESCRIPTION like '%urder%' or
OFFENSE_DESCRIPTION like '%assa%' or
OFFENSE_DESCRIPTION like '%rob%' or
OFFENSE_DESCRIPTION like '%larce%' or 
OFFENSE_DESCRIPTION like '%auto th%'
group by 
OFFENSE_DESCRIPTION;



--Count of all major crimes in 2021

select OFFENSE_DESCRIPTION, count(OFFENSE_DESCRIPTION) as count_
from
	boston_2021
where OFFENSE_DESCRIPTION like '%burglary%' or
OFFENSE_DESCRIPTION like '%urder%' or
OFFENSE_DESCRIPTION like '%assa%' or
OFFENSE_DESCRIPTION like '%rob%' or
OFFENSE_DESCRIPTION like '%larce%' or 
OFFENSE_DESCRIPTION like '%auto th%'
group by 
OFFENSE_DESCRIPTION;
