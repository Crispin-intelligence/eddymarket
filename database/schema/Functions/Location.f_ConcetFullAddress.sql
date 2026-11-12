SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Location].[f_ConcetFullAddress]
    (
      @StateIs NVARCHAR(MAX) ,
      @RegionIs NVARCHAR(MAX) ,
      @Street NVARCHAR(MAX) ,
      @Building NVARCHAR(MAX) ,
      @Floor NVARCHAR(MAX) ,
      @PostalCode NVARCHAR(MAX) ,
      @Note NVARCHAR(MAX) ,
      @SplitBy NVARCHAR(MAX) ,
      @WithOut NVARCHAR(MAX)
    )
RETURNS NVARCHAR(MAX)
AS
BEGIN

    DECLARE @t AS TABLE
        (
          ID TINYINT ,
          Name NVARCHAR(MAX)
        );

    INSERT  INTO @t
            ( ID, Name )
    VALUES  ( 0, @StateIs ),
            ( 1, @RegionIs ),
            ( 2, @Street ),
            ( 3, @Building ),
            ( 4, @Floor ),
            ( 5, @PostalCode ),
            ( 6, IIF(LEN(@Note) = 0, N'', N'(' + @Note + ')'));

    DECLARE @o NVARCHAR(MAX) = ( SELECT @SplitBy + t.Name AS [text()]
                                 FROM   @t AS t
                                 WHERE  t.Name <> N'' AND t.Name <> N'-'
                                 ORDER BY t.ID
                               FOR
                                 XML PATH('')
                               );

    SET @o = SUBSTRING(COALESCE(@o, N''), 4, 99999);

    RETURN ISNULL(@o,N'');

END;





GO
