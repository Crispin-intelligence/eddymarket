CREATE TABLE [Company].[t_SocialMedia]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SocialMedia_ID] DEFAULT (newsequentialid()),
[OwnerID] [uniqueidentifier] NOT NULL,
[AccountIs] [nvarchar] (225) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SocialMedia_AccountIs] DEFAULT ('0'),
[SectionID] [int] NOT NULL CONSTRAINT [DF_t_SocialMedia_SectionID] DEFAULT ((15)),
[TypeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SocialMedia_TypeID] DEFAULT ([Company].[f_SocialMediaTypeGetFirstID]()),
[TypeIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SocialMedia_TypeIs] DEFAULT ([Company].[f_SocialMediaTypeGetFirstName]()),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SocialMedia_DescriptionIs] DEFAULT (''),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SocialMedia_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_SocialMedia_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_SocialMedia_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_SocialMedia_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_SocialMedia] ON [Company].[t_SocialMedia]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Company.t_SocialMedia
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_SocialMedia.ID );

  END;

  BEGIN --Fix data

    UPDATE  Company.t_SocialMedia
    SET     SearchText = Company.f_SocialMediaSearchTextGet(ID)
    WHERE   ID IN ( SELECT  s.ID
                    FROM    Inserted AS s );
  
  END;

  BEGIN --Declare

    DECLARE @IDs TABLE
      (
        ID UNIQUEIDENTIFIER NOT NULL ,
        SectionID INT NOT NULL
      );

  END;

  BEGIN --Get info

    INSERT  INTO @IDs
            ( ID ,
              SectionID
            )
    SELECT  t.OwnerID ,
            t.SectionID
    FROM    Inserted AS t
    UNION
    SELECT  t.OwnerID ,
            t.SectionID
    FROM    Deleted AS t;

  END;

  BEGIN --Fix data Customers

    UPDATE  Customers.t_Customer
    SET     SocialMedia = SUBSTRING(COALESCE(( SELECT N', ' + t.AccountIs AS [text()]
                                               FROM   Company.t_SocialMedia AS t
                                               WHERE  t.OwnerID = t_Customer.ID
                                                      AND t.SectionID = 15
                                             FOR
                                               XML PATH('')
                                             ), ''), 3, 99999) ,
            SocialMediaC = ( SELECT COUNT(t.ID)
                             FROM   Company.t_SocialMedia AS t
                             WHERE  t.OwnerID = t_Customer.ID
                                    AND t.SectionID = 15
                           )
    WHERE   ID IN ( SELECT  s.ID
                    FROM    @IDs AS s
                    WHERE   s.SectionID = 15 );

  END;

  BEGIN --Fix data employee

    UPDATE  Employees.t_Employee
    SET     SocialMedia = Alls.f_FixXML(( SELECT  N', ' + t.AccountIs AS [text()]
                                          FROM    Company.t_SocialMedia AS t
                                          WHERE   t.OwnerID = t_Employee.ID
                                                  AND t.SectionID = 33
                                        FOR
                                          XML PATH('')
                                        )) ,
            SocialMediaC = ( SELECT COUNT(t.ID)
                             FROM   Company.t_SocialMedia AS t
                             WHERE  t.OwnerID = t_Employee.ID
                                    AND t.SectionID = 33
                           )
    WHERE   ID IN ( SELECT  s.ID
                    FROM    @IDs AS s
                    WHERE   s.SectionID = 33 );

  END;

  BEGIN --Fix data bank

    UPDATE  Company.t_Bank
    SET     SocialMedia = Alls.f_FixXML(( SELECT  N', ' + t.AccountIs AS [text()]
                                          FROM    Company.t_SocialMedia AS t
                                          WHERE   t.OwnerID = t_Bank.ID
                                                  AND t.SectionID = 38
                                        FOR
                                          XML PATH('')
                                        )) ,
            SocialMediaC = ( SELECT COUNT(t.ID)
                             FROM   Company.t_SocialMedia AS t
                             WHERE  t.OwnerID = t_Bank.ID
                                    AND t.SectionID = 38
                           )
    WHERE   ID IN ( SELECT  s.ID
                    FROM    @IDs AS s
                    WHERE   s.SectionID = 38 );

  END;

  BEGIN --Fix data vendor

    UPDATE  Vendors.t_Vendor
    SET     SocialMedia = SUBSTRING(COALESCE(( SELECT N', ' + t.AccountIs AS [text()]
                                               FROM   Company.t_SocialMedia AS t
                                               WHERE  t.OwnerID = t_Vendor.ID
                                                      AND t.SectionID = 67
                                             FOR
                                               XML PATH('')
                                             ), ''), 3, 99999) ,
            SocialMediaC = ( SELECT COUNT(t.ID)
                             FROM   Company.t_SocialMedia AS t
                             WHERE  t.OwnerID = t_Vendor.ID
                                    AND t.SectionID = 67
                           )
    WHERE   ID IN ( SELECT  s.ID
                    FROM    @IDs AS s
                    WHERE   s.SectionID = 67 );

  END;

  BEGIN --Fix data sales person

    UPDATE  Employees.t_SalesPerson
    SET     SocialMedia = SUBSTRING(COALESCE(( SELECT N', ' + t.AccountIs AS [text()]
                                               FROM   Company.t_SocialMedia AS t
                                               WHERE  t.OwnerID = t_SalesPerson.ID
                                                      AND t.SectionID = 149
                                             FOR
                                               XML PATH('')
                                             ), ''), 3, 99999) ,
            SocialMediaC = ( SELECT COUNT(t.ID)
                             FROM   Company.t_SocialMedia AS t
                             WHERE  t.OwnerID = t_SalesPerson.ID
                                    AND t.SectionID = 149
                           )
    WHERE   ID IN ( SELECT  s.ID
                    FROM    @IDs AS s
                    WHERE   s.SectionID = 149 );

  END;

  BEGIN --Fix data contact

    UPDATE  Company.t_Contact
    SET     SocialMedia = SUBSTRING(COALESCE(( SELECT N', ' + t.AccountIs AS [text()]
                                               FROM   Company.t_SocialMedia AS t
                                               WHERE  t.OwnerID = t_Contact.ID
                                                      AND t.SectionID = 153
                                             FOR
                                               XML PATH('')
                                             ), ''), 3, 99999) ,
            SocialMediaC = ( SELECT COUNT(t.ID)
                             FROM   Company.t_SocialMedia AS t
                             WHERE  t.OwnerID = t_Contact.ID
                                    AND t.SectionID = 153
                           )
    WHERE   ID IN ( SELECT  s.ID
                    FROM    @IDs AS s
                    WHERE   s.SectionID = 153 );

  END;

  BEGIN --Fix data warehouse

    UPDATE  Company.t_WareHouse
    SET     SocialMedia = Alls.f_FixXML(( SELECT  N', ' + t.AccountIs AS [text()]
                                          FROM    Company.t_SocialMedia AS t
                                          WHERE   t.OwnerID = t_WareHouse.ID
                                                  AND t.SectionID = 42
                                        FOR
                                          XML PATH('')
                                        )) ,
            SocialMediaC = ( SELECT COUNT(t.ID)
                             FROM   Company.t_SocialMedia AS t
                             WHERE  t.OwnerID = t_WareHouse.ID
                                    AND t.SectionID = 42
                           )
    WHERE   ID IN ( SELECT  s.ID
                    FROM    @IDs AS s
                    WHERE   s.SectionID = 42 );

  END;
	
  BEGIN --Fix data Doctor

    UPDATE  Company.t_Doctor
    SET     SocialMedia = SUBSTRING(COALESCE(( SELECT N', ' + t.AccountIs AS [text()]
                                               FROM   Company.t_SocialMedia AS t
                                               WHERE  t.OwnerID = t_Doctor.ID
                                                      AND t.SectionID = 163
                                             FOR
                                               XML PATH('')
                                             ), ''), 3, 99999) ,
            SocialMediaC = ( SELECT COUNT(t.ID)
                             FROM   Company.t_SocialMedia AS t
                             WHERE  t.OwnerID = t_Doctor.ID
                                    AND t.SectionID = 163
                           )
    WHERE   ID IN ( SELECT  s.ID
                    FROM    @IDs AS s
                    WHERE   s.SectionID = 163 );

  END;
 
  BEGIN --Fix t_CarDriver

    UPDATE  Cars.t_CarDriver
    SET     SocialMedia = SUBSTRING(COALESCE(( SELECT N', ' + t.AccountIs AS [text()]
                                               FROM   Company.t_SocialMedia AS t
                                               WHERE  t.OwnerID = t_CarDriver.ID
                                                      AND t.SectionID = 184
                                             FOR
                                               XML PATH('')
                                             ), ''), 3, 99999) ,
            SocialMediaC = ( SELECT COUNT(t.ID)
                             FROM   Company.t_SocialMedia AS t
                             WHERE  t.OwnerID = t_CarDriver.ID
                                    AND t.SectionID = 184
                           )
    WHERE   ID IN ( SELECT  s.ID
                    FROM    @IDs AS s
                    WHERE   s.SectionID = 184 );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'socialMedia'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'socialMedia'
    FROM    Inserted AS s;

  END;
   
  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, SocialMedia, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Company].[t_SocialMedia] ADD CONSTRAINT [PK_t_SocialMedia] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_SocialMedia] ADD CONSTRAINT [SocialMediaTypeKeySocialMedia] FOREIGN KEY ([TypeID]) REFERENCES [Company].[t_SocialMediaType] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer = 15
Employee = 33
Bank = 38
Warehouse = 42
Vendor = 67
Sales Person = 149
Contact = 153
Doctor = 163
CarDriver = 184', 'SCHEMA', N'Company', 'TABLE', N't_SocialMedia', 'COLUMN', N'SectionID'
GO
