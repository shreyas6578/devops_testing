
/****** Object:  StoredProcedure [dbo].[spGetTesting]    Script Date: 6/10/2026 9:47:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

alter PROCEDURE [dbo].[spGetTesting]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.Testing
    ORDER BY ID;
	--hello world
END
