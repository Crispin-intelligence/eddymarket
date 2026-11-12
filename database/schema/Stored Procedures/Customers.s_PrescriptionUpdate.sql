SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Customers].[s_PrescriptionUpdate]
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

      DECLARE @CustomerIDOld UNIQUEIDENTIFIER ,
        @Return INT;

    END;

    BEGIN --SetInfo

      SELECT TOP ( 1 )
              @CustomerIDOld = s.CustomerID
      FROM    Customers.t_Prescription AS s
      WHERE   s.ID = @ID;

    END;

    BEGIN --Update

      SET @Return = 0;

      UPDATE  Customers.t_Prescription
      SET     RefPaper = @RefPaper ,
              DateIs = @DateIs ,
              CustomerID = @CustomerID ,
              Customer = Customers.f_CustomerGetName(@CustomerID) ,
              DoctorID = @DoctorID ,
              Doctor = Company.f_DoctorGetName(@DoctorID) ,
              BrandID = @BrandID ,
              Brand = Items.f_BrandGetName(@BrandID) ,
              TypeIs = @TypeIs ,
              Focal = @Focal ,
              WithRight = @WithRight ,
              WithLeft = @WithLeft ,
              SphereRight = @SphereRight ,
              SphereLeft = @SphereLeft ,
              CylinderRight = @CylinderRight ,
              CylinderLeft = @CylinderLeft ,
              AxisRight = @AxisRight ,
              AxisLeft = @AxisLeft ,
              PrismRight = @PrismRight ,
              PrismLeft = @PrismLeft ,
              BaseRight = @BaseRight ,
              BaseLeft = @BaseLeft ,
              Addition = @Addition ,
              HeightRight = @HeightRight ,
              HeightLeft = @HeightLeft ,
              PDRight = @PDRight ,
              PDLeft = @PDLeft ,
              PD = @PD ,
              DescriptionIs = @DescriptionIs
      WHERE   ID = @ID;
  
      UPDATE  Customers.t_Prescription
      SET     SearchText = Customers.f_PrescriptionSearchTextGet(ID)
      WHERE   ID = @ID;

    END;

    BEGIN --Fix t_Customer

      WITH  o AS ( SELECT TOP ( 1 )
                          s.ID ,
                          s.PrescriptionDoctorID ,
                          s.PrescriptionDoctor ,
                          s.PrescriptionBrandID ,
                          s.PrescriptionBrand ,
                          s.PrescriptionTypeIs ,
                          s.PrescriptionFocal ,
                          s.PrescriptionWithRight ,
                          s.PrescriptionWithLeft ,
                          s.PrescriptionSphereRight ,
                          s.PrescriptionSphereLeft ,
                          s.PrescriptionCylinderRight ,
                          s.PrescriptionCylinderLeft ,
                          s.PrescriptionAxisRight ,
                          s.PrescriptionAxisLeft ,
                          s.PrescriptionPrismRight ,
                          s.PrescriptionPrismLeft ,
                          s.PrescriptionBaseRight ,
                          s.PrescriptionBaseLeft ,
                          s.PrescriptionAddition ,
                          s.PrescriptionHeightRight ,
                          s.PrescriptionHeightLeft ,
                          s.PrescriptionPDRight ,
                          s.PrescriptionPDLeft ,
                          s.PrescriptionPD ,
                          s.PrescriptionDescriptionIs ,
                          s.PrescriptionLastDate ,
                          s1.DoctorID ,
                          s1.Doctor ,
                          s1.BrandID ,
                          s1.Brand ,
                          s1.TypeIs ,
                          s1.Focal ,
                          s1.WithRight ,
                          s1.WithLeft ,
                          s1.SphereRight ,
                          s1.SphereLeft ,
                          s1.CylinderRight ,
                          s1.CylinderLeft ,
                          s1.AxisRight ,
                          s1.AxisLeft ,
                          s1.PrismRight ,
                          s1.PrismLeft ,
                          s1.BaseRight ,
                          s1.BaseLeft ,
                          s1.Addition ,
                          s1.HeightRight ,
                          s1.HeightLeft ,
                          s1.PDRight ,
                          s1.PDLeft ,
                          s1.PD ,
                          s1.DescriptionIs
                   FROM   Customers.t_Customer AS s
                   LEFT JOIN Customers.t_Prescription AS s1 ON s1.CustomerID = s.ID
                   WHERE  s.ID = @CustomerID
                          AND s1.ID = @ID
                 )
        UPDATE  o
        SET     o.PrescriptionDoctorID = o.DoctorID ,
                o.PrescriptionDoctor = o.Doctor ,
                o.PrescriptionBrandID = o.BrandID ,
                o.PrescriptionBrand = o.Brand ,
                o.PrescriptionTypeIs = o.TypeIs ,
                o.PrescriptionFocal = o.Focal ,
                o.PrescriptionWithRight = o.WithRight ,
                o.PrescriptionWithLeft = o.WithLeft ,
                o.PrescriptionSphereRight = o.SphereRight ,
                o.PrescriptionSphereLeft = o.SphereLeft ,
                o.PrescriptionCylinderRight = o.CylinderRight ,
                o.PrescriptionCylinderLeft = o.CylinderLeft ,
                o.PrescriptionAxisRight = o.AxisRight ,
                o.PrescriptionAxisLeft = o.AxisLeft ,
                o.PrescriptionPrismRight = o.PrismRight ,
                o.PrescriptionPrismLeft = o.PrismLeft ,
                o.PrescriptionBaseRight = o.BaseRight ,
                o.PrescriptionBaseLeft = o.BaseLeft ,
                o.PrescriptionAddition = o.Addition ,
                o.PrescriptionHeightRight = o.HeightRight ,
                o.PrescriptionHeightLeft = o.HeightLeft ,
                o.PrescriptionPDRight = o.PDRight ,
                o.PrescriptionPDLeft = o.PDLeft ,
                o.PrescriptionPD = o.PD ,
                o.PrescriptionDescriptionIs = o.DescriptionIs ,
                o.PrescriptionLastDate = COALESCE(( SELECT TOP ( 1 )
                                                            t.DateIs
                                                    FROM    Customers.t_Prescription AS t
                                                    WHERE   t.CustomerID = o.ID
                                                    ORDER BY t.DateIs DESC
                                                  ), DATEFROMPARTS(2000, 1, 1))
        WHERE   ID = @CustomerID;
   					
    END;

    BEGIN --Fix t_Customer

      IF @CustomerID <> @CustomerIDOld
      BEGIN
                         
        IF EXISTS ( SELECT TOP ( 1 )
                            s.ID
                    FROM    Customers.t_Prescription AS s
                    WHERE   s.CustomerID = @CustomerIDOld )
        BEGIN

          WITH  o AS ( SELECT TOP ( 1 )
                              s.ID ,
                              s.PrescriptionDoctorID ,
                              s.PrescriptionDoctor ,
                              s.PrescriptionBrandID ,
                              s.PrescriptionBrand ,
                              s.PrescriptionTypeIs ,
                              s.PrescriptionFocal ,
                              s.PrescriptionWithRight ,
                              s.PrescriptionWithLeft ,
                              s.PrescriptionSphereRight ,
                              s.PrescriptionSphereLeft ,
                              s.PrescriptionCylinderRight ,
                              s.PrescriptionCylinderLeft ,
                              s.PrescriptionAxisRight ,
                              s.PrescriptionAxisLeft ,
                              s.PrescriptionPrismRight ,
                              s.PrescriptionPrismLeft ,
                              s.PrescriptionBaseRight ,
                              s.PrescriptionBaseLeft ,
                              s.PrescriptionAddition ,
                              s.PrescriptionHeightRight ,
                              s.PrescriptionHeightLeft ,
                              s.PrescriptionPDRight ,
                              s.PrescriptionPDLeft ,
                              s.PrescriptionPD ,
                              s.PrescriptionDescriptionIs ,
                              s.PrescriptionC ,
                              s.PrescriptionLastDate ,
                              s1.DoctorID ,
                              s1.Doctor ,
                              s1.BrandID ,
                              s1.Brand ,
                              s1.TypeIs ,
                              s1.Focal ,
                              s1.WithRight ,
                              s1.WithLeft ,
                              s1.SphereRight ,
                              s1.SphereLeft ,
                              s1.CylinderRight ,
                              s1.CylinderLeft ,
                              s1.AxisRight ,
                              s1.AxisLeft ,
                              s1.PrismRight ,
                              s1.PrismLeft ,
                              s1.BaseRight ,
                              s1.BaseLeft ,
                              s1.Addition ,
                              s1.HeightRight ,
                              s1.HeightLeft ,
                              s1.PDRight ,
                              s1.PDLeft ,
                              s1.PD ,
                              s1.DescriptionIs
                       FROM   Customers.t_Customer AS s
                       LEFT JOIN Customers.t_Prescription AS s1 ON s1.CustomerID = s.ID
                       WHERE  s.ID = @CustomerIDOld
                       ORDER BY s1.DateIs DESC
                     )
            UPDATE  o
            SET     o.PrescriptionDoctorID = o.DoctorID ,
                    o.PrescriptionDoctor = o.Doctor ,
                    o.PrescriptionBrandID = o.BrandID ,
                    o.PrescriptionBrand = o.Brand ,
                    o.PrescriptionTypeIs = o.TypeIs ,
                    o.PrescriptionFocal = o.Focal ,
                    o.PrescriptionWithRight = o.WithRight ,
                    o.PrescriptionWithLeft = o.WithLeft ,
                    o.PrescriptionSphereRight = o.SphereRight ,
                    o.PrescriptionSphereLeft = o.SphereLeft ,
                    o.PrescriptionCylinderRight = o.CylinderRight ,
                    o.PrescriptionCylinderLeft = o.CylinderLeft ,
                    o.PrescriptionAxisRight = o.AxisRight ,
                    o.PrescriptionAxisLeft = o.AxisLeft ,
                    o.PrescriptionPrismRight = o.PrismRight ,
                    o.PrescriptionPrismLeft = o.PrismLeft ,
                    o.PrescriptionBaseRight = o.BaseRight ,
                    o.PrescriptionBaseLeft = o.BaseLeft ,
                    o.PrescriptionAddition = o.Addition ,
                    o.PrescriptionHeightRight = o.HeightRight ,
                    o.PrescriptionHeightLeft = o.HeightLeft ,
                    o.PrescriptionPDRight = o.PDRight ,
                    o.PrescriptionPDLeft = o.PDLeft ,
                    o.PrescriptionPD = o.PD ,
                    o.PrescriptionDescriptionIs = o.DescriptionIs ,
                    o.PrescriptionC -= 1 ,
                    o.PrescriptionLastDate = COALESCE(( SELECT TOP ( 1 )
                                                                t.DateIs
                                                        FROM    Customers.t_Prescription AS t
                                                        WHERE   t.CustomerID = o.ID
                                                        ORDER BY t.DateIs DESC
                                                      ), DATEFROMPARTS(2000, 1, 1))
            WHERE   ID = @CustomerIDOld;

        END;
        ELSE
        BEGIN

          UPDATE  Customers.t_Customer
          SET     PrescriptionDoctorID = DEFAULT ,
                  PrescriptionDoctor = DEFAULT ,
                  PrescriptionBrandID = DEFAULT ,
                  PrescriptionBrand = DEFAULT ,
                  PrescriptionTypeIs = DEFAULT ,
                  PrescriptionFocal = DEFAULT ,
                  PrescriptionWithRight = DEFAULT ,
                  PrescriptionWithLeft = DEFAULT ,
                  PrescriptionSphereRight = DEFAULT ,
                  PrescriptionSphereLeft = DEFAULT ,
                  PrescriptionCylinderRight = DEFAULT ,
                  PrescriptionCylinderLeft = DEFAULT ,
                  PrescriptionAxisRight = DEFAULT ,
                  PrescriptionAxisLeft = DEFAULT ,
                  PrescriptionPrismRight = DEFAULT ,
                  PrescriptionPrismLeft = DEFAULT ,
                  PrescriptionBaseRight = DEFAULT ,
                  PrescriptionBaseLeft = DEFAULT ,
                  PrescriptionAddition = DEFAULT ,
                  PrescriptionHeightRight = DEFAULT ,
                  PrescriptionHeightLeft = DEFAULT ,
                  PrescriptionPDRight = DEFAULT ,
                  PrescriptionPDLeft = DEFAULT ,
                  PrescriptionPD = DEFAULT ,
                  PrescriptionDescriptionIs = DEFAULT ,
                  PrescriptionC -= 1 ,
                  PrescriptionLastDate = COALESCE(( SELECT TOP ( 1 )
                                                            t.DateIs
                                                    FROM    Customers.t_Prescription AS t
                                                    WHERE   t.CustomerID = t_Customer.ID
                                                    ORDER BY t.DateIs DESC
                                                  ), DATEFROMPARTS(2000, 1, 1))
          WHERE   ID = @CustomerIDOld;
					
        END;
	
        UPDATE  Customers.t_Customer
        SET     PrescriptionC += 1
        WHERE   ID = @CustomerID;
			      
      END;		
	  
      UPDATE  Customers.t_Customer
      SET     SearchText = Customers.f_CustomerSearchTextGet(ID)
      WHERE   ID IN ( @CustomerIDOld, @CustomerID );
						
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
                @Event ,
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
