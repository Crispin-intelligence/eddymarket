SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Quotations].[s_QuotationNoteRebuildingStatistics]
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        BEGIN --Rebuild statistics

            SET @Return = 0;

            --UPDATE Quotations.t_QuotationNote
            --SET QuotationC =
            --    (
            --        SELECT COUNT(*) AS Total
            --        FROM Quotations.t_QuotationLinkNote AS s
            --        WHERE (s.NoteID = t_QuotationNote.ID)
            --    );

            UPDATE Quotations.t_QuotationNote
            SET QuotationTotalDF = Currencys.f_FormatD(QuotationTotalD),
                QuotationTotalLLF = Currencys.f_FormatD(QuotationTotalLL),
                QuotationTotalEuroF = Currencys.f_FormatD(QuotationTotalEuro);

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Quotations.t_QuotationNoteMoving
            (
                UserID,
                SectionID,
                EventIs,
                EventType,
                ComputerIP,
                Computer,
                ComputerAccount
            )
            VALUES
            (@UserID, '00000000-0000-0000-0000-000000000000', @Event, 6, @ComputerIP, @Computer, @ComputerAccount);

        END;

        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @Return;

    END CATCH;

END;



GO
