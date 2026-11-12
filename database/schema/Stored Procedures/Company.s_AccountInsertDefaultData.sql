SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_AccountInsertDefaultData]
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Check

            IF EXISTS ( SELECT TOP ( 1 )
                                ID
                        FROM    Company.t_Account )
            BEGIN

                COMMIT TRAN;

                RETURN 1;

            END;

        END;

        DISABLE TRIGGER Company.tr_Account ON Company.t_Account;
        DISABLE TRIGGER Company.tr_AccountLevel1 ON Company.t_AccountLevel1;
        DISABLE TRIGGER Company.tr_AccountLevel2 ON Company.t_AccountLevel2;
        DISABLE TRIGGER Company.tr_AccountLevel3 ON Company.t_AccountLevel3;

        BEGIN --Level 1

            INSERT  [Company].[t_AccountLevel1]
                    ( NumberIs, NumberF, Name )
            VALUES  ( 10, N'10', N'رأس المال' ),
                    ( 11, N'11', N'الإحتياطات' ),
                    ( 12, N'12', N'نتائج سابقة مدورة' ),
                    ( 13, N'13', N'النتيجة الصافية للدورة المالية - ربح أو خسارة' ),
                    ( 14, N'14', N'إعانات للتوظيفات' ),
                    ( 15, N'15', N'مؤونات لمواجهة أخطار وأعباء' ),
                    ( 16, N'16', N'ديون مالية طويلة ومتوسطة الأجل' ),
                    ( 21, N'21', N'الأصول الثابتة غير المادية' ),
                    ( 22, N'22', N'الأصول الثابتة المادية' ),
                    ( 25, N'25', N'الأصول الثابتة المالية' ),
                    ( 28, N'28', N'استهلاكات المؤسسة التجارية - الشهرة' ),
                    ( 37, N'37', N'البضائع المعدة للبيع' ),
                    ( 40, N'40', N'الموردون' ),
                    ( 41, N'41', N'الزبائن' ),
                    ( 42, N'42', N'المستخدمون' ),
                    ( 43, N'43', N'مؤسسات الضمان الإجتماعي' ),
                    ( 44, N'44', N'الدولة والمؤسسات العامة' ),
                    ( 45, N'45', N'الشركاء' ),
                    ( 46, N'46', N'ذمم مختلفة' ),
                    ( 47, N'47', N'حسابات التسوية' ),
                    ( 50, N'50', N'سندات التوظيف' ),
                    ( 51, N'51', N'المؤسسات المالية' ),
                    ( 53, N'53', N'الصندوق' ),
                    ( 60, N'60', N'مشتريات' ),
                    ( 61, N'61', N'مواد أولية واستهلاكية مستخدمة' ),
                    ( 62, N'62', N'أعباء خارجية أخرى' ),
                    ( 63, N'63', N'اعباء المستخدمين' ),
                    ( 64, N'64', N'ضرائب ورسوم ومدفوعات مماثلة' ),
                    ( 65, N'65', N'مخصصات الإستهلاكات والمؤونات للإستثمار' ),
                    ( 66, N'66', N'أعباء ادارية عادية أخرى' ),
                    ( 67, N'67', N'الأعباء المالية' ),
                    ( 68, N'68', N'اعباء خارج الإستثمار' ),
                    ( 69, N'69', N'الضرائب على الأرباح' ),
                    ( 70, N'70', N'مبيعات' ),
                    ( 71, N'71', N'المنتجات المباعة' ),
                    ( 72, N'72', N'الإنتاج المخزون (قيمة التغيير)' ),
                    ( 73, N'73', N'منتجات لها طابع الأصول الثابتة' ),
                    ( 74, N'74', N'إعانات للإستثمار' ),
                    ( 75, N'75', N'استردادات من المؤونات للإستثمار' ),
                    ( 76, N'76', N'ايرادات أخرى ناتجة عن الإستثمار' ),
                    ( 77, N'77', N'الإيرادات المالية' ),
                    ( 78, N'78', N'إيرادات خارج الإستثمار' );

        END;

        BEGIN --Level 2

            INSERT  [Company].[t_AccountLevel2]
                    ( Level1ID, NumberIs, NumberF, Name )
            VALUES  ( [Company].[f_AccountLevel1GetIDByNumber](10), 101, N'101', N'رأس المال - للشركة أو للشخص' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](10), 102, N'102', N'علاوات الإصدار والإندماج والمقدمات' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](10), 103, N'103', N'فروقات إعادة التخمين' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](10), 109, N'109', N'الحساب الشخصي لصاحب المؤسسة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](11), 111, N'111', N'إحتياطي قانوني' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](11), 112, N'112', N'احتياطيات نظامية وتعاقدية' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](11), 119, N'119', N'احتياطات اخرى' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](12), 121, N'121', N'نتائج سابقة مدورة دائنة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](12), 125, N'125', N'نتائج سابقة مدورة مدينة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](13), 131, N'131', N'الهامش التجاري القائم' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](13), 132, N'132', N'القيمة المضافة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](13), 133, N'133', N'الفائض غير الصافي للإستثمار' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](13), 134, N'134', N'نتيجة الإستثمار - خارج الأعباء والإيرادات المالية' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](13), 135, N'135', N'النتيجة الجارية قبل الضريبة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](13), 136, N'136', N'النتيجة خارج الإستثمار' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](13), 138, N'138', N'نتيجة الدورة - أرباح' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](13), 139, N'139', N'نتيجة الدورة - خسائر' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](14), 141, N'141', N'اعانات للتوظيفات مقبوضة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](14), 145, N'145', N'اعانات للتوظيفات محولة للنتائج' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](15), 151, N'151', N'مؤونات لمواجهة أخطار' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](15), 155, N'155', N'مؤونات لمواجهة أعباء' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](16), 161, N'161', N'قروض لقاء سندات دين' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](16), 162, N'162', N'قروض من مؤسسات التسليف' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](16), 168, N'168', N'قروض وديون مختلفة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](21), 211, N'211', N'المؤسسات التجارية - الخلو، الشهرة، الزبائن' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](21), 212, N'212', N'مصاريف التأسيس' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](21), 213, N'213', N'مصاريف البحوث والتطوير' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](21), 214, N'214', N'براءات الإختراع-الإجازات-العلامات والقيم المماثلة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](21), 219, N'219', N'أصول ثابتة غير مادية أخرى' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](22), 221, N'221', N'الأراضي' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](22), 223, N'223', N'الأبنية' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](22), 224, N'224', N'التجهيزات الفنية- والآلات الصناعية' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](22), 225, N'225', N'اليات النقل' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](22), 226, N'226', N'أصول ثابتة مادية أخرى' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](22), 227, N'227', N'أصول ثابتة مادية قيد الصنع' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](22), 228, N'228', N'سلفات ودفعات على حساب شراء أصول ثابتة مادية' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](25), 251, N'251', N'سندات مشا ركة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](25), 252, N'252', N'ذمم مدينة مرتبطة بمشاركات' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](25), 253, N'253', N'سندات أخرى مجمدة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](25), 255, N'255', N'قروض طويلة ومتوسطة الأجل (ممنوحة من المؤسسة)' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](25), 259, N'259', N'ذمم مدينة أخرى مجمدة (ودائع وتأمينات)' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](28), 281, N'281', N'استهلاكات الاصول الثابتة غير المادية الاخرى' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](28), 282, N'282', N'استهلاكات الاصول الثابتة المادية' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](40), 401, N'401', N'ذمم دائنة - موردو الإستثمار' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](40), 403, N'403', N'موردو الأصول الثابتة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](40), 409, N'409', N'سلفات ودفعات على حساب طلبيات للإستثمار (صدفة مدين)' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](41), 411, N'411', N'فواتير الزبائن' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](41), 413, N'413', N'أوراق قبض - زبائن' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](41), 415, N'415', N'ذمم مدينة على أشغال لم تبلغ مرحلة تحرير فواتير بها' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](41), 418, N'418', N'فواتير قيد الإعداد (عند إرسال البضاعة)' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](42), 421, N'421', N'مدفوعات متوجبة للمستخدمين (حساب دائن)' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](42), 428, N'428', N'حسابات المستخدمين المدينة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](43), 431, N'431', N'ذمم دائنة تجاه مؤسسات الضمان الإجتماعي' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](43), 438, N'438', N'ذمم مدينة على مؤسسات الضمان الإجتماعي' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](44), 441, N'441', N'ضرائب متوجبة على الإستثمار' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](44), 442, N'442', N'الدولة و المؤسسات المالية' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](44), 443, N'443', N'ضرائب متوجبة خارج الإستثمار' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](44), 445, N'445', N'الدولة والمؤسسات العامة - ذمم دائنة أخرى' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](44), 449, N'449', N'الدولة والمؤسسات العامة - ذمم مدينة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](45), 451, N'451', N'حسابات الشركاء الجارية المدينة أو الدائنة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](45), 453, N'453', N'أنصبة أرباح برسم الدفع' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](45), 455, N'455', N'ذمم دائنة أخرى للشركاء' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](45), 459, N'459', N'ذمم الشركاء المدينة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](46), 461, N'461', N'ذمم الإستثمار الدائنة الأخرى' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](46), 463, N'463', N'اقساط برسم الدفع على أصول صابتة مالية' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](46), 465, N'465', N'دائنون مختلفون خارج الإستثمار' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](46), 468, N'468', N'مدينون مختلفون للإستثمار' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](46), 469, N'469', N'مدينون مختلفون - خارج الإستثمار' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](47), 471, N'471', N'الأعباء الواجب توزيعها على عدة دورات' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](47), 472, N'472', N'أعباء محتسبة مسبقا (أعباء مدفوعة مقدما)' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](47), 473, N'473', N'ايرادات محتسبة مسبقا (ايرادات مقبوضة مقدما)' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](47), 474, N'474', N'اعباء برسم الدفع' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](47), 475, N'475', N'فروقات صرف - خصوم' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](47), 476, N'476', N'فروقات صرف - أصول' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](50), 501, N'501', N'أسهم صادرة عن الشركة ومعاد شراؤها من قبلها' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](50), 502, N'502', N'سندات تمنح حامليها حق الملكية' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](50), 506, N'506', N'سندات تمنح حامليها حقوق الدائنين' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](51), 511, N'511', N'شيكات وقسائم برسم القبض' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](51), 512, N'512', N'بنوك' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](51), 519, N'519', N'مؤسسات التمويل' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](53), 531, N'531', N'صندوق' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](60), 601, N'601', N'مشتريات عامة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](60), 605, N'605', N'قيمة التغيير في مخزون البضاعة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](60), 609, N'609', N'خصم مكتسب' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](61), 611, N'611', N'مشتريات المواد الاولية والاستهلاكية' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](61), 615, N'615', N'قيمة التغيير في مخزون المواد الاولية والاستهلاكية' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](61), 619, N'619', N'أعباء مالية' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](62), 621, N'621', N'مشتريات من ملتزمين ثانويين' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](62), 625, N'625', N'الاتاوى' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](62), 626, N'626', N'الخدمات الخارجية' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](63), 631, N'631', N'رواتب وأجور المستخدمين' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](63), 635, N'635', N'أعباء إجتماعية - ضمان أجتماعي' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](64), 641, N'641', N'على الرواتب والأجور وبدلات الأتعاب' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](64), 642, N'642', N'ضرائب ورسوم للبلديات' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](64), 643, N'643', N'ضرائب على المبيعات غير القابلة للإستردات' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](64), 644, N'644', N'رسوم تسجيل' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](64), 645, N'645', N'ضرائب ورسوم ومدفوعات مماثلة أخرى' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](65), 651, N'651', N'مخصصات الإستهلاك' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](65), 655, N'655', N'مخصصات المؤونات' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](66), 661, N'661', N'أعباء ادارية أخرى' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](66), 665, N'665', N'حصة المؤسسة من الخسائر على عمليات مشتركة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](67), 673, N'673', N'فوائد وأعباء مشابهة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](67), 675, N'675', N'فروقات الصرف السلبية' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](67), 676, N'676', N'اعباء صافية على عمليات التفرغ عن سندات توظيف' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](67), 679, N'679', N'مخصصات الإستهلاكات والمؤونات المالية' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](68), 681, N'681', N'القيمة الدفترية للأصول الثابتة المتفرغ عنها' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](68), 685, N'685', N'أعباء أخرى خارج الإستثمار' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](68), 689, N'689', N'مخصصات الإستهلاكات والمؤونات خارج الإستثمار' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](70), 701, N'701', N'مبيعات عامة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](70), 709, N'709', N'خصم ممنوح' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](71), 711, N'711', N'مبيعات' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](71), 712, N'712', N'أشغال' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](71), 713, N'713', N'خدمات' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](71), 717, N'717', N'ايرادات النشاطات المرعية' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](71), 719, N'719', N'حسومات ممنوحة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](72), 721, N'721', N'قيد الصنع - أموال' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](72), 722, N'722', N'قيد الصنع خدمات' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](72), 725, N'725', N'منتجات' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](73), 731, N'731', N'أصول ثابتة غير مادية' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](73), 732, N'732', N'أصول ثابتة مادية' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](74), 741, N'741', N'للبضائع' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](74), 742, N'742', N'للإنتاج' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](75), 752, N'752', N'استردادات من مؤونات هبوط أسعار الأصول الثابتة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](75), 753, N'753', N'استردادات من مؤونات هبوط أسعار الأصول المتداولة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](75), 755, N'755', N'استردادات من مؤونات أخطار وأعباء للإستثمار' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](76), 761, N'761', N'ايرادات عادية أخرى' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](76), 765, N'765', N'حصص أرباح العمليات المشتركة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](77), 771, N'771', N'إيرادات سندات المشاركة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](77), 772, N'772', N'إيرادات القيم المنقولة الأخرى' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](77), 773, N'773', N'فوائد وإيرادات مشابهة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](77), 775, N'775', N'فروقات الصرف الإيجابية' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](77), 778, N'778', N'إيرادات مالية أخرى' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](77), 779, N'779', N'إستردادات من المؤونات المالية' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](78), 781, N'781', N'إيرادات التفرغ عن أصول ثابتة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](78), 782, N'782', N'إعانات للتوظيفات محوّلة إلى نتيجة الدورة' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](78), 788, N'788', N'إيرادات أخرى خارج الإستثمار' ),
                    ( [Company].[f_AccountLevel1GetIDByNumber](78), 789, N'789', N'إستردادات من مؤونات خارج الإستثمار' );

        END;

        BEGIN --Level 3

            INSERT  [Company].[t_AccountLevel3]
                    ( Level2ID, NumberIs, NumberF, Name )
            VALUES  ( [Company].[f_AccountLevel2GetIDByNumber](101), 10101, N'10101', N'رأس المال المكتتب غير المستدعى' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](101), 10102, N'10102', N'رأس المال المكتتب المستدعى وغير المدفوع' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](101), 10103, N'10103', N'رأس المال المكتتب المستدعى والمدفوع' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](102), 10201, N'10201', N'علاوات الإصدار' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](102), 10202, N'10202', N'علاوات الإندماج' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](102), 10203, N'10203', N'علاوات المقدمات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](102), 10204, N'10204', N'علاوات تحويل السندات إلى أسهم' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](121), 12101, N'12101', N'نتائج مدورة دائنة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](125), 12501, N'12501', N'نتائج مدورة مدينة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](138), 13801, N'13801', N'ارباح' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](139), 13901, N'13901', N'خسائر' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](151), 15101, N'15101', N'مؤونات للمنازعات والإحتمالات المختلفة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](151), 15102, N'15102', N'مؤونات لقاء الضمانات المعطاة للزبائن' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](151), 15103, N'15103', N'مؤونات خسائر سعر الصرف' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](151), 15104, N'15104', N'مؤونات خسائر على عقود لأجل' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](151), 15105, N'15105', N'مؤونات الغرامات والجزاءات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](155), 15501, N'15501', N'مؤونات الأعباء الواجب توزيعها على عدة دورات مالية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](155), 15502, N'15502', N'مؤونات لمواجهة معاشات التقاعد والموجبات المماثلة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](155), 15503, N'15503', N'مؤونات للضرائب' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](168), 16801, N'16801', N'أوراق دفع ناجمة عن شراء المؤسسة التجارية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](168), 16802, N'16802', N'ودائع وكفالات (مقبوضة)' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](168), 16803, N'16803', N'سلفات الدولة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](168), 16804, N'16804', N'دخل لمدى الحياة متراكم' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](168), 16809, N'16809', N'ديون أخرى طويلة ومتوسطة الأجل' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](219), 21908, N'21908', N'سلفات ودفعات على حساب تقديم أصول ثابتة مادية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](221), 22101, N'22101', N'الأراضي الفراغ' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](221), 22102, N'22102', N'الأراضي المبنية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](221), 22103, N'22103', N'الأراضي برسم الإستثمار الجوفي - مناجم- مقاليع' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](221), 22104, N'22104', N'استصلاح وتنظيم الأراضي' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](223), 22301, N'22301', N'الأبنية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](223), 22302, N'22302', N'التجهيزات العامة - استصلاح وتنظيم الأبنية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](223), 22303, N'22303', N'انشاءات البنية التحتية - سدود - مدارج المطارات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](223), 22304, N'22304', N'انشاءات على أراضي الغير' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](224), 22401, N'22401', N'تجهيزات متخصصة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](224), 22402, N'22402', N'تجهيزات ذات طبيعة خاصة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](224), 22403, N'22403', N'المعدات الصناعية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](224), 22404, N'22404', N'الأدوات الصناعية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](226), 22602, N'22602', N'أدوات مكتبية ومعلوماتية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](226), 22603, N'22603', N'أثاث' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](226), 22604, N'22604', N'استثمارات زراعية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](226), 22605, N'22605', N'عبوات قابلة لإعادة الإستعمال' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](227), 22701, N'22701', N'أراضي' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](227), 22703, N'22703', N'أبنية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](227), 22704, N'22704', N'تجهيزات فنية- معدات-وأدوات صناعية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](227), 22706, N'22706', N'أصول ثابتة مادية أخرى' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](253), 25301, N'25301', N'سندات ملكية - اسهم. حصص شراكة -' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](253), 25305, N'25305', N'سندات دين - سندات. قسائم' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](255), 25501, N'25501', N'قروض للشركاء' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](255), 25502, N'25502', N'قروض للمستخدمين' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](255), 25508, N'25508', N'قروض أخرى' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](401), 40101, N'40101', N'فواتير (الموردون)' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](401), 40105, N'40105', N'أوراق دفع' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](401), 40108, N'40108', N'فواتير لم تصل بعد (عند إستلام البضاعة)' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](403), 40305, N'40305', N'أوراق دفع' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](403), 40308, N'40308', N'فواتير لم تصل بعد (عند الإستلام)' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](411), 41101, N'41101', N'زبائن عاديون' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](411), 41105, N'41105', N'زبائن مشكوك بتحصيل ديونهم' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](421), 42101, N'42101', N'مدفوعات متوجبة للمستخدمين (حساب دائن)' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](428), 42801, N'42801', N'سلفات ودفعات للمستخدمين' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](428), 42802, N'42802', N'حجوزات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](431), 43101, N'43101', N'تقديمات برسم الدفع' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](431), 43105, N'43105', N'أوراق الدفع - مؤسسات الضمان الإجتماعي' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](431), 43108, N'43108', N'أعباء يجب لحظها - مؤسسات الضمان الإجتماعي' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](441), 44101, N'44101', N'ضرائب ورسوم متوجبة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](441), 44105, N'44105', N'أوراق دفع - ضرائب ورسوم' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](441), 44108, N'44108', N'أعباء يجب لحظها - ضرائب ورسوم' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](442), 44210, N'44210', N'ضريبة مدفوعة على المشتريات منتجات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](442), 44218, N'44218', N'ضريبة مدفوعة على المشتريات الخدمات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](442), 44251, N'44251', N'الضريبة المتوجب دفعها على القيمة المضافة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](442), 44262, N'44262', N'ضريبة مسددة على شراء أصول ثابتة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](442), 44263, N'44263', N'ضريبة مسددة على شراء سلع' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](442), 44266, N'44266', N'ضريبة مسددة على شراء خدمات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](442), 44269, N'44269', N'الضريبة على القيمة المضافة المدورة للإسترجاع' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](442), 44270, N'44270', N'ضريبة محصلة على مبيع منتجات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](442), 44271, N'44271', N'ضريبة محصلة على مبيع خدمات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](443), 44301, N'44301', N'الضرائب على الأرباح' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](449), 44901, N'44901', N'إعانات مستحقة غير مقبوضة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](449), 44907, N'44907', N'ذمم مدينة أخرى - الدولة والمؤسسات العامة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](449), 44908, N'44908', N'ايرادات مستحقة غير مقبوضة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](451), 45101, N'45101', N'شركات شقيقة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](451), 45105, N'45105', N'شركاء آخرون' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](451), 45108, N'45108', N'عمليات مشتركة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](451), 45111, N'45111', N'الشركة الأم' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](451), 45112, N'45112', N'الشركة التابعة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](451), 45113, N'45113', N'الشركات المشاركة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](451), 45114, N'45114', N'الشركات الداخلة في عدة مجموعات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](455), 45501, N'45501', N'حسابات المقدمات للشركة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](455), 45502, N'45502', N'رأس المال المقرر استرداده من الشركاء' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](455), 45507, N'45507', N'ذمم دائنة أخرى' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](459), 45901, N'45901', N'رأس المال المكتتب غير المستدعي' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](459), 45902, N'45902', N'رأس المال المكتتب المستدعي وغير مدفوع' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](459), 45907, N'45907', N'ذمم مدينة أخرى' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](461), 46101, N'46101', N'مندوبين المبيعات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](463), 46301, N'46301', N'سندات مشاركة غير محررة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](463), 46303, N'46303', N'سندات أخرى مجمدة غير محررة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](465), 46501, N'46501', N'ذمم دائنة على أمتلاك سندات التوظيف' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](465), 46502, N'46502', N'سندات الدين' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](465), 46509, N'46509', N'دائنون مختلفون - خارج الإستثمار' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](468), 46801, N'46801', N'ذمم مدينة متعلقة بالعبوات والمعدات الواجب إعادتها' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](468), 46809, N'46809', N'حسابات أخرى مدينة مختلفة - للإستثمار' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](469), 46901, N'46901', N'ذمم مدينة على بيع أصول ثابتة وسندات توظيف' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](469), 46909, N'46909', N'حسابات أخرى مدينة مختلفة - خارج الاستثمار' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](471), 47101, N'47101', N'أعباء ما قبل الإستثمار' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](471), 47102, N'47102', N'التصليحات الكبيرة الواجب استهلاكها' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](471), 47103, N'47103', N'علاوات تسديد السندات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](471), 47109, N'47109', N'أعباء أخرى واجب توزيعها على عدة دورات مالية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](475), 47501, N'47501', N'الزيادة في الذمم المدينة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](475), 47502, N'47502', N'التدني في الذمم الدائنة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](475), 47508, N'47508', N'فروقات معوضة بفرق الصرف' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](476), 47601, N'47601', N'التدني في الذمم المدينة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](476), 47602, N'47602', N'التدني في الذمم الدائنة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](476), 47608, N'47608', N'فروقات معوضة بفرق الصرف' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](511), 51101, N'51101', N'البنك/شكات برسم التحصيل$$' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](511), 51102, N'51102', N'البنك/قسائم برسم التحصيل J J' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](511), 51103, N'51103', N'البنك أوراق تجارية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](511), 51104, N'51104', N'شيكات برسم التحصيل ل ل' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](511), 51131, N'51131', N'البنك/ أوراق قبض برسم التحصيل' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](511), 51132, N'51132', N'البنك/ أوراق قبض برسم الرهن' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](511), 51133, N'51133', N'البنك/ أوراق قبض برسم الخصم' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](512), 51201, N'51201', N'البنوك العامة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](531), 53101, N'53101', N'صندوق' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](601), 60101, N'60101', N'مشتريات غير خاضعة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](601), 60102, N'60102', N'مشتريات خاضعة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](601), 60108, N'60108', N'نفقات اضافية على شراء البضائع والعبوات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](601), 60109, N'60109', N'حسومات مكتسبة على المشتريات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](601), 60111, N'60111', N'مشترى سلع ضريبتها مسترجعة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](601), 60112, N'60112', N'مشترى سلع معفاة من الضريبة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](601), 60113, N'60113', N'مشترى سلع ضريبتها غير مسترجعة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](601), 60181, N'60181', N'نقليات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](601), 60182, N'60182', N'سمسرة وعمولات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](601), 60183, N'60183', N'تأمين على الشحن' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](601), 60184, N'60184', N'اتعاب مخلصي البضاعة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](601), 60185, N'60185', N'رسوم جمركية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](605), 60501, N'60501', N'التغير في المخزون' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](609), 60900, N'60900', N'خصم مكتسب' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](609), 60910, N'60910', N'حسم شراء سلع ضريبتها مسترجعة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](609), 60911, N'60911', N'حسم شراء سلع معفاة من الضريبة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](611), 61101, N'61101', N'شراء مواد أولية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](611), 61102, N'61102', N'شراء مواد ولوازم استهلاكية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](611), 61103, N'61103', N'شراء عبوات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](611), 61108, N'61108', N'مصاريف اضافية على شراء مواد اولية واستهلاكية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](611), 61109, N'61109', N'حسومات مكتبية (بالتفصيل)' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](611), 61111, N'61111', N'مشترى مواد أولية ضريبتها مسترجعة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](611), 61112, N'61112', N'مشترى مواد أولية معفاة من الضريبة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](611), 61113, N'61113', N'مشترى مواد أولية ضريبتها غير مسترجعة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](611), 61121, N'61121', N'مشترى مواد إستهلاكية ضريبتها مسترجعة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](611), 61122, N'61122', N'مشترى مواد إستهلاكية معفاة من الضريبة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](611), 61123, N'61123', N'مشترى مواد إستهلاكية ضريبتها غير مسترجعة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](611), 61124, N'61124', N'لوازم للمخزن' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](611), 61125, N'61125', N'لوازم مكتبية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](611), 61131, N'61131', N'عبوات لا تسترد' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](611), 61132, N'61132', N'عبوات تسترد ويعاد استعمالها' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](611), 61133, N'61133', N'عبوات تستعمل على أوجه مختلفة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](611), 61181, N'61181', N'نقليات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](611), 61182, N'61182', N'سمسرة وعمولات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](611), 61183, N'61183', N'تأمين على الشحن' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](611), 61184, N'61184', N'اتعاب مخلصي البضاعة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](611), 61185, N'61185', N'رسوم جمركية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](615), 61501, N'61501', N'مخزون أول المدة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](615), 61502, N'61502', N'مخزون آخر المدة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](615), 61511, N'61511', N'(مواد أولية أول المدة)' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](615), 61512, N'61512', N'(مواد ولوازم استهلاكية أول المدة)' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](615), 61513, N'61513', N'(عبوات أول المدة)' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](615), 61521, N'61521', N'(مواد أولية آخر المدة)' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](615), 61522, N'61522', N'(مواد ولوازم استهلاكية آخر المدة)' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](615), 61523, N'61523', N'(عبوات آخر المدة)' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](619), 61901, N'61901', N'حسومات تفصيلية مكتسبة على اصناف الفواتير' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](621), 62101, N'62101', N'ملتزم ثانوى أ' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](621), 62102, N'62102', N'ملتزم ثانوي ب' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](621), 62109, N'62109', N'حسومات مكتسبة على مشتريات من ملتزمين ثانويين' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](625), 62501, N'62501', N'ايجار - قرض - أموال منقولة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](625), 62502, N'62502', N'ايجار - قرض - أموال غير منقولة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](625), 62503, N'62503', N'حقوق الامتياز' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](625), 62504, N'62504', N'براءات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](625), 62505, N'62505', N'اجازات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](625), 62506, N'62506', N'علامات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](625), 62507, N'62507', N'اساليب' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](625), 62508, N'62508', N'حقوق وقيم مماثلة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62601, N'62601', N'مشترى خدمات ضريبتها مسترجعة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62602, N'62602', N'مشترى خدمات معفاة من الضريبة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62603, N'62603', N'مشترى خدمات ضريبتها غير مسترجعة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62604, N'62604', N'خدمات الفنادق والمطاعم' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62605, N'62605', N'خدمات المستخدمين' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62606, N'62606', N'مصاريف محل' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62607, N'62607', N'الدراسات والبحوث' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62608, N'62608', N'أقساط التأمين' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62609, N'62609', N'خدمات خارجية أخرى' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62611, N'62611', N'نفقات نقل للموجودات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62612, N'62612', N'نفقات النقل المشترك للمستخدمين' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62613, N'62613', N'نقل مبيعات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62615, N'62615', N'نفقات البريد والاتصالات السلكية واللاسلكية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62631, N'62631', N'الايجارات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62632, N'62632', N'اعباء تأجيرية اخرى' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62641, N'62641', N'تشريفات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62642, N'62642', N'نقل وانتقال' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62643, N'62643', N'جمرك' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62651, N'62651', N'المستخدمون المؤقتون' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62652, N'62652', N'اجور الوسطاء' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62653, N'62653', N'بدلات أتعاب' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62661, N'62661', N'الاعداد والتدريب' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62662, N'62662', N'التوثيق' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62691, N'62691', N'خدمات صحية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62692, N'62692', N'خدمات مالية مصاريف على سندات وأوراق مالية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62693, N'62693', N'اعلان' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62694, N'62694', N'مياه' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62695, N'62695', N'كهرباء' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62696, N'62696', N'عمولة مبيعات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62697, N'62697', N'تنظيفات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](626), 62698, N'62698', N'خدمات خارجية أخرى' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](631), 63101, N'63101', N'الرواتب' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](631), 63102, N'63102', N'الأجور' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](631), 63104, N'63104', N'العمولات الثابتة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](631), 63107, N'63107', N'البدلات المدفوعة لأعضاء مجلس الإدارة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](651), 65101, N'65101', N'أصول ثابتة غير مادية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](651), 65102, N'65102', N'أصول ثابتة مادية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](651), 65105, N'65105', N'أعباء للتوزيع على عدة دورات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](655), 65501, N'65501', N'مؤونات هبوط أسعار الأصول الثابتة غير المادية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](655), 65502, N'65502', N'مؤونات هبوط أسعار الأصول الثابتة المادية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](655), 65503, N'65503', N'مؤونات هبوط أسعار المخزون وقيد الصنع' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](655), 65504, N'65504', N'مؤونات هبوط قيم الذمم المدينة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](655), 65505, N'65505', N'مؤونات لمواجهة المخاطر والأعباء العائدة للإستثمار' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](661), 66101, N'66101', N'بدلات حضور' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](673), 67301, N'67301', N'فوائد على الذمم الدائنة والقروض' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](673), 67302, N'67302', N'فوائد على الحسابات الجارية والودائع الدائنة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](673), 67303, N'67303', N'فوائد السندات المربوطة بكفالات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](673), 67304, N'67304', N'فوائد الذمم الدائنة الأخرى' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](673), 67305, N'67305', N'الخصم الممنوح من المؤسسة (خصم نقدي مسموح به)' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](673), 67306, N'67306', N'فوائد مصرفية وفوائد على عمليات التمويل' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](675), 67501, N'67501', N'فروقات صرف سلبية عملة اولى' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](675), 67502, N'67502', N'فروقات صرف سلبية عملة ثانية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](679), 67901, N'67901', N'استهلاكات علاوات التسديد' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](679), 67902, N'67902', N'مؤونات هبوط اسعار الأصول الثابتة المالية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](679), 67904, N'67904', N'مؤونات هبوط اسعار سندات التوظيف' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](679), 67905, N'67905', N'مؤونات لمواجهة المخاطر والأعباء المالية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](681), 68101, N'68101', N'أصول ثابتة غير مادية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](685), 68501, N'68501', N'أعباء على عمليات ادارة المؤسسة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](685), 68505, N'68505', N'أعباء على عمليات رأسمالية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](685), 68511, N'68511', N'هبات/اكراميات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](685), 68512, N'68512', N'اعانات ممنوحة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](685), 68513, N'68513', N'غرامات ضريبية وجزائية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](685), 68514, N'68514', N'غرامات على صفقات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](685), 68515, N'68515', N'ذمم مدينة أصبحت هالكة (ديون معدومة خارج الإستثمار)' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](685), 68516, N'68516', N'عمليات إدارية أخرى' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](685), 68551, N'68551', N'أعباء ناتجة عن موجب تطبيق مؤشر أسعار جوائز تسديد' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](685), 68552, N'68552', N'جوائز تسديد' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](689), 68901, N'68901', N'استهلاك استثنائي على أصول ثابثة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](689), 68902, N'68902', N'مؤونات هبوط أسعار استثنائي' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](689), 68905, N'68905', N'مؤونات لمواجهة مخاطر وأعباء خارج الإستثمار' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](701), 70101, N'70101', N'مبيعات غير خاضعة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](701), 70102, N'70102', N'مبيعات خاضعة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](701), 70108, N'70108', N'عمولات المندوبين' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](701), 70109, N'70109', N'حسومات تفصيلية ممنوحة على اصناف الفواتير' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](701), 70111, N'70111', N'مبيع سلع ضريبتها محصلة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](701), 70112, N'70112', N'مبيع سلع معفاة من الضريبة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](709), 70900, N'70900', N'خصم ممنوح' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](709), 70910, N'70910', N'حسم مبيع سلع ضريبتها مسترجعة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](709), 70911, N'70911', N'حسم مبيع  سلع معفاة من الضريبة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](711), 71101, N'71101', N'مبيعات المنتجات التامة الصنع' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](711), 71102, N'71102', N'مبيعات المنتجات الوسيطة(غير تامة الصنع مرحليا)' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](711), 71103, N'71103', N'مبيعات فضلات الإنتاج' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](711), 71111, N'71111', N'مبيع منتجات ضريبتها محصلة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](711), 71112, N'71112', N'مبيع منتجات معفاة من الضريبة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](713), 71311, N'71311', N'مبيع خدمات ضريبتها محصلة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](713), 71312, N'71312', N'مبيع خدمات معفاة من الضريبة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](721), 72101, N'72101', N'منتجات قيد الصنع' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](721), 72102, N'72102', N'أشغال قيد التنفيذ' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](721), 72111, N'72111', N'منتجات قيد الصنع أول المدة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](721), 72112, N'72112', N'منتجات قيد الصنع آخر المدة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](721), 72121, N'72121', N'أشغال قيد التنفيذ' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](721), 72122, N'72122', N'أشغال قيد التنفيذ أول المدة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](722), 72205, N'72205', N'دراسات قيد الإعداد' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](722), 72251, N'72251', N'دراسات قيد الإعداد أول المدة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](722), 72252, N'72252', N'دراسات قيد الإعداد آخر المدة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](722), 72261, N'72261', N'خدمات قيد التنفيذ أول المدة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](722), 72262, N'72262', N'خدمات قيد التنفيذ آخر المدة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](725), 72501, N'72501', N'منتجات وسيطة (غير تامة الصنع مرحلياً)' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](725), 72505, N'72505', N'منتجات تامة الصنع' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](725), 72508, N'72508', N'فضلات انتاج' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](725), 72511, N'72511', N'منتجات وسيطة أول المدة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](725), 72512, N'72512', N'منتجات وسيطة آخر المدة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](725), 72551, N'72551', N'منتجات تامة الصنع أول المدة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](725), 72552, N'72552', N'منتجات تامة الصنع آخر المدة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](761), 76102, N'76102', N'ايرادات الأبنية غير المخصصة للنشاط المهني' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](761), 76109, N'76109', N'أعباء إستثمار محولة إلى حسابات أخرى.' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](765), 76501, N'76501', N'حصص الأعباء الصافية التي جرى تحويلها - محاسبة.' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](771), 77101, N'77101', N'عائدات سندات المشاركة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](771), 77106, N'77106', N'عائدات المشاركات الأخرى' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](771), 77107, N'77107', N'عائدات الذمم المدينة المرتبطة بمشاركات' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](772), 77201, N'77201', N'عائدات سندات التوظيف' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](772), 77203, N'77203', N'عائدات السندات المجمدة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](772), 77205, N'77205', N'عائدات الذمم المدينة المجمدة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](772), 77206, N'77206', N'خدمات قيد التنفيد' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](772), 77207, N'77207', N'عائدات الذمم المدينة المختلفة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](773), 77301, N'77301', N'عائدات اقروض الممنوحة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](773), 77303, N'77303', N'الخصم الممنوح للمؤسسة (الخصم النقدي المكتسب)' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](775), 77501, N'77501', N'فروقات صرف ايجابية عملة اولى' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](775), 77502, N'77502', N'فروقات صرف ايجابية عملة ثانية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](778), 77801, N'77801', N'إيرادات صافية على بيع سندات توظيف' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](778), 77804, N'77804', N'يد عاملة معارة' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](778), 77809, N'77809', N'أعباء مالية محولة إلى حسابات أخرى' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](779), 77903, N'77903', N'إستردادات من مؤونات هبوط الأسعار' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](779), 77905, N'77905', N'إستردادات من مؤونات المخاطر والأعباء' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](781), 78101, N'78101', N'أصول ثابتة غير مادية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](781), 78102, N'78102', N'أصول ثابتة مادية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](781), 78105, N'78105', N'أصول ثابتة مالية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](788), 78801, N'78801', N'إيرادات إستثنائية على عمليات عادية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](788), 78808, N'78808', N'إيرادات أخرى على عمليات رأسمالية إستثنائية' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](788), 78809, N'78809', N'أعباء إستثنائية محولة إلى حسابات أخرى' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](789), 78901, N'78901', N'إستردادات من مؤونات هبوط الأسعار' ),
                    ( [Company].[f_AccountLevel2GetIDByNumber](789), 78905, N'78905', N'إستردادات من مؤونات المخاطر والأعباء' );

        END;

        BEGIN -- Account         
		
            DECLARE @CurrencyIDLL UNIQUEIDENTIFIER = [Currencys].[f_CurrencyGetFirstIDLL]();
            DECLARE @CurrencyIDD UNIQUEIDENTIFIER = [Currencys].[f_CurrencyGetFirstIDD]();
            DECLARE @CurrencyIDEuro UNIQUEIDENTIFIER = [Currencys].[f_CurrencyGetFirstIDEuro]();

            DECLARE @CurrencyLL NVARCHAR(MAX) = [Currencys].[f_CurrencyGetName](@CurrencyIDLL);
            DECLARE @CurrencyD NVARCHAR(MAX) = [Currencys].[f_CurrencyGetName](@CurrencyIDD);
            DECLARE @CurrencyEuro NVARCHAR(MAX) = [Currencys].[f_CurrencyGetName](@CurrencyIDEuro);

            DECLARE @CurrencyTypeIsLL INT = [Currencys].[f_CurrencyGetTypeIs](@CurrencyIDLL);
            DECLARE @CurrencyTypeIsD INT = [Currencys].[f_CurrencyGetTypeIs](@CurrencyIDD);
            DECLARE @CurrencyTypeIsEuro INT = [Currencys].[f_CurrencyGetTypeIs](@CurrencyIDEuro);

            INSERT  [Company].[t_Account]
                    ( Level3ID, NumberIs, NumberF, Name, LinkWithID, LinkWith, SectionID, IsMasterLink, IsStatic, CurrencyID, Currency, CurrencyTypeIs )
            VALUES  ( [Company].[f_AccountLevel3GetIDByNumber](40101), 4010100001, N'4010100001', N'المورد النقدي', Vendors.f_VendorGetFirstID(), Vendors.f_VendorGetFirstName(), 67, 1, 1, @CurrencyIDLL, @CurrencyLL, @CurrencyTypeIsLL ),
                    ( [Company].[f_AccountLevel3GetIDByNumber](41101), 4110100001, N'4110100001', N'الزبون النقدي', Customers.f_CustomerGetFirstID(), Customers.f_CustomerGetFirstName(), 15, 1, 1, @CurrencyIDLL, @CurrencyLL, @CurrencyTypeIsLL ),
                    ( [Company].[f_AccountLevel3GetIDByNumber](42101), 4210100001, N'4210100001', N'الموظف العام', Employees.f_EmployeeGetFirstID(), Employees.f_EmployeeGetFirstName(), 33, 1, 1, @CurrencyIDLL, @CurrencyLL, @CurrencyTypeIsLL ),
                    ( [Company].[f_AccountLevel3GetIDByNumber](44210), 4421000001, N'4421000001', N'المورد النقدي (الضريبة)', Vendors.f_VendorGetFirstID(), Vendors.f_VendorGetFirstName(), 67, 0, 1, @CurrencyIDLL, @CurrencyLL, @CurrencyTypeIsLL ),
                    ( [Company].[f_AccountLevel3GetIDByNumber](44270), 4427000001, N'4427000001', N'الزبون النقدي (الضريبة)', Customers.f_CustomerGetFirstID(), Customers.f_CustomerGetFirstName(), 15, 0, 1, @CurrencyIDLL, @CurrencyLL, @CurrencyTypeIsLL ),
                    ( [Company].[f_AccountLevel3GetIDByNumber](46101), 4610100001, N'4610100001', N'المندوب العام', Employees.f_SalesPersonGetFirstID(), Employees.f_SalesPersonGetFirstName(), 149, 1, 1, @CurrencyIDLL, @CurrencyLL, @CurrencyTypeIsLL ),
                    ( [Company].[f_AccountLevel3GetIDByNumber](51201), 5120100001, N'5120100001', N'البنك الإفتراضي', Company.f_BankGetFirstID(), Company.f_BankGetFirstName(), 38, 1, 1, @CurrencyIDLL, @CurrencyLL, @CurrencyTypeIsLL ),
                    ( [Company].[f_AccountLevel3GetIDByNumber](53101), 5310100001, N'5310100001', N'الصندوق العام', '00000000-0000-0000-0000-000000000000', N'', 69, 0, 1, @CurrencyIDLL, @CurrencyLL, @CurrencyTypeIsLL ),
                    ( [Company].[f_AccountLevel3GetIDByNumber](60101), 6010100001, N'6010100001', N'مشتريات لبناني غير خاضعة', '00000000-0000-0000-0000-000000000000', N'', 69, 0, 1, @CurrencyIDLL, @CurrencyLL, @CurrencyTypeIsLL ),
                    ( [Company].[f_AccountLevel3GetIDByNumber](60101), 6010100002, N'6010100002', N'مشتريات دولار غير خاضعة', '00000000-0000-0000-0000-000000000000', N'', 69, 0, 1, @CurrencyIDD, @CurrencyD, @CurrencyTypeIsD ),
                    ( [Company].[f_AccountLevel3GetIDByNumber](60101), 6010100003, N'6010100003', N'مشتريات يورو غير خاضعة', '00000000-0000-0000-0000-000000000000', N'', 69, 0, 1, @CurrencyIDEuro, @CurrencyEuro, @CurrencyTypeIsEuro ),
                    ( [Company].[f_AccountLevel3GetIDByNumber](60102), 6010200001, N'6010200001', N'مشتريات لبناني خاضعة', '00000000-0000-0000-0000-000000000000', N'', 69, 0, 1, @CurrencyIDLL, @CurrencyLL, @CurrencyTypeIsLL ),
                    ( [Company].[f_AccountLevel3GetIDByNumber](60102), 6010200002, N'6010200002', N'مشتريات دولار خاضعة', '00000000-0000-0000-0000-000000000000', N'', 69, 0, 1, @CurrencyIDD, @CurrencyD, @CurrencyTypeIsD ),
                    ( [Company].[f_AccountLevel3GetIDByNumber](60102), 6010200003, N'6010200003', N'مشتريات يورو خاضعة', '00000000-0000-0000-0000-000000000000', N'', 69, 0, 1, @CurrencyIDEuro, @CurrencyEuro, @CurrencyTypeIsEuro ),
                    ( [Company].[f_AccountLevel3GetIDByNumber](63101), 6310100001, N'6310100001', N'الموظف العام (رواتب)', Employees.f_EmployeeGetFirstID(), Employees.f_EmployeeGetFirstName(), 33, 0, 1, @CurrencyIDLL, @CurrencyLL, @CurrencyTypeIsLL ),
                    ( [Company].[f_AccountLevel3GetIDByNumber](70101), 7010100001, N'7010100001', N'مبيعات لبناني غير خاضعة', '00000000-0000-0000-0000-000000000000', N'', 69, 0, 1, @CurrencyIDLL, @CurrencyLL, @CurrencyTypeIsLL ),
                    ( [Company].[f_AccountLevel3GetIDByNumber](70101), 7010100002, N'7010100002', N'مبيعات دولار غير خاضعة', '00000000-0000-0000-0000-000000000000', N'', 69, 0, 1, @CurrencyIDD, @CurrencyD, @CurrencyTypeIsD ),
                    ( [Company].[f_AccountLevel3GetIDByNumber](70101), 7010100003, N'7010100003', N'مبيعات يورو غير خاضعة', '00000000-0000-0000-0000-000000000000', N'', 69, 0, 1, @CurrencyIDEuro, @CurrencyEuro, @CurrencyTypeIsEuro ),
                    ( [Company].[f_AccountLevel3GetIDByNumber](70102), 7010200001, N'7010200001', N'مبيعات لبناني خاضعة', '00000000-0000-0000-0000-000000000000', N'', 69, 0, 1, @CurrencyIDLL, @CurrencyLL, @CurrencyTypeIsLL ),
                    ( [Company].[f_AccountLevel3GetIDByNumber](70102), 7010200002, N'7010200002', N'مبيعات دولار خاضعة', '00000000-0000-0000-0000-000000000000', N'', 69, 0, 1, @CurrencyIDD, @CurrencyD, @CurrencyTypeIsD ),
                    ( [Company].[f_AccountLevel3GetIDByNumber](70102), 7010200003, N'7010200003', N'مبيعات يورو خاضعة', '00000000-0000-0000-0000-000000000000', N'', 69, 0, 1, @CurrencyIDEuro, @CurrencyEuro, @CurrencyTypeIsEuro )			 ,
                    ( [Company].[f_AccountLevel3GetIDByNumber](70108), 7010800001, N'7010800001', N'المندوب العام (عمولات البيع)', Employees.f_SalesPersonGetFirstID(), Employees.f_SalesPersonGetFirstName(), 149, 0, 1, @CurrencyIDLL, @CurrencyLL, @CurrencyTypeIsLL );

        END;

        BEGIN --Rebuilding statistics

            UPDATE  Company.t_Account
            SET     Level3 = Company.f_AccountLevel3GetName(Level3ID) ,
                    Currency = Currencys.f_CurrencyGetName(CurrencyID) ,
                    BalanceF = Currencys.f_Format(CurrencyID, Balance) ,
                    LimitF = Currencys.f_Format(CurrencyID, Limit);

            UPDATE  Company.t_AccountLevel2
            SET     Level1 = Company.f_AccountLevel1GetName(Level1ID);

            UPDATE  Company.t_AccountLevel3
            SET     Level2 = Company.f_AccountLevel2GetName(Level2ID);

            UPDATE  Company.t_Account
            SET     SearchText = Company.f_AccountSearchTextGet(ID);
      
	        UPDATE  Company.t_AccountLevel1
            SET     SearchText = Company.f_AccountLevel1SearchTextGet(ID);
      
	        UPDATE  Company.t_AccountLevel2
            SET     SearchText = Company.f_AccountLevel2SearchTextGet(ID);
      
	        UPDATE  Company.t_AccountLevel3
            SET     SearchText = Company.f_AccountLevel3SearchTextGet(ID);

        END;

        ENABLE TRIGGER Company.tr_Account ON Company.t_Account;
        ENABLE TRIGGER Company.tr_AccountLevel1 ON Company.t_AccountLevel1;
        ENABLE TRIGGER Company.tr_AccountLevel2 ON Company.t_AccountLevel2;
        ENABLE TRIGGER Company.tr_AccountLevel3 ON Company.t_AccountLevel3;

        COMMIT TRAN;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ENABLE TRIGGER Company.tr_Account ON Company.t_Account;
        ENABLE TRIGGER Company.tr_AccountLevel1 ON Company.t_AccountLevel1;
        ENABLE TRIGGER Company.tr_AccountLevel2 ON Company.t_AccountLevel2;
        ENABLE TRIGGER Company.tr_AccountLevel3 ON Company.t_AccountLevel3;

        ROLLBACK;

        RETURN 0;

    END CATCH;

END;





















GO
