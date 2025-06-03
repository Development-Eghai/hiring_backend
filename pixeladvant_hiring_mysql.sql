-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jun 03, 2025 at 10:31 AM
-- Server version: 9.1.0
-- PHP Version: 8.3.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pixeladvant_hiring`
--

-- --------------------------------------------------------

--
-- Table structure for table `applications`
--

DROP TABLE IF EXISTS `applications`;
CREATE TABLE IF NOT EXISTS `applications` (
  `ApplicationID` int NOT NULL AUTO_INCREMENT,
  `CandidateID` int NOT NULL,
  `RequisitionID` int NOT NULL,
  `Status` enum('Applied','Screened','Interview Scheduled','Selected','Rejected') DEFAULT 'Applied',
  `SubmittedDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ApplicationID`),
  KEY `CandidateID` (`CandidateID`),
  KEY `RequisitionID` (`RequisitionID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE IF NOT EXISTS `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE IF NOT EXISTS `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissions_group_id_b120cbf9` (`group_id`),
  KEY `auth_group_permissions_permission_id_84c5c92e` (`permission_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE IF NOT EXISTS `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  KEY `auth_permission_content_type_id_2f476e4b` (`content_type_id`)
) ENGINE=MyISAM AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add user', 4, 'add_user'),
(14, 'Can change user', 4, 'change_user'),
(15, 'Can delete user', 4, 'delete_user'),
(16, 'Can view user', 4, 'view_user'),
(17, 'Can add content type', 5, 'add_contenttype'),
(18, 'Can change content type', 5, 'change_contenttype'),
(19, 'Can delete content type', 5, 'delete_contenttype'),
(20, 'Can view content type', 5, 'view_contenttype'),
(21, 'Can add session', 6, 'add_session'),
(22, 'Can change session', 6, 'change_session'),
(23, 'Can delete session', 6, 'delete_session'),
(24, 'Can view session', 6, 'view_session'),
(25, 'Can add candidates', 7, 'add_candidates'),
(26, 'Can change candidates', 7, 'change_candidates'),
(27, 'Can delete candidates', 7, 'delete_candidates'),
(28, 'Can view candidates', 7, 'view_candidates'),
(29, 'Can add user details', 8, 'add_userdetails'),
(30, 'Can change user details', 8, 'change_userdetails'),
(31, 'Can delete user details', 8, 'delete_userdetails'),
(32, 'Can view user details', 8, 'view_userdetails'),
(33, 'Can add userrole details', 9, 'add_userroledetails'),
(34, 'Can change userrole details', 9, 'change_userroledetails'),
(35, 'Can delete userrole details', 9, 'delete_userroledetails'),
(36, 'Can view userrole details', 9, 'view_userroledetails'),
(37, 'Can add job requisition', 10, 'add_jobrequisition'),
(38, 'Can change job requisition', 10, 'change_jobrequisition'),
(39, 'Can delete job requisition', 10, 'delete_jobrequisition'),
(40, 'Can view job requisition', 10, 'view_jobrequisition'),
(41, 'Can add posting', 11, 'add_posting'),
(42, 'Can change posting', 11, 'change_posting'),
(43, 'Can delete posting', 11, 'delete_posting'),
(44, 'Can view posting', 11, 'view_posting'),
(45, 'Can add job requisition extra details', 12, 'add_jobrequisitionextradetails'),
(46, 'Can change job requisition extra details', 12, 'change_jobrequisitionextradetails'),
(47, 'Can delete job requisition extra details', 12, 'delete_jobrequisitionextradetails'),
(48, 'Can view job requisition extra details', 12, 'view_jobrequisitionextradetails');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
CREATE TABLE IF NOT EXISTS `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
CREATE TABLE IF NOT EXISTS `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_user_id_6a12ed8b` (`user_id`),
  KEY `auth_user_groups_group_id_97559544` (`group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
CREATE TABLE IF NOT EXISTS `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permissions_user_id_a95ead1b` (`user_id`),
  KEY `auth_user_user_permissions_permission_id_1fbb5f2c` (`permission_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `billingdetails`
--

DROP TABLE IF EXISTS `billingdetails`;
CREATE TABLE IF NOT EXISTS `billingdetails` (
  `id` int NOT NULL AUTO_INCREMENT,
  `RequisitionID` int NOT NULL,
  `BillingType` varchar(50) DEFAULT NULL,
  `BillingStartDate` date DEFAULT NULL,
  `Created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_billing_requisition` (`RequisitionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `candidates`
--

DROP TABLE IF EXISTS `candidates`;
CREATE TABLE IF NOT EXISTS `candidates` (
  `CandidateID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(191) NOT NULL,
  `Email` varchar(191) NOT NULL,
  `Resume` text,
  `ProfileCreated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`CandidateID`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `candidates`
--

INSERT INTO `candidates` (`CandidateID`, `Name`, `Email`, `Resume`, `ProfileCreated`) VALUES
(9, 'Anand', 'anand040593@gmail.com', 'resumes/Resume.pdf', '2025-06-01 09:54:08'),
(8, 'Anand', 'anand040593@gmail.com', 'resumes/Anand-Resume_U5MEVSC.pdf', '2025-06-01 09:53:10');

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE IF NOT EXISTS `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint UNSIGNED NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6` (`user_id`)
) ;

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE IF NOT EXISTS `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(2, 'auth', 'permission'),
(3, 'auth', 'group'),
(4, 'auth', 'user'),
(5, 'contenttypes', 'contenttype'),
(6, 'sessions', 'session'),
(7, 'myapp', 'candidates'),
(8, 'myapp', 'userdetails'),
(9, 'myapp', 'userroledetails'),
(10, 'myapp', 'jobrequisition'),
(11, 'myapp', 'posting'),
(12, 'myapp', 'jobrequisitionextradetails');

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE IF NOT EXISTS `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2025-05-26 05:30:04.707766'),
(2, 'auth', '0001_initial', '2025-05-26 05:30:05.206388'),
(3, 'admin', '0001_initial', '2025-05-26 05:30:05.395228'),
(4, 'admin', '0002_logentry_remove_auto_add', '2025-05-26 05:30:05.403536'),
(5, 'admin', '0003_logentry_add_action_flag_choices', '2025-05-26 05:30:05.412651'),
(6, 'contenttypes', '0002_remove_content_type_name', '2025-05-26 05:30:05.484701'),
(7, 'auth', '0002_alter_permission_name_max_length', '2025-05-26 05:30:05.523143'),
(8, 'auth', '0003_alter_user_email_max_length', '2025-05-26 05:30:05.555431'),
(9, 'auth', '0004_alter_user_username_opts', '2025-05-26 05:30:05.562959'),
(10, 'auth', '0005_alter_user_last_login_null', '2025-05-26 05:30:05.599466'),
(11, 'auth', '0006_require_contenttypes_0002', '2025-05-26 05:30:05.602692'),
(12, 'auth', '0007_alter_validators_add_error_messages', '2025-05-26 05:30:05.607571'),
(13, 'auth', '0008_alter_user_username_max_length', '2025-05-26 05:30:05.643469'),
(14, 'auth', '0009_alter_user_last_name_max_length', '2025-05-26 05:30:05.674665'),
(15, 'auth', '0010_alter_group_name_max_length', '2025-05-26 05:30:05.710646'),
(16, 'auth', '0011_update_proxy_permissions', '2025-05-26 05:30:05.717704'),
(17, 'auth', '0012_alter_user_first_name_max_length', '2025-05-26 05:30:05.750223'),
(18, 'myapp', '0001_initial', '2025-05-26 05:30:05.753447'),
(19, 'myapp', '0002_userroledetails', '2025-05-26 05:30:05.754993'),
(20, 'sessions', '0001_initial', '2025-05-26 05:30:05.788015'),
(21, 'myapp', '0003_jobrequisition', '2025-05-26 07:30:50.947302'),
(22, 'myapp', '0004_posting_jobrequisition_no_of_positions_and_more', '2025-06-01 05:38:34.318535');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
CREATE TABLE IF NOT EXISTS `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('xdcx6oeso5rhsejbpx4g83hgh0s8s0wh', 'eyJyb2xlX25hbWUiOiJSZWNydWl0ZXIiLCJVc2VySUQiOjJ9:1uLkW9:smy0CjpUf40LRUnTCW0dXjoBm_gZw0YaNy8-so7rxTo', '2025-06-15 15:22:33.315001');

-- --------------------------------------------------------

--
-- Table structure for table `interview`
--

DROP TABLE IF EXISTS `interview`;
CREATE TABLE IF NOT EXISTS `interview` (
  `InterviewID` int NOT NULL AUTO_INCREMENT,
  `ApplicationID` int NOT NULL,
  `InterviewerID` int NOT NULL,
  `InterviewDate` date DEFAULT NULL,
  `Feedback` text,
  `Rating` int DEFAULT NULL,
  PRIMARY KEY (`InterviewID`),
  KEY `ApplicationID` (`ApplicationID`),
  KEY `InterviewerID` (`InterviewerID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobposting`
--

DROP TABLE IF EXISTS `jobposting`;
CREATE TABLE IF NOT EXISTS `jobposting` (
  `PostingID` int NOT NULL AUTO_INCREMENT,
  `RequisitionID` int NOT NULL,
  `PostingType` enum('Intranet','External','Private') NOT NULL,
  `PostingStatus` enum('Pending','Posted','Closed') DEFAULT 'Pending',
  `StartDate` date DEFAULT NULL,
  `EndDate` date DEFAULT NULL,
  `Created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`PostingID`),
  KEY `RequisitionID` (`RequisitionID`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobpostingdetails`
--

DROP TABLE IF EXISTS `jobpostingdetails`;
CREATE TABLE IF NOT EXISTS `jobpostingdetails` (
  `id` int NOT NULL AUTO_INCREMENT,
  `RequisitionID` int NOT NULL,
  `Experience` varchar(50) DEFAULT NULL,
  `Qualifications` varchar(255) DEFAULT NULL,
  `Designation` varchar(255) DEFAULT NULL,
  `Job_header` text,
  `Job_footer` text,
  `JobCategory` varchar(255) DEFAULT NULL,
  `JobRegion` varchar(255) DEFAULT NULL,
  `Description` text,
  `Created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_posting_requisition` (`RequisitionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobrequisition`
--

DROP TABLE IF EXISTS `jobrequisition`;
CREATE TABLE IF NOT EXISTS `jobrequisition` (
  `RequisitionID` int NOT NULL AUTO_INCREMENT,
  `PositionTitle` varchar(191) NOT NULL,
  `HiringManagerID` int NOT NULL,
  `recruiter` varchar(191) NOT NULL,
  `No_of_positions` int NOT NULL,
  `Status` enum('Draft','Pending Approval','Approved','Posted','Closed') DEFAULT 'Draft',
  `CreatedDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`RequisitionID`),
  KEY `HiringManagerID` (`HiringManagerID`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `jobrequisition`
--

INSERT INTO `jobrequisition` (`RequisitionID`, `PositionTitle`, `HiringManagerID`, `recruiter`, `No_of_positions`, `Status`, `CreatedDate`) VALUES
(34, 'Software Engineer', 1, 'PixelREQ', 3, 'Approved', '2025-06-01 09:49:48');

-- --------------------------------------------------------

--
-- Table structure for table `jobrequisitionextradetails`
--

DROP TABLE IF EXISTS `jobrequisitionextradetails`;
CREATE TABLE IF NOT EXISTS `jobrequisitionextradetails` (
  `id` int NOT NULL AUTO_INCREMENT,
  `RequisitionID` int NOT NULL,
  `LegalEntity` varchar(255) DEFAULT NULL,
  `PrimaryLocation` varchar(255) DEFAULT NULL,
  `Geo_zone` varchar(255) DEFAULT NULL,
  `EmployeeGroup` varchar(255) DEFAULT NULL,
  `EmployeeSubGroup` varchar(255) DEFAULT NULL,
  `BussinessLine` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `BussinessUnit` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `Division` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `Department` varchar(100) DEFAULT NULL,
  `RequisitionType` varchar(50) DEFAULT NULL,
  `CareerLevel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `Is_contract` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'no',
  `Start_date` date DEFAULT NULL,
  `End_date` date DEFAULT NULL,
  `Band` varchar(50) DEFAULT NULL,
  `SubBand` varchar(50) DEFAULT NULL,
  `Client_interview` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'no',
  `Secondary_skill` text,
  `ModeOfWorking` varchar(50) DEFAULT NULL,
  `Skills` text,
  `Created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_requisition` (`RequisitionID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `jobrequisitionextradetails`
--

INSERT INTO `jobrequisitionextradetails` (`id`, `RequisitionID`, `LegalEntity`, `PrimaryLocation`, `Geo_zone`, `EmployeeGroup`, `EmployeeSubGroup`, `BussinessLine`, `BussinessUnit`, `Division`, `Department`, `RequisitionType`, `CareerLevel`, `Is_contract`, `Start_date`, `End_date`, `Band`, `SubBand`, `Client_interview`, `Secondary_skill`, `ModeOfWorking`, `Skills`, `Created_at`) VALUES
(8, 34, 'ABC Corp', 'New York, USA', 'North America', 'Technology', 'Engineering', 'Software Development', 'Product Engineering', 'Web Applications', 'R&D', 'Full-Time', 'Mid-Level', '0', '2025-06-01', '2025-12-31', 'B3', 'Technical Lead', '0', 'Python, SQL', 'Hybrid', 'React, Node.js', '2025-06-01 15:19:48');

-- --------------------------------------------------------

--
-- Table structure for table `job_request`
--

DROP TABLE IF EXISTS `job_request`;
CREATE TABLE IF NOT EXISTS `job_request` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `RequisitionID` int NOT NULL,
  `job_description` varchar(500) NOT NULL DEFAULT '',
  `no_of_jobs` int NOT NULL,
  `salary_from` varchar(10) NOT NULL,
  `salary_to` varchar(10) NOT NULL,
  `interview_rounds` int NOT NULL,
  `recruiters` int NOT NULL,
  `dead_line` varchar(100) NOT NULL DEFAULT '',
  `progress_status` int NOT NULL,
  `updt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fk_req` (`RequisitionID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_request_interview_rounds`
--

DROP TABLE IF EXISTS `job_request_interview_rounds`;
CREATE TABLE IF NOT EXISTS `job_request_interview_rounds` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `RequisitionID` int NOT NULL,
  `round_name` varchar(500) NOT NULL,
  `updt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_req_id` (`RequisitionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_request_skills`
--

DROP TABLE IF EXISTS `job_request_skills`;
CREATE TABLE IF NOT EXISTS `job_request_skills` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `RequisitionID` int NOT NULL,
  `skills` varchar(500) NOT NULL,
  `updt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_req_skill` (`RequisitionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `offerletter`
--

DROP TABLE IF EXISTS `offerletter`;
CREATE TABLE IF NOT EXISTS `offerletter` (
  `OfferID` int NOT NULL AUTO_INCREMENT,
  `CandidateID` int NOT NULL,
  `RequisitionID` int NOT NULL,
  `SalaryDetails` text NOT NULL,
  `OfferStatus` enum('Draft','Sent','Accepted','Rejected') DEFAULT 'Draft',
  `IssuedDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`OfferID`),
  KEY `CandidateID` (`CandidateID`),
  KEY `RequisitionID` (`RequisitionID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `userrole`
--

DROP TABLE IF EXISTS `userrole`;
CREATE TABLE IF NOT EXISTS `userrole` (
  `RoleID` int NOT NULL AUTO_INCREMENT,
  `RoleName` enum('Hiring Manager','Recruiter','Business Ops','Candidate') NOT NULL,
  PRIMARY KEY (`RoleID`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `userrole`
--

INSERT INTO `userrole` (`RoleID`, `RoleName`) VALUES
(1, 'Hiring Manager'),
(2, 'Recruiter'),
(3, 'Business Ops'),
(4, 'Candidate');

-- --------------------------------------------------------

--
-- Table structure for table `users_details`
--

DROP TABLE IF EXISTS `users_details`;
CREATE TABLE IF NOT EXISTS `users_details` (
  `UserID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(191) NOT NULL,
  `RoleID` int NOT NULL,
  `Email` varchar(191) NOT NULL,
  `PasswordHash` varchar(255) NOT NULL,
  `Created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `Email` (`Email`),
  KEY `RoleID` (`RoleID`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users_details`
--

INSERT INTO `users_details` (`UserID`, `Name`, `RoleID`, `Email`, `PasswordHash`, `Created_at`) VALUES
(1, 'PixelHR', 1, 'pixelhr@gmail.com', 'Admin@123', '2025-05-26 05:10:52'),
(2, 'PixelREQ', 2, 'pixelreq@gmail.com', 'Admin@123', '2025-05-26 05:10:52'),
(3, 'PixelBO', 3, 'pixelbo@gmail.com', 'Admin@123', '2025-05-26 05:10:52'),
(4, 'PixelCan', 4, 'pixelcan@gmail.com', 'Admin@123', '2025-05-26 05:10:52');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `billingdetails`
--
ALTER TABLE `billingdetails`
  ADD CONSTRAINT `fk_billing_requisition` FOREIGN KEY (`RequisitionID`) REFERENCES `jobrequisition` (`RequisitionID`) ON DELETE CASCADE;

--
-- Constraints for table `jobpostingdetails`
--
ALTER TABLE `jobpostingdetails`
  ADD CONSTRAINT `fk_posting_requisition` FOREIGN KEY (`RequisitionID`) REFERENCES `jobrequisition` (`RequisitionID`) ON DELETE CASCADE;

--
-- Constraints for table `jobrequisitionextradetails`
--
ALTER TABLE `jobrequisitionextradetails`
  ADD CONSTRAINT `fk_req_extra` FOREIGN KEY (`RequisitionID`) REFERENCES `jobrequisition` (`RequisitionID`) ON DELETE CASCADE;

--
-- Constraints for table `job_request`
--
ALTER TABLE `job_request`
  ADD CONSTRAINT `fk_req` FOREIGN KEY (`RequisitionID`) REFERENCES `jobrequisition` (`RequisitionID`) ON DELETE CASCADE ON UPDATE RESTRICT;

--
-- Constraints for table `job_request_interview_rounds`
--
ALTER TABLE `job_request_interview_rounds`
  ADD CONSTRAINT `fk_req_id` FOREIGN KEY (`RequisitionID`) REFERENCES `jobrequisition` (`RequisitionID`) ON DELETE CASCADE ON UPDATE RESTRICT;

--
-- Constraints for table `job_request_skills`
--
ALTER TABLE `job_request_skills`
  ADD CONSTRAINT `fk_req_skill` FOREIGN KEY (`RequisitionID`) REFERENCES `jobrequisition` (`RequisitionID`) ON DELETE RESTRICT ON UPDATE RESTRICT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
