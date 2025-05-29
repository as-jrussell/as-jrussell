use [PerfStats]


SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

/* Creat table if it does not exist */
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'IOerrorUsage' and type = 'U')
BEGIN

CREATE TABLE  [dbo].[IOerrorUsage]

([Database Name] nvarchar(50),
[session_id] INT NULL,
[wait_type] nvarchar(100) NULL,
[start_time] DATETIME NOT NULL,
[last_read] DATETIME NOT NULL, 
[last_write] DATETIME NOT NULL,
[last_execution_time] DATETIME NOT NULL,
[execution_count] INT NULL,
[status] nvarchar(100) NULL, 
[command] nvarchar(100) NULL,
[Login_Name] nvarchar(255) NOT NULL,
[Host_Name] nvarchar(255) NOT NULL,
[Program_Name] nvarchar(255) NOT NULL,
[Blocking_Session_id] INT,
[Query_Text] nvarchar(MAX) NULL ,
[Query_Plan] [XML] NULL  
 PRIMARY KEY CLUSTERED(start_time)  
   WITH( 
		PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
		)ON [PRIMARY]
END


