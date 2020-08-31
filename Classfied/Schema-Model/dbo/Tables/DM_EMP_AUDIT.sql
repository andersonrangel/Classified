CREATE TABLE [dbo].[DM_EMP_AUDIT]
(
[identCol] [int] NOT NULL IDENTITY(1, 1),
[person_id] [int] NOT NULL,
[assignment_id] [int] NOT NULL,
[emp_id] [varchar] (10) NULL,
[first_name] [varchar] (40) NULL,
[last_name] [varchar] (40) NULL,
[full_name] [varchar] (40) NULL
)
GO
ALTER TABLE [dbo].[DM_EMP_AUDIT] ADD CONSTRAINT [PK__DM_EMP_A__2DE3C94AA18F71FC] PRIMARY KEY CLUSTERED  ([identCol])
GO
