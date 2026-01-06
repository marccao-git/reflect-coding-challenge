

select
    id, 
    name,
    mail,
    employee_number,
    modified_at,
    refreshed_at,
    raw_payload->>'dtContractStart' as contract_start_date,
    raw_payload->>'dtContractEnd' as contract_end_date,
    raw_payload->>'birthDate' AS birth_date,
    (raw_payload->'manager'->>'id')::int as manager_id,
    raw_payload->'manager'->>'name' AS manager_name,
    (raw_payload->'culture'->>'id')::int AS culture_id,
    raw_payload->'culture'->>'name' AS culture_name,
    (raw_payload->'calendar'->>'id')::int AS calendar_id,
    raw_payload->'calendar'->>'name' AS calendar_name,
    (raw_payload->'legalEntity'->>'id')::int AS legalEntity_id,
    raw_payload->'legalEntity'->>'name' AS legalEntity_name,
    (raw_payload->'rolePrincipal'->>'id')::int AS rolePrincipal_id,
    raw_payload->'rolePrincipal'->>'name' AS rolePrincipal_name,

    -- Habilited roles (tableau)
    ARRAY_TO_STRING(ARRAY(
        SELECT hr->>'name'
        FROM jsonb_array_elements(raw_payload->'habilitedRoles') AS hr
    ), ', ') AS habilitedRoles_names,

    ARRAY_TO_STRING(ARRAY(
        SELECT (hr->>'id')::int
        FROM jsonb_array_elements(raw_payload->'habilitedRoles') AS hr
    ), ',') AS habilitedRoles_ids,

    -- User work cycles (tableau)
    ARRAY_TO_STRING(ARRAY(
        SELECT (uwc->>'id')::int
        FROM jsonb_array_elements(raw_payload->'userWorkCycles') AS uwc
    ), ',') AS workCycle_ids,

    ARRAY_TO_STRING(ARRAY(
        SELECT uwc->>'ownerID'
        FROM jsonb_array_elements(raw_payload->'userWorkCycles') AS uwc
    ), ',') AS workCycle_ownerIDs,

    ARRAY_TO_STRING(ARRAY(
        SELECT uwc->>'workCycleID'
        FROM jsonb_array_elements(raw_payload->'userWorkCycles') AS uwc
    ), ',') AS workCycle_workCycleIDs,

    ARRAY_TO_STRING(ARRAY(
        SELECT uwc->>'startsOn'
        FROM jsonb_array_elements(raw_payload->'userWorkCycles') AS uwc
    ), ',') AS workCycle_starts,

    ARRAY_TO_STRING(ARRAY(
        SELECT uwc->>'endsOn'
        FROM jsonb_array_elements(raw_payload->'userWorkCycles') AS uwc
    ), ',') AS workCycle_ends

from "lucca_db"."public"."users"