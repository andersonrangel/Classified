-- <Migration ID="2c2be451-e657-48ed-8ba7-e1988374c08c" />
GO

PRINT N'Dropping [dbo].[newproc]'
GO
IF OBJECT_ID(N'[dbo].[newproc]', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[newproc]
GO
