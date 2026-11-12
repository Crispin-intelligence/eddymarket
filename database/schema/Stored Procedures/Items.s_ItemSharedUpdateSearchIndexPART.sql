SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Items].[s_ItemSharedUpdateSearchIndexPART] @ID UNIQUEIDENTIFIER
AS
BEGIN

  DECLARE @SearchIndex Alls.td_String;

  INSERT  INTO @SearchIndex
          ( Name
          )
  SELECT  t.Name
  FROM    Items.t_ItemShared AS t
  WHERE   ID = @ID
  UNION ALL
  SELECT  t.Barcodes
  FROM    Items.t_ItemShared AS t
  WHERE   ID = @ID;

  UPDATE  Items.t_ItemShared
  SET     SearchIndex = Alls.f_ToSearchIndex(@SearchIndex) ,
          SearchText = Items.f_ItemSharedSearchTextGet(ID)
  WHERE   ID = @ID;

END;
GO
