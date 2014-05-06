--liquibase formatted sql

--changeset kmschoep:drop_TR_I_AMJO_SEQ splitStatements:false

drop TRIGGER TR_I_AMJO_SEQ;

--changeset kmschoep:drop_TR_METHODO_LAST_UPDATE_DATE splitStatements:false

drop TRIGGER TR_METHODO_LAST_UPDATE_DATE;