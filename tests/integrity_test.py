'''
This test file is used to test data integrity

This test is to generate a full info table by connecting the fact table and dimension table, 
and compare the number of rows and cols of records with the number of raw data. 
If the number of rows is the same, the test passes
'''
import snowflake.connector as sf
import pandas as pd
import operator

#connect with database info
username=''
password='**************'
account='***************'
database='AMBER'
schema_name='TEST'



def tables_dim(conn):
    '''
    calculate the numbers of rows and cols of tables
    '''
    #create cursor
    db_cursor1=conn.cursor()
    db_cursor2=conn.cursor()

    #sql to join fact table with dim tables
    sql_join="""
             select SD."account_no",CD."consumer_no",CD."age_group",SD."state",
                   SD."postcode",SD."site_type",SD."meter_type",AF."billing_status",
                   SD."green_power",AF."sale_date",AF."cool_off",AF."billing_start",AF."billing_end"
            from "ACCOUNT_FACT" AF
            left join "SITE_DIM" SD
            on AF."site_sk"=SD."site_sk"
            left join "CONSUMER_DIM" CD
            on AF."consumer_sk"=CD."consumer_sk";"""
    
    #sql to select all records from raw table
    sql_raw="""
            select * from "AMBER"."TEST"."ACCOUNT_RAW";
            """
    
    #run sql to join tables
    db_cursor1.execute(sql_join)
    join_raw=db_cursor1.fetchall()
    #convert data into dataframe structure
    join_shape=(pd.DataFrame(list(join_raw))).shape


    db_cursor2.execute(sql_raw)
    join_raw=db_cursor2.fetchall()
    #convert data into dataframe structure
    raw_shape=(pd.DataFrame(list(join_raw))).shape


    db_cursor1.close()
    db_cursor2.close()

    return join_shape, raw_shape











if __name__=="__main__":
    conn=sf.connect(user=username,password=password,account=account,database=database,schema=schema_name)

    join_shape=tables_dim(conn)[0]
    raw_shape=tables_dim(conn)[1]

    #check the shape is same or not
    print(operator.eq(join_shape,raw_shape))
    


