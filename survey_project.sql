select * from survey;


CREATE TABLE survey_data (
    unique_id VARCHAR(255),
    email VARCHAR(255),
    date_taken DATE,
    time_taken TIME,
    time_spent INTERVAL,
    role VARCHAR(255),
    switched_careers BOOLEAN,
    salary_range VARCHAR(50),
    industry VARCHAR(255),
    favorite_language VARCHAR(50),
    happiness_level INTEGER,
    difficulty_breaking_in VARCHAR(50),
    important_job_factor VARCHAR(255),
    gender VARCHAR(10),
    age INTEGER,
    country VARCHAR(255),
    ethnicity VARCHAR(255)
);


select * from survey_data;


COPY survey_data(unique_id,email,date_taken,time_taken,time_spent,role,switched_careers,
	salary_range,industry,favorite_language,happiness_level,difficulty_breaking_in,
	important_job_factor,gender,age,country,ethnicity	)
FROM ‘C:\Users\DELL\Downloads\Power_BI_Final_Project_UTF8.csv
DELIMITER ‘,’
CSV HEADER;


COPY survey(unique_id, email, date_taken, time_taken, time_spent, job_title, switch_careers, 
    salary_range, industry, favprogramming_lang, happy_salary, work_life_balance,
    coworkers,management,upward_mobility,learning_new_things,most_important_thing, gender, age, country, ethnicity)
FROM 'C:/Users/DELL/Downloads/Power_BI_Final_Project_UTF8.csv'
DELIMITER ','
CSV HEADER;


drop table survey_data;

CREATE TABLE survey_data (
    unique_id VARCHAR,
    email VARCHAR,
    date_taken VARCHAR, -- Adjusted from DATE to VARCHAR since the date format might not be directly compatible
    time_taken VARCHAR, -- Adjusted from TIME to VARCHAR to handle different time formats
    time_spent VARCHAR, -- Adjusted from INTERVAL to VARCHAR to handle various time spent formats
    job_title VARCHAR,
    switch_careers VARCHAR,
    salary_range VARCHAR,
    industry VARCHAR,
    favprogramming_lang VARCHAR,
    happy_salary FLOAT,
    work_life_balance FLOAT,
    coworkers FLOAT,
    management FLOAT,
    upward_mobility FLOAT,
    learning_new_things FLOAT,
	break_into_data varchar,
    most_important_thing VARCHAR,
    gender VARCHAR,
    age INTEGER,
    country VARCHAR,
    ethnicity VARCHAR
);


drop table survey_data;


select *
from survey_data;

alter table survey_data
alter column date_taken type date
using to_date(date_taken,'mm-dd-yyyy');

alter table survey_data
alter column time_taken type time
using time_taken::time;

alter table survey_data
alter column time_spent type time
using time_spent :: time;


alter table survey_data
drop column ethnicity;


update survey_data
set job_title = replace(job_title,left(job_title,position(':' in job_title)),'')
where job_title like 'Other%';

select distinct job_title
from survey_data
order by job_title;

update survey_data
set job_title = 'Software Engineer'
where job_title like '%oftware%';

update survey_data
set job_title = 'Finance Analyst'
where job_title like '%Finance%';

delete from survey_data
where job_title like '%work%' or job_title like 'Does%' or job_title like '%_ntern%';

update survey_data
set job_title = 'Business Analyst'
where job_title like '%ness__nal%';

update survey_data
set job_title = replace(job_title,'Business Intelligence','BI')
where job_title like '%siness__ntelligen%';

update survey_data
set job_title = 'BI Domain'
where job_title like '%BI%';

update survey_data
set country = replace(country,left(country,position(':' in country)),'')
where country like 'Other%';


update survey_data
set industry = replace(industry,left(industry,position(':' in industry)),'')
where industry like 'Other%';


update survey_data
set favprogramming_lang = replace(favprogramming_lang,left(favprogramming_lang,position(':' in favprogramming_lang)),'')
where favprogramming_lang like 'Other%';


update survey_data
set most_important_thing = replace(most_important_thing,left(most_important_thing,position(':' in most_important_thing)),'')
where most_important_thing like 'Other%';



select distinct industry
from survey_data
order by industry;

update survey_data
set industry = trim(industry);

delete from survey_data
where industry ='Arrosp' or industry ='Cons' or industry like 'Culi%' or industry like'Current%'
or industry like 'fas%' or industry like '%_tudent%' or industry like 'Intern%' or industry like '%_ooking%'
or industry like '_one' or industry like '%working%' or industry like '%transpo'
or industry like 'Cobsuk%' or industry like '%_nemploye%';


update survey_data
set industry = 'Utilities'
where industry like '%Util%';


alter table survey_data
rename column favprogramming_lang to fav_lang;

select distinct fav_lang
from survey_data
order by fav_lang;


delete from survey_data
where fav_lang like '%Dont%' or fav_lang like '%_urrent%' or fav_lang like 'I %'
or fav_lang like '%mean%' or fav_lang like '%learn%' or fav_lang like 'N%'
or fav_lang like '%but%' or fav_lang like '%unkno%';


update survey_data
set fav_lang = 'VBA'
where fav_lang like 'V%' ;



select distinct country
from survey_data
order by country;


update survey_data
set country = trim(country);

delete from survey_data
where country = 'SG' or country = 'uzb';


update survey_data
set country = 'Turkey'
where country like '%_urke%' ;

update survey_data
set country = 'UAE'
where country like '%Arab Emir%' ;

select distinct most_important_thing
from survey_data
order by most_important_thing;


delete from survey_data
where most_important_thing like '%started%' or most_important_thing like 'Projects %' or
most_important_thing like '%move from%';


update survey_data
set most_important_thing = 'Remote'
where most_important_thing like '%Remote%' ;


alter table survey_data
add column salary float;


update survey_data
set salary_range = replace(salary_range,'k','000');

alter table survey_data
drop column salary;