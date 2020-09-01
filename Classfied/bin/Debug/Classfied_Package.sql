﻿/*
    Generated date:     2020-09-01T10:04:31Z
    Generated on:       SLS-LT-ANDERSON
    Package version:    
    Migration version:  (n/a)
    Baseline version:   (n/a)
    SQL Change Automation version:  4.3.20211.21565

    IMPORTANT! "SQLCMD Mode" must be activated prior to execution (under the Query menu in SSMS).

    BEFORE EXECUTING THIS SCRIPT, WE STRONGLY RECOMMEND YOU TAKE A BACKUP OF YOUR DATABASE.

    This SQLCMD script is designed to be executed through MSBuild (via the .sqlproj Deploy target) however
    it can also be run manually using SQL Management Studio.

    It was generated by the SQL Change Automation build task and contains logic to deploy the database, ensuring that
    each of the incremental migrations is executed a single time only in alphabetical (filename)
    order. If any errors occur within those scripts, the deployment will be aborted and the transaction
    rolled-back.

    NOTE: Automatic transaction management is provided for incremental migrations, so you don't need to
          add any special BEGIN TRAN/COMMIT/ROLLBACK logic in those script files.
          However if you require transaction handling in your Pre/Post-Deployment scripts, you will
          need to add this logic to the source .sql files yourself.
*/

----====================================================================================================================
---- SQLCMD Variables
---- This script is designed to be called by SQLCMD.EXE with variables specified on the command line.
---- However you can also run it in SQL Management Studio by uncommenting this section (CTRL+K, CTRL+U).
--:setvar DatabaseName ""
--:setvar ReleaseVersion ""
--:setvar ForceDeployWithoutBaseline "False"
--:setvar DefaultFilePrefix ""
--:setvar DefaultDataPath ""
--:setvar DefaultLogPath ""
--:setvar DefaultBackupPath ""
--:setvar DeployPath ""
----====================================================================================================================

:on error exit -- Instructs SQLCMD to abort execution as soon as an erroneous batch is encountered

:setvar PackageVersion ""
:setvar IsShadowDeployment 0

GO
:setvar IsSqlCmdEnabled "True"
GO

IF N'$(DatabaseName)' = N'$' + N'(DatabaseName)' OR
   N'$(ReleaseVersion)' = N'$' + N'(ReleaseVersion)' OR
   N'$(ForceDeployWithoutBaseline)' = N'$' + N'(ForceDeployWithoutBaseline)'
      RAISERROR('(This will not throw). Please make sure that all SQLCMD variables are defined before running this script.', 0, 0);
GO

SET IMPLICIT_TRANSACTIONS, NUMERIC_ROUNDABORT OFF;
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, NOCOUNT, QUOTED_IDENTIFIER ON;
SET XACT_ABORT ON; -- Abort the current batch immediately if a statement raises a run-time error and rollback any open transaction(s)

IF N'$(IsSqlCmdEnabled)' <> N'True' -- Is SQLCMD mode not enabled within the execution context (eg. SSMS)
    BEGIN
        IF IS_SRVROLEMEMBER(N'sysadmin') = 1
            BEGIN -- User is sysadmin; abort execution by disconnect the script from the database server
                RAISERROR(N'This script must be run in SQLCMD Mode (under the Query menu in SSMS). Aborting connection to suppress subsequent errors.', 20, 127, N'UNKNOWN') WITH LOG;
            END
        ELSE
            BEGIN -- User is not sysadmin; abort execution by switching off statement execution (script will continue to the end without performing any actual deployment work)
                RAISERROR(N'This script must be run in SQLCMD Mode (under the Query menu in SSMS). Script execution has been halted.', 16, 127, N'UNKNOWN') WITH NOWAIT;
            END
    END
GO
IF @@ERROR != 0
    BEGIN
        SET NOEXEC ON; -- SQLCMD is NOT enabled so prevent any further statements from executing
    END
GO
-- Beyond this point, no further explicit error handling is required because it can be assumed that SQLCMD mode is enabled

IF SERVERPROPERTY('EngineEdition') = 5 AND DB_NAME() != N'$(DatabaseName)'
  RAISERROR(N'Azure SQL Database does not support switching between databases. Connect to [$(DatabaseName)] and then re-run the script.', 16, 127);








------------------------------------------------------------------------------------------------------------------------
------------------------------------------       PRE-DEPLOYMENT SCRIPTS       ------------------------------------------
------------------------------------------------------------------------------------------------------------------------

SET IMPLICIT_TRANSACTIONS, NUMERIC_ROUNDABORT OFF;
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, NOCOUNT, QUOTED_IDENTIFIER ON;

PRINT '----- executing pre-deployment script "Pre-Deployment\01_Initialize_Deployment.sql" -----';
GO

---------------------- BEGIN PRE-DEPLOYMENT SCRIPT: "Pre-Deployment\01_Initialize_Deployment.sql" ------------------------
/*
Pre-Deployment Script Template
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be prepended to the build script.
 Use SQLCMD syntax to include a file in the pre-deployment script.
 Example:      :r .\myfile.sql
 Use SQLCMD syntax to reference a variable in the post-deployment script.
 Example:      :setvar TableName MyTable
               SELECT * FROM [$(TableName)]
--------------------------------------------------------------------------------------
*/

GO
----------------------- END PRE-DEPLOYMENT SCRIPT: "Pre-Deployment\01_Initialize_Deployment.sql" -------------------------

SET IMPLICIT_TRANSACTIONS, NUMERIC_ROUNDABORT OFF;
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, NOCOUNT, QUOTED_IDENTIFIER ON;









------------------------------------------------------------------------------------------------------------------------
------------------------------------------       INCREMENTAL MIGRATIONS       ------------------------------------------
------------------------------------------------------------------------------------------------------------------------

SET IMPLICIT_TRANSACTIONS, NUMERIC_ROUNDABORT OFF;
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, NOCOUNT, QUOTED_IDENTIFIER ON;

GO
PRINT '# Beginning transaction';

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SET XACT_ABORT ON;

BEGIN TRANSACTION;

GO
IF DB_NAME() != '$(DatabaseName)'
  USE [$(DatabaseName)];

GO
PRINT '# Setting up migration log table';
IF (NOT EXISTS (SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[__MigrationLog]') AND [type] = 'U'))
  BEGIN
    IF OBJECT_ID(N'[dbo].[__MigrationLogCurrent]', 'V') IS NOT NULL
      DROP VIEW [dbo].[__MigrationLogCurrent];
    PRINT '# Creating a new migration log table';
    CREATE TABLE [dbo].[__MigrationLog] (
      [migration_id] UNIQUEIDENTIFIER NOT NULL,
      [script_checksum] NVARCHAR (64) NOT NULL,
      [script_filename] NVARCHAR (255) NOT NULL,
      [complete_dt] DATETIME2 NOT NULL,
      [applied_by] NVARCHAR (100) NOT NULL,
      [deployed] TINYINT CONSTRAINT [DF___MigrationLog_deployed] DEFAULT (1) NOT NULL,
      [version] VARCHAR (255) NULL,
      [package_version] VARCHAR (255) NULL,
      [release_version] VARCHAR (255) NULL,
      [sequence_no] INT IDENTITY (1, 1) NOT NULL CONSTRAINT [PK___MigrationLog] PRIMARY KEY CLUSTERED ([migration_id], [complete_dt], [script_checksum]));
    CREATE NONCLUSTERED INDEX [IX___MigrationLog_CompleteDt]
      ON [dbo].[__MigrationLog]([complete_dt]);
    CREATE NONCLUSTERED INDEX [IX___MigrationLog_Version]
      ON [dbo].[__MigrationLog]([version]);
    CREATE UNIQUE NONCLUSTERED INDEX [UX___MigrationLog_SequenceNo]
      ON [dbo].[__MigrationLog]([sequence_no]);
    EXECUTE ('
	CREATE VIEW [dbo].[__MigrationLogCurrent]
			AS
			WITH currentMigration AS
			(
			  SELECT
				 migration_id, script_checksum, script_filename, complete_dt, applied_by, deployed, ROW_NUMBER() OVER(PARTITION BY migration_id ORDER BY sequence_no DESC) AS RowNumber
			  FROM [dbo].[__MigrationLog]
			)
			SELECT  migration_id, script_checksum, script_filename, complete_dt, applied_by, deployed
			FROM currentMigration
			WHERE RowNumber = 1
	');
    IF OBJECT_ID(N'sp_addextendedproperty', 'P') IS NOT NULL
      BEGIN
        PRINT N'Creating extended properties';
        EXECUTE sp_addextendedproperty N'MS_Description', N'This table is required by SQL Change Automation projects to keep track of which migrations have been executed during deployment. Please do not alter or remove this table from the database.', 'SCHEMA', N'dbo', 'TABLE', N'__MigrationLog', NULL, NULL;
        EXECUTE sp_addextendedproperty N'MS_Description', N'The executing user at the time of deployment (populated using the SYSTEM_USER function).', 'SCHEMA', N'dbo', 'TABLE', N'__MigrationLog', 'COLUMN', N'applied_by';
        EXECUTE sp_addextendedproperty N'MS_Description', N'The date/time that the migration finished executing. This value is populated using the SYSDATETIME function.', 'SCHEMA', N'dbo', 'TABLE', N'__MigrationLog', 'COLUMN', N'complete_dt';
        EXECUTE sp_addextendedproperty N'MS_Description', N'This column contains a number of potential states:

0 - Marked As Deployed: The migration was not executed.
1- Deployed: The migration was executed successfully.
2- Imported: The migration was generated by importing from this DB.

"Marked As Deployed" and "Imported" are similar in that the migration was not executed on this database; it was was only marked as such to prevent it from executing during subsequent deployments.', 'SCHEMA', N'dbo', 'TABLE', N'__MigrationLog', 'COLUMN', N'deployed';
        EXECUTE sp_addextendedproperty N'MS_Description', N'The unique identifier of a migration script file. This value is stored within the <Migration /> Xml fragment within the header of the file itself.

Note that it is possible for this value to repeat in the [__MigrationLog] table. In the case of programmable object scripts, a record will be inserted with a particular ID each time a change is made to the source file and subsequently deployed.

In the case of a migration, you may see the same [migration_id] repeated, but only in the scenario where the "Mark As Deployed" button/command has been run.', 'SCHEMA', N'dbo', 'TABLE', N'__MigrationLog', 'COLUMN', N'migration_id';
        EXECUTE sp_addextendedproperty N'MS_Description', N'If you have enabled SQLCMD Packaging in your SQL Change Automation project, or if you are using Octopus Deploy, this will be the version number that your database package was stamped with at build-time.', 'SCHEMA', N'dbo', 'TABLE', N'__MigrationLog', 'COLUMN', N'package_version';
        EXECUTE sp_addextendedproperty N'MS_Description', N'If you are using Octopus Deploy, you can use the value in this column to look-up which release was responsible for deploying this migration.
If deploying via PowerShell, set the $ReleaseVersion variable to populate this column.
If deploying via Visual Studio, this column will always be NULL.', 'SCHEMA', N'dbo', 'TABLE', N'__MigrationLog', 'COLUMN', N'release_version';
        EXECUTE sp_addextendedproperty N'MS_Description', N'A SHA256 representation of the migration script file at the time of build.  This value is used to determine whether a migration has been changed since it was deployed. In the case of a programmable object script, a different checksum will cause the migration to be redeployed.
Note: if any variables have been specified as part of a deployment, this will not affect the checksum value.', 'SCHEMA', N'dbo', 'TABLE', N'__MigrationLog', 'COLUMN', N'script_checksum';
        EXECUTE sp_addextendedproperty N'MS_Description', N'The name of the migration script file on disk, at the time of build.
If Semantic Versioning has been enabled, then this value will contain the full relative path from the root of the project folder. If it is not enabled, then it will simply contain the filename itself.', 'SCHEMA', N'dbo', 'TABLE', N'__MigrationLog', 'COLUMN', N'script_filename';
        EXECUTE sp_addextendedproperty N'MS_Description', N'An auto-seeded numeric identifier that can be used to determine the order in which migrations were deployed.', 'SCHEMA', N'dbo', 'TABLE', N'__MigrationLog', 'COLUMN', N'sequence_no';
        EXECUTE sp_addextendedproperty N'MS_Description', N'The semantic version that this migration was created under. In SQL Change Automation projects, a folder can be given a version number, e.g. 1.0.0, and one or more migration scripts can be stored within that folder to provide logical grouping of related database changes.', 'SCHEMA', N'dbo', 'TABLE', N'__MigrationLog', 'COLUMN', N'version';
        EXECUTE sp_addextendedproperty N'MS_Description', N'This view is required by SQL Change Automation projects to determine whether a migration should be executed during a deployment. The view lists the most recent [__MigrationLog] entry for a given [migration_id], which is needed to determine whether a particular programmable object script needs to be (re)executed: a non-matching checksum on the current [__MigrationLog] entry will trigger the execution of a programmable object script. Please do not alter or remove this table from the database.', N'SCHEMA', N'dbo', N'VIEW', N'__MigrationLogCurrent', NULL, NULL;
      END
  END

IF NOT EXISTS (SELECT col.COLUMN_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tab, INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE AS col WHERE col.CONSTRAINT_NAME = tab.CONSTRAINT_NAME AND col.TABLE_NAME = tab.TABLE_NAME AND col.TABLE_SCHEMA = tab.TABLE_SCHEMA AND tab.CONSTRAINT_TYPE = 'PRIMARY KEY' AND col.TABLE_SCHEMA = 'dbo' AND col.TABLE_NAME = '__MigrationLog' AND col.COLUMN_NAME = 'complete_dt')
  BEGIN
    RAISERROR (N'The SQL Change Automation [dbo].[__MigrationLog] table has an incorrect primary key specification. This may be due to the fact that the <SqlChangeAutomationSchemaVersion/> element in your .sqlproj file contains the wrong version number for your database. Please check earlier versions of your .sqlproj file to determine what is the appropriate version for your database (possibly 1.7 or 1.3.1).', 16, 127, N'UNKNOWN')
      WITH NOWAIT;
    RETURN;
  END

IF COL_LENGTH(N'[dbo].[__MigrationLog]', N'sequence_no') IS NULL
  BEGIN
    RAISERROR (N'The SQL Change Automation [dbo].[__MigrationLog] table is missing the [sequence_no] column. This may be due to the fact that the <SqlChangeAutomationSchemaVersion/> element in your .sqlproj file contains the wrong version number for your database. Please check earlier versions of your .sqlproj file to determine what is the appropriate version for your database (possibly 1.7 or 1.3.1).', 16, 127, N'UNKNOWN')
      WITH NOWAIT;
    RETURN;
  END

IF (NOT EXISTS (SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[__MigrationLogCurrent]') AND [type] = 'V'))
  BEGIN
    EXECUTE ('
	CREATE VIEW [dbo].[__MigrationLogCurrent]
			AS
			WITH currentMigration AS
			(
			  SELECT
				 migration_id, script_checksum, script_filename, complete_dt, applied_by, deployed, ROW_NUMBER() OVER(PARTITION BY migration_id ORDER BY sequence_no DESC) AS RowNumber
			  FROM [dbo].[__MigrationLog]
			)
			SELECT  migration_id, script_checksum, script_filename, complete_dt, applied_by, deployed
			FROM currentMigration
			WHERE RowNumber = 1
	');
  END

GO
PRINT '# Setting up __SchemaSnapshot table';
IF (NOT EXISTS (SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[__SchemaSnapshot]')))
  BEGIN
    CREATE TABLE [dbo].[__SchemaSnapshot] (
      [Snapshot] VARBINARY (MAX),
      [LastUpdateDate] DATETIME2 CONSTRAINT [__SchemaSnapshotDateDefault] DEFAULT SYSDATETIME());
    IF OBJECT_ID(N'sp_addextendedproperty', 'P') IS NOT NULL
      BEGIN
        EXECUTE sp_addextendedproperty N'MS_Description', N'This table is used by SQL Change Automation projects to store a snapshot of the schema at the time of the last deployment. Please do not alter or remove this table from the database.', 'SCHEMA', N'dbo', 'TABLE', N'__SchemaSnapshot', NULL, NULL;
      END
  END

GO
PRINT '# Truncating __SchemaSnapshot';
TRUNCATE TABLE [dbo].[__SchemaSnapshot];

GO
PRINT '# Check if baseline is required';
DECLARE @baselineRequired AS BIT;

SET @baselineRequired = 0;

IF (EXISTS (SELECT * FROM sys.objects AS o WHERE o.is_ms_shipped = 0 AND NOT (o.name LIKE '%__MigrationLog%' OR o.name LIKE '%__SchemaSnapshot%')) AND (SELECT count(*) FROM [dbo].[__MigrationLog]) = 0)
  SET @baselineRequired = 1;

IF @baselineRequired = 1
  BEGIN
    PRINT '----- baselined: Migrations\1.0.0-Baseline\001_20200901-0002_Anderson.Rangel.sql (marked as deployed) -----';
    INSERT [$(DatabaseName)].[dbo].[__MigrationLog] ([migration_id], [script_checksum], [script_filename], [complete_dt], [applied_by], [deployed], [version], [package_version], [release_version])
    VALUES                                         (CAST ('87de47e2-f68e-4dba-a389-755112dcce84' AS UNIQUEIDENTIFIER), '7808BFF7EDD9F751D9D6282C81B6A9BED04DED22B20889A2BC5F9D5ACC2CE748', 'Migrations\1.0.0-Baseline\001_20200901-0002_Anderson.Rangel.sql', SYSDATETIME(), SYSTEM_USER, 0, NULL, '$(PackageVersion)', CASE '$(ReleaseVersion)' WHEN '' THEN NULL ELSE '$(ReleaseVersion)' END);
  END

GO
SET IMPLICIT_TRANSACTIONS, NUMERIC_ROUNDABORT OFF;
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, NOCOUNT, QUOTED_IDENTIFIER ON;

GO
IF DB_NAME() != '$(DatabaseName)'
  USE [$(DatabaseName)];

GO
IF NOT EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('87de47e2-f68e-4dba-a389-755112dcce84' AS UNIQUEIDENTIFIER))
  PRINT '

***** EXECUTING MIGRATION "Migrations\1.0.0-Baseline\001_20200901-0002_Anderson.Rangel.sql", ID: {87de47e2-f68e-4dba-a389-755112dcce84} *****';

GO
IF EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('87de47e2-f68e-4dba-a389-755112dcce84' AS UNIQUEIDENTIFIER))
BEGIN
  PRINT '----- Skipping "Migrations\1.0.0-Baseline\001_20200901-0002_Anderson.Rangel.sql", ID: {87de47e2-f68e-4dba-a389-755112dcce84} as it has already been run on this database';
  SET NOEXEC ON;
END

GO
EXECUTE ('
PRINT N''Creating [dbo].[DM_INVOICE_LINE]''
');

GO
EXECUTE ('CREATE TABLE [dbo].[DM_INVOICE_LINE]
(
[invoice_number] [varchar] (10) NOT NULL,
[inventory_item_id] [varchar] (10) NOT NULL,
[invoice_line_quantity] [int] NULL,
[invoice_line_sale_price] [decimal] (10, 2) NULL
)
');

GO
EXECUTE ('PRINT N''Creating primary key [PK__DM_INVOI__D69CED10B7D89B13] on [dbo].[DM_INVOICE_LINE]''
');

GO
EXECUTE ('ALTER TABLE [dbo].[DM_INVOICE_LINE] ADD CONSTRAINT [PK__DM_INVOI__D69CED10B7D89B13] PRIMARY KEY CLUSTERED  ([invoice_number], [inventory_item_id])
');

GO
EXECUTE ('PRINT N''Creating [dbo].[DM_INVOICE_LINE_HISTORY]''
');

GO
EXECUTE ('CREATE TABLE [dbo].[DM_INVOICE_LINE_HISTORY]
(
[identCol] [int] NOT NULL IDENTITY(1, 1),
[invoice_number] [varchar] (6) NOT NULL,
[item_id] [varchar] (6) NOT NULL,
[quantity] [int] NULL
)
');

GO
EXECUTE ('PRINT N''Creating primary key [PK__DM_INVOI__2DE3C94A82AAE2C0] on [dbo].[DM_INVOICE_LINE_HISTORY]''
');

GO
EXECUTE ('ALTER TABLE [dbo].[DM_INVOICE_LINE_HISTORY] ADD CONSTRAINT [PK__DM_INVOI__2DE3C94A82AAE2C0] PRIMARY KEY CLUSTERED  ([identCol])
');

GO
EXECUTE ('PRINT N''Creating trigger [dbo].[IL_trig1] on [dbo].[DM_INVOICE_LINE]''
');

GO
EXECUTE ('create trigger [dbo].[IL_trig1]
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
');

GO
EXECUTE ('PRINT N''Creating [dbo].[DM_EMPLOYEE]''
');

GO
EXECUTE ('CREATE TABLE [dbo].[DM_EMPLOYEE]
(
[person_id] [int] NOT NULL,
[assignment_id] [int] NOT NULL,
[emp_id] [varchar] (50) NULL,
[first_name] [varchar] (40) NULL,
[last_name] [varchar] (40) NULL,
[full_name] [varchar] (40) NULL,
[birth_date] [datetime] NULL,
[gender] [varchar] (1) NULL,
[title] [varchar] (10) NULL,
[emp_data] [varchar] (100) NULL
)
');

GO
EXECUTE ('PRINT N''Creating index [empInd1] on [dbo].[DM_EMPLOYEE]''
');

GO
EXECUTE ('CREATE UNIQUE NONCLUSTERED INDEX [empInd1] ON [dbo].[DM_EMPLOYEE] ([person_id], [emp_id])
');

GO
EXECUTE ('PRINT N''Creating [dbo].[DM_EMP_AUDIT]''
');

GO
EXECUTE ('CREATE TABLE [dbo].[DM_EMP_AUDIT]
(
[identCol] [int] NOT NULL IDENTITY(1, 1),
[person_id] [int] NOT NULL,
[assignment_id] [int] NOT NULL,
[emp_id] [varchar] (10) NULL,
[first_name] [varchar] (40) NULL,
[last_name] [varchar] (40) NULL,
[full_name] [varchar] (40) NULL
)
');

GO
EXECUTE ('PRINT N''Creating primary key [PK__DM_EMP_A__2DE3C94AA18F71FC] on [dbo].[DM_EMP_AUDIT]''
');

GO
EXECUTE ('ALTER TABLE [dbo].[DM_EMP_AUDIT] ADD CONSTRAINT [PK__DM_EMP_A__2DE3C94AA18F71FC] PRIMARY KEY CLUSTERED  ([identCol])
');

GO
EXECUTE ('PRINT N''Creating trigger [dbo].[EMP_trig1] on [dbo].[DM_EMPLOYEE]''
');

GO
EXECUTE ('
create trigger [dbo].[EMP_trig1]
on [dbo].[DM_EMPLOYEE] after update
AS
BEGIN
  DECLARE @person_id integer
  DECLARE @assignment_id integer
  DECLARE @emp_id varchar(10)
  DECLARE @first_name varchar(40)
  DECLARE @last_name varchar(40)
  DECLARE @full_name varchar(40)
  Select @person_id=person_id, @assignment_id=assignment_id, @emp_id=emp_id, @first_name=first_name, @last_name=last_name, @full_name=full_name from DM_EMPLOYEE;
  insert into DM_EMP_AUDIT (person_id,assignment_id, emp_id,first_name,last_name,full_name) 
     values (@person_id,@assignment_id, @emp_id,@first_name,@last_name,@full_name);
END
');

GO
EXECUTE ('PRINT N''Creating [dbo].[DM_CUSTOMER]''
');

GO
EXECUTE ('CREATE TABLE [dbo].[DM_CUSTOMER]
(
[customer_id] [varchar] (10) NOT NULL,
[customer_firstname] [varchar] (60) NULL,
[customer_lastname] [varchar] (60) NULL,
[customer_gender] [varchar] (1) NULL,
[customer_company_name] [varchar] (60) NULL,
[customer_street_address] [varchar] (60) NULL,
[customer_region] [varchar] (60) NULL,
[customer_country] [varchar] (60) NULL,
[customer_email] [varchar] (60) NULL,
[customer_telephone] [varchar] (60) NULL,
[customer_zipcode] [varchar] (60) NULL,
[credit_card_type_id] [varchar] (2) NULL,
[customer_credit_card_number] [varchar] (60) NULL
)
');

GO
EXECUTE ('PRINT N''Creating primary key [PK__DM_CUSTO__CD65CB85EBAB0573] on [dbo].[DM_CUSTOMER]''
');

GO
EXECUTE ('ALTER TABLE [dbo].[DM_CUSTOMER] ADD CONSTRAINT [PK__DM_CUSTO__CD65CB85EBAB0573] PRIMARY KEY CLUSTERED  ([customer_id])
');

GO
EXECUTE ('PRINT N''Creating index [index_name] on [dbo].[DM_CUSTOMER]''
');

GO
EXECUTE ('CREATE NONCLUSTERED INDEX [index_name] ON [dbo].[DM_CUSTOMER] ([customer_street_address])
');

GO
EXECUTE ('PRINT N''Creating [dbo].[DM_CUSTOMER_NOTES]''
');

GO
EXECUTE ('CREATE TABLE [dbo].[DM_CUSTOMER_NOTES]
(
[customer_id] [varchar] (10) NOT NULL,
[customer_firstname] [varchar] (60) NULL,
[customer_lastname] [varchar] (60) NULL,
[customer_notes_entry_date] [datetime] NOT NULL,
[customer_note] [varchar] (2000) NULL
)
');

GO
EXECUTE ('PRINT N''Creating index [cnInd1] on [dbo].[DM_CUSTOMER_NOTES]''
');

GO
EXECUTE ('CREATE UNIQUE NONCLUSTERED INDEX [cnInd1] ON [dbo].[DM_CUSTOMER_NOTES] ([customer_id], [customer_notes_entry_date])
');

GO
EXECUTE ('PRINT N''Creating [dbo].[DM_CREDIT_CARD_TYPE]''
');

GO
EXECUTE ('CREATE TABLE [dbo].[DM_CREDIT_CARD_TYPE]
(
[credit_card_type_id] [varchar] (2) NOT NULL,
[credit_card_type_name] [varchar] (60) NULL
)
');

GO
EXECUTE ('PRINT N''Creating primary key [PK__DM_CREDI__F76530082B5BBF7D] on [dbo].[DM_CREDIT_CARD_TYPE]''
');

GO
EXECUTE ('ALTER TABLE [dbo].[DM_CREDIT_CARD_TYPE] ADD CONSTRAINT [PK__DM_CREDI__F76530082B5BBF7D] PRIMARY KEY CLUSTERED  ([credit_card_type_id])
');

GO
EXECUTE ('PRINT N''Creating [dbo].[DM_INVOICE]''
');

GO
EXECUTE ('CREATE TABLE [dbo].[DM_INVOICE]
(
[invoice_number] [varchar] (10) NOT NULL,
[invoice_date] [datetime] NULL,
[invoice_customer_id] [varchar] (60) NULL
)
');

GO
EXECUTE ('PRINT N''Creating primary key [PK__DM_INVOI__8081A63BC39394DD] on [dbo].[DM_INVOICE]''
');

GO
EXECUTE ('ALTER TABLE [dbo].[DM_INVOICE] ADD CONSTRAINT [PK__DM_INVOI__8081A63BC39394DD] PRIMARY KEY CLUSTERED  ([invoice_number])
');

GO
EXECUTE ('PRINT N''Creating [dbo].[DM_INVENTORY_ITEM]''
');

GO
EXECUTE ('CREATE TABLE [dbo].[DM_INVENTORY_ITEM]
(
[inventory_item_id] [varchar] (10) NOT NULL,
[inventory_item_name] [varchar] (60) NULL
)
');

GO
EXECUTE ('PRINT N''Creating primary key [PK__DM_INVEN__61D4B2B48522D3DF] on [dbo].[DM_INVENTORY_ITEM]''
');

GO
EXECUTE ('ALTER TABLE [dbo].[DM_INVENTORY_ITEM] ADD CONSTRAINT [PK__DM_INVEN__61D4B2B48522D3DF] PRIMARY KEY CLUSTERED  ([inventory_item_id])
');

GO
EXECUTE ('PRINT N''Creating [dbo].[GetContacts]''
');

GO
EXECUTE ('--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
CREATE PROCEDURE [dbo].[GetContacts]
--Author:sa
--Date: 26/11/2019
--GO
    @parameter_name AS INT
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| ''user_name''
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
');

GO
EXECUTE ('PRINT N''Creating [dbo].[DMS_AUDITTAB]''
');

GO
EXECUTE ('CREATE TABLE [dbo].[DMS_AUDITTAB]
(
[runid] [varchar] (100) NOT NULL,
[ruleid] [varchar] (50) NOT NULL,
[rulestatus] [char] (1) NULL,
[rulecreated] [datetime] NOT NULL,
[ruleupdated] [datetime] NULL,
[ruleblock] [int] NULL,
[rulenum] [int] NULL,
[rulesubscript] [int] NULL,
[ruletype] [varchar] (50) NULL,
[ruletarget] [varchar] (250) NULL,
[rstat1] [int] NULL,
[rstat2] [int] NULL,
[rstat3] [int] NULL,
[rstat4] [decimal] (18, 0) NULL,
[rstat5] [datetime] NULL,
[rstat6] [varchar] (50) NULL
)
');

GO
EXECUTE ('PRINT N''Creating index [IX_DMS_AUDITTAB] on [dbo].[DMS_AUDITTAB]''
');

GO
EXECUTE ('CREATE NONCLUSTERED INDEX [IX_DMS_AUDITTAB] ON [dbo].[DMS_AUDITTAB] ([runid], [ruleid])
');

GO
EXECUTE ('PRINT N''Creating [dbo].[DM_ASSIGNMENT]''
');

GO
EXECUTE ('CREATE TABLE [dbo].[DM_ASSIGNMENT]
(
[assignment_id] [int] NOT NULL,
[person_id] [int] NOT NULL,
[emp_id] [varchar] (10) NULL,
[emp_jobtitle] [varchar] (100) NULL,
[assignment_notes] [varchar] (1000) NULL
)
');

GO
EXECUTE ('PRINT N''Creating index [asgnInd1] on [dbo].[DM_ASSIGNMENT]''
');

GO
EXECUTE ('CREATE UNIQUE NONCLUSTERED INDEX [asgnInd1] ON [dbo].[DM_ASSIGNMENT] ([person_id], [assignment_id])
');

GO
EXECUTE ('PRINT N''Creating [dbo].[DM_CUSTOMER_ASXML_IDAttr]''
');

GO
EXECUTE ('CREATE TABLE [dbo].[DM_CUSTOMER_ASXML_IDAttr]
(
[customer_id] [varchar] (10) NOT NULL,
[customer_data] [xml] NULL
)
');

GO
EXECUTE ('PRINT N''Creating primary key [PK_DM_CUSTOMER_ASXML_IDAttr] on [dbo].[DM_CUSTOMER_ASXML_IDAttr]''
');

GO
EXECUTE ('ALTER TABLE [dbo].[DM_CUSTOMER_ASXML_IDAttr] ADD CONSTRAINT [PK_DM_CUSTOMER_ASXML_IDAttr] PRIMARY KEY CLUSTERED  ([customer_id])
');

GO
EXECUTE ('PRINT N''Creating [dbo].[DM_CUSTOMER_CONTACTS]''
');

GO
EXECUTE ('CREATE TABLE [dbo].[DM_CUSTOMER_CONTACTS]
(
[CONTACT_ID] [int] NOT NULL IDENTITY(1, 1),
[CONTACT_PERSON] [xml] NOT NULL CONSTRAINT [DF__DM_CUSTOM__CONTA__2F10007B] DEFAULT (''<Company />'')
)
');

GO
EXECUTE ('PRINT N''Creating primary key [PK__DM_CUSTO__99DE4258A3F94364] on [dbo].[DM_CUSTOMER_CONTACTS]''
');

GO
EXECUTE ('ALTER TABLE [dbo].[DM_CUSTOMER_CONTACTS] ADD CONSTRAINT [PK__DM_CUSTO__99DE4258A3F94364] PRIMARY KEY CLUSTERED  ([CONTACT_ID])
');

GO
EXECUTE ('PRINT N''Creating [dbo].[DM_SUPPLIERS]''
');

GO
EXECUTE ('CREATE TABLE [dbo].[DM_SUPPLIERS]
(
[supplier_id] [int] NOT NULL,
[supplier_name] [varchar] (60) NULL
)
');

GO
EXECUTE ('PRINT N''Creating primary key [PK__DM_SUPPL__6EE594E8AB4A022B] on [dbo].[DM_SUPPLIERS]''
');

GO
EXECUTE ('ALTER TABLE [dbo].[DM_SUPPLIERS] ADD CONSTRAINT [PK__DM_SUPPL__6EE594E8AB4A022B] PRIMARY KEY CLUSTERED  ([supplier_id])
');

GO
EXECUTE ('PRINT N''Adding foreign keys to [dbo].[DM_CUSTOMER]''
');

GO
EXECUTE ('ALTER TABLE [dbo].[DM_CUSTOMER] ADD CONSTRAINT [CU_FK] FOREIGN KEY ([credit_card_type_id]) REFERENCES [dbo].[DM_CREDIT_CARD_TYPE] ([credit_card_type_id])
');

GO
EXECUTE ('PRINT N''Adding foreign keys to [dbo].[DM_CUSTOMER_NOTES]''
');

GO
EXECUTE ('ALTER TABLE [dbo].[DM_CUSTOMER_NOTES] ADD CONSTRAINT [CN_FK] FOREIGN KEY ([customer_id]) REFERENCES [dbo].[DM_CUSTOMER] ([customer_id])
');

GO
EXECUTE ('PRINT N''Adding foreign keys to [dbo].[DM_INVOICE_LINE]''
');

GO
EXECUTE ('ALTER TABLE [dbo].[DM_INVOICE_LINE] ADD CONSTRAINT [I4_FK] FOREIGN KEY ([inventory_item_id]) REFERENCES [dbo].[DM_INVENTORY_ITEM] ([inventory_item_id])
');

GO
EXECUTE ('ALTER TABLE [dbo].[DM_INVOICE_LINE] ADD CONSTRAINT [I3_FK] FOREIGN KEY ([invoice_number]) REFERENCES [dbo].[DM_INVOICE] ([invoice_number])
');

GO
SET NOEXEC OFF;

GO
IF N'$(IsSqlCmdEnabled)' <> N'True'
  SET NOEXEC ON;

GO
IF NOT EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('87de47e2-f68e-4dba-a389-755112dcce84' AS UNIQUEIDENTIFIER))
  PRINT '***** FINISHED EXECUTING MIGRATION "Migrations\1.0.0-Baseline\001_20200901-0002_Anderson.Rangel.sql", ID: {87de47e2-f68e-4dba-a389-755112dcce84} *****
';

GO
IF NOT EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('87de47e2-f68e-4dba-a389-755112dcce84' AS UNIQUEIDENTIFIER))
  INSERT [$(DatabaseName)].[dbo].[__MigrationLog] ([migration_id], [script_checksum], [script_filename], [complete_dt], [applied_by], [deployed], [version], [package_version], [release_version])
  VALUES                                         (CAST ('87de47e2-f68e-4dba-a389-755112dcce84' AS UNIQUEIDENTIFIER), '7808BFF7EDD9F751D9D6282C81B6A9BED04DED22B20889A2BC5F9D5ACC2CE748', 'Migrations\1.0.0-Baseline\001_20200901-0002_Anderson.Rangel.sql', SYSDATETIME(), SYSTEM_USER, 1, NULL, '$(PackageVersion)', CASE '$(ReleaseVersion)' WHEN '' THEN NULL ELSE '$(ReleaseVersion)' END);

GO
SET IMPLICIT_TRANSACTIONS, NUMERIC_ROUNDABORT OFF;
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, NOCOUNT, QUOTED_IDENTIFIER ON;

GO
IF DB_NAME() != '$(DatabaseName)'
  USE [$(DatabaseName)];

GO
IF NOT EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('9170f158-c470-5b3f-8c5e-735a4c2f9ba4' AS UNIQUEIDENTIFIER) AND [script_checksum] = 'A0F9D402ADFF2DDEB0561D839E5CE34A1B620EC12348BA0FC277A78A429371D9')
  PRINT '

***** EXECUTING MIGRATION "Programmable Objects\dbo\Stored Procedures\GetContacts.sql", ID: {9170f158-c470-5b3f-8c5e-735a4c2f9ba4} *****';

GO
IF EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('9170f158-c470-5b3f-8c5e-735a4c2f9ba4' AS UNIQUEIDENTIFIER) AND [script_checksum] = 'A0F9D402ADFF2DDEB0561D839E5CE34A1B620EC12348BA0FC277A78A429371D9')
BEGIN
  PRINT '----- Skipping "Programmable Objects\dbo\Stored Procedures\GetContacts.sql", ID: {9170f158-c470-5b3f-8c5e-735a4c2f9ba4} as there are no changes to deploy';
  SET NOEXEC ON;
END

GO
EXECUTE ('IF OBJECT_ID(''[dbo].[GetContacts]'') IS NOT NULL
	DROP PROCEDURE [dbo].[GetContacts];

');

GO
SET QUOTED_IDENTIFIER ON

GO
SET ANSI_NULLS ON

GO
EXECUTE ('--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
CREATE PROCEDURE [dbo].[GetContacts]
--Author:sa
--Date: 26/11/2019
--GO
    @parameter_name AS INT
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| ''user_name''
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
			--v2
');

GO
SET NOEXEC OFF;

GO
IF N'$(IsSqlCmdEnabled)' <> N'True'
  SET NOEXEC ON;

GO
IF NOT EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('9170f158-c470-5b3f-8c5e-735a4c2f9ba4' AS UNIQUEIDENTIFIER) AND [script_checksum] = 'A0F9D402ADFF2DDEB0561D839E5CE34A1B620EC12348BA0FC277A78A429371D9')
  PRINT '***** FINISHED EXECUTING MIGRATION "Programmable Objects\dbo\Stored Procedures\GetContacts.sql", ID: {9170f158-c470-5b3f-8c5e-735a4c2f9ba4} *****
';

GO
IF NOT EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('9170f158-c470-5b3f-8c5e-735a4c2f9ba4' AS UNIQUEIDENTIFIER) AND [script_checksum] = 'A0F9D402ADFF2DDEB0561D839E5CE34A1B620EC12348BA0FC277A78A429371D9')
  INSERT [$(DatabaseName)].[dbo].[__MigrationLog] ([migration_id], [script_checksum], [script_filename], [complete_dt], [applied_by], [deployed], [version], [package_version], [release_version])
  VALUES                                         (CAST ('9170f158-c470-5b3f-8c5e-735a4c2f9ba4' AS UNIQUEIDENTIFIER), 'A0F9D402ADFF2DDEB0561D839E5CE34A1B620EC12348BA0FC277A78A429371D9', 'Programmable Objects\dbo\Stored Procedures\GetContacts.sql', SYSDATETIME(), SYSTEM_USER, 1, NULL, '$(PackageVersion)', CASE '$(ReleaseVersion)' WHEN '' THEN NULL ELSE '$(ReleaseVersion)' END);

GO
PRINT '# Committing transaction';

COMMIT TRANSACTION;

GO







------------------------------------------------------------------------------------------------------------------------
------------------------------------------       POST-DEPLOYMENT SCRIPTS      ------------------------------------------
------------------------------------------------------------------------------------------------------------------------

SET IMPLICIT_TRANSACTIONS, NUMERIC_ROUNDABORT OFF;
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, NOCOUNT, QUOTED_IDENTIFIER ON;
IF DB_NAME() != '$(DatabaseName)'
  USE [$(DatabaseName)];

GO

PRINT '----- executing post-deployment script "Post-Deployment\01_Finalize_Deployment.sql" -----';
GO

---------------------- BEGIN POST-DEPLOYMENT SCRIPT: "Post-Deployment\01_Finalize_Deployment.sql" ------------------------
/*
Post-Deployment Script Template
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.
 Use SQLCMD syntax to include a file in the post-deployment script.
 Example:      :r .\myfile.sql
 Use SQLCMD syntax to reference a variable in the post-deployment script.
 Example:      :setvar TableName MyTable
               SELECT * FROM [$(TableName)]
--------------------------------------------------------------------------------------
*/

GO
----------------------- END POST-DEPLOYMENT SCRIPT: "Post-Deployment\01_Finalize_Deployment.sql" -------------------------

SET IMPLICIT_TRANSACTIONS, NUMERIC_ROUNDABORT OFF;
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, NOCOUNT, QUOTED_IDENTIFIER ON;
IF DB_NAME() != '$(DatabaseName)'
  USE [$(DatabaseName)];

GO


IF SERVERPROPERTY('EngineEdition') != 5 AND HAS_PERMS_BY_NAME(N'sys.xp_logevent', N'OBJECT', N'EXECUTE') = 1
BEGIN
  DECLARE @databaseName AS nvarchar(2048), @eventMessage AS nvarchar(2048)
  SET @databaseName = REPLACE(REPLACE(DB_NAME(), N'\', N'\\'), N'"', N'\"')
  SET @eventMessage = N'Redgate SQL Change Automation: { "deployment": { "description": "Redgate SQL Change Automation deployed $(ReleaseVersion) to ' + @databaseName + N'", "database": "' + @databaseName + N'" }}'
  EXECUTE sys.xp_logevent 55000, @eventMessage
END
PRINT 'Deployment completed successfully.'
GO




SET NOEXEC OFF; -- Resume statement execution if an error occurred within the script pre-amble
