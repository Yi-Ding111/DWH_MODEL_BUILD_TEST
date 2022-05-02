-- create raw table 
create or replace table "AMBER"."TEST"."ACCOUNT_RAW" ("account_no" text(200) NOT NULL,
                                                      "customer_number" text(200) NOT NULL,
                                                      "age_group" text(200),
                                                      "state" text(200),
                                                      "postcode" int,
                                                      "site_type" varchar(200),
                                                      "meter_type" varchar(200),
                                                      "billing_status" varchar(200),
                                                      "green_power" int,
                                                      "sale_date" date,
                                                      "cool_off" date,
                                                      "billing_start" date,
                                                      "billing_end" date);

-- select * from "AMBER"."TEST"."ACCOUNT_RAW" limit 10;


-- data audit
select max(len ('age_group')),max(len('state')),max(len('site_type')),max(len('meter_type')),max(len('billing_status')) from "AMBER"."TEST"."ACCOUNT_RAW";


