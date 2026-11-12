SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_PurchasingRebuildingStatistics]
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

            DISABLE TRIGGER Invoices.tr_Purchasing ON Invoices.t_Purchasing;

            DISABLE TRIGGER Invoices.tr_PurchasingDetail ON Invoices.t_PurchasingDetail;

            BEGIN --Rebuild statistics

                SET @Return = 0;

                UPDATE  Invoices.t_Purchasing
                SET     RefF = FORMAT(Ref, 'n0') ,
                        UserIs = Users.f_UserGetName(UserID) ,
                        AccountVendor = Company.f_AccountGetName(AccountVendorID) ,
                        AccountBox = Company.f_AccountGetName(AccountBoxID) ,
                        Currency = Currencys.f_CurrencyGetName(CurrencyID) ,
                        TotalF = Currencys.f_Format(CurrencyID, Total) ,
                        DiscountIsF = Currencys.f_Format(CurrencyID, DiscountIs) ,
                        TaxValueF = Currencys.f_Format(CurrencyID, TaxValue) ,
                        NetIsF = Currencys.f_Format(CurrencyID, NetIs) ,
                        NetIsAR = Currencys.f_ToWordAR(NetIs, CurrencyID, 1) ,
                        NetIsEN = Currencys.f_ToWordEN(NetIs, CurrencyID, 1) ,
                        ProfitF = Currencys.f_Format(CurrencyID, Profit) ,
                        FirstPaymentF = Currencys.f_Format(CurrencyID, FirstPayment) ,
                        SellF = Currencys.f_Format(CurrencyID, Sell) ,
                        ItemsNames = Alls.f_FixXML(( SELECT DISTINCT
                                                            ', ' + t1.Name AS [text()]
                                                     FROM   Invoices.t_PurchasingDetail AS t
                                                            LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
                                                     WHERE  t.PurchasingID = t_Purchasing.ID
                                                   FOR
                                                     XML PATH('')
                                                   )) ,
                        ItemHaveDiscount = CASE ( SELECT    COALESCE(SUM(s.DiscountIsValue), 0)
                                                  FROM      Invoices.t_PurchasingDetail AS s
                                                  WHERE     s.PurchasingID = t_Purchasing.ID
                                                )
                                             WHEN 0 THEN 0
                                             ELSE 1
                                           END;

                UPDATE  Invoices.t_Purchasing
                SET     TaxRateF = FORMAT(( TaxValue / ( NetIs - TaxValue ) ) * 100.0, '0.##') + N' %'
                WHERE   NetIs > 0;

                WITH    o AS ( SELECT   s.Price ,
                                        s.PriceF ,
                                        s.DiscountIs ,
                                        s.DiscountIsF ,
                                        s.DiscountIsValue ,
                                        s.DiscountIsValueF ,
                                        s.SubTotal ,
                                        s.SubTotalF ,
                                        s.DiscountInvoice ,
                                        s.DiscountInvoiceF ,
                                        s.TaxRate ,
                                        s.TaxRateF ,
                                        s.TaxValue ,
                                        s.Total ,
                                        s.TotalF ,
                                        s.Sell ,
                                        s.SellF ,
                                        s.Profit ,
                                        s.ProfitF ,
                                        s.ProfitTotal ,
                                        s.ProfitTotalF ,
                                        s1.CurrencyID ,
                                        s.Qty ,
                                        s.Qtys ,
                                        s.QtyWithUnity ,
                                        s3.Name AS Unity
                               FROM     Invoices.t_PurchasingDetail AS s
                                        LEFT JOIN Invoices.t_Purchasing AS s1 ON s1.ID = s.PurchasingID
                                        LEFT JOIN Items.t_UnityItem AS s2 ON s2.ID = s.ItemUnityID
                                        LEFT JOIN Items.t_Unity AS s3 ON s3.ID = s2.UnityID
                             )
                    UPDATE  o
                    SET     o.PriceF = Currencys.f_Format(o.CurrencyID, o.Price) ,
                            o.DiscountIsF = FORMAT(o.DiscountIs, '0.##') + ' %' ,
                            o.DiscountIsValueF = Currencys.f_Format(o.CurrencyID, o.DiscountIsValue) ,
                            o.SubTotalF = Currencys.f_Format(o.CurrencyID, o.SubTotal) ,
                            o.DiscountInvoiceF = Currencys.f_Format(o.CurrencyID, o.DiscountInvoice) ,
                            o.TaxRateF = FORMAT(o.TaxRate, '0.##') + ' %' ,
                            o.TotalF = Currencys.f_Format(o.CurrencyID, o.Total) ,
                            o.SellF = Currencys.f_Format(o.CurrencyID, o.Sell) ,
                            o.ProfitF = Currencys.f_Format(o.CurrencyID, o.Profit) ,
                            o.ProfitTotalF = Currencys.f_Format(o.CurrencyID, o.ProfitTotal) ,
                            o.QtyWithUnity = FORMAT(o.Qty, '#,##0.####') + ' ' + o.Unity;

            END;

            BEGIN --Insert event

                SET @Return = -1;

                INSERT  INTO Invoices.t_PurchasingMoving
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

            BEGIN --Live

                UPDATE  Alls.t_LiveVersion
                SET     VersionLive = STUFF(VersionLive, Purchase, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
                        SchemasIs = STUFF(SchemasIs, SchemaInvoice, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

            END;

            ENABLE TRIGGER Invoices.tr_Purchasing ON Invoices.t_Purchasing;

            ENABLE TRIGGER Invoices.tr_PurchasingDetail ON Invoices.t_PurchasingDetail;

            COMMIT TRANSACTION;

            RETURN 1;

        END TRY
        BEGIN CATCH

            ROLLBACK;

            RETURN @Return;

        END CATCH;

    END;



GO
