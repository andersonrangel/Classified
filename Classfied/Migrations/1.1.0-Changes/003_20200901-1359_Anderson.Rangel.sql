-- <Migration ID="dd343b50-1532-4421-8819-2b748a2c31f3" />
GO

PRINT N'Creating [dbo].[Blogs]'
GO
CREATE TABLE [dbo].[Blogs]
(
[BlogsID] [int] NOT NULL IDENTITY(1, 1),
[AuthorID] [int] NULL,
[Title] [char] (142) NULL,
[PublishDate] [datetime] NULL,
[Article] [nvarchar] (50) NULL
)
GO
PRINT N'Creating primary key [PK__Blogs__C03C1E467AEB09A9] on [dbo].[Blogs]'
GO
ALTER TABLE [dbo].[Blogs] ADD CONSTRAINT [PK__Blogs__C03C1E467AEB09A9] PRIMARY KEY CLUSTERED  ([BlogsID])
GO
PRINT N'Creating [dbo].[BlogComments]'
GO
CREATE TABLE [dbo].[BlogComments]
(
[BlogCommentsID] [int] NOT NULL IDENTITY(1, 1),
[BlogsID] [int] NOT NULL,
[CommentText] [nvarchar] (200) NULL,
[CommentDate] [datetime] NOT NULL
)
GO
PRINT N'Creating primary key [PK__BlogComments] on [dbo].[BlogComments]'
GO
ALTER TABLE [dbo].[BlogComments] ADD CONSTRAINT [PK__BlogComments] PRIMARY KEY CLUSTERED  ([BlogCommentsID])
GO
PRINT N'Creating [dbo].[CountryCodes]'
GO
CREATE TABLE [dbo].[CountryCodes]
(
[CountryName] [nvarchar] (255) NULL,
[CountryCode] [nvarchar] (4) NOT NULL
)
GO
PRINT N'Creating primary key [PK_Countries] on [dbo].[CountryCodes]'
GO
ALTER TABLE [dbo].[CountryCodes] ADD CONSTRAINT [PK_Countries] PRIMARY KEY CLUSTERED  ([CountryCode])
GO
PRINT N'Creating [dbo].[Contacts]'
GO
CREATE TABLE [dbo].[Contacts]
(
[ContactsID] [int] NOT NULL IDENTITY(1, 1),
[ContactFullName] [nvarchar] (100) NOT NULL,
[PhoneWork] [nvarchar] (25) NULL,
[PhoneMobile] [nvarchar] (25) NULL,
[Address1] [nvarchar] (128) NULL,
[Address2] [nvarchar] (128) NULL,
[Address3] [nvarchar] (128) NULL,
[CountryCode] [nvarchar] (4) NULL CONSTRAINT [DF__Contacts__Countr__117F9D94] DEFAULT (N'US'),
[JoiningDate] [datetime] NULL CONSTRAINT [DF__Contacts__Joinin__1273C1CD] DEFAULT (getdate()),
[ModifiedDate] [datetime] NULL,
[Email] [nvarchar] (256) NULL,
[Photo] [image] NULL,
[LinkedIn] [nvarchar] (128) NULL
)
GO
PRINT N'Creating primary key [PK__Contacts__912F378B7C53D1A0] on [dbo].[Contacts]'
GO
ALTER TABLE [dbo].[Contacts] ADD CONSTRAINT [PK__Contacts__912F378B7C53D1A0] PRIMARY KEY CLUSTERED  ([ContactsID])
GO
PRINT N'Creating [dbo].[Articles]'
GO
CREATE TABLE [dbo].[Articles]
(
[ArticlesID] [int] NOT NULL IDENTITY(1, 1),
[AuthorID] [int] NULL,
[Title] [char] (142) NULL,
[Description] [varchar] (max) NULL,
[Article] [varchar] (max) NULL,
[PublishDate] [datetime] NULL,
[ModifiedDate] [datetime] NULL,
[URL] [char] (200) NULL,
[Comments] [int] NULL
)
GO
PRINT N'Creating primary key [PK_Article] on [dbo].[Articles]'
GO
ALTER TABLE [dbo].[Articles] ADD CONSTRAINT [PK_Article] PRIMARY KEY CLUSTERED  ([ArticlesID])
GO
PRINT N'Creating [dbo].[ArticleDescriptions]'
GO
CREATE TABLE [dbo].[ArticleDescriptions]
(
[ArticlesID] [int] NOT NULL IDENTITY(1, 1),
[ShortDescription] [nvarchar] (2000) NULL,
[Description] [text] NULL,
[ArticlesName] [varchar] (50) NULL,
[Picture] [image] NULL
)
GO
PRINT N'Creating primary key [PK_ArticleDescriptions] on [dbo].[ArticleDescriptions]'
GO
ALTER TABLE [dbo].[ArticleDescriptions] ADD CONSTRAINT [PK_ArticleDescriptions] PRIMARY KEY CLUSTERED  ([ArticlesID])
GO
PRINT N'Creating [dbo].[ArticlePrices]'
GO
CREATE TABLE [dbo].[ArticlePrices]
(
[ArticlePricesID] [int] NOT NULL IDENTITY(1, 1),
[ArticlesID] [int] NULL,
[Price] [money] NULL,
[ValidFrom] [datetime] NULL CONSTRAINT [DF__ArticlePr__Valid__1CF15040] DEFAULT (getdate()),
[ValidTo] [datetime] NULL,
[Active] [char] (1) NULL CONSTRAINT [DF__ArticlePr__Activ__1DE57479] DEFAULT ('N'),
[SalesPrice] [char] (1) NULL
)
GO
PRINT N'Creating primary key [PK_ArticlePrices] on [dbo].[ArticlePrices]'
GO
ALTER TABLE [dbo].[ArticlePrices] ADD CONSTRAINT [PK_ArticlePrices] PRIMARY KEY CLUSTERED  ([ArticlePricesID])
GO
PRINT N'Creating index [IX_ArticlePrices] on [dbo].[ArticlePrices]'
GO
CREATE NONCLUSTERED INDEX [IX_ArticlePrices] ON [dbo].[ArticlePrices] ([ArticlesID])
GO
PRINT N'Creating index [IX_ArticlePrices_1] on [dbo].[ArticlePrices]'
GO
CREATE NONCLUSTERED INDEX [IX_ArticlePrices_1] ON [dbo].[ArticlePrices] ([ValidFrom])
GO
PRINT N'Creating index [IX_ArticlePrices_2] on [dbo].[ArticlePrices]'
GO
CREATE NONCLUSTERED INDEX [IX_ArticlePrices_2] ON [dbo].[ArticlePrices] ([ValidTo])
GO
PRINT N'Creating [dbo].[ArticleReferences]'
GO
CREATE TABLE [dbo].[ArticleReferences]
(
[ArticlesID] [int] NOT NULL IDENTITY(1, 1),
[Reference] [varchar] (50) NULL
)
GO
PRINT N'Creating primary key [PK_ArticleReferences] on [dbo].[ArticleReferences]'
GO
ALTER TABLE [dbo].[ArticleReferences] ADD CONSTRAINT [PK_ArticleReferences] PRIMARY KEY CLUSTERED  ([ArticlesID])
GO
PRINT N'Creating [dbo].[RSSFeeds]'
GO
CREATE TABLE [dbo].[RSSFeeds]
(
[RSSFeedID] [int] NOT NULL IDENTITY(1, 1),
[FeedName] [varchar] (max) NULL,
[Checked] [bit] NULL,
[FeedBurner] [bit] NOT NULL
)
GO
PRINT N'Creating primary key [PK__RSSFeeds__DF1690F2C1F77AC5] on [dbo].[RSSFeeds]'
GO
ALTER TABLE [dbo].[RSSFeeds] ADD CONSTRAINT [PK__RSSFeeds__DF1690F2C1F77AC5] PRIMARY KEY CLUSTERED  ([RSSFeedID])
GO
PRINT N'Creating [dbo].[ArticlePurchases]'
GO
CREATE TABLE [dbo].[ArticlePurchases]
(
[ArticlePurchasesID] [int] NOT NULL IDENTITY(1, 1),
[ArticlePricesID] [int] NOT NULL,
[Quantity] [int] NOT NULL CONSTRAINT [DF__ArticlePu__Quant__22AA2996] DEFAULT ((1)),
[InvoiceNumber] [nvarchar] (20) NULL,
[PurchaseDate] [datetime] NOT NULL
)
GO
PRINT N'Creating primary key [PK_ArticlePurchases] on [dbo].[ArticlePurchases]'
GO
ALTER TABLE [dbo].[ArticlePurchases] ADD CONSTRAINT [PK_ArticlePurchases] PRIMARY KEY CLUSTERED  ([ArticlePurchasesID])
GO
PRINT N'Creating [dbo].[PersonData]'
GO
CREATE TABLE [dbo].[PersonData]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[NAME] [nvarchar] (200) NOT NULL,
[Email1] [nvarchar] (200) NULL,
[Email2] [nvarchar] (200) NULL,
[Phone1] [nvarchar] (100) NULL,
[Phone2] [nvarchar] (100) NULL,
[Street1] [nvarchar] (200) NULL,
[City1] [nvarchar] (200) NULL,
[StateProvince1] [nvarchar] (50) NULL,
[PostalCode1] [nvarchar] (50) NULL,
[Street2] [nvarchar] (200) NULL,
[City2] [nvarchar] (200) NULL,
[StateProvince2] [nvarchar] (50) NULL,
[PostalCode2] [nvarchar] (50) NULL
)
GO
PRINT N'Creating primary key [PK__PersonDa__3214EC27CA5DC9C3] on [dbo].[PersonData]'
GO
ALTER TABLE [dbo].[PersonData] ADD CONSTRAINT [PK__PersonDa__3214EC27CA5DC9C3] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[ArticleDescriptions]'
GO
ALTER TABLE [dbo].[ArticleDescriptions] ADD CONSTRAINT [FK_ArticleDescriptions] FOREIGN KEY ([ArticlesID]) REFERENCES [dbo].[Articles] ([ArticlesID])
GO
PRINT N'Adding foreign keys to [dbo].[ArticlePrices]'
GO
ALTER TABLE [dbo].[ArticlePrices] ADD CONSTRAINT [FK_ArticlePrices] FOREIGN KEY ([ArticlesID]) REFERENCES [dbo].[Articles] ([ArticlesID])
GO
PRINT N'Adding foreign keys to [dbo].[ArticleReferences]'
GO
ALTER TABLE [dbo].[ArticleReferences] ADD CONSTRAINT [FK_Articles] FOREIGN KEY ([ArticlesID]) REFERENCES [dbo].[Articles] ([ArticlesID])
GO
PRINT N'Adding foreign keys to [dbo].[Articles]'
GO
ALTER TABLE [dbo].[Articles] ADD CONSTRAINT [FK_Author] FOREIGN KEY ([AuthorID]) REFERENCES [dbo].[Contacts] ([ContactsID])
GO
PRINT N'Adding foreign keys to [dbo].[BlogComments]'
GO
ALTER TABLE [dbo].[BlogComments] ADD CONSTRAINT [FK__BlogComments] FOREIGN KEY ([BlogsID]) REFERENCES [dbo].[Blogs] ([BlogsID])
GO
PRINT N'Adding foreign keys to [dbo].[Blogs]'
GO
ALTER TABLE [dbo].[Blogs] ADD CONSTRAINT [FK_BlogAuthor] FOREIGN KEY ([AuthorID]) REFERENCES [dbo].[Contacts] ([ContactsID])
GO
PRINT N'Adding foreign keys to [dbo].[Contacts]'
GO
ALTER TABLE [dbo].[Contacts] ADD CONSTRAINT [FK__Contacts__Countr__145C0A3F] FOREIGN KEY ([CountryCode]) REFERENCES [dbo].[CountryCodes] ([CountryCode])
GO
PRINT N'Creating extended properties'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A short summary of the article appearing on the main Simple Talk page', 'SCHEMA', N'dbo', 'TABLE', N'ArticleDescriptions', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Deprecated - do not use', 'SCHEMA', N'dbo', 'TABLE', N'ArticleDescriptions', 'COLUMN', N'ArticlesName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Deprecated - do not use', 'SCHEMA', N'dbo', 'TABLE', N'ArticleDescriptions', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Deprecated - do not use', 'SCHEMA', N'dbo', 'TABLE', N'ArticleDescriptions', 'COLUMN', N'Picture'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The description that appears on the main web page', 'SCHEMA', N'dbo', 'TABLE', N'ArticleDescriptions', 'COLUMN', N'ShortDescription'
GO
EXEC sp_addextendedproperty N'MS_Description', N'How much was paid for the article', 'SCHEMA', N'dbo', 'TABLE', N'ArticlePrices', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'References listed in an article', 'SCHEMA', N'dbo', 'TABLE', N'ArticleReferences', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Table of Simple Talk articles', 'SCHEMA', N'dbo', 'TABLE', N'Articles', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The actual article content', 'SCHEMA', N'dbo', 'TABLE', N'Articles', 'COLUMN', N'Article'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The number of reader comments for a given article', 'SCHEMA', N'dbo', 'TABLE', N'Articles', 'COLUMN', N'Comments'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A short description of the article going between the title and "read more"', 'SCHEMA', N'dbo', 'TABLE', N'Articles', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'When the article was last modified', 'SCHEMA', N'dbo', 'TABLE', N'Articles', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'When the article was published', 'SCHEMA', N'dbo', 'TABLE', N'Articles', 'COLUMN', N'PublishDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The main title - appears on main web page as well as heading the article page', 'SCHEMA', N'dbo', 'TABLE', N'Articles', 'COLUMN', N'Title'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The hyperlink when the title or "read more" is clicked', 'SCHEMA', N'dbo', 'TABLE', N'Articles', 'COLUMN', N'URL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Comments made by readers', 'SCHEMA', N'dbo', 'TABLE', N'BlogComments', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date the comment was made', 'SCHEMA', N'dbo', 'TABLE', N'BlogComments', 'COLUMN', N'CommentDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The text for the comment', 'SCHEMA', N'dbo', 'TABLE', N'BlogComments', 'COLUMN', N'CommentText'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Blog posts made by Simple Talk members', 'SCHEMA', N'dbo', 'TABLE', N'Blogs', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Authors link back to the Contacts table', 'SCHEMA', N'dbo', 'TABLE', N'Blogs', 'COLUMN', N'AuthorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the Blog was published', 'SCHEMA', N'dbo', 'TABLE', N'Blogs', 'COLUMN', N'PublishDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Title of a Blog', 'SCHEMA', N'dbo', 'TABLE', N'Blogs', 'COLUMN', N'Title'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A list of all Simple Talk members, including authors, bloggers, and any other member or contributor', 'SCHEMA', N'dbo', 'TABLE', N'Contacts', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contact name', 'SCHEMA', N'dbo', 'TABLE', N'Contacts', 'COLUMN', N'ContactFullName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Country for the given address', 'SCHEMA', N'dbo', 'TABLE', N'Contacts', 'COLUMN', N'CountryCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contact email address', 'SCHEMA', N'dbo', 'TABLE', N'Contacts', 'COLUMN', N'Email'
GO
EXEC sp_addextendedproperty N'MS_Description', N'When the contact joined Simple Talk', 'SCHEMA', N'dbo', 'TABLE', N'Contacts', 'COLUMN', N'JoiningDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'When the contact details were last modified', 'SCHEMA', N'dbo', 'TABLE', N'Contacts', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Photo of contact, especially authors.
This is now deprecated as the photos are saved as image files outside of the database.', 'SCHEMA', N'dbo', 'TABLE', N'Contacts', 'COLUMN', N'Photo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A list of country codes 
ISO 3166-1-alpha-2 code
http://www.iso.org/iso/country_codes/iso_3166_code_lists/country_names_and_code_elements.htm', 'SCHEMA', N'dbo', 'TABLE', N'CountryCodes', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'In theory shouldn''t need more than two characters', 'SCHEMA', N'dbo', 'TABLE', N'CountryCodes', 'COLUMN', N'CountryCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A feature to create a custom RSS feed', 'SCHEMA', N'dbo', 'TABLE', N'RSSFeeds', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Whether checked by default on the list offered to users', 'SCHEMA', N'dbo', 'TABLE', N'RSSFeeds', 'COLUMN', N'Checked'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Eg, SQL, .NET, SysAdmin, Opinion etc.', 'SCHEMA', N'dbo', 'TABLE', N'RSSFeeds', 'COLUMN', N'FeedName'
GO
