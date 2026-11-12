SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Items].[s_ProfitPartnerInsertDefaultData]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Check

      IF EXISTS ( SELECT TOP ( 1 )
                          ID
                  FROM    Items.t_ProfitPartner )
      BEGIN
			
        COMMIT TRAN;

        RETURN 1;

      END;

    END;

    BEGIN --Insert

      INSERT  Items.t_ProfitPartner
              ( Name )
      VALUES  ( N'-' );

      UPDATE  Items.t_ProfitPartner
      SET     IsMaster = 1 ,
              SearchText = Items.f_ProfitPartnerSearchTextGet(ID);

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
