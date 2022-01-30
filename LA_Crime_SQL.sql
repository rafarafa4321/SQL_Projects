

--Data Source: https://www.kaggle.com/cityofLA/los-angeles-crime-arrest-data?select=arrest-data-from-2010-to-present.csv


--Since many columns were imported as varchar, I modified some columns' data type

alter table LA_crime..arrest
alter column report_id bigint;

alter table LA_crime..arrest
alter column arrest_date date;

alter table LA_crime..arrest
alter column age bigint;







--I created a new date column that only includes the year of the arrest instead of the full, unstandardized date

alter table LA_crime..arrest
add year_ varchar(255);

update LA_crime..arrest
set year_ = parsename(replace(arrest_date, '-','.'),3);





--Felony arrests per year between males and females

select Sex_Code, count(sex_code) as gender_total, year_
from
LA_crime..arrest
where 
	Arrest_Type_Code = 'F'
group by
 Sex_Code, year_ 
order by
year_, sex_code;





--Misdemeanor arrests per year between males and females

select Sex_Code, count(sex_code) as gender_total, year_
from
LA_crime..arrest
where 
	Arrest_Type_Code = 'M'
group by
 Sex_Code, year_ 
order by
year_, sex_code;






--Homicide arrests per year between males and females

select Sex_Code, count(sex_code) as gender_total, year_, Charge_Group_Description
from
LA_crime..arrest
where 
	Charge_Group_Code = '01'
group by
 Sex_Code, year_, Charge_Group_Description 
order by
year_, sex_code ;





--Look up every distinct category of crime with respective code

select distinct crime_code_description, crime_code
from
	LA_crime..crime
	order by
	crime_code;






--I noticed that some date_reported column values in crimes committed in 2019 were not fully standardized, so I created
--a new column and used a query that would resolve the issue

alter table LA_crime..crime
add year_2 varchar(255);


select year_, case	
		when cast(year_ as int)>2019 then '2019'
		else year_ end
from
LA_Crime..crime;


update LA_Crime..crime
set year_2 = case	
		when cast(year_ as int)>2019 then '2019'
		else year_ end;





--Yearly Homicide count by sex

select crime_code_description, count(crime_code_description) homicide_count, year_2 as year, Victim_Sex
from
LA_Crime..crime
where crime_code_description = 'criminal homicide'
and
Victim_Sex in ('M', 'F')
group by
	crime_code_description, year_2, Victim_Sex
order by 
year;




--A table that contains the annual sum of homicides and victims of homicide 

select  Crime_Code_Description,count(Crime_Code_Description) homicides, year_2
from
la_crime..crime
where
Crime_Code_Description = 'Criminal Homicide'
group by year_2, Crime_Code_Description

union

select  a.charge_group_description, 
count(a.charge_group_description) homicide_arrests,
a.year_
from
la_crime..arrest a
where a.charge_group_description = 'homicide'
group by
a.charge_group_description, a.year_;


