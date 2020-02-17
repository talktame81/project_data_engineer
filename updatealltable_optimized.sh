#cdw_sapp_branch

sqoop job \
--meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop \
--delete updatebranchtable_optimal
sqoop job \
--meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop \
--create updatebranchtable_optimal \
-- import \
--connect jdbc:mysql://localhost/cdw_sapp \
--driver com.mysql.jdbc.Driver \
-m 1 \
--query \
"select \
BRANCH_CODE, \
BRANCH_NAME, \
BRANCH_STREET, \
BRANCH_CITY, \
BRANCH_STATE, \
if (BRANCH_ZIP IS NULL, 999999, BRANCH_ZIP) as BRANCH_ZIP, \
concat ( '(' , left(BRANCH_PHONE,3) , ')' , substring(BRANCH_PHONE,4,3) , '-' , right(BRANCH_PHONE,4) ) as BRANCH_PHONE, \
LAST_UPDATED \
from \
cdw_sapp.cdw_sapp_branch \
where \
\$CONDITIONS" \
--target-dir /Credit_Card_System/CDW_SAPP_D_BRANCH/ \
--append \
--incremental lastmodified \
--check-column LAST_UPDATED \
--last-value '0000-00-00 00:00:00' \
--fields-terminated-by '\t'

#cdw_sapp_creditcard

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

#cdw_sapp_customer

sqoop job \
--meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop \
--delete updatecustomertable_optimal
sqoop job  \
--meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop \
--create updatecustomertable_optimal \
-- import \
--connect jdbc:mysql://localhost/cdw_sapp \
--driver com.mysql.jdbc.Driver \
-m 1 \
--query \
"SELECT \
SSN AS CUST_SSN, \
CONCAT(UPPER(SUBSTRING(FIRST_NAME,1,1)),LOWER(SUBSTRING(FIRST_NAME,2))) AS CUST_F_NAME, \
LOWER(MIDDLE_NAME) AS CUST_M_NAME, \
CONCAT(UPPER(SUBSTRING(LAST_NAME,1,1)),LOWER(SUBSTRING(LAST_NAME,2)))  AS CUST_L_NAME, \
CREDIT_CARD_NO AS CUST_CC_NO, \
CONCAT(STREET_NAME,', ',APT_NO) AS CUST_STREET, \
CUST_CITY, \
CUST_STATE, \
CUST_COUNTRY, \
CUST_ZIP, \
CONCAT (  LEFT(CUST_PHONE,3) , '-' , RIGHT(CUST_PHONE,4) ) AS CUST_PHONE, \
CUST_EMAIL, \
LAST_UPDATED \
FROM \
cdw_sapp.cdw_sapp_customer \
WHERE \$CONDITIONS" \
--target-dir /Credit_Card_System/CDW_SAPP_D_CUSTOMER/ \
--append \
--incremental lastmodified \
--check-column LAST_UPDATED \
--last-value '0000-00-00 00:00:00' \
--fields-terminated-by '\t'

#cdw_sapp_time

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
CONCAT(YEAR, LPAD(MONTH, 2,'0'),  LPAD(DAY, 2,'0')) as TIMEID, \
DAY, \
MONTH, \
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