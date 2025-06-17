-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jun 17, 2025 at 12:10 PM
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
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobrequisition`
--

DROP TABLE IF EXISTS `jobrequisition`;
CREATE TABLE IF NOT EXISTS `jobrequisition` (
  `RequisitionID` int NOT NULL AUTO_INCREMENT,
  `Planning_id` bigint NOT NULL,
  `PositionTitle` varchar(191) NOT NULL,
  `HiringManagerID` int NOT NULL,
  `Recruiter` varchar(191) NOT NULL,
  `No_of_positions` int NOT NULL,
  `Status` enum('Draft','Pending Approval','Approved','Posted') DEFAULT 'Draft',
  `CreatedDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`RequisitionID`),
  KEY `fk_hiring_manager` (`HiringManagerID`),
  KEY `plan_id_fk` (`Planning_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
  PRIMARY KEY (`id`),
  KEY `plan_skill_fk` (`requisition_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
  `Created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`hiring_plan_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_request_interview_rounds`
--

DROP TABLE IF EXISTS `job_request_interview_rounds`;
CREATE TABLE IF NOT EXISTS `job_request_interview_rounds` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `requisition_id` bigint NOT NULL,
  `round_name` varchar(500) NOT NULL,
  `updt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `plan_fk` (`requisition_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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

--
-- Constraints for dumped tables
--

--
-- Constraints for table `jobrequisition`
--
ALTER TABLE `jobrequisition`
  ADD CONSTRAINT `plan_id_fk` FOREIGN KEY (`Planning_id`) REFERENCES `job_hiring_overview` (`hiring_plan_id`) ON DELETE CASCADE ON UPDATE RESTRICT;

--
-- Constraints for table `job_communication_skills`
--
ALTER TABLE `job_communication_skills`
  ADD CONSTRAINT `plan_skill_fk` FOREIGN KEY (`requisition_id`) REFERENCES `job_hiring_overview` (`hiring_plan_id`) ON DELETE CASCADE ON UPDATE RESTRICT;

--
-- Constraints for table `job_request_interview_rounds`
--
ALTER TABLE `job_request_interview_rounds`
  ADD CONSTRAINT `plan_fk` FOREIGN KEY (`requisition_id`) REFERENCES `job_hiring_overview` (`hiring_plan_id`) ON DELETE CASCADE ON UPDATE RESTRICT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
