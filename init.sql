-- Create the database if it doesn't exist
-- CREATE DATABASE IF NOT EXISTS `pixeladvant_hiring` CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

-- Use the database
-- USE `pixeladvant_hiring`;

-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jul 13, 2025 at 10:50 AM
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `approval_status`
--

DROP TABLE IF EXISTS `approval_status`;
CREATE TABLE IF NOT EXISTS `approval_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `offer_negotiation_id` int NOT NULL,
  `approver_id` int NOT NULL,
  `status` varchar(20) NOT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `offer_negotiation_id` (`offer_negotiation_id`),
  KEY `approver_id` (`approver_id`)
) ;

-- --------------------------------------------------------

--
-- Table structure for table `approver`
--

DROP TABLE IF EXISTS `approver`;
CREATE TABLE IF NOT EXISTS `approver` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `hiring_plan_id` varchar(50) NOT NULL,
  `role` varchar(20) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(254) NOT NULL,
  `contact_number` varchar(15) DEFAULT NULL,
  `job_title` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `set_as_approver` varchar(10) DEFAULT 'NA',
  `requisition_id` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `fk_requisition` (`requisition_id`)
) ;

--
-- Dumping data for table `approver`
--

INSERT INTO `approver` (`id`, `hiring_plan_id`, `role`, `first_name`, `last_name`, `email`, `contact_number`, `job_title`, `created_at`, `set_as_approver`, `requisition_id`) VALUES
(8, 'PL0001', 'HR', 'Test', 'Test', 'marshalmiller143@gmail.com', 'test', 'Test', '2025-07-19 23:05:58', 'Yes', 'RQ0001'),
(9, 'PL0001', 'HR', 'Test', 'Test', 'marshalmiller143@gmail.com', 'Test', 'Test', '2025-07-19 23:05:58', 'Yes', 'RQ0001');

-- --------------------------------------------------------

--
-- Table structure for table `asset_details`
--

DROP TABLE IF EXISTS `asset_details`;
CREATE TABLE IF NOT EXISTS `asset_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `requisition_id` varchar(50) NOT NULL,
  `laptop_type` varchar(100) DEFAULT 'Not Specified',
  `laptop_needed` varchar(10) DEFAULT 'no',
  `additional_questions` varchar(10) DEFAULT 'no',
  `comments` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `requisition_id` (`requisition_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `asset_details`
--

INSERT INTO `asset_details` (`id`, `requisition_id`, `laptop_type`, `laptop_needed`, `additional_questions`, `comments`, `created_at`, `updated_at`) VALUES
(1, 'RQ0001', 'ThinkPad X1', 'Yes', 'No', 'High-performance hardware required', '2025-07-19 07:29:31', '2025-07-19 07:29:31'),
(2, 'RQ0002', 'ThinkPad X1', 'Yes', 'No', 'High-performance hardware required', '2025-07-19 07:39:32', '2025-07-19 07:39:32'),
(3, 'RQ0003', 'ThinkPad X1', 'Yes', 'No', 'High-performance hardware required', '2025-07-20 05:33:07', '2025-07-20 05:33:07'),
(4, 'RQ0004', 'Mac', 'Yes', 'No', 'Provision required before onboarding', '2025-07-21 17:06:30', '2025-07-21 17:06:30');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `auth_user`
--

INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
(1, 'temporarypassword', NULL, 0, 'hiring', '', '', 'hiring@pixeladvant.com', 0, 1, '2025-07-16 08:21:16.755939'),
(2, 'pbkdf2_sha256$1000000$0YwnwKLw6vy7CDVea4m7MU$kA4acs1GFa8HXporfpQ8OXBD4scoYzX006aKj+nGS0k=', NULL, 0, 'pixelhr@gmail.com', '', '', 'pixelhr@gmail.com', 0, 1, '2025-07-19 02:21:49.471282'),
(3, 'pbkdf2_sha256$1000000$yiOWhpERHOQpMYK1dNETpv$ygvqwkGqW7h0nTEbotpQdgVmojvD6WS5q2CNcna5PH4=', NULL, 0, 'pixelbo@gmail.com', '', '', 'pixelbo@gmail.com', 0, 1, '2025-07-19 02:39:15.076782'),
(4, 'pbkdf2_sha256$1000000$0yzrBqecOCpG0hW1Fh8it7$RVp+Fnq077Hst2ISkCLh7r4refWvXJjaHbaysBkC/zs=', NULL, 0, 'pixelreq@gmail.com', '', '', 'pixelreq@gmail.com', 0, 1, '2025-07-19 02:39:25.558270');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `benefit`
--

DROP TABLE IF EXISTS `benefit`;
CREATE TABLE IF NOT EXISTS `benefit` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `billing_details`
--

DROP TABLE IF EXISTS `billing_details`;
CREATE TABLE IF NOT EXISTS `billing_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `requisition_id` varchar(50) NOT NULL,
  `billing_type` varchar(50) DEFAULT NULL,
  `billing_start_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `billing_end_date` date DEFAULT NULL,
  `contract_start_date` date DEFAULT NULL,
  `contract_end_date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `billing_details`
--

INSERT INTO `billing_details` (`id`, `requisition_id`, `billing_type`, `billing_start_date`, `created_at`, `updated_at`, `billing_end_date`, `contract_start_date`, `contract_end_date`) VALUES
(1, 'RQ0001', 'Non-Billable', '2025-08-01', '2025-07-19 01:59:31', '2025-07-19 01:59:31', '2025-12-31', '2025-08-01', '2026-01-31'),
(2, 'RQ0002', 'Non-Billable', '2025-08-01', '2025-07-19 02:09:32', '2025-07-19 02:09:32', '2025-12-31', '2025-08-01', '2026-01-31'),
(3, 'RQ0003', 'Non-Billable', '2025-08-01', '2025-07-20 00:03:07', '2025-07-20 00:03:07', '2025-12-31', '2025-08-01', '2026-01-31'),
(4, 'RQ0004', 'Contract', '2025-08-01', '2025-07-21 11:36:30', '2025-07-21 11:36:30', '2026-01-31', '2025-08-05', '2026-01-15');

-- --------------------------------------------------------

--
-- Table structure for table `candidates`
--

DROP TABLE IF EXISTS `candidates`;
CREATE TABLE IF NOT EXISTS `candidates` (
  `CandidateID` int NOT NULL AUTO_INCREMENT,
  `Req_id_fk` varchar(50) NOT NULL,
  `Email` varchar(191) NOT NULL,
  `Resume` text,
  `Final_rating` int DEFAULT NULL,
  `Feedback` text,
  `Result` varchar(50) DEFAULT NULL,
  `ProfileCreated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `CoverLetter` text,
  `Source` varchar(100) DEFAULT NULL,
  `Score` int DEFAULT NULL,
  `Phone_no` varchar(50) DEFAULT NULL,
  `candidate_first_name` varchar(100) DEFAULT NULL,
  `candidate_last_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`CandidateID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `candidates`
--

INSERT INTO `candidates` (`CandidateID`, `Req_id_fk`, `Email`, `Resume`, `Final_rating`, `Feedback`, `Result`, `ProfileCreated`, `CoverLetter`, `Source`, `Score`, `Phone_no`, `candidate_first_name`, `candidate_last_name`) VALUES
(1, 'RQ0001', 'candidate7322@gmail.com', 'sakthi _Resume.pdf', NULL, NULL, NULL, '2025-07-19 04:23:45', 'This is a sample cover letter for candidate7322.', 'LinkedIn', NULL, '9999999999', 'CandidateFirst7322', 'CandidateLast7322'),
(2, 'RQ0001', 'candidate9718@gmail.com', 'Resume_Vinay_J.pdf', NULL, NULL, NULL, '2025-07-19 09:11:32', 'This is a sample cover letter for candidate9718.', NULL, NULL, '9999999999', 'CandidateFirst9718', 'CandidateLast9718');

-- --------------------------------------------------------

--
-- Table structure for table `candidate_approval`
--

DROP TABLE IF EXISTS `candidate_approval`;
CREATE TABLE IF NOT EXISTS `candidate_approval` (
  `id` int NOT NULL AUTO_INCREMENT,
  `candidate_id` int NOT NULL,
  `approver_id` bigint UNSIGNED NOT NULL,
  `role` varchar(20) NOT NULL,
  `decision` varchar(20) DEFAULT 'Awaiting',
  `comment` text,
  `reviewed_at` datetime DEFAULT NULL,
  `assigned_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_assignment` (`candidate_id`,`approver_id`,`role`),
  KEY `fk_candidate_approval_approver` (`approver_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `candidate_interview_stages`
--

DROP TABLE IF EXISTS `candidate_interview_stages`;
CREATE TABLE IF NOT EXISTS `candidate_interview_stages` (
  `interview_stage_id` int NOT NULL AUTO_INCREMENT,
  `interview_plan_id` int NOT NULL DEFAULT '0',
  `candidate_id` int NOT NULL DEFAULT '0',
  `recuiter_id` int NOT NULL DEFAULT '0',
  `interview_stage` varchar(500) NOT NULL DEFAULT '',
  `interview_date` date DEFAULT NULL,
  `mode_of_interview` varchar(500) NOT NULL DEFAULT '',
  `feedback` varchar(1000) NOT NULL DEFAULT '',
  `status` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`interview_stage_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `candidate_reference`
--

DROP TABLE IF EXISTS `candidate_reference`;
CREATE TABLE IF NOT EXISTS `candidate_reference` (
  `id` int NOT NULL AUTO_INCREMENT,
  `candidate_submission_id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `designation` varchar(100) NOT NULL,
  `organization` varchar(100) NOT NULL,
  `relationship` varchar(100) NOT NULL,
  `phone_number` varchar(20) NOT NULL,
  `email` varchar(254) NOT NULL,
  `address` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_submission` (`candidate_submission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `candidate_reviews`
--

DROP TABLE IF EXISTS `candidate_reviews`;
CREATE TABLE IF NOT EXISTS `candidate_reviews` (
  `ReviewID` int NOT NULL AUTO_INCREMENT,
  `CandidateID` int NOT NULL,
  `ParameterDefined` varchar(100) DEFAULT NULL,
  `Guidelines` varchar(100) DEFAULT NULL,
  `MinimumQuestions` int DEFAULT NULL,
  `ActualRating` decimal(3,1) DEFAULT NULL,
  `Feedback` text,
  `Created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ReviewID`),
  KEY `can_id_fk` (`CandidateID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `candidate_submission`
--

DROP TABLE IF EXISTS `candidate_submission`;
CREATE TABLE IF NOT EXISTS `candidate_submission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `candidate_id` int NOT NULL,
  `recruiter_email` varchar(254) NOT NULL,
  `job_title` varchar(100) NOT NULL,
  `start_date` date NOT NULL,
  `city` varchar(100) NOT NULL,
  `country` varchar(100) NOT NULL,
  `currency` varchar(10) NOT NULL,
  `salary` decimal(12,2) NOT NULL,
  `variable_pay` decimal(12,2) DEFAULT NULL,
  `status` varchar(50) NOT NULL,
  `open_date` date NOT NULL,
  `target_start_date` date NOT NULL,
  `close_date` date DEFAULT NULL,
  `close_reason` text,
  `opening_salary_currency` varchar(10) NOT NULL,
  `opening_salary_range` varchar(50) NOT NULL,
  `driving_license_number` varchar(50) DEFAULT NULL,
  `driving_license_validity` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_candidate` (`candidate_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `config_job_position`
--

DROP TABLE IF EXISTS `config_job_position`;
CREATE TABLE IF NOT EXISTS `config_job_position` (
  `id` int NOT NULL AUTO_INCREMENT,
  `position_role` varchar(500) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `config_job_position`
--

INSERT INTO `config_job_position` (`id`, `position_role`) VALUES
(1, 'Project Manager'),
(2, 'Backend Developer'),
(3, 'Frontend Developer');

-- --------------------------------------------------------

--
-- Table structure for table `config_score_card`
--

DROP TABLE IF EXISTS `config_score_card`;
CREATE TABLE IF NOT EXISTS `config_score_card` (
  `id` int NOT NULL AUTO_INCREMENT,
  `score_card_name` varchar(500) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `config_score_card`
--

INSERT INTO `config_score_card` (`id`, `score_card_name`) VALUES
(1, 'Technical Skills'),
(2, 'Communication'),
(3, 'Problem Solving');

-- --------------------------------------------------------

--
-- Table structure for table `config_screening_type`
--

DROP TABLE IF EXISTS `config_screening_type`;
CREATE TABLE IF NOT EXISTS `config_screening_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `screening_type_name` varchar(500) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `config_screening_type`
--

INSERT INTO `config_screening_type` (`id`, `screening_type_name`) VALUES
(1, 'Online Test'),
(2, 'Telephonic Screen'),
(3, 'Video Screen'),
(4, 'Technical Interview');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
(22, 'myapp', '0004_posting_jobrequisition_no_of_positions_and_more', '2025-06-01 05:38:34.318535'),
(23, 'token_blacklist', '0001_initial', '2025-07-19 02:25:36.549408'),
(24, 'token_blacklist', '0002_outstandingtoken_jti_hex', '2025-07-19 02:25:36.587653'),
(25, 'token_blacklist', '0003_auto_20171017_2007', '2025-07-19 02:25:36.603929');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `interviewer`
--

DROP TABLE IF EXISTS `interviewer`;
CREATE TABLE IF NOT EXISTS `interviewer` (
  `interviewer_id` bigint NOT NULL AUTO_INCREMENT,
  `req_id` varchar(50) NOT NULL,
  `client_id` varchar(100) NOT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `job_title` varchar(100) DEFAULT NULL,
  `interview_mode` varchar(50) DEFAULT NULL,
  `interviewer_stage` varchar(100) DEFAULT NULL,
  `email` varchar(254) DEFAULT NULL,
  `contact_number` varchar(15) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`interviewer_id`) USING BTREE,
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `interviewer`
--

INSERT INTO `interviewer` (`interviewer_id`, `req_id`, `client_id`, `first_name`, `last_name`, `job_title`, `interview_mode`, `interviewer_stage`, `email`, `contact_number`, `created_at`, `user_id`) VALUES
(6, 'RQ0001', 'ABC', 'Kumar', 'Sachidanand', 'PM', 'Online', 'Technical Round-1 & 2', 'kumar.sachidanand11@gmail.com', '8904957029', '2025-07-20 03:14:34', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `interview_review`
--

DROP TABLE IF EXISTS `interview_review`;
CREATE TABLE IF NOT EXISTS `interview_review` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `schedule_id` bigint NOT NULL,
  `feedback` text,
  `result` varchar(100) DEFAULT NULL,
  `reviewed_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_schedule` (`schedule_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `interview_schedule`
--

DROP TABLE IF EXISTS `interview_schedule`;
CREATE TABLE IF NOT EXISTS `interview_schedule` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `candidate_id` int NOT NULL,
  `interviewer_id` bigint NOT NULL,
  `round_name` varchar(100) NOT NULL,
  `date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `meet_link` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `location` varchar(255) DEFAULT NULL,
  `time_zone` varchar(50) DEFAULT NULL,
  `purpose` varchar(255) DEFAULT NULL,
  `mode` varchar(100) DEFAULT NULL,
  `guests` json DEFAULT NULL,
  `durations` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_candidate` (`candidate_id`),
  KEY `fk_interviewer` (`interviewer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `interview_schedule`
--

INSERT INTO `interview_schedule` (`id`, `candidate_id`, `interviewer_id`, `round_name`, `date`, `start_time`, `end_time`, `meet_link`, `created_at`, `location`, `time_zone`, `purpose`, `mode`, `guests`, `durations`) VALUES
(21, 1, 6, 'Technical Screening', '2025-06-06', '11:00:00', '11:30:00', 'https://us05web.zoom.us/j/86897539696?pwd=nBumEhZOuTVAbRXTVm6hldr2Iphtjy.1', '2025-07-20 12:29:47', 'Zoom', 'IST', 'Technical Screening', 'Face to face', '[{\"name\": \"John\", \"email\": \"john@example.com\"}]', '30 mins'),
(22, 1, 6, 'Technical Screening', '2025-06-06', '11:00:00', '11:30:00', 'https://us05web.zoom.us/j/83901668764?pwd=44kEbGBv7YvJw6FnCYLaAG9nJXro3U.1', '2025-07-20 12:30:39', 'Zoom', 'IST', 'Technical Screening', 'Face to face', '[{\"name\": \"John\", \"email\": \"john@example.com\"}]', '30 mins');

-- --------------------------------------------------------

--
-- Table structure for table `interview_slot`
--

DROP TABLE IF EXISTS `interview_slot`;
CREATE TABLE IF NOT EXISTS `interview_slot` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `interviewer_id` bigint DEFAULT NULL,
  `date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `int_fk_id` (`interviewer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `interview_slot`
--

INSERT INTO `interview_slot` (`id`, `interviewer_id`, `date`, `start_time`, `end_time`, `created_at`) VALUES
(5, 6, '2025-06-25', '10:00:00', '12:00:00', '2025-07-20 03:14:34'),
(6, 6, '2025-06-25', '15:00:00', '17:00:00', '2025-07-20 03:14:34');

-- --------------------------------------------------------

--
-- Table structure for table `interview_team`
--

DROP TABLE IF EXISTS `interview_team`;
CREATE TABLE IF NOT EXISTS `interview_team` (
  `id` int NOT NULL AUTO_INCREMENT,
  `requisition_id` varchar(50) NOT NULL,
  `employee_id` varchar(50) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobrequisition`
--

DROP TABLE IF EXISTS `jobrequisition`;
CREATE TABLE IF NOT EXISTS `jobrequisition` (
  `id` int NOT NULL AUTO_INCREMENT,
  `RequisitionID` varchar(50) NOT NULL DEFAULT '',
  `Planning_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `PositionTitle` varchar(191) NOT NULL,
  `HiringManagerID` int NOT NULL,
  `Recruiter` varchar(191) NOT NULL,
  `No_of_positions` int NOT NULL,
  `LegalEntityID` varchar(50) NOT NULL DEFAULT '',
  `QualificationID` varchar(100) NOT NULL DEFAULT '',
  `CommentFromBusinessOps` text NOT NULL,
  `company_client_name` varchar(255) DEFAULT '',
  `client_id` varchar(50) DEFAULT '',
  `Status` enum('Pending Approval','Approved','Rejected','Need More Details','Incomplete form') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'Incomplete form',
  `CreatedDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `requisition_date` date DEFAULT NULL,
  `due_requisition_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `RequisitionID` (`RequisitionID`),
  KEY `fk_hiring_manager` (`HiringManagerID`),
  KEY `plan_id_fk` (`Planning_id`)
) ;

--
-- Dumping data for table `jobrequisition`
--

INSERT INTO `jobrequisition` (`id`, `RequisitionID`, `Planning_id`, `PositionTitle`, `HiringManagerID`, `Recruiter`, `No_of_positions`, `LegalEntityID`, `QualificationID`, `CommentFromBusinessOps`, `company_client_name`, `client_id`, `Status`, `CreatedDate`, `UpdatedDate`, `requisition_date`, `due_requisition_date`) VALUES
(39, 'RQ0001', '1', 'Principal Backend Architect', 1, 'Not Assigned', 1, '0', 'B.Tech', 'Budget confirmed. Proceeding with approval.', 'HCL', 'CL0001', 'Approved', '2025-07-19 01:59:15', '2025-07-20 05:28:11', '2025-07-19', NULL),
(40, 'RQ0002', '1', 'Principal Backend Architect', 1, 'Not Assigned', 1, '0', 'B.Tech', '', 'HCL', 'CL0002', 'Pending Approval', '2025-07-19 02:09:18', '2025-07-20 05:28:15', '2025-07-19', NULL),
(41, 'RQ0003', '1', 'Principal Backend Architect', 1, 'Not Assigned', 1, '0', 'B.Tech', '', 'ABC', 'CL0003', 'Pending Approval', '2025-07-20 00:02:30', '2025-07-20 00:03:07', '2025-07-19', '2025-07-19'),
(43, 'RQ0004', '1', 'Senior Backend Engineer', 1, 'Not Assigned', 1, '0', 'B.Tech', '', 'CloudNexa Solutions', NULL, 'Incomplete form', '2025-07-21 11:21:16', '2025-07-21 11:36:30', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `job_communication_skills`
--

DROP TABLE IF EXISTS `job_communication_skills`;
CREATE TABLE IF NOT EXISTS `job_communication_skills` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `plan_id` varchar(50) NOT NULL,
  `skill_name` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `skill_value` varchar(200) NOT NULL DEFAULT '',
  `updt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_hiring_overview`
--

DROP TABLE IF EXISTS `job_hiring_overview`;
CREATE TABLE IF NOT EXISTS `job_hiring_overview` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `hiring_plan_id` varchar(50) NOT NULL DEFAULT '',
  `job_position` varchar(500) NOT NULL DEFAULT '',
  `tech_stacks` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '',
  `jd_details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `designation` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '',
  `experience_range` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `target_companies` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `compensation` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `working_model` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `interview_status` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `location` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `education_decision` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `relocation` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `travel_opportunities` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `domain_knowledge` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `visa_requirements` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `background_verification` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `shift_timings` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `role_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `job_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `communication_language` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `notice_period` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `additional_comp` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `citizen_requirement` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `career_gap` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `sabbatical` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `screening_questions` text,
  `job_health_requirements` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `social_media_links` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `language_proficiency` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `requisition_template` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `no_of_openings` int DEFAULT '0',
  `Created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `mode_of_working` varchar(255) DEFAULT NULL,
  `relocation_amount` varchar(255) DEFAULT NULL,
  `domain_yn` varchar(255) DEFAULT NULL,
  `domain_name` varchar(255) DEFAULT NULL,
  `education_qualification` varchar(255) DEFAULT NULL,
  `visa_country` varchar(255) DEFAULT NULL,
  `visa_type` varchar(255) DEFAULT NULL,
  `github_link` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `job_hiring_overview`
--

INSERT INTO `job_hiring_overview` (`id`, `hiring_plan_id`, `job_position`, `tech_stacks`, `jd_details`, `designation`, `experience_range`, `target_companies`, `compensation`, `working_model`, `interview_status`, `location`, `education_decision`, `relocation`, `travel_opportunities`, `domain_knowledge`, `visa_requirements`, `background_verification`, `shift_timings`, `role_type`, `job_type`, `communication_language`, `notice_period`, `additional_comp`, `citizen_requirement`, `career_gap`, `sabbatical`, `screening_questions`, `job_health_requirements`, `social_media_links`, `language_proficiency`, `requisition_template`, `no_of_openings`, `Created_at`, `mode_of_working`, `relocation_amount`, `domain_yn`, `domain_name`, `education_qualification`, `visa_country`, `visa_type`, `github_link`) VALUES
(1, 'PL0001', 'Backend API Developer', 'Node.js, MongoDB, Redis, GraphQL', 'Design scalable backend APIs, manage databases, and integrate third-party services.', 'Software Engineer II', '3-6', 'Google, Amazon, Stripe', '₹18-22 LPA', 'Remote', '', 'Chennai', '', 'No', 'Quarterly client visits', '', 'Yes', 'Yes', 'Flexible', 'Individual Contributor', 'Full time', 'English', '', '', 'No', 'Allowed up to 2 years', '', '', 'Vaccinated', 'LinkedIn, GitHub', 'Advanced', '', 4, '2025-07-09 23:18:25', 'Online', 'N/A', 'Yes', 'FinTech', 'B.E./B.Tech in Computer Science', 'Singapore', 'Work Visa', 'https://github.com/developer42');

-- --------------------------------------------------------

--
-- Table structure for table `job_interview_design_parameters`
--

DROP TABLE IF EXISTS `job_interview_design_parameters`;
CREATE TABLE IF NOT EXISTS `job_interview_design_parameters` (
  `interview_desing_params_id` int NOT NULL AUTO_INCREMENT,
  `hiring_plan_id` varchar(50) NOT NULL DEFAULT '',
  `interview_design_id` int NOT NULL DEFAULT '0',
  `score_card` varchar(500) NOT NULL DEFAULT '',
  `options` varchar(500) NOT NULL DEFAULT '',
  `guideline` varchar(500) NOT NULL DEFAULT '',
  `min_questions` int NOT NULL DEFAULT '0',
  `screen_type` varchar(500) NOT NULL DEFAULT '',
  `duration` int NOT NULL,
  `mode` varchar(1000) NOT NULL DEFAULT '',
  `feedback` varchar(500) NOT NULL DEFAULT '',
  PRIMARY KEY (`interview_desing_params_id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `job_interview_design_parameters`
--

INSERT INTO `job_interview_design_parameters` (`interview_desing_params_id`, `hiring_plan_id`, `interview_design_id`, `score_card`, `options`, `guideline`, `min_questions`, `screen_type`, `duration`, `mode`, `feedback`) VALUES
(19, 'PL0001', 12, 'Technical Skills', '11', '11', 1, 'online', 11, '11', '11'),
(20, 'PL0001', 12, 'Communication Skills', '1', '1', 1, 'online', 11, '11', '11'),
(23, 'PL0001', 13, 'Technical Skills', '11', '11', 1, '111', 11, 'Online', '11'),
(24, 'PL0001', 13, 'Technical Skills', '1', '1', 1, '11', 11, 'Online', '11');

-- --------------------------------------------------------

--
-- Table structure for table `job_interview_design_screen`
--

DROP TABLE IF EXISTS `job_interview_design_screen`;
CREATE TABLE IF NOT EXISTS `job_interview_design_screen` (
  `interview_design_id` int NOT NULL AUTO_INCREMENT,
  `hiring_plan_id` varchar(50) NOT NULL DEFAULT '',
  `req_id` varchar(50) NOT NULL DEFAULT '',
  `position_role` varchar(500) NOT NULL DEFAULT '',
  `tech_stacks` varchar(500) NOT NULL DEFAULT '',
  `screening_type` varchar(500) NOT NULL DEFAULT '',
  `no_of_interview_round` int NOT NULL DEFAULT '0',
  `final_rating` int NOT NULL DEFAULT '0',
  `status` varchar(800) NOT NULL,
  `feedback` varchar(1000) NOT NULL,
  PRIMARY KEY (`interview_design_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `job_interview_design_screen`
--

INSERT INTO `job_interview_design_screen` (`interview_design_id`, `hiring_plan_id`, `req_id`, `position_role`, `tech_stacks`, `screening_type`, `no_of_interview_round`, `final_rating`, `status`, `feedback`) VALUES
(8, 'PL0001', 'RQ0001', 'Principal Backend Architect', '2', 'Online Test', 1, 0, '', ''),
(12, 'PL0001', 'RQ0001', 'Principal Backend Architect', '2', 'Online Test', 1, 0, '', ''),
(13, 'PL0001', 'RQ0001', 'Principal Backend Architect', '2', 'Online Test', 1, 0, '', '');

-- --------------------------------------------------------

--
-- Table structure for table `job_interview_planning`
--

DROP TABLE IF EXISTS `job_interview_planning`;
CREATE TABLE IF NOT EXISTS `job_interview_planning` (
  `interview_plan_id` int NOT NULL AUTO_INCREMENT,
  `hiring_plan_id` varchar(50) NOT NULL DEFAULT '',
  `requisition_id` varchar(50) NOT NULL DEFAULT '',
  `dead_line_days` int NOT NULL DEFAULT '0',
  `offer_decline` int NOT NULL DEFAULT '0',
  `working_hours_per_day` int NOT NULL DEFAULT '0',
  `no_of_roles_to_hire` int NOT NULL DEFAULT '0',
  `conversion_ratio` int NOT NULL DEFAULT '0',
  `elimination` int NOT NULL DEFAULT '0',
  `avg_interviewer_time_per_week_hrs` int NOT NULL DEFAULT '0',
  `interview_round` int NOT NULL DEFAULT '0',
  `interview_time_per_round` int NOT NULL DEFAULT '0',
  `interviewer_leave_days` int NOT NULL DEFAULT '0',
  `no_of_month_interview_happens` int NOT NULL DEFAULT '0',
  `working_hrs_per_week` int NOT NULL DEFAULT '0',
  `required_candidate` int NOT NULL DEFAULT '0',
  `decline_adjust_count` int NOT NULL DEFAULT '0',
  `total_candidate_pipline` int NOT NULL DEFAULT '0',
  `total_interviews_needed` int NOT NULL DEFAULT '0',
  `total_interview_hrs` int NOT NULL DEFAULT '0',
  `total_interview_weeks` int NOT NULL DEFAULT '0',
  `no_of_interviewer_need` int NOT NULL DEFAULT '0',
  `leave_adjustment` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`interview_plan_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `job_interview_planning`
--

INSERT INTO `job_interview_planning` (`interview_plan_id`, `hiring_plan_id`, `requisition_id`, `dead_line_days`, `offer_decline`, `working_hours_per_day`, `no_of_roles_to_hire`, `conversion_ratio`, `elimination`, `avg_interviewer_time_per_week_hrs`, `interview_round`, `interview_time_per_round`, `interviewer_leave_days`, `no_of_month_interview_happens`, `working_hrs_per_week`, `required_candidate`, `decline_adjust_count`, `total_candidate_pipline`, `total_interviews_needed`, `total_interview_hrs`, `total_interview_weeks`, `no_of_interviewer_need`, `leave_adjustment`) VALUES
(3, 'PL0001', 'RQ0001', 60, 20, 8, 10, 12, 0, 5, 3, 2, 10, 1, 40, 120, 24, 144, 432, 864, 22, 14, 15.9);

-- --------------------------------------------------------

--
-- Table structure for table `job_request_interview_rounds`
--

DROP TABLE IF EXISTS `job_request_interview_rounds`;
CREATE TABLE IF NOT EXISTS `job_request_interview_rounds` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `plan_id` varchar(50) NOT NULL,
  `requisition_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `round_name` varchar(500) NOT NULL,
  `updt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_stage_responsibility`
--

DROP TABLE IF EXISTS `job_stage_responsibility`;
CREATE TABLE IF NOT EXISTS `job_stage_responsibility` (
  `stage_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `hiring_plan_id` varchar(50) NOT NULL DEFAULT '',
  `role_name` varchar(255) DEFAULT NULL,
  `application_review` int DEFAULT '0',
  `phone_review` int DEFAULT '0',
  `reference_check` int DEFAULT '0',
  `face_to_face` int DEFAULT '0',
  `verbal_offer` int DEFAULT '0',
  `other` int DEFAULT '0',
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `email_id` varchar(255) DEFAULT NULL,
  `phone_no` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`stage_id`),
  UNIQUE KEY `stage_id` (`stage_id`)
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `offer_negotiation`
--

DROP TABLE IF EXISTS `offer_negotiation`;
CREATE TABLE IF NOT EXISTS `offer_negotiation` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `requisition_id` varchar(50) NOT NULL,
  `client_name` varchar(100) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `position_applied` varchar(150) NOT NULL,
  `expected_salary` decimal(10,2) DEFAULT NULL,
  `offered_salary` decimal(10,2) DEFAULT NULL,
  `expected_title` varchar(150) DEFAULT NULL,
  `offered_title` varchar(150) DEFAULT NULL,
  `expected_location` varchar(100) DEFAULT NULL,
  `offered_location` varchar(100) DEFAULT NULL,
  `expected_doj` date DEFAULT NULL,
  `offered_doj` date DEFAULT NULL,
  `expected_work_mode` varchar(50) DEFAULT NULL,
  `offered_work_mode` varchar(50) DEFAULT NULL,
  `negotiation_status` varchar(50) NOT NULL,
  `comments` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `offer_negotiation_benefits`
--

DROP TABLE IF EXISTS `offer_negotiation_benefits`;
CREATE TABLE IF NOT EXISTS `offer_negotiation_benefits` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `offer_negotiation_id` int NOT NULL,
  `benefit_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `offernegotiation_id` (`offer_negotiation_id`,`benefit_id`),
  KEY `benefit_id` (`benefit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `posting_details`
--

DROP TABLE IF EXISTS `posting_details`;
CREATE TABLE IF NOT EXISTS `posting_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `requisition_id` varchar(50) NOT NULL,
  `experience` varchar(255) DEFAULT NULL,
  `designation` varchar(255) DEFAULT NULL,
  `job_category` varchar(255) DEFAULT NULL,
  `job_region` varchar(255) DEFAULT NULL,
  `internal_job_description` text,
  `external_job_description` text,
  `qualification` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `posting_details`
--

INSERT INTO `posting_details` (`id`, `requisition_id`, `experience`, `designation`, `job_category`, `job_region`, `internal_job_description`, `external_job_description`, `qualification`, `created_at`, `updated_at`) VALUES
(1, 'RQ0001', '8-12 years', 'Principal Engineer', NULL, 'India, EMEA', '<p>Drive backend architecture and lead cross-team initiatives</p>', '<p>Looking for an expert in scalable systems and leadership</p>', 'M.Tech, PhD', '2025-07-19 01:59:31', '2025-07-19 01:59:31'),
(2, 'RQ0002', '8-12 years', 'Principal Engineer', NULL, 'India, EMEA', '<p>Drive backend architecture and lead cross-team initiatives</p>', '<p>Looking for an expert in scalable systems and leadership</p>', 'M.Tech, PhD', '2025-07-19 02:09:32', '2025-07-19 02:09:32'),
(3, 'RQ0003', '8-12 years', 'Principal Engineer', NULL, 'India, EMEA', '<p>Drive backend architecture and lead cross-team initiatives</p>', '<p>Looking for an expert in scalable systems and leadership</p>', 'M.Tech, PhD', '2025-07-20 00:03:07', '2025-07-20 00:03:07'),
(4, 'RQ0004', '5-8', 'Senior Engineer', '', 'India', '<p>Lead backend development with Django and PostgreSQL.</p>', '<p>Looking for a senior engineer to join our cloud infrastructure team.</p>', 'MCA, B.Tech', '2025-07-21 11:21:16', '2025-07-21 11:36:30');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `requisition_competency`
--

DROP TABLE IF EXISTS `requisition_competency`;
CREATE TABLE IF NOT EXISTS `requisition_competency` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `requisition_id` varchar(50) NOT NULL,
  `competency` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `library` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `expected_rating` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `weight` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `requisition_id` (`requisition_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `requisition_details`
--

DROP TABLE IF EXISTS `requisition_details`;
CREATE TABLE IF NOT EXISTS `requisition_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `requisition_id` varchar(50) NOT NULL DEFAULT '',
  `internal_title` varchar(255) NOT NULL,
  `external_title` varchar(255) NOT NULL,
  `job_position` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
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
  `company_client_name` varchar(255) DEFAULT NULL,
  `client_id` varchar(50) DEFAULT NULL,
  `band` varchar(50) DEFAULT NULL,
  `sub_band` varchar(50) DEFAULT NULL,
  `primary_skills` text,
  `secondary_skills` text,
  `working_model` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `requisition_type` varchar(50) DEFAULT NULL,
  `client_interview` varchar(10) DEFAULT 'NO',
  `required_score` int DEFAULT NULL,
  `onb_coordinator` varchar(255) DEFAULT NULL,
  `onb_coordinator_team` text,
  `isg_team` text,
  `interviewer_teammate_employee_id` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `requisition_date` date DEFAULT NULL,
  `due_requisition_date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `requisition_details`
--

INSERT INTO `requisition_details` (`id`, `requisition_id`, `internal_title`, `external_title`, `job_position`, `business_line`, `business_unit`, `division`, `department`, `location`, `geo_zone`, `employee_group`, `employee_sub_group`, `contract_start_date`, `contract_end_date`, `career_level`, `company_client_name`, `client_id`, `band`, `sub_band`, `primary_skills`, `secondary_skills`, `working_model`, `requisition_type`, `client_interview`, `required_score`, `onb_coordinator`, `onb_coordinator_team`, `isg_team`, `interviewer_teammate_employee_id`, `created_at`, `updated_at`, `requisition_date`, `due_requisition_date`) VALUES
(1, 'RQ0001', 'Backend Architect', 'Principal Engineer', 'Lead Backend Developer', 'SaaS Infrastructure', 'Product Core', 'Engineering', 'Platform Services', 'Bangalore', 'APAC', 'General Employee Group', 'General Sub Group', '2025-08-01', '2026-01-31', 'Senior-Level', 'CodeFusion Ltd', '', 'Band 3', 'Sub Band C', 'Node.js, NestJS, PostgreSQL', 'Kubernetes, AWS, Kafka', 'Remote', 'Strategic', 'No', 0, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-07-19 01:59:31', '2025-07-19 01:59:31', '2025-08-01', '2025-12-31'),
(2, 'RQ0002', 'Backend Architect', 'Principal Engineer', 'Lead Backend Developer', 'SaaS Infrastructure', 'Product Core', 'Engineering', 'Platform Services', 'Bangalore', 'APAC', 'General Employee Group', 'General Sub Group', '2025-08-01', '2026-01-31', 'Senior-Level', 'CodeFusion Ltd', '', 'Band 3', 'Sub Band C', 'Node.js, NestJS, PostgreSQL', 'Kubernetes, AWS, Kafka', 'Remote', 'Strategic', 'No', 0, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-07-19 02:09:32', '2025-07-19 02:09:32', '2025-08-01', '2025-12-31'),
(3, 'RQ0003', 'Backend Architect', 'Principal Engineer', 'Lead Backend Developer', 'SaaS Infrastructure', 'Product Core', 'Engineering', 'Platform Services', 'Bangalore', 'APAC', 'General Employee Group', 'General Sub Group', '2025-08-01', '2026-01-31', 'Senior-Level', 'CodeFusion Ltd', '', 'Band 3', 'Sub Band C', 'Node.js, NestJS, PostgreSQL', 'Kubernetes, AWS, Kafka', 'Remote', 'Strategic', 'No', 0, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-07-20 00:03:07', '2025-07-20 00:03:07', '2025-08-01', '2025-12-31'),
(4, 'RQ0004', 'SDE Backend', 'Senior Backend Engineer', 'Backend Developer', 'Cloud Ops', 'Engineering', 'Infrastructure', 'Platform Team', 'Bangalore', 'APAC', 'General Employee Group', 'General Sub Group', NULL, NULL, 'L4', 'CloudNexa Solutions', '', 'P5', 'Core', 'Python, Django, SQL', 'Docker, AWS, Redis', 'Hybrid', 'Replacement', 'Yes', 0, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-07-21 11:21:16', '2025-07-21 11:36:30', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `requisition_question`
--

DROP TABLE IF EXISTS `requisition_question`;
CREATE TABLE IF NOT EXISTS `requisition_question` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `requisition_id` varchar(50) NOT NULL,
  `question` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `required` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `disqualifier` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `score` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `weight` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `requisition_id` (`requisition_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `teams`
--

DROP TABLE IF EXISTS `teams`;
CREATE TABLE IF NOT EXISTS `teams` (
  `id` int NOT NULL AUTO_INCREMENT,
  `requisition_id` varchar(50) NOT NULL,
  `team_type` varchar(50) DEFAULT NULL,
  `team_name` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `userrole`
--

DROP TABLE IF EXISTS `userrole`;
CREATE TABLE IF NOT EXISTS `userrole` (
  `RoleID` int NOT NULL AUTO_INCREMENT,
  `RoleName` enum('Hiring Manager','Recruiter','Business Ops','Interviewer') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`RoleID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `userrole`
--

INSERT INTO `userrole` (`RoleID`, `RoleName`) VALUES
(1, 'Hiring Manager'),
(2, 'Recruiter'),
(3, 'Business Ops'),
(4, 'Interviewer');

-- --------------------------------------------------------

--
-- Table structure for table `users_details`
--

DROP TABLE IF EXISTS `users_details`;
CREATE TABLE IF NOT EXISTS `users_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(191) NOT NULL,
  `RoleID` int NOT NULL,
  `Email` varchar(191) NOT NULL,
  `PasswordHash` varchar(255) NOT NULL,
  `ResetToken` varchar(64) DEFAULT NULL,
  `Created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Email` (`Email`),
  KEY `RoleID` (`RoleID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users_details`
--

INSERT INTO `users_details` (`id`, `Name`, `RoleID`, `Email`, `PasswordHash`, `ResetToken`, `Created_at`) VALUES
(1, 'PixelHR', 1, 'pixelhr@gmail.com', 'pbkdf2_sha256$1000000$N1sbu22wbKw9gJTFmbpq4R$vpDXvWtFyAzqayvxGYm7EM54rRst5xNuRJMOFbmPlVg=', NULL, '2025-05-26 05:10:52'),
(2, 'PixelREQ', 2, 'pixelreq@gmail.com', 'pbkdf2_sha256$1000000$N1sbu22wbKw9gJTFmbpq4R$vpDXvWtFyAzqayvxGYm7EM54rRst5xNuRJMOFbmPlVg=', NULL, '2025-05-26 05:10:52'),
(3, 'PixelBO', 3, 'pixelbo@gmail.com', 'pbkdf2_sha256$1000000$N1sbu22wbKw9gJTFmbpq4R$vpDXvWtFyAzqayvxGYm7EM54rRst5xNuRJMOFbmPlVg=', NULL, '2025-05-26 05:10:52'),
(4, 'PixelCan', 4, 'pixelcan@gmail.com', 'pbkdf2_sha256$1000000$N1sbu22wbKw9gJTFmbpq4R$vpDXvWtFyAzqayvxGYm7EM54rRst5xNuRJMOFbmPlVg=', NULL, '2025-05-26 05:10:52'),
(5, 'ANAND', 1, 'anand040593@gmail.com', 'pbkdf2_sha256$1000000$s5wZjZTM19ND2LpAqQOOzD$lNsk5Rxt9kUB3yHXp0c9EUo3ZmW7CB/BsddEbUcQWSA=', 'KulesSJQnXgQqCyZOhoE71udhj6ukHnz', '2025-05-26 05:10:52'),
(6, 'Kumar', 4, 'kumar.sachidanand@gmail.com', 'pbkdf2_sha256$1000000$s5wZjZTM19ND2LpAqQOOzD$lNsk5Rxt9kUB3yHXp0c9EUo3ZmW7CB/BsddEbUcQWSA=', NULL, '2025-05-26 05:10:52');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `approver`
--
ALTER TABLE `approver`
  ADD CONSTRAINT `fk_requisition` FOREIGN KEY (`requisition_id`) REFERENCES `jobrequisition` (`RequisitionID`) ON DELETE CASCADE;

--
-- Constraints for table `candidate_approval`
--
ALTER TABLE `candidate_approval`
  ADD CONSTRAINT `fk_candidate_approval_approver` FOREIGN KEY (`approver_id`) REFERENCES `approver` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_candidate_approval_candidate` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`CandidateID`) ON DELETE CASCADE;

--
-- Constraints for table `candidate_reviews`
--
ALTER TABLE `candidate_reviews`
  ADD CONSTRAINT `can_id_fk` FOREIGN KEY (`CandidateID`) REFERENCES `candidates` (`CandidateID`) ON DELETE CASCADE ON UPDATE RESTRICT;

--
-- Constraints for table `interviewer`
--
ALTER TABLE `interviewer`
  ADD CONSTRAINT `fk_user_interviewer` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `interview_review`
--
ALTER TABLE `interview_review`
  ADD CONSTRAINT `fk_schedule` FOREIGN KEY (`schedule_id`) REFERENCES `interview_schedule` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `interview_schedule`
--
ALTER TABLE `interview_schedule`
  ADD CONSTRAINT `fk_candidate` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`CandidateID`) ON DELETE CASCADE ON UPDATE RESTRICT,
  ADD CONSTRAINT `fk_interviewer` FOREIGN KEY (`interviewer_id`) REFERENCES `interviewer` (`interviewer_id`) ON DELETE CASCADE ON UPDATE RESTRICT;

--
-- Constraints for table `interview_slot`
--
ALTER TABLE `interview_slot`
  ADD CONSTRAINT `int_fk_id` FOREIGN KEY (`interviewer_id`) REFERENCES `interviewer` (`interviewer_id`) ON DELETE CASCADE ON UPDATE RESTRICT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
