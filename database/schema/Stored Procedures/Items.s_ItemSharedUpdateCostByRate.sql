SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_ItemSharedUpdateCostByRate]
    @IncreaseRate DECIMAL(5, 2) ,
    @UserID UNIQUEIDENTIFIER ,
    @Event NVARCHAR(MAX) ,
    @ComputerIP NVARCHAR(MAX) ,
    @Computer NVARCHAR(MAX) ,
    @ComputerAccount NVARCHAR(MAX) ,
    @IDs Alls.tt_Guid READONLY
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        BEGIN --Update 

            SET @Return = 0;

            UPDATE  Items.t_ItemShared
            SET     Purchase = Calculation.Rate(PurchaseWithTax, @IncreaseRate) - ( ( Calculation.Rate(PurchaseWithTax, @IncreaseRate) / ( 100.0 + TaxRate ) ) * TaxRate ) ,
                    PurchaseWithTax = Calculation.Rate(PurchaseWithTax, @IncreaseRate)
            WHERE   EXISTS ( SELECT TOP ( 1 )
                                    s.ID
                             FROM   @IDs AS s
                             WHERE  s.ID = t_ItemShared.ID );

            WITH    o AS ( SELECT   s.CurrencyID ,
                                    s.Purchase ,
                                    s.PurchaseD ,
                                    s.PurchaseLL ,
                                    s.PurchaseEuro ,
                                    s.PurchaseWithTax ,
                                    s.PurchaseWithTaxD ,
                                    s.PurchaseWithTaxLL ,
                                    s.PurchaseWithTaxEuro ,
                                    s1.ExchangeRate
                           FROM     Items.t_ItemShared AS s
                                    LEFT JOIN Currencys.t_Currency AS s1 ON s1.ID = s.CurrencyID
                           WHERE    EXISTS ( SELECT TOP ( 1 )
                                                    s2.ID
                                             FROM   @IDs AS s2
                                             WHERE  s2.ID = s.ID )
                         )
                UPDATE  o
                SET     o.PurchaseD = o.Purchase / o.ExchangeRate ,
                        o.PurchaseLL = Currencys.f_ExchangeToLL(o.CurrencyID, o.Purchase, o.Purchase / o.ExchangeRate) ,
                        o.PurchaseEuro = Currencys.f_ExchangeToEuro(o.CurrencyID, o.Purchase, o.Purchase / o.ExchangeRate) ,
                        o.PurchaseWithTaxD = o.PurchaseWithTax / o.ExchangeRate ,
                        o.PurchaseWithTaxLL = Currencys.f_ExchangeToLL(o.CurrencyID, o.PurchaseWithTax, o.PurchaseWithTax / o.ExchangeRate) ,
                        o.PurchaseWithTaxEuro = Currencys.f_ExchangeToEuro(o.CurrencyID, o.PurchaseWithTax, o.PurchaseWithTax / o.ExchangeRate);

            UPDATE  Items.t_ItemShared
            SET     PurchaseF = Currencys.f_Format(CurrencyID, Purchase) ,
                    PurchaseTotal = QtyCurrent * Purchase ,
                    PurchaseTotalF = Currencys.f_Format(CurrencyID, QtyCurrent * Purchase) ,
                    PurchaseTotalD = PurchaseD * QtyCurrent ,
                    PurchaseTotalLL = PurchaseLL * QtyCurrent ,
                    PurchaseTotalEuro = PurchaseEuro * QtyCurrent ,
                    PurchaseWithTaxF = Currencys.f_Format(CurrencyID, PurchaseWithTax) ,
                    PurchaseTotalWithTax = QtyCurrent * PurchaseWithTax ,
                    PurchaseTotalWithTaxF = Currencys.f_Format(CurrencyID, QtyCurrent * PurchaseWithTax) ,
                    PurchaseTotalWithTaxD = PurchaseWithTaxD * QtyCurrent ,
                    PurchaseTotalWithTaxLL = PurchaseWithTaxLL * QtyCurrent ,
                    PurchaseTotalWithTaxEuro = PurchaseWithTaxEuro * QtyCurrent
            WHERE   EXISTS ( SELECT TOP ( 1 )
                                    s.ID
                             FROM   @IDs AS s
                             WHERE  s.ID = t_ItemShared.ID );

        END;

        IF EXISTS ( SELECT TOP ( 1 ) --t_ItemSharedMaterial
                            s.ID
                    FROM    Items.t_ItemSharedMaterial AS s
                    WHERE   EXISTS ( SELECT TOP ( 1 )
                                            ss.ID
                                     FROM   @IDs AS ss
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
                                     FROM   @IDs AS ss
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
                            REPLACE(@Event, '{0}', s1.Name) ,
                            1 ,
                            @ComputerIP ,
                            @Computer ,
                            @ComputerAccount
                    FROM    @IDs AS s
                            LEFT JOIN Items.t_ItemShared AS s1 ON s1.ID = s.ID;

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
