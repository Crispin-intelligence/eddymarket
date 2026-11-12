SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Vendors].[s_VendorInsertDefaultData]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Check

      IF EXISTS ( SELECT TOP ( 1 )
                          ID
                  FROM    Vendors.t_Vendor )
      BEGIN
			
        COMMIT TRAN;

        RETURN 1;

      END;

    END;

    BEGIN --Insert
		
      INSERT  INTO Vendors.t_VendorOption
              DEFAULT VALUES;

      INSERT  INTO Vendors.t_Vendor
              DEFAULT VALUES;
		   
      UPDATE  Vendors.t_Vendor
      SET     SearchText = Vendors.f_VendorSearchTextGet(ID);
	 
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
