USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[UT_GetPDErrorInfo]    Script Date: 12/4/2017 8:27:46 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[UT_GetPDErrorInfo]
AS
    SET NOCOUNT ON

    DECLARE @ID VARCHAR(10)
    DECLARE @NAME_TX NVARCHAR(100)
    DECLARE @UPDATE_DT NVARCHAR(25)
    DECLARE @LAST_RUN_DT NVARCHAR(25)
    DECLARE @STATUS_CD NVARCHAR(10)
    DECLARE @PROCESS_TYPE_CD NVARCHAR(100)
    DECLARE @body AS VARCHAR(6000) 

    SET @body = ''

    CREATE TABLE #tmpPDInfo
        (
          ID NVARCHAR(100) ,
          NAME_TX NVARCHAR(100) ,
          UPDATE_DT NVARCHAR(25) ,
          LAST_RUN_DT NVARCHAR(25) ,
          STATUS_CD NVARCHAR(10) ,
          PROCESS_TYPE_CD NVARCHAR(100)
        )

    INSERT  INTO #tmpPDInfo
            ( ID ,
              NAME_TX ,
              UPDATE_DT ,
              LAST_RUN_DT ,
              STATUS_CD ,
              PROCESS_TYPE_CD
            )
            SELECT  pd.ID ,
                    pd.NAME_TX ,
                    pd.UPDATE_DT ,
                    pd.LAST_RUN_DT ,
                    pd.STATUS_CD ,
                    pd.PROCESS_TYPE_CD
            FROM    dbo.PROCESS_DEFINITION pd
            WHERE   pd.STATUS_CD = 'Error' AND PROCESS_TYPE_CD NOT IN ('BILLING', 'CYCLEPRC', 'GOODTHRUDT')
                                                
    DECLARE CursorVar CURSOR READ_ONLY
    FOR
        SELECT  ID ,
                NAME_TX ,
                UPDATE_DT ,
                LAST_RUN_DT ,
                STATUS_CD ,
                PROCESS_TYPE_CD
        FROM    #tmpPDInfo

    OPEN CursorVar
    FETCH CursorVar INTO @ID, @NAME_TX, @UPDATE_DT, @LAST_RUN_DT, @STATUS_CD,
        @PROCESS_TYPE_CD

    WHILE @@Fetch_Status = 0
        BEGIN
            SET @body = @body + @ID + ',  ' + @NAME_TX + ',  ' + @UPDATE_DT
                + ',  ' + @LAST_RUN_DT + ',  ' + @STATUS_CD + ',  '
                + @PROCESS_TYPE_CD + CHAR(13) + CHAR(10)

            FETCH NEXT FROM CursorVar INTO @ID, @NAME_TX, @UPDATE_DT,
                @LAST_RUN_DT, @STATUS_CD, @PROCESS_TYPE_CD
        END
    CLOSE CursorVar
    DEALLOCATE CursorVar

    IF @body <> ''
        BEGIN
            SET @body = 'Unitrac Process Definitions In Error Status:   (Process Definition ID, Process Name, Update Dt, Last Run Dt, Process Type Code)
                                             ' + CHAR(13) + CHAR(10) + @body 
            EXEC UT_GetPDErrorInfo_Email @Body	
--Print @body
        END

    DROP TABLE #tmpPDInfo


GO

