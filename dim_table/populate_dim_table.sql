-- update or insert data from site stage dlt table to site dim table
merge into "AMBER"."TEST"."SITE_DIM"as SDT
using "AMBER"."TEST"."SITE_DIM_DLT" as SDC
on SDT."account_no"=SDC."account_no"
when matched
then update set SDT."state"=case when SDT."state"!=SDC."state" then SDC."state" else SDT."state" end,
                SDT."postcode"=case when SDT."postcode"!=SDC."postcode" then SDC."postcode" else SDT."postcode" end,
                SDT."site_type"=case when SDT."site_type"!=SDC."site_type" then SDC."site_type" else SDT."site_type" end,
                SDT."meter_type"=case when SDT."meter_type"!=SDC."meter_type" then SDC."meter_type" else SDT."meter_type" end,
                SDT."green_power"=case when SDT."green_power"!=SDC."green_power" then SDC."green_power" else SDT."green_power" end
when not matched
then insert values(SITEDIM_SEQ.nextval,SDC."account_no",SDC."state",SDC."postcode",SDC."site_type",SDC."meter_type",SDC."green_power");



-- update or insert data from consumer stage dim table into consumer dim table
merge into "AMBER"."TEST"."CONSUMER_DIM" as CDT
using "AMBER"."TEST"."CONSUMER_DIM_DLT" as CDC
on CDT."consumer_no"=CDC."consumer_no"
when matched
then update set CDT."age_group"=case when CDT."age_group"!=CDC."age_group" then CDC."age_group" else CDT."age_group" end
when not matched
then insert values(CONSUMERDIM_SEQ.nextval,CDC."consumer_no",CDC."age_group");
