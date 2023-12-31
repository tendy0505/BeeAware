USE [master]
GO
/****** Object:  Database [BeeAware]    Script Date: 8/30/2023 5:25:38 PM ******/
CREATE DATABASE [BeeAware]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BeeAware', FILENAME = N'C:\Users\tendy\Desktop\BeeAware.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'BeeAware_log', FILENAME = N'C:\Users\tendy\Desktop\BeeAware_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [BeeAware] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BeeAware].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BeeAware] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BeeAware] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BeeAware] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BeeAware] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BeeAware] SET ARITHABORT OFF 
GO
ALTER DATABASE [BeeAware] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BeeAware] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BeeAware] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BeeAware] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BeeAware] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BeeAware] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BeeAware] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BeeAware] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BeeAware] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BeeAware] SET  DISABLE_BROKER 
GO
ALTER DATABASE [BeeAware] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BeeAware] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BeeAware] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BeeAware] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BeeAware] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BeeAware] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BeeAware] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BeeAware] SET RECOVERY FULL 
GO
ALTER DATABASE [BeeAware] SET  MULTI_USER 
GO
ALTER DATABASE [BeeAware] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BeeAware] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BeeAware] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BeeAware] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [BeeAware] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'BeeAware', N'ON'
GO
ALTER DATABASE [BeeAware] SET QUERY_STORE = OFF
GO
USE [BeeAware]
GO
/****** Object:  Table [dbo].[mms_Relationship]    Script Date: 8/30/2023 5:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mms_Relationship](
	[RelationshipNo] [bigint] IDENTITY(1,1) NOT NULL,
	[MemberNo_Parent] [bigint] NOT NULL,
	[MemberNo_Child] [bigint] NOT NULL,
	[Notes] [varchar](max) NULL,
	[Timestamp] [datetime] NULL,
 CONSTRAINT [PK_oms_Relationship] PRIMARY KEY CLUSTERED 
(
	[RelationshipNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mms_Members]    Script Date: 8/30/2023 5:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mms_Members](
	[UserID] [bigint] IDENTITY(1000,5) NOT NULL,
	[Name_First] [nvarchar](50) NOT NULL,
	[Name_Last] [nvarchar](50) NOT NULL,
	[Type] [nvarchar](10) NOT NULL,
	[Status] [varchar](10) NOT NULL,
	[UserPoints] [int] NOT NULL,
	[PostDate] [date] NULL,
 CONSTRAINT [PK_Table_1] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vHierarchy]    Script Date: 8/30/2023 5:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vHierarchy]
AS
SELECT        mms_Members_2.UserID AS Org_UserID, mms_Members_2.Name_First AS Org_Name, mms_Members_2.Type AS Org_Type, mms_Members_1.UserID AS Unit_UserID, mms_Members_1.Name_First AS Unit_Name, 
                         mms_Members_1.Type AS Unit_Type, mms_Members_3.UserID AS Team_UserID, mms_Members_3.Name_First AS Team_Name, mms_Members_3.Type AS Team_Type, dbo.mms_Relationship.Notes AS Team_Notes, 
                         dbo.mms_Members.UserID AS Memb_UserID, dbo.mms_Members.Name_First AS Memb_Name_First, dbo.mms_Members.Name_Last AS Memb_Name_Last, dbo.mms_Members.Type AS Memb_Type
FROM            dbo.mms_Relationship AS mms_Relationship_1 FULL OUTER JOIN
                         dbo.mms_Members INNER JOIN
                         dbo.mms_Relationship INNER JOIN
                         dbo.mms_Relationship AS mms_Relationship_2 INNER JOIN
                         dbo.mms_Members AS mms_Members_1 ON mms_Relationship_2.MemberNo_Parent = mms_Members_1.UserID INNER JOIN
                         dbo.mms_Members AS mms_Members_3 ON mms_Relationship_2.MemberNo_Child = mms_Members_3.UserID ON dbo.mms_Relationship.MemberNo_Parent = mms_Members_3.UserID ON 
                         dbo.mms_Members.UserID = dbo.mms_Relationship.MemberNo_Child ON mms_Relationship_1.MemberNo_Child = mms_Members_1.UserID FULL OUTER JOIN
                         dbo.mms_Members AS mms_Members_2 ON mms_Relationship_1.MemberNo_Parent = mms_Members_2.UserID
WHERE        (mms_Members_2.Type = N'ORG') AND (NOT (mms_Relationship_1.MemberNo_Parent IS NULL)) AND (mms_Relationship_1.MemberNo_Child <> mms_Relationship_1.MemberNo_Parent) AND 
                         (mms_Members_1.Type = N'ORGUnit') AND (mms_Members_3.Type = N'Team')
GO
/****** Object:  View [dbo].[vRelationships]    Script Date: 8/30/2023 5:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vRelationships]
AS
SELECT        mms_Members_2.UserID AS Org_UserID, mms_Members_2.Name_First AS Org_Name, mms_Members_2.Type AS Org_Type, mms_Members_1.UserID AS Unit_UserID, mms_Members_1.Name_First AS Unit_Name, 
                         mms_Members_1.Type AS Unit_Type, mms_Members_3.UserID AS Team_UserID, mms_Members_3.Name_First AS Team_Name, mms_Members_3.Type AS Team_Type, dbo.mms_Relationship.Notes AS Team_Notes, 
                         dbo.mms_Members.UserID AS Memb_UserID, dbo.mms_Members.Name_First AS Memb_Name_First, dbo.mms_Members.Name_Last AS Memb_Name_Last, dbo.mms_Members.Type AS Memb_Type
FROM            dbo.mms_Relationship AS mms_Relationship_1 FULL OUTER JOIN
                         dbo.mms_Members INNER JOIN
                         dbo.mms_Relationship INNER JOIN
                         dbo.mms_Relationship AS mms_Relationship_2 INNER JOIN
                         dbo.mms_Members AS mms_Members_1 ON mms_Relationship_2.MemberNo_Parent = mms_Members_1.UserID INNER JOIN
                         dbo.mms_Members AS mms_Members_3 ON mms_Relationship_2.MemberNo_Child = mms_Members_3.UserID ON dbo.mms_Relationship.MemberNo_Parent = mms_Members_3.UserID ON 
                         dbo.mms_Members.UserID = dbo.mms_Relationship.MemberNo_Child ON mms_Relationship_1.MemberNo_Child = mms_Members_1.UserID FULL OUTER JOIN
                         dbo.mms_Members AS mms_Members_2 ON mms_Relationship_1.MemberNo_Parent = mms_Members_2.UserID
WHERE        (mms_Members_1.Type = N'ORGUnit') AND (mms_Members_3.Type = N'Team')
GO
/****** Object:  Table [dbo].[exp_Example]    Script Date: 8/30/2023 5:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[exp_Example](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [text] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[glb_Awards]    Script Date: 8/30/2023 5:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[glb_Awards](
	[AwardID] [bigint] NOT NULL,
	[PostUserID] [bigint] NULL,
	[RespUserID] [bigint] NOT NULL,
	[Points] [int] NULL,
	[PlugIn] [varchar](3) NULL,
	[Reference] [varchar](10) NULL,
	[PostDate] [date] NULL,
 CONSTRAINT [PK_glb_Awards] PRIMARY KEY CLUSTERED 
(
	[AwardID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[glb_Lookups]    Script Date: 8/30/2023 5:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[glb_Lookups](
	[LookupID] [bigint] IDENTITY(10000,5) NOT NULL,
	[LookupSrc] [char](1) NOT NULL,
	[LookupType] [varchar](15) NOT NULL,
	[LookupCode] [varchar](15) NOT NULL,
	[Description] [varchar](50) NULL,
 CONSTRAINT [PK_oms_Lookups] PRIMARY KEY CLUSTERED 
(
	[LookupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[glb_Noticebrd]    Script Date: 8/30/2023 5:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[glb_Noticebrd](
	[NoticebrdID] [bigint] NOT NULL,
	[PostUserID] [bigint] NOT NULL,
	[Notice] [varchar](max) NULL,
	[PlugIn] [varchar](3) NULL,
	[PostDate] [date] NOT NULL,
 CONSTRAINT [PK_glb_Noticebrd] PRIMARY KEY CLUSTERED 
(
	[NoticebrdID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[glb_SecMod]    Script Date: 8/30/2023 5:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[glb_SecMod](
	[SecModID] [bigint] IDENTITY(1,1) NOT NULL,
	[Module] [char](3) NOT NULL,
	[ModuleCode] [varchar](10) NULL,
	[Description] [varchar](100) NULL,
	[SecurityLevel] [int] NOT NULL,
 CONSTRAINT [PK_glb_ModSec] PRIMARY KEY CLUSTERED 
(
	[SecModID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[glb_SecUser]    Script Date: 8/30/2023 5:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[glb_SecUser](
	[SecUserID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [bigint] NOT NULL,
	[SecModID] [varchar](10) NULL,
	[SecurityLevel] [int] NOT NULL,
 CONSTRAINT [PK_glb_UserSec] PRIMARY KEY CLUSTERED 
(
	[SecUserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[glb_Setup]    Script Date: 8/30/2023 5:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[glb_Setup](
	[SetupID] [bigint] NOT NULL,
	[NoticeBrdDays] [int] NOT NULL,
 CONSTRAINT [PK_glb_Setup] PRIMARY KEY CLUSTERED 
(
	[SetupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[glb_Users]    Script Date: 8/30/2023 5:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[glb_Users](
	[UserID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[UserPoints] [int] NOT NULL,
	[PostDate] [date] NULL,
 CONSTRAINT [PK_gbl_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[hip_HiveHeader]    Script Date: 8/30/2023 5:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[hip_HiveHeader](
	[HiveID] [bigint] NOT NULL,
	[UserID] [bigint] NOT NULL,
	[HiveCode] [varchar](10) NULL,
	[AddressID] [bigint] NULL,
	[Supers_Cnt] [int] NOT NULL,
	[Frames] [int] NOT NULL,
	[QType] [nchar](10) NULL,
	[QDOB] [date] NULL,
	[QClipped] [bit] NULL,
	[QMarked] [bit] NULL,
	[Notes] [nvarchar](max) NULL,
	[PostDate] [date] NULL,
	[Images] [varbinary](max) NULL,
 CONSTRAINT [PK_HiveDatadetails] PRIMARY KEY CLUSTERED 
(
	[HiveID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[hip_HiveHealth]    Script Date: 8/30/2023 5:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[hip_HiveHealth](
	[HiveHealthID] [bigint] NOT NULL,
	[HiveInspectionID] [bigint] NOT NULL,
	[Date] [date] NOT NULL,
	[Irregularity] [int] NULL,
	[Seriousness] [int] NULL,
	[Notes] [varchar](max) NULL,
 CONSTRAINT [PK_hip_HiveHealth] PRIMARY KEY CLUSTERED 
(
	[HiveHealthID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[hip_HiveInspectionDetail]    Script Date: 8/30/2023 5:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[hip_HiveInspectionDetail](
	[InspectionID] [bigint] NOT NULL,
	[HiveID] [bigint] NULL,
	[InspDate] [date] NULL,
	[InspTime] [time](7) NULL,
	[Condition] [varchar](10) NULL,
	[Temperament] [varchar](10) NULL,
	[Population] [varchar](10) NULL,
	[FCnt_Honey] [int] NULL,
	[FCnt_Brood] [int] NULL,
	[FCnt_Pollen] [int] NULL,
	[FCnt_Empty] [int] NULL,
	[FCnt_Drone] [int] NULL,
	[FCon_Honey] [bigint] NULL,
	[FCon_Brood] [bigint] NULL,
	[FCon_BroodPattern] [bigint] NULL,
	[FCon_Eggs] [bigint] NULL,
	[FCon_Pollen] [bigint] NULL,
	[FCon_Empty] [bigint] NULL,
	[FCon_Drone] [bigint] NULL,
	[Notes] [nvarchar](max) NULL,
 CONSTRAINT [PK_zhim_HiveInspectionDetail] PRIMARY KEY CLUSTERED 
(
	[InspectionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[hip_HiveInspectionNotes]    Script Date: 8/30/2023 5:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[hip_HiveInspectionNotes](
	[HiveInspectionNoteID] [bigint] NOT NULL,
	[HiveInspectionID] [bigint] NOT NULL,
	[Images] [varbinary](max) NULL,
	[Notes] [varbinary](max) NOT NULL,
 CONSTRAINT [PK_hip_HiveInspectionNotes] PRIMARY KEY CLUSTERED 
(
	[HiveInspectionNoteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[hip_Users]    Script Date: 8/30/2023 5:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[hip_Users](
	[UserID] [bigint] NOT NULL,
	[UserType] [nvarchar](20) NOT NULL,
	[RegNo] [varchar](15) NOT NULL,
	[PostDate] [date] NULL,
 CONSTRAINT [PK_hip_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mms_Address]    Script Date: 8/30/2023 5:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mms_Address](
	[AddressID] [bigint] NOT NULL,
	[UserID] [bigint] NOT NULL,
	[AddressType] [varchar](5) NOT NULL,
	[Address1] [varchar](50) NULL,
	[Address2] [varchar](50) NULL,
	[Address3] [varchar](50) NULL,
	[City] [varchar](25) NOT NULL,
	[PostCode] [varchar](5) NOT NULL,
	[RegionalCouncil] [varchar](25) NULL,
	[State] [varchar](5) NOT NULL,
	[Country] [bigint] NULL,
	[PostDate] [date] NOT NULL,
 CONSTRAINT [PK_Table_1_1] PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mms_Contact]    Script Date: 8/30/2023 5:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mms_Contact](
	[ContactID] [bigint] IDENTITY(1,5) NOT NULL,
	[UserID] [bigint] NOT NULL,
	[ContactType] [varchar](10) NOT NULL,
	[ContactDetail] [varchar](50) NULL,
	[Notes] [varchar](max) NULL,
 CONSTRAINT [PK_mms_Contacts] PRIMARY KEY CLUSTERED 
(
	[ContactID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mms_Setup]    Script Date: 8/30/2023 5:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mms_Setup](
	[SetupID] [bigint] NOT NULL,
	[NoticeBrdDays] [int] NOT NULL,
 CONSTRAINT [PK_ums_Setup] PRIMARY KEY CLUSTERED 
(
	[SetupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[msb_Skills]    Script Date: 8/30/2023 5:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[msb_Skills](
	[SkillsID] [bigint] IDENTITY(10000,1) NOT NULL,
	[Industry] [nvarchar](50) NULL,
	[Domain] [nvarchar](50) NULL,
	[Dmn_Attribute] [nvarchar](100) NULL,
	[Skill] [nvarchar](100) NULL,
 CONSTRAINT [PK_oms_Skills] PRIMARY KEY CLUSTERED 
(
	[SkillsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[msb_SkillsRelationship]    Script Date: 8/30/2023 5:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[msb_SkillsRelationship](
	[MemberID] [bigint] NOT NULL,
	[SkillID] [bigint] NOT NULL,
	[Level] [smallint] NULL,
 CONSTRAINT [PK_msb_SkillsRelationship] PRIMARY KEY CLUSTERED 
(
	[MemberID] ASC,
	[SkillID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[qbm_QRelationship]    Script Date: 8/30/2023 5:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[qbm_QRelationship](
	[QuestionaireRelationshipID] [bigint] IDENTITY(10,1) NOT NULL,
	[QuestionaireID] [bigint] NOT NULL,
	[QuestionaireDetailID] [bigint] NOT NULL,
	[QuestionaireResponseID] [bigint] NULL,
	[MemberID] [bigint] NOT NULL,
	[Notes] [varchar](max) NULL,
 CONSTRAINT [PK_qbm_QRelationship] PRIMARY KEY CLUSTERED 
(
	[QuestionaireRelationshipID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[qbm_QuestionaireDetails]    Script Date: 8/30/2023 5:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[qbm_QuestionaireDetails](
	[QuestionaireDetailID] [bigint] IDENTITY(10,1) NOT NULL,
	[QuestionaireID] [bigint] NOT NULL,
	[QuestionNumber] [varchar](10) NULL,
	[QuestionDataType] [varchar](3) NULL,
	[Question] [varchar](max) NULL,
	[Weighting] [int] NULL,
	[Notes] [varchar](max) NULL,
	[PostDate] [date] NULL,
 CONSTRAINT [PK_qbm_QuestionaireDetails] PRIMARY KEY CLUSTERED 
(
	[QuestionaireDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[qbm_QuestionaireResponse]    Script Date: 8/30/2023 5:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[qbm_QuestionaireResponse](
	[QuestionaireResponseID] [bigint] IDENTITY(10,1) NOT NULL,
	[QuestionaireDetailID] [bigint] NOT NULL,
	[ResponseNumber] [varchar](10) NOT NULL,
	[ResponseDataType] [varchar](5) NOT NULL,
	[Response] [varchar](max) NOT NULL,
	[Notes] [varchar](max) NULL,
	[PostDate] [date] NOT NULL,
 CONSTRAINT [PK_qbm_QuestionaireResponse] PRIMARY KEY CLUSTERED 
(
	[QuestionaireResponseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[qbm_QuestionHeader]    Script Date: 8/30/2023 5:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[qbm_QuestionHeader](
	[QuestionaireHeadID] [bigint] IDENTITY(10,1) NOT NULL,
	[QuestionaireTitle] [varchar](100) NULL,
	[QuestionaireNotes] [varchar](max) NULL,
	[QuestionaireStatus] [varchar](10) NULL,
	[Notes] [varchar](max) NULL,
	[PostDate] [date] NULL,
 CONSTRAINT [PK_qbm_QuestionHeader] PRIMARY KEY CLUSTERED 
(
	[QuestionaireHeadID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[qbm_Setup]    Script Date: 8/30/2023 5:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[qbm_Setup](
	[SetupID] [bigint] IDENTITY(10,1) NOT NULL,
	[TabID] [nchar](10) NULL,
	[Visible] [bit] NULL,
	[Notes] [varchar](max) NULL,
	[PostDate] [nchar](10) NULL,
 CONSTRAINT [PK_qbm_Setup] PRIMARY KEY CLUSTERED 
(
	[SetupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [IX_oms_Lookups]    Script Date: 8/30/2023 5:25:38 PM ******/
CREATE NONCLUSTERED INDEX [IX_oms_Lookups] ON [dbo].[glb_Lookups]
(
	[LookupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_oms_Relationship]    Script Date: 8/30/2023 5:25:38 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_oms_Relationship] ON [dbo].[mms_Relationship]
(
	[MemberNo_Parent] ASC,
	[MemberNo_Child] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[glb_SecMod] ADD  CONSTRAINT [DF_glb_ModSec_SecurityLevel]  DEFAULT ((1)) FOR [SecurityLevel]
GO
ALTER TABLE [dbo].[glb_SecUser] ADD  CONSTRAINT [DF_glb_UserSec_SecurityLevel]  DEFAULT ((1)) FOR [SecurityLevel]
GO
ALTER TABLE [dbo].[glb_Users] ADD  CONSTRAINT [DF_gbl_Users_UserPoints]  DEFAULT ((0)) FOR [UserPoints]
GO
ALTER TABLE [dbo].[hip_HiveHeader] ADD  CONSTRAINT [DF_HiveDatadetails_Super2Cnt]  DEFAULT ((0)) FOR [Frames]
GO
ALTER TABLE [dbo].[hip_HiveHeader] ADD  CONSTRAINT [DF_HiveDatadetails_QClipped]  DEFAULT ((0)) FOR [QClipped]
GO
ALTER TABLE [dbo].[hip_HiveHeader] ADD  CONSTRAINT [DF_HiveDatadetails_QMarked]  DEFAULT ((0)) FOR [QMarked]
GO
ALTER TABLE [dbo].[hip_Users] ADD  CONSTRAINT [DF_Table_1_Status_1]  DEFAULT ('Pend') FOR [RegNo]
GO
ALTER TABLE [dbo].[mms_Members] ADD  CONSTRAINT [DF_Table_1_Status]  DEFAULT ('Pend') FOR [Status]
GO
ALTER TABLE [dbo].[mms_Members] ADD  CONSTRAINT [DF_ums_Users_UserPoints]  DEFAULT ((0)) FOR [UserPoints]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[33] 4[20] 2[11] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "mms_Members_2"
            Begin Extent = 
               Top = 9
               Left = 9
               Bottom = 199
               Right = 179
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "mms_Relationship_1"
            Begin Extent = 
               Top = 9
               Left = 257
               Bottom = 212
               Right = 423
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "mms_Members_1"
            Begin Extent = 
               Top = 64
               Left = 5
               Bottom = 217
               Right = 175
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "mms_Relationship_2"
            Begin Extent = 
               Top = 64
               Left = 256
               Bottom = 214
               Right = 445
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "mms_Members_3"
            Begin Extent = 
               Top = 9
               Left = 514
               Bottom = 200
               Right = 684
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "mms_Relationship"
            Begin Extent = 
               Top = 6
               Left = 741
               Bottom = 205
               Right = 930
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "mms_Members"
            Begin Extent = 
               Top = 6
               Left = 968
               Bottom = 188
               Right = 1138
   ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vHierarchy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'         End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 20
         Width = 284
         Width = 1020
         Width = 1305
         Width = 1170
         Width = 1500
         Width = 1290
         Width = 1500
         Width = 1215
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1950
         Alias = 1815
         Table = 2280
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1395
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vHierarchy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vHierarchy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "mms_Relationship_1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 227
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "mms_Members"
            Begin Extent = 
               Top = 6
               Left = 265
               Bottom = 136
               Right = 435
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "mms_Relationship"
            Begin Extent = 
               Top = 6
               Left = 473
               Bottom = 136
               Right = 662
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "mms_Relationship_2"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 227
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "mms_Members_1"
            Begin Extent = 
               Top = 138
               Left = 265
               Bottom = 268
               Right = 435
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "mms_Members_3"
            Begin Extent = 
               Top = 138
               Left = 473
               Bottom = 268
               Right = 643
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "mms_Members_2"
            Begin Extent = 
               Top = 138
               Left = 681
               Bottom = 268
               Right = 8' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vRelationships'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'51
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 4065
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vRelationships'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vRelationships'
GO
USE [master]
GO
ALTER DATABASE [BeeAware] SET  READ_WRITE 
GO
