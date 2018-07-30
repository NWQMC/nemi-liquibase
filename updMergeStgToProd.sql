--liquibase formatted sql

--changeset kmschoep:UpdMERGE_STG_TO_PROD splitStatements:false

CREATE OR REPLACE PACKAGE           MERGE_STG_TO_PROD AS
/******************************************************************************
   NAME:       MERGE_STG_TO_PROD
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        3/31/2008             1. Created this package.
******************************************************************************/
    
    PROCEDURE RefreshOnlineMethods(p_method_id in number);
    PROCEDURE RefreshStgMethods(p_method_id in number);
    PROCEDURE MergeOnlineMethods(p_method_id in number);
    PROCEDURE MergeStgMethods(p_method_id in number);
    PROCEDURE MergeOnlineAnalytes(p_method_id in number);
    PROCEDURE MergeStgAnalytes(p_method_id in number);
    PROCEDURE MergeOnlineRevisions(p_method_id in number);
    PROCEDURE MergeStgRevisions(p_method_id in number);
    PROCEDURE MergeProtStgRevisions(p_source_citation_id in number);
    PROCEDURE MergeProtStgMethods(p_source_citation_id in number);

END MERGE_STG_TO_PROD;
/
CREATE OR REPLACE PACKAGE BODY           MERGE_STG_TO_PROD AS
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

delete from analyte_method_jn where analyte_method_id in 
(
select analyte_method_id from analyte_method_jn
where METHOD_ID = p_method_id
minus
select analyte_method_id from analyte_method_jn_stg
where METHOD_ID = p_method_id)
and method_id = p_method_id;

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
PROCEDURE MergeProtStgRevisions(p_source_citation_id in number) IS
  BEGIN
--    execute immediate 'DROP INDEX method_pdf_ctx_idx';
    MERGE INTO revision_join B
USING (
  SELECT *
  FROM revision_join_stg amj where amj.source_citation_id = p_source_citation_id) E
ON (B.revision_id = E.revision_id)
WHEN MATCHED THEN
  UPDATE SET                                     
b.source_citation_id = e.source_citation_id,                                          
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
b.source_citation_id,                     
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
e.source_citation_id,                     
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
    
PROCEDURE MergeProtStgMethods(p_source_citation_id in number) IS
  BEGIN
--    execute immediate 'DROP INDEX method_pdf_ctx_idx';

delete from protocol_method_rel where source_citation_id =  p_source_citation_id;
insert into protocol_method_rel (protocol_method_id, source_citation_id, method_id) 
select protocol_method_id, source_citation_id, method_id from protocol_method_stg_rel where source_citation_id = p_source_citation_id; 

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
