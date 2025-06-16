-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jun 16, 2025 at 12:40 PM
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
-- Table structure for table `asset_details`
--

DROP TABLE IF EXISTS `asset_details`;
CREATE TABLE IF NOT EXISTS `asset_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `requisition_id` int NOT NULL,
  `laptop_needed` tinyint(1) DEFAULT '0',
  `laptop_type` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `requisition_id` (`requisition_id`)
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
) ENGINE=MyISAM AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
(48, 'Can view job requisition extra details', 12, 'view_jobrequisitionextradetails'),
(49, 'Can add billing details', 13, 'add_billingdetails'),
(50, 'Can change billing details', 13, 'change_billingdetails'),
(51, 'Can delete billing details', 13, 'delete_billingdetails'),
(52, 'Can view billing details', 13, 'view_billingdetails'),
(53, 'Can add interview team', 14, 'add_interviewteam'),
(54, 'Can change interview team', 14, 'change_interviewteam'),
(55, 'Can delete interview team', 14, 'delete_interviewteam'),
(56, 'Can view interview team', 14, 'view_interviewteam'),
(57, 'Can add posting details', 15, 'add_postingdetails'),
(58, 'Can change posting details', 15, 'change_postingdetails'),
(59, 'Can delete posting details', 15, 'delete_postingdetails'),
(60, 'Can view posting details', 15, 'view_postingdetails'),
(61, 'Can add requisition details', 16, 'add_requisitiondetails'),
(62, 'Can change requisition details', 16, 'change_requisitiondetails'),
(63, 'Can delete requisition details', 16, 'delete_requisitiondetails'),
(64, 'Can view requisition details', 16, 'view_requisitiondetails'),
(65, 'Can add teams', 17, 'add_teams'),
(66, 'Can change teams', 17, 'change_teams'),
(67, 'Can delete teams', 17, 'delete_teams'),
(68, 'Can view teams', 17, 'view_teams');

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
-- Table structure for table `billing_details`
--

DROP TABLE IF EXISTS `billing_details`;
CREATE TABLE IF NOT EXISTS `billing_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `requisition_id` int NOT NULL,
  `billing_type` varchar(50) DEFAULT NULL,
  `billing_start_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `requisition_id` (`requisition_id`)
) ENGINE=MyISAM AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `billing_details`
--

INSERT INTO `billing_details` (`id`, `requisition_id`, `billing_type`, `billing_start_date`, `created_at`, `updated_at`) VALUES
(5, 21, 'Billable', '2025-06-05', '2025-06-06 05:19:23', '2025-06-06 05:19:23'),
(4, 20, 'Billable', '2025-06-05', '2025-06-06 05:18:15', '2025-06-06 05:18:15'),
(6, 22, 'Billable', '2025-06-05', '2025-06-06 06:05:00', '2025-06-06 06:05:00'),
(7, 23, 'Billable', '2025-06-05', '2025-06-06 06:10:25', '2025-06-06 06:10:25'),
(8, 24, 'Billable', '2025-06-05', '2025-06-06 06:16:38', '2025-06-06 06:16:38'),
(9, 25, 'Billable', '2025-06-05', '2025-06-06 06:29:16', '2025-06-06 06:29:16'),
(10, 26, 'Billable', '2025-06-05', '2025-06-07 00:52:13', '2025-06-07 00:52:13'),
(11, 27, 'Billable', '2025-06-05', '2025-06-07 00:53:20', '2025-06-07 00:53:20'),
(12, 28, 'Billable', '2025-06-05', '2025-06-07 00:56:26', '2025-06-07 00:56:26'),
(13, 29, 'Billable', '2025-06-05', '2025-06-07 00:58:16', '2025-06-07 00:58:16'),
(14, 30, 'Billable', '2025-06-05', '2025-06-07 00:58:29', '2025-06-07 00:58:29'),
(15, 31, 'Billable', '2025-06-05', '2025-06-07 00:59:09', '2025-06-07 00:59:09'),
(16, 32, 'Billable', '2025-06-05', '2025-06-07 01:00:14', '2025-06-07 01:00:14'),
(17, 33, 'Billable', '2025-06-05', '2025-06-07 09:37:40', '2025-06-07 09:37:40'),
(18, 34, 'Billable', '2025-06-05', '2025-06-08 01:28:16', '2025-06-08 01:28:16'),
(19, 35, 'Billable', '2025-06-05', '2025-06-08 01:59:40', '2025-06-08 01:59:40'),
(20, 36, 'Billable', '2025-06-05', '2025-06-12 03:16:45', '2025-06-12 03:16:45'),
(21, 37, 'Billable', '2025-06-05', '2025-06-12 03:16:55', '2025-06-12 03:16:55'),
(22, 38, 'Billable', '2025-06-05', '2025-06-12 03:21:20', '2025-06-12 03:21:20'),
(23, 39, 'Billable', '2025-06-05', '2025-06-12 03:23:47', '2025-06-12 03:23:47'),
(24, 40, 'Billable', '2025-06-05', '2025-06-12 04:29:38', '2025-06-12 04:29:38');

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
) ENGINE=MyISAM AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `candidates`
--

INSERT INTO `candidates` (`CandidateID`, `Name`, `Email`, `Resume`, `ProfileCreated`) VALUES
(96, 'NITIN BANSAL', 'nitinbansal1984@hotmail.com', 'media/resumes\\NITIN BANSAL - Resume (1).pdf', '2025-06-10 01:23:58'),
(97, 'Vinay Junghare', 'vinayjunghare@gmail.com', 'media/resumes\\Resume_Vinay_J.pdf', '2025-06-10 01:23:58'),
(98, 'Ritika Dogra', 'ritika_rati2@yahoo.co.in', 'media/resumes\\RitikaDogra_14Years.pdf', '2025-06-10 01:23:58'),
(99, 'TUSHAR BHATNAGAR', 'tusharbhatnagar13@gmail.com', 'media/resumes\\Tushar  Bhatnagar Resume.pdf', '2025-06-10 01:23:58'),
(100, 'PRIYANK SINHA', 'priyanksinha.007@gmail.com', 'media/resumes\\Priyank%20Sinha%20Resume%20May%202024.pdf', '2025-06-10 01:23:58');

-- --------------------------------------------------------

--
-- Table structure for table `competency`
--

DROP TABLE IF EXISTS `competency`;
CREATE TABLE IF NOT EXISTS `competency` (
  `id` int NOT NULL AUTO_INCREMENT,
  `requisition_id` int NOT NULL,
  `category` varchar(255) DEFAULT NULL,
  `expected_rating` int DEFAULT NULL,
  `weight` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `requisition_id` (`requisition_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
) ENGINE=MyISAM AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
(12, 'myapp', 'jobrequisitionextradetails'),
(13, 'myapp', 'billingdetails'),
(14, 'myapp', 'interviewteam'),
(15, 'myapp', 'postingdetails'),
(16, 'myapp', 'requisitiondetails'),
(17, 'myapp', 'teams');

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
('rwv83m8axcqjughixkhje6umpvetn77e', 'eyJyb2xlX25hbWUiOiJIaXJpbmcgTWFuYWdlciIsIlVzZXJJRCI6MX0:1uPZor:FUqaRhL0uOL1wftt7PLBRotMAYuXQLQpZvJGYJEGMaY', '2025-06-26 04:45:41.212096'),
('xdcx6oeso5rhsejbpx4g83hgh0s8s0wh', 'eyJyb2xlX25hbWUiOiJIaXJpbmcgTWFuYWdlciIsIlVzZXJJRCI6MX0:1uPZv0:GBm6uH63-bQgQ_lXSAH50frRIk9QNTtbF0UgMo8E0K8', '2025-06-26 04:52:02.921308');

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
-- Table structure for table `interview_team`
--

DROP TABLE IF EXISTS `interview_team`;
CREATE TABLE IF NOT EXISTS `interview_team` (
  `id` int NOT NULL AUTO_INCREMENT,
  `requisition_id` int NOT NULL,
  `employee_id` varchar(50) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `requisition_id` (`requisition_id`)
) ENGINE=MyISAM AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `interview_team`
--

INSERT INTO `interview_team` (`id`, `requisition_id`, `employee_id`, `name`, `created_at`, `updated_at`) VALUES
(3, 20, 'EMP001', 'Robert Smith', '2025-06-06 05:18:15', '2025-06-06 05:18:15'),
(4, 20, 'EMP002', 'Emily White', '2025-06-06 05:18:15', '2025-06-06 05:18:15'),
(5, 21, 'EMP001', 'Robert Smith', '2025-06-06 05:19:23', '2025-06-06 05:19:23'),
(6, 21, 'EMP002', 'Emily White', '2025-06-06 05:19:23', '2025-06-06 05:19:23'),
(7, 22, 'EMP001', 'Robert Smith', '2025-06-06 06:05:00', '2025-06-06 06:05:00'),
(8, 22, 'EMP002', 'Emily White', '2025-06-06 06:05:00', '2025-06-06 06:05:00'),
(9, 23, 'EMP001', 'Robert Smith', '2025-06-06 06:10:25', '2025-06-06 06:10:25'),
(10, 23, 'EMP002', 'Emily White', '2025-06-06 06:10:25', '2025-06-06 06:10:25'),
(11, 24, 'EMP001', 'Robert Smith', '2025-06-06 06:16:38', '2025-06-06 06:16:38'),
(12, 24, 'EMP002', 'Emily White', '2025-06-06 06:16:38', '2025-06-06 06:16:38'),
(13, 25, 'EMP001', 'Robert Smith', '2025-06-06 06:29:16', '2025-06-06 06:29:16'),
(14, 25, 'EMP002', 'Emily White', '2025-06-06 06:29:16', '2025-06-06 06:29:16'),
(15, 26, 'EMP001', 'Robert Smith', '2025-06-07 00:52:13', '2025-06-07 00:52:13'),
(16, 26, 'EMP002', 'Emily White', '2025-06-07 00:52:13', '2025-06-07 00:52:13'),
(17, 27, 'EMP001', 'Robert Smith', '2025-06-07 00:53:20', '2025-06-07 00:53:20'),
(18, 27, 'EMP002', 'Emily White', '2025-06-07 00:53:20', '2025-06-07 00:53:20'),
(19, 28, 'EMP001', 'Robert Smith', '2025-06-07 00:56:26', '2025-06-07 00:56:26'),
(20, 28, 'EMP002', 'Emily White', '2025-06-07 00:56:26', '2025-06-07 00:56:26'),
(21, 29, 'EMP001', 'Robert Smith', '2025-06-07 00:58:16', '2025-06-07 00:58:16'),
(22, 29, 'EMP002', 'Emily White', '2025-06-07 00:58:16', '2025-06-07 00:58:16'),
(23, 30, 'EMP001', 'Robert Smith', '2025-06-07 00:58:29', '2025-06-07 00:58:29'),
(24, 30, 'EMP002', 'Emily White', '2025-06-07 00:58:29', '2025-06-07 00:58:29'),
(25, 31, 'EMP001', 'Robert Smith', '2025-06-07 00:59:09', '2025-06-07 00:59:09'),
(26, 31, 'EMP002', 'Emily White', '2025-06-07 00:59:09', '2025-06-07 00:59:09'),
(27, 32, 'EMP001', 'Robert Smith', '2025-06-07 01:00:14', '2025-06-07 01:00:14'),
(28, 32, 'EMP002', 'Emily White', '2025-06-07 01:00:14', '2025-06-07 01:00:14'),
(29, 33, 'EMP001', 'Robert Smith', '2025-06-07 09:37:40', '2025-06-07 09:37:40'),
(30, 33, 'EMP002', 'Emily White', '2025-06-07 09:37:40', '2025-06-07 09:37:40'),
(31, 34, 'EMP001', 'Robert Smith', '2025-06-08 01:28:16', '2025-06-08 01:28:16'),
(32, 34, 'EMP002', 'Emily White', '2025-06-08 01:28:16', '2025-06-08 01:28:16'),
(33, 35, 'EMP001', 'Robert Smith', '2025-06-08 01:59:40', '2025-06-08 01:59:40'),
(34, 35, 'EMP002', 'Emily White', '2025-06-08 01:59:40', '2025-06-08 01:59:40'),
(35, 36, 'EMP001', 'Robert Smith', '2025-06-12 03:16:45', '2025-06-12 03:16:45'),
(36, 36, 'EMP002', 'Emily White', '2025-06-12 03:16:45', '2025-06-12 03:16:45'),
(37, 37, 'EMP001', 'Robert Smith', '2025-06-12 03:16:55', '2025-06-12 03:16:55'),
(38, 37, 'EMP002', 'Emily White', '2025-06-12 03:16:55', '2025-06-12 03:16:55'),
(39, 38, 'EMP001', 'Robert Smith', '2025-06-12 03:21:20', '2025-06-12 03:21:20'),
(40, 38, 'EMP002', 'Emily White', '2025-06-12 03:21:20', '2025-06-12 03:21:20'),
(41, 39, 'EMP001', 'Robert Smith', '2025-06-12 03:23:47', '2025-06-12 03:23:47'),
(42, 39, 'EMP002', 'Emily White', '2025-06-12 03:23:47', '2025-06-12 03:23:47'),
(43, 40, 'EMP001', 'Robert Smith', '2025-06-12 04:29:38', '2025-06-12 04:29:38'),
(44, 40, 'EMP002', 'Emily White', '2025-06-12 04:29:38', '2025-06-12 04:29:38');

-- --------------------------------------------------------

--
-- Table structure for table `jobrequisition`
--

DROP TABLE IF EXISTS `jobrequisition`;
CREATE TABLE IF NOT EXISTS `jobrequisition` (
  `RequisitionID` int NOT NULL AUTO_INCREMENT,
  `PositionTitle` varchar(191) NOT NULL,
  `HiringManagerID` int NOT NULL,
  `Recruiter` varchar(191) NOT NULL,
  `No_of_positions` int NOT NULL,
  `Status` enum('Draft','Pending Approval','Approved','Posted') DEFAULT 'Draft',
  `CreatedDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`RequisitionID`),
  KEY `fk_hiring_manager` (`HiringManagerID`)
) ENGINE=MyISAM AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `jobrequisition`
--

INSERT INTO `jobrequisition` (`RequisitionID`, `PositionTitle`, `HiringManagerID`, `Recruiter`, `No_of_positions`, `Status`, `CreatedDate`, `UpdatedDate`) VALUES
(30, 'Software Engineer1', 1, 'John Doe', 2, 'Approved', '2025-06-07 00:58:29', '2025-06-12 05:16:14'),
(29, 'Software Engineer1', 1, 'John Doe', 2, 'Approved', '2025-06-07 00:58:16', '2025-06-12 05:16:17'),
(28, 'Software Engineer1', 1, 'John Doe', 2, 'Approved', '2025-06-07 00:56:26', '2025-06-12 05:16:19'),
(27, 'Software Engineer1', 1, 'John Doe', 2, 'Pending Approval', '2025-06-07 00:53:20', '2025-06-12 05:16:22'),
(26, 'Software Engineer1', 1, 'John Doe', 2, 'Pending Approval', '2025-06-07 00:52:13', '2025-06-12 05:16:26'),
(25, 'Software Engineer1', 1, 'John Doe', 2, 'Pending Approval', '2025-06-06 06:29:16', '2025-06-12 09:45:49'),
(24, 'Software Engineer1', 1, 'John Doe', 2, 'Pending Approval', '2025-06-06 06:16:38', '2025-06-12 09:45:56'),
(23, 'Software Engineer1', 1, 'John Doe', 2, 'Pending Approval', '2025-06-06 06:10:25', '2025-06-12 09:45:59'),
(22, 'Software Engineer1', 1, 'John Doe', 2, 'Pending Approval', '2025-06-06 06:05:00', '2025-06-12 09:46:02'),
(21, 'Software Engineer1', 1, 'John Doe', 2, 'Approved', '2025-06-06 05:19:23', '2025-06-12 09:46:03'),
(20, 'Software Engineer', 1, 'John Doe', 2, 'Pending Approval', '2025-06-06 05:18:15', '2025-06-12 09:46:05'),
(31, 'Software Engineer1', 1, 'John Doe', 2, 'Pending Approval', '2025-06-07 00:59:09', '2025-06-12 09:46:08'),
(32, 'Software Engineer1', 1, 'John Doe', 2, 'Pending Approval', '2025-06-07 01:00:14', '2025-06-12 09:46:09'),
(33, 'Software Engineer1', 1, 'John Doe', 2, 'Pending Approval', '2025-06-07 09:37:40', '2025-06-12 09:46:11'),
(34, 'Software Engineer1', 1, 'John Doe', 2, 'Pending Approval', '2025-06-08 01:28:16', '2025-06-12 09:46:13'),
(35, 'Software Engineer1', 1, 'John Doe', 2, 'Pending Approval', '2025-06-08 01:59:40', '2025-06-12 09:46:15'),
(36, 'Software Engineer1', 1, 'John Doe', 2, 'Approved', '2025-06-12 03:16:45', '2025-06-12 03:18:30'),
(37, 'Software Engineer1', 1, 'John Doe', 2, 'Approved', '2025-06-12 03:16:55', '2025-06-12 03:18:24'),
(38, 'Software Engineer1', 1, 'John Doe', 2, 'Approved', '2025-06-12 03:21:20', '2025-06-12 03:21:29'),
(39, 'Software Engineer1', 1, 'John Doe', 2, 'Approved', '2025-06-12 03:23:47', '2025-06-12 03:23:57'),
(40, 'Software Engineer1', 1, 'John Doe', 2, 'Approved', '2025-06-12 04:29:38', '2025-06-12 04:33:02');

-- --------------------------------------------------------

--
-- Table structure for table `job_communication_skills`
--

DROP TABLE IF EXISTS `job_communication_skills`;
CREATE TABLE IF NOT EXISTS `job_communication_skills` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `requisition_id` bigint NOT NULL,
  `skill_name` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `skill_value` varchar(200) NOT NULL DEFAULT '',
  `updt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `job_communication_skills`
--

INSERT INTO `job_communication_skills` (`id`, `requisition_id`, `skill_name`, `skill_value`, `updt`) VALUES
(2, 1, 'Python', '5', '2025-06-16 12:31:42'),
(3, 1, 'Django', '4', '2025-06-16 12:31:42');

-- --------------------------------------------------------

--
-- Table structure for table `job_hiring_overview`
--

DROP TABLE IF EXISTS `job_hiring_overview`;
CREATE TABLE IF NOT EXISTS `job_hiring_overview` (
  `hiring_plan_id` bigint NOT NULL AUTO_INCREMENT,
  `job_position` varchar(500) NOT NULL DEFAULT '',
  `tech_stacks` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '',
  `jd_details` varchar(500) NOT NULL DEFAULT '',
  `designation` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '',
  `experience_range` varchar(500) NOT NULL DEFAULT '',
  `target_companies` varchar(500) NOT NULL,
  `compensation` varchar(500) NOT NULL,
  `working_model` varchar(50) NOT NULL DEFAULT '',
  `interview_status` varchar(500) NOT NULL,
  `location` varchar(500) NOT NULL,
  `education_decision` varchar(50) NOT NULL,
  `relocation` varchar(500) NOT NULL,
  `travel_opportunities` varchar(500) NOT NULL,
  `domain_knowledge` varchar(500) NOT NULL,
  `visa_requirements` varchar(500) NOT NULL,
  `background_verification` varchar(50) NOT NULL,
  `shift_timings` varchar(50) NOT NULL,
  `role_type` varchar(100) NOT NULL,
  `job_type` varchar(100) NOT NULL,
  `communication_language` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `notice_period` varchar(500) NOT NULL,
  `additional_comp` varchar(500) NOT NULL,
  `citizen_requirement` varchar(100) NOT NULL,
  `career_gap` varchar(50) NOT NULL,
  `sabbatical` varchar(50) NOT NULL,
  `screening_questions` text,
  `job_health_requirements` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `social_media_links` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `language_proficiency` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`hiring_plan_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `job_hiring_overview`
--

INSERT INTO `job_hiring_overview` (`hiring_plan_id`, `job_position`, `tech_stacks`, `jd_details`, `designation`, `experience_range`, `target_companies`, `compensation`, `working_model`, `interview_status`, `location`, `education_decision`, `relocation`, `travel_opportunities`, `domain_knowledge`, `visa_requirements`, `background_verification`, `shift_timings`, `role_type`, `job_type`, `communication_language`, `notice_period`, `additional_comp`, `citizen_requirement`, `career_gap`, `sabbatical`, `screening_questions`, `job_health_requirements`, `social_media_links`, `language_proficiency`) VALUES
(3, 'Software Engineer', 'Python, Django', 'Detailed job description here', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `job_request_interview_rounds`
--

DROP TABLE IF EXISTS `job_request_interview_rounds`;
CREATE TABLE IF NOT EXISTS `job_request_interview_rounds` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `requisition_id` varchar(100) NOT NULL DEFAULT '',
  `round_name` varchar(500) NOT NULL,
  `updt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `job_request_interview_rounds`
--

INSERT INTO `job_request_interview_rounds` (`id`, `requisition_id`, `round_name`, `updt`) VALUES
(9, '1', 'Technical', '2025-06-16 12:32:34'),
(10, '1', 'HR', '2025-06-16 12:32:34');

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
-- Table structure for table `posting_details`
--

DROP TABLE IF EXISTS `posting_details`;
CREATE TABLE IF NOT EXISTS `posting_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `requisition_id` int NOT NULL,
  `experience` varchar(255) DEFAULT NULL,
  `designation` varchar(255) DEFAULT NULL,
  `job_category` varchar(255) DEFAULT NULL,
  `job_region` varchar(255) DEFAULT NULL,
  `internal_job_description` text,
  `external_job_description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `requisition_id` (`requisition_id`)
) ENGINE=MyISAM AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `posting_details`
--

INSERT INTO `posting_details` (`id`, `requisition_id`, `experience`, `designation`, `job_category`, `job_region`, `internal_job_description`, `external_job_description`, `created_at`, `updated_at`) VALUES
(1, 19, '5+ years', 'Software Engineer I', 'Development', 'US', 'Backend development using Django.', 'Looking for an experienced Software Engineer proficient in Python and Django.', '2025-06-06 05:14:09', '2025-06-06 05:14:09'),
(2, 20, '5+ years', 'Software Engineer I', 'Development', 'US', 'Backend development using Django.', 'Looking for an experienced Software Engineer proficient in Python and Django.', '2025-06-06 05:18:15', '2025-06-06 05:18:15'),
(3, 21, '5+ years', 'Software Engineer I', 'Development', 'US', 'Backend development using Django.', 'Looking for an experienced Software Engineer proficient in Python and Django.', '2025-06-06 05:19:23', '2025-06-06 05:19:23'),
(4, 22, '5+ years', 'Software Engineer I', 'Development', 'US', 'Backend development using Django.', 'Looking for an experienced Software Engineer proficient in Python and Django.', '2025-06-06 06:05:00', '2025-06-06 06:05:00'),
(5, 23, '5+ years', 'Software Engineer I', 'Development', 'US', 'Backend development using Django.', 'Looking for an experienced Software Engineer proficient in Python and Django.', '2025-06-06 06:10:25', '2025-06-06 06:10:25'),
(6, 24, '5+ years', 'Software Engineer I', 'Development', 'US', 'Backend development using Django.', 'Looking for an experienced Software Engineer proficient in Python and Django.', '2025-06-06 06:16:38', '2025-06-06 06:16:38'),
(7, 25, '5+ years', 'Software Engineer I', 'Development', 'US', 'Backend development using Django.', 'Looking for an experienced Software Engineer proficient in Python and Django.', '2025-06-06 06:29:16', '2025-06-06 06:29:16'),
(8, 26, '5+ years', 'Software Engineer I', 'Development', 'US', 'Backend development using Django.', 'Looking for an experienced Software Engineer proficient in Python and Django.', '2025-06-07 00:52:13', '2025-06-07 00:52:13'),
(9, 27, '5+ years', 'Software Engineer I', 'Development', 'US', 'Backend development using Django.', 'Looking for an experienced Software Engineer proficient in Python and Django.', '2025-06-07 00:53:20', '2025-06-07 00:53:20'),
(10, 28, '5+ years', 'Software Engineer I', 'Development', 'US', 'Backend development using Django.', 'Looking for an experienced Software Engineer proficient in Python and Django.', '2025-06-07 00:56:26', '2025-06-07 00:56:26'),
(11, 29, '5+ years', 'Software Engineer I', 'Development', 'US', 'Backend development using Django.', 'Looking for an experienced Software Engineer proficient in Python and Django.', '2025-06-07 00:58:16', '2025-06-07 00:58:16'),
(12, 30, '5+ years', 'Software Engineer I', 'Development', 'US', 'Backend development using Django.', 'Looking for an experienced Software Engineer proficient in Python and Django.', '2025-06-07 00:58:29', '2025-06-07 00:58:29'),
(13, 31, '5+ years', 'Software Engineer I', 'Development', 'US', 'Backend development using Django.', 'Looking for an experienced Software Engineer proficient in Python and Django.', '2025-06-07 00:59:09', '2025-06-07 00:59:09'),
(14, 32, '5+ years', 'Software Engineer I', 'Development', 'US', 'Backend development using Django.', 'Looking for an experienced Software Engineer proficient in Python and Django.', '2025-06-07 01:00:14', '2025-06-07 01:00:14'),
(15, 33, '5+ years', 'Software Engineer I', 'Development', 'US', 'Backend development using Django.', 'Looking for an experienced Software Engineer proficient in Python and Django.', '2025-06-07 09:37:40', '2025-06-07 09:37:40'),
(16, 34, '5+ years', 'Software Engineer I', 'Development', 'US', 'Backend development using Django.', 'Looking for an experienced Software Engineer proficient in Python and Django.', '2025-06-08 01:28:16', '2025-06-08 01:28:16'),
(17, 35, '5+ years', 'Software Engineer I', 'Development', 'US', 'Backend development using Django.', 'Looking for an experienced Software Engineer proficient in Python and Django.', '2025-06-08 01:59:40', '2025-06-08 01:59:40'),
(18, 36, '5+ years', 'Software Engineer I', 'Development', 'US', 'Backend development using Django.', 'Looking for an experienced Software Engineer proficient in Python and Django.', '2025-06-12 03:16:45', '2025-06-12 03:16:45'),
(19, 37, '5+ years', 'Software Engineer I', 'Development', 'US', 'Backend development using Django.', 'Looking for an experienced Software Engineer proficient in Python and Django.', '2025-06-12 03:16:55', '2025-06-12 03:16:55'),
(20, 38, '5+ years', 'Software Engineer I', 'Development', 'US', 'Backend development using Django.', 'Looking for an experienced Software Engineer proficient in Python and Django.', '2025-06-12 03:21:20', '2025-06-12 03:21:20'),
(21, 39, '5+ years', 'Software Engineer I', 'Development', 'US', 'Backend development using Django.', 'Looking for an experienced Software Engineer proficient in Python and Django.', '2025-06-12 03:23:47', '2025-06-12 03:23:47'),
(22, 40, '5+ years', 'Software Engineer I', 'Development', 'US', 'Backend development using Django.', 'Looking for an experienced Software Engineer proficient in Python and Django.', '2025-06-12 04:29:38', '2025-06-12 04:29:38');

-- --------------------------------------------------------

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
CREATE TABLE IF NOT EXISTS `questions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `requisition_id` int NOT NULL,
  `question_text` text,
  `required` tinyint(1) DEFAULT '0',
  `disqualifier` tinyint(1) DEFAULT '0',
  `score` int DEFAULT NULL,
  `weight` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `requisition_id` (`requisition_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `requisition_details`
--

DROP TABLE IF EXISTS `requisition_details`;
CREATE TABLE IF NOT EXISTS `requisition_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `requisition_id` int NOT NULL,
  `internal_title` varchar(255) NOT NULL,
  `external_title` varchar(255) NOT NULL,
  `position` varchar(255) DEFAULT NULL,
  `business_line` varchar(255) DEFAULT NULL,
  `business_unit` varchar(255) DEFAULT NULL,
  `division` varchar(255) DEFAULT NULL,
  `department` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `geo_zone` varchar(255) DEFAULT NULL,
  `employee_group` varchar(255) DEFAULT NULL,
  `employee_sub_group` varchar(255) DEFAULT NULL,
  `contract_start_date` date DEFAULT NULL,
  `contract_end_date` date DEFAULT NULL,
  `career_level` varchar(50) DEFAULT NULL,
  `band` varchar(50) DEFAULT NULL,
  `sub_band` varchar(50) DEFAULT NULL,
  `primary_skills` text,
  `secondary_skills` text,
  `mode_of_working` varchar(50) DEFAULT NULL,
  `requisition_type` varchar(50) DEFAULT NULL,
  `client_interview` tinyint(1) DEFAULT '0',
  `required_score` int DEFAULT NULL,
  `onb_coordinator` varchar(255) DEFAULT NULL,
  `onb_coordinator_team` text,
  `isg_team` text,
  `interviewer_teammate_employee_id` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `requisition_id` (`requisition_id`)
) ENGINE=MyISAM AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `requisition_details`
--

INSERT INTO `requisition_details` (`id`, `requisition_id`, `internal_title`, `external_title`, `position`, `business_line`, `business_unit`, `division`, `department`, `location`, `geo_zone`, `employee_group`, `employee_sub_group`, `contract_start_date`, `contract_end_date`, `career_level`, `band`, `sub_band`, `primary_skills`, `secondary_skills`, `mode_of_working`, `requisition_type`, `client_interview`, `required_score`, `onb_coordinator`, `onb_coordinator_team`, `isg_team`, `interviewer_teammate_employee_id`, `created_at`, `updated_at`) VALUES
(17, 27, 'Senior Software Engineer1', 'Software Engineer1 I', 'Not Provided', 'General Business', 'General Unit', 'Unknown Division', 'Unknown Department', 'Not Provided', 'US-East', 'Software Engineers', 'Backend Developers', '2025-06-12', '2025-07-19', 'Senior', 'N/A', 'N/A', 'Python, Django, REST APIs', 'Docker, Kubernetes', 'Office', 'Permanent', 1, 85, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-06-07 00:53:20', '2025-06-12 05:06:34'),
(16, 26, 'Senior Software Engineer1', 'Software Engineer1 I', 'Not Provided', 'General Business', 'General Unit', 'Unknown Division', 'Unknown Department', 'Not Provided', 'US-East', 'Software Engineers', 'Backend Developers', NULL, NULL, 'Senior', 'N/A', 'N/A', 'Python, Django, REST APIs', 'Docker, Kubernetes', 'Office', 'Permanent', 1, 85, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-06-07 00:52:13', '2025-06-07 00:52:13'),
(15, 25, 'Senior Software Engineer1', 'Software Engineer1 I', 'Not Provided', 'General Business', 'General Unit', 'Unknown Division', 'Unknown Department', 'Not Provided', 'US-East', 'Software Engineers', 'Backend Developers', NULL, NULL, 'Senior', 'N/A', 'N/A', 'Python, Django, REST APIs', 'Docker, Kubernetes', 'Office', 'Permanent', 1, 85, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-06-06 06:29:16', '2025-06-06 06:29:16'),
(14, 24, 'Senior Software Engineer1', 'Software Engineer1 I', 'Not Provided', 'General Business', 'General Unit', 'Unknown Division', 'Unknown Department', 'Not Provided', 'US-East', 'Software Engineers', 'Backend Developers', NULL, NULL, 'Senior', 'N/A', 'N/A', 'Python, Django, REST APIs', 'Docker, Kubernetes', 'Office', 'Permanent', 1, 85, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-06-06 06:16:38', '2025-06-06 06:16:38'),
(13, 23, 'Senior Software Engineer1', 'Software Engineer1 I', 'Not Provided', 'General Business', 'General Unit', 'Unknown Division', 'Unknown Department', 'Not Provided', 'US-East', 'Software Engineers', 'Backend Developers', NULL, NULL, 'Senior', 'N/A', 'N/A', 'Python, Django, REST APIs', 'Docker, Kubernetes', 'Office', 'Permanent', 1, 85, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-06-06 06:10:25', '2025-06-06 06:10:25'),
(12, 22, 'Senior Software Engineer1', 'Software Engineer1 I', 'Not Provided', 'General Business', 'General Unit', 'Unknown Division', 'Unknown Department', 'Not Provided', 'US-East', 'Software Engineers', 'Backend Developers', NULL, NULL, 'Senior', 'N/A', 'N/A', 'Python, Django, REST APIs', 'Docker, Kubernetes', 'Office', 'Permanent', 1, 85, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-06-06 06:05:00', '2025-06-06 06:05:00'),
(11, 21, 'Senior Software Engineer1', 'Software Engineer1 I', 'Not Provided', 'General Business', 'General Unit', 'Unknown Division', 'Unknown Department', 'Not Provided', 'US-East', 'Software Engineers', 'Backend Developers', '2025-06-12', '2025-07-31', 'Senior', 'N/A', 'N/A', 'Python, Django, REST APIs', 'Docker, Kubernetes', 'Office', 'Permanent', 1, 85, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-06-06 05:19:23', '2025-06-12 06:23:34'),
(10, 20, 'Senior Software Engineer', 'Software Engineer I', 'Not Provided', 'General Business', 'General Unit', 'Unknown Division', 'Unknown Department', 'Not Provided', 'US-East', 'Software Engineers', 'Backend Developers', NULL, NULL, 'Senior', 'N/A', 'N/A', 'Python, Django, REST APIs', 'Docker, Kubernetes', 'Office', 'Permanent', 1, 85, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-06-06 05:18:15', '2025-06-06 05:18:15'),
(18, 28, 'Senior Software Engineer1', 'Software Engineer1 I', 'Not Provided', 'General Business', 'General Unit', 'Unknown Division', 'Unknown Department', 'Not Provided', 'US-East', 'Software Engineers', 'Backend Developers', '2025-06-12', '2025-07-31', 'Senior', 'N/A', 'N/A', 'Python, Django, REST APIs', 'Docker, Kubernetes', 'Office', 'Permanent', 1, 85, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-06-07 00:56:26', '2025-06-12 06:23:34'),
(19, 29, 'Senior Software Engineer1', 'Software Engineer1 I', 'Not Provided', 'General Business', 'General Unit', 'Unknown Division', 'Unknown Department', 'Not Provided', 'US-East', 'Software Engineers', 'Backend Developers', '2025-07-31', '2025-08-30', 'Senior', 'N/A', 'N/A', 'Python, Django, REST APIs', 'Docker, Kubernetes', 'Office', 'Permanent', 1, 85, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-06-07 00:58:16', '2025-06-12 06:23:34'),
(20, 30, 'Senior Software Engineer1', 'Software Engineer1 I', 'Not Provided', 'General Business', 'General Unit', 'Unknown Division', 'Unknown Department', 'Not Provided', 'US-East', 'Software Engineers', 'Backend Developers', '2025-06-12', '2025-07-31', 'Senior', 'N/A', 'N/A', 'Python, Django, REST APIs', 'Docker, Kubernetes', 'Office', 'Permanent', 1, 85, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-06-07 00:58:29', '2025-06-12 06:23:34'),
(21, 31, 'Senior Software Engineer1', 'Software Engineer1 I', 'Not Provided', 'General Business', 'General Unit', 'Unknown Division', 'Unknown Department', 'Not Provided', 'US-East', 'Software Engineers', 'Backend Developers', NULL, NULL, 'Senior', 'N/A', 'N/A', 'Python, Django, REST APIs', 'Docker, Kubernetes', 'Office', 'Permanent', 1, 85, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-06-07 00:59:09', '2025-06-07 00:59:09'),
(22, 32, 'Senior Software Engineer1', 'Software Engineer1 I', 'Not Provided', 'General Business', 'General Unit', 'Unknown Division', 'Unknown Department', 'Not Provided', 'US-East', 'Software Engineers', 'Backend Developers', NULL, NULL, 'Senior', 'N/A', 'N/A', 'Python, Django, REST APIs', 'Docker, Kubernetes', 'Office', 'Permanent', 1, 85, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-06-07 01:00:14', '2025-06-07 01:00:14'),
(23, 33, 'Senior Software Engineer1', 'Software Engineer1 I', 'Not Provided', 'General Business', 'General Unit', 'Unknown Division', 'Unknown Department', 'Not Provided', 'US-East', 'Software Engineers', 'Backend Developers', NULL, NULL, 'Senior', 'N/A', 'N/A', 'Python, Django, REST APIs', 'Docker, Kubernetes', 'Office', 'Permanent', 1, 85, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-06-07 09:37:40', '2025-06-07 09:37:40'),
(24, 34, 'Senior Software Engineer1', 'Software Engineer1 I', 'Not Provided', 'General Business', 'General Unit', 'Unknown Division', 'Unknown Department', 'Not Provided', 'US-East', 'Software Engineers', 'Backend Developers', NULL, NULL, 'Senior', 'N/A', 'N/A', 'Python, Django, REST APIs', 'Docker, Kubernetes', 'Office', 'Permanent', 1, 85, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-06-08 01:28:16', '2025-06-08 01:28:16'),
(25, 35, 'Senior Software Engineer1', 'Software Engineer1 I', 'Not Provided', 'General Business', 'General Unit', 'Unknown Division', 'Unknown Department', 'Not Provided', 'US-East', 'Software Engineers', 'Backend Developers', NULL, NULL, 'Senior', 'N/A', 'N/A', 'Python, Django, REST APIs', 'Docker, Kubernetes', 'Office', 'Permanent', 1, 85, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-06-08 01:59:40', '2025-06-08 01:59:40'),
(26, 36, 'Senior Software Engineer1', 'Software Engineer1 I', 'Software Engineer1', 'General Business', 'General Unit', 'Unknown Division', 'Unknown Department', 'Not Provided', 'US-East', 'Software Engineers', 'Backend Developers', NULL, NULL, 'Senior', 'N/A', 'N/A', 'Python, Django, REST APIs', 'Docker, Kubernetes', 'Office', 'Permanent', 1, 85, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-06-12 03:16:45', '2025-06-12 03:16:45'),
(27, 37, 'Senior Software Engineer1', 'Software Engineer1 I', 'Software Engineer1', 'General Business', 'General Unit', 'Unknown Division', 'Unknown Department', 'Not Provided', 'US-East', 'Software Engineers', 'Backend Developers', NULL, NULL, 'Senior', 'N/A', 'N/A', 'Python, Django, REST APIs', 'Docker, Kubernetes', 'Office', 'Permanent', 1, 85, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-06-12 03:16:55', '2025-06-12 03:16:55'),
(28, 38, 'Senior Software Engineer1', 'Software Engineer1 I', 'Software Engineer1', 'General Business', 'General Unit', 'Unknown Division', 'Unknown Department', 'Not Provided', 'US-East', 'Software Engineers', 'Backend Developers', '2025-06-01', '2026-06-01', 'Senior', 'B1', 'SB2', 'Python, Django, REST APIs', 'Docker, Kubernetes', 'Office', 'Permanent', 1, 85, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-06-12 03:21:20', '2025-06-12 03:21:20'),
(29, 39, 'Senior Software Engineer1', 'Software Engineer1 I', 'Software Engineer1', 'General Business', 'General Unit', 'Engineering', 'Software Development', 'New York', 'US-East', 'Software Engineers', 'Backend Developers', '2025-06-01', '2026-06-01', 'Senior', 'B1', 'SB2', 'Python, Django, REST APIs', 'Docker, Kubernetes', 'Office', 'Permanent', 1, 85, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-06-12 03:23:47', '2025-06-12 03:23:47'),
(30, 40, 'Senior Software Engineer1', 'Software Engineer1 I', 'Software Engineer1', 'General Business', 'General Unit', 'Engineering', 'Software Development', 'New York', 'US-East', 'Software Engineers', 'Backend Developers', '2025-06-01', '2026-06-01', 'Senior', 'B1', 'SB2', 'Python, Django, REST APIs', 'Docker, Kubernetes', 'Office', 'Permanent', 1, 85, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-06-12 04:29:38', '2025-06-12 04:29:38');

-- --------------------------------------------------------

--
-- Table structure for table `teams`
--

DROP TABLE IF EXISTS `teams`;
CREATE TABLE IF NOT EXISTS `teams` (
  `id` int NOT NULL AUTO_INCREMENT,
  `requisition_id` int NOT NULL,
  `team_type` varchar(50) DEFAULT NULL,
  `team_name` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `requisition_id` (`requisition_id`)
) ENGINE=MyISAM AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `teams`
--

INSERT INTO `teams` (`id`, `requisition_id`, `team_type`, `team_name`, `created_at`, `updated_at`) VALUES
(4, 20, 'ISG Team', 'Infrastructure Team', '2025-06-06 05:18:15', '2025-06-06 05:18:15'),
(3, 20, 'ONB Coordinator', 'HR Team', '2025-06-06 05:18:15', '2025-06-06 05:18:15'),
(5, 21, 'ONB Coordinator', 'HR Team', '2025-06-06 05:19:23', '2025-06-06 05:19:23'),
(6, 21, 'ISG Team', 'Infrastructure Team', '2025-06-06 05:19:23', '2025-06-06 05:19:23'),
(7, 22, 'ONB Coordinator', 'HR Team', '2025-06-06 06:05:00', '2025-06-06 06:05:00'),
(8, 22, 'ISG Team', 'Infrastructure Team', '2025-06-06 06:05:00', '2025-06-06 06:05:00'),
(9, 23, 'ONB Coordinator', 'HR Team', '2025-06-06 06:10:25', '2025-06-06 06:10:25'),
(10, 23, 'ISG Team', 'Infrastructure Team', '2025-06-06 06:10:25', '2025-06-06 06:10:25'),
(11, 24, 'ONB Coordinator', 'HR Team', '2025-06-06 06:16:38', '2025-06-06 06:16:38'),
(12, 24, 'ISG Team', 'Infrastructure Team', '2025-06-06 06:16:38', '2025-06-06 06:16:38'),
(13, 25, 'ONB Coordinator', 'HR Team', '2025-06-06 06:29:16', '2025-06-06 06:29:16'),
(14, 25, 'ISG Team', 'Infrastructure Team', '2025-06-06 06:29:16', '2025-06-06 06:29:16'),
(15, 26, 'ONB Coordinator', 'HR Team', '2025-06-07 00:52:13', '2025-06-07 00:52:13'),
(16, 26, 'ISG Team', 'Infrastructure Team', '2025-06-07 00:52:13', '2025-06-07 00:52:13'),
(17, 27, 'ONB Coordinator', 'HR Team', '2025-06-07 00:53:20', '2025-06-07 00:53:20'),
(18, 27, 'ISG Team', 'Infrastructure Team', '2025-06-07 00:53:20', '2025-06-07 00:53:20'),
(19, 28, 'ONB Coordinator', 'HR Team', '2025-06-07 00:56:26', '2025-06-07 00:56:26'),
(20, 28, 'ISG Team', 'Infrastructure Team', '2025-06-07 00:56:26', '2025-06-07 00:56:26'),
(21, 29, 'ONB Coordinator', 'HR Team', '2025-06-07 00:58:16', '2025-06-07 00:58:16'),
(22, 29, 'ISG Team', 'Infrastructure Team', '2025-06-07 00:58:16', '2025-06-07 00:58:16'),
(23, 30, 'ONB Coordinator', 'HR Team', '2025-06-07 00:58:29', '2025-06-07 00:58:29'),
(24, 30, 'ISG Team', 'Infrastructure Team', '2025-06-07 00:58:29', '2025-06-07 00:58:29'),
(25, 31, 'ONB Coordinator', 'HR Team', '2025-06-07 00:59:09', '2025-06-07 00:59:09'),
(26, 31, 'ISG Team', 'Infrastructure Team', '2025-06-07 00:59:09', '2025-06-07 00:59:09'),
(27, 32, 'ONB Coordinator', 'HR Team', '2025-06-07 01:00:14', '2025-06-07 01:00:14'),
(28, 32, 'ISG Team', 'Infrastructure Team', '2025-06-07 01:00:14', '2025-06-07 01:00:14'),
(29, 33, 'ONB Coordinator', 'HR Team', '2025-06-07 09:37:40', '2025-06-07 09:37:40'),
(30, 33, 'ISG Team', 'Infrastructure Team', '2025-06-07 09:37:40', '2025-06-07 09:37:40'),
(31, 34, 'ONB Coordinator', 'HR Team', '2025-06-08 01:28:16', '2025-06-08 01:28:16'),
(32, 34, 'ISG Team', 'Infrastructure Team', '2025-06-08 01:28:16', '2025-06-08 01:28:16'),
(33, 35, 'ONB Coordinator', 'HR Team', '2025-06-08 01:59:40', '2025-06-08 01:59:40'),
(34, 35, 'ISG Team', 'Infrastructure Team', '2025-06-08 01:59:40', '2025-06-08 01:59:40'),
(35, 36, 'ONB Coordinator', 'HR Team', '2025-06-12 03:16:45', '2025-06-12 03:16:45'),
(36, 36, 'ISG Team', 'Infrastructure Team', '2025-06-12 03:16:45', '2025-06-12 03:16:45'),
(37, 37, 'ONB Coordinator', 'HR Team', '2025-06-12 03:16:55', '2025-06-12 03:16:55'),
(38, 37, 'ISG Team', 'Infrastructure Team', '2025-06-12 03:16:55', '2025-06-12 03:16:55'),
(39, 38, 'ONB Coordinator', 'HR Team', '2025-06-12 03:21:20', '2025-06-12 03:21:20'),
(40, 38, 'ISG Team', 'Infrastructure Team', '2025-06-12 03:21:20', '2025-06-12 03:21:20'),
(41, 39, 'ONB Coordinator', 'HR Team', '2025-06-12 03:23:47', '2025-06-12 03:23:47'),
(42, 39, 'ISG Team', 'Infrastructure Team', '2025-06-12 03:23:47', '2025-06-12 03:23:47'),
(43, 40, 'ONB Coordinator', 'HR Team', '2025-06-12 04:29:38', '2025-06-12 04:29:38'),
(44, 40, 'ISG Team', 'Infrastructure Team', '2025-06-12 04:29:38', '2025-06-12 04:29:38');

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
  `ResetToken` varchar(64) DEFAULT NULL,
  `Created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `Email` (`Email`),
  KEY `RoleID` (`RoleID`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users_details`
--

INSERT INTO `users_details` (`UserID`, `Name`, `RoleID`, `Email`, `PasswordHash`, `ResetToken`, `Created_at`) VALUES
(1, 'PixelHR', 1, 'pixelhr@gmail.com', 'pbkdf2_sha256$1000000$N1sbu22wbKw9gJTFmbpq4R$vpDXvWtFyAzqayvxGYm7EM54rRst5xNuRJMOFbmPlVg=', NULL, '2025-05-26 05:10:52'),
(2, 'PixelREQ', 2, 'pixelreq@gmail.com', 'pbkdf2_sha256$1000000$N1sbu22wbKw9gJTFmbpq4R$vpDXvWtFyAzqayvxGYm7EM54rRst5xNuRJMOFbmPlVg=', NULL, '2025-05-26 05:10:52'),
(3, 'PixelBO', 3, 'pixelbo@gmail.com', 'pbkdf2_sha256$1000000$N1sbu22wbKw9gJTFmbpq4R$vpDXvWtFyAzqayvxGYm7EM54rRst5xNuRJMOFbmPlVg=', NULL, '2025-05-26 05:10:52'),
(4, 'PixelCan', 4, 'pixelcan@gmail.com', 'pbkdf2_sha256$1000000$N1sbu22wbKw9gJTFmbpq4R$vpDXvWtFyAzqayvxGYm7EM54rRst5xNuRJMOFbmPlVg=', NULL, '2025-05-26 05:10:52'),
(5, 'ANAND', 1, 'anand040593@gmail.com', 'pbkdf2_sha256$1000000$s5wZjZTM19ND2LpAqQOOzD$lNsk5Rxt9kUB3yHXp0c9EUo3ZmW7CB/BsddEbUcQWSA=', NULL, '2025-05-26 05:10:52');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
