-- <Migration ID="b1aa78fc-f6e2-49f5-98c8-28afe54bd871" />
GO

PRINT N'Dropping [dbo].[oldproc]'
GO
IF OBJECT_ID(N'[dbo].[oldproc]', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[oldproc]
GO
PRINT N'Altering [dbo].[DM_CUSTOMER]'
GO
IF COL_LENGTH(N'[dbo].[DM_CUSTOMER]', N'status') IS NULL
ALTER TABLE [dbo].[DM_CUSTOMER] ADD[status] [int] NULL
GO
