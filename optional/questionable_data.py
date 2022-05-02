import snowflake.connector as sf
import pandas as pd
import datetime
from datetime import datetime
#username=''
#password=''
#account=''
#database='AMBER'
#schema_name='TEST'

#connect database
#conn=sf.connect(user=username,password=password,account=account,database=database,schema=schema_name)

#db_cursor=conn.cursor()
#select all raw data
#sql="select * from ACCOUNT_RAW limit 10;"
#db_cursor.execute(sql)
#rows=db_cursor.fetchall()


def find_unprocess_record(data_df):
    '''
    find all records connot be processed
    '''
    #dataframe to store data connot be processed
    bad_record=pd.DataFrame(columns=['row number','reason','data'])
    #give initial number
    for index in range(data_df.shape[0]):
        payload={
            'account_no':data_df.loc[index][0],
            'customer_number':data_df.loc[index][1],
            'age_group':data_df.loc[index][2],
            'state':data_df.loc[index][3],
            'postcode':data_df.loc[index][4],
            'site_type':data_df.loc[index][5],
            'meter_type':data_df.loc[index][6],
            'billing_status':data_df.loc[index][7],
            'green_power':data_df.loc[index][8],
            'sale_date':data_df.loc[index][9],
            'cool_off':data_df.loc[index][10],
            'billing_start':data_df.loc[index][11],
            'billing_end':data_df.loc[index][12]
        }
        #print(payload)
        reason=reason_identify(payload)
        if len(reason)!=0:
            #link reasons
            reasons='&'.join(reason)
            #print(reasons)
            bad_record=bad_record.append({'row number':index+1,'reason':reasons,'data':payload},ignore_index=True)


    return bad_record





def reason_identify(payload):
    '''
    identify the reason why the record cannot be processed
    '''
    #initial reason
    reason=[]
    if payload['age_group'] is None:
        reason.append('Miss age')
    if payload['state'] is None or payload['postcode']is None:
        reason.append('Miss address')
    if payload['site_type'] not in ['BUSINESS','RESIDENTIAL']:
        reason.append('Invalid site type')
    if payload['meter_type'] not in ['Pending Id','Basic','Smart','Interval']:
        reason.append('Invalid meter type')
    if payload['billing_status'] not in ['Transfer In','Billing','Closed','Cancelled','Suspended - Duplicate']:
        reason.append('Invalid billing status')
    if check_date(payload['sale_date']) is False:
        reason.append('Invalid sale date')
    if check_date(payload['billing_start']) is False:
        reason.append('Invalid start date')
    if check_date(payload['billing_end']) is False:
        reason.append('Invalid end date')
    #print(reason)
    return reason



def check_date(date_str):
    '''
    check the date is valid or not
    '''
    try:
        datetime.strptime(str(date_str),"%d/%m/%y")
        return True
    except ValueError or TypeError:
        return False






if __name__=="__main__":
    amber_data=pd.read_csv('./data.csv',)
    data_df=pd.DataFrame(amber_data)
    bad_record=find_unprocess_record(data_df)
    #extract data into csv file
    bad_record.to_csv('./optional/data_bad.csv',sep='\t',encoding='utf-8')