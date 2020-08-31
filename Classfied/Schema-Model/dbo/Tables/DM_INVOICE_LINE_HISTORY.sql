CREATE TABLE [dbo].[DM_INVOICE_LINE_HISTORY]
(
[identCol] [int] NOT NULL IDENTITY(1, 1),
[invoice_number] [varchar] (6) NOT NULL,
[item_id] [varchar] (6) NOT NULL,
[quantity] [int] NULL
)
GO
ALTER TABLE [dbo].[DM_INVOICE_LINE_HISTORY] ADD CONSTRAINT [PK__DM_INVOI__2DE3C94A82AAE2C0] PRIMARY KEY CLUSTERED  ([identCol])
GO
