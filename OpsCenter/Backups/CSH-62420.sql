/*

Run on infor-sql01

*/
USE InforCRM

GO

BEGIN TRAN;

/* Declare variables */
DECLARE @Ticket NVARCHAR(15) =N'CSH62420_1';
DECLARE @RowsToInsert BIGINT = 0;

/* Step 1 - Calculate rows to be Inserted */
SET @RowsToInsert = 1; -- If the rows are not contained in an existing table

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM   HDTStorage.sys.tables -- Someday this will be the standard 
               WHERE  NAME LIKE @Ticket + '_%'
                      AND type IN ( N'U' ))
  BEGIN
      /* Step 2 - Create EMPTY Storage Table  */
      EXEC('
	  
	  SELECT INF_PRODUCT_HEADERID
                ,CREATEUSER
                ,CREATEDATE
                ,MODIFYUSER
                ,MODIFYDATE
                ,COVERAGETYPE
                ,COVERAGETYPEIDNMB
                ,OPPCOVERAGESTATUS
                ,PIMSCOVERAGESTATUS
                ,ALLIEDDIVISION
                ,ALLIEDGROUP
                ,PRODUCTMANAGERID
                ,TIER
                ,COVERAGEDESCRIPTION
                ,COVERAGESHORTNAME
                ,CLASSIFICATION
                ,CentralSource_Product_Group
                ,CentralSource_Product_Name
                ,Commission_Worksheet_Name
                ,Sales_Dev_Sales_Opps_Reporting
                ,CDM_Products_Of_Focus
                ,Affinion_Suite_Less_ADD
                ,Product_Created_Date
                ,Sales_Specialist
                ,ALIAS
                ,CATEGORY
                ,URLLINK
                ,RENEWALGROUP
                ,CDMOVERRIDE
                ,CRRMOVERRIDE
                ,DESCRIPTION
                ,GPE_SOLUTION_SUITE
                ,PROJECTMANAGERPHONE
                ,SALES_SPECIALISTPHONE
                INTO HDTStorage..'+ @Ticket+'_INF_PRODUCT_HEADER
                FROM sysdba.INF_PRODUCT_HEADER
                WHERE 1=0

				--'); -- WHERE 1=0 creates table without moving data
      /* populate new Storage table from Sources */
      INSERT INTO HDTStorage..CSH62420_1_INF_PRODUCT_HEADER
                  (INF_PRODUCT_HEADERID,
                   CREATEUSER,
                   CREATEDATE,
                   MODIFYUSER,
                   MODIFYDATE,
                   COVERAGETYPE,
                   COVERAGETYPEIDNMB,
                   OPPCOVERAGESTATUS,
                   PIMSCOVERAGESTATUS,
                   ALLIEDDIVISION,
                   ALLIEDGROUP,
                   PRODUCTMANAGERID,
                   TIER,
                   COVERAGEDESCRIPTION,
                   COVERAGESHORTNAME,
                   CLASSIFICATION,
                   CentralSource_Product_Group,
                   CentralSource_Product_Name,
                   Commission_Worksheet_Name,
                   Sales_Dev_Sales_Opps_Reporting,
                   CDM_Products_Of_Focus,
                   Affinion_Suite_Less_ADD,
                   Product_Created_Date,
                   Sales_Specialist,
                   ALIAS,
                   CATEGORY,
                   URLLINK,
                   RENEWALGROUP,
                   CDMOVERRIDE,
                   CRRMOVERRIDE,
                   DESCRIPTION,
                   GPE_SOLUTION_SUITE,
                   PROJECTMANAGERPHONE,
                   SALES_SPECIALISTPHONE)--Specify columns to avoid identity columns
         
	  
VALUES	  (
'Q6UJ9A004LI7',
'PIMS',
'2011-10-05 20:32:43.000',
'SCRIBEU2',
GETDATE(),
'COLL SOFTWARE',
'85',
'Active',
'Active',
'Risk Management',
'Risk Management',
'U6UJ9A0001IK',
'Other',
'Collections Technology',
'Collections Technology',
'Register Lead Risk Management ',
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
'2006-09-12 14:42:14.000',
'',
'Risk Mgmt Products',
NULL,
'https://app.smartsheet.com/b/form/4ba37794c6944bdd89e1978114b0c2a0',
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL);
	

	

      /* Does Storage Table meet expectations */
      IF( @@ROWCOUNT = @RowsToInsert )
        BEGIN
            PRINT 'Storage table meets expections - continue'

            /* Step 3 - Perform table INSERT */
            INSERT INTO InforCRM.sysdba.INF_PRODUCT_HEADER
            SELECT INF_PRODUCT_HEADERID,
                   CREATEUSER,
                   CREATEDATE,
                   MODIFYUSER,
                   MODIFYDATE,
                   COVERAGETYPE,
                   COVERAGETYPEIDNMB,
                   OPPCOVERAGESTATUS,
                   PIMSCOVERAGESTATUS,
                   ALLIEDDIVISION,
                   ALLIEDGROUP,
                   PRODUCTMANAGERID,
                   TIER,
                   COVERAGEDESCRIPTION,
                   COVERAGESHORTNAME,
                   CLASSIFICATION,
                   CentralSource_Product_Group,
                   CentralSource_Product_Name,
                   Commission_Worksheet_Name,
                   Sales_Dev_Sales_Opps_Reporting,
                   CDM_Products_Of_Focus,
                   Affinion_Suite_Less_ADD,
                   Product_Created_Date,
                   Sales_Specialist,
                   ALIAS,
                   CATEGORY,
                   URLLINK,
                   RENEWALGROUP,
                   CDMOVERRIDE,
                   CRRMOVERRIDE,
                   DESCRIPTION,
                   GPE_SOLUTION_SUITE,
                   PROJECTMANAGERPHONE,
                   SALES_SPECIALISTPHONE
            FROM   HDTStorage..CSH62420_1_INF_PRODUCT_HEADER
            WHERE  INF_PRODUCT_HEADERID = 'Q6UJ9A004LI7'

            /* Step 4 - Inspect results - Commit/Rollback */
            IF ( @@ROWCOUNT = @RowsToInsert )
              BEGIN
                  PRINT 'SUCCESS - Performing Commit'

                  COMMIT;
              END
            ELSE
              BEGIN
                  PRINT 'FAILED TO UPDATE - Performing Rollback'

                  ROLLBACK;
              END
        END
      ELSE
        BEGIN
            PRINT 'Storage does not meet expectations - rollback'

            ROLLBACK;
        END
  END
ELSE
  BEGIN
      PRINT 'HD TABLE EXISTS - Stop work'

      COMMIT;
  END




