USE SCHEMA {{ schema_name }};

create or replace TABLE BRANDS_9 (
	ID VARCHAR(16777216) NOT NULL,
	IS_ACTIVE BOOLEAN NOT NULL,
	CREATE_DATE TIMESTAMP_NTZ(9) NOT NULL,
	NAME VARCHAR(16777216) NOT NULL,
	MANUFACTURER_NAME VARCHAR(16777216)
);
