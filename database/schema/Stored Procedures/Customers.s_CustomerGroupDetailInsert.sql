SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Customers].[s_CustomerGroupDetailInsert]
    @CustomerGroupID UNIQUEIDENTIFIER ,
    @CustomerID UNIQUEIDENTIFIER ,
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

        BEGIN --Insert

            SET @Return = 0;

            INSERT  INTO Customers.t_CustomerGroupDetail
                    ( CustomerGroupID ,
                      CustomerID ,
                      Customer
                    )
            VALUES  ( @CustomerGroupID ,
                      @CustomerID ,
                      Customers.f_CustomerGetName(@CustomerID)
                    );


        END;
     
        BEGIN --Fix t_CustomerGroup
		
            UPDATE  Customers.t_CustomerGroup
            SET     CustomerNames = Alls.f_FixXML(( SELECT  N', ' + t.Customer AS [text()]
                                                    FROM    Customers.t_CustomerGroupDetail AS t
                                                    WHERE   t.CustomerGroupID = t_CustomerGroup.ID
                                                  FOR
                                                    XML PATH('')
                                                  )) ,
                    CustomerCount = ( SELECT    COUNT(t.ID)
                                      FROM      Customers.t_CustomerGroupDetail AS t
                                      WHERE     t.CustomerGroupID = t_CustomerGroup.ID
                                    )
            WHERE   ID = @CustomerGroupID;

        END;

        BEGIN --Fix t_Customer

            UPDATE  Customers.t_Customer
            SET     GroupNames = Alls.f_FixXML(( SELECT N', ' + t1.Name AS [text()]
                                                 FROM   Customers.t_CustomerGroupDetail AS t
                                                        LEFT JOIN Customers.t_CustomerGroup AS t1 ON t1.ID = t.CustomerGroupID
                                                 WHERE  t.CustomerID = t_Customer.ID
                                               FOR
                                                 XML PATH('')
                                               )) ,
                    GroupCounts = ( SELECT  COUNT(t.ID)
                                    FROM    Customers.t_CustomerGroupDetail AS t
                                    WHERE   t.CustomerID = t_Customer.ID
                                  )
            WHERE   ID = @CustomerID;

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT  INTO Customers.t_CustomerGroupMoving
                    ( UserID ,
                      SectionID ,
                      EventIs ,
                      EventType ,
                      ComputerIP ,
                      Computer ,
                      ComputerAccount
                    )
            VALUES  ( @UserID ,
                      @CustomerGroupID ,
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
