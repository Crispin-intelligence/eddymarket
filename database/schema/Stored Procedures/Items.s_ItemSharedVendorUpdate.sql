SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_ItemSharedVendorUpdate]
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

      DECLARE @Return INT ,
        @SharedID UNIQUEIDENTIFIER;

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @SharedID = s.SharedID
      FROM    Items.t_ItemSharedVendor AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

    END;

    BEGIN --Update

      SET @Return = 0;

      UPDATE  Items.t_ItemSharedVendor
      SET     ItemCode = @ItemCode ,
              UnitIs = @UnitIs ,
              CurrencyID = @CurrencyID ,
              Currency = Currencys.f_CurrencyGetName(@CurrencyID) ,
              Price = @Price ,
              PriceF = Currencys.f_Format(@CurrencyID, @Price) ,
              PriceD = @Price / Currencys.f_CurrencyGetExchangeRate(@CurrencyID) ,
              DescriptionIs = @DescriptionIs
      WHERE   ID = @ID;

      UPDATE  Items.t_ItemSharedVendor
      SET     SearchText = Items.f_ItemSharedVendorSearchTextGet(ID)
      WHERE   ID = @ID;

    END;

    BEGIN --Rebuilding statistics

      UPDATE  Items.t_ItemShared
      SET     VendorNames = Alls.f_FixXML(( SELECT  N', ' + t.Vendor AS [text()]
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
