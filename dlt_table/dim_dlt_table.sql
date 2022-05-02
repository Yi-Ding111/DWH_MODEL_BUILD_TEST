-- create site stage dim table
create or replace table "AMBER"."TEST"."SITE_DIM_DLT"("account_no" int UNIQUE NOT NULL,
                                                      "state" varchar(20) NOT NULL,
                                                      "postcode" int NOT NULL,
                                                      "site_type" varchar(20) NOT NULL,
                                                      "meter_type" varchar(40) NOT NULL,
                                                      "green_power" int NOT NULL);


-- create consumer stage dim table
create or replace table "AMBER"."TEST"."CONSUMER_DIM_DLT"("consumer_no" int UNIQUE NOT NULL,
                                                          "age_group" varchar(20) NOT NULL);