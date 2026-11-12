SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_ItemSharedVendorInsert]
  @VendorID UNIQUEIDENTIFIER ,
  @SharedID UNIQUEIDENTIFIER ,
  @ItemCode NVARCHAR(MAX) ,
  @UnitIs NVARCHAR(MAX) ,
  @CurrencyID UNIQUEIDENTIFIER ,
  @Price FLOAT ,
  @DescriptionIs NVARCHAR(MAX) ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @EventType TINYINT ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT;

    END;

    BEGIN --Insert

      SET @Return = 0;

      INSERT  INTO Items.t_ItemSharedVendor
              ( ID ,
                VendorID ,
                Vendor ,
                SharedID ,
                ItemCode ,
                UnitIs ,
                CurrencyID ,
                Currency ,
                Price ,
                PriceF ,
                PriceD ,
                DescriptionIs
              )
      SELECT TOP ( 1 )
              @ID ,
              @VendorID ,
              Vendors.f_VendorGetName(@VendorID) ,
              @SharedID ,
              @ItemCode ,
              @UnitIs ,
              @CurrencyID ,
              s.Name ,
              @Price ,
              Currencys.f_Format(@CurrencyID, @Price) ,
              @Price / s.ExchangeRate ,
              @DescriptionIs
      FROM    Currencys.t_Currency AS s
      WHERE   s.ID = @CurrencyID
      ORDER BY s.ID;
	  
      UPDATE  Items.t_ItemSharedVendor
      SET     SearchText = Items.f_ItemSharedVendorSearchTextGet(ID)
      WHERE   ID = @ID;

    END;

    BEGIN --Rebuilding statistics

      UPDATE  Items.t_ItemShared
      SET     VendorC += 1 ,
              VendorNames = Alls.f_FixXML(( SELECT  N', ' + t.Vendor AS [text()]
                                            FROM    Items.t_ItemSharedVendor AS t
                                            WHERE   t.SharedID = t_ItemShared.ID
                                          FOR
                                            XML PATH('')
                                          ))
      WHERE   ID = @SharedID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Items.t_ItemSharedMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      VALUES  ( @UserID ,
                @SharedID ,
                @Event ,
                @EventType ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

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
