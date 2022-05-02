-- create sequence for site dim table as surrogate key
create or replace sequence sitedim_seq start=1 increment=1; 

-- create sequnece for consumer dim table as surrogate key
create or replace sequence consumerdim_seq start = 1 increment=1; 