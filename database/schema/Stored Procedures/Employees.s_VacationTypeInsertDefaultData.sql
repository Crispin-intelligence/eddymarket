SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Employees].[s_VacationTypeInsertDefaultData]
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Check

            IF EXISTS (SELECT TOP (1) ID FROM Employees.t_VacationType)
            BEGIN

                COMMIT TRAN;

                RETURN 1;

            END;

        END;

        BEGIN --Insert

            INSERT Employees.t_VacationType
            (
                Name
            )
            VALUES
            (N'رأس السنة الميلادية'),
            (N'عيد الميلاد المجيد ش'),
            (N'عيد مار مارون'),
            (N'يوم الأبجدية'),
            (N'عيد المعلّم'),
            (N'عيد الأم'),
            (N'عيد الطفل'),
            (N'عيد بشارة السيدة مريم العذراء'),
            (N'ذكرى مجزرة قانا'),
            (N'الجمعة العظيمة غ'),
            (N'عيد الفصح المجيد غ'),
            (N'الجمعة العظيمة ش'),
            (N'عيد الفصح المجيد ش'),
            (N'عيد العمال'),
            (N'ذكرى الشهداء'),
            (N'عيد المقاومة والتحرير'),
            (N'عيد الفطر السعيد'),
            (N'عيد الأب'),
            (N'عيد الجيش'),
            (N'عيد الأضحى المبارك'),
            (N'عيد إنتقال العذراء'),
            (N'رأس السنة الهجرية'),
            (N'ذكرى عاشوراء'),
            (N'عيد جميع القديسين'),
            (N'المولد النبوي الشريف'),
            (N'عيد العلم'),
            (N'عيد الإستقلال'),
            (N'عيد الميلاد المجيد غ');

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
