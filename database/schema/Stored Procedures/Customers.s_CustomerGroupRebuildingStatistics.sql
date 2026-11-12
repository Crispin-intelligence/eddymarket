SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Customers].[s_CustomerGroupRebuildingStatistics]
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

        BEGIN --Rebuilding statistics

            SET @Return = 0;

            UPDATE  Customers.t_CustomerGroupDetail
            SET     Customer = Customers.f_CustomerGetName(CustomerID);

            UPDATE  Customers.t_CustomerGroup
            SET     CustomerNames = Alls.f_FixXML(( SELECT  N', ' + s.Customer AS [text()]
                                                    FROM    Customers.t_CustomerGroupDetail AS s
                                                    WHERE   s.CustomerGroupID = t_CustomerGroup.ID
                                                  FOR
                                                    XML PATH('')
                                                  )) ,
                    CustomerCount = ( SELECT    COUNT(*)
                                      FROM      Customers.t_CustomerGroupDetail AS s
                                      WHERE     s.CustomerGroupID = t_CustomerGroup.ID
                                    );

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
                      '00000000-0000-0000-0000-000000000000' ,
                      @Event ,
                      6 ,
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
