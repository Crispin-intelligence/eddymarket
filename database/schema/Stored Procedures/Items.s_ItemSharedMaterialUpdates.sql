SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_ItemSharedMaterialUpdates]
    @ItemSharedFatherID UNIQUEIDENTIFIER ,
    @Material Items.tt_ItemSharedMaterial READONLY ,
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

            DECLARE @CurrencyID UNIQUEIDENTIFIER ,
                @CurrencyType TINYINT ,
                @ExchangeRate DECIMAL(18, 2) ,
                @Return INT;

        END;

        BEGIN --Set info

            SELECT TOP ( 1 )
                    @CurrencyID = s.CurrencyID ,
                    @CurrencyType = s1.TypeIs ,
                    @ExchangeRate = s1.ExchangeRate
            FROM    Items.t_ItemShared AS s
                    INNER JOIN Currencys.t_Currency AS s1 ON s1.ID = s.CurrencyID
            WHERE   s.ID = @ItemSharedFatherID;

        END;

        BEGIN --Reinsert t_ItemSharedMaterial
     
            SET @Return = 0;

            DELETE  FROM Items.t_ItemSharedMaterial
            WHERE   ItemSharedFatherID = @ItemSharedFatherID;

            INSERT  INTO Items.t_ItemSharedMaterial
                    ( ID ,
                      ItemSharedFatherID ,
                      ItemSharedID ,
                      ItemUnityID ,
                      Qty ,
                      QtyWithUnity ,
                      Qtys ,
                      DescriptionIs ,
                      CreateByID ,
                      CreateBy
                    )
                    SELECT  t.ID ,
                            @ItemSharedFatherID ,
                            t.ItemSharedID ,
                            t.ItemUnityID ,
                            t.Qty ,
                            FORMAT(t.Qty, '#,##0.####') + ' ' + t2.Name ,
                            t.Qtys ,
                            t.DescriptionIs ,
                            @UserID ,
                            Users.f_UserGetName(@UserID)
                    FROM    @Material AS t
                            LEFT JOIN Items.t_UnityItem AS t1 ON t1.ID = t.ItemUnityID
                            LEFT JOIN Items.t_Unity AS t2 ON t2.ID = t1.UnityID;

        END;

        BEGIN --Fix Cost
		  
            UPDATE  Items.t_ItemShared
            SET     Purchase = ( SELECT COALESCE(SUM(CASE @CurrencyType
                                                       WHEN 0 THEN s1.PurchaseD * s.Qtys
                                                       WHEN 1 THEN s1.PurchaseLL * s.Qtys
                                                       ELSE s1.PurchaseEuro * s.Qtys
                                                     END), 0)
                                 FROM   Items.t_ItemSharedMaterial AS s
                                        LEFT JOIN Items.t_ItemShared AS s1 ON s1.ID = s.ItemSharedID
                                 WHERE  s.ItemSharedFatherID = t_ItemShared.ID
                               )
            WHERE   ID = @ItemSharedFatherID;

            UPDATE  Items.t_ItemShared
            SET     PurchaseF = Currencys.f_Format(CurrencyID, Purchase) ,
                    PurchaseD = Purchase / @ExchangeRate ,
                    PurchaseLL = Currencys.f_ExchangeToLL(CurrencyID, Purchase, Purchase / @ExchangeRate) ,
                    PurchaseEuro = Currencys.f_ExchangeToEuro(CurrencyID, Purchase, Purchase / @ExchangeRate) ,
                    PurchaseWithTax = Calculation.Rate(Purchase, TaxRate)
            WHERE   ID = @ItemSharedFatherID;

            UPDATE  Items.t_ItemShared
            SET     PurchaseWithTaxF = Currencys.f_Format(CurrencyID, PurchaseWithTax) ,
                    PurchaseWithTaxD = PurchaseWithTax / @ExchangeRate ,
                    PurchaseWithTaxLL = Currencys.f_ExchangeToLL(CurrencyID, PurchaseWithTax, PurchaseWithTax / @ExchangeRate) ,
                    PurchaseWithTaxEuro = Currencys.f_ExchangeToEuro(CurrencyID, PurchaseWithTax, PurchaseWithTax / @ExchangeRate)
            WHERE   ID = @ItemSharedFatherID;

        END;

        BEGIN --Rebuilding statistics

            UPDATE  Items.t_ItemShared
            SET     PurchaseTotal = Purchase * QtyCurrent ,
                    PurchaseTotalF = Currencys.f_Format(CurrencyID, Purchase * QtyCurrent) ,
                    PurchaseTotalD = PurchaseD * QtyCurrent ,
                    PurchaseTotalLL = PurchaseLL * QtyCurrent ,
                    PurchaseTotalEuro = PurchaseEuro * QtyCurrent ,
                    PurchaseTotalWithTax = PurchaseWithTax * QtyCurrent ,
                    PurchaseTotalWithTaxF = Currencys.f_Format(CurrencyID, PurchaseWithTax * QtyCurrent) ,
                    PurchaseTotalWithTaxD = PurchaseWithTaxD * QtyCurrent ,
                    PurchaseTotalWithTaxLL = PurchaseWithTaxLL * QtyCurrent ,
                    PurchaseTotalWithTaxEuro = PurchaseWithTaxEuro * QtyCurrent ,
                    MaterialsNames = Alls.f_FixXML(( SELECT N', ' + t1.Name AS [text()]
                                                     FROM   Items.t_ItemSharedMaterial AS t
                                                            LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
                                                     WHERE  t.ItemSharedFatherID = t_ItemShared.ID
                                                   FOR
                                                     XML PATH('')
                                                   )) ,
                    MaterialsCounts = ( SELECT  COUNT(t.ID)
                                        FROM    Items.t_ItemSharedMaterial AS t
                                        WHERE   t.ItemSharedFatherID = t_ItemShared.ID
                                      )
            WHERE   ID = @ItemSharedFatherID;

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
                      @ItemSharedFatherID ,
                      @Event ,
                      1 ,
                      @ComputerIP ,
                      @Computer ,
                      @ComputerAccount
                    );

        END;

        COMMIT TRANSACTION;

        SELECT  1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        SELECT  @Return;

    END CATCH;

END;





GO
