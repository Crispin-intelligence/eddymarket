SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Customers].[s_PrescriptionInsert]
  @RefPaper NVARCHAR(MAX) ,
  @DateIs DATE ,
  @CustomerID UNIQUEIDENTIFIER ,
  @DoctorID UNIQUEIDENTIFIER ,
  @BrandID UNIQUEIDENTIFIER ,
  @TypeIs NVARCHAR(MAX) ,
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
	
      DECLARE @Ref BIGINT ,
        @Return INT;

    END;

    BEGIN --Set info

      SELECT  @Ref = COALESCE(MAX(s.Ref), 0) + 1
      FROM    Customers.t_Prescription AS s;
				
    END;

    BEGIN --Insert

      SET @Return = 0;

      INSERT  INTO Customers.t_Prescription
              ( ID ,
                Ref ,
                RefF ,
                RefPaper ,
                DateIs ,
                CustomerID ,
                Customer ,
                DoctorID ,
                Doctor ,
                BrandID ,
                Brand ,
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
      VALUES  ( @ID ,
                @Ref ,
                FORMAT(@Ref, 'n0') ,
                @RefPaper ,
                @DateIs ,
                @CustomerID ,
                Customers.f_CustomerGetName(@CustomerID) ,
                @DoctorID ,
                Company.f_DoctorGetName(@DoctorID) ,
                @BrandID ,
                Items.f_BrandGetName(@BrandID) ,
                @TypeIs ,
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
  
      UPDATE  Customers.t_Prescription
      SET     SearchText = Customers.f_PrescriptionSearchTextGet(ID)
      WHERE   ID = @ID;

    END;

    BEGIN--Fix t_Customer
    
      UPDATE  Customers.t_Customer
      SET     PrescriptionDoctorID = @DoctorID ,
              PrescriptionDoctor = Company.f_DoctorGetName(@DoctorID) ,
              PrescriptionBrandID = @BrandID ,
              PrescriptionBrand = Items.f_BrandGetName(@BrandID) ,
              PrescriptionTypeIs = @TypeIs ,
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
              PrescriptionLastDate = COALESCE(( SELECT TOP ( 1 )
                                                        t.DateIs
                                                FROM    Customers.t_Prescription AS t
                                                WHERE   t.CustomerID = t_Customer.ID
                                                ORDER BY t.DateIs DESC
                                              ), DATEFROMPARTS(2000, 1, 1))
      WHERE   ID = @CustomerID;

      UPDATE  Customers.t_Customer
      SET     SearchText = Customers.f_CustomerSearchTextGet(ID)
      WHERE   ID = @CustomerID;
		
    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Customers.t_PrescriptionMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      VALUES  ( @UserID ,
                @ID ,
                @Event + N': ' + CONVERT(NVARCHAR(MAX), @Ref) ,
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
