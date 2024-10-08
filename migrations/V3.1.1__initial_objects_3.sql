CREATE OR REPLACE SCHEMA SCHEMA_TEST;
create or replace TABLE PEOPLE (
	ID VARCHAR(16777216) NOT NULL,
	IS_ACTIVE BOOLEAN NOT NULL,
	CREATE_DATE TIMESTAMP_NTZ(9) NOT NULL,
	FIRST_NAME VARCHAR(16777216),
	LAST_NAME VARCHAR(16777216),
	BIRTHDATE TIMESTAMP_NTZ(9),
	PHOTOR_URL VARCHAR(16777216),
	GENDER_OPTION_ID NUMBER(38,0),
	MOTHER_NAME VARCHAR(16777216),
	FATHER_NAME VARCHAR(16777216),
	BIRTH_STATE VARCHAR(16777216),
	BIRTH_CITY VARCHAR(16777216),
	LEGACY_PERSON_ID NUMBER(38,0),
	MARITAL_STATUS_OPTION_ID NUMBER(38,0),
	UPDATED_AT TIMESTAMP_NTZ(9)
);
