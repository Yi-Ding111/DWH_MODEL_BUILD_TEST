-- create fact table
create or replace table "AMBER"."TEST"."ACCOUNT_FACT"("site_sk" int NOT NULL,
                                                      "consumer_sk" int NOT NULL,
                                                      "billing_status" varchar(40) NOT NULL,
                                                      "sale_date" date,
                                                      "cool_off" date,
                                                      "billing_start" date,
                                                      "billing_end" date,
                                                      "insert_timestamp" timestamp);