USE UniTrac


 SELECT SF.PURGE_DT, SC.PURGE_DT, SG.PURGE_DT, U.PURGE_DT, U.USER_NAME_TX, U.FAMILY_NAME_TX, U.GIVEN_NAME_TX, * FROM dbo.SECURITY_FUNCTION SF
 INNER JOIN dbo.SECURITY_CONTAINER SC ON sc.SECURITY_FUNC_ID = sf.ID
 INNER JOIN dbo.SECURITY_GROUP SG ON SG.ID = sc.SECURITY_GRP_ID
 LEFT JOIN dbo.USERS U ON U.ID = SC.USER_ID --AND SC.USER_ID IS NOT NULL 

 SELECT * FROM dbo.USERS
 WHERE USER_NAME_TX = ''



 UPDATE dbo.USER_WORK_QUEUE_RELATE
 SET PURGE_DT = NULL, LOCK_ID = LOCK_ID+1, UPDATE_DT = GETDATE()
-- SELECT * FROM dbo.USER_WORK_QUEUE_RELATE
 WHERE PURGE_DT >= '2016-09-07 '


  SELECT *
  
  INTO UniTracHDStorage..PRB0040890 FROM dbo.USER_WORK_QUEUE_RELATE
 WHERE PURGE_DT >= '2016-09-07 '