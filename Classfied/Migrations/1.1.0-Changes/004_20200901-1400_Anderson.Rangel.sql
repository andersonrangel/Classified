-- <Migration ID="a1a64e2d-f9fc-44e8-8776-a28802659c9f" />
GO


SET DATEFORMAT YMD;


GO
IF (SELECT COUNT(*)
    FROM   [dbo].[RSSFeeds]) = 0
    BEGIN
        PRINT (N'Add 4 rows to [dbo].[RSSFeeds]');
        SET IDENTITY_INSERT [dbo].[RSSFeeds] ON;
        INSERT  INTO [dbo].[RSSFeeds] ([RSSFeedID], [FeedName], [Checked], [FeedBurner])
        VALUES                       (1, 'SQL', 1, 0);
        INSERT  INTO [dbo].[RSSFeeds] ([RSSFeedID], [FeedName], [Checked], [FeedBurner])
        VALUES                       (2, '.NET', 1, 1);
        INSERT  INTO [dbo].[RSSFeeds] ([RSSFeedID], [FeedName], [Checked], [FeedBurner])
        VALUES                       (3, 'SysAdmin', 1, 0);
        INSERT  INTO [dbo].[RSSFeeds] ([RSSFeedID], [FeedName], [Checked], [FeedBurner])
        VALUES                       (4, 'Opinion', 1, 1);
        SET IDENTITY_INSERT [dbo].[RSSFeeds] OFF;
    END


GO