SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Alls].[f_Concet]
    (
      @v NVARCHAR(MAX) ,
      @v1 NVARCHAR(MAX) ,
      @v2 NVARCHAR(MAX) ,
      @SplitBy NVARCHAR(MAX) ,
      @WithOut NVARCHAR(MAX)
    )
RETURNS NVARCHAR(MAX)
AS
    BEGIN

        DECLARE @o NVARCHAR(MAX) = N'';

        SET @v = RTRIM(LTRIM(@v));
        SET @v1 = RTRIM(LTRIM(@v1));
        SET @v2 = RTRIM(LTRIM(@v2));

        SET @o = IIF(REPLACE(@v, @WithOut, N'') = N'', N'', @v + @SplitBy)
            + IIF(REPLACE(@v1, @WithOut, N'') = N'', N'', @v1 + @SplitBy)
            + IIF(REPLACE(@v2, @WithOut, N'') = N'', N'', @v2);
     
	 
	    RETURN iif(@o = N'' ,N'-' ,@o);

    END;


GO
