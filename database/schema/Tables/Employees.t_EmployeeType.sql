CREATE TABLE [Employees].[t_EmployeeType]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_EmployeeType_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_EmployeeType_Name] DEFAULT ('-'),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_EmployeeType_DescriptionIs] DEFAULT (''),
[EmployeeC] [int] NOT NULL CONSTRAINT [DF_t_EmployeeType_EmployeeC] DEFAULT ((0)),
[TeamC] [int] NOT NULL CONSTRAINT [DF_t_EmployeeType_TeamC] DEFAULT ((0)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_EmployeeType_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_EmployeeType_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_EmployeeType_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_EmployeeType_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Employees].[tr_EmployeeType] ON [Employees].[t_EmployeeType]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Employees.t_EmployeeType
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_EmployeeType.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'employeeType'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'employeeType'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, EmployeeType, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaEmployee, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Employees].[t_EmployeeType] ADD CONSTRAINT [PK_t_EmployeeType] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_t_EmployeesTypeName] ON [Employees].[t_EmployeeType] ([Name]) ON [PRIMARY]
GO
