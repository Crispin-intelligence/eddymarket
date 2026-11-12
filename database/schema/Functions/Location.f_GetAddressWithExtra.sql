SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Location].[f_GetAddressWithExtra]
    (
      @StateID INT ,
      @RegionID INT ,
      @StreetID INT ,
      @BuildingID INT ,
      @FloorID INT ,
      @AddressNote NVARCHAR(MAX)
    )
RETURNS NVARCHAR(MAX)
AS
    BEGIN
	
        DECLARE @EndReturn NVARCHAR(MAX) = '';

        DECLARE @State NVARCHAR(MAX);
        DECLARE @Region NVARCHAR(MAX);
        DECLARE @Street NVARCHAR(MAX);
        DECLARE @Building NVARCHAR(MAX);
        DECLARE @Floor NVARCHAR(MAX);

        SELECT TOP 1
                @State = COALESCE(t.Name, N'-') + N' '
        FROM    Location.t_States AS t
        WHERE   t.ID = @StateID;

        SELECT TOP 1
                @Region = COALESCE(t.Name, N'-') + N' '
        FROM    Location.t_Region AS t
        WHERE   t.ID = @RegionID;

        SELECT TOP 1
                @Street = COALESCE(t.Name, N'-') + N' '
        FROM    Location.t_Street AS t
        WHERE   t.ID = @StreetID;

        IF @BuildingID > 0
            BEGIN
        
                SELECT TOP 1
                        @Building = COALESCE(t.Name, N'-') + N' '
                FROM    Location.t_Building AS t
                WHERE   t.ID = @BuildingID;

                SELECT TOP 1
                        @Floor = COALESCE(t.Name, N'-') + N' '
                FROM    Location.t_Floor AS t
                WHERE   t.ID = @FloorID;

            END;

        SET @EndReturn = @State + @Region + @Street + @Building + @Floor
            + N'(' + @AddressNote + N')';

        SET @EndReturn = LTRIM(REPLACE(REPLACE(@EndReturn, '-', ''), N'()',
                                       N''));
			
        RETURN @EndReturn;

    END;




GO
