-- insert data into site stage dim table
insert into "AMBER"."TEST"."SITE_DIM_DLT"
select distinct "account_no","state","postcode","site_type","meter_type","green_power"
from "AMBER"."TEST"."ACCOUNT_RAW_DLT"
order by "account_no";


-- insert data into consumer stage dim table
insert into "AMBER"."TEST"."CONSUMER_DIM_DLT"
select distinct "customer_number", "age_group"
from "AMBER"."TEST"."ACCOUNT_RAW_DLT"
order by "customer_number";