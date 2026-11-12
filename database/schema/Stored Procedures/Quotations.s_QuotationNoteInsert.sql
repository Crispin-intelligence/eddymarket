SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Quotations].[s_QuotationNoteInsert]
    @Name NVARCHAR(MAX),
    @AutoInsert BIT,
    @DescriptionIs NVARCHAR(MAX),
    @SortAt FLOAT,
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX),
    @ID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @IDs TABLE
            (
                ID UNIQUEIDENTIFIER NOT NULL
            );

            DECLARE @Return INT;

        END;

        BEGIN --Insert

            SET @Return = 0;

            INSERT INTO Quotations.t_QuotationNote
            (
                Name,
                AutoInsert,
                DescriptionIs,
                SortAt
            )
            OUTPUT Inserted.ID
            INTO @IDs
            (
                ID
            )
            VALUES
            (@Name, @AutoInsert, @DescriptionIs, @SortAt);

            SET @ID =
            (
                SELECT TOP (1) ID FROM @IDs ORDER BY ID
            );

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
            (@UserID, @ID, @Event, 0, @ComputerIP, @Computer, @ComputerAccount);

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
