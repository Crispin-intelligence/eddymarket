SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_BankFormat] @ID UNIQUEIDENTIFIER
AS
BEGIN

  UPDATE  Company.t_Bank
  SET     Phones = Alls.f_FixXML(( SELECT N', ' + t.NumberIs + CASE t.ExtensionIs
                                                                 WHEN N'' THEN N''
                                                                 ELSE N': ' + t.ExtensionIs
                                                               END AS [text()]
                                   FROM   Company.t_BookPhone AS t
                                   WHERE  t.OwnerID = t_Bank.ID
                                          AND t.SectionID = 38
                                 FOR
                                   XML PATH('')
                                 )) ,
          PhonesC = ( SELECT  COUNT(t.ID)
                      FROM    Company.t_BookPhone AS t
                      WHERE   t.OwnerID = t_Bank.ID
                              AND t.SectionID = 38
                    ) ,
          SocialMedia = Alls.f_FixXML(( SELECT  N', ' + t.AccountIs AS [text()]
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
                         ) ,
          StatesIs = Location.f_StatesGetName(StatesID) ,
          RegionIs = Location.f_RegionGetName(RegionID) ,
          Street = Location.f_StreetGetName(StreetID) ,
          Building = Location.f_BuildingGetName(BuildingID) ,
          FloorIs = Location.f_FloorGetName(FloorID) ,
          PostalCode = Location.f_PostalCodeGetName(PostalCodeID)
  WHERE   ID = @ID;

  UPDATE  Company.t_Bank
  SET     AddressIs = Location.f_ConcetFullAddress(StatesIs, RegionIs, Street, Building, FloorIs, PostalCode, AddressNote, ' - ', '-')
  WHERE   ID = @ID;

  UPDATE  Company.t_Bank
  SET     SearchText = Company.f_BankSearchTextGet(ID)
  WHERE   ID = @ID;

END;

GO
