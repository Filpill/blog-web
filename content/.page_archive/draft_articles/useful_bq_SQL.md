## Retrieve Stored Procedures
Takes a snapshot of procedure names and DDL contents from the Google BigQuery.

```SQL
WITH project_procedures AS (
select
    CONCAT(routine_catalog,'.',routine_schema,'.',routine_name) AS stored_procedure_path
   ,'"' || ddl || '"' AS ddl,
   last_altered
from `skyuk-uk-vis-cust-res-d1-lab.stored_procedures.INFORMATION_SCHEMA.ROUTINES`
)
SELECT * FROM project_procedures
```

It's worth considering that BigQuery does not save a history of revised Stored Procedures.

Creating a change history is down to you to create through some kind of Git-based CI/CD or by potentially creating a table with Type 2 SCD's.


  SELECT  
    jbp.destination_table.project_id || '.' || jbp.destination_table.dataset_id || '.' || jbp.destination_table.table_id AS table_name
  FROM `region-eu`.INFORMATION_SCHEMA.JOBS_BY_PROJECT jbp
        ,UNNEST(referenced_tables) rt
  WHERE
    job_type = "QUERY"
    AND user_email = "firstname.lastname@email.com"
    AND DATE(creation_time) >= CURRENT_DATE()
  ORDER BY creation_time DESC
  LIMIT 1




SELECT
   jbp.job_id
  ,jbp.creation_time
  ,jbp.user_email
  ,jbp.statement_type
  ,jbp.priority
  ,jbp.start_time
  ,jbp.end_time
  ,jbp.state
  ,jbp.reservation_id
  ,jbp.total_bytes_processed
  ,jbp.total_slot_ms
  ,jbp.cache_hit
  ,rt.*
  ,jbp.destination_table.project_id as destination_project_id
  ,jbp.destination_table.dataset_id as destination_dataset_id
  ,jbp.destination_table.table_id   as destination_table_id
FROM 
  `region-eu`.INFORMATION_SCHEMA.JOBS_BY_PROJECT jbp
  ,unnest(referenced_tables) rt
WHERE
job_type = "QUERY"
    AND
user_email = "filip.livancic@sky.uk"
    AND
DATE(creation_time) >= '2023-05-17'

ORDER BY creation_time DESC

Columnar Array - Storage Compression
BEGIN
CREATE OR REPLACE TEMP TABLE array_table AS (
  SELECT 
    t.* except(comcast_rolloff_week,weekly_discount_value),
    ARRAY_AGG(
        STRUCT(comcast_rolloff_week,weekly_discount_value)
    ) AS rolloff_data
  FROM `skyuk-uk-vis-cust-res-u1-lab.tableau_broadband_team.bb_offer_rolloff` t
  GROUP BY ALL
);
END

Dynamic SQL
SET rolloff_weeks = (
  SELECT 
    CONCAT('("', STRING_AGG(DISTINCT comcast_rolloff_week, '", "'), '")') 
  FROM rolloff_calendar ORDER BY 1 ASC
);

EXECUTE IMMEDIATE format("""
  CREATE OR REPLACE TABLE `skyuk-uk-vis-cust-res-d1-lab.tableau_broadband_team.bb_offer_rolloff_pivot` AS (
    SELECT 
      *
    FROM `skyuk-uk-vis-cust-res-d1-lab.tableau_broadband_team.bb_offer_rolloff_tableau`
    PIVOT(SUM(weekly_rolloff_value) FOR comcast_rolloff_week IN %s) 
  )
  
  """, rolloff_weeks);

Auto Expire
ALTER TABLE
  `project.`dataset`.`table`
SET
  OPTIONS(expiration_timestamp=TIMESTAMP '2024-05-01 00:00:00 UTC',
          description = 'Temp clone to enable SP testing due to object access issues.')
;

Permissions
select  * 
from  skyuk-uk-viewing-pres-prod.`region-eu`.INFORMATION_SCHEMA.OBJECT_PRIVILEGES
where  object_name = 'uk_pres_content_viewing_is'
and grantee like '%consumer%'
Column Search
SELECT * 
FROM skyuk-uk-viewing-pres-prod.uk_pres_content_viewing_is.INFORMATION_SCHEMA.COLUMNS 
WHERE column_name like '%nk%' 
ORDER BY table_name,column_name DESC;

Except Distinct

Identifies distinct rows which are not matching between the two tables

SELECT
      table_catalog,
      table_schema,
      table_name,
      column_name,
      data_type,
      is_nullable,
      is_partitioning_column,
      clustering_ordinal_position,
      ordinal_position,
      collation_name
      column_comment
    FROM
      -- `skyuk-uk-vis-cust-res-p1-lab.key_tables.INFORMATION_SCHEMA.COLUMNS`
      `skyuk-uk-customer-pres-dev.uk_pub_customer_assurance_is.INFORMATION_SCHEMA.COLUMNS`
    WHERE
      lower(table_name) IN ('dim_assurance_case_management_guarantee_details')

EXCEPT DISTINCT

  SELECT
      table_catalog,
      table_schema,
      table_name,
      column_name,
      data_type,
      is_nullable,
      is_partitioning_column,
      clustering_ordinal_position,
      ordinal_position,
      collation_name
      column_comment
    FROM
      -- `skyuk-uk-vis-cust-res-p1-lab.key_tables.INFORMATION_SCHEMA.COLUMNS`
      `skyuk-uk-customer-pres-u01.uk_pub_customer_assurance_is.INFORMATION_SCHEMA.COLUMNS`
    WHERE
      lower(table_name) IN ('dim_assurance_case_management_guarantee_details' )
  ;
 
Info Schema Routines

The routine_definition col contains the data for the SP design.

select
     specific_catalog
    ,specific_schema
    ,specific_name
    ,routine_catalog
    ,routine_schema
    ,routine_name
    ,routine_type
    ,data_type
    ,routine_body
    ,routine_definition
    ,external_language
    ,is_deterministic
    ,security_type
    ,created
    ,last_altered
    ,ddl
from 
--`skyuk-uk-vis-cust-res-p1-lab.batch_processing.INFORMATION_SCHEMA.ROUTINES`
`skyuk-uk-vis-cust-res-p1-lab.stored_procedures.INFORMATION_SCHEMA.ROUTINES`
;
Data Lineage

Sample SQL for "dbfiddle" designed for postGres database in order trace lineage of a set of id values

CREATE TABLE test
(
  id INTEGER,
  parent_project_id INTEGER
);


INSERT INTO test (id, parent_project_id) VALUES
  (2, 1),
  (3, 1),
  (7, 2),
  (8, 3),
  (9, 3),
  (10, 8),
  (11, 8);
  
  
  CREATE TABLE path_names
  (
    id INTEGER,
    path_name VARCHAR
  );
  
 INSERT INTO path_names (id, path_name) VALUES
  (1,'A'),
  (2,'B'),
  (3,'C'),
  (4,'D'),
  (5,'E'),
  (6,'F'),
  (7,'G'),
  (8,'H'),
  (9,'I'),
  (10,'J'),
  (11,'K');
   
   
/* Need to join back to the project name */
WITH RECURSIVE
c
AS
(
--SELECT 1 AS leaf,
--       1 AS parent,
--       0 AS n
--UNION ALL
SELECT id AS leaf,
       id AS parent,
       0 AS n
       FROM test
UNION ALL
SELECT leaf,
       t.parent_project_id AS parent,
       c.n + 1
       FROM test AS t
            INNER JOIN c
                       ON c.parent = t.id
)
SELECT leaf AS id,
       array_agg(parent ORDER BY n DESC) FILTER (WHERE parent IS NOT NULL) AS ancestry,
       max(parent) FILTER (WHERE n = 1) AS parent,
       STRING_AGG(parent::text,'>' order by n DESC) FILTER (WHERE parent IS NOT NULL) as path
       FROM c
       GROUP BY leaf
       ORDER BY leaf;


