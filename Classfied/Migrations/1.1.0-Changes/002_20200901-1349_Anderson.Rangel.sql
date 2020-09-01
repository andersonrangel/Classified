-- <Migration ID="69895b0b-3ac2-4be1-a916-d195969ca1a4" />
GO


SET IMPLICIT_TRANSACTIONS, NUMERIC_ROUNDABORT OFF;
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, NOCOUNT, QUOTED_IDENTIFIER ON;

SET DATEFORMAT YMD;


GO
IF (SELECT COUNT(*)
    FROM   [dbo].[DM_CREDIT_CARD_TYPE]) = 0
    BEGIN
        PRINT (N'Add 5 rows to [dbo].[DM_CREDIT_CARD_TYPE]');
        INSERT  INTO [dbo].[DM_CREDIT_CARD_TYPE] ([credit_card_type_id], [credit_card_type_name])
        VALUES                                  ('1', 'Discover');
        INSERT  INTO [dbo].[DM_CREDIT_CARD_TYPE] ([credit_card_type_id], [credit_card_type_name])
        VALUES                                  ('2', 'American Express');
        INSERT  INTO [dbo].[DM_CREDIT_CARD_TYPE] ([credit_card_type_id], [credit_card_type_name])
        VALUES                                  ('3', 'Diners Club');
        INSERT  INTO [dbo].[DM_CREDIT_CARD_TYPE] ([credit_card_type_id], [credit_card_type_name])
        VALUES                                  ('4', 'Master Card');
        INSERT  INTO [dbo].[DM_CREDIT_CARD_TYPE] ([credit_card_type_id], [credit_card_type_name])
        VALUES                                  ('5', 'VISA');
    END


GO