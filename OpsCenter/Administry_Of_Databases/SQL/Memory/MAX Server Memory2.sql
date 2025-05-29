/*

This script is used to calculate the recommended MAX Server Memory for SQL Server

It needs to be run on the server to read the physical memory of the box and they generates the recommended size.

*/

DECLARE @PhyMemoryMB BIGINT,

    @PhyMemoryGB INT,

    @CurrMaxMemMB BIGINT,

    @RecomenedMemAllocatedOSGB INT =4 ,

    @RecomendedMaxMemMB BIGINT,
@SQLCMD nvarchar(255),
@SQLCMD2 nvarchar(255),

@DryRun BIT = 1,
@Revert BIT = 1,
@Verbose BIT = 0

/* Get Physical Memory */

SELECT  @PhyMemoryMB=ROUND(total_physical_memory_kb/1024.0, 0),

        @PhyMemoryGB=ROUND(((total_physical_memory_kb/1024.0)/1024.0), 0)

FROM    sys.dm_os_sys_memory

/* Get Current MaxMemory */

SELECT  @CurrMaxMemMB=CAST(value_in_use AS INT)

FROM    sys.configurations

WHERE   name='max server memory (MB)'

/* Calculate Recomended Memory for OS, unless OS memory is less than 4GB */

IF @PhyMemoryGB<4

    BEGIN

        SET @RecomendedMaxMemMB = (@PhyMemoryGB * .75) * 1024.0;

    END

ELSE

    IF @PhyMemoryGB BETWEEN 4 AND 16

        BEGIN

            SET @RecomenedMemAllocatedOSGB=@RecomenedMemAllocatedOSGB

        END

    ELSE

        IF @PhyMemoryGB BETWEEN 17 AND 64

            BEGIN

                SET @RecomenedMemAllocatedOSGB=@RecomenedMemAllocatedOSGB

            END

        ELSE

            IF @PhyMemoryGB>64

                BEGIN

                    SET @RecomenedMemAllocatedOSGB=@RecomenedMemAllocatedOSGB

                END

/* Calculate Recomended Max Memory OS memory is greater than 4GB*/

IF @PhyMemoryGB > 4

BEGIN

    SET @RecomendedMaxMemMB=(@PhyMemoryGB-@RecomenedMemAllocatedOSGB)*1024.0

END

SELECT  @SQLCMD = 

'EXEC sp_configure ''show advanced options'', 1

RECONFIGURE

EXEC sp_configure ''max server memory'', '+CAST(@RecomendedMaxMemMB AS VARCHAR(25))+'

RECONFIGURE

EXEC sp_configure ''show advanced options'', 0

RECONFIGURE'
SELECT @SQLCMD2 = 

'EXEC sp_configure ''show advanced options'', 1

RECONFIGURE

EXEC sp_configure ''max server memory'', '+CAST(@CurrMaxMemMB AS VARCHAR(25))+'

RECONFIGURE

EXEC sp_configure ''show advanced options'', 0

RECONFIGURE

' 



IF @Verbose = 0

BEGIN 
SELECT 

        @PhyMemoryGB AS PhyMemoryGB,

 

        @CurrMaxMemMB/1024 AS CurrMaxMemGB,

       (@PhyMemoryMB -  @CurrMaxMemMB)/1024 AS [ActualMemAllocatedOSGB],

        @RecomenedMemAllocatedOSGB AS RecomenedMemAllocatedOSGB,



        @RecomendedMaxMemMB/1024 AS RecomendedMaxMemGB
END 



IF @DryRun = 0 
BEGIN 
EXEC ( @SQLCMD) 
END
ELSE IF @DryRun = 0 AND @Revert = 0
BEGIN 
EXEC ( @SQLCMD2) 
END
ELSE
BEGIN 
PRINT ( @SQLCMD) 
END
