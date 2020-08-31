CREATE TABLE [dbo].[DM_CREDIT_CARD_TYPE]
(
[credit_card_type_id] [varchar] (2) NOT NULL,
[credit_card_type_name] [varchar] (60) NULL
)
GO
ALTER TABLE [dbo].[DM_CREDIT_CARD_TYPE] ADD CONSTRAINT [PK__DM_CREDI__F76530082B5BBF7D] PRIMARY KEY CLUSTERED  ([credit_card_type_id])
GO
