IF EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID('dbo.spGetTesting')
    AND type = 'P'
)
DROP PROCEDURE dbo.spGetTesting
GO

CREATE PROCEDURE dbo.spGetTesting
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.Testing
    ORDER BY ID;
END
GO