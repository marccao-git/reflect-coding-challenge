
--description: Table pour regrouper les informations sur les contrats étendus avec des indicateurs sur les employés
select 
    *,
    case
        when contract_start_date > current_date then true
        else false
    end as will_start,

    case
        when contract_start_date > current_date then 'not_started'
        when contract_end_date is null or contract_end_date >= current_date then 'active'
        else 'inactive'
    end as contract_status,

    case
        when contract_end_date is not null and contract_end_date < current_date then true
        else false
    end as is_suspended,    

    case
        when contract_start_date is not null then
            coalesce(contract_end_date, current_date) - contract_start_date
        else null
    end as days_worked,

    case
        when contract_start_date is not null then
                extract(year from age(coalesce(contract_end_date, current_date), contract_start_date))
            else null
    end as seniority_years,

    case
        when contract_end_date is not null and contract_end_date >= current_date then
            contract_end_date - current_date
        else null
    end as remaining_days

from "lucca_db"."public_base"."lucca_raw_data"