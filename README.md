# DATA WAREHOUSE BUILDUP BASED ON SNOWFLAKE


```
1. Determine the granularity of the fact table in dimensional modeling: ***Each row in the fact table represents the subscription status of each site***

2. According to the data description, it can be found that raw data has two dimensions, site info and consumer info.
Compared with the fact table, the dimension table is relatively stable for each update or insertion of data. In other words, the information stored in the dimension tables does not need to be updated frequently, and the measurements contained in each dimension table are closely related.

Two dimension tabls (SITE_DIM, CONSUMER_DIM) have following measurements:
SITE_DIM: site_sk (surrogate key),account_no (unique),state,postcode,site_type,meter_type,green_power.
CONSUMER_DIM: consumer_sk (surrogate key), consumer_number (unique), age_group.

3. The dimension tables use "SCD-TYPE 1" (The updated data in the dimension table will directly overwrite the previous record).
You can also check the document that I give the "SCD_TYPE 2" note.
```

---
---

```
CREATE RAW TABLE (ACCOUNT_RAW)
```
file link:[raw_table_create](raw_table_create.sql)

```
LOAD DATA INTO RAW TABLE (ACCOUNT_RAW)
```
file link: [extract_data](extract_data.sql)

```
Check the data quality
```
file link: [data_wash](data_wash.sql)

```
create stage tables
```
file links: [raw_data_stage_table](./dlt_table/raw_dlt_table.sql)
            [site_dim_and_consumer_dim_stage_table](./dlt_table/dim_dlt_table.sql)

```
data washing and insert data into RAW DATA STAGE TABLE (ACCOUNT_RAW_DLT)
```
file link: [data_wash](data_wash.sql)

```
Insert data into dimension stage table (SITE_DIM_DLT,CONSUMER_DIM_DLT)
```
file link: [stage_table_population](./dlt_table/dlt_table_insertion.sql)

```
Create dimension_table (SITE_DIM,CONSUMER_DIM)
```
file link: [dim_table_create](./dim_table/dim_table.sql)

```
Create sequences for dim tables to generate surrogate key
```
file link: [create_sequences](./dim_table/sequence_sk_create.sql)

```
Insert or update dim table records (SITE_DIM,CONSUMER_DIM)
```
file link: [dim_table_populate](./dim_table/populate_dim_table.sql)

```
Create fact table (ACCOUNT_FACT)
```
file link: [fact_table_create](./fact_table/fact_table.sql)

```
Insert data into fact table
```
file link: [populate_fact_table](./fact_table/populate_fact_table.sql)

```
truncate stage tables for next use
```
file link: [truncate](./dlt_table/truncate_dlt.sql)


---
---
```
test-cases used to verify data consistency and integrity
```
file link: [tests](./tests/)

```
Ingest questionable data
```
file link: [optional](./optional/)

---
---
Author: YI DING
Contact: dydifferent@gmail.com