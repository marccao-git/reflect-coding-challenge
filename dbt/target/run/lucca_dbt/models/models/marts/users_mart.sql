
  
    

  create  table "lucca_db"."public"."users_mart__dbt_tmp"
  
  
    as
  
  (
    

select
    id, 
    name
from "lucca_db"."public"."users"
  );
  