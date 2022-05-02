-- Q2

-- define combined customer growth: Number of new consumers added (Transfer in) per state - number of consumers reduced (cancelled) per state

with state_up as(select SD."state" as state,count(distinct AF."consumer_sk") as num_up
                 from "AMBER"."TEST"."ACCOUNT_FACT" AF
                 left join "SITE_DIM" SD
                 on AF."site_sk"=SD."site_sk"
                 where AF."billing_status"='Transfer In' and SD."state"!='UNKNOW'
                 group by SD."state"),
   state_down as(select SD."state" as state,count(distinct AF."consumer_sk") as num_down
                 from "AMBER"."TEST"."ACCOUNT_FACT" AF
                 left join "SITE_DIM" SD
                 on AF."site_sk"=SD."site_sk"
                 where AF."billing_status"='Cancelled' and SD."state"!='UNKNOW'
                 group by SD."state"),
   state_growth as(select state_up.state,(state_up.num_up-state_down.num_down) as growth
                   from state_up
                   join state_down
                   on state_up.state=state_down.state)
     
select state
from state_growth
where growth in (select max(growth) from state_growth);

-- the overall best state for combined customer growth is ACT





-- Q3 

-- I define the customer growth: billing_status='Transfer In'

with cte as (select MONTH("sale_date") as month, count(*) as nums
             from "AMBER"."TEST"."ACCOUNT_FACT"
             where "billing_status"='Transfer In'
             group by month)

select month 
from cte
where nums in (select max(nums) from cte);

-- The best month for total customer growth is Oct






-- Q4

-- I define the customer churns: billing_status='cancelled' or 'closed'

--To prevent some users from canceling the service but then re-subscribing, 
--filter duplicate consumer records to the latest records

with churn_user as (select CD."age_group",count(*) as num
                    from "AMBER"."TEST"."ACCOUNT_FACT" AF
                    join (select "consumer_sk",max("sale_date") as sale_date
                          from "AMBER"."TEST"."ACCOUNT_FACT"
                          group by "consumer_sk") T1
                    on AF."consumer_sk"=T1."consumer_sk" and AF."sale_date"=T1.sale_date
                    left join "AMBER"."TEST"."CONSUMER_DIM" CD
                    on AF."consumer_sk"=CD."consumer_sk"
                    where AF."billing_status"='Cancelled' or AF."billing_status"='Closed'
                    group by CD."age_group")
               
select "age_group"
from churn_user
where num in (select max(num) from churn_user);

-- 35-39 churns the most




--Q5

with cte as (select SD."site_type",SD."state",month(AF."sale_date") as "sale_month",AF."billing_status"
            from "AMBER"."TEST"."ACCOUNT_FACT" AF
            join (select "consumer_sk",max("sale_date") as sale_date
                  from "AMBER"."TEST"."ACCOUNT_FACT"
                  group by "consumer_sk") T1
            on AF."consumer_sk"=T1."consumer_sk" and AF."sale_date"=T1.sale_date
            left join "AMBER"."TEST"."SITE_DIM" SD
            on AF."site_sk"=SD."site_sk"
            where SD."state"!='UNKNOW' and SD."site_type"!='UNKNOW' and SD."site_type"!='UNVERIFIED')


select T1."site_type",T1."state",T1."sale_month",round(T2.churn_num/T1.total_num*100,2) as "percentage"
from (select "site_type","state","sale_month",count(*) as total_num
      from cte
      group by "site_type","state","sale_month") T1
left join (select "site_type","state","sale_month",count(*) as churn_num
      from cte
      where "billing_status"='Cancelled' or "billing_status"='Closed'
      group by "site_type","state","sale_month") T2
on T1."site_type"=T2."site_type" and T1."state"=T2."state" and T1."sale_month"=T2."sale_month";




-- Q6

--filter out the earliest date when a user starts to subscribe to the service 
--and the latest date when the user unsubscribes from the service, 
--and calculate the time difference between the two dates

select T1."consumer_sk",(T2.latest_date-T1.early_date) as keep_time
from (select "consumer_sk", min("sale_date") as early_date
      from "AMBER"."TEST"."ACCOUNT_FACT"
      where "billing_status"='Transfer In' or "billing_status"='Billing'
      group by "consumer_sk") T1
join (select "consumer_sk", max("sale_date") as latest_date
      from "AMBER"."TEST"."ACCOUNT_FACT"
      where "billing_status"!='Transfer In' and "billing_status"!='Billing'
      group by "consumer_sk") T2
on T1."consumer_sk"=T2."consumer_sk"
having keep_time>=0
order by keep_time;

--It is easy to find that most unsubscribed customers cancel their subscriptions 
--within a short period of time after starting the subscription service.



-- Q7

-- calculate the churn percentage of each age group

with cte as (select CD."age_group",AF."billing_status"
            from "AMBER"."TEST"."ACCOUNT_FACT" AF
            join (select "consumer_sk",max("sale_date") as sale_date
                  from "AMBER"."TEST"."ACCOUNT_FACT"
                  group by "consumer_sk") T1
            on AF."consumer_sk"=T1."consumer_sk" and AF."sale_date"=T1.sale_date
            left join "AMBER"."TEST"."CONSUMER_DIM" CD
            on AF."consumer_sk"=CD."consumer_sk")

select T1."age_group", round(T2.churn_nums/T1.total_nums*100,2) as age_churn_perc
from (select "age_group",count(*) as total_nums
      from cte
      group by "age_group")T1
left join (select "age_group", count(*) as churn_nums
           from cte
           where "billing_status"='Cancelled' or "billing_status"='Closed'
           group by "age_group") T2
on T1."age_group"=T2."age_group"
order by age_churn_perc;

--It is easy to find that churn rates generally decrease with age,
--older people are more likely to continue to subscribe the service,
--while younger people are more likely to opt out




--Q8

--This sql is to find what is the most important type of service chosen by customers on ongoing payments?

select SD."site_type",SD."meter_type",count(*) as nums
from "AMBER"."TEST"."ACCOUNT_FACT" AF
left join "AMBER"."TEST"."SITE_DIM" SD
on AF."site_sk"=SD."site_sk"
where AF."billing_status"='Billing'and SD."site_type"!='UNKNOW'
group by "site_type","meter_type"
order by nums;

--It is easy to find that most of the users are in RESDENTIAL sites and the meter type chosen is SMART.