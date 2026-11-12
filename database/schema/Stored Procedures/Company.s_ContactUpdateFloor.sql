SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_ContactUpdateFloor]
    @FloorID UNIQUEIDENTIFIER,
    @UserID UNIQUEIDENTIFIER,
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX),
    @IDAndEvent Alls.tt_IDAndEvent READONLY
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        BEGIN --Update 

            SET @Return = 0;

            UPDATE Company.t_Contact
            SET FloorID = @FloorID,
                FloorIs = Location.f_FloorGetName(@FloorID)
            WHERE EXISTS
            (
                SELECT TOP (1) s.ID FROM @IDAndEvent AS s WHERE s.ID = t_Contact.ID
            );

            UPDATE Company.t_Contact
            SET AddressIs = Location.f_ConcetFullAddress(
                                                            StatesIs,
                                                            RegionIs,
                                                            Street,
                                                            Building,
                                                            FloorIs,
                                                            PostalCode,
                                                            AddressNote,
                                                            ' - ',
                                                            '-'
                                                        )
            WHERE EXISTS
            (
                SELECT TOP (1) s.ID FROM @IDAndEvent AS s WHERE s.ID = t_Contact.ID
            );

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Company.t_ContactMoving
            (
                UserID,
                SectionID,
                EventIs,
                EventType,
                ComputerIP,
                Computer,
                ComputerAccount
            )
            SELECT @UserID,
                   s.ID,
                   s.EventIs,
                   1,
                   @ComputerIP,
                   @Computer,
                   @ComputerAccount
            FROM @IDAndEvent AS s;

        END;

        COMMIT TRANSACTION;

        SELECT 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        SELECT @Return;

    END CATCH;

END;








GO
