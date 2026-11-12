SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Alls].[s_Backup] @Path1 NVARCHAR(MAX) ,
  @Path2 NVARCHAR(MAX) ,
  @DatabaseName sysname ,
  @TypeIs NVARCHAR(MAX)
AS
BEGIN
  BEGIN TRY

    DECLARE @PathNet1 AS NVARCHAR(MAX) = @Path1 + @DatabaseName + ' ' + FORMAT(GETDATE(), 'dd-MM-yyyy (hh-mm-ss tt)') + ' ' + @TypeIs + '.bak';
    DECLARE @PathNet2 AS NVARCHAR(MAX) = @Path2 + @DatabaseName + ' ' + FORMAT(GETDATE(), 'dd-MM-yyyy (hh-mm-ss tt)') + ' ' + @TypeIs + '.bak';

    IF @Path1 <> '' AND @Path2 <> ''
    BEGIN

      BACKUP DATABASE @DatabaseName TO DISK = @PathNet1 WITH FORMAT , INIT , COMPRESSION; 

      BACKUP DATABASE @DatabaseName TO DISK = @PathNet2 WITH FORMAT , INIT , COMPRESSION; 
	 
      RETURN 1;

    END;
  
    IF @Path1 <> ''
    BEGIN

      BACKUP DATABASE @DatabaseName TO DISK = @PathNet1 WITH FORMAT , INIT , COMPRESSION; 
          
    END;	
 
    IF @Path2 <> ''
    BEGIN

      BACKUP DATABASE @DatabaseName TO DISK = @PathNet2 WITH FORMAT , INIT , COMPRESSION; 
        
    END;
			
    RETURN 1;

  END TRY

  BEGIN CATCH

    RETURN 0;

  END CATCH;

END;







GO
