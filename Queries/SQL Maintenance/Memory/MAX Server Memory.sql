/*

This script is used to calculate the recommended MAX Server Memory for SQL Server

It needs to be run on the server to read the physical memory of the box and they generates the recommended size.

*/

DECLARE @PhyMemoryMB BIGINT,

����@PhyMemoryGB INT,

����@CurrMaxMemMB BIGINT,

����@RecomenedMemAllocatedOSGB INT =4 ,

����@RecomendedMaxMemMB BIGINT

/* Get Physical Memory */

SELECT �@PhyMemoryMB=ROUND(total_physical_memory_kb/1024.0, 0),

��������@PhyMemoryGB=ROUND(((total_physical_memory_kb/1024.0)/1024.0), 0)

FROM ���sys.dm_os_sys_memory

/* Get Current MaxMemory */

SELECT �@CurrMaxMemMB=CAST(value_in_use AS INT)

FROM ���sys.configurations

WHERE ��name='max server memory (MB)'

/* Calculate Recomended Memory for OS, unless OS memory is less than 4GB */

IF @PhyMemoryGB<4

����BEGIN

��������SET @RecomendedMaxMemMB = (@PhyMemoryGB * .75) * 1024.0;

����END

ELSE

����IF @PhyMemoryGB BETWEEN 4 AND 16

��������BEGIN

������������SET @RecomenedMemAllocatedOSGB=@RecomenedMemAllocatedOSGB

��������END

����ELSE

��������IF @PhyMemoryGB BETWEEN 17 AND 64

������������BEGIN

����������������SET @RecomenedMemAllocatedOSGB=@RecomenedMemAllocatedOSGB

������������END

��������ELSE

������������IF @PhyMemoryGB>64

����������������BEGIN

��������������������SET @RecomenedMemAllocatedOSGB=@RecomenedMemAllocatedOSGB

����������������END

/* Calculate Recomended Max Memory OS memory is greater than 4GB*/

IF @PhyMemoryGB > 4

BEGIN

����SET @RecomendedMaxMemMB=(@PhyMemoryGB-@RecomenedMemAllocatedOSGB)*1024.0

END

SELECT --�@PhyMemoryMB AS PhyMemoryMB,

��������@PhyMemoryGB AS PhyMemoryGB,

�����--���@CurrMaxMemMB AS CurrMaxMemMB,

���--�����@CurrMaxMemMB/1024 AS CurrMaxMemGB,

�      (@PhyMemoryMB - �@CurrMaxMemMB)/1024 AS [ActualMemAllocatedOSGB],

������� @RecomenedMemAllocatedOSGB AS RecomenedMemAllocatedOSGB,

������--�@RecomendedMaxMemMB AS RecomendedMaxMemMB,

��������@RecomendedMaxMemMB/1024 AS RecomendedMaxMemGB,

'EXEC sp_configure ''show advanced options'', 1

RECONFIGURE

EXEC sp_configure ''max server memory'', '+CAST(@RecomendedMaxMemMB AS VARCHAR(25))+'

RECONFIGURE

EXEC sp_configure ''show advanced options'', 0

RECONFIGURE' AS SQLCodeSnippet_New,

'EXEC sp_configure ''show advanced options'', 1

RECONFIGURE

EXEC sp_configure ''max server memory'', '+CAST(@CurrMaxMemMB AS VARCHAR(25))+'

RECONFIGURE

EXEC sp_configure ''show advanced options'', 0

RECONFIGURE

' AS SQLCodeSnippet_Revert




