--liquibase formatted sql

--changeset kmschoep:add_cols splitstatments:true
ALTER TABLE NEMI_DATA.REVISION_JOIN
ADD (SOURCE_CITATION_ID NUMBER);

ALTER TABLE NEMI_DATA.REVISION_JOIN_ONLINE
ADD (SOURCE_CITATION_ID NUMBER);

ALTER TABLE NEMI_DATA.REVISION_JOIN_STG_JN
ADD (SOURCE_CITATION_ID NUMBER);

ALTER TABLE NEMI_DATA.REVISION_JOIN_STG
ADD (SOURCE_CITATION_ID NUMBER);

ALTER TABLE NEMI_DATA.REVISION_JOIN_ONLINE_JN
ADD (SOURCE_CITATION_ID NUMBER);

--changeset kmschoep:add_cols2 splitstatements:true

ALTER TABLE NEMI_DATA.SOURCE_CITATION_STG_REF_JN
ADD (CITATION_TYPE VARCHAR2(50 BYTE));

ALTER TABLE NEMI_DATA.SOURCE_CITATION_STG_REF_JN
ADD (READY_FOR_REVIEW VARCHAR2(1 CHAR) DEFAULT 'N');

ALTER TABLE NEMI_DATA.SOURCE_CITATION_STG_REF_JN
ADD (OWNER_EDITABLE VARCHAR2(1 CHAR) DEFAULT 'N');

ALTER TABLE NEMI_DATA.SOURCE_CITATION_STG_REF_JN
ADD (APPROVED_DATE DATE);

ALTER TABLE NEMI_DATA.SOURCE_CITATION_STG_REF_JN
ADD (APPROVED VARCHAR2(1 CHAR) DEFAULT 'N');

ALTER TABLE NEMI_DATA.SOURCE_CITATION_STG_REF
ADD (CITATION_TYPE VARCHAR2(50 BYTE) DEFAULT 'METHOD');

ALTER TABLE NEMI_DATA.SOURCE_CITATION_STG_REF
ADD (READY_FOR_REVIEW VARCHAR2(1 CHAR) DEFAULT 'N');

ALTER TABLE NEMI_DATA.SOURCE_CITATION_STG_REF
ADD (OWNER_EDITABLE VARCHAR2(1 CHAR) DEFAULT 'N');

ALTER TABLE NEMI_DATA.SOURCE_CITATION_STG_REF
ADD (APPROVED_DATE DATE);

ALTER TABLE NEMI_DATA.SOURCE_CITATION_STG_REF
ADD (APPROVED VARCHAR2(1 CHAR) DEFAULT 'N');

ALTER TABLE NEMI_DATA.SOURCE_CITATION_ONLINE_REF_JN
ADD (CITATION_TYPE VARCHAR2(50 BYTE));

ALTER TABLE NEMI_DATA.SOURCE_CITATION_ONLINE_REF_JN
ADD (READY_FOR_REVIEW VARCHAR2(1 CHAR));

ALTER TABLE NEMI_DATA.SOURCE_CITATION_ONLINE_REF
ADD (CITATION_TYPE VARCHAR2(50 BYTE) DEFAULT 'METHOD');

ALTER TABLE NEMI_DATA.SOURCE_CITATION_ONLINE_REF
ADD (READY_FOR_REVIEW VARCHAR2(1 CHAR) DEFAULT 'N');

ALTER TABLE NEMI_DATA.SOURCE_CITATION_REF
ADD (CITATION_TYPE VARCHAR2(50 BYTE));

ALTER TABLE NEMI_DATA.SOURCE_CITATION_REF
ADD (APPROVED VARCHAR2(1 CHAR));

ALTER TABLE NEMI_DATA.SOURCE_CITATION_REF
ADD (APPROVED_DATE DATE);

--changeset kmschoep:increase_toc_protocol splitstatements:true
alter table NEMI_DATA.SOURCE_CITATION_ONLINE_REF
modify(table_of_contents varchar2(3000 Char));

alter table NEMI_DATA.SOURCE_CITATION_ONLINE_REF_JN
modify(table_of_contents varchar2(3000 Char));

alter table NEMI_DATA.SOURCE_CITATION_STG_REF
modify(table_of_contents varchar2(3000 Char));

alter table NEMI_DATA.SOURCE_CITATION_STG_REF_JN
modify(table_of_contents varchar2(3000 Char));

alter table NEMI_DATA.SOURCE_CITATION_REF
modify(table_of_contents varchar2(3000 Char));

--changeset kmschoep:mod_cols splitstatements:true
ALTER TABLE NEMI_DATA.REVISION_JOIN
MODIFY (METHOD_ID NULL);

ALTER TABLE NEMI_DATA.REVISION_JOIN_STG
MODIFY (METHOD_ID NULL);
 
--changeset kmschoep:protocol_method_rel splitstatements:true
CREATE TABLE NEMI_DATA.PROTOCOL_METHOD_REL
(
PROTOCOL_METHOD_ID NUMBER,
SOURCE_CITATION_ID NUMBER NOT NULL,
METHOD_ID NUMBER NOT NULL
)
TABLESPACE NEMI
PCTUSED 0
PCTFREE 10
INITRANS 1
MAXTRANS 255
STORAGE (
PCTINCREASE 0
BUFFER_POOL DEFAULT
)
LOGGING
NOCOMPRESS
NOCACHE
NOPARALLEL
MONITORING;

ALTER TABLE NEMI_DATA.PROTOCOL_METHOD_REL
ADD CONSTRAINT PROTOCOL_METHOD_REL_PK
PRIMARY KEY
(PROTOCOL_METHOD_ID);

--changeset kmschoep:grant_protocol_method_rel_nemi_user
grant select on nemi_data.PROTOCOL_METHOD_REL to nemi_user;

--changeset kmschoep:PROTOCOL_METHOD_ONLINE_REL splitstatements:true
CREATE TABLE NEMI_DATA.PROTOCOL_METHOD_ONLINE_REL
(
PROTOCOL_METHOD_ID NUMBER,
SOURCE_CITATION_ID NUMBER NOT NULL,
METHOD_ID NUMBER NOT NULL
)
TABLESPACE NEMI
PCTUSED 0
PCTFREE 10
INITRANS 1
MAXTRANS 255
STORAGE (
PCTINCREASE 0
BUFFER_POOL DEFAULT
)
LOGGING
NOCOMPRESS
NOCACHE
NOPARALLEL
MONITORING;

ALTER TABLE NEMI_DATA.PROTOCOL_METHOD_ONLINE_REL
ADD CONSTRAINT PROTOCOL_METHOD_O_REL_PK
PRIMARY KEY
(PROTOCOL_METHOD_ID);

--changeset kmschoep:PROTOCOL_METHOD_STG_REL splitstatements:true
CREATE TABLE NEMI_DATA.PROTOCOL_METHOD_STG_REL
(
PROTOCOL_METHOD_ID NUMBER,
SOURCE_CITATION_ID NUMBER NOT NULL,
METHOD_ID NUMBER NOT NULL
)
TABLESPACE NEMI
PCTUSED 0
PCTFREE 10
INITRANS 1
MAXTRANS 255
STORAGE (
PCTINCREASE 0
BUFFER_POOL DEFAULT
)
LOGGING
NOCOMPRESS
NOCACHE
NOPARALLEL
MONITORING;

 ALTER TABLE NEMI_DATA.PROTOCOL_METHOD_STG_REL
 ADD CONSTRAINT PROTOCOL_METHOD_STG_REL_PK
 PRIMARY KEY
 (PROTOCOL_METHOD_ID);

--changeset kmschoep:rjo_jn_u_trigger2 splitstatements:false 
 CREATE OR REPLACE TRIGGER NEMI_DATA.TR_U_JN_REVISION_JOIN_ONLINE
 BEFORE UPDATE
 ON REVISION_JOIN_ONLINE
 REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
 BEGIN

 insert into REVISION_JOIN_ONLINE_JN (

 JN_OPERATION,
 JN_ORACLE_USER,
 JN_DATETIME,
 REVISION_ID,
 METHOD_ID,
 REVISION_INFORMATION,
 METHOD_PDF,
 INSERT_DATE,
 INSERT_PERSON_NAME,
 LAST_UPDATE_DATE,
 LAST_UPDATE_PERSON_NAME,
 REVISION_FLAG,
 MIMETYPE,
 PDF_INSERT_PERSON,
 PDF_INSERT_DATE,
 reviewer_name,
 source_citation_id )
 values (
 'UPD',
 'NEMI_DATA',
 SYSDATE,
 :OLD.REVISION_ID,
 :OLD.METHOD_ID,
 :OLD.REVISION_INFORMATION,
 :OLD.METHOD_PDF,
 :OLD.INSERT_DATE,
 :OLD.INSERT_PERSON_NAME,
 :OLD.LAST_UPDATE_DATE,
 :OLD.LAST_UPDATE_PERSON_NAME,
 :OLD.REVISION_FLAG,
 :OLD.MIMETYPE,
 :OLD.PDF_INSERT_PERSON,
 :OLD.PDF_INSERT_DATE,
 :old.reviewer_name,
 :old.source_citation_id ) ;

 END;
 
--changeset kmschoep:rjo_jn_d_trigger splitstatements:false 
 CREATE OR REPLACE TRIGGER NEMI_DATA.TR_D_JN_REVISION_JOIN_ONLINE
 BEFORE DELETE
 ON REVISION_JOIN_ONLINE
 REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
 BEGIN

 insert into REVISION_JOIN_ONLINE_JN (

 JN_OPERATION,
 JN_ORACLE_USER,
 JN_DATETIME,
 REVISION_ID,
 METHOD_ID,
 REVISION_INFORMATION,
 METHOD_PDF,
 INSERT_DATE,
 INSERT_PERSON_NAME,
 LAST_UPDATE_DATE,
 LAST_UPDATE_PERSON_NAME,
 REVISION_FLAG,
 MIMETYPE,
 PDF_INSERT_PERSON,
 PDF_INSERT_DATE,
 reviewer_name,
 source_citation_id )
 values (
 'DEL',
 'NEMI_DATA',
 SYSDATE,
 :OLD.REVISION_ID,
 :OLD.METHOD_ID,
 :OLD.REVISION_INFORMATION,
 :OLD.METHOD_PDF,
 :OLD.INSERT_DATE,
 :OLD.INSERT_PERSON_NAME,
 :OLD.LAST_UPDATE_DATE,
 :OLD.LAST_UPDATE_PERSON_NAME,
 :OLD.REVISION_FLAG,
 :OLD.MIMETYPE,
 :OLD.PDF_INSERT_PERSON,
 :OLD.PDF_INSERT_DATE,
 :old.reviewer_name,
 :old.source_citation_id ) ;

 END;
 
--changeset kmschoep:rjs_jn_u_trigger splitstatements:false 
 CREATE OR REPLACE TRIGGER NEMI_DATA.TR_U_JN_REVISION_JOIN_STG
 BEFORE UPDATE
 ON NEMI_DATA.REVISION_JOIN_stg
 REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
 BEGIN

 insert into REVISION_JOIN_stg_JN (

 JN_OPERATION,
 JN_ORACLE_USER,
 JN_DATETIME,
 REVISION_ID,
 METHOD_ID,
 REVISION_INFORMATION,
 METHOD_PDF,
 INSERT_DATE,
 INSERT_PERSON_NAME,
 LAST_UPDATE_DATE,
 LAST_UPDATE_PERSON_NAME,
 REVISION_FLAG,
 MIMETYPE,
 PDF_INSERT_PERSON,
 PDF_INSERT_DATE,
 source_citation_id )
 values (
 'UPD',
 'NEMI_DATA',
 SYSDATE,
 :OLD.REVISION_ID,
 :OLD.METHOD_ID,
 :OLD.REVISION_INFORMATION,
 :OLD.METHOD_PDF,
 :OLD.INSERT_DATE,
 :OLD.INSERT_PERSON_NAME,
 :OLD.LAST_UPDATE_DATE,
 :OLD.LAST_UPDATE_PERSON_NAME,
 :OLD.REVISION_FLAG,
 :OLD.MIMETYPE,
 :OLD.PDF_INSERT_PERSON,
 :OLD.PDF_INSERT_DATE,
 :old.source_citation_id ) ;

 END;

--changeset kmschoep:rjs_jn_d_trigger splitstatements:false 
 CREATE OR REPLACE TRIGGER NEMI_DATA.TR_D_JN_REVISION_JOIN_STG
 BEFORE DELETE
 ON NEMI_DATA.REVISION_JOIN_STG
 REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
 BEGIN

 insert into REVISION_JOIN_STG_JN (

 JN_OPERATION,
 JN_ORACLE_USER,
 JN_DATETIME,
 REVISION_ID,
 METHOD_ID,
 REVISION_INFORMATION,
 METHOD_PDF,
 INSERT_DATE,
 INSERT_PERSON_NAME,
 LAST_UPDATE_DATE,
 LAST_UPDATE_PERSON_NAME,
 REVISION_FLAG,
 MIMETYPE,
 PDF_INSERT_PERSON,
 PDF_INSERT_DATE,
 source_citation_id )
 values (
 'DEL',
 'NEMI_DATA',
 SYSDATE,
 :OLD.REVISION_ID,
 :OLD.METHOD_ID,
 :OLD.REVISION_INFORMATION,
 :OLD.METHOD_PDF,
 :OLD.INSERT_DATE,
 :OLD.INSERT_PERSON_NAME,
 :OLD.LAST_UPDATE_DATE,
 :OLD.LAST_UPDATE_PERSON_NAME,
 :OLD.REVISION_FLAG,
 :OLD.MIMETYPE,
 :OLD.PDF_INSERT_PERSON,
 :OLD.PDF_INSERT_DATE,
 :old.source_citation_id ) ;

 END;

--changeset kmschoep:add_fks splitstatements:true  
 ALTER TABLE NEMI_DATA.PROTOCOL_METHOD_REL
 ADD CONSTRAINT PROTOCOL_METHOD_REL_R01
 FOREIGN KEY (SOURCE_CITATION_ID)
 REFERENCES NEMI_DATA.SOURCE_CITATION_REF (SOURCE_CITATION_ID);

 ALTER TABLE NEMI_DATA.PROTOCOL_METHOD_REL
 ADD CONSTRAINT PROTOCOL_METHOD_REL_R02
 FOREIGN KEY (METHOD_ID)
 REFERENCES NEMI_DATA.METHOD (METHOD_ID);

 ALTER TABLE NEMI_DATA.PROTOCOL_METHOD_ONLINE_REL
 ADD CONSTRAINT PROTOCOL_METHOD_O_REL_R01
 FOREIGN KEY (SOURCE_CITATION_ID)
 REFERENCES NEMI_DATA.SOURCE_CITATION_ONLINE_REF (SOURCE_CITATION_ID);

 ALTER TABLE NEMI_DATA.PROTOCOL_METHOD_ONLINE_REL
 ADD CONSTRAINT PROTOCOL_METHOD_O_REL_R02
 FOREIGN KEY (METHOD_ID)
 REFERENCES NEMI_DATA.METHOD_ONLINE (METHOD_ID);

 ALTER TABLE NEMI_DATA.PROTOCOL_METHOD_STG_REL
 ADD CONSTRAINT PROTOCOL_METHOD_STG_REL_R01
 FOREIGN KEY (SOURCE_CITATION_ID)
 REFERENCES NEMI_DATA.SOURCE_CITATION_STG_REF (SOURCE_CITATION_ID);

 ALTER TABLE NEMI_DATA.PROTOCOL_METHOD_STG_REL
 ADD CONSTRAINT PROTOCOL_METHOD_STG_REL_R02
 FOREIGN KEY (METHOD_ID)
 REFERENCES NEMI_DATA.METHOD_STG (METHOD_ID);

 ALTER TABLE NEMI_DATA.REVISION_JOIN
 ADD FOREIGN KEY (SOURCE_CITATION_ID)
 REFERENCES NEMI_DATA.SOURCE_CITATION_REF (SOURCE_CITATION_ID)
 ON DELETE CASCADE;

 ALTER TABLE NEMI_DATA.REVISION_JOIN_ONLINE
 ADD FOREIGN KEY (SOURCE_CITATION_ID)
 REFERENCES NEMI_DATA.SOURCE_CITATION_ONLINE_REF (SOURCE_CITATION_ID)
 ON DELETE CASCADE;

 ALTER TABLE NEMI_DATA.REVISION_JOIN_STG
 ADD FOREIGN KEY (SOURCE_CITATION_ID)
 REFERENCES NEMI_DATA.SOURCE_CITATION_STG_REF (SOURCE_CITATION_ID)
 ON DELETE CASCADE;

--changeset kmschoep:merge_stg_to_prod_spec2 splitstatements:false
CREATE OR REPLACE PACKAGE NEMI_DATA.MERGE_STG_TO_PROD AS
/******************************************************************************
NAME: MERGE_STG_TO_PROD
PURPOSE:

REVISIONS:
Ver Date Author Description
--------- ---------- --------------- ------------------------------------
1.0 3/31/2008 1. Created this package.
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

--changeset kmschoep:emailer_spec splitstatements:false
CREATE OR REPLACE PACKAGE NEMI_DATA.emailer is
procedure review_email(v_body in varchar2, v_body_html in varchar2);
procedure review_protocol_email(v_body in varchar2, v_body_html in varchar2);
procedure owner_email(v_method_id in number, v_body in varchar2, v_body_html in varchar2);
procedure owner_approval(v_method_id in number);
procedure new_user_email;
end;

--changeset kmschoep:emailer_body2 splitstatements:false
CREATE OR REPLACE PACKAGE BODY NEMI_DATA.emailer as

current_host varchar2(100) := lower(sys_context('USERENV', 'INSTANCE_NAME'));
base_url varchar2(100) := case
when current_host like '%dev%' then 'http://cida-eros-apexdev1.er.usgs.gov/devtrans/apex/'
when current_host like '%qa%' then 'http://cida-test.er.usgs.gov/nemi_forms/apex/'
when current_host = 'dbtrans' then 'http://cida.usgs.gov/nemi_forms/apex/' end;
crlf varchar2(10) := chr(10)||chr(13);
l_body_html varchar2(4000);
l_body varchar2(4000);
v_reviewer_email varchar2(100) := case
when current_host like '%dev%' then 'kmschoep@usgs.gov'
when current_host like '%qa%' then 'kmschoep@usgs.gov'
when current_host = 'dbtrans' then 'nemi@usgs.gov' end;


 procedure review_email(v_body in varchar2, v_body_html varchar2) is

 begin

 l_body := 'The following method(s) from the _stg tables are ready for review:'||CRLF;
 l_body_html := 'The following method(s) from the _stg tables are ready for review:<p>';
 l_body := l_body||v_body;
 l_body_html := l_body_html||v_body_html;
 l_body := l_body||crlf||'Link to review method(s): '||base_url||'f?p=nemi_stg_forms:method_list:::::P5_READY_FOR_REVIEW:Y';
 l_body_html := l_body_html||'<p><a title="Link to review method(s)" href="'||base_url||'f?p=nemi_stg_forms:method_list:::::P5_READY_FOR_REVIEW:Y">Link to review method(s)</a><br>';

 apex_mail.send(
 p_to => v_reviewer_email,
 p_from => 'nemi@usgs.gov', -- change to a real senders email address
 p_body => l_body,
 p_body_html => l_body_html,
 p_subj => '[NEMI-'||current_host||']- staging methods ready for review');
 APEX_MAIL.PUSH_QUEUE('gsvaresh01.er.usgs.gov','25');
 end;

 procedure review_protocol_email(v_body in varchar2, v_body_html varchar2) is

 begin

 l_body := 'The following protocol(s) from the _stg tables are ready for review:'||CRLF;
 l_body_html := 'The following protocol(s) from the _stg tables are ready for review:<p>';
 l_body := l_body||v_body;
 l_body_html := l_body_html||v_body_html;
 l_body := l_body||crlf||'Link to review protocol(s): '||base_url||'f?p=nemi_stg_forms:protocols';
 l_body_html := l_body_html||'<p><a title="Link to review protocol(s)" href="'||base_url||'f?p=nemi_stg_forms:protocols">Link to review protocol(s)</a><br>';

 apex_mail.send(
 p_to => v_reviewer_email,
 p_from => 'nemi@usgs.gov', -- change to a real senders email address
 p_body => l_body,
 p_body_html => l_body_html,
 p_subj => '[NEMI-'||current_host||']- staging protocols ready for review');
 APEX_MAIL.PUSH_QUEUE('localhost','25');
 end;

 procedure owner_email(v_method_id in number, v_body in varchar2, v_body_html varchar2) is
 v_source_method_identifier varchar2(100);
 v_user_email varchar2(100);

 begin
 select ms.source_method_identifier, ua.email into v_source_method_identifier, v_user_email from method_stg ms, user_account ua where
 ms.method_id = v_method_id and
 lower(ms.insert_person_name) = lower(ua.user_name) ;


 l_body := 'Method '||v_source_method_identifier||', which you have submitted for review requires additional edits before it can be approved for inclusion on www.nemi.gov.'||crlf;
 l_body_html := 'Method '||v_source_method_identifier||', which you have submitted for review requires additional edits before it can be approved for inclusion on www.nemi.gov.<p>';
 l_body := l_body||v_body;
 l_body_html := l_body_html||v_body_html;
 l_body := l_body||crlf||'Link to edit method: '||base_url||'f?p=nemi_stg_forms:method:::::P2_METHOD_ID:'||v_method_id;
 l_body_html := l_body_html||'<p><a title="Link to edit method" href="'||base_url||'f?p=nemi_stg_forms:method:::::P2_METHOD_ID:'||v_method_id||'">Link to edit method</a><br>';

 apex_mail.send(
 p_to => v_user_email,
 p_from => 'nemi@usgs.gov', -- change to a real senders email address
 --p_bcc => 'nemi@usgs.gov',
 p_body => l_body,
 p_body_html => l_body_html,
 p_subj => 'NEMI Method '||v_source_method_identifier||' requires additional edits');
 APEX_MAIL.PUSH_QUEUE('gsvaresh01.er.usgs.gov','25');

 exception
 when no_data_found then
 RAISE_APPLICATION_ERROR(-20000, 'Method owner does not have a user account.');
 raise;


 end;
 procedure owner_approval(v_method_id in number) is
 v_source_method_identifier varchar2(100);
 v_user_email varchar2(100);

 begin
 select ms.source_method_identifier, ua.email into v_source_method_identifier, v_user_email from method_stg ms, user_account ua where
 ms.method_id = v_method_id and
 lower(ms.insert_person_name) = lower(ua.user_name) ;


 l_body := 'Method '||v_source_method_identifier||', which you have submitted for inclusion on www.nemi.gov has been approved. It will be available for searching on the website in a day or two.'||crlf ||'Thank you for contributing your method to NEMI!';
 l_body_html := 'Method '||v_source_method_identifier||', which you have submitted for inclusion on www.nemi.gov has been approved. It will be available for searching on the website in a day or two.<p>Thank you for contributing your method to NEMI!';

 apex_mail.send(
 p_to => v_user_email,
 p_from => 'nemi@usgs.gov', -- change to a real senders email address
 --p_bcc => 'nemi@usgs.gov',
 p_body => l_body,
 p_body_html => l_body_html,
 p_subj => 'NEMI Method '||v_source_method_identifier||' has been approved.');
 APEX_MAIL.PUSH_QUEUE('gsvaresh01.er.usgs.gov','25');

 exception
 when no_data_found then
 null;


 end;

 procedure new_user_email is

 l_body varchar2(2000);
 l_body_html varchar2(2000);

 begin
 l_body := 'A new user has created an account for Classic NEMI:'||chr(13)||chr(10)||
 v('P100_FIRST_NAME')||chr(13)||chr(10)||
 v('P100_LAST_NAME')||chr(13)||chr(10)||
 v('P100_ORGANIZATION')||chr(13)||chr(10)||
 v('P100_EMAIL');

 l_body_html := 'A new user has created an account for Classic NEMI:<p>'||
 v('P100_FIRST_NAME')||'<br>'||
 v('P100_LAST_NAME')||'<br>'||
 v('P100_ORGANIZATION')||'<br>'||
 v('P100_EMAIL');

 apex_mail.send(
 p_to => 'nemi@usgs.gov',
 p_from => 'nemi@usgs.gov', -- change to a real senders email address
 p_body => l_body,
 p_body_html => l_body_html,
 p_subj => '[NEMI-'||current_host||']- New Classic NEMI user');
 APEX_MAIL.PUSH_QUEUE('gsvaresh01.er.usgs.gov','25');
 end;
 end;

--changeset kmschoep:merge_stg_to_prod_body splitstatements:false
CREATE OR REPLACE PACKAGE BODY NEMI_DATA.MERGE_STG_TO_PROD AS
/******************************************************************************
NAME: MergeMethods
PURPOSE:

REVISIONS:
Ver Date Author Description
--------- ---------- --------------- ------------------------------------
1.0 3/31/2008 1. Created this package body.
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
FROM analyte_method_jn_online amj where amj.method_id = p_method_id ) E
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
-- execute immediate 'DROP INDEX method_pdf_ctx_idx';
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
-- execute immediate 'DROP INDEX method_pdf_ctx_idx';
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
-- execute immediate 'DROP INDEX method_pdf_ctx_idx';

delete from protocol_method_rel where source_citation_id = p_source_citation_id;
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

--changeset kmschoep:tr_i_protocol_method_online splitstatements:false
 CREATE OR REPLACE TRIGGER NEMI_DATA.tr_i_protocol_method_online
 BEFORE INSERT
 ON PROTOCOL_METHOD_ONLINE_REL
 REFERENCING NEW AS New OLD AS Old
 FOR EACH ROW
 DECLARE
 tmpVar NUMBER;
 /******************************************************************************
 NAME:
 PURPOSE:

 REVISIONS:
 Ver Date Author Description
 --------- ---------- --------------- ------------------------------------
 1.0 2/4/2014 kmschoep 1. Created this trigger.

 NOTES:

 Automatically available Auto Replace Keywords:
 Object Name:
 Sysdate: 2/4/2014
 Date and Time: 2/4/2014, 4:21:14 PM, and 2/4/2014 4:21:14 PM
 Username: kmschoep (set in TOAD Options, Proc Templates)
 Table Name: PROTOCOL_METHOD_ONLINE_REL (set in the "New PL/SQL Object" dialog)
 Trigger Options: (set in the "New PL/SQL Object" dialog)
 ******************************************************************************/
 BEGIN
 tmpVar := 0;
 if :NEW.protocol_method_id is null then
 :NEW.protocol_method_id := method_id_seq.nextval;
 end if;

 EXCEPTION
 WHEN OTHERS THEN
 -- Consider logging the error and then re-raise
 RAISE;
 END ;

--changeset kmschoep:tr_i_protocol_method_id splitstatements:false
CREATE OR REPLACE TRIGGER NEMI_DATA.TR_I_PROTOCOL_METHOD_ID
 BEFORE INSERT
 ON PROTOCOL_METHOD_STG_REL
 REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
 DECLARE
 tmpVar NUMBER;
 /******************************************************************************
 NAME: tr_i_protocol_method_id
 PURPOSE:

 REVISIONS:
 Ver Date Author Description
 --------- ---------- --------------- ------------------------------------
 1.0 2/4/2014 kmschoep 1. Created this trigger.

 NOTES:

 Automatically available Auto Replace Keywords:
 Object Name: tr_i_protocol_method_id
 Sysdate: 2/4/2014
 Date and Time: 2/4/2014, 4:19:47 PM, and 2/4/2014 4:19:47 PM
 Username: kmschoep (set in TOAD Options, Proc Templates)
 Table Name: PROTOCOL_METHOD_STG_REL (set in the "New PL/SQL Object" dialog)
 Trigger Options: (set in the "New PL/SQL Object" dialog)
 ******************************************************************************/
 BEGIN
 tmpVar := 0;

 if :NEW.protocol_method_id is null then
 :NEW.protocol_method_id := method_id_seq.nextval;
 end if;


 EXCEPTION
 WHEN OTHERS THEN
 -- Consider logging the error and then re-raise
 RAISE;
 END tr_i_protocol_method_id;

--changeset kmschoep:TR_D_JN_SOURCE_CITATION_ONLINE2 splitstatements:false
CREATE OR REPLACE TRIGGER NEMI_DATA.TR_D_JN_SOURCE_CITATION_ONLINE
 BEFORE DELETE
 ON SOURCE_CITATION_ONLINE_REF
 REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
 BEGIN

 insert into SOURCE_CITATION_ONLINE_REF_JN (

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
 ITEM_TYPE_NOTE,
 SPONSER_TYPE_NOTE,
 INSERT_PERSON_NAME,
 CITATION_TYPE,
 ready_for_review )
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
 :old.ITEM_TYPE_NOTE,
 :old.SPONSER_TYPE_NOTE,
 :old.INSERT_PERSON_NAME,
 :OLD.CITATION_TYPE,
 :old.ready_for_review) ;
 END;

 
--changeset kmschoep:TR_U_JN_SOURCE_CITATION_ONLINE2 splitstatements:false
CREATE OR REPLACE TRIGGER NEMI_DATA.TR_U_JN_SOURCE_CITATION_ONLINE
 BEFORE UPDATE
 ON SOURCE_CITATION_ONLINE_REF
 REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
 BEGIN

 insert into SOURCE_CITATION_ONLINE_REF_JN (

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
 ITEM_TYPE_NOTE,
 SPONSER_TYPE_NOTE,
 INSERT_PERSON_NAME,
 CITATION_TYPE,
 ready_for_review )
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
 :old.ITEM_TYPE_NOTE,
 :old.SPONSER_TYPE_NOTE,
 :old.INSERT_PERSON_NAME,
 :OLD.CITATION_TYPE,
 :old.ready_for_review) ;
 END; 

--changeset kmschoep:TR_U_JN_SOURCE_STG_ONLINE splitstatements:false
CREATE OR REPLACE TRIGGER NEMI_DATA.TR_U_JN_SOURCE_STG_ONLINE
 BEFORE UPDATE
 ON SOURCE_CITATION_STG_REF
 REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
 BEGIN

 insert into SOURCE_CITATION_STG_REF_JN (

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
 ITEM_TYPE_NOTE,
 SPONSER_TYPE_NOTE,
 INSERT_PERSON_NAME,
 CITATION_TYPE,
 READY_FOR_REVIEW,
 OWNER_EDITABLE,
 APPROVED_DATE,
 APPROVED )
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
 :old.ITEM_TYPE_NOTE,
 :old.SPONSER_TYPE_NOTE,
 :old.INSERT_PERSON_NAME,
 :OLD.CITATION_TYPE,
 :OLD.READY_FOR_REVIEW,
 :OLD.OWNER_EDITABLE,
 :OLD.APPROVED_DATE,
 :OLD.APPROVED) ;
 END; 
 
--changeset kmschoep:TR_D_JN_SOURCE_STG_ONLINE splitstatements:false
CREATE OR REPLACE TRIGGER NEMI_DATA.TR_D_JN_SOURCE_STG_ONLINE
 BEFORE DELETE
 ON SOURCE_CITATION_STG_REF
 REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
 BEGIN

 insert into SOURCE_CITATION_STG_REF_JN (

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
 ITEM_TYPE_NOTE,
 SPONSER_TYPE_NOTE,
 INSERT_PERSON_NAME,
 CITATION_TYPE,
 READY_FOR_REVIEW,
 OWNER_EDITABLE,
 APPROVED_DATE,
 APPROVED)
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
 :old.ITEM_TYPE_NOTE,
 :old.SPONSER_TYPE_NOTE,
 :old.INSERT_PERSON_NAME,
 :OLD.CITATION_TYPE,
 :OLD.READY_FOR_REVIEW,
 :OLD.OWNER_EDITABLE,
 :OLD.APPROVED_DATE,
 :OLD.APPROVED) ;

 END; 
 
--changeset kmschoep:TR_U_APPROVED_PROT_STG1 splitstatements:false
CREATE OR REPLACE TRIGGER NEMI_DATA.TR_U_APPROVED_PROT_STG
 AFTER UPDATE
 OF APPROVED
 ON SOURCE_CITATION_STG_REF
 REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
 declare

 BEGIN
 if :new.citation_type = 'PROTOCOL' THEN

 if nvl(:old.approved,'N') = 'N' and :new.approved = 'Y'
 then
 UPDATE source_citation_ref SET
 SOURCE_CITATION = :new.SOURCE_CITATION,
 SOURCE_CITATION_NAME = :new.SOURCE_CITATION_NAME,
 SOURCE_CITATION_INFORMATION = :new.SOURCE_CITATION_INFORMATION,
 INSERT_DATE = :new.INSERT_DATE,
 TITLE = :new.TITLE,
 AUTHOR = :new.AUTHOR,
 ABSTRACT_SUMMARY = :new.ABSTRACT_SUMMARY,
 TABLE_OF_CONTENTS = :new.TABLE_OF_CONTENTS,
 LINK = :new.LINK,
 NOTES = :new.NOTES,
 PUBLICATION_YEAR = :new.PUBLICATION_YEAR,
 UPDATE_DATE = :new.UPDATE_DATE,
 INSERT_PERSON_NAME = :new.INSERT_PERSON_NAME,
 CITATION_TYPE = :new.CITATION_TYPE,
 APPROVED_DATE = :new.APPROVED_DATE,
 APPROVED = :new.APPROVED
 where SOURCE_CITATION_ID = :new.SOURCE_CITATION_ID;
 IF sql%ROWCOUNT=0 then
 INSERT into source_citation_ref (
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
 PUBLICATION_YEAR,
 UPDATE_DATE,
 INSERT_PERSON_NAME,
 CITATION_TYPE,
 APPROVED_DATE,
 APPROVED)
 VALUES (
 :new.SOURCE_CITATION_ID,
 :new.SOURCE_CITATION,
 :new.SOURCE_CITATION_NAME,
 :new.SOURCE_CITATION_INFORMATION,
 :new.INSERT_DATE,
 :new.TITLE,
 :new.AUTHOR,
 :new.ABSTRACT_SUMMARY,
 :new.TABLE_OF_CONTENTS,
 :new.LINK,
 :new.NOTES,
 :new.PUBLICATION_YEAR,
 :new.UPDATE_DATE,
 :new.INSERT_PERSON_NAME,
 :new.CITATION_TYPE,
 :new.APPROVED_DATE,
 :new.APPROVED);
 end if;


 merge_stg_to_prod.MergeProtStgRevisions(:new.source_citation_id);
 merge_stg_to_prod.MergeProtStgMethods(:new.source_citation_id);
 LOTUS_EMAIL ('nemi@usgs.gov',
 'djsulliv@usgs.gov',
 'Protocol '||:new.SOURCE_CITATION||' has been approved',
 'Protocol '||:new.SOURCE_CITATION||' has been approved');
 end if;
 END IF;



 END;
 
--changeset kmschoep:protocol_stg_vw3 splitstatements:false
CREATE OR REPLACE FORCE VIEW NEMI_DATA.PROTOCOL_STG_VW
(SOURCE_CITATION_ID, SOURCE_CITATION, SOURCE_CITATION_NAME, SOURCE_CITATION_INFORMATION,TITLE,
AUTHOR, PUBLICATION_YEAR, READY_FOR_REVIEW, APPROVED, APPROVED_DATE,
INSERT_PERSON_NAME, INSERT_DATE, UPDATE_DATE, METHODS, REVISIONS,
STATUS)
AS
select
source_citation_id,
source_citation,
source_citation_name,
source_citation_information,
title,
author,
publication_year,
ready_for_review,
approved,
approved_date,
insert_person_name,
insert_date,
update_date,
methods,
revisions,
case when methods = 'Has Methods' and revisions = 'Has Revision' then 'COMPLETE' else 'NOT COMPLETE' end status
from (
select
sc.source_citation_id,
sc.source_citation,
sc.source_citation_name,
sc.source_citation_information,
sc.title,
 sc.author,
 sc.publication_year,
 sc.ready_for_review,
 sc.approved,
 sc.approved_date,
 sc.insert_person_name,
 sc.insert_date,
 sc.update_date,
 case when exists(select null from protocol_method_stg_rel pm where pm.source_citation_id = sc.source_citation_id) 
 then 'Has Methods' else 'Needs Method(s)' end methods,
 case when exists(select null from revision_join_stg rj where (rj.source_citation_id = sc.source_citation_id and rj.revision_flag = 1 and rj.method_pdf is not null) or sc.link is not null) 
 then 'Has Revision' else 'Needs Revision(s)' end revisions
 from source_citation_stg_ref sc where citation_type = 'PROTOCOL')
 
 
--changeset kmschoep:grants2 splitstatements:true
GRANT DELETE, INSERT, SELECT, UPDATE ON NEMI_DATA.PROTOCOL_METHOD_ONLINE_REL TO NEMI_DATA_APEX;
GRANT DELETE, INSERT, SELECT, UPDATE ON NEMI_DATA.PROTOCOL_METHOD_REL TO NEMI_DATA_APEX;
GRANT DELETE, INSERT, SELECT, UPDATE ON NEMI_DATA.PROTOCOL_METHOD_STG_REL TO NEMI_DATA_APEX;
GRANT SELECT ON NEMI_DATA.PROTOCOL_STG_VW TO NEMI_DATA_APEX;
GRANT DELETE, INSERT, SELECT, UPDATE ON NEMI_DATA.SOURCE_CITATION_ONLINE_REF TO NEMI_DATA_APEX;

--changeset kmschoep:constraints splitstatements:true
ALTER TABLE NEMI_DATA.REVISION_JOIN
 ADD CONSTRAINT REVISION_JOIN_C01
 CHECK (method_id is not null or source_citation_id is not null);

 ALTER TABLE NEMI_DATA.REVISION_JOIN_STG
 ADD CONSTRAINT REVISION_JOIN_STG_C01
 CHECK (method_id is not null or source_citation_id is not null);

 ALTER TABLE NEMI_DATA.PROTOCOL_METHOD_STG_REL
 DROP CONSTRAINT PROTOCOL_METHOD_STG_REL_R01;

 ALTER TABLE NEMI_DATA.PROTOCOL_METHOD_STG_REL
 ADD CONSTRAINT PROTOCOL_METHOD_STG_REL_R01
 FOREIGN KEY (SOURCE_CITATION_ID)
 REFERENCES NEMI_DATA.SOURCE_CITATION_STG_REF (SOURCE_CITATION_ID)
 ON DELETE CASCADE;

 ALTER TABLE NEMI_DATA.PROTOCOL_METHOD_STG_REL
 DROP CONSTRAINT PROTOCOL_METHOD_STG_REL_R02;

 ALTER TABLE NEMI_DATA.PROTOCOL_METHOD_STG_REL
 ADD CONSTRAINT PROTOCOL_METHOD_STG_REL_R02
 FOREIGN KEY (METHOD_ID)
 REFERENCES NEMI_DATA.METHOD_STG (METHOD_ID)
 ON DELETE CASCADE;
