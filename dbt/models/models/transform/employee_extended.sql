{{ config(
    materialized='table',
    schema="transform"
) }}
-- Table pour regrouper les informations étendues sur les employés, incluant le statut d'activité et de management

select 
    e.*,
    case 
        when e.employee_id in (
            select distinct manager_id::varchar 
            from {{ ref('employee') }}
            where manager_id is not null
        )
        then true
        else false
    end as is_manager,

    case
        when c.contract_start_date <= current_date
         and (c.contract_end_date is null or c.contract_end_date > current_date)
        then true
        else false
    end as is_active

from {{ ref('employee') }} e
left join {{ ref('contract') }} c
    on e.employee_id = c.employee_id
