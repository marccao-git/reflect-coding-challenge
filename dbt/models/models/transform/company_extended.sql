{{ config(
    materialized='table',
    schema="transform"
) }}
--description: Table pour les informations sur les entreprises avec des métriques agrégées sur les employés et départements
select
    c.company_id,
    c.company_name,
    count(e.employee_id) as total_employee,
    count(case when e.is_active = true then 1 else 0 end) as total_employee_active,
    sum(case when e.is_manager then 1 else 0 end) as total_manager,
    sum(case when e.is_manager and e.is_active = true then 1 else 0 end) as total_manager_active,
    count(distinct e.department_id) as total_nb_departments

from {{ ref('company') }} c
left join {{ ref('employee_extended') }} e
    on c.company_id = e.company_id

group by
    c.company_id,
    c.company_name
