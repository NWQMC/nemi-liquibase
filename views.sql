--liquibase formatted sql

--changeset kmschoep:analyte_vw

CREATE OR REPLACE FORCE VIEW analyte_vw
AS
	SELECT b.analyte_code
			,a.analyte_name
			,a.preferred
			,a.analyte_type
			,b.analyte_id
			,b.analyte_cbr
			,b.usgs_pcode
	  FROM analyte_code_rel a, analyte_ref b
	 WHERE a.analyte_id = b.analyte_id;