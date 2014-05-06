--liquibase formatted sql
--changelog kmschoep:USER_ACCOUNT 

CREATE TABLE USER_ACCOUNT
(
  USER_SEQ          NUMBER,
  USER_NAME         VARCHAR2(100 BYTE)          NOT NULL,
  USER_PASSWORD     RAW(2000),
  USER_ROLE         VARCHAR2(100 BYTE)          DEFAULT 'data_entry'          NOT NULL,
  EMAIL             VARCHAR2(200 BYTE)          NOT NULL,
  FORGOT_PW_FLAG    VARCHAR2(1 BYTE)            DEFAULT 'N'                   NOT NULL,
  DATA_ENTRY_NAME   VARCHAR2(100 BYTE)          NOT NULL,
  DATA_ENTRY_DATE   DATE                        NOT NULL,
  LAST_UPDATE_NAME  VARCHAR2(100 BYTE),
  LAST_UPDATE_DATE  DATE,
  FIRST_NAME        VARCHAR2(100 BYTE)          NOT NULL,
  LAST_NAME         VARCHAR2(200 BYTE)          NOT NULL,
  ORGANIZATION      VARCHAR2(1000 BYTE),
  LAST_LOGIN        DATE,
  USER_STATUS       VARCHAR2(10 CHAR)           DEFAULT 'ACTIVE'              NOT NULL
)
TABLESPACE NEMI
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN USER_ACCOUNT.USER_STATUS IS 'set to ''inactive'' after 18 months of not logging in.';



CREATE UNIQUE INDEX T_USER_ACCOUNT_U02 ON USER_ACCOUNT
(EMAIL)
LOGGING
TABLESPACE NEMI
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX USER_ACCOUNT_PK ON USER_ACCOUNT
(USER_SEQ)
LOGGING
TABLESPACE NEMI
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX USER_ACCOUNT_U03 ON USER_ACCOUNT
(USER_NAME)
LOGGING
TABLESPACE NEMI
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOPARALLEL;

ALTER TABLE USER_ACCOUNT ADD (
  CONSTRAINT USER_ACCOUNT_PK
  PRIMARY KEY
  (USER_SEQ)
  USING INDEX USER_ACCOUNT_PK
  ENABLE VALIDATE,
  CONSTRAINT T_USER_ACCOUNT_U02
  UNIQUE (EMAIL)
  USING INDEX T_USER_ACCOUNT_U02
  ENABLE VALIDATE,
  CONSTRAINT USER_ACCOUNT_U03
  UNIQUE (USER_NAME)
  USING INDEX USER_ACCOUNT_U03
  ENABLE VALIDATE);

ALTER TABLE USER_ACCOUNT ADD (
  CONSTRAINT USER_ACCOUNT_R01 
  FOREIGN KEY (USER_ROLE) 
  REFERENCES USER_ROLES (ROLE_NAME)
  ENABLE VALIDATE);

GRANT DELETE, INSERT, SELECT, UPDATE ON USER_ACCOUNT TO NEMI_DATA_APEX;

--changelog kmschoep:TR_I_USER_ACCOUNT splitStatements:false

CREATE OR REPLACE TRIGGER TR_I_USER_ACCOUNT
BEFORE INSERT OR UPDATE
ON USER_ACCOUNT 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN

IF INSERTING THEN 
 if :new.USER_SEQ is null then
:NEW.USER_SEQ := AUTH_USER_SQ.nextval;
end if;

   :new.data_entry_date := sysdate;
   :new.data_entry_name := nvl(:new.data_entry_name,lower(v('APP_USER')));    
   --:new.user_password := user_auth.pass_encrypt(:new.user_password);
   
END IF;
   
IF UPDATING THEN 

   :new.last_update_date := sysdate;
   :new.last_update_name := nvl(:new.last_update_name,lower(v('APP_USER')));

   
END IF;   
 
END;

--changelog kmschoep:user_roles

CREATE TABLE USER_ROLES
(
  ROLE_NAME         VARCHAR2(100 CHAR),
  ROLE_DESCRIPTION  VARCHAR2(100 CHAR)
)
TABLESPACE NEMI
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE UNIQUE INDEX USER_ROLES_PK ON USER_ROLES
(ROLE_NAME)
LOGGING
TABLESPACE NEMI
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOPARALLEL;


ALTER TABLE USER_ROLES ADD (
  CONSTRAINT USER_ROLES_PK
  PRIMARY KEY
  (ROLE_NAME)
  USING INDEX USER_ROLES_PK
  ENABLE VALIDATE);

GRANT INSERT, SELECT, UPDATE ON USER_ROLES TO NEMI_DATA_APEX;

