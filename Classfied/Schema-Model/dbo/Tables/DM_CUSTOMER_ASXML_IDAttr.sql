CREATE TABLE [dbo].[DM_CUSTOMER_ASXML_IDAttr]
(
[customer_id] [varchar] (10) NOT NULL,
[customer_data] [xml] NULL
)
GO
ALTER TABLE [dbo].[DM_CUSTOMER_ASXML_IDAttr] ADD CONSTRAINT [PK_DM_CUSTOMER_ASXML_IDAttr] PRIMARY KEY CLUSTERED  ([customer_id])
GO
