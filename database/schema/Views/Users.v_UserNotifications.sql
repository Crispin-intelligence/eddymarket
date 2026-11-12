SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Users].[v_UserNotifications]
AS
    SELECT  N.NotificationID ,
            N.NotificationType ,
            N.NotificationSectionID ,
            N.NotificationText ,
            N.NotificationFromUserID ,
            N.NotificationToUserID ,
            N.NotificationDateSend ,
            N.NotificationDateSee ,
            N.NotificationStop
    FROM    Users.t_UserNotifications AS N






GO
