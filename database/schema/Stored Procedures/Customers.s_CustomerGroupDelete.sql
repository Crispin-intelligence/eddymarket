SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Customers].[s_CustomerGroupDelete]
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

            DECLARE @Return INT;

            DECLARE @CustomerIDs AS TABLE ( ID UNIQUEIDENTIFIER );

        END;

        BEGIN --Set Info

            INSERT  INTO @CustomerIDs
                    ( ID
                    )
                    SELECT  s.CustomerID
                    FROM    Customers.t_CustomerGroupDetail AS s
                    WHERE   s.CustomerGroupID = @ID;

        END;

        BEGIN --Delete

            SET @Return = 0;

            DELETE  FROM Customers.t_CustomerGroupDetail
            WHERE   CustomerGroupID = @ID;

            DELETE  FROM Customers.t_CustomerGroup
            WHERE   ID = @ID;

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
            WHERE   EXISTS ( SELECT TOP ( 1 )
                                    s.ID
                             FROM   @CustomerIDs AS s
                             WHERE  s.ID = t_Customer.ID );

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
