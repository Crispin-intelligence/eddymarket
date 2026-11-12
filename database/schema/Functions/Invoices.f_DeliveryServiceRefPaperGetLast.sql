SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [Invoices].[f_DeliveryServiceRefPaperGetLast]
    (
      @AccountVendorID UNIQUEIDENTIFIER
    )
RETURNS NVARCHAR(MAX)
AS
    BEGIN

        BEGIN --DECLARE

            DECLARE @RefPaper NVARCHAR(MAX);

        END;

        BEGIN --Set

            SELECT TOP ( 1 )
                    @RefPaper = o.RefPaper
            FROM    ( SELECT    s.Ref ,
                                s.RefPaper
                      FROM      Invoices.t_DeliveryService AS s
                      WHERE     s.AccountVendorID = @AccountVendorID
                      UNION ALL
                      SELECT    s.Ref ,
                                s.RefPaper
                      FROM      Invoices.t_DeliveryServiceHistory AS s
                      WHERE     s.AccountVendorID = @AccountVendorID
                    ) AS o
            ORDER BY o.Ref DESC;

        END;

        RETURN COALESCE(@RefPaper, '');

    END;



GO
