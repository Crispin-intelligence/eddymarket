SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_WarehouseRebuildingStatisticsOf] @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Rebuilding statistics

            UPDATE Company.t_WareHouse
            SET UserIs = Users.f_UserGetName(UserID),
                Phones = Alls.f_FixXML(
                         (
                             SELECT N', ' + t.NumberIs + CASE t.ExtensionIs
                                                             WHEN N'' THEN
                                                                 N''
                                                             ELSE
                                                                 N': ' + t.ExtensionIs
                                                         END AS [text()]
                             FROM Company.t_BookPhone AS t
                             WHERE t.OwnerID = t_WareHouse.ID
                                   AND t.SectionID = 42
                             FOR XML PATH('')
                         )
                                      ),
                PhonesC =
                (
                    SELECT COUNT(t.ID)
                    FROM Company.t_BookPhone AS t
                    WHERE t.OwnerID = t_WareHouse.ID
                          AND t.SectionID = 42
                ),
                SocialMedia = Alls.f_FixXML(
                              (
                                  SELECT N', ' + t.AccountIs AS [text()]
                                  FROM Company.t_SocialMedia AS t
                                  WHERE t.OwnerID = t_WareHouse.ID
                                        AND t.SectionID = 42
                                  FOR XML PATH('')
                              )
                                           ),
                SocialMediaC =
                (
                    SELECT COUNT(t.ID)
                    FROM Company.t_SocialMedia AS t
                    WHERE t.OwnerID = t_WareHouse.ID
                          AND t.SectionID = 42
                ),
                StatesIs = Location.f_StatesGetName(StatesID),
                RegionIs = Location.f_RegionGetName(RegionID),
                Street = Location.f_StreetGetName(StreetID),
                Building = Location.f_BuildingGetName(BuildingID),
                FloorIs = Location.f_FloorGetName(FloorID),
                PostalCode = Location.f_PostalCodeGetName(PostalCodeID),
                PlaceC =
                (
                    SELECT COUNT(*)
                    FROM Company.t_Place AS s
                    WHERE s.WareHouseID = t_WareHouse.ID
                ),
                UserC =
                (
                    SELECT COUNT(*)
                    FROM Company.t_WarehouseUser AS s
                    WHERE s.WarehouseID = t_WareHouse.ID
                ),
                ItemC =
                (
                    SELECT COUNT(*)
                    FROM Items.t_Item AS s
                    WHERE s.WareHouseID = t_WareHouse.ID
                ),
                Qtys =
                (
                    SELECT COALESCE(SUM(s.QtyCurrent), 0)
                    FROM Items.t_Item AS s
                    WHERE s.WareHouseID = t_WareHouse.ID
                ),
                Purchase =
                (
                    SELECT COALESCE(SUM(s1.PurchaseD * s.QtyCurrent), 0)
                    FROM Items.t_Item AS s
                        LEFT JOIN Items.t_ItemShared AS s1
                            ON s1.ID = s.SharedID
                    WHERE s.WareHouseID = t_WareHouse.ID
                ),
                Sell =
                (
                    SELECT COALESCE(SUM(s1.SellD * s.QtyCurrent), 0)
                    FROM Items.t_Item AS s
                        LEFT JOIN Items.t_ItemShared AS s1
                            ON s1.ID = s.SharedID
                    WHERE s.WareHouseID = t_WareHouse.ID
                ),
                UsersNames = Alls.f_FixXML(
                             (
                                 SELECT ', ' + t1.Name AS [text()]
                                 FROM Company.t_WarehouseUser AS t
                                     LEFT JOIN Users.t_User AS t1
                                         ON t1.ID = t.UserID
                                 WHERE t.WarehouseID = t_WareHouse.ID
                                 FOR XML PATH('')
                             )
                                          )
            WHERE ID = @ID;

            UPDATE Company.t_WareHouse
            SET AddressIs = Location.f_ConcetFullAddress(
                                                            StatesIs,
                                                            RegionIs,
                                                            Street,
                                                            Building,
                                                            FloorIs,
                                                            PostalCode,
                                                            AddressNote,
                                                            ' - ',
                                                            '-'
                                                        ),
                PurchaseF = Currencys.f_FormatD(Purchase),
                SellF = Currencys.f_FormatD(Sell)
            WHERE ID = @ID;

        END;

        BEGIN --Rebuilding statistics t_WarehouseUser

            UPDATE Company.t_WarehouseUser
            SET Warehouse = Company.f_WareHouseGetName(WarehouseID),
                UserIs = Users.f_UserGetName(UserID)
            WHERE WarehouseID = @ID;

        END;

        COMMIT TRAN;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN 0;

    END CATCH;

END;


GO
