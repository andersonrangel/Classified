CREATE TABLE [dbo].[DM_INVOICE_LINE]
(
[invoice_number] [varchar] (10) NOT NULL,
[inventory_item_id] [varchar] (10) NOT NULL,
[invoice_line_quantity] [int] NULL,
[invoice_line_sale_price] [decimal] (10, 2) NULL
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[IL_trig1]
on [dbo].[DM_INVOICE_LINE] after insert, update
AS
BEGIN
  DECLARE @invNum integer
  DECLARE @itemID integer
  DECLARE @itemQty integer
  Select @invNum=invoice_number, @itemID=inventory_item_id, @itemQty=invoice_line_quantity from DM_INVOICE_LINE;
  insert into DM_INVOICE_LINE_HISTORY (invoice_number,item_id,quantity) 
     values (@invNum,@itemID,@itemQty);
END
GO
ALTER TABLE [dbo].[DM_INVOICE_LINE] ADD CONSTRAINT [PK__DM_INVOI__D69CED10B7D89B13] PRIMARY KEY CLUSTERED  ([invoice_number], [inventory_item_id])
GO
ALTER TABLE [dbo].[DM_INVOICE_LINE] ADD CONSTRAINT [I3_FK] FOREIGN KEY ([invoice_number]) REFERENCES [dbo].[DM_INVOICE] ([invoice_number])
GO
ALTER TABLE [dbo].[DM_INVOICE_LINE] ADD CONSTRAINT [I4_FK] FOREIGN KEY ([inventory_item_id]) REFERENCES [dbo].[DM_INVENTORY_ITEM] ([inventory_item_id])
GO
