/****** Object:  Trigger [dbo].[TRG_ESCROW_UPD]    Script Date: 5/10/2018 1:22:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRG_ESCROW_UPD_TMP] 
ON [dbo].[ESCROW] 
AFTER UPDATE 
AS 
BEGIN

 declare @sub_status_cd nvarchar(10), @status_cd nvarchar(10), @reported_dt datetime, @id bigint;

 select @sub_status_cd=i.sub_status_cd, @status_cd=i.status_cd, @reported_dt = i.reported_dt, @id = i.id
 from
	inserted i;

 if (@sub_status_cd = 'QCREJ' and @status_cd = 'OPEN' and @reported_dt is null)
	UPDATE ESCROW 
	SET STATUS_CD = 'CLSE'
	WHERE 
		ID = @id;
END
GO
