-- create raw data delt table for data wash

create or replace table "AMBER"."TEST"."ACCOUNT_RAW_DLT"("account_no" int NOT NULL,
                                                         "customer_number" int NOT NULL,
                                                         "age_group" varchar(20) NOT NULL,
                                                         "state" varchar(20) NOT NULL,
                                                         "postcode" int NOT NULL,
                                                         "site_type" varchar(20) NOT NULL,
                                                         "meter_type" varchar(40) NOT NULL,
                                                         "billing_status" varchar(40) NOT NULL,
                                                         "green_power" int NOT NULL,
                                                         "sale_date" date,
                                                         "cool_off" date,
                                                         "billing_start" date,
                                                         "billing_end" date);



