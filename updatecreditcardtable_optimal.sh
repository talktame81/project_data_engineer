sqoop job \
--meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop \
--delete updatecreditcardtable_optimal
sqoop job \
--meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop \
--create  updatecreditcardtable_optimal \
-- import \
--connect jdbc:mysql://localhost/cdw_sapp \
--driver com.mysql.jdbc.Driver \
-m 1 \
--query \
"SELECT \
CREDIT_CARD_NO AS CUST_CC_NO, \
CONCAT (YEAR, IF(MONTH<=9, CONCAT (0, MONTH), MONTH), IF(DAY<=9, CONCAT (0, DAY), DAY)) AS TIMEID, \
CUST_SSN, \
BRANCH_CODE, \
TRANSACTION_TYPE, \
TRANSACTION_VALUE, \
TRANSACTION_ID, \
LAST_UPDATED \
FROM \
cdw_sapp.cdw_sapp_creditcard \
WHERE \$CONDITIONS" \
--target-dir /Credit_Card_System/CDW_SAPP_F_CREDIT_CARD/ \
--append \
--incremental lastmodified \
--check-column LAST_UPDATED \
--last-value '0000-00-00 00:00:00' \
--fields-terminated-by '\t'