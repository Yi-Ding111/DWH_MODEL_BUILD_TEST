--insert data into fact table
insert into "AMBER"."TEST"."ACCOUNT_FACT"
select SD."site_sk",CD."consumer_sk",ACD."billing_status",ACD."sale_date",ACD."cool_off",ACD."billing_start",ACD."billing_end",CURRENT_TIMESTAMP
from "AMBER"."TEST"."ACCOUNT_RAW_DLT" ACD
left join "AMBER"."TEST"."SITE_DIM" SD
on ACD."account_no"=SD."account_no"
left join "AMBER"."TEST"."CONSUMER_DIM" CD
on ACD."customer_number"=CD."consumer_no";