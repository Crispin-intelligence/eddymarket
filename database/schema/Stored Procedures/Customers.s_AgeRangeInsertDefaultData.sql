SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Customers].[s_AgeRangeInsertDefaultData]
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Check

            IF EXISTS ( SELECT TOP ( 1 )
                                ID
                        FROM    Customers.t_AgeRange )
            BEGIN
			
                COMMIT TRAN;

                RETURN 1;

            END;

        END;

        BEGIN --Insert

            INSERT  Customers.t_AgeRange
                    ( Name )
            VALUES  ( N'-' ),
                    ( N'1 - 5' ),
                    ( N'5 - 10' ),
                    ( N'10 - 18' ),
                    ( N'18 - 25' ),
                    ( N'25 - 30' ),
                    ( N'35 - 50' ),
                    ( N'Above 50' );

        END;

        COMMIT TRAN;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN 0;

    END CATCH;

END;




GO
