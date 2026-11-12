SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Gym].[v_GymMemberAttendanceTop10PerCustomer]
AS
SELECT o.ID ,
    o.DateIs ,
    o.AccountID ,
    o.TypeIs
  FROM ( SELECT s.ID ,
            s.DateIs ,
            s.AccountID ,
            s.TypeIs ,
            ROW_NUMBER() OVER ( PARTITION BY s.AccountID ORDER BY s.DateOnly DESC ) AS RowNumber
          FROM Gym.t_GymMemberAttendance AS s
       ) AS o
  WHERE o.RowNumber <= 10;
  

GO
