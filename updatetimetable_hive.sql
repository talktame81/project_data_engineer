CREATE DATABASE IF NOT EXISTS CDW_SAPP; -- Only gets created the first time the script runs
DROP TABLE IF EXISTS CDW_SAPP.TEMP_CDW_SAPP_D_TIME;
CREATE EXTERNAL TABLE IF NOT EXISTS CDW_SAPP.TEMP_CDW_SAPP_D_TIME( -- Only gets created the first time the script runs
TRANSACTION_ID INT,
TIMEID VARCHAR(8),
`DAY` INT,
`MONTH` INT,
QUARTER VARCHAR(8),
`YEAR` INT,
LAST_UPDATED TIMESTAMP
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n'
LOCATION "/Credit_Card_System/CDW_SAPP_D_TIME/";

CREATE TABLE IF NOT EXISTS CDW_SAPP.CDW_SAPP_D_TIME ( -- Only gets created the first time the script runs
TRANSACTION_ID INT,
TIMEID VARCHAR(8),
`DAY` INT,
`MONTH` INT,
QUARTER VARCHAR(8),
LAST_UPDATED TIMESTAMP
)
PARTITIONED BY (`YEAR` INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode = nonstrict;
INSERT INTO TABLE CDW_SAPP.CDW_SAPP_D_TIME  PARTITION (`YEAR`)

SELECT TRANSACTION_ID, TIMEID , `DAY`, `MONTH`, QUARTER, LAST_UPDATED, `YEAR`
FROM CDW_SAPP.TEMP_CDW_SAPP_D_TIME;

DROP TABLE CDW_SAPP.TEMP_CDW_SAPP_D_TIME;