SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Alls].[s_SectionInsertDefaultData]
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Check

            IF EXISTS (SELECT TOP (1) ID FROM Alls.t_Section)
            BEGIN

                COMMIT TRAN;

                RETURN 1;

            END;

        END;

        BEGIN --Insert

            INSERT INTO [Alls].[t_Section]
            (
                [SectionID],
                [NameEN],
                [NameAR],
                [DescriptionEN],
                [DescriptionAR],
                [WorkStationID]
            )
            VALUES
            (0, N'Purchase', N'', N'', N'', 1),
            (1, N'Return Purchased', N'', N'', N'', 1),
            (2, N'Sell', N'', N'', N'', 1),
            (3, N'Return Sold', N'', N'', N'', 1),
            (4, N'Quotation', N'', N'', N'', 1),
            (5, N'Quotation History', N'', N'', N'', 1),
            (6, N'Reason', N'', N'', N'', 1),
            (7, N'Stock Adjustment', N'', N'', N'', 1),
            (8, N'Expense', N'', N'', N'', 1),
            (9, N'Open Box', N'', N'', N'', 1),
            (10, N'Item', N'', N'', N'', 1),
            (11, N'Pay Salary', N'', N'', N'', 1),
            (12, N'Inventory Adjustment', N'', N'', N'', 1),
            (13, N'Qty Of First Period', N'', N'', N'', 1),
            (14, N'User', N'', N'', N'', 1),
            (15, N'Customer', N'', N'', N'', 1),
            (16, N'Addresses', N'', N'', N'', 1),
            (17, N'Internet Package', N'', N'', N'', 1),
            (18, N'Internet Subscription', N'', N'', N'', 1),
            (19, N'Sold Return Accrual', N'', N'', N'', 1),
            (20, N'Purchase Accrual', N'', N'', N'', 1),
            (21, N'Purchased Return Accrual', N'', N'', N'', 1),
            (22, N'Purchase Details', N'', N'', N'', 1),
            (23, N'Purchased Return Details', N'', N'', N'', 1),
            (24, N'Sell Details', N'', N'', N'', 1),
            (25, N'Sold Return Details', N'', N'', N'', 1),
            (26, N'Quotation Details', N'', N'', N'', 1),
            (27, N'Quotation History Details', N'', N'', N'', 1),
            (28, N'Request Details', N'', N'', N'', 1),
            (29, N'Request Details History', N'', N'', N'', 1),
            (30, N'Contract Clauses Objects', N'', N'', N'', 1),
            (31, N'Contract Clauses Objects History', N'', N'', N'', 1),
            (32, N'Inventory Adjustment Details', N'', N'', N'', 1),
            (33, N'Employee', N'', N'', N'', 1),
            (34, N'Employee Type', N'', N'', N'', 1),
            (35, N'Caller Log', N'', N'', N'', 1),
            (36, N'Caller Type', N'', N'', N'', 1),
            (37, N'Account', N'', N'', N'', 1),
            (38, N'Bank', N'', N'', N'', 1),
            (39, N'Generator', N'', N'', N'', 1),
            (40, N'WarehousePlace', N'', N'', N'', 1),
            (41, N'Power', N'', N'', N'', 1),
            (42, N'Warehouse', N'', N'', N'', 1),
            (43, N'Currency', N'', N'', N'', 1),
            (44, N'Tax', N'', N'', N'', 1),
            (45, N'Classification', N'', N'', N'', 1),
            (46, N'Title', N'', N'', N'', 1),
            (47, N'Nationality', N'', N'', N'', 1),
            (48, N'Teams', N'', N'', N'', 1),
            (49, N'Subscription', N'', N'', N'', 1),
            (50, N'Transfer', N'', N'', N'', 1),
            (51, N'Brand', N'', N'', N'', 1),
            (52, N'Main Catery', N'', N'', N'', 1),
            (53, N'Sub Catery', N'', N'', N'', 1),
            (54, N'Unity', N'', N'', N'', 1),
            (55, N'States', N'', N'', N'', 1),
            (56, N'Region', N'', N'', N'', 1),
            (57, N'Street', N'', N'', N'', 1),
            (58, N'Floor', N'', N'', N'', 1),
            (59, N'Building', N'', N'', N'', 1),
            (60, N'Clause Type', N'', N'', N'', 1),
            (61, N'Quotation Note', N'', N'', N'', 1),
            (62, N'Quotation Template', N'', N'', N'', 1),
            (63, N'Quotation Warranty', N'', N'', N'', 1),
            (64, N'Request Type', N'', N'', N'', 1),
            (65, N'Transaction', N'', N'', N'', 1),
            (66, N'Permission', N'', N'', N'', 1),
            (67, N'Vendor', N'', N'', N'', 1),
            (68, N'Account Email', N'', N'', N'', 1),
            (69, N'None', N'', N'', N'', 1),
            (70, N'Report Header Footer', N'', N'', N'', 1),
            (71, N'File Storage Types', N'', N'', N'', 1),
            (72, N'File Storage', N'', N'', N'', 1),
            (73, N'Contract Clauses Visit', N'', N'', N'', 1),
            (74, N'Request Visit', N'', N'', N'', 1),
            (75, N'FeedBack Types', N'', N'', N'', 1),
            (76, N'FeedBack', N'', N'', N'', 1),
            (77, N'Task Type', N'', N'', N'', 1),
            (78, N'Task', N'', N'', N'', 1),
            (79, N'Task Employee Do', N'', N'', N'', 1),
            (80, N'Task Employee Do History', N'', N'', N'', 1),
            (81, N'Cheque', N'', N'', N'', 1),
            (82, N'Beneficiary', N'', N'', N'', 1),
            (83, N'Account Points', N'', N'', N'', 1),
            (84, N'Recharge Account Points', N'', N'', N'', 1),
            (85, N'User Login', N'', N'', N'', 1),
            (86, N'User Login Spying', N'', N'', N'', 1),
            (87, N'Delivery Pricing', N'', N'', N'', 1),
            (88, N'Delivery', N'', N'', N'', 1),
            (89, N'Rules', N'', N'', N'', 1),
            (90, N'Vacation Type', N'', N'', N'', 1),
            (91, N'Vacation', N'', N'', N'', 1),
            (92, N'Permission (Exit \ Entry) Type', N'', N'', N'', 1),
            (93, N'Permission (Exit \ Entry)', N'', N'', N'', 1),
            (94, N'Discount Type', N'', N'', N'', 1),
            (95, N'Discount', N'', N'', N'', 1),
            (96, N'Transaction PV', N'', N'', N'', 1),
            (97, N'Transaction RV', N'', N'', N'', 1),
            (98, N'Addition', N'', N'', N'', 1),
            (99, N'TableArea', N'', N'', N'', 1),
            (100, N'Table', N'', N'', N'', 1),
            (101, N'Stock Take', N'', N'', N'', 1),
            (102, N'Inventory Report', N'', N'', N'', 1);

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
