-- Find out information about a single consumer ID with different ages
select * 
from "AMBER"."TEST"."ACCOUNT_RAW"
where "customer_number" in (select T1."customer_number" 
                            from (select distinct "customer_number","age_group" 
                                  from "AMBER"."TEST"."ACCOUNT_RAW") T1
                            group by T1."customer_number"
                            having count(*)>1);



--find the records same account_no with different site attribute values
select * 
from "AMBER"."TEST"."ACCOUNT_RAW"
where "account_no" in (select T1."account_no"
                       from (select distinct "account_no","state","postcode","site_type","meter_type","green_power"
                             from "AMBER"."TEST"."ACCOUNT_RAW") T1
                       group by T1."account_no"
                       having count(*)>1);



-- identify all ENUM types
select distinct("site_type") from "AMBER"."TEST"."ACCOUNT_RAW";

select distinct("meter_type") from "AMBER"."TEST"."ACCOUNT_RAW";

select distinct("billing_status") from "AMBER"."TEST"."ACCOUNT_RAW";



-- datawash, fill null value 

insert into "AMBER"."TEST"."ACCOUNT_RAW_DLT"
select cast("account_no" as integer) as "account_no",
       cast("customer_number" as integer) as "customer_number",
       case when "age_group" is null then 'UNKNOW' 
            else "age_group" end as "age_group",
       case when "state" is null then 'UNKNOW' 
            else upper("state") end as "state",
       case when "postcode" is null then -1 
            else "postcode" end as "postcode",
       case when "site_type" is null then 'UNKNOW'
            when "site_type" not in ('BUSINESS','RESIDENTIAL') then 'UNVERIFIED'
            else "site_type" end as "site_type",
       case when "meter_type" is null then 'UNKNOW'
            when "meter_type" not in ('Pending Id','Basic','Smart','Interval') then 'UNVERIFIED'
            else "meter_type" end as "meter_type",
       case when "billing_status" is null then 'UNKNOW'
            when "billing_status" not in ('Transfer In','Billing','Closed','Cancelled','Suspended - Duplicate') then 'UNVERIFIED'
            else "billing_status" end as "billing_status",
       case when "green_power" is null then -1 
            else "green_power" end as "green_power",
       "sale_date" as "sale_date",
       "cool_off" as "cool_off",
       "billing_start" as "billing_start",
       "billing_end" as "billing_end"
from "AMBER"."TEST"."ACCOUNT_RAW";


