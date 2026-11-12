SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Users].[v_UserNotificationsHistory]
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
    FROM    Users.t_UserNotificationsHistory AS N;






GO
