
  
    

  create  table "lucca_db"."public_transform"."department_extended__dbt_tmp"
  
  
    as
  
  (
    
-- description: Table pour regrouper les informations étendues sur les départements, incluant le nombre d'employés et de managers
select
    d.*,
    count(e.employee_id) as employee_count,
    sum(case when e.is_manager then 1 else 0 end) as manager_count
from "lucca_db"."public_base"."department" d
left join "lucca_db"."public_transform"."employee_extended" e
    on d.department_id = e.department_id and d.company_id = e.company_id
group by
    d.department_id,
    d.department_name,
    d.company_id,
    d.company_name
  );
  