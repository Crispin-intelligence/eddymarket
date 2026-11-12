SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Customers].[s_FrameJobOrderHistoryRebuildingStatistics]
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

        DISABLE TRIGGER Customers.tr_FrameJobOrderHistory ON Customers.t_FrameJobOrderHistory;
        DISABLE TRIGGER Customers.tr_FrameJobOrderHistoryDetail ON Customers.t_FrameJobOrderHistoryDetail;

        BEGIN --Rebuild statistics

            SET @Return = 0;

            UPDATE  Customers.t_FrameJobOrderHistory
            SET     RefF = FORMAT(Ref, 'n0') ,
                    Customer = Customers.f_CustomerGetName(CustomerID) ,
                    Doctor = Company.f_DoctorGetName(DoctorID) ,
                    Salesperson = Employees.f_SalesPersonGetName(SalespersonID) ,
                    StatesIs = Location.f_StatesGetName(StatesID) ,
                    RegionIs = Location.f_RegionGetName(RegionID) ,
                    Street = Location.f_StreetGetName(StreetID) ,
                    Currency = Currencys.f_CurrencyGetName(CurrencyID) ,
                    SubTotalF = Currencys.f_Format(CurrencyID, SubTotal) ,
                    DiscountIsF = Currencys.f_Format(CurrencyID, DiscountIs) ,
                    TaxRateF = N'0 %' ,
                    TaxValueF = Currencys.f_Format(CurrencyID, TaxValue) ,
                    TotalF = Currencys.f_Format(CurrencyID, Total) ,
                    PaymentF = Currencys.f_Format(CurrencyID, Payment) ,
                    RestF = Currencys.f_Format(CurrencyID, Rest) ,
                    CostF = Currencys.f_Format(CurrencyID, Cost) ,
                    ProfitF = Currencys.f_Format(CurrencyID, Profit) ,
                    ItemsNames = Alls.f_FixXML(( SELECT DISTINCT
                                                        ', ' + t1.Name AS [text()]
                                                 FROM   Customers.t_FrameJobOrderHistoryDetail AS t
                                                        LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
                                                 WHERE  t.FrameJobOrderHistoryID = t_FrameJobOrderHistory.ID
                                               FOR
                                                 XML PATH('')
                                               ));

            UPDATE  Customers.t_FrameJobOrderHistory
            SET     AddressIs = Location.f_ConcetFullAddress(StatesIs, RegionIs, Street, N'', N'', N'', N'', ' - ', '-');

            UPDATE  Customers.t_FrameJobOrderHistory
            SET     TaxRateF = FORMAT(( TaxValue / ( Total - TaxValue ) ) * 100.0, '0.##') + N' %'
            WHERE   Total > 0;

            WITH    o AS ( SELECT   s.Sale ,
                                    s.SaleF ,
                                    s.DiscountIs ,
                                    s.DiscountIsF ,
                                    s.DiscountIsValue ,
                                    s.DiscountIsValueF ,
                                    s.SubTotal ,
                                    s.SubTotalF ,
                                    s.DiscountOrder ,
                                    s.DiscountOrderF ,
                                    s.TaxRate ,
                                    s.TaxRateF ,
                                    s.TaxValue ,
                                    s.Total ,
                                    s.TotalF ,
                                    s.Cost ,
                                    s.CostF ,
                                    s.TotalCost ,
                                    s.TotalCostF ,
                                    s.Profit ,
                                    s.ProfitF ,
                                    s.ProfitTotal ,
                                    s.ProfitTotalF ,
                                    s1.CurrencyID ,
                                    s.Qty ,
                                    s.Qtys ,
                                    s.QtyWithUnity ,
                                    s3.Name AS Unity
                           FROM     Customers.t_FrameJobOrderHistoryDetail AS s
                                    LEFT JOIN Customers.t_FrameJobOrderHistory AS s1 ON s1.ID = s.FrameJobOrderHistoryID
                                    LEFT JOIN Items.t_UnityItem AS s2 ON s2.ID = s.ItemUnityID
                                    LEFT JOIN Items.t_Unity AS s3 ON s3.ID = s2.UnityID
                         )
                UPDATE  o
                SET     o.SaleF = Currencys.f_Format(o.CurrencyID, o.Sale) ,
                        o.DiscountIsF = FORMAT(o.DiscountIs, '0.##') + ' %' ,
                        o.DiscountIsValueF = Currencys.f_Format(o.CurrencyID, o.DiscountIsValue) ,
                        o.SubTotalF = Currencys.f_Format(o.CurrencyID, o.SubTotal) ,
                        o.DiscountOrderF = Currencys.f_Format(o.CurrencyID, o.DiscountOrder) ,
                        o.TaxRateF = FORMAT(o.TaxRate, '0.##') + ' %' ,
                        o.TotalF = Currencys.f_Format(o.CurrencyID, o.Total) ,
                        o.CostF = Currencys.f_Format(o.CurrencyID, o.Cost) ,
                        o.TotalCostF = Currencys.f_Format(o.CurrencyID, o.TotalCost) ,
                        o.ProfitF = Currencys.f_Format(o.CurrencyID, o.Profit) ,
                        o.ProfitTotalF = Currencys.f_Format(o.CurrencyID, o.ProfitTotal) ,
                        o.QtyWithUnity = FORMAT(o.Qty, '#,##0.####') + ' ' + o.Unity;

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT  INTO Customers.t_FrameJobOrderMoving
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
            SET     VersionLive = STUFF(VersionLive, FrameJobOrder, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
                    SchemasIs = STUFF(SchemasIs, SchemaCustomer, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

        END;

        ENABLE TRIGGER Customers.tr_FrameJobOrderHistory ON Customers.t_FrameJobOrderHistory;
        ENABLE TRIGGER Customers.tr_FrameJobOrderHistoryDetail ON Customers.t_FrameJobOrderHistoryDetail;

        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @Return;

    END CATCH;

END;






GO
