SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Users].[s_UserLoginUpdateAuto]
    @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Update

            UPDATE Users.t_UserLogin
            SET EndTime = GETDATE(),
                WorkTime = DateTimes.f_DateTimeDiff(StartTime, GETDATE(), N'd', 1, '', ''),
                [HoursIs] = (DATEDIFF(SECOND, StartTime, GETDATE()) / 60.0) / 60.0
            WHERE ID = @ID;

        END;

        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN 0;

    END CATCH;

END;


GO
