
  
    

  create  table "lucca_db"."public_transform"."employee__dbt_tmp"
  
  
    as
  
  (
    

select

    id as employee_id,
    employee_number,
    last_name,
    first_name,
    mail as employee_email,
    birth_date,
    culture_name as nationality,
    legalentity_id as company_id,
    legalentity_name as company_name,
    roleprincipal_id as jobtitle_id,
    roleprincipal_name as jobtitle_name,
    manager_id,
    manager_name,
    modified_at,
    refreshed_at

from "lucca_db"."public_base"."lucca_raw_data"
  );
  