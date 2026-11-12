SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Quotations].[s_QuotationTypeUpdate]
    @Name NVARCHAR(MAX),
    @DescriptionIs NVARCHAR(MAX),
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX),
    @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT,
                    @NameOld NVARCHAR(450);

        END;

        BEGIN --Set info

            SELECT TOP (1)
                   @NameOld = s.Name
            FROM Quotations.t_QuotationType AS s
            WHERE s.ID = @ID
            ORDER BY s.ID;

        END;

        BEGIN --Update

            SET @Return = 0;

            UPDATE Quotations.t_QuotationType
            SET Name = @Name,
                DescriptionIs = @DescriptionIs
            WHERE ID = @ID;

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Quotations.t_QuotationTypeMoving
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
            (@UserID, @ID, @Event, 1, @ComputerIP, @Computer, @ComputerAccount);

        END;

    --IF @NameOld COLLATE Arabic_CS_AS <> @Name COLLATE Arabic_CS_AS
        --BEGIN

        --    BEGIN --Fix t_Quotation

        --        UPDATE Quotations.t_Quotation
        --        SET Type = @Name
        --        WHERE TypeID = @ID;

        --    END;

        --    BEGIN --Fix t_QuotationHistory

        --        UPDATE Quotations.t_QuotationHistory
        --        SET Type = @Name
        --        WHERE TypeID = @ID;

        --    END;

        --END;

        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @Return;

    END CATCH;

END;










GO
