IF OBJECT_ID('[dbo].[newview]') IS NOT NULL
	DROP VIEW [dbo].[newview];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--Author: RED-GATE\Anderson.Rangel
--Date: 27/08/2020
CREATE VIEW [dbo].[newview]
--WITH ENCRYPTION, SCHEMABINDING, VIEW_METADATA
AS
    SELECT * FROM dbo.ArticlePrices AS AP
-- WITH CHECK OPTION
GO
