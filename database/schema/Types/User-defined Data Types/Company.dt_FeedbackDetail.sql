CREATE TYPE [Company].[dt_FeedbackDetail] AS TABLE
(
[ID] [bigint] NULL,
[ServiceID] [int] NULL,
[RatingIs] [decimal] (3, 2) NULL,
[NoteIs] [nvarchar] (max) COLLATE Arabic_CI_AS NULL
)
GO
