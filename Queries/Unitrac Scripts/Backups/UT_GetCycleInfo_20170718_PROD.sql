USE [UniTrac]
GO
/****** Object:  StoredProcedure [dbo].[UT_GetCycleInfo]    Script Date: 7/18/2017 10:14:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[UT_GetCycleInfo]
AS 
    SET NOCOUNT ON

    DECLARE @ID VARCHAR(10)
    DECLARE @NAME_TX NVARCHAR(100)
    DECLARE @START_DT NVARCHAR(25)
    DECLARE @UPDATE_DT NVARCHAR(25)
    DECLARE @STATUS_CD NVARCHAR(10)
    DECLARE @MSG_TX NVARCHAR(4000)
    DECLARE @body AS VARCHAR(6000) 

    SET @body = ''

    CREATE TABLE #tmpCycleInfo
        (
          ID NVARCHAR(100) ,
          NAME_TX NVARCHAR(100) ,
          START_DT NVARCHAR(25) ,
          UPDATE_DT NVARCHAR(25) ,
          STATUS_CD NVARCHAR(10) ,
          MSG_TX NVARCHAR(4000)
        )

    INSERT  INTO #tmpCycleInfo
            ( ID ,
              NAME_TX ,
              START_DT ,
              UPDATE_DT ,
              STATUS_CD ,
              MSG_TX
            )
            SELECT  pd.ID ,
                    pd.NAME_TX ,
                    pl.START_DT ,
                    PL.UPDATE_DT ,
                    pl.STATUS_CD ,
                    pl.MSG_TX
            FROM    PROCESS_LOG pl
                    JOIN PROCESS_DEFINITION pd ON pd.ID = pl.PROCESS_DEFINITION_ID
            WHERE   pl.STATUS_CD = 'InProcess'
                    AND pd.PROCESS_TYPE_CD = 'CYCLEPRC'
                    AND pd.ACTIVE_IN = 'Y'
                    AND pd.EXECUTION_FREQ_CD != 'RUNONCE'
                    AND CAST(pl.CREATE_DT AS DATE) > CAST(GETDATE() - 1 AS DATE)
        
    DECLARE CursorVar CURSOR READ_ONLY
    FOR
        SELECT  ID ,
                NAME_TX ,
                START_DT ,
                UPDATE_DT ,
                STATUS_CD ,
                MSG_TX
        FROM    #tmpCycleInfo

    OPEN CursorVar
    FETCH CursorVar INTO @ID, @NAME_TX, @START_DT, @UPDATE_DT, @STATUS_CD,
        @MSG_TX

    WHILE @@Fetch_Status = 0 
        BEGIN
            SET @body = @body + @ID + ',  ' + @NAME_TX + ',  ' + @START_DT
                + ',  ' + @UPDATE_DT + ',  ' + @STATUS_CD + ',  ' + @MSG_TX
                + CHAR(13) + CHAR(10)

            FETCH NEXT FROM CursorVar INTO @ID, @NAME_TX, @START_DT,
                @UPDATE_DT, @STATUS_CD, @MSG_TX
        END
    CLOSE CursorVar
    DEALLOCATE CursorVar

    IF @body <> '' 
        BEGIN
            SET @body = 'Unitrac Cycle Processes Running At 9 AM:   (Process Definition ID, Process Name, Start Dt, Update Dt, Status, Work Items Processed Count)
                                             ' + CHAR(13) + CHAR(10) + @body 
            EXEC UT_GetCycleInfo_Email @Body	
--Print @body
        END

    DROP TABLE #tmpCycleInfo





