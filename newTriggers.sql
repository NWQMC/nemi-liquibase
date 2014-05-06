--liquibase formatted sql

--changeset kmschoep:TR_U_APPROVED_STG splitStatements:false

CREATE OR REPLACE TRIGGER NEMI_DATA.TR_U_APPROVED_STG
AFTER UPDATE
OF APPROVED
ON NEMI_DATA.METHOD_STG 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
declare
v_category varchar2(100);

BEGIN
select distinct method_category into v_category from METHOD_SUBCATEGORY_REF
where method_subcategory_id =  :new.method_subcategory_id;

if v_category != 'STATISTICAL' THEN

if nvl(:old.approved,'N') = 'N' and :new.approved = 'Y'
then
      UPDATE method SET                                        
METHOD_SUBCATEGORY_ID = :new.METHOD_SUBCATEGORY_ID,                  
METHOD_SOURCE_ID = :new.METHOD_SOURCE_ID,                            
SOURCE_CITATION_ID = :new.SOURCE_CITATION_ID,                        
SOURCE_METHOD_IDENTIFIER = :new.SOURCE_METHOD_IDENTIFIER,            
METHOD_DESCRIPTIVE_NAME = :new.METHOD_DESCRIPTIVE_NAME,              
METHOD_OFFICIAL_NAME = :new.METHOD_OFFICIAL_NAME,                    
MEDIA_NAME = :new.MEDIA_NAME,                                        
BRIEF_METHOD_SUMMARY = :new.BRIEF_METHOD_SUMMARY,                    
SCOPE_AND_APPLICATION = :new.SCOPE_AND_APPLICATION,                  
DL_TYPE_ID = :new.DL_TYPE_ID,                                        
DL_NOTE = :new.DL_NOTE,                                              
APPLICABLE_CONC_RANGE = :new.APPLICABLE_CONC_RANGE,                  
CONC_RANGE_UNITS = :new.CONC_RANGE_UNITS,                            
INTERFERENCES = :new.INTERFERENCES,                                  
QC_REQUIREMENTS = :new.QC_REQUIREMENTS,                              
SAMPLE_HANDLING = :new.SAMPLE_HANDLING,                              
MAX_HOLDING_TIME = :new.MAX_HOLDING_TIME,                            
SAMPLE_PREP_METHODS = :new.SAMPLE_PREP_METHODS,                      
RELATIVE_COST_ID = :new.RELATIVE_COST_ID,                            
LINK_TO_FULL_METHOD = :new.LINK_TO_FULL_METHOD,                      
INSERT_DATE = :new.INSERT_DATE,                                      
INSERT_PERSON_NAME = :new.INSERT_PERSON_NAME,                        
LAST_UPDATE_DATE = :new.LAST_UPDATE_DATE,                            
LAST_UPDATE_PERSON_NAME = :new.LAST_UPDATE_PERSON_NAME,              
APPROVED = :new.APPROVED,                                            
APPROVED_DATE = :new.APPROVED_DATE,                                  
INSTRUMENTATION_ID = :new.INSTRUMENTATION_ID,                        
PRECISION_DESCRIPTOR_NOTES = :new.PRECISION_DESCRIPTOR_NOTES,        
RAPIDITY = :new.RAPIDITY,                                            
CBR_ONLY = :new.CBR_ONLY,                                            
WATERBODY_TYPE = :new.WATERBODY_TYPE,                                
MATRIX = :new.MATRIX,                                                
TECHNIQUE = :new.TECHNIQUE,                                          
SCREENING = :new.SCREENING,                                          
ETV_LINK = :new.ETV_LINK,                                            
DATE_LOADED = sysdate,                                      
REVIEWER_NAME = :new.REVIEWER_NAME,                                  
REGS_ONLY = :new.REGS_ONLY,                                          
METHOD_TYPE_ID = :new.METHOD_TYPE_ID,                                
ANALYSIS_AMT_ML = :new.ANALYSIS_AMT_ML,                              
CORROSIVE = :new.CORROSIVE,                                          
COLLECTED_SAMPLE_AMT_G = :new.COLLECTED_SAMPLE_AMT_G,                
PBT = :new.PBT,                                                      
TOXIC = :new.TOXIC,                                                  
COLLECTED_SAMPLE_AMT_ML = :new.COLLECTED_SAMPLE_AMT_ML,              
PH_OF_ANALYTICAL_SAMPLE = :new.PH_OF_ANALYTICAL_SAMPLE,              
QUALITY_REVIEW_ID = :new.QUALITY_REVIEW_ID,                          
LIQUID_SAMPLE_FLAG = :new.LIQUID_SAMPLE_FLAG,                        
ANALYSIS_AMT_G = :new.ANALYSIS_AMT_G,                                
WASTE = :new.WASTE,                                                  
ASSUMPTIONS_COMMENTS = :new.ASSUMPTIONS_COMMENTS,                    
CALC_WASTE_AMT = :new.CALC_WASTE_AMT,                                                                                                       
NOTES = :new.NOTES,                                                  
MEDIA_SUBCATEGORY = :new.MEDIA_SUBCATEGORY,                          
LEVEL_OF_TRAINING = :new.LEVEL_OF_TRAINING,                          
MEDIA_EMPHASIZED_NOTE = :new.MEDIA_EMPHASIZED_NOTE,                  
SAM_COMPLEXITY = :new.SAM_COMPLEXITY
where method_id = :new.method_id;
IF sql%ROWCOUNT=0 then
     INSERT into method (
METHOD_ID,                     
METHOD_SUBCATEGORY_ID,         
METHOD_SOURCE_ID,              
SOURCE_CITATION_ID,            
SOURCE_METHOD_IDENTIFIER,      
METHOD_DESCRIPTIVE_NAME,       
METHOD_OFFICIAL_NAME,          
MEDIA_NAME,                    
BRIEF_METHOD_SUMMARY,          
SCOPE_AND_APPLICATION,         
DL_TYPE_ID,                    
DL_NOTE,                       
APPLICABLE_CONC_RANGE,         
CONC_RANGE_UNITS,              
INTERFERENCES,                 
QC_REQUIREMENTS,               
SAMPLE_HANDLING,               
MAX_HOLDING_TIME,              
SAMPLE_PREP_METHODS,           
RELATIVE_COST_ID,              
LINK_TO_FULL_METHOD,           
INSERT_DATE,                   
INSERT_PERSON_NAME,            
LAST_UPDATE_DATE,              
LAST_UPDATE_PERSON_NAME,       
APPROVED,                      
APPROVED_DATE,                 
INSTRUMENTATION_ID,            
PRECISION_DESCRIPTOR_NOTES,    
RAPIDITY,                      
CBR_ONLY,                      
WATERBODY_TYPE,                
MATRIX,                        
TECHNIQUE,                     
SCREENING,                     
ETV_LINK,                      
DATE_LOADED,                   
REVIEWER_NAME,                 
REGS_ONLY,                     
METHOD_TYPE_ID,                
ANALYSIS_AMT_ML,               
CORROSIVE,                     
COLLECTED_SAMPLE_AMT_G,        
PBT,                           
TOXIC,                         
COLLECTED_SAMPLE_AMT_ML,       
PH_OF_ANALYTICAL_SAMPLE,       
QUALITY_REVIEW_ID,             
LIQUID_SAMPLE_FLAG,            
ANALYSIS_AMT_G,                
WASTE,                         
ASSUMPTIONS_COMMENTS,          
CALC_WASTE_AMT,                                               
NOTES,                         
MEDIA_SUBCATEGORY,             
LEVEL_OF_TRAINING,             
MEDIA_EMPHASIZED_NOTE,         
SAM_COMPLEXITY)
  VALUES (
:new.METHOD_ID,                     
:new.METHOD_SUBCATEGORY_ID,         
:new.METHOD_SOURCE_ID,              
:new.SOURCE_CITATION_ID,            
:new.SOURCE_METHOD_IDENTIFIER,      
:new.METHOD_DESCRIPTIVE_NAME,       
:new.METHOD_OFFICIAL_NAME,          
:new.MEDIA_NAME,                    
:new.BRIEF_METHOD_SUMMARY,          
:new.SCOPE_AND_APPLICATION,         
:new.DL_TYPE_ID,                    
:new.DL_NOTE,                       
:new.APPLICABLE_CONC_RANGE,         
:new.CONC_RANGE_UNITS,              
:new.INTERFERENCES,                 
:new.QC_REQUIREMENTS,               
:new.SAMPLE_HANDLING,               
:new.MAX_HOLDING_TIME,              
:new.SAMPLE_PREP_METHODS,           
:new.RELATIVE_COST_ID,              
:new.LINK_TO_FULL_METHOD,           
:new.INSERT_DATE,                   
:new.INSERT_PERSON_NAME,            
:new.LAST_UPDATE_DATE,              
:new.LAST_UPDATE_PERSON_NAME,       
:new.APPROVED,                      
:new.APPROVED_DATE,                 
:new.INSTRUMENTATION_ID,            
:new.PRECISION_DESCRIPTOR_NOTES,    
:new.RAPIDITY,                      
:new.CBR_ONLY,                      
:new.WATERBODY_TYPE,                
:new.MATRIX,                        
:new.TECHNIQUE,                     
:new.SCREENING,                     
:new.ETV_LINK,                      
sysdate,                   
:new.REVIEWER_NAME,                 
:new.REGS_ONLY,                     
:new.METHOD_TYPE_ID,                
:new.ANALYSIS_AMT_ML,               
:new.CORROSIVE,                     
:new.COLLECTED_SAMPLE_AMT_G,        
:new.PBT,                           
:new.TOXIC,                         
:new.COLLECTED_SAMPLE_AMT_ML,       
:new.PH_OF_ANALYTICAL_SAMPLE,       
:new.QUALITY_REVIEW_ID,             
:new.LIQUID_SAMPLE_FLAG,            
:new.ANALYSIS_AMT_G,                
:new.WASTE,                         
:new.ASSUMPTIONS_COMMENTS,          
:new.CALC_WASTE_AMT,                                                
:new.NOTES,                         
:new.MEDIA_SUBCATEGORY,             
:new.LEVEL_OF_TRAINING,             
:new.MEDIA_EMPHASIZED_NOTE,         
:new.SAM_COMPLEXITY);
end if;

merge_stg_to_prod.MergeStgAnalytes(:new.method_id);
merge_stg_to_prod.MergeStgRevisions(:new.method_id);
end if;
end if;
END;

--changeset kmschoep:tr_d_jn_analyte_method_jn_onl splitStatements:false

CREATE OR REPLACE TRIGGER tr_d_jn_analyte_method_jn_onl
BEFORE DELETE
ON ANALYTE_METHOD_JN_ONLINE 
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN

insert into    ANALYTE_METHOD_JN_ONLINE_JN (

JN_OPERATION,                  
JN_ORACLE_USER,                
JN_DATETIME,                                       
ANALYTE_METHOD_ID,             
METHOD_ID,                     
ANALYTE_ID,                    
DL_VALUE,                      
DL_UNITS,                      
ACCURACY,                      
ACCURACY_UNITS,                
FALSE_POSITIVE_VALUE,          
FALSE_NEGATIVE_VALUE,          
PRECISION,                     
PRECISION_UNITS,               
PREC_ACC_CONC_USED,            
INSERT_DATE,                   
INSERT_PERSON_NAME,            
LAST_UPDATE_DATE,              
LAST_UPDATE_PERSON_NAME,       
SOURCE_METHOD_IDENTIFIER,      
GREEN_FLAG,                    
YELLOW_FLAG,                   
CONFIRMATORY )
values ( 
'DEL',                   
'NEMI_DATA',                 
SYSDATE,         
:old.ANALYTE_METHOD_ID,             
:old.METHOD_ID,                     
:old.ANALYTE_ID,                    
:old.DL_VALUE,                      
:old.DL_UNITS,                      
:old.ACCURACY,                      
:old.ACCURACY_UNITS,                
:old.FALSE_POSITIVE_VALUE,          
:old.FALSE_NEGATIVE_VALUE,          
:old.PRECISION,                     
:old.PRECISION_UNITS,               
:old.PREC_ACC_CONC_USED,            
:old.INSERT_DATE,                   
:old.INSERT_PERSON_NAME,            
:old.LAST_UPDATE_DATE,              
:old.LAST_UPDATE_PERSON_NAME,       
:old.SOURCE_METHOD_IDENTIFIER,      
:old.GREEN_FLAG,                    
:old.YELLOW_FLAG,                   
:old.CONFIRMATORY)   ;
 
END;

--changeset kmschoep:tr_u_jn_analyte_method_jn_onl splitStatements:false

CREATE OR REPLACE TRIGGER tr_u_jn_analyte_method_jn_onl
BEFORE UPDATE
ON ANALYTE_METHOD_JN_ONLINE 
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN

insert into    ANALYTE_METHOD_JN_ONLINE_JN (

JN_OPERATION,                  
JN_ORACLE_USER,                
JN_DATETIME,                                       
ANALYTE_METHOD_ID,             
METHOD_ID,                     
ANALYTE_ID,                    
DL_VALUE,                      
DL_UNITS,                      
ACCURACY,                      
ACCURACY_UNITS,                
FALSE_POSITIVE_VALUE,          
FALSE_NEGATIVE_VALUE,          
PRECISION,                     
PRECISION_UNITS,               
PREC_ACC_CONC_USED,            
INSERT_DATE,                   
INSERT_PERSON_NAME,            
LAST_UPDATE_DATE,              
LAST_UPDATE_PERSON_NAME,       
SOURCE_METHOD_IDENTIFIER,      
GREEN_FLAG,                    
YELLOW_FLAG,                   
CONFIRMATORY )
values ( 
'UPD',                   
'NEMI_DATA',                 
SYSDATE,         
:old.ANALYTE_METHOD_ID,             
:old.METHOD_ID,                     
:old.ANALYTE_ID,                    
:old.DL_VALUE,                      
:old.DL_UNITS,                      
:old.ACCURACY,                      
:old.ACCURACY_UNITS,                
:old.FALSE_POSITIVE_VALUE,          
:old.FALSE_NEGATIVE_VALUE,          
:old.PRECISION,                     
:old.PRECISION_UNITS,               
:old.PREC_ACC_CONC_USED,            
:old.INSERT_DATE,                   
:old.INSERT_PERSON_NAME,            
:old.LAST_UPDATE_DATE,              
:old.LAST_UPDATE_PERSON_NAME,       
:old.SOURCE_METHOD_IDENTIFIER,      
:old.GREEN_FLAG,                    
:old.YELLOW_FLAG,                   
:old.CONFIRMATORY)   ;
end;

--changeset kmschoep:TR_U_JN_SOURCE_STG_ONLINE splitStatements:false

CREATE OR REPLACE TRIGGER TR_U_JN_SOURCE_STG_ONLINE
BEFORE UPDATE
ON NEMI_DATA.SOURCE_CITATION_STG_REF 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN

insert into    SOURCE_CITATION_STG_REF_JN (

JN_OPERATION,                  
JN_ORACLE_USER,                
JN_DATETIME,                   
SOURCE_CITATION_ID,            
SOURCE_CITATION,               
SOURCE_CITATION_NAME,          
SOURCE_CITATION_INFORMATION,   
INSERT_DATE,                   
TITLE,                         
AUTHOR,                        
ABSTRACT_SUMMARY,              
TABLE_OF_CONTENTS,             
LINK,                          
NOTES,                         
ITEM_TYPE_ID,                  
PUBLICATION_YEAR,                           
COUNTRY,                       
UPDATE_DATE,                                  
LEVEL_OF_TRAINING,             
ITEM_TYPE_NOTE,                
SPONSER_TYPE_NOTE,             
SUBCATEGORY,                   
COMPLEXITY,                    
MEDIA_EMPHASIZED_NOTE,         
SOURCE_ORGANIZATION_ID,        
INSERT_PERSON_NAME,
UPDATE_NAME )
values ( 
'UPD',                   
'NEMI_DATA',                 
SYSDATE,         
:old.SOURCE_CITATION_ID,            
:old.SOURCE_CITATION,               
:old.SOURCE_CITATION_NAME,          
:old.SOURCE_CITATION_INFORMATION,   
:old.INSERT_DATE,                   
:old.TITLE,                         
:old.AUTHOR,                        
:old.ABSTRACT_SUMMARY,              
:old.TABLE_OF_CONTENTS,             
:old.LINK,                          
:old.NOTES,                         
:old.ITEM_TYPE_ID,                  
:old.PUBLICATION_YEAR,              
:old.COUNTRY,                       
:old.UPDATE_DATE,                                   
:old.LEVEL_OF_TRAINING,             
:old.ITEM_TYPE_NOTE,                
:old.SPONSER_TYPE_NOTE,             
:old.SUBCATEGORY,                   
:old.COMPLEXITY,                    
:old.MEDIA_EMPHASIZED_NOTE,         
:old.SOURCE_ORGANIZATION_ID,        
:old.INSERT_PERSON_NAME,
:old.UPDATE_NAME)   ;
 
END;

--changeset kmschoep:TR_U_JN_SOURCE_CITATION_ONLINE splitStatements:false


CREATE OR REPLACE TRIGGER TR_U_JN_SOURCE_CITATION_ONLINE
BEFORE UPDATE
ON NEMI_DATA.SOURCE_CITATION_ONLINE_REF 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN

insert into    SOURCE_CITATION_ONLINE_REF_JN (

JN_OPERATION,                  
JN_ORACLE_USER,                
JN_DATETIME,                   
SOURCE_CITATION_ID,            
SOURCE_CITATION,               
SOURCE_CITATION_NAME,          
SOURCE_CITATION_INFORMATION,   
INSERT_DATE,                   
TITLE,                         
AUTHOR,                        
ABSTRACT_SUMMARY,              
TABLE_OF_CONTENTS,             
LINK,                          
NOTES,                         
ITEM_TYPE_ID,                  
PUBLICATION_YEAR,                           
COUNTRY,                       
UPDATE_DATE,                                  
LEVEL_OF_TRAINING,             
ITEM_TYPE_NOTE,                
SPONSER_TYPE_NOTE,             
SUBCATEGORY,                   
COMPLEXITY,                    
MEDIA_EMPHASIZED_NOTE,         
SOURCE_ORGANIZATION_ID,        
INSERT_PERSON_NAME,
UPDATE_NAME )
values ( 
'UPD',                   
'NEMI_DATA',                 
SYSDATE,         
:old.SOURCE_CITATION_ID,            
:old.SOURCE_CITATION,               
:old.SOURCE_CITATION_NAME,          
:old.SOURCE_CITATION_INFORMATION,   
:old.INSERT_DATE,                   
:old.TITLE,                         
:old.AUTHOR,                        
:old.ABSTRACT_SUMMARY,              
:old.TABLE_OF_CONTENTS,             
:old.LINK,                          
:old.NOTES,                         
:old.ITEM_TYPE_ID,                  
:old.PUBLICATION_YEAR,              
:old.COUNTRY,                       
:old.UPDATE_DATE,                                   
:old.LEVEL_OF_TRAINING,             
:old.ITEM_TYPE_NOTE,                
:old.SPONSER_TYPE_NOTE,             
:old.SUBCATEGORY,                   
:old.COMPLEXITY,                    
:old.MEDIA_EMPHASIZED_NOTE,         
:old.SOURCE_ORGANIZATION_ID,        
:old.INSERT_PERSON_NAME,
:old.UPDATE_NAME)   ;
 
END;

--changeset kmschoep:TR_U_JN_METHOD_STG splitStatements:false

CREATE OR REPLACE TRIGGER TR_U_JN_METHOD_STG
BEFORE UPDATE
ON NEMI_DATA.METHOD_STG 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
INSERT INTO METHOD_STG_JN (
JN_OPERATION,                   
JN_ORACLE_USER,                 
JN_DATETIME,                                       
METHOD_ID,                      
METHOD_SUBCATEGORY_ID,          
METHOD_SOURCE_ID,               
SOURCE_CITATION_ID,             
SOURCE_METHOD_IDENTIFIER,       
METHOD_DESCRIPTIVE_NAME,        
METHOD_OFFICIAL_NAME,           
MEDIA_NAME,                     
BRIEF_METHOD_SUMMARY,           
SCOPE_AND_APPLICATION,          
DL_TYPE_ID,                     
DL_NOTE,                        
APPLICABLE_CONC_RANGE,          
CONC_RANGE_UNITS,               
INTERFERENCES,                  
QC_REQUIREMENTS,                
SAMPLE_HANDLING,                
MAX_HOLDING_TIME,               
SAMPLE_PREP_METHODS,            
RELATIVE_COST_ID,               
LINK_TO_FULL_METHOD,            
INSERT_DATE,                    
INSERT_PERSON_NAME,             
LAST_UPDATE_DATE,               
LAST_UPDATE_PERSON_NAME,        
APPROVED,                       
APPROVED_DATE,                  
INSTRUMENTATION_ID,             
PRECISION_DESCRIPTOR_NOTES,     
RAPIDITY,                       
CBR_ONLY,                       
WATERBODY_TYPE,                 
MATRIX,                         
TECHNIQUE,                      
SCREENING,                      
ETV_LINK,                       
DATE_LOADED,                    
REVIEWER_NAME,                  
REGS_ONLY,                      
METHOD_TYPE_ID,                 
READY_FOR_REVIEW,               
COMMENTS,                       
COLLECTED_SAMPLE_AMT_ML,        
COLLECTED_SAMPLE_AMT_G,         
LIQUID_SAMPLE_FLAG,             
ANALYSIS_AMT_ML,                
ANALYSIS_AMT_G,                 
PH_OF_ANALYTICAL_SAMPLE,        
CALC_WASTE_AMT,                 
QUALITY_REVIEW_ID,              
PBT,                            
TOXIC,                          
CORROSIVE,                      
WASTE,                          
ASSUMPTIONS_COMMENTS,           
LEVEL_OF_TRAINING,              
MEDIA_SUBCATEGORY,              
MEDIA_EMPHASIZED_NOTE,          
SAM_COMPLEXITY,
NOTES,
NO_ANALYTE_FLAG,
OWNER_EDITABLE)
VALUES
(
'UPD',                   
'NEMI_DATA',                 
SYSDATE,                    
:OLD.METHOD_ID,                      
:OLD.METHOD_SUBCATEGORY_ID,          
:OLD.METHOD_SOURCE_ID,               
:OLD.SOURCE_CITATION_ID,             
:OLD.SOURCE_METHOD_IDENTIFIER,       
:OLD.METHOD_DESCRIPTIVE_NAME,        
:OLD.METHOD_OFFICIAL_NAME,           
:OLD.MEDIA_NAME,                     
:OLD.BRIEF_METHOD_SUMMARY,           
:OLD.SCOPE_AND_APPLICATION,          
:OLD.DL_TYPE_ID,                     
:OLD.DL_NOTE,                        
:OLD.APPLICABLE_CONC_RANGE,          
:OLD.CONC_RANGE_UNITS,               
:OLD.INTERFERENCES,                  
:OLD.QC_REQUIREMENTS,                
:OLD.SAMPLE_HANDLING,                
:OLD.MAX_HOLDING_TIME,               
:OLD.SAMPLE_PREP_METHODS,            
:OLD.RELATIVE_COST_ID,               
:OLD.LINK_TO_FULL_METHOD,            
:OLD.INSERT_DATE,                    
:OLD.INSERT_PERSON_NAME,             
:OLD.LAST_UPDATE_DATE,               
:OLD.LAST_UPDATE_PERSON_NAME,        
:OLD.APPROVED,                       
:OLD.APPROVED_DATE,                  
:OLD.INSTRUMENTATION_ID,             
:OLD.PRECISION_DESCRIPTOR_NOTES,     
:OLD.RAPIDITY,                       
:OLD.CBR_ONLY,                       
:OLD.WATERBODY_TYPE,                 
:OLD.MATRIX,                         
:OLD.TECHNIQUE,                      
:OLD.SCREENING,                      
:OLD.ETV_LINK,                       
:OLD.DATE_LOADED,                    
:OLD.REVIEWER_NAME,                  
:OLD.REGS_ONLY,                      
:OLD.METHOD_TYPE_ID,                 
:OLD.READY_FOR_REVIEW,               
:OLD.COMMENTS,                       
:OLD.COLLECTED_SAMPLE_AMT_ML,        
:OLD.COLLECTED_SAMPLE_AMT_G,         
:OLD.LIQUID_SAMPLE_FLAG,             
:OLD.ANALYSIS_AMT_ML,                
:OLD.ANALYSIS_AMT_G,                 
:OLD.PH_OF_ANALYTICAL_SAMPLE,        
:OLD.CALC_WASTE_AMT,                 
:OLD.QUALITY_REVIEW_ID,              
:OLD.PBT,                            
:OLD.TOXIC,                          
:OLD.CORROSIVE,                      
:OLD.WASTE,                          
:OLD.ASSUMPTIONS_COMMENTS,           
:OLD.LEVEL_OF_TRAINING,              
:OLD.MEDIA_SUBCATEGORY,              
:OLD.MEDIA_EMPHASIZED_NOTE,          
:OLD.SAM_COMPLEXITY,
:OLD.NOTES,
:OLD.NO_ANALYTE_FLAG,
:OLD.OWNER_EDITABLE);  
END;

--changeset kmschoep:TR_D_JN_SOURCE_CITATION_ONLINE splitStatements:false

CREATE OR REPLACE TRIGGER TR_D_JN_SOURCE_CITATION_ONLINE
BEFORE DELETE
ON NEMI_DATA.SOURCE_CITATION_ONLINE_REF 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN

insert into    SOURCE_CITATION_ONLINE_REF_JN (

JN_OPERATION,                  
JN_ORACLE_USER,                
JN_DATETIME,                   
SOURCE_CITATION_ID,            
SOURCE_CITATION,               
SOURCE_CITATION_NAME,          
SOURCE_CITATION_INFORMATION,   
INSERT_DATE,                   
TITLE,                         
AUTHOR,                        
ABSTRACT_SUMMARY,              
TABLE_OF_CONTENTS,             
LINK,                          
NOTES,                         
ITEM_TYPE_ID,                  
PUBLICATION_YEAR,                           
COUNTRY,                       
UPDATE_DATE,                                  
LEVEL_OF_TRAINING,             
ITEM_TYPE_NOTE,                
SPONSER_TYPE_NOTE,             
SUBCATEGORY,                   
COMPLEXITY,                    
MEDIA_EMPHASIZED_NOTE,         
SOURCE_ORGANIZATION_ID,        
INSERT_PERSON_NAME,
UPDATE_NAME )
values ( 
'DEL',                   
'NEMI_DATA',                 
SYSDATE,         
:old.SOURCE_CITATION_ID,            
:old.SOURCE_CITATION,               
:old.SOURCE_CITATION_NAME,          
:old.SOURCE_CITATION_INFORMATION,   
:old.INSERT_DATE,                   
:old.TITLE,                         
:old.AUTHOR,                        
:old.ABSTRACT_SUMMARY,              
:old.TABLE_OF_CONTENTS,             
:old.LINK,                          
:old.NOTES,                         
:old.ITEM_TYPE_ID,                  
:old.PUBLICATION_YEAR,              
:old.COUNTRY,                       
:old.UPDATE_DATE,                                   
:old.LEVEL_OF_TRAINING,             
:old.ITEM_TYPE_NOTE,                
:old.SPONSER_TYPE_NOTE,             
:old.SUBCATEGORY,                   
:old.COMPLEXITY,                    
:old.MEDIA_EMPHASIZED_NOTE,         
:old.SOURCE_ORGANIZATION_ID,        
:old.INSERT_PERSON_NAME,
:old.UPDATE_NAME)   ;
 
END;

--changeset kmschoep:TR_D_JN_METHOD_STG splitStatements:false


CREATE OR REPLACE TRIGGER TR_D_JN_METHOD_STG
BEFORE DELETE
ON NEMI_DATA.METHOD_STG 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
INSERT INTO METHOD_STG_JN (
JN_OPERATION,                   
JN_ORACLE_USER,                 
JN_DATETIME,                                       
METHOD_ID,                      
METHOD_SUBCATEGORY_ID,          
METHOD_SOURCE_ID,               
SOURCE_CITATION_ID,             
SOURCE_METHOD_IDENTIFIER,       
METHOD_DESCRIPTIVE_NAME,        
METHOD_OFFICIAL_NAME,           
MEDIA_NAME,                     
BRIEF_METHOD_SUMMARY,           
SCOPE_AND_APPLICATION,          
DL_TYPE_ID,                     
DL_NOTE,                        
APPLICABLE_CONC_RANGE,          
CONC_RANGE_UNITS,               
INTERFERENCES,                  
QC_REQUIREMENTS,                
SAMPLE_HANDLING,                
MAX_HOLDING_TIME,               
SAMPLE_PREP_METHODS,            
RELATIVE_COST_ID,               
LINK_TO_FULL_METHOD,            
INSERT_DATE,                    
INSERT_PERSON_NAME,             
LAST_UPDATE_DATE,               
LAST_UPDATE_PERSON_NAME,        
APPROVED,                       
APPROVED_DATE,                  
INSTRUMENTATION_ID,             
PRECISION_DESCRIPTOR_NOTES,     
RAPIDITY,                       
CBR_ONLY,                       
WATERBODY_TYPE,                 
MATRIX,                         
TECHNIQUE,                      
SCREENING,                      
ETV_LINK,                       
DATE_LOADED,                    
REVIEWER_NAME,                  
REGS_ONLY,                      
METHOD_TYPE_ID,                 
READY_FOR_REVIEW,               
COMMENTS,                       
COLLECTED_SAMPLE_AMT_ML,        
COLLECTED_SAMPLE_AMT_G,         
LIQUID_SAMPLE_FLAG,             
ANALYSIS_AMT_ML,                
ANALYSIS_AMT_G,                 
PH_OF_ANALYTICAL_SAMPLE,        
CALC_WASTE_AMT,                 
QUALITY_REVIEW_ID,              
PBT,                            
TOXIC,                          
CORROSIVE,                      
WASTE,                          
ASSUMPTIONS_COMMENTS,           
LEVEL_OF_TRAINING,              
MEDIA_SUBCATEGORY,              
MEDIA_EMPHASIZED_NOTE,          
SAM_COMPLEXITY,
NOTES,
NO_ANALYTE_FLAG,
OWNER_EDITABLE)
VALUES
(
'DEL',                   
'NEMI_DATA',                 
SYSDATE,                    
:OLD.METHOD_ID,                      
:OLD.METHOD_SUBCATEGORY_ID,          
:OLD.METHOD_SOURCE_ID,               
:OLD.SOURCE_CITATION_ID,             
:OLD.SOURCE_METHOD_IDENTIFIER,       
:OLD.METHOD_DESCRIPTIVE_NAME,        
:OLD.METHOD_OFFICIAL_NAME,           
:OLD.MEDIA_NAME,                     
:OLD.BRIEF_METHOD_SUMMARY,           
:OLD.SCOPE_AND_APPLICATION,          
:OLD.DL_TYPE_ID,                     
:OLD.DL_NOTE,                        
:OLD.APPLICABLE_CONC_RANGE,          
:OLD.CONC_RANGE_UNITS,               
:OLD.INTERFERENCES,                  
:OLD.QC_REQUIREMENTS,                
:OLD.SAMPLE_HANDLING,                
:OLD.MAX_HOLDING_TIME,               
:OLD.SAMPLE_PREP_METHODS,            
:OLD.RELATIVE_COST_ID,               
:OLD.LINK_TO_FULL_METHOD,            
:OLD.INSERT_DATE,                    
:OLD.INSERT_PERSON_NAME,             
:OLD.LAST_UPDATE_DATE,               
:OLD.LAST_UPDATE_PERSON_NAME,        
:OLD.APPROVED,                       
:OLD.APPROVED_DATE,                  
:OLD.INSTRUMENTATION_ID,             
:OLD.PRECISION_DESCRIPTOR_NOTES,     
:OLD.RAPIDITY,                       
:OLD.CBR_ONLY,                       
:OLD.WATERBODY_TYPE,                 
:OLD.MATRIX,                         
:OLD.TECHNIQUE,                      
:OLD.SCREENING,                      
:OLD.ETV_LINK,                       
:OLD.DATE_LOADED,                    
:OLD.REVIEWER_NAME,                  
:OLD.REGS_ONLY,                      
:OLD.METHOD_TYPE_ID,                 
:OLD.READY_FOR_REVIEW,               
:OLD.COMMENTS,                       
:OLD.COLLECTED_SAMPLE_AMT_ML,        
:OLD.COLLECTED_SAMPLE_AMT_G,         
:OLD.LIQUID_SAMPLE_FLAG,             
:OLD.ANALYSIS_AMT_ML,                
:OLD.ANALYSIS_AMT_G,                 
:OLD.PH_OF_ANALYTICAL_SAMPLE,        
:OLD.CALC_WASTE_AMT,                 
:OLD.QUALITY_REVIEW_ID,              
:OLD.PBT,                            
:OLD.TOXIC,                          
:OLD.CORROSIVE,                      
:OLD.WASTE,                          
:OLD.ASSUMPTIONS_COMMENTS,           
:OLD.LEVEL_OF_TRAINING,              
:OLD.MEDIA_SUBCATEGORY,              
:OLD.MEDIA_EMPHASIZED_NOTE,          
:OLD.SAM_COMPLEXITY,
:OLD.NOTES,
:OLD.NO_ANALYTE_FLAG,
:OLD.OWNER_EDITABLE
);  
END;

--changeset kmschoep:TR_AMJ_ONLINE_DATE_INS splitStatements:false


CREATE OR REPLACE TRIGGER TR_AMJ_ONLINE_DATE_INS
BEFORE INSERT
ON NEMI_DATA.ANALYTE_METHOD_JN_ONLINE 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN

IF  :NEW.analyte_method_id IS NULL THEN
   :NEW.analyte_method_id := ANALYTE_METHOD_ID_SEQ.NEXTVAL;
END IF;
   :NEW.INSERT_DATE := SYSDATE;
   
   EXCEPTION
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END TR_AMJ_ONLINE_DATE_INS;

--changeset kmschoep:TR_I_METHOD splitStatements:false

CREATE OR REPLACE TRIGGER TR_I_METHOD
BEFORE INSERT
ON NEMI_DATA.METHOD 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
WHEN (
NEW.method_id is null
      )
DECLARE
tmpVar NUMBER;
/******************************************************************************
   NAME:       tr_i_method
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        4/27/2006             1. Created this trigger.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     tr_i_method
      Sysdate:         4/27/2006
      Date and Time:   4/27/2006, 8:53:11 AM, and 4/27/2006 8:53:11 AM
      Username:         (set in TOAD Options, Proc Templates)
      Table Name:      METHOD (set in the "New PL/SQL Object" dialog)
      Trigger Options:  (set in the "New PL/SQL Object" dialog)
******************************************************************************/
BEGIN
   tmpVar := 0;

   SELECT method_id_seq.NEXTVAL INTO tmpVar FROM dual;
   :NEW.method_id := tmpVar;


   EXCEPTION
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END tr_i_method;

--changeset kmschoep:tr_d_jn_analyte_method_jn_stg splitStatements:false

CREATE OR REPLACE TRIGGER tr_d_jn_analyte_method_jn_stg
BEFORE DELETE
ON ANALYTE_METHOD_JN_STG 
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN

insert into    ANALYTE_METHOD_JN_STG_JN (

JN_OPERATION,                  
JN_ORACLE_USER,                
JN_DATETIME,                                      
ANALYTE_METHOD_ID,             
METHOD_ID,                     
ANALYTE_ID,                    
DL_VALUE,                      
DL_UNITS,                      
ACCURACY,                      
ACCURACY_UNITS,                
FALSE_POSITIVE_VALUE,          
FALSE_NEGATIVE_VALUE,          
PRECISION,                     
PRECISION_UNITS,               
PREC_ACC_CONC_USED,            
INSERT_DATE,                   
INSERT_PERSON_NAME,            
LAST_UPDATE_DATE,              
LAST_UPDATE_PERSON_NAME,       
GREEN_FLAG,                    
YELLOW_FLAG,                   
CONFIRMATORY,                  
DATE_LOADED)
values ( 
'DEL',                   
'NEMI_DATA',                 
SYSDATE,         
:OLD.ANALYTE_METHOD_ID,             
:OLD.METHOD_ID,                     
:OLD.ANALYTE_ID,                    
:OLD.DL_VALUE,                      
:OLD.DL_UNITS,                      
:OLD.ACCURACY,                      
:OLD.ACCURACY_UNITS,                
:OLD.FALSE_POSITIVE_VALUE,          
:OLD.FALSE_NEGATIVE_VALUE,          
:OLD.PRECISION,                     
:OLD.PRECISION_UNITS,               
:OLD.PREC_ACC_CONC_USED,            
:OLD.INSERT_DATE,                   
:OLD.INSERT_PERSON_NAME,            
:OLD.LAST_UPDATE_DATE,              
:OLD.LAST_UPDATE_PERSON_NAME,       
:OLD.GREEN_FLAG,                    
:OLD.YELLOW_FLAG,                   
:OLD.CONFIRMATORY,                  
:OLD.DATE_LOADED)   ;
 
END;

--changeset kmschoep:tr_u_jn_analyte_method_jn_stg splitStatements:false


CREATE OR REPLACE TRIGGER tr_u_jn_analyte_method_jn_stg
BEFORE UPDATE
ON ANALYTE_METHOD_JN_STG 
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN

insert into    ANALYTE_METHOD_JN_STG_JN (

JN_OPERATION,                  
JN_ORACLE_USER,                
JN_DATETIME,                                      
ANALYTE_METHOD_ID,             
METHOD_ID,                     
ANALYTE_ID,                    
DL_VALUE,                      
DL_UNITS,                      
ACCURACY,                      
ACCURACY_UNITS,                
FALSE_POSITIVE_VALUE,          
FALSE_NEGATIVE_VALUE,          
PRECISION,                     
PRECISION_UNITS,               
PREC_ACC_CONC_USED,            
INSERT_DATE,                   
INSERT_PERSON_NAME,            
LAST_UPDATE_DATE,              
LAST_UPDATE_PERSON_NAME,       
GREEN_FLAG,                    
YELLOW_FLAG,                   
CONFIRMATORY,                  
DATE_LOADED)
values ( 
'UPD',                   
'NEMI_DATA',                 
SYSDATE,         
:OLD.ANALYTE_METHOD_ID,             
:OLD.METHOD_ID,                     
:OLD.ANALYTE_ID,                    
:OLD.DL_VALUE,                      
:OLD.DL_UNITS,                      
:OLD.ACCURACY,                      
:OLD.ACCURACY_UNITS,                
:OLD.FALSE_POSITIVE_VALUE,          
:OLD.FALSE_NEGATIVE_VALUE,          
:OLD.PRECISION,                     
:OLD.PRECISION_UNITS,               
:OLD.PREC_ACC_CONC_USED,            
:OLD.INSERT_DATE,                   
:OLD.INSERT_PERSON_NAME,            
:OLD.LAST_UPDATE_DATE,              
:OLD.LAST_UPDATE_PERSON_NAME,       
:OLD.GREEN_FLAG,                    
:OLD.YELLOW_FLAG,                   
:OLD.CONFIRMATORY,                  
:OLD.DATE_LOADED)   ;
 
END;

--changeset kmschoep:TR_D_JN_METHOD_ONLINE3 splitStatements:false
 
 CREATE OR REPLACE TRIGGER TR_D_JN_METHOD_ONLINE
BEFORE DELETE
ON NEMI_DATA.METHOD_ONLINE 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
  INSERT INTO METHOD_ONLINE_JN (
JN_OPERATION,                   
JN_ORACLE_USER,                 
JN_DATETIME,                                        
METHOD_ID,                      
METHOD_SUBCATEGORY_ID,          
METHOD_SOURCE_ID,               
SOURCE_CITATION_ID,             
SOURCE_METHOD_IDENTIFIER,       
METHOD_DESCRIPTIVE_NAME,        
METHOD_OFFICIAL_NAME,           
MEDIA_NAME,                     
BRIEF_METHOD_SUMMARY,           
SCOPE_AND_APPLICATION,          
DL_TYPE_ID,                     
DL_NOTE,                        
APPLICABLE_CONC_RANGE,          
CONC_RANGE_UNITS,               
INTERFERENCES,                  
QC_REQUIREMENTS,                
SAMPLE_HANDLING,                
MAX_HOLDING_TIME,               
SAMPLE_PREP_METHODS,            
RELATIVE_COST_ID,               
LINK_TO_FULL_METHOD,            
INSERT_DATE,                    
INSERT_PERSON_NAME,             
LAST_UPDATE_DATE,               
LAST_UPDATE_PERSON_NAME,                       
INSTRUMENTATION_ID,             
PRECISION_DESCRIPTOR_NOTES,     
RAPIDITY,                       
WATERBODY_TYPE,                 
MATRIX,                         
TECHNIQUE,                                       
SCREENING,                      
COMMENTS,                       
INSERT_PERSON_NAME2,            
REVIEWER_NAME,                             
REGS_ONLY,                      
METHOD_TYPE_ID,                 
READY_FOR_REVIEW,               
LEVEL_OF_TRAINING,              
MEDIA_SUBCATEGORY,              
MEDIA_EMPHASIZED_NOTE,          
SAM_COMPLEXITY,                 
CBR_ONLY,                       
ETV_LINK,                       
COLLECTED_SAMPLE_AMT_ML,        
COLLECTED_SAMPLE_AMT_G,         
LIQUID_SAMPLE_FLAG,             
ANALYSIS_AMT_ML,                
ANALYSIS_AMT_G,                 
PH_OF_ANALYTICAL_SAMPLE,        
CALC_WASTE_AMT,                 
QUALITY_REVIEW_ID,              
PBT,                            
TOXIC,                          
CORROSIVE,                      
WASTE,                          
ASSUMPTIONS_COMMENTS,           
NOTES)
VALUES
(
'DEL',                   
'NEMI_DATA',                 
sysdate,                                         
:OLD.METHOD_ID,                      
:OLD.METHOD_SUBCATEGORY_ID,          
:OLD.METHOD_SOURCE_ID,               
:OLD.SOURCE_CITATION_ID,             
:OLD.SOURCE_METHOD_IDENTIFIER,       
:OLD.METHOD_DESCRIPTIVE_NAME,        
:OLD.METHOD_OFFICIAL_NAME,           
:OLD.MEDIA_NAME,                     
:OLD.BRIEF_METHOD_SUMMARY,           
:OLD.SCOPE_AND_APPLICATION,          
:OLD.DL_TYPE_ID,                     
:OLD.DL_NOTE,                        
:OLD.APPLICABLE_CONC_RANGE,          
:OLD.CONC_RANGE_UNITS,               
:OLD.INTERFERENCES,                  
:OLD.QC_REQUIREMENTS,                
:OLD.SAMPLE_HANDLING,                
:OLD.MAX_HOLDING_TIME,               
:OLD.SAMPLE_PREP_METHODS,            
:OLD.RELATIVE_COST_ID,               
:OLD.LINK_TO_FULL_METHOD,            
:OLD.INSERT_DATE,                    
:OLD.INSERT_PERSON_NAME,             
:OLD.LAST_UPDATE_DATE,               
:OLD.LAST_UPDATE_PERSON_NAME,                        
:OLD.INSTRUMENTATION_ID,             
:OLD.PRECISION_DESCRIPTOR_NOTES,     
:OLD.RAPIDITY,                       
:OLD.WATERBODY_TYPE,                 
:OLD.MATRIX,                         
:OLD.TECHNIQUE,                                     
:OLD.SCREENING,                      
:OLD.COMMENTS,                       
:OLD.INSERT_PERSON_NAME2,            
:OLD.REVIEWER_NAME,                           
:OLD.REGS_ONLY,                      
:OLD.METHOD_TYPE_ID,                 
:OLD.READY_FOR_REVIEW,               
:OLD.LEVEL_OF_TRAINING,              
:OLD.MEDIA_SUBCATEGORY,              
:OLD.MEDIA_EMPHASIZED_NOTE,          
:OLD.SAM_COMPLEXITY,                 
:OLD.CBR_ONLY,                       
:OLD.ETV_LINK,                       
:OLD.COLLECTED_SAMPLE_AMT_ML,        
:OLD.COLLECTED_SAMPLE_AMT_G,         
:OLD.LIQUID_SAMPLE_FLAG,             
:OLD.ANALYSIS_AMT_ML,                
:OLD.ANALYSIS_AMT_G,                 
:OLD.PH_OF_ANALYTICAL_SAMPLE,        
:OLD.CALC_WASTE_AMT,                 
:OLD.QUALITY_REVIEW_ID,              
:OLD.PBT,                            
:OLD.TOXIC,                          
:OLD.CORROSIVE,                      
:OLD.WASTE,                          
:OLD.ASSUMPTIONS_COMMENTS,           
:OLD.NOTES);  
   
END;

--changeset kmschoep:TR_U_APPROVED_ONLINE3 splitStatements:false

CREATE OR REPLACE TRIGGER TR_U_APPROVED_ONLINE
AFTER UPDATE
OF APPROVED
ON METHOD_ONLINE 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
declare
v_category varchar2(100);

BEGIN
select distinct method_category into v_category from METHOD_SUBCATEGORY_REF
where method_subcategory_id =  :new.method_subcategory_id;

if v_category != 'STATISTICAL' THEN
if nvl(:old.ready_for_review,'N') = 'N' and :new.ready_for_review = 'Y' then
INSERT into method_stg (
METHOD_ID,                     
METHOD_SUBCATEGORY_ID,         
METHOD_SOURCE_ID,              
SOURCE_CITATION_ID,            
SOURCE_METHOD_IDENTIFIER,      
METHOD_DESCRIPTIVE_NAME,       
METHOD_OFFICIAL_NAME,          
MEDIA_NAME,                    
BRIEF_METHOD_SUMMARY,          
SCOPE_AND_APPLICATION,         
DL_TYPE_ID,                    
DL_NOTE,                       
APPLICABLE_CONC_RANGE,         
CONC_RANGE_UNITS,              
INTERFERENCES,                 
QC_REQUIREMENTS,               
SAMPLE_HANDLING,               
MAX_HOLDING_TIME,              
SAMPLE_PREP_METHODS,           
RELATIVE_COST_ID,              
LINK_TO_FULL_METHOD,           
INSERT_DATE,                   
INSERT_PERSON_NAME,            
LAST_UPDATE_DATE,              
LAST_UPDATE_PERSON_NAME,       
approved,
approved_date,
INSTRUMENTATION_ID,            
PRECISION_DESCRIPTOR_NOTES,    
RAPIDITY,                      
CBR_ONLY,                      
WATERBODY_TYPE,                
MATRIX,                        
TECHNIQUE,                     
SCREENING,                     
ETV_LINK,                      
DATE_LOADED,                   
REVIEWER_NAME,                 
REGS_ONLY,                     
METHOD_TYPE_ID,                
ANALYSIS_AMT_ML,               
CORROSIVE,                     
COLLECTED_SAMPLE_AMT_G,        
PBT,                           
TOXIC,                         
COLLECTED_SAMPLE_AMT_ML,                  
COMMENTS,                      
PH_OF_ANALYTICAL_SAMPLE,       
QUALITY_REVIEW_ID,             
LIQUID_SAMPLE_FLAG,            
ANALYSIS_AMT_G,                
WASTE,                         
ASSUMPTIONS_COMMENTS,          
CALC_WASTE_AMT,                
READY_FOR_REVIEW,              
NOTES,                         
MEDIA_SUBCATEGORY,             
LEVEL_OF_TRAINING,             
MEDIA_EMPHASIZED_NOTE,         
SAM_COMPLEXITY)
  VALUES (
:new.METHOD_ID,                     
:new.METHOD_SUBCATEGORY_ID,         
:new.METHOD_SOURCE_ID,              
:new.SOURCE_CITATION_ID,            
:new.SOURCE_METHOD_IDENTIFIER,      
:new.METHOD_DESCRIPTIVE_NAME,       
:new.METHOD_OFFICIAL_NAME,          
:new.MEDIA_NAME,                    
:new.BRIEF_METHOD_SUMMARY,          
:new.SCOPE_AND_APPLICATION,         
:new.DL_TYPE_ID,                    
:new.DL_NOTE,                       
:new.APPLICABLE_CONC_RANGE,         
:new.CONC_RANGE_UNITS,              
:new.INTERFERENCES,                 
:new.QC_REQUIREMENTS,               
:new.SAMPLE_HANDLING,               
:new.MAX_HOLDING_TIME,              
:new.SAMPLE_PREP_METHODS,           
:new.RELATIVE_COST_ID,              
:new.LINK_TO_FULL_METHOD,           
:new.INSERT_DATE,                   
:new.INSERT_PERSON_NAME,            
:new.LAST_UPDATE_DATE,              
:new.LAST_UPDATE_PERSON_NAME,       
'N',                      
sysdate,                 
:new.INSTRUMENTATION_ID,            
:new.PRECISION_DESCRIPTOR_NOTES,    
:new.RAPIDITY,                      
:new.CBR_ONLY,                      
:new.WATERBODY_TYPE,                
:new.MATRIX,                        
:new.TECHNIQUE,                     
:new.SCREENING,                     
:new.ETV_LINK,                      
sysdate,                   
:new.REVIEWER_NAME,                 
:new.REGS_ONLY,                     
:new.METHOD_TYPE_ID,                
:new.ANALYSIS_AMT_ML,               
:new.CORROSIVE,                     
:new.COLLECTED_SAMPLE_AMT_G,        
:new.PBT,                           
:new.TOXIC,                         
:new.COLLECTED_SAMPLE_AMT_ML,                    
:new.COMMENTS,                      
:new.PH_OF_ANALYTICAL_SAMPLE,       
:new.QUALITY_REVIEW_ID,             
:new.LIQUID_SAMPLE_FLAG,            
:new.ANALYSIS_AMT_G,                
:new.WASTE,                         
:new.ASSUMPTIONS_COMMENTS,          
:new.CALC_WASTE_AMT,                
:new.READY_FOR_REVIEW,              
:new.NOTES,                         
:new.MEDIA_SUBCATEGORY,             
:new.LEVEL_OF_TRAINING,             
:new.MEDIA_EMPHASIZED_NOTE,         
:new.SAM_COMPLEXITY
  );           
merge_stg_to_prod.MergeOnlineAnalytes(:new.method_id);
merge_stg_to_prod.MergeOnlineRevisions(:new.method_id);
--delete from analyte_method_jn_online where method_id = :new.method_id;
--delete from revision_join_online where method_id = :new.method_id;
--delete from method_online where method_id = :new.method_id;
end if;
end if;

exception when others then
raise;
END;

--changeset kmschoep:TR_U_JN_METHOD_ONLINE3 splitStatements:false

CREATE OR REPLACE TRIGGER TR_U_JN_METHOD_ONLINE
BEFORE UPDATE
ON NEMI_DATA.METHOD_ONLINE 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
  INSERT INTO METHOD_ONLINE_JN (
JN_OPERATION,                   
JN_ORACLE_USER,                 
JN_DATETIME,                                        
METHOD_ID,                      
METHOD_SUBCATEGORY_ID,          
METHOD_SOURCE_ID,               
SOURCE_CITATION_ID,             
SOURCE_METHOD_IDENTIFIER,       
METHOD_DESCRIPTIVE_NAME,        
METHOD_OFFICIAL_NAME,           
MEDIA_NAME,                     
BRIEF_METHOD_SUMMARY,           
SCOPE_AND_APPLICATION,          
DL_TYPE_ID,                     
DL_NOTE,                        
APPLICABLE_CONC_RANGE,          
CONC_RANGE_UNITS,               
INTERFERENCES,                  
QC_REQUIREMENTS,                
SAMPLE_HANDLING,                
MAX_HOLDING_TIME,               
SAMPLE_PREP_METHODS,            
RELATIVE_COST_ID,               
LINK_TO_FULL_METHOD,            
INSERT_DATE,                    
INSERT_PERSON_NAME,             
LAST_UPDATE_DATE,               
LAST_UPDATE_PERSON_NAME,                       
INSTRUMENTATION_ID,             
PRECISION_DESCRIPTOR_NOTES,     
RAPIDITY,                       
WATERBODY_TYPE,                 
MATRIX,                         
TECHNIQUE,                                       
SCREENING,                      
COMMENTS,                       
INSERT_PERSON_NAME2,            
REVIEWER_NAME,                            
REGS_ONLY,                      
METHOD_TYPE_ID,                 
READY_FOR_REVIEW,               
LEVEL_OF_TRAINING,              
MEDIA_SUBCATEGORY,              
MEDIA_EMPHASIZED_NOTE,          
SAM_COMPLEXITY,                 
CBR_ONLY,                       
ETV_LINK,                       
COLLECTED_SAMPLE_AMT_ML,        
COLLECTED_SAMPLE_AMT_G,         
LIQUID_SAMPLE_FLAG,             
ANALYSIS_AMT_ML,                
ANALYSIS_AMT_G,                 
PH_OF_ANALYTICAL_SAMPLE,        
CALC_WASTE_AMT,                 
QUALITY_REVIEW_ID,              
PBT,                            
TOXIC,                          
CORROSIVE,                      
WASTE,                          
ASSUMPTIONS_COMMENTS,           
NOTES,
NO_ANALYTE_FLAG)
VALUES
(
'UPD',                   
'NEMI_DATA',                 
sysdate,                                         
:OLD.METHOD_ID,                      
:OLD.METHOD_SUBCATEGORY_ID,          
:OLD.METHOD_SOURCE_ID,               
:OLD.SOURCE_CITATION_ID,             
:OLD.SOURCE_METHOD_IDENTIFIER,       
:OLD.METHOD_DESCRIPTIVE_NAME,        
:OLD.METHOD_OFFICIAL_NAME,           
:OLD.MEDIA_NAME,                     
:OLD.BRIEF_METHOD_SUMMARY,           
:OLD.SCOPE_AND_APPLICATION,          
:OLD.DL_TYPE_ID,                     
:OLD.DL_NOTE,                        
:OLD.APPLICABLE_CONC_RANGE,          
:OLD.CONC_RANGE_UNITS,               
:OLD.INTERFERENCES,                  
:OLD.QC_REQUIREMENTS,                
:OLD.SAMPLE_HANDLING,                
:OLD.MAX_HOLDING_TIME,               
:OLD.SAMPLE_PREP_METHODS,            
:OLD.RELATIVE_COST_ID,               
:OLD.LINK_TO_FULL_METHOD,            
:OLD.INSERT_DATE,                    
:OLD.INSERT_PERSON_NAME,             
:OLD.LAST_UPDATE_DATE,               
:OLD.LAST_UPDATE_PERSON_NAME,                         
:OLD.INSTRUMENTATION_ID,             
:OLD.PRECISION_DESCRIPTOR_NOTES,     
:OLD.RAPIDITY,                       
:OLD.WATERBODY_TYPE,                 
:OLD.MATRIX,                         
:OLD.TECHNIQUE,                                     
:OLD.SCREENING,                      
:OLD.COMMENTS,                       
:OLD.INSERT_PERSON_NAME2,            
:OLD.REVIEWER_NAME,                              
:OLD.REGS_ONLY,                      
:OLD.METHOD_TYPE_ID,                 
:OLD.READY_FOR_REVIEW,               
:OLD.LEVEL_OF_TRAINING,              
:OLD.MEDIA_SUBCATEGORY,              
:OLD.MEDIA_EMPHASIZED_NOTE,          
:OLD.SAM_COMPLEXITY,                 
:OLD.CBR_ONLY,                       
:OLD.ETV_LINK,                       
:OLD.COLLECTED_SAMPLE_AMT_ML,        
:OLD.COLLECTED_SAMPLE_AMT_G,         
:OLD.LIQUID_SAMPLE_FLAG,             
:OLD.ANALYSIS_AMT_ML,                
:OLD.ANALYSIS_AMT_G,                 
:OLD.PH_OF_ANALYTICAL_SAMPLE,        
:OLD.CALC_WASTE_AMT,                 
:OLD.QUALITY_REVIEW_ID,              
:OLD.PBT,                            
:OLD.TOXIC,                          
:OLD.CORROSIVE,                      
:OLD.WASTE,                          
:OLD.ASSUMPTIONS_COMMENTS,           
:OLD.NOTES,
:OLD.NO_ANALYTE_FLAG);  
   
END;

--changeset kmschoep:MERGE_STG_TO_PROD splitStatements:false

CREATE OR REPLACE PACKAGE BODY NEMI_DATA.MERGE_STG_TO_PROD AS
/******************************************************************************
   NAME:       MergeMethods
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        3/31/2008             1. Created this package body.
******************************************************************************/
  PROCEDURE RefreshStgMethods(p_method_id in number) is
  begin
    MergeStgMethods(p_method_id);
    MergeStgAnalytes(p_method_id);
    MergeStgRevisions(p_method_id);
    end;
    
    PROCEDURE RefreshOnlineMethods(p_method_id in number) is
  begin
    MergeOnlineMethods(p_method_id);
    MergeOnlineAnalytes(p_method_id);
    MergeOnlineRevisions(p_method_id);
    end;

  PROCEDURE MergeStgMethods(p_method_id in number) IS
  BEGIN
    MERGE INTO method B
USING (
  SELECT *
  FROM method_stg where approved = 'Y' and method_id = p_method_id) E ON (B.method_id = E.method_id)
WHEN MATCHED THEN
  UPDATE SET                                        
b.METHOD_SUBCATEGORY_ID = e.METHOD_SUBCATEGORY_ID,                  
b.METHOD_SOURCE_ID = e.METHOD_SOURCE_ID,                            
b.SOURCE_CITATION_ID = e.SOURCE_CITATION_ID,                        
b.SOURCE_METHOD_IDENTIFIER = e.SOURCE_METHOD_IDENTIFIER,            
b.METHOD_DESCRIPTIVE_NAME = e.METHOD_DESCRIPTIVE_NAME,              
b.METHOD_OFFICIAL_NAME = e.METHOD_OFFICIAL_NAME,                    
b.MEDIA_NAME = e.MEDIA_NAME,                                        
b.BRIEF_METHOD_SUMMARY = e.BRIEF_METHOD_SUMMARY,                    
b.SCOPE_AND_APPLICATION = e.SCOPE_AND_APPLICATION,                  
b.DL_TYPE_ID = e.DL_TYPE_ID,                                        
b.DL_NOTE = e.DL_NOTE,                                              
b.APPLICABLE_CONC_RANGE = e.APPLICABLE_CONC_RANGE,                  
b.CONC_RANGE_UNITS = e.CONC_RANGE_UNITS,                            
b.INTERFERENCES = e.INTERFERENCES,                                  
b.QC_REQUIREMENTS = e.QC_REQUIREMENTS,                              
b.SAMPLE_HANDLING = e.SAMPLE_HANDLING,                              
b.MAX_HOLDING_TIME = e.MAX_HOLDING_TIME,                            
b.SAMPLE_PREP_METHODS = e.SAMPLE_PREP_METHODS,                      
b.RELATIVE_COST_ID = e.RELATIVE_COST_ID,                            
b.LINK_TO_FULL_METHOD = e.LINK_TO_FULL_METHOD,                      
b.INSERT_DATE = e.INSERT_DATE,                                      
b.INSERT_PERSON_NAME = e.INSERT_PERSON_NAME,                        
b.LAST_UPDATE_DATE = e.LAST_UPDATE_DATE,                            
b.LAST_UPDATE_PERSON_NAME = e.LAST_UPDATE_PERSON_NAME,              
b.APPROVED = e.APPROVED,                                            
b.APPROVED_DATE = e.APPROVED_DATE,                                  
b.INSTRUMENTATION_ID = e.INSTRUMENTATION_ID,                        
b.PRECISION_DESCRIPTOR_NOTES = e.PRECISION_DESCRIPTOR_NOTES,        
b.RAPIDITY = e.RAPIDITY,                                            
b.CBR_ONLY = e.CBR_ONLY,                                            
b.WATERBODY_TYPE = e.WATERBODY_TYPE,                                
b.MATRIX = e.MATRIX,                                                
b.TECHNIQUE = e.TECHNIQUE,                                          
b.SCREENING = e.SCREENING,                                          
b.ETV_LINK = e.ETV_LINK,                                            
b.DATE_LOADED = sysdate,                                      
b.REVIEWER_NAME = e.REVIEWER_NAME,                                  
b.REGS_ONLY = e.REGS_ONLY,                                          
b.METHOD_TYPE_ID = e.METHOD_TYPE_ID,                                
b.ANALYSIS_AMT_ML = e.ANALYSIS_AMT_ML,                              
b.CORROSIVE = e.CORROSIVE,                                          
b.COLLECTED_SAMPLE_AMT_G = e.COLLECTED_SAMPLE_AMT_G,                
b.PBT = e.PBT,                                                      
b.TOXIC = e.TOXIC,                                                  
b.COLLECTED_SAMPLE_AMT_ML = e.COLLECTED_SAMPLE_AMT_ML,              
b.PH_OF_ANALYTICAL_SAMPLE = e.PH_OF_ANALYTICAL_SAMPLE,              
b.QUALITY_REVIEW_ID = e.QUALITY_REVIEW_ID,                          
b.LIQUID_SAMPLE_FLAG = e.LIQUID_SAMPLE_FLAG,                        
b.ANALYSIS_AMT_G = e.ANALYSIS_AMT_G,                                
b.WASTE = e.WASTE,                                                  
b.ASSUMPTIONS_COMMENTS = e.ASSUMPTIONS_COMMENTS,                    
b.CALC_WASTE_AMT = e.CALC_WASTE_AMT,                                                                                                    
b.NOTES = e.NOTES,                                                  
b.MEDIA_SUBCATEGORY = e.MEDIA_SUBCATEGORY,                          
b.LEVEL_OF_TRAINING = e.LEVEL_OF_TRAINING,                          
b.MEDIA_EMPHASIZED_NOTE = e.MEDIA_EMPHASIZED_NOTE,                  
b.SAM_COMPLEXITY = e.SAM_COMPLEXITY 
WHEN NOT MATCHED THEN
  INSERT (
b.METHOD_ID,                     
b.METHOD_SUBCATEGORY_ID,         
b.METHOD_SOURCE_ID,              
b.SOURCE_CITATION_ID,            
b.SOURCE_METHOD_IDENTIFIER,      
b.METHOD_DESCRIPTIVE_NAME,       
b.METHOD_OFFICIAL_NAME,          
b.MEDIA_NAME,                    
b.BRIEF_METHOD_SUMMARY,          
b.SCOPE_AND_APPLICATION,         
b.DL_TYPE_ID,                    
b.DL_NOTE,                       
b.APPLICABLE_CONC_RANGE,         
b.CONC_RANGE_UNITS,              
b.INTERFERENCES,                 
b.QC_REQUIREMENTS,               
b.SAMPLE_HANDLING,               
b.MAX_HOLDING_TIME,              
b.SAMPLE_PREP_METHODS,           
b.RELATIVE_COST_ID,              
b.LINK_TO_FULL_METHOD,           
b.INSERT_DATE,                   
b.INSERT_PERSON_NAME,            
b.LAST_UPDATE_DATE,              
b.LAST_UPDATE_PERSON_NAME,       
b.APPROVED,                      
b.APPROVED_DATE,                 
b.INSTRUMENTATION_ID,            
b.PRECISION_DESCRIPTOR_NOTES,    
b.RAPIDITY,                      
b.CBR_ONLY,                      
b.WATERBODY_TYPE,                
b.MATRIX,                        
b.TECHNIQUE,                     
b.SCREENING,                     
b.ETV_LINK,                      
b.DATE_LOADED,                   
b.REVIEWER_NAME,                 
b.REGS_ONLY,                     
b.METHOD_TYPE_ID,                
b.ANALYSIS_AMT_ML,               
b.CORROSIVE,                     
b.COLLECTED_SAMPLE_AMT_G,        
b.PBT,                           
b.TOXIC,                         
b.COLLECTED_SAMPLE_AMT_ML,       
b.PH_OF_ANALYTICAL_SAMPLE,       
b.QUALITY_REVIEW_ID,             
b.LIQUID_SAMPLE_FLAG,            
b.ANALYSIS_AMT_G,                
b.WASTE,                         
b.ASSUMPTIONS_COMMENTS,          
b.CALC_WASTE_AMT,                                                
b.NOTES,                         
b.MEDIA_SUBCATEGORY,             
b.LEVEL_OF_TRAINING,             
b.MEDIA_EMPHASIZED_NOTE,         
b.SAM_COMPLEXITY)
  VALUES (
e.METHOD_ID,                     
e.METHOD_SUBCATEGORY_ID,         
e.METHOD_SOURCE_ID,              
e.SOURCE_CITATION_ID,            
e.SOURCE_METHOD_IDENTIFIER,      
e.METHOD_DESCRIPTIVE_NAME,       
e.METHOD_OFFICIAL_NAME,          
e.MEDIA_NAME,                    
e.BRIEF_METHOD_SUMMARY,          
e.SCOPE_AND_APPLICATION,         
e.DL_TYPE_ID,                    
e.DL_NOTE,                       
e.APPLICABLE_CONC_RANGE,         
e.CONC_RANGE_UNITS,              
e.INTERFERENCES,                 
e.QC_REQUIREMENTS,               
e.SAMPLE_HANDLING,               
e.MAX_HOLDING_TIME,              
e.SAMPLE_PREP_METHODS,           
e.RELATIVE_COST_ID,              
e.LINK_TO_FULL_METHOD,           
e.INSERT_DATE,                   
e.INSERT_PERSON_NAME,            
e.LAST_UPDATE_DATE,              
e.LAST_UPDATE_PERSON_NAME,       
e.APPROVED,                      
e.APPROVED_DATE,                 
e.INSTRUMENTATION_ID,            
e.PRECISION_DESCRIPTOR_NOTES,    
e.RAPIDITY,                      
e.CBR_ONLY,                      
e.WATERBODY_TYPE,                
e.MATRIX,                        
e.TECHNIQUE,                     
e.SCREENING,                     
e.ETV_LINK,                      
sysdate,                   
e.REVIEWER_NAME,                 
e.REGS_ONLY,                     
e.METHOD_TYPE_ID,                
e.ANALYSIS_AMT_ML,               
e.CORROSIVE,                     
e.COLLECTED_SAMPLE_AMT_G,        
e.PBT,                           
e.TOXIC,                         
e.COLLECTED_SAMPLE_AMT_ML,       
e.PH_OF_ANALYTICAL_SAMPLE,       
e.QUALITY_REVIEW_ID,             
e.LIQUID_SAMPLE_FLAG,            
e.ANALYSIS_AMT_G,                
e.WASTE,                         
e.ASSUMPTIONS_COMMENTS,          
e.CALC_WASTE_AMT,                                               
e.NOTES,                         
e.MEDIA_SUBCATEGORY,             
e.LEVEL_OF_TRAINING,             
e.MEDIA_EMPHASIZED_NOTE,         
e.SAM_COMPLEXITY
  );
  END;
  
procedure MergeOnlineMethods(p_method_id in number) is
begin
MERGE INTO method_stg B
USING (
  SELECT *
  FROM method_online where approved = 'Y' and method_id = p_method_id) E ON (B.method_id = E.method_id)
WHEN MATCHED THEN
  UPDATE SET                                                                                 
b.METHOD_SUBCATEGORY_ID = e.METHOD_SUBCATEGORY_ID,                  
b.METHOD_SOURCE_ID = e.METHOD_SOURCE_ID,                            
b.SOURCE_CITATION_ID = e.SOURCE_CITATION_ID,                        
b.SOURCE_METHOD_IDENTIFIER = e.SOURCE_METHOD_IDENTIFIER,            
b.METHOD_DESCRIPTIVE_NAME = e.METHOD_DESCRIPTIVE_NAME,              
b.METHOD_OFFICIAL_NAME = e.METHOD_OFFICIAL_NAME,                    
b.MEDIA_NAME = e.MEDIA_NAME,                                        
b.BRIEF_METHOD_SUMMARY = e.BRIEF_METHOD_SUMMARY,                    
b.SCOPE_AND_APPLICATION = e.SCOPE_AND_APPLICATION,                  
b.DL_TYPE_ID = e.DL_TYPE_ID,                                        
b.DL_NOTE = e.DL_NOTE,                                              
b.APPLICABLE_CONC_RANGE = e.APPLICABLE_CONC_RANGE,                  
b.CONC_RANGE_UNITS = e.CONC_RANGE_UNITS,                            
b.INTERFERENCES = e.INTERFERENCES,                                  
b.QC_REQUIREMENTS = e.QC_REQUIREMENTS,                              
b.SAMPLE_HANDLING = e.SAMPLE_HANDLING,                              
b.MAX_HOLDING_TIME = e.MAX_HOLDING_TIME,                            
b.SAMPLE_PREP_METHODS = e.SAMPLE_PREP_METHODS,                      
b.RELATIVE_COST_ID = e.RELATIVE_COST_ID,                            
b.LINK_TO_FULL_METHOD = e.LINK_TO_FULL_METHOD,                      
b.INSERT_DATE = e.INSERT_DATE,                                      
b.INSERT_PERSON_NAME = e.INSERT_PERSON_NAME,                        
b.LAST_UPDATE_DATE = e.LAST_UPDATE_DATE,                            
b.LAST_UPDATE_PERSON_NAME = e.LAST_UPDATE_PERSON_NAME,              
b.APPROVED = 'N',                                            
b.APPROVED_DATE = e.APPROVED_DATE,                                  
b.INSTRUMENTATION_ID = e.INSTRUMENTATION_ID,                        
b.PRECISION_DESCRIPTOR_NOTES = e.PRECISION_DESCRIPTOR_NOTES,        
b.RAPIDITY = e.RAPIDITY,                                            
b.CBR_ONLY = e.CBR_ONLY,                                            
b.WATERBODY_TYPE = e.WATERBODY_TYPE,                                
b.MATRIX = e.MATRIX,                                                
b.TECHNIQUE = e.TECHNIQUE,                                          
b.SCREENING = e.SCREENING,                                          
b.ETV_LINK = e.ETV_LINK,                                            
b.DATE_LOADED = sysdate,                                      
b.REVIEWER_NAME = e.REVIEWER_NAME,                                  
b.REGS_ONLY = e.REGS_ONLY,                                          
b.METHOD_TYPE_ID = e.METHOD_TYPE_ID,                                
b.ANALYSIS_AMT_ML = e.ANALYSIS_AMT_ML,                              
b.CORROSIVE = e.CORROSIVE,                                          
b.COLLECTED_SAMPLE_AMT_G = e.COLLECTED_SAMPLE_AMT_G,                
b.PBT = e.PBT,                                                      
b.TOXIC = e.TOXIC,                                                  
b.COLLECTED_SAMPLE_AMT_ML = e.COLLECTED_SAMPLE_AMT_ML,              
b.NO_ANALYTE_FLAG = e.NO_ANALYTE_FLAG,                            
b.COMMENTS = e.COMMENTS,                                            
b.PH_OF_ANALYTICAL_SAMPLE = e.PH_OF_ANALYTICAL_SAMPLE,              
b.QUALITY_REVIEW_ID = e.QUALITY_REVIEW_ID,                          
b.LIQUID_SAMPLE_FLAG = e.LIQUID_SAMPLE_FLAG,                        
b.ANALYSIS_AMT_G = e.ANALYSIS_AMT_G,                                
b.WASTE = e.WASTE,                                                  
b.ASSUMPTIONS_COMMENTS = e.ASSUMPTIONS_COMMENTS,                    
b.CALC_WASTE_AMT = e.CALC_WASTE_AMT,                                
b.READY_FOR_REVIEW = e.READY_FOR_REVIEW,                            
b.NOTES = e.NOTES,                                                  
b.MEDIA_SUBCATEGORY = e.MEDIA_SUBCATEGORY,                          
b.LEVEL_OF_TRAINING = e.LEVEL_OF_TRAINING,                          
b.MEDIA_EMPHASIZED_NOTE = e.MEDIA_EMPHASIZED_NOTE,                  
b.SAM_COMPLEXITY = e.SAM_COMPLEXITY 
WHEN NOT MATCHED THEN
  INSERT (
b.METHOD_ID,                     
b.METHOD_SUBCATEGORY_ID,         
b.METHOD_SOURCE_ID,              
b.SOURCE_CITATION_ID,            
b.SOURCE_METHOD_IDENTIFIER,      
b.METHOD_DESCRIPTIVE_NAME,       
b.METHOD_OFFICIAL_NAME,          
b.MEDIA_NAME,                    
b.BRIEF_METHOD_SUMMARY,          
b.SCOPE_AND_APPLICATION,         
b.DL_TYPE_ID,                    
b.DL_NOTE,                       
b.APPLICABLE_CONC_RANGE,         
b.CONC_RANGE_UNITS,              
b.INTERFERENCES,                 
b.QC_REQUIREMENTS,               
b.SAMPLE_HANDLING,               
b.MAX_HOLDING_TIME,              
b.SAMPLE_PREP_METHODS,           
b.RELATIVE_COST_ID,              
b.LINK_TO_FULL_METHOD,           
b.INSERT_DATE,                   
b.INSERT_PERSON_NAME,            
b.LAST_UPDATE_DATE,              
b.LAST_UPDATE_PERSON_NAME,       
b.APPROVED,                      
b.APPROVED_DATE,                 
b.INSTRUMENTATION_ID,            
b.PRECISION_DESCRIPTOR_NOTES,    
b.RAPIDITY,                      
b.CBR_ONLY,                      
b.WATERBODY_TYPE,                
b.MATRIX,                        
b.TECHNIQUE,                     
b.SCREENING,                     
b.ETV_LINK,                      
b.DATE_LOADED,                   
b.REVIEWER_NAME,                 
b.REGS_ONLY,                     
b.METHOD_TYPE_ID,                
b.ANALYSIS_AMT_ML,               
b.CORROSIVE,                     
b.COLLECTED_SAMPLE_AMT_G,        
b.PBT,                           
b.TOXIC,                         
b.COLLECTED_SAMPLE_AMT_ML,       
b.NO_ANALYTE_FLAG,              
b.COMMENTS,                      
b.PH_OF_ANALYTICAL_SAMPLE,       
b.QUALITY_REVIEW_ID,             
b.LIQUID_SAMPLE_FLAG,            
b.ANALYSIS_AMT_G,                
b.WASTE,                         
b.ASSUMPTIONS_COMMENTS,          
b.CALC_WASTE_AMT,                
b.READY_FOR_REVIEW,              
b.NOTES,                         
b.MEDIA_SUBCATEGORY,             
b.LEVEL_OF_TRAINING,             
b.MEDIA_EMPHASIZED_NOTE,         
b.SAM_COMPLEXITY)
  VALUES (
e.METHOD_ID,                     
e.METHOD_SUBCATEGORY_ID,         
e.METHOD_SOURCE_ID,              
e.SOURCE_CITATION_ID,            
e.SOURCE_METHOD_IDENTIFIER,      
e.METHOD_DESCRIPTIVE_NAME,       
e.METHOD_OFFICIAL_NAME,          
e.MEDIA_NAME,                    
e.BRIEF_METHOD_SUMMARY,          
e.SCOPE_AND_APPLICATION,         
e.DL_TYPE_ID,                    
e.DL_NOTE,                       
e.APPLICABLE_CONC_RANGE,         
e.CONC_RANGE_UNITS,              
e.INTERFERENCES,                 
e.QC_REQUIREMENTS,               
e.SAMPLE_HANDLING,               
e.MAX_HOLDING_TIME,              
e.SAMPLE_PREP_METHODS,           
e.RELATIVE_COST_ID,              
e.LINK_TO_FULL_METHOD,           
e.INSERT_DATE,                   
e.INSERT_PERSON_NAME,            
e.LAST_UPDATE_DATE,              
e.LAST_UPDATE_PERSON_NAME,       
'N',                      
sysdate,                 
e.INSTRUMENTATION_ID,            
e.PRECISION_DESCRIPTOR_NOTES,    
e.RAPIDITY,                      
e.CBR_ONLY,                      
e.WATERBODY_TYPE,                
e.MATRIX,                        
e.TECHNIQUE,                     
e.SCREENING,                     
e.ETV_LINK,                      
sysdate,                   
e.REVIEWER_NAME,                 
e.REGS_ONLY,                     
e.METHOD_TYPE_ID,                
e.ANALYSIS_AMT_ML,               
e.CORROSIVE,                     
e.COLLECTED_SAMPLE_AMT_G,        
e.PBT,                           
e.TOXIC,                         
e.COLLECTED_SAMPLE_AMT_ML,       
e.NO_ANALYTE_FLAG,              
e.COMMENTS,                      
e.PH_OF_ANALYTICAL_SAMPLE,       
e.QUALITY_REVIEW_ID,             
e.LIQUID_SAMPLE_FLAG,            
e.ANALYSIS_AMT_G,                
e.WASTE,                         
e.ASSUMPTIONS_COMMENTS,          
e.CALC_WASTE_AMT,                
e.READY_FOR_REVIEW,              
e.NOTES,                         
e.MEDIA_SUBCATEGORY,             
e.LEVEL_OF_TRAINING,             
e.MEDIA_EMPHASIZED_NOTE,         
e.SAM_COMPLEXITY
  );

  exception when others then
  raise;
end;

PROCEDURE MergeStgAnalytes(p_method_id in number) IS
  BEGIN
    MERGE INTO analyte_method_jn B
USING (
  SELECT *
 FROM analyte_method_jn_stg amj where amj.method_id = p_method_id ) E
ON (B.analyte_method_id = E.analyte_method_id)
WHEN MATCHED THEN
  UPDATE SET                         
b.METHOD_ID = e.METHOD_ID,                                          
b.ANALYTE_ID = e.ANALYTE_ID,                                        
b.DL_VALUE = e.DL_VALUE,                                            
b.DL_UNITS = e.DL_UNITS,                                            
b.ACCURACY = e.ACCURACY,                                            
b.ACCURACY_UNITS = e.ACCURACY_UNITS,                                
b.FALSE_POSITIVE_VALUE = e.FALSE_POSITIVE_VALUE,                    
b.FALSE_NEGATIVE_VALUE = e.FALSE_NEGATIVE_VALUE,                    
b.PRECISION = e.PRECISION,                                          
b.PRECISION_UNITS = e.PRECISION_UNITS,                              
b.PREC_ACC_CONC_USED = e.PREC_ACC_CONC_USED,                        
b.INSERT_DATE = e.INSERT_DATE,                                      
b.INSERT_PERSON_NAME = e.INSERT_PERSON_NAME,                        
b.LAST_UPDATE_DATE = e.LAST_UPDATE_DATE,                            
b.LAST_UPDATE_PERSON_NAME = e.LAST_UPDATE_PERSON_NAME,                                    
b.GREEN_FLAG = e.GREEN_FLAG,                                        
b.YELLOW_FLAG = e.YELLOW_FLAG,                                      
b.CONFIRMATORY = e.CONFIRMATORY,                                    
b.DATE_LOADED = SYSDATE 
WHEN NOT MATCHED THEN
  INSERT (
b.ANALYTE_METHOD_ID,             
b.METHOD_ID,                     
b.ANALYTE_ID,                    
b.DL_VALUE,                      
b.DL_UNITS,                      
b.ACCURACY,                      
b.ACCURACY_UNITS,                
b.FALSE_POSITIVE_VALUE,          
b.FALSE_NEGATIVE_VALUE,          
b.PRECISION,                     
b.PRECISION_UNITS,               
b.PREC_ACC_CONC_USED,            
b.INSERT_DATE,                   
b.INSERT_PERSON_NAME,            
b.LAST_UPDATE_DATE,              
b.LAST_UPDATE_PERSON_NAME,                 
b.GREEN_FLAG,                    
b.YELLOW_FLAG,                   
b.CONFIRMATORY,                  
b.DATE_LOADED)
values (
e.ANALYTE_METHOD_ID,             
e.METHOD_ID,                     
e.ANALYTE_ID,                    
e.DL_VALUE,                      
e.DL_UNITS,                      
e.ACCURACY,                      
e.ACCURACY_UNITS,                
e.FALSE_POSITIVE_VALUE,          
e.FALSE_NEGATIVE_VALUE,          
e.PRECISION,                     
e.PRECISION_UNITS,               
e.PREC_ACC_CONC_USED,            
e.INSERT_DATE,                   
e.INSERT_PERSON_NAME,            
e.LAST_UPDATE_DATE,              
e.LAST_UPDATE_PERSON_NAME,                 
e.GREEN_FLAG,                    
e.YELLOW_FLAG,                   
e.CONFIRMATORY,                  
sysdate );

end;

procedure MergeOnlineAnalytes(p_method_id in number) is
begin
MERGE INTO analyte_method_jn_stg B
USING (
  SELECT *
 FROM analyte_method_jn_online amj where  amj.method_id = p_method_id ) E
ON (B.analyte_method_id = E.analyte_method_id)
WHEN MATCHED THEN
  UPDATE SET                                                  
b.METHOD_ID = e.METHOD_ID,                                          
b.ANALYTE_ID = e.ANALYTE_ID,                                        
b.DL_VALUE = e.DL_VALUE,                                            
b.DL_UNITS = e.DL_UNITS,                                            
b.ACCURACY = e.ACCURACY,                                            
b.ACCURACY_UNITS = e.ACCURACY_UNITS,                                
b.FALSE_POSITIVE_VALUE = e.FALSE_POSITIVE_VALUE,                    
b.FALSE_NEGATIVE_VALUE = e.FALSE_NEGATIVE_VALUE,                    
b.PRECISION = e.PRECISION,                                          
b.PRECISION_UNITS = e.PRECISION_UNITS,                              
b.PREC_ACC_CONC_USED = e.PREC_ACC_CONC_USED,                        
b.INSERT_DATE = e.INSERT_DATE,                                      
b.INSERT_PERSON_NAME = e.INSERT_PERSON_NAME,                        
b.LAST_UPDATE_DATE = e.LAST_UPDATE_DATE,                            
b.LAST_UPDATE_PERSON_NAME = e.LAST_UPDATE_PERSON_NAME,              
b.GREEN_FLAG = e.GREEN_FLAG,                                        
b.YELLOW_FLAG = e.YELLOW_FLAG,                                      
b.CONFIRMATORY = e.CONFIRMATORY,                                    
b.DATE_LOADED = SYSDATE 
WHEN NOT MATCHED THEN
  INSERT (
b.ANALYTE_METHOD_ID,             
b.METHOD_ID,                     
b.ANALYTE_ID,                    
b.DL_VALUE,                      
b.DL_UNITS,                      
b.ACCURACY,                      
b.ACCURACY_UNITS,                
b.FALSE_POSITIVE_VALUE,          
b.FALSE_NEGATIVE_VALUE,          
b.PRECISION,                     
b.PRECISION_UNITS,               
b.PREC_ACC_CONC_USED,            
b.INSERT_DATE,                   
b.INSERT_PERSON_NAME,            
b.LAST_UPDATE_DATE,              
b.LAST_UPDATE_PERSON_NAME,       
b.GREEN_FLAG,                    
b.YELLOW_FLAG,                   
b.CONFIRMATORY,                  
b.DATE_LOADED)
values (
e.ANALYTE_METHOD_ID,             
e.METHOD_ID,                     
e.ANALYTE_ID,                    
e.DL_VALUE,                      
e.DL_UNITS,                      
e.ACCURACY,                      
e.ACCURACY_UNITS,                
e.FALSE_POSITIVE_VALUE,          
e.FALSE_NEGATIVE_VALUE,          
e.PRECISION,                     
e.PRECISION_UNITS,               
e.PREC_ACC_CONC_USED,            
e.INSERT_DATE,                   
e.INSERT_PERSON_NAME,            
e.LAST_UPDATE_DATE,              
e.LAST_UPDATE_PERSON_NAME,       
e.GREEN_FLAG,                    
e.YELLOW_FLAG,                   
e.CONFIRMATORY,                  
sysdate );

end;

PROCEDURE MergeStgRevisions(p_method_id in number) IS
  BEGIN
--    execute immediate 'DROP INDEX method_pdf_ctx_idx';
    MERGE INTO revision_join B
USING (
  SELECT *
  FROM revision_join_stg amj where amj.method_id = p_method_id) E
ON (B.revision_id = E.revision_id)
WHEN MATCHED THEN
  UPDATE SET                                     
b.METHOD_ID = e.METHOD_ID,                                          
b.REVISION_INFORMATION = e.REVISION_INFORMATION,                    
b.METHOD_PDF = e.METHOD_PDF,                                        
b.INSERT_DATE = e.INSERT_DATE,                                      
b.INSERT_PERSON_NAME = e.INSERT_PERSON_NAME,                        
b.LAST_UPDATE_DATE = e.LAST_UPDATE_DATE,                            
b.LAST_UPDATE_PERSON_NAME = e.LAST_UPDATE_PERSON_NAME,              
b.MIMETYPE = e.MIMETYPE,                                            
b.PDF_INSERT_PERSON = e.PDF_INSERT_PERSON,                          
b.PDF_INSERT_DATE = e.PDF_INSERT_DATE,                              
b.REVISION_FLAG = e.REVISION_FLAG,                                  
b.DATE_LOADED = sysdate
WHEN NOT MATCHED THEN
  INSERT (
  b.REVISION_ID,                   
b.METHOD_ID,                     
b.REVISION_INFORMATION,          
b.METHOD_PDF,                    
b.INSERT_DATE,                   
b.INSERT_PERSON_NAME,            
b.LAST_UPDATE_DATE,              
b.LAST_UPDATE_PERSON_NAME,       
b.MIMETYPE,                      
b.PDF_INSERT_PERSON,             
b.PDF_INSERT_DATE,               
b.REVISION_FLAG,                 
b.DATE_LOADED)
values (e.REVISION_ID,                   
e.METHOD_ID,                     
e.REVISION_INFORMATION,          
e.METHOD_PDF,                    
e.INSERT_DATE,                   
e.INSERT_PERSON_NAME,            
e.LAST_UPDATE_DATE,              
e.LAST_UPDATE_PERSON_NAME,       
e.MIMETYPE,                      
e.PDF_INSERT_PERSON,             
e.PDF_INSERT_DATE,               
e.REVISION_FLAG,                 
sysdate);

--execute immediate 'CREATE INDEX method_pdf_ctx_idx ON revision_join(method_pdf) INDEXTYPE IS ctxsys.context
 -- PARAMETERS(''DATASTORE multi_method_pdf LEXER mylex filter ctxsys.auto_filter WORDLIST STEM_FUZZY_PREF'')';
    end;

procedure MergeOnlineRevisions(p_method_id in number) is
begin
MERGE INTO revision_join_stg B
USING (
  SELECT *
  FROM revision_join_online amj where amj.method_id = p_method_id) E
ON (B.revision_id = E.revision_id)
WHEN MATCHED THEN
  UPDATE SET                                                                          
b.METHOD_ID = e.METHOD_ID,                                          
b.REVISION_INFORMATION = e.REVISION_INFORMATION,                    
b.METHOD_PDF = e.METHOD_PDF,                                        
b.INSERT_DATE = e.INSERT_DATE,                                      
b.INSERT_PERSON_NAME = e.INSERT_PERSON_NAME,                        
b.LAST_UPDATE_DATE = e.LAST_UPDATE_DATE,                            
b.LAST_UPDATE_PERSON_NAME = e.LAST_UPDATE_PERSON_NAME,              
b.MIMETYPE = e.MIMETYPE,                                            
b.PDF_INSERT_PERSON = e.PDF_INSERT_PERSON,                          
b.PDF_INSERT_DATE = e.PDF_INSERT_DATE,                              
b.REVISION_FLAG = e.REVISION_FLAG,                                  
b.DATE_LOADED = SYSDATE
WHEN NOT MATCHED THEN
  INSERT (
  b.REVISION_ID,                   
b.METHOD_ID,                     
b.REVISION_INFORMATION,          
b.METHOD_PDF,                    
b.INSERT_DATE,                   
b.INSERT_PERSON_NAME,            
b.LAST_UPDATE_DATE,              
b.LAST_UPDATE_PERSON_NAME,       
b.MIMETYPE,                      
b.PDF_INSERT_PERSON,             
b.PDF_INSERT_DATE,               
b.REVISION_FLAG,                 
b.DATE_LOADED)
values (e.REVISION_ID,                   
e.METHOD_ID,                     
e.REVISION_INFORMATION,          
e.METHOD_PDF,                    
e.INSERT_DATE,                   
e.INSERT_PERSON_NAME,            
e.LAST_UPDATE_DATE,              
e.LAST_UPDATE_PERSON_NAME,       
e.MIMETYPE,                      
e.PDF_INSERT_PERSON,             
e.PDF_INSERT_DATE,               
e.REVISION_FLAG,                 
sysdate);

end;

END MERGE_STG_TO_PROD;

-- changeset kmschoep:tr_u_method_online splitStatements:false
CREATE OR REPLACE TRIGGER tr_u_method_online
BEFORE UPDATE
ON METHOD_ONLINE
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
tmpVar NUMBER;
/******************************************************************************
   NAME:       tr_u_method_stg
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        5/20/2013      kmschoep       1. Created this trigger.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     tr_u_method_stg
      Sysdate:         5/20/2013
      Date and Time:   5/20/2013, 9:16:44 AM, and 5/20/2013 9:16:44 AM
      Username:        kmschoep (set in TOAD Options, Proc Templates)
      Table Name:      METHOD_STG (set in the "New PL/SQL Object" dialog)
      Trigger Options:  (set in the "New PL/SQL Object" dialog)
******************************************************************************/
BEGIN
   tmpVar := 0;


   :NEW.last_update_date := SYSDATE;
   :NEW.last_update_person_name := v('APP_USER');

   EXCEPTION
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END tr_u_method_online;

--changeset kmschoep:TR_I_ANALYTE_REF splitStatements:false

CREATE OR REPLACE TRIGGER TR_I_ANALYTE_REF
BEFORE INSERT OR UPDATE
ON ANALYTE_REF 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
tmpVar NUMBER;
/******************************************************************************
   NAME:       tr_i_analyte_ref
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/5/2006             1. Created this trigger.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     tr_i_analyte_ref
      Sysdate:         12/5/2006
      Date and Time:   12/5/2006, 3:04:37 PM, and 12/5/2006 3:04:37 PM
      Username:         (set in TOAD Options, Proc Templates)
      Table Name:      ANALYTE_REF (set in the "New PL/SQL Object" dialog)
      Trigger Options:  (set in the "New PL/SQL Object" dialog)
******************************************************************************/
BEGIN
   
IF INSERTING THEN 

   if :new.analyte_id is null then
   :new.analyte_id := analyte_ref_id_seq.NEXTVAL;
   end if;
   
   :new.data_entry_date := sysdate;
   :new.data_entry_name := lower(v('APP_USER'));
   
END IF;
   
IF UPDATING THEN 

   :new.update_date := sysdate;
   :new.update_name := lower(v('APP_USER'));
   
END IF;      
   
   
   EXCEPTION
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END tr_i_analyte_ref;

--changeset kmschoep:TR_I_ANALYTE_CODE_REL splitStatements:false

CREATE OR REPLACE TRIGGER TR_I_ANALYTE_CODE_REL
BEFORE INSERT OR UPDATE
ON ANALYTE_CODE_REL 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN

      
IF INSERTING THEN 

   if :new.analyte_code_id is null then
   :new.analyte_code_id := ANALYTE_CODE_REL_SEQ.NEXTVAL;
   end if;
   
   :new.data_entry_date := sysdate;
   :new.data_entry_name := lower(v('APP_USER'));  
   
END IF;
   
IF UPDATING THEN 

   :new.update_date := sysdate;
   :new.update_name := lower(v('APP_USER'));
   
END IF; 


END;
