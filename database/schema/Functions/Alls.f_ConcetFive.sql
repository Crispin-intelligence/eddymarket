SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Alls].[f_ConcetFive]
    (
      @v NVARCHAR(MAX) ,
      @v1 NVARCHAR(MAX) ,
      @v2 NVARCHAR(MAX) ,
      @v3 NVARCHAR(MAX) ,
      @v4 NVARCHAR(MAX) ,
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
        SET @v3 = RTRIM(LTRIM(@v3));
        SET @v4 = RTRIM(LTRIM(@v4));

        SET @o = IIF(REPLACE(@v, @WithOut, N'') = N'', N'', @v + @SplitBy)
            + IIF(REPLACE(@v1, @WithOut, N'') = N'', N'', @v1 + @SplitBy)
            + IIF(REPLACE(@v2, @WithOut, N'') = N'', N'', @v2 + @SplitBy)
            + IIF(REPLACE(@v3, @WithOut, N'') = N'', N'', @v3 + @SplitBy)
            + IIF(REPLACE(@v4, @WithOut, N'') = N'', N'', @v4);
     
	 
        RETURN IIF(@o = N'' ,N'-' ,@o);

    END;


GO
