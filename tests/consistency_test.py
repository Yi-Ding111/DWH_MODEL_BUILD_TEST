'''
This test file is used to test data consistency

It will connect the fact table and the dimension table, 
convert them into the original data table form, 
and compare it with the content of the raw table. 
If both can match exactly, the test is successful.
'''

import snowflake.connector as sf
import pandas as pd
from pandas.testing import assert_frame_equal


#connect with database info
username=''
password='******'
account='*********'
database='AMBER'
schema_name='TEST'





def table_join(conn):
    '''
    create full info table through join fact table and dimension tables
    '''
    #create cursor
    db_cursor=conn.cursor()
    #join fact table with dimension tables
    sql=""" 
        select cast(SD."account_no" as text(200)) as "account_no",cast(CD."consumer_no" as text(200)) as "customer_number",
        case when CD."age_group"='UNKNOW' then NULL else CD."age_group" end as "age_group",
        case when SD."state"='UNKNOW' then NULL else SD."state" end as "state",
        case when SD."postcode"=-1 then NULL else SD."postcode" end as "postcode",
        case when SD."site_type"='UNKNOW' then NULL else SD."site_type" end as "site_type",
        case when SD."meter_type"='UNKNOW' then NULL else SD."meter_type" end as "meter_type",
        case when AF."billing_status"='UNKNOW' then NULL else AF."billing_status" end as "billing_status",
        case when SD."green_power"=-1 then NULL else SD."green_power" end as "green_power",
        AF."sale_date",AF."cool_off",AF."billing_start",AF."billing_end"
        from "ACCOUNT_FACT" AF
        left join "SITE_DIM" SD
        on AF."site_sk"=SD."site_sk"
        left join "CONSUMER_DIM" CD
        on AF."consumer_sk"=CD."consumer_sk";"""

    #run sql to join tables
    db_cursor.execute(sql)
    join_raw=db_cursor.fetchall()
    #convert data into dataframe structure
    join_raw_df=pd.DataFrame(list(join_raw))

    #close cursor
    db_cursor.close()

    return join_raw_df



def raw_table_get(conn):
    '''
    get raw table data
    '''
    db_cursor=conn.cursor()

    sql="""
        select "account_no","customer_number","age_group","state","postcode",
               case when "site_type" not in ('BUSINESS','RESIDENTIAL') then 'UNVERIFIED' 
               else "site_type" end as "site_type",
               case when "meter_type" not in ('Pending Id','Basic','Smart','Interval') then 'UNVERIFIED'
               else "meter_type" end as "meter_type",
               case when "billing_status" not in ('Transfer In','Billing','Closed','Cancelled','Suspended - Duplicate') then 'UNVERIFIED'
               else "billing_status" end as "billing_status",
               "green_power","sale_date","cool_off","billing_start","billing_end"
        from "AMBER"."TEST"."ACCOUNT_RAW";"""

    db_cursor.execute(sql)
    raw_table=db_cursor.fetchall()
    raw_table_df=pd.DataFrame(list(raw_table))

    return raw_table_df





if __name__=="__main__":
    #connect database
    conn=sf.connect(user=username,password=password,account=account,database=database,schema=schema_name)

    raw_table_df=raw_table_get(conn)
    join_raw_df=table_join(conn)
    
    #compare two tables to check consistency
    try:
        assert_frame_equal(raw_table_df,join_raw_df)
        print("True")
    
    except AssertionError:
        print("False")


    #disconnet database
    conn.close()