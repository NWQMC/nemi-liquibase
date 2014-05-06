--liquibase formatted sql

--changeset kmschoep:DOWNLOAD_ONLINE_PDF splitStatements:false

CREATE OR REPLACE PROCEDURE NEMI_DATA.DOWNLOAD_ONLINE_PDF (p_file in number) as
 v_mime  varchar2(255);
 v_length  number;
 v_file_name varchar2(4000);
 Lob_loc  BLOB;
BEGIN
 select rj.mimetype, rj.method_pdf, rj.revision_id||'.pdf' ,dbms_lob.getlength(rj.method_pdf)
  into v_mime,lob_loc,v_file_name,v_length
  from revision_join_online rj
  where 
  exists (select 1 from method_online m where m.cbr_only = 'N' and m.method_id = rj.method_id) and 
  rj.revision_id = p_file;
              --
              -- set up HTTP header
              --
                    -- use an NVL around the mime type and
                    -- if it is a null set it to application/octect
                    -- application/octect may launch a download window from windows
                    owa_util.mime_header( nvl(v_mime,'application/octet'), FALSE );

                -- set the size so the browser knows how much to download
                htp.p('Content-length: ' || v_length);
                -- the filename will be used by the browser if the users does a save as
                htp.p('Content-Disposition: attachment; filename="' || v_file_name || '"');
  -- close the headers
                owa_util.http_header_close;
  -- download the BLOB
  wpg_docload.download_file( Lob_loc );

end download_online_pdf;

--changeset kmschoep:nemi_query_spec splitStatements:false

create or replace package nemi_query as
function entered_online_methods return clob;
end;

--changeset kmschoep:nemi_query_body splitStatements:false

create or replace package body nemi_query as
function entered_online_methods return clob is
v_query clob;
begin

v_query := q'^
SELECT method_id
,source_method_identifier
,method_descriptive_name
,insert_person_name
,completion_flag
,DECODE(ready_for_review, 'Y', 'X', NULL) ready_for_review
,method_type
,CASE
     WHEN completion_flag = 'COMPLETE' THEN
 APEX_ITEM.checkbox(50, method_id)
     ELSE
 NULL
 END
     review1
,last_update_person_name
,last_method_update
,method_pdf
,link_to_full_method
,num_current_revisions
,method_id method_id_display
  FROM (SELECT mo.method_id method_id
  ,mo.source_method_identifier source_method_identifier
  ,mo.method_descriptive_name method_descriptive_name
  ,mo.insert_person_name insert_person_name
  ,mo.link_to_full_method
  ,CASE
WHEN ((EXISTS
     (SELECT 1
 FROM analyte_method_jn_online amjo
WHERE amjo.method_id = mo.method_id)
     OR mo.no_analyte_flag = 'Y')
  AND EXISTS
    (SELECT 1
FROM revision_join_online rjo
      WHERE rjo.method_id = mo.method_id
 AND rjo.revision_flag = 1
 AND (rjo.method_pdf IS NOT NULL
    OR mo.link_to_full_method IS NOT NULL))) THEN
    'COMPLETE'
WHEN (EXISTS
    (SELECT 1
FROM analyte_method_jn_online amjo
      WHERE amjo.method_id = mo.method_id)
  AND NOT EXISTS
 (SELECT 1
     FROM revision_join_online rjo
    WHERE rjo.method_id = mo.method_id
      AND rjo.revision_flag = 1
      AND (rjo.method_pdf IS NOT NULL
 OR mo.link_to_full_method IS NOT NULL))) THEN
    'R'
WHEN (NOT EXISTS
    (SELECT 1
FROM analyte_method_jn_online amjo
      WHERE amjo.method_id = mo.method_id)
  AND EXISTS
    (SELECT 1
FROM revision_join_online rjo
      WHERE rjo.method_id = mo.method_id
 AND rjo.revision_flag = 1
 AND (rjo.method_pdf IS NOT NULL
    OR mo.link_to_full_method IS NOT NULL))) THEN
    'A'
WHEN (NOT EXISTS
    (SELECT 1
FROM analyte_method_jn_online amjo
      WHERE amjo.method_id = mo.method_id)
  AND NOT EXISTS
 (SELECT 1
     FROM revision_join_online rjo
    WHERE rjo.method_id = mo.method_id
      AND rjo.revision_flag = 1
      AND (rjo.method_pdf IS NOT NULL
 OR mo.link_to_full_method IS NOT NULL))) THEN
    'AR'
    END
completion_flag
  ,CASE
WHEN EXISTS
  (SELECT 1
      FROM method_subcategory_ref
     WHERE method_subcategory_id = mo.method_subcategory_id AND method_category IN ('CHEMICAL', 'PHYSICAL')) THEN 'P'
WHEN EXISTS
  (SELECT 1
      FROM method_subcategory_ref
     WHERE method_subcategory_id = mo.method_subcategory_id AND method_category = 'BIOLOGICAL') THEN 'B'
WHEN EXISTS
  (SELECT 1
      FROM method_subcategory_ref
     WHERE method_subcategory_id = mo.method_subcategory_id AND method_category = 'TOXICITY ASSAY') THEN 'T'
    END
method_type
  ,mo.ready_for_review
  ,mo.method_id upload_method
  ,mo.last_update_person_name
  ,mo.last_update_date last_method_update
  ,CASE
WHEN rjs.mimetype IS NOT NULL THEN
'<a href="/pls/nemi_pdf/nemi_data.download_online_pdf?p_file='|| revision_id|| '">View PDF <img src="#IMAGE_PREFIX#pdf.png" border="0" alt="Icon 1"></a>'
ELSE
    NULL END method_pdf
  ,SUM(NVL(rjs.revision_flag, 0))
OVER (PARTITION BY mo.method_id) num_current_revisions
     FROM method_online mo
  ,revision_join_online rjs
  ,analyte_method_jn_online amjs
    WHERE (LOWER(mo.insert_person_name) = LOWER(v('P70_USERS'))
 OR LOWER(mo.last_update_person_name) = LOWER(v('P70_USERS'))
 OR v('P70_USERS') IS NULL)
      AND (LOWER(mo.source_method_identifier) = LOWER(v('P70_METHOD'))
 OR v('P70_METHOD') IS NULL)
      AND (mo.approved = v('P70_APPROVED_FLAG')
 OR v('P70_APPROVED_FLAG') IS NULL
 OR v('P70_APPROVED_FLAG') = 'B')
      AND mo.method_id = rjs.method_id(+)
      AND mo.method_id = amjs.method_id(+)
      AND mo.method_subcategory_id NOT IN (16, 17)
      AND rjs.revision_flag(+) = 1
  GROUP BY mo.method_id
     ,mo.method_subcategory_id
     ,mo.source_method_identifier
     ,mo.method_descriptive_name
     ,mo.insert_person_name
     ,mo.link_to_full_method
     ,CASE
  WHEN ((EXISTS
(SELECT 1
    FROM analyte_method_jn_online amjo
  WHERE amjo.method_id = mo.method_id)
OR mo.no_analyte_flag = 'Y')
     AND EXISTS
      (SELECT 1
  FROM revision_join_online rjo
 WHERE rjo.method_id = mo.method_id
    AND rjo.revision_flag = 1
    AND (rjo.method_pdf IS NOT NULL
      OR mo.link_to_full_method IS NOT NULL))) THEN
      'COMPLETE'
  WHEN (EXISTS
      (SELECT 1
  FROM analyte_method_jn_online amjo
 WHERE amjo.method_id = mo.method_id)
     AND NOT EXISTS
    (SELECT 1
FROM revision_join_online rjo
      WHERE rjo.method_id = mo.method_id
 AND rjo.revision_flag = 1
 AND (rjo.method_pdf IS NOT NULL
    OR mo.link_to_full_method IS NOT NULL))) THEN
      'R'
  WHEN (NOT EXISTS
      (SELECT 1
  FROM analyte_method_jn_online amjo
 WHERE amjo.method_id = mo.method_id)
     AND EXISTS
      (SELECT 1
  FROM revision_join_online rjo
 WHERE rjo.method_id = mo.method_id
    AND rjo.revision_flag = 1
    AND (rjo.method_pdf IS NOT NULL
      OR mo.link_to_full_method IS NOT NULL))) THEN
      'A'
  WHEN (NOT EXISTS
      (SELECT 1
  FROM analyte_method_jn_online amjo
 WHERE amjo.method_id = mo.method_id)
     AND NOT EXISTS
    (SELECT 1
FROM revision_join_online rjo
      WHERE rjo.method_id = mo.method_id
 AND rjo.revision_flag = 1
 AND (rjo.method_pdf IS NOT NULL
    OR mo.link_to_full_method IS NOT NULL))) THEN
      'AR'
      END
     ,CASE
  WHEN EXISTS
     (SELECT NULL
 FROM method
WHERE method_id = mo.method_id) THEN 'X' ELSE NULL END
     ,CASE WHEN EXISTS (SELECT 1
 FROM method_subcategory_ref
WHERE method_subcategory_id =
    mo.method_subcategory_id
  AND method_category IN
    ('CHEMICAL', 'PHYSICAL')) THEN
      'P'
  WHEN EXISTS
     (SELECT 1
 FROM method_subcategory_ref
WHERE method_subcategory_id =
    mo.method_subcategory_id
  AND method_category = 'BIOLOGICAL') THEN
      'B'
  WHEN EXISTS
     (SELECT 1
 FROM method_subcategory_ref
WHERE method_subcategory_id =
    mo.method_subcategory_id
  AND method_category = 'TOXICITY ASSAY') THEN
      'T'
      END
     ,mo.ready_for_review
     ,mo.method_id
     ,mo.last_update_person_name
     ,mo.last_update_date
     ,rjs.revision_flag
     ,CASE
  WHEN rjs.mimetype IS NOT NULL THEN
  '<a href="/pls/nemi_pdf/nemi_data.download_online_pdf?p_file='
      || revision_id
      || '">View PDF <img src="#IMAGE_PREFIX#pdf.png" border="0" alt="Icon 1"></a>'
  ELSE
      NULL
      END
     ,mo.no_analyte_flag)
 WHERE ((num_current_revisions = 0 AND v('P70_REVISION_FLAG') LIKE '%0%')
      OR (num_current_revisions > 1 AND v('P70_REVISION_FLAG') LIKE '%2%')
      OR v('P70_REVISION_FLAG') IS NULL)
    AND (INSTR(':' || v('P70_MISSING_ELEMENTS') || ':'
 ,':' || completion_flag || ':'
 ) > 0
      OR (link_to_full_method IS NULL
      AND method_pdf IS NULL
      AND INSTR(':' || v('P70_MISSING_ELEMENTS') || ':', ':PDF:') > 0)
      OR v('P70_MISSING_ELEMENTS') IS NULL)
    AND (ready_for_review = v'(P70_READY_FOR_REVIEW')
      OR v'(P70_READY_FOR_REVIEW') IS NULL)^'

;
return v_query;
end;
end;

-- changeset kmschoep:grants
grant execute on nemi_query to nemi_data_apex;