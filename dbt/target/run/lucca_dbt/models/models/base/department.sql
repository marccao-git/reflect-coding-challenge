
  
    

  create  table "lucca_db"."public_base"."department__dbt_tmp"
  
  
    as
  
  (
    
    --description: Table pour regrouper les informations sur les départements 

select distinct 
    department_id,
    department_name,
    legalEntity_id as company_id,
    legalEntity_name as company_name

from "lucca_db"."public_base"."lucca_raw_data"
  );
  