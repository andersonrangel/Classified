IF OBJECT_ID('[dbo].[oldproc]') IS NOT NULL
	DROP PROCEDURE [dbo].[oldproc];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
--Author: RED-GATE\Anderson.Rangel
--Date: 2/09/2020

CREATE PROCEDURE [dbo].[oldproc]
    @parameter_name AS INT
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| 'user_name'
AS
begin
    SELECT * FROM dbo.DM_ASSIGNMENT AS DA
end
GO
