
/****** Object:  StoredProcedure [dbo].[pr_AddNewUser]    Script Date: 6/11/2026 3:10:51 PM ******/
DROP PROCEDURE [dbo].[pr_AddNewUser]
GO

/****** Object:  StoredProcedure [dbo].[pr_AddNewMenu]    Script Date: 6/11/2026 3:10:51 PM ******/
DROP PROCEDURE [dbo].[pr_AddNewMenu]
GO

/****** Object:  StoredProcedure [dbo].[pr_AddNewMenu]    Script Date: 6/11/2026 3:10:51 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO





CREATE PROCEDURE [dbo].[pr_AddNewMenu] AS

GO

/****** Object:  StoredProcedure [dbo].[pr_AddNewUser]    Script Date: 6/11/2026 3:10:51 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO





CREATE PROCEDURE [dbo].[pr_AddNewUser]
	@UserID varchar(20),@isJnjPortal bit, @UserName varchar(100),@FullName VARCHAR(200),@Password varchar(100),@MD5Password varchar(100),@Msg varchar(200) output,@MailMsg VARCHAR(200) output
AS
BEGIN
	SET NOCOUNT ON;
	SET @Msg='ERROR: SORRY PLEASE TRY AGAIN'
	BEGIN TRY
		BEGIN TRANSACTION
		
		DECLARE @PASSWORDTEMPEXPIRYDAY VARCHAR(5)
		DECLARE @PASSWORDTEMPEXPIRYDAY_INT INT
	
		DECLARE @query nvarchar(max)
		DECLARE @ZylemDBName VARCHAR(100)=[dbo].[fn_GetZylemDatabaseName] ();
		DECLARE @ParamDefinition AS NVarchar(2000) 		

		SELECT @PASSWORDTEMPEXPIRYDAY = ISNULL(VALUE,'0') FROM PPASSWORDPOLICYSETTINGS WHERE KEYNAME='PASSWORDTEMPEXPIRYDAY';
		SET @PASSWORDTEMPEXPIRYDAY_INT=CAST(@PASSWORDTEMPEXPIRYDAY AS INT)
		DECLARE @ExpiryDate datetime=NULL
		IF(@PASSWORDTEMPEXPIRYDAY_INT>0)
		BEGIN
			SET @ExpiryDate=DATEADD(DAY,@PASSWORDTEMPEXPIRYDAY_INT,GETDATE())
		END
		

		IF(isnull(@UserID,'')!='' and isnull(@Password,'')!='' and isnull(@MD5Password,'')!=''  and isnull(@FullName,'')!='' and isnull(@UserName,'')!='')
		BEGIN
			IF NOT EXISTS(SELECT 1 FROM DBO.PAASSWORDPOLICY WHERE LOGINID=@UserName)
			BEGIN		
						
					INSERT INTO [dbo].[PAASSWORDPOLICY]([USERID],[LOGINID],[CURRENTPASSWORD],[LASTLOGINTIME],[EXPIRYDATE],[NOOFATTEMPTS])
					VALUES(@UserID,@UserName,@MD5Password,NULL,@ExpiryDate,0)

					SELECT @MailMsg='Dear <b>'+@FullName+ "</b> Your  <b>User Name : "+@UserName+ "</b> and <b>Password : "+@Password+"</b> "
					IF(@ExpiryDate IS NOT NULL)
					BEGIN
						SET @MailMsg=@MailMsg+" and password will expire after "+cast(@ExpiryDate as varchar(100))
					END
												
					SET @Msg='User added successfully'			
				
				

			END
			ELSE
			BEGIN
				SET @Msg='User already exists'
			END		
		END
		ELSE
		BEGIN	
			SET @Msg ='User ID,Login Name,Full Name and password is required'
		END
	
		
	COMMIT TRANSACTION
	RETURN;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
			SELECT @Msg='ERROR: '+ERROR_MESSAGE();
	END CATCH
END




GO


