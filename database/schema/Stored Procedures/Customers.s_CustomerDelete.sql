SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Customers].[s_CustomerDelete]
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
        BEGIN TRANSACTION customerDelete;

        BEGIN --Declare

            DECLARE @AgeRangeID UNIQUEIDENTIFIER ,
                @Return INT;

        END;

        BEGIN --Set Info

            SELECT TOP ( 1 )
                    @AgeRangeID = s.AgeRangeID
            FROM    Customers.t_Customer AS s
            WHERE   s.ID = @ID;

        END;

        BEGIN --Delete account

            SET @Return = -3;

            DELETE  FROM Company.t_Account
            WHERE   SectionID = 15
                    AND LinkWithID = @ID;

        END;

        BEGIN --Delete phones 

            DELETE  FROM Company.t_BookPhone
            WHERE   SectionID = 15
                    AND OwnerID = @ID;

        END;

        BEGIN --Delete SocialMedia 

            DELETE  FROM Company.t_SocialMedia
            WHERE   SectionID = 15
                    AND OwnerID = @ID;

        END;

        BEGIN --Delete File Storage Linked 

            DELETE  FROM Company.t_FileStorageLinked
            WHERE   SectionID = 15
                    AND OwnerID = @ID;

        END;

        BEGIN --Delete

            SET @Return = 0;

            DELETE  FROM Customers.t_Customer
            WHERE   ID = @ID;

        END;

        BEGIN --Fix t_AgeRange

            UPDATE  Customers.t_AgeRange
            SET     CustomerC -= 1
            WHERE   ID = @AgeRangeID;

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
            WHERE   EXISTS ( SELECT TOP ( 1 )
                                    s.ID
                             FROM   Customers.t_CustomerGroupDetail AS s
                             WHERE  s.CustomerID = @ID
                                    AND s.CustomerGroupID = t_CustomerGroup.ID );

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT  INTO Customers.t_CustomerMoving
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

        COMMIT TRANSACTION customerDelete;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK TRANSACTION customerDelete;

        RETURN @Return;

    END CATCH;

END;












GO
