CREATE TABLE [Users].[t_UserLoginHistory]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_UserLoginHistory_ID] DEFAULT (newsequentialid()),
[UserID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_UserLoginHistory_UserID] DEFAULT ([Users].[f_UserGetFirstID]()),
[UserIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_UserLoginHistory_UserIs] DEFAULT ([Users].[f_UserGetFirstName]()),
[DateIs] [date] NOT NULL CONSTRAINT [DF_t_UserLoginHistory_DateIs] DEFAULT (getdate()),
[StartTime] [datetime] NOT NULL CONSTRAINT [DF_t_UserLoginHistory_StartTime] DEFAULT (getdate()),
[EndTime] [datetime] NOT NULL CONSTRAINT [DF_t_UserLoginHistory_EndTime] DEFAULT (getdate()),
[WorkTime] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_UserLoginHistory_WorkTime] DEFAULT ('00:00:00'),
[HoursIs] [float] NOT NULL CONSTRAINT [DF_t_UserLoginHistory_HoursIs] DEFAULT ((0)),
[ComputerIP] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL,
[Computer] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL,
[ComputerAccount] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL,
[IsOnline] [bit] NOT NULL CONSTRAINT [DF_t_UserLoginHistory_Online] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_UserLoginHistory_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Users].[tr_UserLoginHistory]
ON [Users].[t_UserLoginHistory]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @User AS TABLE
        (
            ID UNIQUEIDENTIFIER NOT NULL,
            HoursIs FLOAT NOT NULL,
            LoginC BIGINT NOT NULL
        );

    END;

    BEGIN --Set info

        INSERT INTO @User
        (
            ID,
            HoursIs,
            LoginC
        )
        SELECT o.UserID,
               ISNULL(SUM(o.HoursIs), 0),
               ISNULL(SUM(o.LoginC), 0)
        FROM
        (
            SELECT s.UserID,
                   s.HoursIs,
                   1 AS LoginC
            FROM Inserted AS s
            UNION ALL
            SELECT s.UserID,
                   0 - s.HoursIs,
                   -1 AS LoginC
            FROM Deleted AS s
        ) AS o
        GROUP BY o.UserID;

    END;

    BEGIN --Fix user

        MERGE Users.t_User AS t
        USING @User AS s
        ON s.ID = t.ID
        WHEN MATCHED THEN
            UPDATE SET t.HoursIs += s.HoursIs,
                       t.WorkTime = DateTimes.f_DateTimeDiff(
                                                                GETDATE(),
                                                                GETDATE() + ((t.HoursIs + s.HoursIs) / 24),
                                                                N'y',
                                                                1,
                                                                '',
                                                                ''
                                                            ),
                       t.LoginC += s.LoginC;

    END;

END;
GO
ALTER TABLE [Users].[t_UserLoginHistory] ADD CONSTRAINT [PK_t_UserLoginHistory] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Users].[t_UserLoginHistory] ADD CONSTRAINT [UserKeyUserLoginHistory] FOREIGN KEY ([UserID]) REFERENCES [Users].[t_User] ([ID]) ON DELETE CASCADE
GO
