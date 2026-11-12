CREATE TABLE [Gym].[t_GymActiveVSAttendance]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymActiveVSAttendance_ID] DEFAULT (newsequentialid()),
[DateIs] [date] NOT NULL CONSTRAINT [DF_t_GymActiveVSAttendance_DateIs] DEFAULT (getdate()),
[DateMonthly] [date] NOT NULL CONSTRAINT [DF_t_GymActiveVSAttendance_DateMonthly] DEFAULT (getdate()),
[DateYearly] [date] NOT NULL CONSTRAINT [DF_t_GymActiveVSAttendance_DateYearly] DEFAULT (getdate()),
[ActiveNumber] [bigint] NOT NULL CONSTRAINT [DF_t_GymActiveVSAttendance_ActiveNumber] DEFAULT ((0)),
[AttendanceNumber] [bigint] NOT NULL CONSTRAINT [DF_t_GymActiveVSAttendance_AttendanceNumber] DEFAULT ((0)),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_GymActiveVSAttendance_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_GymActiveVSAttendance_WorkStationID] DEFAULT ((1))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE TRIGGER [Gym].[tr_GymActiveVSAttendance] ON [Gym].[t_GymActiveVSAttendance]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Gym.t_GymActiveVSAttendance
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_GymActiveVSAttendance.ID );

  END;
  
  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'gymActiveVSAttendance'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'gymActiveVSAttendance'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, GymActiveVSAttendance, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaGym, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;

GO
ALTER TABLE [Gym].[t_GymActiveVSAttendance] ADD CONSTRAINT [PK_t_GymActiveVSAttendance] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
