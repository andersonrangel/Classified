CREATE TABLE [dbo].[DM_INVENTORY_ITEM]
(
[inventory_item_id] [varchar] (10) NOT NULL,
[inventory_item_name] [varchar] (60) NULL
)
GO
ALTER TABLE [dbo].[DM_INVENTORY_ITEM] ADD CONSTRAINT [PK__DM_INVEN__61D4B2B48522D3DF] PRIMARY KEY CLUSTERED  ([inventory_item_id])
GO
