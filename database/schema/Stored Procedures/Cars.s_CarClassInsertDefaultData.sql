SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Cars].[s_CarClassInsertDefaultData]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Check

      IF EXISTS ( SELECT TOP ( 1 )
                          ID
                  FROM    Cars.t_CarClass )
      BEGIN
			
        COMMIT TRAN;

        RETURN 1;

      END;

    END;

    BEGIN --Insert

      INSERT  Cars.t_CarClass
              ( Name )
      VALUES  ( N'-' ) ,
              ( N'Compact' ) ,
              ( N'Convertible' ) ,
              ( N'Economy' ) ,
              ( N'Fullsize' ) ,
              ( N'Fullsize Van' ) ,
              ( N'Luxury' ) ,
              ( N'Midsize' ) ,
              ( N'Minivan' ) ,
              ( N'Pickup' ) ,
              ( N'Sport Utilty' );

      UPDATE  Cars.t_CarClass
      SET     SearchText = '';

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
