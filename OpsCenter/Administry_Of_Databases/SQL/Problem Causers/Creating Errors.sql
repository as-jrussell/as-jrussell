use ThePlayPen


BEGIN TRY
  -- Error here
  SELECT 1/0
END TRY
BEGIN CATCH
RAISERROR (15600, -1, -1, 'I like when I create errors') WITH LOG
END CATCH

GO 1000