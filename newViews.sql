--liquibase formatted sql

--changeset kmschoep:entered_online_view

CREATE OR REPLACE FORCE VIEW entered_online_view
(
	method_id
  ,source_method_identifier
  ,method_descriptive_name
  ,insert_person_name
  ,completion_flag
  ,ready_for_review
  ,method_type
  ,last_update_person_name
  ,last_method_update
  ,method_pdf
  ,link_to_full_method
  ,num_current_revisions
  ,method_id_display
)
AS
	SELECT method_id
			,source_method_identifier
			,method_descriptive_name
			,insert_person_name
			,completion_flag
			,DECODE(ready_for_review, 'Y', 'X', NULL) ready_for_review
			,method_type
			,last_update_person_name
			,last_method_update
			,method_pdf
			,link_to_full_method
			,num_current_revisions
			,method_id method_id_display
	  FROM (SELECT mo.method_id method_id
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
							completion_flag
					  ,CASE
							WHEN EXISTS
									  (SELECT 1
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
							method_type
					  ,mo.ready_for_review
					  ,mo.method_id upload_method
					  ,mo.last_update_person_name
					  ,mo.last_update_date last_method_update
					  ,CASE
							WHEN rjs.mimetype IS NOT NULL THEN revision_id
							ELSE NULL
						END
							method_pdf
					  ,SUM(NVL(rjs.revision_flag, 0))
							OVER (PARTITION BY mo.method_id)
							num_current_revisions
				 FROM method_online mo
					  ,revision_join_online rjs
					  ,analyte_method_jn_online amjs
				WHERE mo.method_id = rjs.method_id(+)
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
														OR mo.link_to_full_method
																IS NOT NULL))) THEN
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
														OR mo.link_to_full_method
																IS NOT NULL))) THEN
								  'AR'
						  END
						 ,CASE
							  WHEN EXISTS
										 (SELECT NULL
											 FROM method
											WHERE method_id = mo.method_id) THEN
								  'X'
							  ELSE
								  NULL
						  END
						 ,CASE
							  WHEN EXISTS
										 (SELECT 1
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
							  WHEN rjs.mimetype IS NOT NULL THEN revision_id
							  ELSE NULL
						  END
						 ,mo.no_analyte_flag);
						 
--changeset kmschoep:grants

grant select on entered_online_view to nemi_data_apex;
