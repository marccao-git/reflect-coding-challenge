{{ config(
    materialized='table',
    schema="base"
) }}
    --description: Table brut de l'extraction de l'API de Lucca suite au script python main.py
select
    id, 
    last_name,
    first_name,
    mail,
    employee_number,
    modified_at,
    refreshed_at,
    -- extract du payload an json
    (raw_payload->>'dtContractStart')::date as contract_start_date,
    (raw_payload->>'dtContractEnd')::date as contract_end_date,
    (raw_payload->>'birthDate')::date as birth_date,
    (raw_payload->'manager'->>'id')::int as manager_id,
    raw_payload->'manager'->>'name' as manager_name,
    (raw_payload->'culture'->>'id')::int as culture_id,
    raw_payload->'culture'->>'name' as culture_name,
    (raw_payload->'calendar'->>'id')::int as calendar_id,
    raw_payload->'calendar'->>'name' as calendar_name,
    (raw_payload->'legalEntity'->>'id')::int as legalEntity_id,
    raw_payload->'legalEntity'->>'name' as legalEntity_name,
    raw_payload->'department'->>'id'   as department_id,
    raw_payload->'department'->>'name' as department_name,  
    (raw_payload->'rolePrincipal'->>'id')::int as rolePrincipal_id,
    raw_payload->'rolePrincipal'->>'name' as rolePrincipal_name,
    array_to_string(array(
        select hr->>'name'
        from jsonb_array_elements(raw_payload->'habilitedRoles') as hr
    ), ', ') as habilitedRoles_names,
    array_to_string(array(
        select (hr->>'id')::int
        from jsonb_array_elements(raw_payload->'habilitedRoles') as hr
    ), ',') as habilitedRoles_ids,
    array_to_string(array(
        select (uwc->>'id')::int
        from jsonb_array_elements(raw_payload->'userWorkCycles') as uwc
    ), ',') as workCycle_ids,
    array_to_string(array(
        select uwc->>'ownerID'
        from jsonb_array_elements(raw_payload->'userWorkCycles') as uwc
    ), ',') as workCycle_ownerIDs,
    array_to_string(array(
        select uwc->>'workCycleID'
        from jsonb_array_elements(raw_payload->'userWorkCycles') as uwc
    ), ',') as workCycle_workCycleIDs,
    array_to_string(array(
        select uwc->>'startsOn'
        from jsonb_array_elements(raw_payload->'userWorkCycles') as uwc
    ), ',') as workCycle_starts,
    array_to_string(array(
        select uwc->>'endsOn'
        from jsonb_array_elements(raw_payload->'userWorkCycles') as uwc
    ), ',') as workCycle_ends

from {{ source('lucca', 'users') }}
