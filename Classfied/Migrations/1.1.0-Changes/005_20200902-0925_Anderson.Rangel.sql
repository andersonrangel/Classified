-- <Migration ID="9408f93b-d09c-4b76-8930-b2f401d23411" />
GO

PRINT N'Dropping [dbo].[oldproc]'
GO
IF OBJECT_ID(N'[dbo].[oldproc]', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[oldproc]
GO
