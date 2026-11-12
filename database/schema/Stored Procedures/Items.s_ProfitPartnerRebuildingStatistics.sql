SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Items].[s_ProfitPartnerRebuildingStatistics]
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

    BEGIN --Rebuild statistics

      SET @Return = 0;

      UPDATE  Items.t_ProfitPartner
      SET     ItemsCount = ( SELECT COUNT(*)
                             FROM   Items.t_ItemSharedProfitPartner AS s
                             WHERE  ( s.ProfitPartnerID = t_ProfitPartner.ID )
                           ) ,
              SalesInvoicesCount = ( SELECT COUNT(*)
                                     FROM   Invoices.t_SoldProfitPartner AS s
                                     WHERE  ( s.ProfitPartnerID = t_ProfitPartner.ID )
                                   ) ,
              TotalProfitD = ( SELECT ISNULL(SUM(s.ProfitD), 0)
                               FROM   Invoices.t_SoldProfitPartner AS s
                               WHERE  ( s.ProfitPartnerID = t_ProfitPartner.ID )
                             ) ,
              TotalProfitLL = ( SELECT  ISNULL(SUM(s.ProfitLL), 0)
                                FROM    Invoices.t_SoldProfitPartner AS s
                                WHERE   ( s.ProfitPartnerID = t_ProfitPartner.ID )
                              ) ,
              TotalProfitEuro = ( SELECT  ISNULL(SUM(s.ProfitEuro), 0)
                                  FROM    Invoices.t_SoldProfitPartner AS s
                                  WHERE   ( s.ProfitPartnerID = t_ProfitPartner.ID )
                                );

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Items.t_ProfitPartnerMoving
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
