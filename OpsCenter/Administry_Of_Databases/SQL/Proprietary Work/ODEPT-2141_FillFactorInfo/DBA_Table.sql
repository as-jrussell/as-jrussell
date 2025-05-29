USE [DBA]
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

/* Creat table if it does not exist */
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[info].[FillFactor]') AND type in (N'U'))
BEGIN
  CREATE TABLE [info].[FillFactor](
           DatabaseName      SYSNAME,
           SchemaName        SYSNAME,
           TableName         SYSNAME,
           IndexName         SYSNAME,
           CurrentFillFactor INT,
		 CurrentTime DATETIME DEFAULT GETDATE(),
        CreationTime DATETIME DEFAULT GETDATE(), 
		[ID]  [BIGINT] IDENTITY(1, 1) NOT FOR REPLICATION NOT NULL
  PRIMARY KEY CLUSTERED(ID) 
   WITH( 
		PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW)
		)
END

