DECLARE @GroupName NVARCHAR(50)=''
DECLARE @AccountName NVARCHAR(50)=''
DECLARE @BEGINDATE DATETIME = '2024-05-15'
DECLARE @ENDDATE DATETIME = Getdate()

IF (SELECT Count(accountName)
    FROM   DBA.info.GroupMembership
    WHERE  AccountName = MappedLoginName
           AND AccountName = 'Cannot interogate') >= 5
  BEGIN
      PRINT 'FAIL: We cannot interogate most likely due to the fact it is a RDS or Azure instance'
  END
ELSE
  BEGIN
      IF @AccountName <> ''
        BEGIN
            SELECT *
            FROM   DBA.info.GroupMembership
            WHERE  AccountName = MappedLoginName
                   AND AccountName LIKE '%' + @AccountName + '%'
            ORDER  BY HarvestDate DESC
        END
      ELSE IF @GroupName <> ''
        BEGIN
            SELECT *
            FROM   DBA.info.GroupMembership
            WHERE  AccountName = MappedLoginName
                   AND GroupName LIKE '%' + @GroupName + '%'
            ORDER  BY HarvestDate DESC
        END
      ELSE IF @BEGINDATE <> ''
        BEGIN
            SELECT *
            FROM   DBA.info.GroupMembership
            WHERE  AccountName = MappedLoginName
                   AND DiscoverDate BETWEEN @BEGINDATE AND @ENDDATE
            ORDER  BY DiscoverDate DESC
        END
      ELSE
        BEGIN
            SELECT *
            FROM   DBA.info.GroupMembership
            WHERE  AccountName = MappedLoginName
            ORDER  BY HarvestDate DESC
        END
  END 
