
  
    

  create  table "lucca_db"."public_base"."contract__dbt_tmp"
  
  
    as
  
  (
    
    --description: Table pour regrouper les informations sur les contrats 
select 
    id as employee_id,
    employee_number,
    last_name,
    first_name,
    contract_start_date,
    contract_end_date,
    legalEntity_id as company_id,
    legalEntity_name as company_name,
    roleprincipal_id as jobtitle_id,
    roleprincipal_name as jobtitle_name,
    modified_at,
    refreshed_at

from "lucca_db"."public_base"."lucca_raw_data"
  );
  