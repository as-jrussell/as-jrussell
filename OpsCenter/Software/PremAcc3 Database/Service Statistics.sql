USE PremAcc3

SELECT *
FROM service_statistics
WHERE service_name in ('BSSRestService Staging DMZ','InsuranceVerificationStaging') and started >= '2018-04-23 09:42:00'
order by started


/*

In staging, DS-SQLTEST-14, DB PremAcc3 
 QA2 is DS-SQLDEV-14 
 Prod is ALLIED-PIMSDB 

*/