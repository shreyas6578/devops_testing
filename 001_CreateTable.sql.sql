IF OBJECT_ID('dbo.Testing', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Testing
    (
        ID INT IDENTITY(1,1) PRIMARY KEY,
        Name VARCHAR(100),
        CreatedDate DATETIME DEFAULT GETDATE()
    )
END
GO