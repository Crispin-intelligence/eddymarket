SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Gym].[f_GymClassGetDaysNamesEN]
  (
    @Day0 BIT ,
    @Day1 BIT ,
    @Day2 BIT ,
    @Day3 BIT ,
    @Day4 BIT ,
    @Day5 BIT ,
    @Day6 BIT
  )
RETURNS NVARCHAR(MAX)
AS
BEGIN

  DECLARE @t AS TABLE
    (
      DayIsActive BIT ,
      SortIndex INT ,
      Name NVARCHAR(MAX)
    );

  INSERT @t
      ( DayIsActive, SortIndex, Name )
    VALUES  ( @Day0, 7, N'Sunday' ),
            ( @Day1, 1, N'Monday' ),
            ( @Day2, 2, N'Tuesday' ),
            ( @Day3, 3, N'Wednesday' ),
            ( @Day4, 4, N'Thursday' ),
            ( @Day5, 5, N'Friday' ),
            ( @Day6, 6, N'Saturday' );

  RETURN Alls.f_FixXML(( SELECT ', ' + t.Name AS [text()]
                                              FROM @t AS t
											  WHERE t.DayIsActive = 1
											  ORDER BY t.SortIndex
                                           FOR
                                             XML PATH('')
                                           ));

END;



GO
