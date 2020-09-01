IF OBJECT_ID('[dbo].[GetContacts]') IS NOT NULL
	DROP PROCEDURE [dbo].[GetContacts];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
CREATE PROCEDURE [dbo].[GetContacts]
--Author:sa
--Date: 26/11/2019
--GO
    @parameter_name AS INT
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| 'user_name'
AS
--SET NOCOUNT ON

    SELECT	DC.customer_id,
            DC.customer_firstname,
            DC.customer_lastname,
            DC.customer_gender,
            DC.customer_company_name,
            DC.customer_street_address,
            DC.customer_region,
            DC.customer_country,
            DC.customer_email,
            DC.customer_telephone,
            DC.customer_zipcode,
            DC.credit_card_type_id,
            DC.customer_credit_card_number FROM dbo.DM_CUSTOMER AS DC
			--v3
GO
