CREATE TABLE [dbo].[DM_SUPPLIERS]
(
[supplier_id] [int] NOT NULL,
[supplier_name] [varchar] (60) NULL
)
GO
ALTER TABLE [dbo].[DM_SUPPLIERS] ADD CONSTRAINT [PK__DM_SUPPL__6EE594E8AB4A022B] PRIMARY KEY CLUSTERED  ([supplier_id])
GO
