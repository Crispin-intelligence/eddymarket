SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Items].[s_ItemSharedUpdateSaleToCurrency]
    @CurrencyID UNIQUEIDENTIFIER ,
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

                DECLARE @Return INT ,
                    @Currency NVARCHAR(MAX) ,
                    @CurrencyTypeIs INT ,
                    @ExchangeRate DECIMAL(18, 2) ,
                    @ExchangeRateLL DECIMAL(18, 2) ,
                    @ExchangeRateEuro DECIMAL(18, 2);

            END;

            BEGIN --Set info
			    
                SELECT TOP ( 1 )
                        @Currency = s.Name ,
                        @ExchangeRate = s.ExchangeRate ,
                        @CurrencyTypeIs = s.TypeIs
                FROM    Currencys.t_Currency AS s
                WHERE   s.ID = @CurrencyID
                ORDER BY s.ID;

                SET @ExchangeRateLL = Currencys.f_CurrencyGetExchangeRateLL();

                SET @ExchangeRateEuro = Currencys.f_CurrencyGetExchangeRateEuro();

            END;

            BEGIN --Update t_UnityItem

                SET @Return = 0;

                IF ( @CurrencyTypeIs = 0 )
                    BEGIN
				                     
                        UPDATE  Items.t_UnityItem
                        SET     CurrencyID = @CurrencyID ,
                                Currency = Currencys.f_CurrencyGetName(@CurrencyID) ,
                                Price = PriceD ,
                                PriceWithTax = PriceWithTaxD
                        WHERE   EXISTS ( SELECT TOP ( 1 )
                                                s.ID
                                         FROM   @IDs AS s
                                         WHERE  s.ID = t_UnityItem.SharedID );

                    END;
                ELSE
                    IF ( @CurrencyTypeIs = 1 )
                        BEGIN
				                     
                            UPDATE  Items.t_UnityItem
                            SET     CurrencyID = @CurrencyID ,
                                    Currency = Currencys.f_CurrencyGetName(@CurrencyID) ,
                                    Price = PriceLL ,
                                    PriceWithTax = PriceWithTaxLL
                            WHERE   EXISTS ( SELECT TOP ( 1 )
                                                    s.ID
                                             FROM   @IDs AS s
                                             WHERE  s.ID = t_UnityItem.SharedID );

                        END;
                    ELSE
                        IF ( @CurrencyTypeIs = 2 )
                            BEGIN
				                     
                                UPDATE  Items.t_UnityItem
                                SET     CurrencyID = @CurrencyID ,
                                        Currency = Currencys.f_CurrencyGetName(@CurrencyID) ,
                                        Price = PriceEuro ,
                                        PriceWithTax = PriceWithTaxEuro
                                WHERE   EXISTS ( SELECT TOP ( 1 )
                                                        s.ID
                                                 FROM   @IDs AS s
                                                 WHERE  s.ID = t_UnityItem.SharedID );

                            END;

                UPDATE  Items.t_UnityItem
                SET     PriceF = Currencys.f_Format(CurrencyID, Price) ,
                        PriceD = Price / @ExchangeRate ,
                        PriceLL = ( Price / @ExchangeRate ) * @ExchangeRateLL ,
                        PriceEuro = ( Price / @ExchangeRate )
                        * @ExchangeRateEuro ,
                        PriceWithTaxF = Currencys.f_Format(CurrencyID,
                                                           PriceWithTax) ,
                        PriceWithTaxD = PriceWithTax / @ExchangeRate ,
                        PriceWithTaxLL = ( PriceWithTax / @ExchangeRate )
                        * @ExchangeRateLL ,
                        PriceWithTaxEuro = ( PriceWithTax / @ExchangeRate )
                        * @ExchangeRateEuro
                WHERE   EXISTS ( SELECT TOP ( 1 )
                                        s.ID
                                 FROM   @IDs AS s
                                 WHERE  s.ID = t_UnityItem.SharedID );

            END;

            BEGIN --Update t_ItemShared

                WITH    o AS ( SELECT   s.CurrencyID AS SellCurrencyID_ ,
                                        s.Currency AS SellCurrency_ ,
                                        s.Price AS Price_ ,
                                        s.PriceF AS PriceF_ ,
                                        s.PriceD AS PriceD_ ,
                                        s.PriceLL AS PriceLL_ ,
                                        s.PriceEuro AS PriceEuro_ ,
                                        s.PriceWithTax AS PriceWithTax_ ,
                                        s.PriceWithTaxF AS PriceWithTaxF_ ,
                                        s.PriceWithTaxD AS PriceWithTaxD_ ,
                                        s.PriceWithTaxLL AS PriceWithTaxLL_ ,
                                        s.PriceWithTaxEuro AS PriceWithTaxEuro_ ,
                                        s1.SellCurrencyID ,
                                        s1.SellCurrency ,
                                        s1.Sell ,
                                        s1.SellF ,
                                        s1.SellD ,
                                        s1.SellLL ,
                                        s1.SellEuro ,
                                        s1.SellWithTax ,
                                        s1.SellWithTaxF ,
                                        s1.SellWithTaxD ,
                                        s1.SellWithTaxLL ,
                                        s1.SellWithTaxEuro
                               FROM     Items.t_UnityItem AS s
                                        INNER JOIN Items.t_ItemShared AS s1 ON s1.ID = s.SharedID
                               WHERE    s.PrimaryIs = 1
                                        AND s.Qty = 1
                                        AND EXISTS ( SELECT TOP ( 1 )
                                                            ss.ID
                                                     FROM   @IDs AS ss
                                                     WHERE  ss.ID = s.SharedID )
                             )
                    UPDATE  o
                    SET     o.SellCurrencyID = o.SellCurrencyID_ ,
                            o.SellCurrency = o.SellCurrency_ ,
                            o.Sell = o.Price_ ,
                            o.SellF = o.PriceF_ ,
                            o.SellD = o.PriceD_ ,
                            o.SellLL = o.PriceLL_ ,
                            o.SellEuro = o.PriceEuro_ ,
                            o.SellWithTax = o.PriceWithTax_ ,
                            o.SellWithTaxF = o.PriceWithTaxF_ ,
                            o.SellWithTaxD = o.PriceWithTaxD_ ,
                            o.SellWithTaxLL = o.PriceWithTaxLL_ ,
                            o.SellWithTaxEuro = o.PriceWithTaxEuro_;

            END;

            BEGIN --Rebuilding statistics
			
                UPDATE  Items.t_ItemShared
                SET     SellTotal = Sell * QtyCurrent ,
                        SellTotalF = Currencys.f_Format(SellCurrencyID,
                                                        Sell * QtyCurrent) ,
                        SellTotalD = SellD * QtyCurrent ,
                        SellTotalLL = SellLL * QtyCurrent ,
                        SellTotalEuro = SellEuro * QtyCurrent ,
                        SellTotalWithTax = SellWithTax * QtyCurrent ,
                        SellTotalWithTaxF = Currencys.f_Format(SellCurrencyID,
                                                              SellWithTax
                                                              * QtyCurrent) ,
                        SellTotalWithTaxD = SellWithTaxD * QtyCurrent ,
                        SellTotalWithTaxLL = SellWithTaxLL * QtyCurrent ,
                        SellTotalWithTaxEuro = SellWithTaxEuro * QtyCurrent
                WHERE   EXISTS ( SELECT TOP ( 1 )
                                        s.ID
                                 FROM   @IDs AS s
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
