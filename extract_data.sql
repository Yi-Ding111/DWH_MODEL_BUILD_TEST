-- create database 
create or replace database "AMBER";
create schema test;


--create file format
create or replace file format "AMBER"."TEST".amber_data_format
type='CSV'
field_delimiter=','
record_delimiter='\n'
skip_header=1
trim_space=True
error_on_column_count_mismatch = true
escape='None'
date_format='DD/MM/YY'
null_if = ('NULL');


-- put file into stage
put file:///Users/charles/Desktop/data_amber.csv @"AMBER"."TEST"."ACCOUNT_RAW_STAGE" auto_compress=true;


-- copy file into raw table
copy into ACCOUNT_RAW 
from @ACCOUNT_RAW_STAGE/data_amber.csv.gz
file_format=(format_name="AMBER"."TEST".amber_data_format)
on_error='skip_file';


-- load error records txt file
copy into ACCOUNT_RAW 
from @ACCOUNT_RAW_STAGE/data_amber.csv.gz
file_format=(format_name="AMBER"."TEST".amber_data_format)
validation_mode=return_all_errors;

set qid=last_query_id();

copy into @ACCOUNT_RAW_STAGE/errors/load_errors.txt from (select rejected_record from table(result_scan($qid)));
