CREATE TABLE [Gym].[t_GymMemberAttendance]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymMemberAttendance_ID] DEFAULT (newsequentialid()),
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_GymMemberAttendance_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_GymMemberAttendance_DateOnly] DEFAULT (getdate()),
[DateMonthly] [date] NOT NULL CONSTRAINT [DF_t_GymMemberAttendance_DateMonthly] DEFAULT (getdate()),
[DateYearly] [date] NOT NULL CONSTRAINT [DF_t_GymMemberAttendance_DateYearly] DEFAULT (getdate()),
[AccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymMemberAttendance_AccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[Account] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymMemberAttendance_Account] DEFAULT ([Company].[f_AccountGetFirstName]()),
[AccountNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymMemberAttendance_AccountNumber] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[TypeIs] [tinyint] NOT NULL CONSTRAINT [DF_t_GymMemberAttendance_TypeIs] DEFAULT ((0)),
[TypeIsAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymMemberAttendance_TypeIsAR] DEFAULT (N'يدويا'),
[TypeIsEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymMemberAttendance_TypeIsEN] DEFAULT ('Manually'),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymMemberAttendance_DescriptionIs] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_GymMemberAttendance_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_GymMemberAttendance_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_GymMemberAttendance_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [Gym].[tr_GymMemberAttendance] ON [Gym].[t_GymMemberAttendance]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Gym.t_GymMemberAttendance
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_GymMemberAttendance.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'gymMemberAttendance'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'gymMemberAttendance'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, GymMemberAttendance, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaGym, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;

GO
ALTER TABLE [Gym].[t_GymMemberAttendance] ADD CONSTRAINT [PK_t_GymMemberAttendance] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Gym].[t_GymMemberAttendance] ADD CONSTRAINT [AccountKeyGymMemberAttendance] FOREIGN KEY ([AccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Manually
Automatically', 'SCHEMA', N'Gym', 'TABLE', N't_GymMemberAttendance', 'COLUMN', N'TypeIs'
GO
