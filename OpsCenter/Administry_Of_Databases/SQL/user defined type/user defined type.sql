USE [TargetDatabase];

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @typedefinition nvarchar(max),@typeschema sysname, @typename sysname, @WhatIF bit = 1, @debug bit = 0;

SELECT @typeschema = 'PoLP', @typename = 'ParameterValueToJSON';

/* set type definition */ 
SELECT @typedefinition = '
CREATE TYPE '+QUOTENAME(@typeschema)+'.'+QUOTENAME(@typename)+' AS TABLE ( [column] [type] );'

DECLARE @i int, @max int, @sql nvarchar(max);
DECLARE @ModuleObjectID int, @ModuleSchema nvarchar(256), @ModuleName nvarchar(256), @ModuleType char(2);

CREATE TABLE #ModulesToRecreate (
    id int identity(1,1) not null primary key clustered,
    ModuleObjectID int not null,
    ModuleSchema nvarchar(256) not null,
    ModuleName nvarchar(256) not null,
    ModuleType char(2) not null,
    ModuleDefinition nvarchar(max) )

/*
Drop and re-create all modules that reference this particular type

This MUST be done within a transaction to prevent failure. By wrapping
this in an explicit transaction, it will block execution for the duration
of the transaction. If we simply drop then add, there is potential for
code to try to execute the procedure, it not be there, and the code fail.

*/

INSERT INTO #ModulesToRecreate (ModuleObjectID, ModuleSchema, ModuleName, ModuleType, ModuleDefinition)
SELECT  o.object_id, s.name, o.name, o.type, OBJECT_DEFINITION(o.object_id)
FROM sys.sql_expression_dependencies d
    JOIN sys.objects o ON o.object_id = d.referencing_id
    JOIN sys.schemas s on o.schema_id = s.schema_id
    JOIN sys.types t on t.user_type_id = d.referenced_id
    JOIN sys.schemas s_t on t.schema_id = s_t.schema_id
WHERE s_t.name = 'PoLP' AND t.name = 'ParameterValueToJSON'

SELECT @i = 1, @max = MAX(id) FROM #ModulesToRecreate

BEGIN TRY

    BEGIN TRANSACTION
    /*drop all of the objects*/
    WHILE @i <= @max
    BEGIN
        
        SELECT @ModuleSchema = ModuleSchema, @ModuleName = ModuleName, @ModuleType = ModuleType
        FROM #ModulesToRecreate WHERE id = @i

        SELECT @sql = 'DROP '
            + CASE 
                WHEN @ModuleType IN ('F', 'IF', 'TF', 'FS', 'FT', 'FN') THEN 'FUNCTION '
                WHEN @ModuleType IN ('P', 'PC') THEN 'PROCEDURE '
            END + QUOTENAME(@ModuleSchema)+'.'+QUOTENAME(@ModuleName)+';';
            
        IF( @debug = 1 )
        BEGIN
            PRINT @sql;
        END

        IF( @WhatIF = 1 )
        BEGIN
            EXEC(@sql);
        END 

        SELECT @i = @i + 1;

    END
        
    /*Drop and Re-create type*/
    IF EXISTS (SELECT * FROM sys.types t join sys.schemas s on t.schema_id = s.schema_id
    where s.name = @typeschema and t.name = @typename)
    BEGIN
        SELECT @sql = 'DROP TYPE '+QUOTENAME(@typeschema)+'.'+QUOTENAME(@typename)+';';

        IF( @debug = 1 ) PRINT @sql;

        IF( @WhatIF = 1 ) EXEC(@sql);
    END

    IF( @debug = 1 )
    BEGIN
        PRINT @typedefinition;
    END

    IF( @WhatIF = 1 )
    BEGIN
        EXEC(@typedefinition);
    END 

    /*ReCreate all of the objects*/
    SELECT @i = 1
    WHILE @i <= @max
    BEGIN
        
        SELECT @ModuleObjectID = ModuleObjectID, @sql = ModuleDefinition
        FROM #ModulesToRecreate WHERE id = @i
            
        IF( @debug = 1 ) PRINT @sql;

        IF( @WhatIF = 1 ) EXEC(@sql);   

        SELECT @i = @i + 1;
    END

    COMMIT

    DROP TABLE #ModulesToRecreate

END TRY
BEGIN CATCH
            
            
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    DROP TABLE #ModulesToRecreate

    DECLARE @ErrorMessage NVARCHAR(4000),
        @ErrorNumber INT,
        @ErrorSeverity INT,
        @ErrorState INT,
        @ErrorLine INT,
        @ErrorProcedure NVARCHAR(200);

    /*Assign variables to error-handling functions that capture information for RAISERROR.*/
    SELECT  @ErrorNumber=ERROR_NUMBER(),
            @ErrorSeverity=ERROR_SEVERITY(),
            @ErrorState=ERROR_STATE(),
            @ErrorLine=ERROR_LINE(),
            @ErrorProcedure=ISNULL(ERROR_PROCEDURE(), '-');

    /*Build the message string that will contain original error information.*/
    SELECT  @ErrorMessage=N'Error %d, Level %d, State %d, Procedure %s, Line %d, '+'Message: '+ERROR_MESSAGE();


    /*Raise an error: msg_str parameter of RAISERROR will contain the original error information.*/
    RAISERROR(
        @ErrorMessage, 
        @ErrorSeverity, 
        1,               
        @ErrorNumber,
        @ErrorSeverity,
        @ErrorState,
        @ErrorProcedure,
        @ErrorLine
    );


END CATCH

GO