SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Company].[s_SMSServiceMerge]
    @SMSService Company.[tt_SMSService] READONLY ,
    @SMSServiceDetail Company.[tt_SMSServiceDetail] READONLY ,
    @UserID UNIQUEIDENTIFIER ,
    @ComputerIP NVARCHAR(MAX) ,
    @Computer NVARCHAR(MAX) ,
    @ComputerAccount NVARCHAR(MAX)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        BEGIN --Insert

            SET @Return = 0;

            MERGE Company.t_SMSService AS t
            USING @SMSService AS s
            ON s.BatchID = t.BatchID
            WHEN NOT MATCHED BY TARGET THEN
                INSERT ( ID ,
                         BatchID ,
                         DateSend ,
                         StatusIs ,
                         SenderID ,
                         TotalMobiles ,
                         MessageIs
                       )
                VALUES ( s.ID ,
                         s.BatchID ,
                         s.DateSend ,
                         s.StatusIs ,
                         s.SenderID ,
                         s.TotalMobiles ,
                         s.MessageIs
                       )
            WHEN MATCHED THEN
                UPDATE SET
                         t.StatusIs = s.StatusIs;

        END;

        BEGIN --Insert Detail

            DELETE  FROM Company.t_SMSServiceDetail
            WHERE   EXISTS ( SELECT TOP ( 1 )
                                    s.ID
                             FROM   @SMSService AS s
                             WHERE  s.BatchID = t_SMSServiceDetail.BatchID );

            MERGE Company.t_SMSServiceDetail AS t
            USING @SMSServiceDetail AS s
            ON s.BatchID = t.BatchID
                AND s.Mobile = t.Mobile
            WHEN NOT MATCHED BY TARGET THEN
                INSERT ( BatchID ,
                         Mobile ,
                         DateSend ,
                         DateDone ,
                         StatusIs
                       )
                VALUES ( s.BatchID ,
                         s.Mobile ,
                         s.DateSend ,
                         s.DateDone ,
                         s.StatusIs
                       )
            WHEN MATCHED THEN
                UPDATE SET
                         t.DateSend = s.DateSend ,
                         t.DateDone = s.DateDone ,
                         t.StatusIs = s.StatusIs;

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT  INTO Company.t_SMSServiceMoving
                    ( UserID ,
                      SectionID ,
                      EventIs ,
                      EventType ,
                      ComputerIP ,
                      Computer ,
                      ComputerAccount
                    )
                    SELECT  @UserID ,
                            s.ID ,
                            s.EventIs ,
                            0 ,
                            @ComputerIP ,
                            @Computer ,
                            @ComputerAccount
                    FROM    @SMSService AS s;

        END;

        COMMIT TRANSACTION;

        SELECT  1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        SELECT  @Return;

    END CATCH;

END;

GO
