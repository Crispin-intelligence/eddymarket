SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Alls].[s_CompanyInfoSetAppQRCode] @AppQRCode NVARCHAR(450)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT TOP (1) ID FROM Alls.t_CompanyInfo)
        BEGIN

            INSERT INTO Alls.t_CompanyInfo
            (
                AppQRCode
            )
            VALUES
            (@AppQRCode);

        END;
        ELSE
        BEGIN --Insert

            UPDATE Alls.t_CompanyInfo
            SET AppQRCode = @AppQRCode;

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
