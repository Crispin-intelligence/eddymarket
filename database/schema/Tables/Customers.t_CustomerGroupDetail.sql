CREATE TABLE [Customers].[t_CustomerGroupDetail]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CustomerGroupDetail_ID] DEFAULT (newsequentialid()),
[CustomerGroupID] [uniqueidentifier] NOT NULL,
[CustomerID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CustomerGroupDetail_CustomerID] DEFAULT ([Customers].[f_CustomerGetFirstID]()),
[Customer] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CustomerGroupDetail_Customer] DEFAULT ([Customers].[f_CustomerGetFirstName]()),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_CustomerGroupDetail_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_CustomerGroupDetail_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_CustomerGroupDetail_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Customers].[tr_CustomerGroupDetail] ON [Customers].[t_CustomerGroupDetail]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Customers.t_CustomerGroupDetail
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_CustomerGroupDetail.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'customerGroupDetail'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'customerGroupDetail'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, CustomerGroup, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCustomer, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Customers].[t_CustomerGroupDetail] ADD CONSTRAINT [PK_t_CustomerGroupDetail] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_CustomerGroupDetail_CustomerGroupID_CustomerID] ON [Customers].[t_CustomerGroupDetail] ([CustomerGroupID], [CustomerID]) ON [PRIMARY]
GO
ALTER TABLE [Customers].[t_CustomerGroupDetail] ADD CONSTRAINT [CustomerGroupKeyCustomerGroupDetail] FOREIGN KEY ([CustomerGroupID]) REFERENCES [Customers].[t_CustomerGroup] ([ID])
GO
ALTER TABLE [Customers].[t_CustomerGroupDetail] ADD CONSTRAINT [CustomerKeyCustomerGroupDetail] FOREIGN KEY ([CustomerID]) REFERENCES [Customers].[t_Customer] ([ID])
GO
