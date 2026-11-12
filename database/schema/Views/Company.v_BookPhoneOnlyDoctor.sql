SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Company].[v_BookPhoneOnlyDoctor]
AS
SELECT ID,
       OwnerID,
       NumberWithExtension,
       NumberType,
       LanguageCode,
       ExtensionIs,
       DateCreate
FROM Company.t_BookPhone AS t
WHERE (SectionID = 163);


GO
