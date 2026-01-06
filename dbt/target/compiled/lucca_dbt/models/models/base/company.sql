
    --description: Table pour regrouper les informations sur les entreprises 
select distinct 
    legalEntity_id as company_id,
    legalEntity_name as company_name

from "lucca_db"."public_base"."lucca_raw_data"