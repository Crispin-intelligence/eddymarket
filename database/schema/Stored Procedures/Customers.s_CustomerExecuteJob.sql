SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Customers].[s_CustomerExecuteJob]
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Check i need execute

            IF NOT EXISTS ( SELECT TOP ( 1 )
                                    s.ID
                            FROM    Alls.t_LastExecuteJob AS s
                            WHERE   s.Customers_t_Customer < CONVERT(DATE, GETDATE()) )
            BEGIN

                COMMIT TRANSACTION;

                RETURN 1;

            END;

        END;

        BEGIN; --Update 

            UPDATE  Customers.t_Customer
            SET     AgeIs = DateTimes.f_GetAge(Birthday) ,
                    NotificationDateInternet = DATEADD(DAY, 0 - NotificationBeforeDaysInternet, ActiveToInternet);

        END;

        BEGIN --Execute is done

            UPDATE  Alls.t_LastExecuteJob
            SET     Customers_t_Customer = GETDATE();

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
