SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_ItemSharedMaterialUpdate]
    @ItemUnityID UNIQUEIDENTIFIER ,
    @Qty DECIMAL(18, 4) ,
    @Qtys DECIMAL(18, 4) ,
    @DescriptionIs NVARCHAR(MAX) ,
    @UserID UNIQUEIDENTIFIER ,
    @Event NVARCHAR(MAX) ,
    @ComputerIP NVARCHAR(MAX) ,
    @Computer NVARCHAR(MAX) ,
    @ComputerAccount NVARCHAR(MAX) ,
    @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @CurrencyID UNIQUEIDENTIFIER ,
                @CurrencyType TINYINT ,
                @ExchangeRate DECIMAL(18, 2) ,
                @Return INT ,
                @ItemSharedFatherID UNIQUEIDENTIFIER;

        END;

        BEGIN --Set info

            SELECT TOP ( 1 )
                    @ItemSharedFatherID = s.ItemSharedFatherID
            FROM    Items.t_ItemSharedMaterial AS s
            WHERE   s.ID = @ID
            ORDER BY s.ID;

            SELECT TOP ( 1 )
                    @CurrencyID = s.CurrencyID
            FROM    Items.t_ItemShared AS s
            WHERE   s.ID = @ItemSharedFatherID;

            SET @CurrencyType = [Currencys].[f_CurrencyGetTypeIs](@CurrencyID);
            SET @ExchangeRate = [Currencys].[f_CurrencyGetExchangeRate](@CurrencyID);

        END;

        BEGIN --Update

            SET @Return = 0;

            UPDATE  Items.t_ItemSharedMaterial
            SET     ItemUnityID = @ItemUnityID ,
                    Qty = @Qty ,
                    QtyWithUnity = FORMAT(@Qty, '#,##0.####') + ' ' + Items.f_UnityItemGetName(@ItemUnityID) ,
                    Qtys = @Qtys ,
                    DescriptionIs = @DescriptionIs
            WHERE   ID = @ID;

        END;

        BEGIN --t_ItemSharedMaterial

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
                    PurchaseWithTaxEuro = Currencys.f_ExchangeToEuro(CurrencyID, PurchaseWithTax, PurchaseWithTax / @ExchangeRate) ,
                    PurchaseTotal = Purchase * QtyCurrent ,
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
                                                   ))
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

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @Return;

    END CATCH;

END;











GO
