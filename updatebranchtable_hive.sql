CREATE DATABASE IF NOT EXISTS CDW_SAPP; -- Only gets created the first time the script runs
DROP TABLE IF EXISTS CDW_SAPP.TEMP_CDW_SAPP_D_BRANCH;
CREATE EXTERNAL TABLE IF NOT EXISTS CDW_SAPP.TEMP_CDW_SAPP_D_BRANCH( -- Only gets created the first time the script runs
	BRANCH_CODE INT,
	BRANCH_NAME VARCHAR(25),
	BRANCH_STREET VARCHAR(30),
	BRANCH_CITY VARCHAR(30),
	BRANCH_STATE VARCHAR(30),
	BRANCH_ZIP VARCHAR(5),
	BRANCH_PHONE VARCHAR(13),
	LAST_UPDATED TIMESTAMP
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n'
LOCATION "/Credit_Card_System/CDW_SAPP_D_BRANCH/";

CREATE TABLE IF NOT EXISTS CDW_SAPP.CDW_SAPP_D_BRANCH ( -- Only gets created the first time the script runs
	BRANCH_CODE INT,
	BRANCH_NAME VARCHAR(25),
	BRANCH_STREET VARCHAR(30),
	BRANCH_CITY VARCHAR(30),
	BRANCH_ZIP VARCHAR(5),
	BRANCH_PHONE VARCHAR(13),
	LAST_UPDATED TIMESTAMP
)
PARTITIONED BY (BRANCH_STATE VARCHAR(30))
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode = nonstrict;
INSERT INTO TABLE CDW_SAPP.CDW_SAPP_D_BRANCH PARTITION (BRANCH_STATE)

SELECT
	BRANCH_CODE,
	BRANCH_NAME,
	BRANCH_STREET,
	BRANCH_CITY,
	BRANCH_ZIP,
	BRANCH_PHONE,
	LAST_UPDATED,
	BRANCH_STATE
FROM 
	CDW_SAPP.TEMP_CDW_SAPP_D_BRANCH;
DROP TABLE CDW_SAPP.TEMP_CDW_SAPP_D_BRANCH;