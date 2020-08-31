CREATE TABLE [dbo].[DM_ASSIGNMENT]
(
[assignment_id] [int] NOT NULL,
[person_id] [int] NOT NULL,
[emp_id] [varchar] (10) NULL,
[emp_jobtitle] [varchar] (100) NULL,
[assignment_notes] [varchar] (1000) NULL
)
GO
CREATE UNIQUE NONCLUSTERED INDEX [asgnInd1] ON [dbo].[DM_ASSIGNMENT] ([person_id], [assignment_id])
GO
