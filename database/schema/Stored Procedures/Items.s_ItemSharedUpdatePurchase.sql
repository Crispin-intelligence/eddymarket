SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_ItemSharedUpdatePurchase]
    @UserID UNIQUEIDENTIFIER ,
    @ComputerIP NVARCHAR(MAX) ,
    @Computer NVARCHAR(MAX) ,
    @ComputerAccount NVARCHAR(MAX) ,
    @Items Items.[tt_ItemSharedEditCost] READONLY
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Items_ AS TABLE
                (
                  [ID] [UNIQUEIDENTIFIER] NOT NULL ,
                  [Cost] [FLOAT] NOT NULL ,
                  [CurrencyID] [UNIQUEIDENTIFIER] NOT NULL ,
                  [Currency] NVARCHAR(MAX) NOT NULL ,
                  ExchangeRate DECIMAL(18, 2) NOT NULL ,
                  [Discount] [DECIMAL](4, 2) NOT NULL ,
                  TaxRate [DECIMAL](4, 2) NOT NULL
                );

            DECLARE @Return INT ,
                @ExchangeRateLL DECIMAL(18, 2) ,
                @ExchangeRateEuro DECIMAL(18, 2);

        END;

        BEGIN --Set info

            INSERT  INTO @Items_
                    ( ID ,
                      Cost ,
                      CurrencyID ,
                      Currency ,
                      ExchangeRate ,
                      TaxRate ,
                      Discount
                    )
                    SELECT  s.ID ,
                            s.Cost ,
                            s.CurrencyID ,
                            s1.Name ,
                            s1.ExchangeRate ,
                            s.TaxRate ,
                            s.Discount
                    FROM    @Items AS s
                            LEFT JOIN Currencys.t_Currency AS s1 ON s1.ID = s.CurrencyID;

            SET @ExchangeRateLL = Currencys.f_CurrencyGetExchangeRateLL();

            SET @ExchangeRateEuro = Currencys.f_CurrencyGetExchangeRateEuro();

        END;

        BEGIN --Update 

            SET @Return = 0;

            MERGE Items.t_ItemShared AS t
            USING @Items_ AS s
            ON s.ID = t.ID
            WHEN MATCHED THEN
                UPDATE SET
                         t.CurrencyID = s.CurrencyID ,
                         t.Currency = s.Currency ,
                         t.Purchase = s.Cost - ( ( s.Cost / ( 100.0 + s.TaxRate ) ) * s.TaxRate ) ,
                         t.PurchaseWithTax = s.Cost ,
                         t.Discount = s.Discount ,
                         t.DiscountF = Currencys.f_FormatRate(s.Discount) ,
                         t.TaxRate = s.TaxRate;

            MERGE Items.t_ItemShared AS t
            USING @Items_ AS s
            ON s.ID = t.ID
            WHEN MATCHED THEN
                UPDATE SET
                         t.PurchaseF = Currencys.f_Format(s.CurrencyID, t.Purchase) ,
                         t.PurchaseD = t.Purchase / s.ExchangeRate ,
                         t.PurchaseLL = ( t.Purchase / s.ExchangeRate ) * @ExchangeRateLL ,
                         t.PurchaseEuro = ( t.Purchase / s.ExchangeRate ) * @ExchangeRateEuro ,
                         t.PurchaseWithTaxF = Currencys.f_Format(s.CurrencyID, t.PurchaseWithTax) ,
                         t.PurchaseWithTaxD = t.PurchaseWithTax / s.ExchangeRate ,
                         t.PurchaseWithTaxLL = ( t.PurchaseWithTax / s.ExchangeRate ) * @ExchangeRateLL ,
                         t.PurchaseWithTaxEuro = ( t.PurchaseWithTax / s.ExchangeRate ) * @ExchangeRateEuro;

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
                    PurchaseTotalWithTaxEuro = PurchaseWithTaxEuro * QtyCurrent
            WHERE   EXISTS ( SELECT TOP ( 1 )
                                    s.ID
                             FROM   @Items AS s
                             WHERE  s.ID = t_ItemShared.ID );

        END;

        IF EXISTS ( SELECT TOP ( 1 ) --t_ItemSharedMaterial
                            s.ID
                    FROM    Items.t_ItemSharedMaterial AS s
                    WHERE   EXISTS ( SELECT TOP ( 1 )
                                            ss.ID
                                     FROM   @Items AS ss
                                     WHERE  ss.ID = s.ItemSharedID ) )
        BEGIN
		  
            DECLARE @MaterialItemSharedFatherIDs AS TABLE ( ID UNIQUEIDENTIFIER );

            INSERT  @MaterialItemSharedFatherIDs
                    ( ID
                    )
                    SELECT  s.ItemSharedFatherID
                    FROM    Items.t_ItemSharedMaterial AS s
                    WHERE   EXISTS ( SELECT TOP ( 1 )
                                            ss.ID
                                     FROM   @Items AS ss
                                     WHERE  ss.ID = s.ItemSharedID );

            UPDATE  Items.t_ItemShared
            SET     Purchase = ( SELECT COALESCE(SUM(CASE Currencys.f_CurrencyGetTypeIs(s1.CurrencyID)
                                                       WHEN 0 THEN s1.PurchaseD * s.Qtys
                                                       WHEN 1 THEN s1.PurchaseLL * s.Qtys
                                                       ELSE s1.PurchaseEuro * s.Qtys
                                                     END), 0)
                                 FROM   Items.t_ItemSharedMaterial AS s
                                        LEFT JOIN Items.t_ItemShared AS s1 ON s1.ID = s.ItemSharedID
                                 WHERE  s.ItemSharedFatherID = t_ItemShared.ID
                               )
            WHERE   EXISTS ( SELECT TOP ( 1 )
                                    s.ID
                             FROM   @MaterialItemSharedFatherIDs AS s
                             WHERE  s.ID = t_ItemShared.ID );

            WITH    o AS ( SELECT   s.ID ,
                                    s.CurrencyID ,
                                    s.Purchase ,
                                    s.PurchaseD ,
                                    s.PurchaseLL ,
                                    s.PurchaseEuro ,
                                    s.PurchaseWithTax ,
                                    Calculation.Rate(s.Purchase, s.TaxRate) AS PurchaseWithTax_ ,
                                    s.PurchaseWithTaxD ,
                                    s.PurchaseWithTaxLL ,
                                    s.PurchaseWithTaxEuro ,
                                    s1.ExchangeRate
                           FROM     Items.t_ItemShared AS s
                                    LEFT JOIN Currencys.t_Currency AS s1 ON s1.ID = s.CurrencyID
                           WHERE    EXISTS ( SELECT TOP ( 1 )
                                                    ss.ID
                                             FROM   @MaterialItemSharedFatherIDs AS ss
                                             WHERE  ss.ID = s.ID )
                         )
                UPDATE  o
                SET     o.PurchaseD = o.Purchase / o.ExchangeRate ,
                        o.PurchaseLL = Currencys.f_ExchangeToLL(o.CurrencyID, o.Purchase, o.Purchase / o.ExchangeRate) ,
                        o.PurchaseEuro = Currencys.f_ExchangeToEuro(o.CurrencyID, o.Purchase, o.Purchase / o.ExchangeRate) ,
                        o.PurchaseWithTax = o.PurchaseWithTax_ ,
                        o.PurchaseWithTaxD = o.PurchaseWithTax_ / o.ExchangeRate ,
                        o.PurchaseWithTaxLL = Currencys.f_ExchangeToLL(o.CurrencyID, o.PurchaseWithTax_, o.PurchaseWithTax_ / o.ExchangeRate) ,
                        o.PurchaseWithTaxEuro = Currencys.f_ExchangeToEuro(o.CurrencyID, o.PurchaseWithTax_, o.PurchaseWithTax_ / o.ExchangeRate)
                WHERE   EXISTS ( SELECT TOP ( 1 )
                                        s.ID
                                 FROM   @MaterialItemSharedFatherIDs AS s
                                 WHERE  s.ID = o.ID );

            UPDATE  Items.t_ItemShared
            SET     PurchaseF = Currencys.f_Format(CurrencyID, Purchase) ,
                    PurchaseWithTaxF = Currencys.f_Format(CurrencyID, PurchaseWithTax) ,
                    PurchaseTotal = Purchase * QtyCurrent ,
                    PurchaseTotalF = Currencys.f_Format(CurrencyID, Purchase * QtyCurrent) ,
                    PurchaseTotalD = PurchaseD * QtyCurrent ,
                    PurchaseTotalLL = PurchaseLL * QtyCurrent ,
                    PurchaseTotalEuro = PurchaseEuro * QtyCurrent ,
                    PurchaseTotalWithTax = PurchaseWithTax * QtyCurrent ,
                    PurchaseTotalWithTaxF = Currencys.f_Format(CurrencyID, PurchaseWithTax * QtyCurrent) ,
                    PurchaseTotalWithTaxD = PurchaseWithTaxD * QtyCurrent ,
                    PurchaseTotalWithTaxLL = PurchaseWithTaxLL * QtyCurrent ,
                    PurchaseTotalWithTaxEuro = PurchaseWithTaxEuro * QtyCurrent
            WHERE   EXISTS ( SELECT TOP ( 1 )
                                    s.ID
                             FROM   @MaterialItemSharedFatherIDs AS s
                             WHERE  s.ID = t_ItemShared.ID );

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
                    SELECT  @UserID ,
                            s.ID ,
                            s.EventIs ,
                            1 ,
                            @ComputerIP ,
                            @Computer ,
                            @ComputerAccount
                    FROM    @Items AS s;

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
