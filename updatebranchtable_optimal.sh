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