sqoop job \
--meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop \
--delete updatetimetable_optimal
sqoop job \
--meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop \
--create updatetimetable_optimal \
-- import \
--connect jdbc:mysql://localhost/cdw_sapp \
--driver com.mysql.jdbc.Driver \
-m 1 \
--query \
"select  TRANSACTION_ID, \
CONCAT(YEAR, LPAD(MONTH, 2,'0'),  LPAD(DAY, 2,'0')) as TIMEID, DAY, MONTH, \
CASE \
WHEN (MONTH <= 3) THEN 'FIRST' \
WHEN (MONTH <= 6) THEN 'SECOND' \
WHEN (MONTH <= 9) THEN 'THIRD' \
WHEN (MONTH <= 12) THEN 'FOURTH' \
END AS 'QUARTER', \
YEAR, LAST_UPDATED FROM cdw_sapp.cdw_sapp_creditcard WHERE \$CONDITIONS" \
--target-dir /Credit_Card_System/CDW_SAPP_D_TIME/ \
--append \
--incremental lastmodified \
--check-column LAST_UPDATED \
--last-value '0000-00-00 00:00:00' \
--fields-terminated-by '\t'