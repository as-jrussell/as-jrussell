USE CenterPointSecurity

DECLARE @Date_Option INT;
DECLARE @Begin_Date DATETIME;
DECLARE @End_Date DATETIME;
DECLARE @Date_Closed_Begin DATETIME;
DECLARE @Date_Closed_End DATETIME;
DECLARE @Date_Sold_Begin DATETIME;
DECLARE @Date_Sold_End DATETIME;
DECLARE @Date_Received_Begin DATETIME;
DECLARE @Date_Received_End DATETIME;
DECLARE @Date_Entered_Begin DATETIME;
DECLARE @Date_Entered_End DATETIME;
DECLARE @Coverage_Type NVARCHAR(max);
DECLARE @Product_Group NVARCHAR(50);
DECLARE @Relationship_ID_Number INT;
DECLARE @Relationship_Status_Code INT;
DECLARE @Client_ID_Number INT;
DECLARE @Client_Status_Code INT;
DECLARE @Parent_Client_ID_Number INT;
DECLARE @Underwriter_ID_Number INT;
DECLARE @Underwriter_Group NVARCHAR(50);
DECLARE @Representative_ID_Number INT;
DECLARE @Product_ID_Number INT;
DECLARE @Product_Type NVARCHAR(20);
DECLARE @Fiscal_Year INT;
DECLARE @Batch_Number INT;
DECLARE @Region NVARCHAR(50);
DECLARE @State_Code NVARCHAR(50);
DECLARE @Sort_Option NVARCHAR(50);
DECLARE @File_Name NVARCHAR(512);
DECLARE @Input_File_Name NVARCHAR(512);
DECLARE @Representative_Type_ID_Number INT;
DECLARE @Client_Underwriter_ID NVARCHAR(50);
DECLARE @Company_Code NVARCHAR(6);
DECLARE @UDF_Options NVARCHAR(255);
DECLARE @Client_UDF_Options NVARCHAR(255);
DECLARE @Relationship_Division NVARCHAR(5);
DECLARE @Relationship_Department NVARCHAR(5);
DECLARE @Assets_Greater MONEY;
DECLARE @Assets_Less MONEY;
DECLARE @Data_Processor NVARCHAR(50);
DECLARE @Client_Type_ID INT;
DECLARE @Client_Group_ID INT;
DECLARE @VUT_Lender_ID NVARCHAR(10);
DECLARE @CWS_Status INT;
DECLARE @CWS_Contract_Status INT;
DECLARE @CWS_Initiator NVARCHAR(50);
DECLARE @CWS_Level_1 NVARCHAR(50);
DECLARE @CWS_Level_2 NVARCHAR(50);
DECLARE @CWS_Level_3 NVARCHAR(50);
DECLARE @CWS_Level_4 NVARCHAR(50);
DECLARE @CWS_Level_5 NVARCHAR(50);
DECLARE @CWS_Sales INT;
DECLARE @CWS_CDM INT;
DECLARE @CS_Month_End_UID INT;
DECLARE @File_Format NVARCHAR(50);
DECLARE @Generic_Integer_1 BIGINT;
DECLARE @Generic_Integer_2 BIGINT;
DECLARE @Generic_Integer_3 BIGINT;
DECLARE @Generic_Integer_4 BIGINT;
DECLARE @Generic_Money_1 MONEY;
DECLARE @Generic_Money_2 MONEY;
DECLARE @Generic_Money_3 MONEY;
DECLARE @Generic_Money_4 MONEY;
DECLARE @Generic_String_1 NVARCHAR(max);
DECLARE @Generic_String_2 NVARCHAR(max);
DECLARE @Generic_String_3 NVARCHAR(max);
DECLARE @Generic_String_4 NVARCHAR(max);
DECLARE @Generic_Date_1 DATETIME;
DECLARE @Generic_Date_2 DATETIME;
DECLARE @Generic_bit_1 BIT;
DECLARE @Generic_bit_2 BIT;
DECLARE @Month_Only SMALLINT;
DECLARE @Year_Only SMALLINT;
DECLARE @Generic_ddl_1 NVARCHAR(max);
DECLARE @Generic_ddl_2 NVARCHAR(max);
DECLARE @Generic_ddl_3 NVARCHAR(max);
DECLARE @Generic_ddl_4 NVARCHAR(max);
DECLARE @Generic_lbx_1 NVARCHAR(max);
DECLARE @Generic_lbx_2 NVARCHAR(max);
DECLARE @Generic_lbx_3 NVARCHAR(max);
DECLARE @Generic_lbx_4 NVARCHAR(max);
DECLARE @Generic_cbl_1 NVARCHAR(max);
DECLARE @Generic_cbl_2 NVARCHAR(max);
DECLARE @Generic_cbl_3 NVARCHAR(max);
DECLARE @Generic_cbl_4 NVARCHAR(max);
DECLARE @Generic_rbl_1 NVARCHAR(max);
DECLARE @Generic_rbl_2 NVARCHAR(max);
DECLARE @Generic_rbl_3 NVARCHAR(max);
DECLARE @Generic_rbl_4 NVARCHAR(max);

SET @Date_Option = 0;
SET @Begin_Date = '1/1/1900 12:00:00 AM';
SET @End_Date = '1/1/1900 12:00:00 AM';
SET @Date_Closed_Begin = '1/1/1900 12:00:00 AM';
SET @Date_Closed_End = '1/1/1900 12:00:00 AM';
SET @Date_Sold_Begin = '1/1/1900 12:00:00 AM';
SET @Date_Sold_End = '1/1/1900 12:00:00 AM';
SET @Date_Received_Begin = '1/1/1900 12:00:00 AM';
SET @Date_Received_End = '1/1/1900 12:00:00 AM';
SET @Date_Entered_Begin = '1/1/1900 12:00:00 AM';
SET @Date_Entered_End = '1/1/1900 12:00:00 AM';
SET @Coverage_Type = '';
SET @Product_Group = '';
SET @Relationship_ID_Number = 0;
SET @Relationship_Status_Code = 1;
SET @Client_ID_Number = 0;
SET @Client_Status_Code = 1;
SET @Parent_Client_ID_Number = 0;
SET @Underwriter_ID_Number = 0;
SET @Underwriter_Group = '';
SET @Representative_ID_Number = 0;
SET @Product_ID_Number = 0;
SET @Product_Type = '';
SET @Fiscal_Year = 0;
SET @Batch_Number = 0;
SET @Region = '';
SET @State_Code = '';
SET @Sort_Option = 'N/A';
SET @File_Name = '\\as.local\users\CarmelUsers\ldillow\CenterPoint LastLogin08-29-2022 08-00-02.xlsx';
SET @Input_File_Name = '\\as.local\users\CarmelUsers\ldillow\';
SET @Representative_Type_ID_Number= 0;
SET @Client_Underwriter_ID = '';
SET @Company_Code = '';
SET @UDF_Options = '2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2';
SET @Client_UDF_Options = '2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2';
SET @Relationship_Division = '';
SET @Relationship_Department = '';
SET @Assets_Greater = 0.0000;
SET @Assets_Less = 0.0000;
SET @Data_Processor = '';
SET @Client_Type_ID= 0;
SET @Client_Group_ID= 0;
SET @VUT_Lender_ID = '';
SET @CWS_Status = 0;
SET @CWS_Contract_Status = 0;
SET @CWS_Initiator = '';
SET @CWS_Level_1 = '';
SET @CWS_Level_2 = '';
SET @CWS_Level_3 = '';
SET @CWS_Level_4 = '';
SET @CWS_Level_5 = '';
SET @CWS_Sales = '0';
SET @CWS_CDM = '0';
SET @CS_Month_End_UID = -999999999;
SET @File_Format = 'xlsx';
SET @Generic_Integer_1 = '-9223372036854775808';
SET @Generic_Integer_2 = '-9223372036854775808';
SET @Generic_Integer_3 = '-9223372036854775808';
SET @Generic_Integer_4 = '-9223372036854775808';
SET @Generic_Money_1 = -922337203685477.5808;
SET @Generic_Money_2 = -922337203685477.5808;
SET @Generic_Money_3 = -922337203685477.5808;
SET @Generic_Money_4 = -922337203685477.5808;
SET @Generic_String_1 = '';
SET @Generic_String_2 = '';
SET @Generic_String_3 = '';
SET @Generic_String_4 = '';
SET @Generic_Date_1 = '1/1/1900 12:00:00 AM';
SET @Generic_Date_2 = '1/1/1900 12:00:00 AM';
SET @Generic_bit_1 = 'False';
SET @Generic_bit_2 = 'False';
SET @Month_Only = 0;
SET @Year_Only = 0;
SET @Generic_ddl_1 = '';
SET @Generic_ddl_2 = '';
SET @Generic_ddl_3 = '';
SET @Generic_ddl_4 = '';
SET @Generic_lbx_1 = '';
SET @Generic_lbx_2 = '';
SET @Generic_lbx_3 = '';
SET @Generic_lbx_4 = '';
SET @Generic_cbl_1 = '';
SET @Generic_cbl_2 = '';
SET @Generic_cbl_3 = '';
SET @Generic_cbl_4 = '';
SET @Generic_rbl_1 = '';
SET @Generic_rbl_2 = '';
SET @Generic_rbl_3 = '';
SET @Generic_rbl_4 = '';

SELECT DISTINCT up.FirstName,
                up.LastName,
                up.UserName,
                up.ClientId,
                CASE
                  WHEN A.UserId IS NULL THEN 0
                  ELSE 1
                END [Report Notifications],
                CASE
                  WHEN B.UserId IS NULL THEN 0
                  ELSE 1
                END [CPI Billing],
                CASE
                  WHEN C.UserId IS NULL THEN 0
                  ELSE 1
                END [Recovery User],
                CASE
                  WHEN D.UserId IS NULL THEN 0
                  ELSE 1
                END [System Admin],
                CASE
                  WHEN E.UserId IS NULL THEN 0
                  ELSE 1
                END [Reports User],
                CASE
                  WHEN F.UserId IS NULL THEN 0
                  ELSE 1
                END [Claim User],
                CASE
                  WHEN G.UserId IS NULL THEN 0
                  ELSE 1
                END [Verify Data],
                CASE
                  WHEN H.UserId IS NULL THEN 0
                  ELSE 1
                END [View Loans],
                CASE
                  WHEN I.UserId IS NULL THEN 0
                  ELSE 1
                END [Edit Loans],
                CASE
                  WHEN J.UserId IS NULL THEN 0
                  ELSE 1
                END [Manual Updates],
                CASE
                  WHEN K.UserId IS NULL THEN 0
                  ELSE 1
                END [Application Manager (Internal)],
                CASE
                  WHEN L.UserId IS NULL THEN 0
                  ELSE 1
                END [UX Test],
                CASE
                  WHEN M.UserId IS NULL THEN 0
                  ELSE 1
                END [GAP Enrollment],
                CASE
                  WHEN up.Internal = 1 THEN 'Yes'
                  ELSE 'No'
                END [Allied User],
                up.OptIn,
                up.LastLoginDate,
                CASE
                  WHEN s.[User] IS NOT NULL THEN 'Yes'
                  ELSE 'No'
                END [Opted In Before]
FROM   [CenterpointSecurity].[dbo].CP_UserProfile up
       LEFT OUTER JOIN [CenterpointSecurity].[dbo].AspNetUserRoles A
                    ON a.UserId = up.UserId
                       AND a.RoleId = (SELECT id
                                       FROM   [CenterpointSecurity].[dbo].AspNetRoles
                                       WHERE  Name = 'Report Notifications')
       LEFT OUTER JOIN [CenterpointSecurity].[dbo].AspNetUserRoles B
                    ON b.UserId = up.UserId
                       AND b.RoleId = (SELECT id
                                       FROM   [CenterpointSecurity].[dbo].AspNetRoles
                                       WHERE  Name = 'CPI Billing')
       LEFT OUTER JOIN [CenterpointSecurity].[dbo].AspNetUserRoles C
                    ON c.UserId = up.UserId
                       AND c.RoleId = (SELECT id
                                       FROM   [CenterpointSecurity].[dbo].AspNetRoles
                                       WHERE  Name = 'Recovery User')
       LEFT OUTER JOIN [CenterpointSecurity].[dbo].AspNetUserRoles D
                    ON d.UserId = up.UserId
                       AND d.RoleId = (SELECT id
                                       FROM   [CenterpointSecurity].[dbo].AspNetRoles
                                       WHERE  Name = 'System Admin')
       LEFT OUTER JOIN [CenterpointSecurity].[dbo].AspNetUserRoles E
                    ON e.UserId = up.UserId
                       AND e.RoleId = (SELECT id
                                       FROM   [CenterpointSecurity].[dbo].AspNetRoles
                                       WHERE  Name = 'Reports User')
       LEFT OUTER JOIN [CenterpointSecurity].[dbo].AspNetUserRoles F
                    ON f.UserId = up.UserId
                       AND f.RoleId = (SELECT id
                                       FROM   [CenterpointSecurity].[dbo].AspNetRoles
                                       WHERE  Name = 'Claim User')
       LEFT OUTER JOIN [CenterpointSecurity].[dbo].AspNetUserRoles G
                    ON g.UserId = up.UserId
                       AND g.RoleId = (SELECT id
                                       FROM   [CenterpointSecurity].[dbo].AspNetRoles
                                       WHERE  Name = 'Verify Data')
       LEFT OUTER JOIN [CenterpointSecurity].[dbo].AspNetUserRoles H
                    ON h.UserId = up.UserId
                       AND h.RoleId = (SELECT id
                                       FROM   [CenterpointSecurity].[dbo].AspNetRoles
                                       WHERE  Name = 'View Loans')
       LEFT OUTER JOIN [CenterpointSecurity].[dbo].AspNetUserRoles I
                    ON i.UserId = up.UserId
                       AND i.RoleId = (SELECT id
                                       FROM   [CenterpointSecurity].[dbo].AspNetRoles
                                       WHERE  Name = 'Edit Loans')
       LEFT OUTER JOIN [CenterpointSecurity].[dbo].AspNetUserRoles J
                    ON j.UserId = up.UserId
                       AND j.RoleId = (SELECT id
                                       FROM   [CenterpointSecurity].[dbo].AspNetRoles
                                       WHERE  Name = 'Manual Updates')
       LEFT OUTER JOIN [CenterpointSecurity].[dbo].AspNetUserRoles K
                    ON k.UserId = up.UserId
                       AND k.RoleId = (SELECT id
                                       FROM   [CenterpointSecurity].[dbo].AspNetRoles
                                       WHERE  Name = 'Application Manager (Internal)')
       LEFT OUTER JOIN [CenterpointSecurity].[dbo].AspNetUserRoles L
                    ON l.UserId = up.UserId
                       AND l.RoleId = (SELECT id
                                       FROM   [CenterpointSecurity].[dbo].AspNetRoles
                                       WHERE  Name = 'UX Test')
       LEFT OUTER JOIN [CenterpointSecurity].[dbo].AspNetUserRoles M
                    ON m.UserId = up.UserId
                       AND m.RoleId = (SELECT id
                                       FROM   [CenterpointSecurity].[dbo].AspNetRoles
                                       WHERE  Name = 'GAP Enrollment')
       LEFT OUTER JOIN [CenterpointSecurity].[dbo].AspNetUserRoles N
                    ON n.UserId = up.UserId
                       AND n.RoleId = (SELECT id
                                       FROM   [CenterpointSecurity].[dbo].AspNetRoles
                                       WHERE  Name = 'Claim User (Gap)')
       LEFT JOIN [SysLog].[dbo].[SysLog] S
              ON s.[User] = up.UserName
                 AND s.PROCID = 331
WHERE  username IS NOT NULL
       AND username != ''
ORDER  BY username 
