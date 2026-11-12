SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Alls].[f_CastListToString]
  (
    @Names Alls.td_String READONLY
  )
RETURNS NVARCHAR(MAX)
BEGIN

  DECLARE @OutPut VARCHAR(MAX);

  SELECT @OutPut = COALESCE(@OutPut + ', ', '') + CAST(t.Name AS NVARCHAR(MAX))
    FROM @Names AS t;

  RETURN ISNULL( @OutPut , N'');

END;

	
GO
