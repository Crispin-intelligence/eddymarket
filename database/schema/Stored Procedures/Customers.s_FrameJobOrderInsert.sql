SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Customers].[s_FrameJobOrderInsert] @RefPaper NVARCHAR(MAX) ,
  @DateIs DATETIME ,
  @DateDelivery DATETIME ,
  @StatusIs TINYINT ,
  @PriorityLevel TINYINT ,
  @CustomerID UNIQUEIDENTIFIER ,
  @DoctorID UNIQUEIDENTIFIER ,
  @SalespersonID UNIQUEIDENTIFIER ,
  @StatesID UNIQUEIDENTIFIER ,
  @RegionID UNIQUEIDENTIFIER ,
  @StreetID UNIQUEIDENTIFIER ,
  @Focal NVARCHAR(MAX) ,
  @WithRight BIT ,
  @WithLeft BIT ,
  @SphereRight DECIMAL(18, 2) ,
  @SphereLeft DECIMAL(18, 2) ,
  @CylinderRight DECIMAL(18, 2) ,
  @CylinderLeft DECIMAL(18, 2) ,
  @AxisRight INT ,
  @AxisLeft INT ,
  @PrismRight INT ,
  @PrismLeft INT ,
  @BaseRight NVARCHAR(MAX) ,
  @BaseLeft NVARCHAR(MAX) ,
  @Addition DECIMAL(18, 2) ,
  @HeightRight INT ,
  @HeightLeft INT ,
  @PDRight DECIMAL(18, 2) ,
  @PDLeft DECIMAL(18, 2) ,
  @PD DECIMAL(18, 2) ,
  @CurrencyID UNIQUEIDENTIFIER ,
  @ExchangeRate DECIMAL(18, 2) ,
  @ExchangeRateLL DECIMAL(18, 2) ,
  @ExchangeRateEuro DECIMAL(18, 2) ,
  @DiscountIs FLOAT ,
  @CustomerAccountID UNIQUEIDENTIFIER ,
  @BoxID UNIQUEIDENTIFIER ,
  @Payment FLOAT ,
  @DescriptionIs NVARCHAR(MAX) ,
  @DetailIs Customers.tt_FrameJobOrderDetail READONLY ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @ID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
  BEGIN TRY

    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @IDs TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL
        );

      DECLARE @TransactionIDs TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL ,
          RefF NVARCHAR(MAX) NOT NULL
        );

      DECLARE @Ref BIGINT ,
        @RefF NVARCHAR(MAX) ,
        @TransactionID UNIQUEIDENTIFIER ,
        @TransactionRef BIGINT ,
        @LinkType TINYINT = 169 ,
        @CurrencyTypeIsAccountCustomer TINYINT ,
        @CID UNIQUEIDENTIFIER ,
        @E DECIMAL(18, 2) ,
        @ELL DECIMAL(18, 2) ,
        @EEuro DECIMAL(18, 2) ,
        @V FLOAT ,
        @VD FLOAT ,
        @SubTotal FLOAT ,
        @SubTotalD FLOAT ,
        @DiscountIsD FLOAT ,
        @TaxValue FLOAT ,
        @TaxValueD FLOAT ,
        @Total FLOAT ,
        @TotalD FLOAT ,
        @PaymentD FLOAT ,
        @Rest FLOAT ,
        @RestD FLOAT ,
        @CustomerAccount NVARCHAR(MAX) ,
        @Box NVARCHAR(MAX) ,
        @Cost FLOAT ,
        @CostD FLOAT ,
        @Profit FLOAT ,
        @ProfitD FLOAT ,
        @Qtys DECIMAL(18, 4) ,
        @ItemsNames NVARCHAR(MAX) ,
        @StatesIs NVARCHAR(MAX) ,
        @RegionIs NVARCHAR(MAX) ,
        @Street NVARCHAR(MAX) ,
        @AddressIs NVARCHAR(MAX) ,
        @User NVARCHAR(MAX) ,
        @return INT;

    END;

    BEGIN --Set info

      SELECT @Ref = ISNULL(MAX(s.Ref), 0) + 1
        FROM ( SELECT t.Ref
                FROM Customers.t_FrameJobOrder AS t
               UNION ALL
               SELECT t.Ref
                FROM Customers.t_FrameJobOrderHistory AS t
             ) AS s;

      SET @RefF = FORMAT(@Ref, 'n0');

      SELECT @SubTotal = COALESCE(SUM(s.SubTotal), 0) ,
          @TaxValue = COALESCE(SUM(s.TaxValue), 0) ,
          @Total = COALESCE(SUM(s.Total), 0) ,
          @Cost = COALESCE(SUM(s.Cost), 0) ,
          @Profit = COALESCE(SUM(s.Profit), 0) ,
          @Qtys = COALESCE(SUM(s.Qtys), 0)
        FROM @DetailIs AS s;
			 
      SET @CustomerAccount = Company.f_AccountGetName(@CustomerAccountID);
      SET @Box = Company.f_AccountGetName(@BoxID);

      SET @SubTotalD = @SubTotal / @ExchangeRate;
      SET @DiscountIsD = @DiscountIs / @ExchangeRate;
      SET @TaxValueD = @TaxValue / @ExchangeRate;
      SET @TotalD = @Total / @ExchangeRate;
      SET @PaymentD = @Payment / @ExchangeRate;
      SET @Rest = @Total - @Payment;
      SET @RestD = @Rest / @ExchangeRate;
      SET @CostD = @Cost / @ExchangeRate;
      SET @ProfitD = @Profit / @ExchangeRate;
			
      SET @StatesIs = Location.f_StatesGetName(@StatesID); 
      SET @RegionIs = Location.f_RegionGetName(@RegionID); 
      SET @Street = Location.f_StreetGetName(@StreetID); 
      SET @AddressIs = Location.f_ConcetFullAddress(@StatesIs, @RegionIs, @Street, N'', N'', N'', N'', ' - ', '-');
           
      SET @User = Users.f_UserGetName(@UserID);

      SET @ItemsNames = Alls.f_FixXML(( SELECT DISTINCT ', ' + t1.Name AS [text()]
                                          FROM @DetailIs AS t
                                            LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
                                      FOR
                                        XML PATH('')
                                      ));
     
      SELECT TOP ( 1 ) @CurrencyTypeIsAccountCustomer = s.CurrencyTypeIs
        FROM Company.t_Account AS s
        WHERE s.LinkWithID = @CustomerID AND s.IsMasterLink = 1 AND s.SectionID = 15
        ORDER BY s.ID; 

    END;

    BEGIN --Insert

      SET @return = 0;

      INSERT INTO Customers.t_FrameJobOrder
          ( Ref ,
            RefF ,
            RefPaper ,
            DateIs ,
            DateDelivery ,
            StatusIs ,
            PriorityLevel ,
            CustomerID ,
            Customer ,
            DoctorID ,
            Doctor ,
            SalespersonID ,
            Salesperson ,
            StatesID ,
            StatesIs ,
            RegionID ,
            RegionIs ,
            StreetID ,
            Street ,
            AddressIs ,
            Focal ,
            WithRight ,
            WithLeft ,
            SphereRight ,
            SphereLeft ,
            CylinderRight ,
            CylinderLeft ,
            AxisRight ,
            AxisLeft ,
            PrismRight ,
            PrismLeft ,
            BaseRight ,
            BaseLeft ,
            Addition ,
            HeightRight ,
            HeightLeft ,
            PDRight ,
            PDLeft ,
            PD ,
            CurrencyID ,
            Currency ,
            ExchangeRate ,
            ExchangeRateLL ,
            ExchangeRateEuro ,
            SubTotal ,
            SubTotalF ,
            SubTotalD ,
            SubTotalLL ,
            SubTotalEuro ,
            DiscountIs ,
            DiscountIsF ,
            DiscountIsD ,
            DiscountIsLL ,
            DiscountIsEuro ,
            TaxValue ,
            TaxValueF ,
            TaxValueD ,
            TaxValueLL ,
            TaxValueEuro ,
            Total ,
            TotalF ,
            TotalD ,
            TotalLL ,
            TotalEuro ,
            Payment ,
            PaymentF ,
            PaymentD ,
            PaymentLL ,
            PaymentEuro ,
            Rest ,
            RestF ,
            RestD ,
            RestLL ,
            RestEuro ,
            Cost ,
            CostF ,
            CostD ,
            CostLL ,
            CostEuro ,
            Profit ,
            ProfitF ,
            ProfitD ,
            ProfitLL ,
            ProfitEuro ,
            Qtys ,
            ItemsNames ,
            DescriptionIs
          )
        OUTPUT Inserted.ID
          INTO @IDs ( ID )
        VALUES
          ( @Ref ,
            @RefF ,
            @RefPaper ,
            @DateIs ,
            @DateDelivery ,
            @StatusIs ,
            @PriorityLevel ,
            @CustomerID ,
            Customers.f_CustomerGetName(@CustomerID) ,
            @DoctorID ,
            Company.f_DoctorGetName(@DoctorID) ,
            @SalespersonID ,
            Employees.f_SalesPersonGetName(@SalespersonID) ,
            @StatesID ,
            @StatesIs ,
            @RegionID ,
            @RegionIs ,
            @StreetID ,
            @Street ,
            @AddressIs ,
            @Focal ,
            @WithRight ,
            @WithLeft ,
            @SphereRight ,
            @SphereLeft ,
            @CylinderRight ,
            @CylinderLeft ,
            @AxisRight ,
            @AxisLeft ,
            @PrismRight ,
            @PrismLeft ,
            @BaseRight ,
            @BaseLeft ,
            @Addition ,
            @HeightRight ,
            @HeightLeft ,
            @PDRight ,
            @PDLeft ,
            @PD ,
            @CurrencyID ,
            Currencys.f_CurrencyGetName(@CurrencyID) ,
            @ExchangeRate ,
            @ExchangeRateLL ,
            @ExchangeRateEuro ,
            @SubTotal ,
            Currencys.f_Format(@CurrencyID, @SubTotal) ,
            @SubTotalD ,
            @SubTotalD * @ExchangeRateLL ,
            @SubTotalD * @ExchangeRateEuro ,
            @DiscountIs ,
            Currencys.f_Format(@CurrencyID, @DiscountIs) ,
            @DiscountIsD ,
            @DiscountIsD * @ExchangeRateLL ,
            @DiscountIsD * @ExchangeRateEuro ,
            @TaxValue ,
            Currencys.f_Format(@CurrencyID, @TaxValue) ,
            @TaxValueD ,
            @TaxValueD * @ExchangeRateLL ,
            @TaxValueD * @ExchangeRateEuro ,
            @Total ,
            Currencys.f_Format(@CurrencyID, @Total) ,
            @TotalD ,
            @TotalD * @ExchangeRateLL ,
            @TotalD * @ExchangeRateEuro ,
            @Payment ,
            Currencys.f_Format(@CurrencyID, @Payment) ,
            @PaymentD ,
            @PaymentD * @ExchangeRateLL ,
            @PaymentD * @ExchangeRateEuro ,
            @Rest ,
            Currencys.f_Format(@CurrencyID, @Rest) ,
            @RestD ,
            @RestD * @ExchangeRateLL ,
            @RestD * @ExchangeRateEuro ,
            @Cost ,
            Currencys.f_Format(@CurrencyID, @Cost) ,
            @CostD ,
            @CostD * @ExchangeRateLL ,
            @CostD * @ExchangeRateEuro ,
            @Profit ,
            Currencys.f_Format(@CurrencyID, @Profit) ,
            @ProfitD ,
            @ProfitD * @ExchangeRateLL ,
            @ProfitD * @ExchangeRateEuro ,
            @Qtys ,
            @ItemsNames ,
            @DescriptionIs 
          );

      SET @ID = ( SELECT TOP ( 1 ) s.ID
                    FROM @IDs AS s
                    ORDER BY s.ID
                );

    END;

    BEGIN --Insert detail

      INSERT INTO Customers.t_FrameJobOrderDetail
          ( ID ,
            FrameJobOrderID ,
            ItemSharedID ,
            ItemID ,
            ItemUnityID ,
            Qty ,
            QtyWithUnity ,
            Qtys ,
            ItemType ,
            Sale ,
            SaleF ,
            SaleD ,
            SaleLL ,
            SaleEuro ,
            DiscountIs ,
            DiscountIsF ,
            DiscountIsValue ,
            DiscountIsValueF ,
            DiscountIsValueD ,
            DiscountIsValueLL ,
            DiscountIsValueEuro ,
            SubTotal ,
            SubTotalF ,
            SubTotalD ,
            SubTotalLL ,
            SubTotalEuro ,
            DiscountOrder ,
            DiscountOrderF ,
            DiscountOrderD ,
            DiscountOrderLL ,
            DiscountOrderEuro ,
            TaxRate ,
            TaxRateF ,
            TaxValue ,
            TaxValueF ,
            TaxValueD ,
            TaxValueLL ,
            TaxValueEuro ,
            Total ,
            TotalF ,
            TotalD ,
            TotalLL ,
            TotalEuro ,
            Cost ,
            CostF ,
            CostD ,
            CostLL ,
            CostEuro ,
            TotalCost ,
            TotalCostF ,
            TotalCostD ,
            TotalCostLL ,
            TotalCostEuro ,
            Profit ,
            ProfitF ,
            ProfitD ,
            ProfitLL ,
            ProfitEuro ,
            ProfitTotal ,
            ProfitTotalF ,
            ProfitTotalD ,
            ProfitTotalLL ,
            ProfitTotalEuro ,
            DescriptionIs ,
            SortAt
          )
          SELECT s.ID ,
              @ID ,
              s.ItemSharedID ,
              s.ItemID ,
              s.ItemUnityID ,
              s.Qty ,
              FORMAT(s.Qty, '#,##0.####') + ' ' + s2.Name ,
              s.Qtys ,
              s.ItemType ,
              s.Sale ,
              Currencys.f_Format(@CurrencyID, s.Sale) ,
              s.Sale / @ExchangeRate ,
              ( s.Sale / @ExchangeRate ) * @ExchangeRateLL ,
              ( s.Sale / @ExchangeRate ) * @ExchangeRateEuro ,
              s.DiscountIs ,
              FORMAT(s.DiscountIs, '0.##') + ' %' ,
              s.DiscountIsValue ,
              Currencys.f_Format(@CurrencyID, s.DiscountIsValue) ,
              s.DiscountIsValue / @ExchangeRate ,
              ( s.DiscountIsValue / @ExchangeRate ) * @ExchangeRateLL ,
              ( s.DiscountIsValue / @ExchangeRate ) * @ExchangeRateEuro ,
              s.SubTotal ,
              Currencys.f_Format(@CurrencyID, s.SubTotal) ,
              s.SubTotal / @ExchangeRate ,
              ( s.SubTotal / @ExchangeRate ) * @ExchangeRateLL ,
              ( s.SubTotal / @ExchangeRate ) * @ExchangeRateEuro ,
              s.DiscountOrder ,
              Currencys.f_Format(@CurrencyID, s.DiscountOrder) ,
              s.DiscountOrder / @ExchangeRate ,
              ( s.DiscountOrder / @ExchangeRate ) * @ExchangeRateLL ,
              ( s.DiscountOrder / @ExchangeRate ) * @ExchangeRateEuro ,
              s.TaxRate ,
              FORMAT(s.TaxRate, '0.##') + ' %' ,
              s.TaxValue ,
              Currencys.f_Format(@CurrencyID, s.TaxValue) ,
              s.TaxValue / @ExchangeRate ,
              ( s.TaxValue / @ExchangeRate ) * @ExchangeRateLL ,
              ( s.TaxValue / @ExchangeRate ) * @ExchangeRateEuro ,
              s.Total ,
              Currencys.f_Format(@CurrencyID, s.Total) ,
              s.Total / @ExchangeRate ,
              ( s.Total / @ExchangeRate ) * @ExchangeRateLL ,
              ( s.Total / @ExchangeRate ) * @ExchangeRateEuro ,
              s.Cost ,
              Currencys.f_Format(@CurrencyID, s.Cost) ,
              s.Cost / @ExchangeRate ,
              ( s.Cost / @ExchangeRate ) * @ExchangeRateLL ,
              ( s.Cost / @ExchangeRate ) * @ExchangeRateEuro ,
              s.TotalCost ,
              Currencys.f_Format(@CurrencyID, s.TotalCost) ,
              s.TotalCost / @ExchangeRate ,
              ( s.TotalCost / @ExchangeRate ) * @ExchangeRateLL ,
              ( s.TotalCost / @ExchangeRate ) * @ExchangeRateEuro ,
              s.Profit ,
              Currencys.f_Format(@CurrencyID, s.Profit) ,
              s.Profit / @ExchangeRate ,
              ( s.Profit / @ExchangeRate ) * @ExchangeRateLL ,
              ( s.Profit / @ExchangeRate ) * @ExchangeRateEuro ,
              s.ProfitTotal ,
              Currencys.f_Format(@CurrencyID, s.ProfitTotal) ,
              s.ProfitTotal / @ExchangeRate ,
              ( s.ProfitTotal / @ExchangeRate ) * @ExchangeRateLL ,
              ( s.ProfitTotal / @ExchangeRate ) * @ExchangeRateEuro ,
              s.DescriptionIs ,
              s.SortAt
            FROM @DetailIs AS s
              LEFT JOIN Items.t_UnityItem AS s1 ON s1.ID = s.ItemUnityID
              LEFT JOIN Items.t_Unity AS s2 ON s2.ID = s1.UnityID;

    END;

    BEGIN --Rebuild statistics

      UPDATE Customers.t_FrameJobOrder
        SET TaxRate = ( TaxValue / ( Total - TaxValue ) ) * 100.0 ,
            TaxRateF = FORMAT(( TaxValue / ( Total - TaxValue ) ) * 100.0, '0.##') + N' %'
        WHERE ID = @ID AND Total > 0;

    END;

    BEGIN --Fix t_Customer

      UPDATE Customers.t_Customer
        SET FrameJobOrderC += 1 ,
            FrameJobOrderTotal = CASE @CurrencyTypeIsAccountCustomer
                                   WHEN 0 THEN @TotalD
                                   WHEN 1 THEN @TotalD * @ExchangeRateLL
                                   ELSE @TotalD * @ExchangeRateEuro
                                 END ,
            FrameJobOrderProfit = CASE @CurrencyTypeIsAccountCustomer
                                    WHEN 0 THEN @ProfitD
                                    WHEN 1 THEN @ProfitD * @ExchangeRateLL
                                    ELSE @ProfitD * @ExchangeRateEuro
                                  END ,
            FrameJobOrderLast = Customers.f_FrameJobOrderGetLastDateByCustomerID(ID)
        WHERE ID = @CustomerID;

      WITH  o AS ( SELECT s1.CurrencyID ,
                      s.FrameJobOrderTotal ,
                      s.FrameJobOrderTotalF ,
                      s.FrameJobOrderProfit ,
                      s.FrameJobOrderProfitF
                    FROM Customers.t_Customer AS s
                      INNER JOIN Company.t_Account AS s1 ON s1.LinkWithID = s.ID AND s1.IsMasterLink = 1 AND s1.SectionID = 15
                    WHERE s.ID = @ID
                 )
        UPDATE o
          SET o.FrameJobOrderTotalF = Currencys.f_Format(o.CurrencyID, o.FrameJobOrderTotal) ,
              o.FrameJobOrderProfitF = Currencys.f_Format(o.CurrencyID, o.FrameJobOrderProfit);

    END;

    BEGIN --Insert event

      SET @return = -1;

      INSERT INTO Customers.t_FrameJobOrderMoving
          ( UserID ,
            SectionID ,
            EventIs ,
            EventType ,
            ComputerIP ,
            Computer ,
            ComputerAccount
          )
        VALUES
          ( @UserID ,
            @ID ,
            @Event + @RefF ,
            0 ,
            @ComputerIP ,
            @Computer ,
            @ComputerAccount
          );

    END;

    IF @Payment > 0
    BEGIN --Transaction

      BEGIN --Set info

        SELECT @TransactionRef = ISNULL(MAX(s.Ref), 0) + 1
          FROM Transactions.t_Transaction AS s
          WHERE s.TypeIs = N'RV';

      END;

      BEGIN --Insert transaction

        SET @return = 0;

        DELETE FROM @IDs;

        INSERT INTO Transactions.t_Transaction
            ( Ref ,
              TypeIs ,
              DateIs ,
              DescriptionIs ,
              LinkType ,
              LinkTypeSub ,
              LinkID ,
              UserID 
            )
          OUTPUT Inserted.ID
            INTO @IDs ( ID )
          VALUES
            ( @TransactionRef ,
              N'RV' ,
              @DateIs ,
              N'FJB:' + @RefF ,
              @LinkType ,
              0 ,
              @ID ,
              @UserID 
            );

        SET @TransactionID = ( SELECT TOP ( 1 ) s.ID
                                FROM @IDs AS s
                                ORDER BY s.ID
                             );

        INSERT @TransactionIDs
            ( ID ,
              RefF
            )
          VALUES
            ( @TransactionID ,
              CONVERT(NVARCHAR(MAX), @TransactionRef)
            );

      END;

      BEGIN --Insert detail

        SET @CID = @CurrencyID;
        SET @E = @ExchangeRate;
        SET @ELL = @ExchangeRateLL;
        SET @EEuro = @ExchangeRateEuro;
        SET @V = @Payment;
        SET @VD = @PaymentD;

        INSERT INTO Transactions.t_TransactionDetail
            ( RowNumber, TransactionID, AccountID, DateIs, Balance, BalanceD, BalanceLL, BalanceEuro, Credit, CreditD, CreditLL, CreditEuro, Debit, DebitD, DebitLL, DebitEuro, StatementIs, CurrencyID, ExchangeRate )
          VALUES  ( 1, @TransactionID, @BoxID, @DateIs, @V, @VD, @VD * @ELL, @VD * @EEuro, 0, 0, 0, 0, @V, @VD, @VD * @ELL, @VD * @EEuro, N'FJB:' + @RefF + ' \ ' + @CustomerAccount, @CID, @E ),
                  ( 2, @TransactionID, @CustomerAccountID, @DateIs, 0 - @V, 0 - @VD, ( 0 - @VD ) * @ELL, ( 0 - @VD ) * @EEuro, @V, @VD, @VD * @ELL, @VD * @EEuro, 0, 0, 0, 0, N'FJB:' + @RefF, @CID, @E );

      END;

      BEGIN --Insert t_TransactionMoving

        SET @return = -1;

        INSERT INTO Transactions.t_TransactionMoving
            ( UserID ,
              SectionID ,
              EventIs ,
              EventType ,
              ComputerIP ,
              Computer ,
              ComputerAccount
            )
            SELECT @UserID ,
                @TransactionID ,
                @Event + s.RefF ,
                0 ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              FROM @TransactionIDs AS s;

      END;

      BEGIN --Fix data

        UPDATE Company.t_Account
          SET StatusIs = 0 ,
              LastAction = GETDATE()
          WHERE ID IN ( @BoxID, @CustomerID ) AND StatusIs = 1;
                 
        UPDATE Transactions.t_Transaction
          SET RefF = FORMAT(Ref, 'n0') ,
              DateOnly = DateIs ,
              DateFirstDayInMonth = DATEFROMPARTS(YEAR(DateIs), MONTH(DateIs), 1) ,
              DateFirstDayInYear = DATEFROMPARTS(YEAR(DateIs), 1, 1) ,
              AccountsNames = Alls.f_FixXML(( SELECT DISTINCT ', ' + t.Account AS [text()]
                                                FROM Transactions.t_TransactionDetail AS t
                                                WHERE t.TransactionID = @TransactionID
                                            FOR
                                              XML PATH('')
                                            )) ,
              BalanceD = COALESCE(( SELECT SUM(s.Balance)
                                      FROM Transactions.t_TransactionDetail AS s
                                      WHERE s.TransactionID = t_Transaction.ID AND s.CurrencyTypeIs = 0 AND s.Balance > 0
                                  ), 0) ,
              BalanceLL = COALESCE(( SELECT SUM(s.Balance)
                                      FROM Transactions.t_TransactionDetail AS s
                                      WHERE s.TransactionID = t_Transaction.ID AND s.CurrencyTypeIs = 1 AND s.Balance > 0
                                   ), 0) ,
              BalanceEuro = COALESCE(( SELECT SUM(s.Balance)
                                        FROM Transactions.t_TransactionDetail AS s
                                        WHERE s.TransactionID = t_Transaction.ID AND s.CurrencyTypeIs = 2 AND s.Balance > 0
                                     ), 0) ,
              UserIs = Users.f_UserGetName(UserID)
          WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                          FROM @TransactionIDs AS s
                          WHERE s.ID = t_Transaction.ID );

        UPDATE Transactions.t_TransactionDetail
          SET Account = Company.f_AccountGetName(AccountID) ,
              DateOnly = DateIs ,
              DateFirstDayInMonth = DATEFROMPARTS(YEAR(DateIs), MONTH(DateIs), 1) ,
              DateFirstDayInYear = DATEFROMPARTS(YEAR(DateIs), 1, 1) ,
              Currency = Currencys.f_CurrencyGetName(CurrencyID) ,
              CurrencyTypeIs = Currencys.f_CurrencyGetTypeIs(CurrencyID) ,
              BalanceF = Currencys.f_Format(CurrencyID, Balance) ,
              BalanceAR = Currencys.f_ToWordAR(Balance, CurrencyID, 1) ,
              BalanceEN = Currencys.f_ToWordEN(Balance, CurrencyID, 1)
          WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                          FROM @TransactionIDs AS s
                          WHERE s.ID = t_TransactionDetail.TransactionID );

      END;

    END;

    BEGIN --t_Prescription 
		   
      BEGIN --Set info

        SELECT @Ref = COALESCE(MAX(s.Ref), 0) + 1
          FROM Customers.t_Prescription AS s;
			
        SET @RefF = FORMAT(@Ref, 'n0');

      END;

      BEGIN --Insert

        SET @return = 0;

        INSERT INTO Customers.t_Prescription
            ( Ref ,
              RefF ,
              RefPaper ,
              DateIs ,
              CustomerID ,
              Customer ,
              DoctorID ,
              Doctor ,
              TypeIs ,
              Focal ,
              WithRight ,
              WithLeft ,
              SphereRight ,
              SphereLeft ,
              CylinderRight ,
              CylinderLeft ,
              AxisRight ,
              AxisLeft ,
              PrismRight ,
              PrismLeft ,
              BaseRight ,
              BaseLeft ,
              Addition ,
              HeightRight ,
              HeightLeft ,
              PDRight ,
              PDLeft ,
              PD ,
              DescriptionIs
            )
          OUTPUT Inserted.ID
            INTO @IDs ( ID )
          VALUES
            ( @Ref ,
              @RefF ,
              @RefPaper ,
              @DateIs ,
              @CustomerID ,
              Customers.f_CustomerGetName(@CustomerID) ,
              @DoctorID ,
              Company.f_DoctorGetName(@DoctorID) ,
              N'Spectacle Lenses' ,
              @Focal ,
              @WithRight ,
              @WithLeft ,
              @SphereRight ,
              @SphereLeft ,
              @CylinderRight ,
              @CylinderLeft ,
              @AxisRight ,
              @AxisLeft ,
              @PrismRight ,
              @PrismLeft ,
              @BaseRight ,
              @BaseLeft ,
              @Addition ,
              @HeightRight ,
              @HeightLeft ,
              @PDRight ,
              @PDLeft ,
              @PD ,
              @DescriptionIs
            );

        SET @ID = ( SELECT TOP ( 1 ) ID
                      FROM @IDs
                      ORDER BY ID
                  );

      END;
 
      BEGIN --Insert event

        SET @return = -1;

        INSERT INTO Customers.t_PrescriptionMoving
            ( UserID ,
              SectionID ,
              EventIs ,
              EventType ,
              ComputerIP ,
              Computer ,
              ComputerAccount
            )
          VALUES
            ( @UserID ,
              @ID ,
              @Event + @RefF ,
              0 ,
              @ComputerIP ,
              @Computer ,
              @ComputerAccount
            );

      END;
	
	    BEGIN--Fix t_Customer
    
      UPDATE Customers.t_Customer
        SET PrescriptionDoctorID = @DoctorID ,
            PrescriptionDoctor = Company.f_DoctorGetName(@DoctorID) ,
            PrescriptionTypeIs = N'Spectacle Lenses' ,
            PrescriptionFocal = @Focal ,
            PrescriptionWithRight = @WithRight ,
            PrescriptionWithLeft = @WithLeft ,
            PrescriptionSphereRight = @SphereRight ,
            PrescriptionSphereLeft = @SphereLeft ,
            PrescriptionCylinderRight = @CylinderRight ,
            PrescriptionCylinderLeft = @CylinderLeft ,
            PrescriptionAxisRight = @AxisRight ,
            PrescriptionAxisLeft = @AxisLeft ,
            PrescriptionPrismRight = @PrismRight ,
            PrescriptionPrismLeft = @PrismLeft ,
            PrescriptionBaseRight = @BaseRight ,
            PrescriptionBaseLeft = @BaseLeft ,
            PrescriptionAddition = @Addition ,
            PrescriptionHeightRight = @HeightRight ,
            PrescriptionHeightLeft = @HeightLeft ,
            PrescriptionPDRight = @PDRight ,
            PrescriptionPDLeft = @PDLeft ,
            PrescriptionPD = @PD ,
            PrescriptionDescriptionIs = @DescriptionIs ,
            PrescriptionC += 1 ,
            PrescriptionLastDate = COALESCE(( SELECT TOP ( 1 ) t.DateIs
                                                FROM Customers.t_Prescription AS t
                                                WHERE t.CustomerID = t_Customer.ID
                                                ORDER BY t.DateIs DESC
                                            ), DATEFROMPARTS(2000, 1, 1))
        WHERE ID = @CustomerID;
		
    END;
	
    END;

    COMMIT TRANSACTION;

    SELECT 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    SELECT @return;

  END CATCH;

END;



GO
