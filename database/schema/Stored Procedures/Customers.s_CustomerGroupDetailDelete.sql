SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Customers].[s_CustomerGroupDetailDelete]
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
		
            DECLARE @CustomerGroupID UNIQUEIDENTIFIER ,
                @CustomerID UNIQUEIDENTIFIER ,
                @Return INT;

        END;

        BEGIN --Set Info

            SELECT TOP ( 1 )
                    @CustomerGroupID = s.CustomerGroupID ,
                    @CustomerID = s.CustomerID
            FROM    Customers.t_CustomerGroupDetail AS s
            WHERE   s.ID = @ID;

        END;

        BEGIN --Delete

            SET @Return = 0;

            DELETE  FROM Customers.t_CustomerGroupDetail
            WHERE   ID = @ID;
			
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
