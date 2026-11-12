SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Company].[f_BookPhoneGet]
    (
      @ID NVARCHAR(MAX) ,
      @SectionID INT
    )
RETURNS NVARCHAR(MAX)
    BEGIN

        DECLARE @OutPut VARCHAR(MAX);

        SELECT  @OutPut = COALESCE(@OutPut + ' , ', N'')
                + CAST(t.NumberIs AS NVARCHAR(MAX))
        FROM    Company.t_BookPhone AS t
        WHERE   t.OwnerID = @ID
                AND t.SectionID = @SectionID;

        RETURN COALESCE(@OutPut , N'');

    END;

	


GO
