SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Company].[s_AccountGroupUpdate]
  @Name NVARCHAR(MAX) ,
  @CurrencyID UNIQUEIDENTIFIER ,
  @TypeIs TINYINT ,
  @DescriptionIs NVARCHAR(MAX) ,
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

    BEGIN --DECLARE

      DECLARE @Return INT ,
        @NameOld NVARCHAR(450);

    END;

    BEGIN --Set Info

      SELECT TOP ( 1 )
              @NameOld = s.Name
      FROM    Company.t_AccountGroup AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

    END;

    BEGIN --Insert Account

      SET @Return = 0;

      UPDATE  Company.t_AccountGroup
      SET     Name = @Name ,
              CurrencyID = @CurrencyID ,
              Currency = Currencys.f_CurrencyGetName(@CurrencyID) ,
              TypeIs = @TypeIs ,
              DescriptionIs = @DescriptionIs
      WHERE   ID = @ID;

    END;

    IF @NameOld COLLATE Arabic_CS_AS <> @Name COLLATE Arabic_CS_AS
    BEGIN; --Fix

      BEGIN --Account Group Account

        UPDATE  Company.t_AccountGroupAccount
        SET     AccountGroup = @Name
        WHERE   AccountGroupID = @ID;

      END;

      BEGIN --Account Group Range

        UPDATE  Company.t_AccountGroupRange
        SET     AccountGroup = @Name
        WHERE   AccountGroupID = @ID;

      END;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Company.t_AccountGroupMoving
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
