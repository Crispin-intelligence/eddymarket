SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Alls].[f_NotificationIsActive]
(
    @StopNotification BIT,
    @ExpirationDate DATE
)
RETURNS BIT
AS
BEGIN

    RETURN CASE
               WHEN @StopNotification = 1 THEN
                   0
               ELSE
                   CASE
                       WHEN @ExpirationDate < CONVERT(DATE, GETDATE()) THEN
                           0
                       ELSE
                           1
                   END
           END;

END;





GO
