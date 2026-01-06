{{ config(
    materialized='table',
    schema="base"
) }}
    --description: Table pour regrouper les informations sur les entreprises 
select distinct 
    legalEntity_id as company_id,
    legalEntity_name as company_name

from {{ ref('lucca_raw_data') }}
