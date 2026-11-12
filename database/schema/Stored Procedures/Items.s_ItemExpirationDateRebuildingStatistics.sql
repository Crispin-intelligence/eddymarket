SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Items].[s_ItemExpirationDateRebuildingStatistics]
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX)
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT;

    END;

    BEGIN --Rebuild statistics

      SET @Return = 0;

      UPDATE  Items.t_ItemExpirationDate
      SET     WareHouse = Company.f_WareHouseGetName(WareHouseID) ,
              Place = Company.f_PlaceGetName(PlaceID) ,
              Currency = Currencys.f_CurrencyGetName(CurrencyID) ,
              PriceF = Currencys.f_Format(CurrencyID, Price);

      UPDATE  Items.t_ItemExpirationDate
      SET     SearchText = Items.f_ItemExpirationDateSearchTextGet(ID);

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Items.t_ItemExpirationDateMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      VALUES  ( @UserID ,
                '00000000-0000-0000-0000-000000000000' ,
                @Event ,
                6 ,
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
