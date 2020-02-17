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