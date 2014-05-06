--liquibase formatted sql

--changeset kmschoep:add_method_online_no_analytes_flag

ALTER TRIGGER TR_U_JN_METHOD_ONLINE DISABLE;

alter table method_online add (NO_ANALYTE_FLAG     
        VARCHAR2(1 CHAR)  DEFAULT 'N');
        
 alter table method_online_jn add (NO_ANALYTE_FLAG     
        VARCHAR2(1 CHAR)  DEFAULT 'N');
        
COMMENT ON COLUMN METHOD_ONLINE.NO_ANALYTE_FLAG IS 'This value should be ''Y'' if there are no analytes associated with this method.';
ALTER TRIGGER TR_U_JN_METHOD_ONLINE ENABLE;
 
--changeset kmschoep:drop_cols
 
 alter table method_online drop (WQSA_CATEGORY_CD);
 
 alter table method_online_jn drop (WQSA_CATEGORY_CD);

--changeset kmschoep:drop_cols_analytes

 alter table analyte_method_jn_online drop (source_method_identifier);
 
--changeset kmschoep:mod_cols_analytes 
 
 alter table analyte_method_jn_online modify (last_update_date default null);
 
--changeset kmschoep:mod_cols_analytes2
 
 alter table analyte_method_jn_online modify (confirmatory varchar2(8 char));
 
--changeset kmschoep:mod_cols_revision2
 
 alter table revision_join_online modify (last_update_date default null);
 alter table revision_join_online modify (revision_flag default null);
 
 --changeset kmschoep:add_analyte_ref_cols
 
 alter table analyte_ref add(
 ANALYTE_TYPE          VARCHAR2(100 BYTE),
  DATA_ENTRY_NAME       VARCHAR2(50 BYTE),
  DATA_ENTRY_DATE       DATE,
  UPDATE_NAME           VARCHAR2(50 BYTE),
  UPDATE_DATE           DATE
);

--changeset kmschoep:add_analyte_code_rel_cols

alter table analyte_code_rel add (
  DATA_ENTRY_DATE  DATE,
  UPDATE_NAME      VARCHAR2(50 BYTE),
  ANALYTE_ID       NUMBER,
  ANALYTE_CODE_ID  NUMBER
 );
 

  
