CREATE TABLE [Company].[t_BookPhone]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_BookPhone_ID] DEFAULT (newsequentialid()),
[OwnerID] [uniqueidentifier] NOT NULL,
[SectionID] [int] NOT NULL,
[NumberIs] [nvarchar] (100) COLLATE Arabic_CI_AS NOT NULL,
[NumberNet] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BookPhone_NumberNet] DEFAULT (''),
[NumberNetPlus] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BookPhone_NumberNetPlus] DEFAULT (''),
[NumberWithExtension] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BookPhone_NumberWithExtension] DEFAULT (''),
[NumberType] [tinyint] NOT NULL CONSTRAINT [DF_t_BookPhone_NumberType] DEFAULT ((0)),
[LanguageCodeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_BookPhone_LanguageCodeID] DEFAULT ([Alls].[f_LanguageCodeGetFirstID]()),
[LanguageCode] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BookPhone_LanguageCode] DEFAULT ([Alls].[f_LanguageCodeGetFirstName]()),
[ExtensionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BookPhone_ExtensionIs] DEFAULT (''),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BookPhone_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_BookPhone_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_BookPhone_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_BookPhone_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_BookPhone] ON [Company].[t_BookPhone]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN
  
  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Company.t_BookPhone
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_BookPhone.ID );


  END;
	
  BEGIN --Fix data

    UPDATE  Company.t_BookPhone
    SET     NumberNet = COALESCE(( SELECT TOP ( 1 )
                                          s.InternationalDialingPrefix + s.CountryCallingCode
                                   FROM   Alls.t_LanguageCode AS s
                                   WHERE  s.ID = t_BookPhone.LanguageCodeID
                                   ORDER BY s.DateCreate
                                 ), N'') + CASE SUBSTRING(NumberIs, 1, 1)
                                             WHEN '0' THEN SUBSTRING(NumberIs, 2, LEN(NumberIs) - 1)
                                             ELSE NumberIs
                                           END ,
            NumberNetPlus = COALESCE(( SELECT TOP ( 1 )
                                              N'++' + s.CountryCallingCode
                                       FROM   Alls.t_LanguageCode AS s
                                       WHERE  s.ID = t_BookPhone.LanguageCodeID
                                       ORDER BY s.DateCreate
                                     ), N'') + CASE SUBSTRING(NumberIs, 1, 1)
                                                 WHEN '0' THEN SUBSTRING(NumberIs, 2, LEN(NumberIs) - 1)
                                                 ELSE NumberIs
                                               END ,
            NumberWithExtension = [Alls].f_AppendWithParentheses(NumberIs, ExtensionIs)
    WHERE   ID IN ( SELECT  s.ID
                    FROM    Inserted AS s );

    UPDATE  Company.t_BookPhone
    SET     SearchText = Company.f_BookPhoneSearchTextGet(ID)
    WHERE   ID IN ( SELECT  s.ID
                    FROM    Inserted AS s );
  
  END;

  BEGIN --Declare

    DECLARE @IDs TABLE
      (
        ID UNIQUEIDENTIFIER NOT NULL
      );

    DECLARE @OwnerIDs TABLE
      (
        ID UNIQUEIDENTIFIER NOT NULL ,
        SectionID INT NOT NULL
      );

  END;

  BEGIN --Get info

    INSERT  INTO @IDs
            ( ID
            )
    SELECT  t.ID
    FROM    Inserted AS t
    UNION
    SELECT  t.ID
    FROM    Deleted AS t;

    INSERT  INTO @OwnerIDs
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

  BEGIN --Fix data customer

    UPDATE  Customers.t_Customer
    SET     Phones = SUBSTRING(COALESCE(( SELECT  N', ' + t.NumberIs + CASE t.ExtensionIs
                                                                         WHEN N'' THEN N''
                                                                         ELSE N': ' + t.ExtensionIs
                                                                       END AS [text()]
                                          FROM    Company.t_BookPhone AS t
                                          WHERE   t.OwnerID = t_Customer.ID
                                                  AND t.SectionID = 15
                                        FOR
                                          XML PATH('')
                                        ), ''), 3, 99999) ,
            PhonesC = ( SELECT  COUNT(t.ID)
                        FROM    Company.t_BookPhone AS t
                        WHERE   t.OwnerID = t_Customer.ID
                                AND t.SectionID = 15
                      )
    WHERE   ID IN ( SELECT  s.ID
                    FROM    @OwnerIDs AS s
                    WHERE   s.SectionID = 15 );

  END;

  BEGIN --Fix data employee

    UPDATE  Employees.t_Employee
    SET     Phones = Alls.f_FixXML(( SELECT N', ' + t.NumberIs + CASE t.ExtensionIs
                                                                   WHEN N'' THEN N''
                                                                   ELSE N' (' + t.ExtensionIs + ')'
                                                                 END AS [text()]
                                     FROM   Company.t_BookPhone AS t
                                     WHERE  t.OwnerID = t_Employee.ID
                                            AND t.SectionID = 33
                                   FOR
                                     XML PATH('')
                                   )) ,
            PhonesC = ( SELECT  COUNT(t.ID)
                        FROM    Company.t_BookPhone AS t
                        WHERE   t.OwnerID = t_Employee.ID
                                AND t.SectionID = 33
                      )
    WHERE   ID IN ( SELECT  s.ID
                    FROM    @OwnerIDs AS s
                    WHERE   s.SectionID = 33 );

  END;

  BEGIN --Fix data bank

    UPDATE  Company.t_Bank
    SET     Phones = SUBSTRING(COALESCE(( SELECT  N', ' + t.NumberIs + CASE t.ExtensionIs
                                                                         WHEN N'' THEN N''
                                                                         ELSE N': ' + t.ExtensionIs
                                                                       END AS [text()]
                                          FROM    Company.t_BookPhone AS t
                                          WHERE   t.OwnerID = t_Bank.ID
                                                  AND t.SectionID = 38
                                        FOR
                                          XML PATH('')
                                        ), ''), 3, 99999)
    WHERE   ID IN ( SELECT  s.ID
                    FROM    @OwnerIDs AS s
                    WHERE   s.SectionID = 38 );

  END;

  BEGIN --Fix data warehouse

    UPDATE  Company.t_WareHouse
    SET     Phones = Alls.f_FixXML(( SELECT N', ' + t.NumberIs + CASE t.ExtensionIs
                                                                   WHEN N'' THEN N''
                                                                   ELSE N' (' + t.ExtensionIs + ')'
                                                                 END AS [text()]
                                     FROM   Company.t_BookPhone AS t
                                     WHERE  t.OwnerID = t_WareHouse.ID
                                            AND t.SectionID = 42
                                   FOR
                                     XML PATH('')
                                   )) ,
            PhonesC = ( SELECT  COUNT(t.ID)
                        FROM    Company.t_BookPhone AS t
                        WHERE   t.OwnerID = t_WareHouse.ID
                                AND t.SectionID = 42
                      )
    WHERE   ID IN ( SELECT  s.ID
                    FROM    @OwnerIDs AS s
                    WHERE   s.SectionID = 42 );

  END;

  BEGIN --Fix data vendor

    UPDATE  Vendors.t_Vendor
    SET     Phones = SUBSTRING(COALESCE(( SELECT  N', ' + t.NumberIs + CASE t.ExtensionIs
                                                                         WHEN N'' THEN N''
                                                                         ELSE N': ' + t.ExtensionIs
                                                                       END AS [text()]
                                          FROM    Company.t_BookPhone AS t
                                          WHERE   t.OwnerID = t_Vendor.ID
                                                  AND t.SectionID = 67
                                        FOR
                                          XML PATH('')
                                        ), ''), 3, 99999) ,
            PhonesC = ( SELECT  COUNT(t.ID)
                        FROM    Company.t_BookPhone AS t
                        WHERE   t.OwnerID = t_Vendor.ID
                                AND t.SectionID = 67
                      )
    WHERE   ID IN ( SELECT  s.ID
                    FROM    @OwnerIDs AS s
                    WHERE   s.SectionID = 67 );

  END;

  BEGIN --Fix data sales person

    UPDATE  Employees.t_SalesPerson
    SET     Phones = SUBSTRING(COALESCE(( SELECT  N', ' + t.NumberIs + CASE t.ExtensionIs
                                                                         WHEN N'' THEN N''
                                                                         ELSE N': ' + t.ExtensionIs
                                                                       END AS [text()]
                                          FROM    Company.t_BookPhone AS t
                                          WHERE   t.OwnerID = t_SalesPerson.ID
                                                  AND t.SectionID = 149
                                        FOR
                                          XML PATH('')
                                        ), ''), 3, 99999) ,
            PhonesC = ( SELECT  COUNT(t.ID)
                        FROM    Company.t_BookPhone AS t
                        WHERE   t.OwnerID = t_SalesPerson.ID
                                AND t.SectionID = 149
                      )
    WHERE   ID IN ( SELECT  s.ID
                    FROM    @OwnerIDs AS s
                    WHERE   s.SectionID = 149 );

  END;

  BEGIN --Fix data contact

    UPDATE  Company.t_Contact
    SET     Phones = SUBSTRING(COALESCE(( SELECT  N', ' + t.NumberIs + CASE t.ExtensionIs
                                                                         WHEN N'' THEN N''
                                                                         ELSE N': ' + t.ExtensionIs
                                                                       END AS [text()]
                                          FROM    Company.t_BookPhone AS t
                                          WHERE   t.OwnerID = t_Contact.ID
                                                  AND t.SectionID = 153
                                        FOR
                                          XML PATH('')
                                        ), ''), 3, 99999) ,
            PhonesC = ( SELECT  COUNT(t.ID)
                        FROM    Company.t_BookPhone AS t
                        WHERE   t.OwnerID = t_Contact.ID
                                AND t.SectionID = 153
                      )
    WHERE   ID IN ( SELECT  s.ID
                    FROM    @OwnerIDs AS s
                    WHERE   s.SectionID = 153 );

  END;

  BEGIN --Fix data doctor

    UPDATE  Company.t_Doctor
    SET     Phones = SUBSTRING(COALESCE(( SELECT  N', ' + t.NumberIs + CASE t.ExtensionIs
                                                                         WHEN N'' THEN N''
                                                                         ELSE N': ' + t.ExtensionIs
                                                                       END AS [text()]
                                          FROM    Company.t_BookPhone AS t
                                          WHERE   t.OwnerID = t_Doctor.ID
                                                  AND t.SectionID = 163
                                        FOR
                                          XML PATH('')
                                        ), ''), 3, 99999) ,
            PhonesC = ( SELECT  COUNT(t.ID)
                        FROM    Company.t_BookPhone AS t
                        WHERE   t.OwnerID = t_Doctor.ID
                                AND t.SectionID = 163
                      )
    WHERE   ID IN ( SELECT  s.ID
                    FROM    @OwnerIDs AS s
                    WHERE   s.SectionID = 163 );

  END;

  BEGIN --Fix t_CarDriver

    UPDATE  Cars.t_CarDriver
    SET     Phones = SUBSTRING(COALESCE(( SELECT  N', ' + t.NumberIs + CASE t.ExtensionIs
                                                                         WHEN N'' THEN N''
                                                                         ELSE N': ' + t.ExtensionIs
                                                                       END AS [text()]
                                          FROM    Company.t_BookPhone AS t
                                          WHERE   t.OwnerID = t_CarDriver.ID
                                                  AND t.SectionID = 184
                                        FOR
                                          XML PATH('')
                                        ), ''), 3, 99999) ,
            PhonesC = ( SELECT  COUNT(t.ID)
                        FROM    Company.t_BookPhone AS t
                        WHERE   t.OwnerID = t_CarDriver.ID
                                AND t.SectionID = 184
                      )
    WHERE   ID IN ( SELECT  s.ID
                    FROM    @OwnerIDs AS s
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
            'bookPhone'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'bookPhone'
    FROM    Inserted AS s;

  END;
   
  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, BookPhone, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Company].[t_BookPhone] ADD CONSTRAINT [PK_t_BookPhone] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [iu_t_BookPhone_SectionID_NumberIs] ON [Company].[t_BookPhone] ([SectionID], [NumberIs]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_BookPhone] ADD CONSTRAINT [LanguageCodeKeyBookPhone] FOREIGN KEY ([LanguageCodeID]) REFERENCES [Alls].[t_LanguageCode] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mobile = 0
Telephone = 1
Fax = 2
Internal = 3', 'SCHEMA', N'Company', 'TABLE', N't_BookPhone', 'COLUMN', N'NumberType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer = 15
Employee = 33
Bank = 38
Warehouse = 42
Vendor = 67
Sales Person = 149
Contact = 153
Doctor = 163
CarDriver = 184', 'SCHEMA', N'Company', 'TABLE', N't_BookPhone', 'COLUMN', N'SectionID'
GO
