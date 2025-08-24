-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Aug 24, 2025 at 08:00 AM
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `approval_status`
--

INSERT INTO `approval_status` (`id`, `offer_negotiation_id`, `approver_id`, `status`, `updated_at`) VALUES
(1, 1, 1, 'Pending', '2025-08-05 10:26:02'),
(2, 1, 2, 'Pending', '2025-08-05 10:26:02'),
(3, 2, 1, 'Approved', '2025-08-05 11:12:04'),
(4, 2, 2, 'Approved', '2025-08-05 11:11:50');

-- --------------------------------------------------------

--
-- Table structure for table `approver`
--

DROP TABLE IF EXISTS `approver`;
CREATE TABLE IF NOT EXISTS `approver` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `hiring_plan_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `approver`
--

INSERT INTO `approver` (`id`, `hiring_plan_id`, `role`, `first_name`, `last_name`, `email`, `contact_number`, `job_title`, `created_at`, `set_as_approver`, `requisition_id`) VALUES
(1, 'PL0001', 'MANAGER', 'Anand', 'Sivakumar', 'anand040593@gmail.com', '09994551690', 'Software Engineer', '2025-08-05 10:16:58', 'Yes', 'RQ0001'),
(2, 'PL0001', 'HR', 'Rajkumar', 'R', 'anandsivakumar27@gmail.com', '8667735882', 'Principal Backend Architect', '2025-08-05 10:16:58', 'Yes', 'RQ0001'),
(3, '', 'HR', 'Test', 'Test', 'marshalmiller143@gmail.com', 'test', 'Test', '2025-08-18 12:26:31', 'Yes', 'RQ0002'),
(4, '', 'HR', 'Test', 'Test', 'marshalmiller143@gmail.com', 'Test', 'Test', '2025-08-18 12:26:31', 'Yes', 'RQ0002'),
(5, NULL, 'MANAGER', 'Aravind', 'Kumar', 'engineering@gmail.com', '567890098765', 'Senior Software engineer', '2025-08-18 12:37:21', 'Yes', 'RQ0002'),
(6, '1', 'HR', 'Anand1', 'Sivakumar', 'anand040593@gmail.com', '09994551690', 'Principal Backend Architect', '2025-08-18 23:21:57', 'Yes', 'RQ0001'),
(7, '1', 'MANAGER', 'Anand2', 'Sivakumar', 'anandsivakumar27@gmail.com', '09994551690', 'Software Engineer', '2025-08-18 23:21:57', 'Yes', 'RQ0001');

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `asset_details`
--

INSERT INTO `asset_details` (`id`, `requisition_id`, `laptop_type`, `laptop_needed`, `additional_questions`, `comments`, `created_at`, `updated_at`) VALUES
(1, 'RQ0002', 'Windows', 'Yes', 'No', 'needed', '2025-08-18 04:29:52', '2025-08-18 04:29:52');

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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `auth_user`
--

INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
(1, 'temporarypassword', NULL, 0, 'hiring', '', '', 'hiring@pixeladvant.com', 0, 1, '2025-07-16 08:21:16.755939'),
(2, 'pbkdf2_sha256$1000000$0YwnwKLw6vy7CDVea4m7MU$kA4acs1GFa8HXporfpQ8OXBD4scoYzX006aKj+nGS0k=', NULL, 0, 'pixelhr@gmail.com', '', '', 'pixelhr@gmail.com', 0, 1, '2025-07-19 02:21:49.471282'),
(3, 'pbkdf2_sha256$1000000$yiOWhpERHOQpMYK1dNETpv$ygvqwkGqW7h0nTEbotpQdgVmojvD6WS5q2CNcna5PH4=', NULL, 0, 'pixelbo@gmail.com', '', '', 'pixelbo@gmail.com', 0, 1, '2025-07-19 02:39:15.076782'),
(4, 'pbkdf2_sha256$1000000$0yzrBqecOCpG0hW1Fh8it7$RVp+Fnq077Hst2ISkCLh7r4refWvXJjaHbaysBkC/zs=', NULL, 0, 'pixelreq@gmail.com', '', '', 'pixelreq@gmail.com', 0, 1, '2025-07-19 02:39:25.558270'),
(5, 'pbkdf2_sha256$1000000$JtViLKCDbU0aQD7IwV1ohW$1CQnWfRZXqmZcYvvAHddqs7JHxTy4v41jZIr964dOXM=', NULL, 0, 'pixelcan@gmail.com', '', '', 'pixelcan@gmail.com', 0, 1, '2025-07-30 15:12:30.899243');

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
-- Table structure for table `banking_details`
--

DROP TABLE IF EXISTS `banking_details`;
CREATE TABLE IF NOT EXISTS `banking_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `candidate_id` int DEFAULT NULL,
  `bank_name` varchar(100) DEFAULT NULL,
  `account_number` varchar(50) DEFAULT NULL,
  `ifsc_code` varchar(20) DEFAULT NULL,
  `branch_address` text,
  `bank_statement` varchar(255) DEFAULT NULL,
  `cancel_cheque` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `candidate_id` (`candidate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `banking_details`
--

INSERT INTO `banking_details` (`id`, `candidate_id`, `bank_name`, `account_number`, `ifsc_code`, `branch_address`, `bank_statement`, `cancel_cheque`) VALUES
(1, 1, 'HDFC Bank', '1234567890', 'HDFC0001234', 'MG Road', '', '');

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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `benefit`
--

INSERT INTO `benefit` (`id`, `name`) VALUES
(1, 'Insurance'),
(3, 'Joining Bonus'),
(2, 'Relocation Amount');

-- --------------------------------------------------------

--
-- Table structure for table `bg_check_request`
--

DROP TABLE IF EXISTS `bg_check_request`;
CREATE TABLE IF NOT EXISTS `bg_check_request` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `requisition_id` varchar(255) NOT NULL,
  `candidate_id` int NOT NULL,
  `vendor_id` int NOT NULL,
  `selected_package_id` int DEFAULT NULL,
  `custom_checks` json DEFAULT NULL,
  `status` varchar(50) DEFAULT 'Initiated',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `requisition_id` (`requisition_id`),
  KEY `candidate_id` (`candidate_id`),
  KEY `vendor_id` (`vendor_id`),
  KEY `selected_package_id` (`selected_package_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bg_package`
--

DROP TABLE IF EXISTS `bg_package`;
CREATE TABLE IF NOT EXISTS `bg_package` (
  `id` int NOT NULL AUTO_INCREMENT,
  `vendor_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `rate` decimal(10,2) NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `verification_items` text,
  PRIMARY KEY (`id`),
  KEY `fk_vendor` (`vendor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `bg_package`
--

INSERT INTO `bg_package` (`id`, `vendor_id`, `name`, `rate`, `description`, `created_at`, `verification_items`) VALUES
(14, 6, 'Royal Wedding', 49999.00, 'Full-day coverage with cinematic highlights and drone shots.', '2025-08-07 08:05:19', NULL),
(15, 6, 'Classic Wedding ', 29999.00, 'Traditional photography and video coverage with 2 photographers.', '2025-08-07 08:05:19', NULL),
(16, 7, 'Advances', 2500.00, 'all checks', '2025-08-19 05:04:29', 'Email, ID Proof, Phone'),
(17, 7, 'Advances', 2500.00, 'all checks', '2025-08-21 14:47:06', 'Email, ID Proof, Phone');

-- --------------------------------------------------------

--
-- Table structure for table `bg_package_detail`
--

DROP TABLE IF EXISTS `bg_package_detail`;
CREATE TABLE IF NOT EXISTS `bg_package_detail` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `vendor_id` int NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `rate` decimal(10,2) NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `bg_package_detail_vendor_id_fk` (`vendor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `bg_package_detail`
--

INSERT INTO `bg_package_detail` (`id`, `vendor_id`, `title`, `description`, `rate`, `created_at`) VALUES
(7, 6, 'Live Streaming', 'Stream your wedding live on YouTube and Facebook.', 4999.00, '2025-08-07 08:05:18.902524'),
(8, 6, 'Photo Booth Setup', 'Interactive photo booth with instant prints and props.', 3499.00, '2025-08-07 08:05:18.906402'),
(9, 6, 'Wedding Album', 'Premium leather-bound album with 100 curated photos.', 5999.00, '2025-08-07 08:05:18.908908'),
(11, 7, 'employement check', 'good', 1000.00, '2025-08-21 14:48:18.650532');

-- --------------------------------------------------------

--
-- Table structure for table `bg_vendor`
--

DROP TABLE IF EXISTS `bg_vendor`;
CREATE TABLE IF NOT EXISTS `bg_vendor` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_email` varchar(254) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `mobile_no` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `bg_vendor`
--

INSERT INTO `bg_vendor` (`id`, `name`, `contact_email`, `address`, `created_at`, `mobile_no`) VALUES
(6, 'Elite Weddings Co', 'contact@eliteweddings.in', '124 Celebration Avenue, Chennai', '2025-08-07 08:05:19', NULL),
(7, 'American adventage', 'hiring@pixeladvant.com', 'bangalore', '2025-08-19 05:04:29', '9994551690');

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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `billing_details`
--

INSERT INTO `billing_details` (`id`, `requisition_id`, `billing_type`, `billing_start_date`, `created_at`, `updated_at`, `billing_end_date`, `contract_start_date`, `contract_end_date`) VALUES
(1, 'RQ0001', 'Recrruing', '2025-08-05', '2025-08-05 10:14:14', '2025-08-05 10:14:14', '2026-01-05', '2025-08-05', '2026-01-05'),
(2, 'RQ0002', 'Recrruing', '2025-08-14', '2025-08-17 22:58:54', '2025-08-17 23:14:41', '2025-09-14', '2025-08-14', '2025-09-14'),
(3, 'RQ0003', 'Recrruing', '2025-07-25', '2025-08-22 05:51:48', '2025-08-22 05:51:48', '2025-08-26', '2025-07-25', '2025-08-26'),
(4, 'RQ0004', 'Recrruing', '2025-07-25', '2025-08-22 05:59:31', '2025-08-22 05:59:31', '2025-08-26', '2025-07-25', '2025-08-26'),
(5, 'RQ0005', 'Recrruing', '2025-07-25', '2025-08-22 06:03:14', '2025-08-22 06:03:14', '2025-08-26', '2025-07-25', '2025-08-26'),
(6, 'RQ0006', 'Recrruing', '2025-07-25', '2025-08-22 06:20:05', '2025-08-22 06:20:05', '2025-08-26', '2025-07-25', '2025-08-26');

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `candidates`
--

INSERT INTO `candidates` (`CandidateID`, `Req_id_fk`, `Email`, `Resume`, `Final_rating`, `Feedback`, `Result`, `ProfileCreated`, `CoverLetter`, `Source`, `Score`, `Phone_no`, `candidate_first_name`, `candidate_last_name`) VALUES
(1, 'RQ0001', 'anand040593@gmail.com', 'Anand_Sivakumar_March.pdf', 5, 'good', 'Recommended', '2025-08-05 10:19:11', 'Resume.pdf', 'Refferal', 85, '8667735882', 'Aravind', 'Kumar');

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `candidate_approval`
--

INSERT INTO `candidate_approval` (`id`, `candidate_id`, `approver_id`, `role`, `decision`, `comment`, `reviewed_at`, `assigned_at`) VALUES
(1, 1, 1, 'MANAGER', 'Approve', NULL, '2025-08-05 10:23:13', '2025-08-05 10:22:49'),
(2, 1, 2, 'HR', 'Approve', NULL, '2025-08-05 10:27:12', '2025-08-05 10:22:49');

-- --------------------------------------------------------

--
-- Table structure for table `candidate_education`
--

DROP TABLE IF EXISTS `candidate_education`;
CREATE TABLE IF NOT EXISTS `candidate_education` (
  `id` int NOT NULL AUTO_INCREMENT,
  `submission_id` int NOT NULL,
  `qualification` varchar(50) DEFAULT NULL,
  `institution_city` varchar(200) DEFAULT NULL,
  `university_board` varchar(100) DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `program` varchar(100) DEFAULT NULL,
  `marks_or_cgpa` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `submission_id` (`submission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `candidate_employment`
--

DROP TABLE IF EXISTS `candidate_employment`;
CREATE TABLE IF NOT EXISTS `candidate_employment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `submission_id` int NOT NULL,
  `company_name` varchar(200) DEFAULT NULL,
  `address` text,
  `employment_type` varchar(50) DEFAULT NULL,
  `designation` varchar(100) DEFAULT NULL,
  `reported_to_name` varchar(100) DEFAULT NULL,
  `reported_to_position` varchar(100) DEFAULT NULL,
  `reported_to_contact` varchar(20) DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `emp_code_or_ssn` varchar(50) DEFAULT NULL,
  `monthly_salary` decimal(12,2) DEFAULT NULL,
  `pf_account_number` varchar(50) DEFAULT NULL,
  `reason_for_leaving` varchar(50) DEFAULT NULL,
  `mode_of_separation` varchar(50) DEFAULT NULL,
  `other_reason` text,
  PRIMARY KEY (`id`),
  KEY `submission_id` (`submission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `candidate_form_invite`
--

DROP TABLE IF EXISTS `candidate_form_invite`;
CREATE TABLE IF NOT EXISTS `candidate_form_invite` (
  `id` int NOT NULL AUTO_INCREMENT,
  `candidate_id` int NOT NULL,
  `token` char(36) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `expires_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `candidate_id` (`candidate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `candidate_form_invite`
--

INSERT INTO `candidate_form_invite` (`id`, `candidate_id`, `token`, `created_at`, `expires_at`) VALUES
(1, 1, '62a07b0354ed4740b75a440777ddb1d7', '2025-08-11 07:30:41', '2025-08-16 07:30:41'),
(2, 1, '77ec1658839b4e7cb042f3e3e3993d06', '2025-08-11 15:27:20', '2025-08-16 15:27:20');

-- --------------------------------------------------------

--
-- Table structure for table `candidate_interview_stages`
--

DROP TABLE IF EXISTS `candidate_interview_stages`;
CREATE TABLE IF NOT EXISTS `candidate_interview_stages` (
  `interview_stage_id` int NOT NULL AUTO_INCREMENT,
  `candidate_id` int NOT NULL DEFAULT '0',
  `Req_id` varchar(50) DEFAULT NULL,
  `interview_stage` varchar(500) NOT NULL DEFAULT '',
  `interview_date` date DEFAULT NULL,
  `mode_of_interview` varchar(500) NOT NULL DEFAULT '',
  `feedback` varchar(1000) NOT NULL DEFAULT '',
  `final_rating` int DEFAULT '0',
  `result` varchar(100) DEFAULT NULL,
  `status` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`interview_stage_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `candidate_interview_stages`
--

INSERT INTO `candidate_interview_stages` (`interview_stage_id`, `candidate_id`, `Req_id`, `interview_stage`, `interview_date`, `mode_of_interview`, `feedback`, `final_rating`, `result`, `status`) VALUES
(1, 1, 'RQ0001', 'Technical', '2025-08-04', 'online', 'good', 5, 'Selected', 'Completed'),
(2, 1, 'RQ0001', 'Communication', '2025-08-05', 'online', 'good', 5, 'Selected', 'Completed'),
(3, 1, 'RQ0001', 'Technical', '2025-07-25', 'zoom', '', 0, '', 'Stage Scheduled'),
(4, 1, 'RQ0001', 'Technical', '2025-07-25', 'zoom', '', 0, '', 'Stage Scheduled');

-- --------------------------------------------------------

--
-- Table structure for table `candidate_personal`
--

DROP TABLE IF EXISTS `candidate_personal`;
CREATE TABLE IF NOT EXISTS `candidate_personal` (
  `id` int NOT NULL AUTO_INCREMENT,
  `submission_id` int NOT NULL,
  `title` varchar(20) DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `submission_id` (`submission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `candidate_profile`
--

DROP TABLE IF EXISTS `candidate_profile`;
CREATE TABLE IF NOT EXISTS `candidate_profile` (
  `id` int NOT NULL AUTO_INCREMENT,
  `candidate_id` varchar(20) NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `date_of_joining` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `candidate_id` (`candidate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `candidate_profile`
--

INSERT INTO `candidate_profile` (`id`, `candidate_id`, `first_name`, `last_name`, `date_of_joining`) VALUES
(1, '1', 'Pankaj', 'Pundir', '2025-08-10');

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `candidate_reviews`
--

INSERT INTO `candidate_reviews` (`ReviewID`, `CandidateID`, `ParameterDefined`, `Guidelines`, `MinimumQuestions`, `ActualRating`, `Feedback`, `Created_at`) VALUES
(1, 1, 'Technical', 'Good', 5, 5.0, '', '2025-08-05 10:22:49'),
(2, 1, 'Communication', 'Good', 5, 5.0, '', '2025-08-05 10:22:49');

-- --------------------------------------------------------

--
-- Table structure for table `candidate_submission`
--

DROP TABLE IF EXISTS `candidate_submission`;
CREATE TABLE IF NOT EXISTS `candidate_submission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `candidate_id` int DEFAULT NULL,
  `recruiter_email` varchar(254) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `job_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `city` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `country` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `currency` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `salary` decimal(12,2) DEFAULT NULL,
  `variable_pay` decimal(12,2) DEFAULT NULL,
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `open_date` date DEFAULT NULL,
  `target_start_date` date DEFAULT NULL,
  `close_date` date DEFAULT NULL,
  `close_reason` text,
  `opening_salary_currency` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `opening_salary_range` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
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
-- Table structure for table `config_hiring_data`
--

DROP TABLE IF EXISTS `config_hiring_data`;
CREATE TABLE IF NOT EXISTS `config_hiring_data` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `category_name` varchar(500) NOT NULL DEFAULT '',
  `category_values` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `config_hiring_data`
--

INSERT INTO `config_hiring_data` (`id`, `category_name`, `category_values`) VALUES
(2, 'Position Role', 'Project Manager'),
(3, 'Position Role', 'Python developer'),
(4, 'Screening Type', 'Online Test'),
(5, 'Screening Type', 'Telephonic interview'),
(6, 'Score Card', 'Technical'),
(7, 'Score Card', 'Communication'),
(8, 'Location', 'Bangalore'),
(9, 'Designation', 'Senior Developer'),
(10, 'Designation', 'Software Engineer I'),
(11, 'Designation', 'Software Engineer II'),
(12, 'Tech Stack', 'Python'),
(13, 'Tech Stack', 'Django'),
(14, 'Tech Stack', 'AWS'),
(15, 'Target Companies', 'HCL'),
(16, 'Target Companies', 'Accenture'),
(17, 'Working Model', 'Onsite'),
(18, 'Working Model', 'Hybrid'),
(19, 'Working Model', 'WFH'),
(20, 'Role Type', 'Full Time'),
(21, 'Role Type', 'Part Time'),
(22, 'Job Type', 'Contract'),
(23, 'Job Type', 'Permanant'),
(24, 'Mode of Working', 'Hybrid'),
(25, 'Mode of Working', 'Work from home'),
(26, 'Shift Timings', 'Day Shift'),
(27, 'Shift Timings', 'Night Shift'),
(28, 'Education Qualification', 'BE'),
(29, 'Education Qualification', 'B Tech'),
(30, 'Education Qualification', 'MBA'),
(32, 'Education Qualification', 'M Tech'),
(33, 'Communication Language', 'English'),
(34, 'Communication Language', 'Hindi'),
(35, 'Communication Language', 'Tamil'),
(36, 'Location', 'Coimbatore'),
(37, 'Location', 'Chennai');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
-- Table structure for table `document_item`
--

DROP TABLE IF EXISTS `document_item`;
CREATE TABLE IF NOT EXISTS `document_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `candidate_id` int DEFAULT NULL,
  `category` enum('Education','Employment','Mandatory') DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `institution_name` varchar(100) DEFAULT NULL,
  `document_name` varchar(100) DEFAULT NULL,
  `document_status` varchar(50) DEFAULT NULL,
  `comment` text,
  `uploaded_file` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `candidate_id` (`candidate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `document_item`
--

INSERT INTO `document_item` (`id`, `candidate_id`, `category`, `type`, `institution_name`, `document_name`, `document_status`, `comment`, `uploaded_file`) VALUES
(10, 1, 'Education', '10th', 'N/A', '10th Document', 'Submitted', '', 'documents/Tushar__Bhatnagar_Resume_6DIu0go.pdf'),
(11, 1, 'Employment', 'Offer Letter', 'N/A', 'Offer Letter Document', 'Submitted', '', 'documents/RitikaDogra_14Years_DDP5432.pdf'),
(12, 1, 'Mandatory', 'PanCard', 'N/A', 'PanCard Document', 'Submitted', '', 'documents/Priyank20Sinha20Resume20May202024_52KLb4A.pdf');

-- --------------------------------------------------------

--
-- Table structure for table `financial_documents`
--

DROP TABLE IF EXISTS `financial_documents`;
CREATE TABLE IF NOT EXISTS `financial_documents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `candidate_id` int DEFAULT NULL,
  `pf_number` varchar(50) DEFAULT NULL,
  `uan_number` varchar(50) DEFAULT NULL,
  `pran_number` varchar(50) DEFAULT NULL,
  `form_16` varchar(255) DEFAULT NULL,
  `salary_slips` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `candidate_id` (`candidate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `financial_documents`
--

INSERT INTO `financial_documents` (`id`, `candidate_id`, `pf_number`, `uan_number`, `pran_number`, `form_16`, `salary_slips`) VALUES
(1, 1, 'PF123456', 'UAN987654', 'PRAN456789', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `generated_offer`
--

DROP TABLE IF EXISTS `generated_offer`;
CREATE TABLE IF NOT EXISTS `generated_offer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `requisition_id` int NOT NULL,
  `candidate_id` int NOT NULL,
  `recruiter_email` varchar(254) NOT NULL,
  `job_title` varchar(100) NOT NULL,
  `job_city` varchar(100) NOT NULL,
  `job_country` varchar(100) NOT NULL,
  `currency` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `estimated_start_date` date DEFAULT NULL,
  `negotiation_status` varchar(20) NOT NULL DEFAULT 'Generated',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `requisition_id` (`requisition_id`),
  KEY `candidate_id` (`candidate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `generated_offer`
--

INSERT INTO `generated_offer` (`id`, `requisition_id`, `candidate_id`, `recruiter_email`, `job_title`, `job_city`, `job_country`, `currency`, `estimated_start_date`, `negotiation_status`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 'pixelreq@gmail.com', 'Senior Software engineer', 'Select city', 'India', 'INR', '2025-08-12', 'Generated', '2025-08-05 11:13:46', '2025-08-05 11:13:46');

-- --------------------------------------------------------

--
-- Table structure for table `insurance_detail`
--

DROP TABLE IF EXISTS `insurance_detail`;
CREATE TABLE IF NOT EXISTS `insurance_detail` (
  `id` int NOT NULL AUTO_INCREMENT,
  `candidate_id` int DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `candidate_id` (`candidate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `insurance_detail`
--

INSERT INTO `insurance_detail` (`id`, `candidate_id`, `first_name`, `last_name`, `dob`) VALUES
(1, 1, 'Asha', 'Pundir', '1965-05-10'),
(2, 1, 'Asha', 'Pundir', '1965-05-10'),
(3, 1, 'Asha', 'Pundir', '1965-05-10'),
(4, 1, 'Asha', 'Pundir', '1965-05-10'),
(5, 1, 'Asha', 'Pundir', '1965-05-10');

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
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `interviewer`
--

INSERT INTO `interviewer` (`interviewer_id`, `req_id`, `client_id`, `first_name`, `last_name`, `job_title`, `interview_mode`, `interviewer_stage`, `email`, `contact_number`, `created_at`, `user_id`) VALUES
(1, 'RQ0001', '', 'Anand', 'Sivakumar', 'Software Engineer', 'online', 'Technical', 'anandsivakumar27@gmail.com', NULL, '2025-08-05 10:17:28', NULL),
(2, 'RQ0001', '', 'Rajkumar', 'R', 'Software Engineer', 'online', 'Communication', 'anand040593@gmail.com', NULL, '2025-08-05 10:18:16', NULL);

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
  `ParameterDefined` json DEFAULT NULL,
  `Guidelines` json DEFAULT NULL,
  `MinimumQuestions` json DEFAULT NULL,
  `ActualRating` json DEFAULT NULL,
  `Weightage` int DEFAULT '0',
  `Feedback_param` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `candidate_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_schedule` (`schedule_id`),
  KEY `fk_candidate_review` (`candidate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `interview_review`
--

INSERT INTO `interview_review` (`id`, `schedule_id`, `feedback`, `result`, `reviewed_at`, `ParameterDefined`, `Guidelines`, `MinimumQuestions`, `ActualRating`, `Weightage`, `Feedback_param`, `created_at`, `candidate_id`) VALUES
(1, 1, '', '', '2025-08-05 10:25:27', '\"Technical\"', '\"good\"', '5', '4', 50, '\"good\"', '2025-08-05 10:25:27', 1),
(2, 1, '', '', '2025-08-05 11:00:13', '\"communication\"', '\"good\"', '\"5\"', '5', 50, '\"good\"', '2025-08-05 05:30:13', 1);

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `interview_schedule`
--

INSERT INTO `interview_schedule` (`id`, `candidate_id`, `interviewer_id`, `round_name`, `date`, `start_time`, `end_time`, `meet_link`, `created_at`, `location`, `time_zone`, `purpose`, `mode`, `guests`, `durations`) VALUES
(1, 1, 1, 'Technical', '2025-08-04', '15:00:00', '15:30:00', 'https://us05web.zoom.us/j/84636259845?pwd=41g5dCoVmdWvao7EyH2y2TybpFtbRL.1', '2025-08-05 10:24:12', 'Zoom', 'IST', 'Technical', 'online', '[]', '30 mins'),
(2, 1, 2, 'Communication', '2025-08-05', '14:30:00', '15:00:00', 'https://us05web.zoom.us/j/84593624190?pwd=Ds8lJO7SOsveed2DKyC132vQKP245e.1', '2025-08-05 10:24:29', 'Zoom', 'IST', 'Communication', 'online', '[]', '30 mins'),
(3, 1, 1, 'Technical', '2025-07-25', '11:30:00', '12:00:00', 'https://us05web.zoom.us/j/87199267376?pwd=Vh8Sho5CGg49uJTRAGs6Rs0387Nhp7.1', '2025-08-23 04:13:17', 'Zoom', 'IST', 'Technical', 'zoom', '[{\"name\": \"asdasd\", \"email\": \"marshalmiller143@gmail.com\"}]', '30 mins'),
(4, 1, 1, 'Technical', '2025-07-25', '11:30:00', '12:00:00', 'https://us05web.zoom.us/j/84486405394?pwd=BniJFb9mJIimkbSuxwkU3bo61MZhC0.1', '2025-08-23 04:14:11', 'Zoom', 'IST', 'Technical', 'zoom', '[{\"name\": \"asdasd\", \"email\": \"marshalmiller143@gmail.com\"}]', '30 mins');

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
  `round_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `int_fk_id` (`interviewer_id`),
  KEY `fk_round_id` (`round_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `interview_slot`
--

INSERT INTO `interview_slot` (`id`, `interviewer_id`, `date`, `start_time`, `end_time`, `created_at`, `round_id`) VALUES
(1, 1, '2025-08-04', '15:00:00', '16:00:00', '2025-08-05 10:17:28', NULL),
(2, 2, '2025-08-05', '14:30:00', '15:30:00', '2025-08-05 10:18:16', NULL);

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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `jobrequisition`
--

INSERT INTO `jobrequisition` (`id`, `RequisitionID`, `Planning_id`, `PositionTitle`, `HiringManagerID`, `Recruiter`, `No_of_positions`, `LegalEntityID`, `QualificationID`, `CommentFromBusinessOps`, `company_client_name`, `client_id`, `Status`, `CreatedDate`, `UpdatedDate`, `requisition_date`, `due_requisition_date`) VALUES
(1, 'RQ0001', '1', 'Software Engineer', 1, 'Not Assigned', 25, '0', 'B.Tech', 'good', 'Accenture', 'CL0001', 'Approved', '2025-08-05 10:12:44', '2025-08-05 10:18:43', '2025-08-05', '2025-09-05'),
(2, 'RQ0002', NULL, 'Software Engineer', 1, 'Not Assigned', 25, '0', 'B.Tech', '', 'CloudNexa', 'CL0002', 'Pending Approval', '2025-08-17 02:53:13', '2025-08-17 23:14:41', '2025-08-15', '2025-08-16'),
(3, 'RQ0003', NULL, 'Software Engineer', 1, 'Not Assigned', 25, '0', 'B.Tech', '', 'HCL', 'CL0003', 'Pending Approval', '2025-08-22 05:49:56', '2025-08-22 05:51:48', '2025-07-26', '2025-08-09'),
(4, 'RQ0004', NULL, 'Software Engineer', 1, 'Not Assigned', 25, '0', 'B.Tech', '', 'HCL', 'CL0004', 'Pending Approval', '2025-08-22 05:59:22', '2025-08-22 05:59:31', '2025-07-26', '2025-08-09'),
(5, 'RQ0005', NULL, 'Software Engineer', 1, 'Not Assigned', 25, '0', 'B.Tech', '', 'HCL', 'CL0005', 'Pending Approval', '2025-08-22 06:03:05', '2025-08-22 06:03:14', '2025-07-26', '2025-08-09'),
(6, 'RQ0006', NULL, 'Software Engineer', 1, 'Not Assigned', 25, '0', 'B.Tech', '', 'HCL', 'CL0006', 'Pending Approval', '2025-08-22 06:18:25', '2025-08-22 06:20:05', '2025-07-26', '2025-08-09');

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
  `bg_verification_type` varchar(255) DEFAULT NULL,
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
  `job_health_requirement` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `social_media_links` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `social_media_data` text,
  `compensation_range` varchar(255) DEFAULT NULL,
  `language_proficiency` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `requisition_template` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `no_of_openings` int DEFAULT '0',
  `Created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `mode_of_working` varchar(255) DEFAULT NULL,
  `relocation_amount` varchar(255) DEFAULT NULL,
  `domain_yn` varchar(255) DEFAULT NULL,
  `domain_name` varchar(255) DEFAULT NULL,
  `citizen_describe` varchar(255) DEFAULT NULL,
  `health_describe` varchar(255) DEFAULT NULL,
  `education_qualification` varchar(255) DEFAULT NULL,
  `visa_country` varchar(255) DEFAULT NULL,
  `visa_type` varchar(255) DEFAULT NULL,
  `github_link` varchar(255) DEFAULT NULL,
  `currency_type` varchar(50) DEFAULT NULL,
  `relocation_currency_type` varchar(50) DEFAULT NULL,
  `sub_domain_name` varchar(255) DEFAULT NULL,
  `citizen_countries` varchar(255) DEFAULT NULL,
  `job_role` varchar(255) DEFAULT NULL,
  `domain_details` json DEFAULT NULL,
  `visa_details` json DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `job_hiring_overview`
--

INSERT INTO `job_hiring_overview` (`id`, `hiring_plan_id`, `job_position`, `tech_stacks`, `jd_details`, `designation`, `experience_range`, `target_companies`, `compensation`, `working_model`, `interview_status`, `location`, `education_decision`, `relocation`, `travel_opportunities`, `domain_knowledge`, `visa_requirements`, `background_verification`, `bg_verification_type`, `shift_timings`, `role_type`, `job_type`, `communication_language`, `notice_period`, `additional_comp`, `citizen_requirement`, `career_gap`, `sabbatical`, `screening_questions`, `job_health_requirement`, `social_media_links`, `social_media_data`, `compensation_range`, `language_proficiency`, `requisition_template`, `no_of_openings`, `Created_at`, `mode_of_working`, `relocation_amount`, `domain_yn`, `domain_name`, `citizen_describe`, `health_describe`, `education_qualification`, `visa_country`, `visa_type`, `github_link`, `currency_type`, `relocation_currency_type`, `sub_domain_name`, `citizen_countries`, `job_role`, `domain_details`, `visa_details`) VALUES
(1, 'PL0001', 'Python developer', 'Python, AWS', '<p>sample</p>', 'Software Engineer I', '5-10', 'Accenture', NULL, 'Hybrid', NULL, 'Coimbatore', NULL, 'Yes', '55', NULL, 'Yes', 'Yes', 'Basic', 'Day Shift', 'Full Time', 'Permanant', 'English', NULL, NULL, 'Yes', 'Yes', NULL, NULL, 'Yes', ':', '[{\'media_type\': \'\', \'media_link\': \'\'}]', '0-5', 'Advanced', NULL, 25, '2025-08-05 10:12:13', NULL, '2000', 'Yes', 'Finance', 'indian', 'good', 'B Tech', 'USA', 'H1B', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2, 'PL0002', 'Software Engineer I - Python developer', 'Python, AWS', '<p>adfaddddddddddddddddddddddddddddddddddddddddddddddddddddddddddvvvvvvvvvvvcsssssaddddddddddddddddddddddddddd</p>', 'Software Engineer I', '5-10', 'HCL', NULL, 'Onsite', NULL, 'San Francisco', NULL, 'Yes', '55', NULL, 'Yes', 'Yes', 'Aadhar', 'Day Shift', 'Full Time', 'Permanant', '', NULL, NULL, 'Yes', 'Yes', NULL, NULL, NULL, NULL, 'linkedin: ', '0-5', NULL, NULL, 25, '2025-08-17 00:15:31', NULL, '25000', 'Yes', 'Finance', NULL, NULL, 'BE', 'USA', 'h1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(3, 'PL0003', 'Senior Developer - Project Manager', 'Python', '<p>fwefewfdwe</p>', 'Senior Developer', '3', 'HCL', NULL, 'Onsite', NULL, 'New York', NULL, 'Yes', '20', NULL, 'Yes', 'Yes', 'dsfas', 'Day Shift', 'Full Time', 'Permanant', 'Hindi:Intermediate, English:Beginner', NULL, NULL, 'Yes', 'Yes', NULL, NULL, NULL, NULL, 'dsadsa: ', '0-4', NULL, NULL, 4, '2025-08-17 01:55:31', NULL, '1000', 'Yes', '43rew', NULL, NULL, 'BE', 'dasdas', 'dasdsa', NULL, 'INR', 'USA', 'efwfwe', 'dasd, dasdas', NULL, NULL, NULL),
(4, 'PL0004', 'Senior Developer - Senior Developer - Senior Developer - Python developer', 'Python', '<p>cdscds</p>', 'Senior Developer', '0-5', 'HCL', NULL, 'Onsite', NULL, 'Bangalore', NULL, 'Yes', '20', NULL, 'Yes', 'Yes', 'Advances, Credit Check', 'Day Shift', 'Full Time', 'Contract', 'English:Beginner, Hindi:Beginner', NULL, NULL, 'Yes', 'Yes', NULL, NULL, NULL, NULL, 'dsadas: \ndas: ', '', NULL, NULL, 2, '2025-08-23 23:04:09', NULL, '1000', 'Yes', '', NULL, NULL, 'BE', '', '', NULL, 'INR', 'INR', '', 'dasdasd, dasdas', 'Senior Developer - Senior Developer - Python developer', '[{\"domain_name\": \"fdsf\", \"sub_domain_name\": \"fsdfd\"}, {\"domain_name\": \"fsdf\", \"sub_domain_name\": \"fsdf\"}]', '[{\"visa_type\": \"fdfsdf\", \"visa_country\": \"fdfds\"}, {\"visa_type\": \"fdsfds\", \"visa_country\": \"fdsf\"}]');

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
  `Weightage` int NOT NULL DEFAULT '0',
  `mode` varchar(1000) NOT NULL DEFAULT '',
  `feedback` varchar(500) NOT NULL DEFAULT '',
  `duration_metric` varchar(50) DEFAULT 'days',
  PRIMARY KEY (`interview_desing_params_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `job_interview_design_parameters`
--

INSERT INTO `job_interview_design_parameters` (`interview_desing_params_id`, `hiring_plan_id`, `interview_design_id`, `score_card`, `options`, `guideline`, `min_questions`, `screen_type`, `duration`, `Weightage`, `mode`, `feedback`, `duration_metric`) VALUES
(1, '', 1, 'Technical', 'Required', 'Good', 5, 'online', 60, 50, 'online', 'Good', 'days'),
(2, '', 1, 'Communication', 'Required', 'Good', 5, 'online', 60, 50, 'online', 'Good', 'days'),
(3, '', 2, 'Technical', '21', '12', 12, '12', 21, 12, '', '12', 'days');

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `job_interview_design_screen`
--

INSERT INTO `job_interview_design_screen` (`interview_design_id`, `hiring_plan_id`, `req_id`, `position_role`, `tech_stacks`, `screening_type`, `no_of_interview_round`, `final_rating`, `status`, `feedback`) VALUES
(1, 'PL0001', 'RQ0001', '', 'Python, AWS', 'Online Test', 2, 0, '', ''),
(2, 'PL0001', 'RQ0001', '', 'Python, AWS', '', 1, 0, '', '');

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `job_interview_planning`
--

INSERT INTO `job_interview_planning` (`interview_plan_id`, `hiring_plan_id`, `requisition_id`, `dead_line_days`, `offer_decline`, `working_hours_per_day`, `no_of_roles_to_hire`, `conversion_ratio`, `elimination`, `avg_interviewer_time_per_week_hrs`, `interview_round`, `interview_time_per_round`, `interviewer_leave_days`, `no_of_month_interview_happens`, `working_hrs_per_week`, `required_candidate`, `decline_adjust_count`, `total_candidate_pipline`, `total_interviews_needed`, `total_interview_hrs`, `total_interview_weeks`, `no_of_interviewer_need`, `leave_adjustment`) VALUES
(1, 'PL0001', 'RQ0001', 10, 0, 8, 25, 12, 0, 12, 2, 1, 10, 2, 40, 300, 0, 300, 600, 600, 15, 60, 150);

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
-- Table structure for table `nominee`
--

DROP TABLE IF EXISTS `nominee`;
CREATE TABLE IF NOT EXISTS `nominee` (
  `id` int NOT NULL AUTO_INCREMENT,
  `candidate_id` int DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `share_percentage` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `candidate_id` (`candidate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `nominee`
--

INSERT INTO `nominee` (`id`, `candidate_id`, `first_name`, `last_name`, `share_percentage`) VALUES
(1, 1, 'Asha', 'Pundir', 50),
(2, 1, 'Asha', 'Pundir', 50),
(3, 1, 'Asha', 'Pundir', 50),
(4, 1, 'Asha', 'Pundir', 50),
(5, 1, 'Asha', 'Pundir', 50);

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
  `client_id` varchar(50) DEFAULT NULL,
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
  `candidate_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `fk_candidate_offer` (`candidate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `offer_negotiation`
--

INSERT INTO `offer_negotiation` (`id`, `requisition_id`, `client_name`, `client_id`, `first_name`, `last_name`, `position_applied`, `expected_salary`, `offered_salary`, `expected_title`, `offered_title`, `expected_location`, `offered_location`, `expected_doj`, `offered_doj`, `expected_work_mode`, `offered_work_mode`, `negotiation_status`, `comments`, `created_at`, `updated_at`, `candidate_id`) VALUES
(2, 'RQ0001', 'Accenture', 'CL0001', 'Aravind', 'Kumar', 'Software Engineer', 2000000.00, 15000000.00, 'Senior Software engineer', 'Senior Software engineer', 'Bangalore', 'Bangalore', '2025-08-14', '2025-08-12', 'Remote', 'Hybrid', 'Successful', 'good to go', '2025-08-05 05:33:24', '2025-08-05 10:26:19', 1);

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
-- Table structure for table `offer_salary_component`
--

DROP TABLE IF EXISTS `offer_salary_component`;
CREATE TABLE IF NOT EXISTS `offer_salary_component` (
  `id` int NOT NULL AUTO_INCREMENT,
  `offer_id` int NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `value` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `offer_id` (`offer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `offer_salary_component`
--

INSERT INTO `offer_salary_component` (`id`, `offer_id`, `name`, `value`) VALUES
(1, 1, 'Base Salary', '15000000.00');

-- --------------------------------------------------------

--
-- Table structure for table `offer_variable_pay_component`
--

DROP TABLE IF EXISTS `offer_variable_pay_component`;
CREATE TABLE IF NOT EXISTS `offer_variable_pay_component` (
  `id` int NOT NULL AUTO_INCREMENT,
  `offer_id` int NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `value` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `offer_id` (`offer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_details`
--

DROP TABLE IF EXISTS `personal_details`;
CREATE TABLE IF NOT EXISTS `personal_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `candidate_id` int DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `marital_status` varchar(20) DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `permanent_address` text,
  `present_address` text,
  `blood_group` varchar(5) DEFAULT NULL,
  `emergency_contact_name` varchar(100) DEFAULT NULL,
  `emergency_contact_number` varchar(20) DEFAULT NULL,
  `photograph` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `candidate_id` (`candidate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `personal_details`
--

INSERT INTO `personal_details` (`id`, `candidate_id`, `dob`, `marital_status`, `gender`, `permanent_address`, `present_address`, `blood_group`, `emergency_contact_name`, `emergency_contact_number`, `photograph`) VALUES
(1, 1, '1990-01-01', 'Single', 'Male', '123 Main St', '456 Elm St', 'O+', 'Raj', '9876543210', 'photographs/Anand_zLeShDD.JPG');

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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `posting_details`
--

INSERT INTO `posting_details` (`id`, `requisition_id`, `experience`, `designation`, `job_category`, `job_region`, `internal_job_description`, `external_job_description`, `qualification`, `created_at`, `updated_at`) VALUES
(1, 'RQ0001', '2-5 years', 'senior_developer', '', 'Asia', '<p>Sample</p>', '<p>sample</p>', 'mtech', '2025-08-05 10:14:14', '2025-08-05 10:14:14'),
(2, 'RQ0002', '2-5 years', 'team_lead', '', 'Asia', '<p>sample</p>', '<p>sample</p>', 'mtech', '2025-08-17 22:58:54', '2025-08-17 23:14:41'),
(3, 'RQ0003', '2-5 years', 'software_engineer', '', 'north_america', '<p class=\"ql-align-center\"><br></p><p> <strong>Software Application Developer</strong></p><p>   </p><p class=\"ql-align-center\"><strong>Responsibilities</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Develop and implement new software programs.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Maintain and improve the performance of existing software.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Clearly and regularly communicate with management and technical support colleagues</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Design and update software database</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Test and maintain software products to ensure strong functionality and optimization</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Recommend improvements to existing software programs as necessary</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Update existing applications to meet the security and functionality standards</p><p>as outlined in the company’s website policies</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Troubleshoot and debug applications</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Evaluate existing applications to reprogram, update and add new features</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Develop technical documents and handbooks to accurately represent application design and code</p><p class=\"ql-align-center\">   <strong>Qualification</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Bachelor’s Degree in Computer Science or relevant.</p><p>   </p><p><br></p><p><br></p><p class=\"ql-align-center\"><strong>Experience</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Overall 5-7 years’ experience in web and software development</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Demonstrated knowledge of web technologies</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ability to work independently and multi-task effectively</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Demonstrated understanding of projects from the perspective of business stakeholders and end users.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Flexible and willing to accept a change in priorities as necessary</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Strong attention to detail</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Proven knowledge of the most current security and web development programming languages</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;In-depth knowledge of programming for diverse operating systems and platforms using development tools</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Excellent understanding of software design and programming principles.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Certified application developer is a plus</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;In-depth knowledge of programming for diverse operating systems and platforms using development tools</p><p>   </p><p class=\"ql-align-center\"><strong>Skill Set</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Web application development Including C#, ASP.NET (Web Forms and MVC), ASP.NET Web APIs, HTML, JavaScript, Angular 2+, SharePoint (2013, 2016, Online), jQuery, Object Oriented Programming and Design, Design Patterns, Web Services</p><p>&nbsp;</p>', '<p> <strong>Software Application Developer</strong></p><p>   </p><p class=\"ql-align-center\"><strong>Responsibilities</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Develop and implement new software programs.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Maintain and improve the performance of existing software.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Clearly and regularly communicate with management and technical support colleagues</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Design and update software database</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Test and maintain software products to ensure strong functionality and optimization</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Recommend improvements to existing software programs as necessary</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Update existing applications to meet the security and functionality standards</p><p>as outlined in the company’s website policies</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Troubleshoot and debug applications</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Evaluate existing applications to reprogram, update and add new features</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Develop technical documents and handbooks to accurately represent application design and code</p><p class=\"ql-align-center\">   <strong>Qualification</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Bachelor’s Degree in Computer Science or relevant.</p><p>   </p><p><br></p><p><br></p><p class=\"ql-align-center\"><strong>Experience</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Overall 5-7 years’ experience in web and software development</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Demonstrated knowledge of web technologies</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ability to work independently and multi-task effectively</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Demonstrated understanding of projects from the perspective of business stakeholders and end users.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Flexible and willing to accept a change in priorities as necessary</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Strong attention to detail</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Proven knowledge of the most current security and web development programming languages</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;In-depth knowledge of programming for diverse operating systems and platforms using development tools</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Excellent understanding of software design and programming principles.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Certified application developer is a plus</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;In-depth knowledge of programming for diverse operating systems and platforms using development tools</p><p>   </p><p class=\"ql-align-center\"><strong>Skill Set</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Web application development Including C#, ASP.NET (Web Forms and MVC), ASP.NET Web APIs, HTML, JavaScript, Angular 2+, SharePoint (2013, 2016, Online), jQuery, Object Oriented Programming and Design, Design Patterns, Web Services</p>', 'mtech', '2025-08-22 05:51:48', '2025-08-22 05:51:48'),
(4, 'RQ0004', '2-5 years', 'software_engineer', '', 'north_america', '<p class=\"ql-align-center\"><br></p><p> <strong>Software Application Developer</strong></p><p>   </p><p class=\"ql-align-center\"><strong>Responsibilities</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Develop and implement new software programs.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Maintain and improve the performance of existing software.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Clearly and regularly communicate with management and technical support colleagues</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Design and update software database</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Test and maintain software products to ensure strong functionality and optimization</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Recommend improvements to existing software programs as necessary</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Update existing applications to meet the security and functionality standards</p><p>as outlined in the company’s website policies</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Troubleshoot and debug applications</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Evaluate existing applications to reprogram, update and add new features</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Develop technical documents and handbooks to accurately represent application design and code</p><p class=\"ql-align-center\">   <strong>Qualification</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Bachelor’s Degree in Computer Science or relevant.</p><p>   </p><p><br></p><p><br></p><p class=\"ql-align-center\"><strong>Experience</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Overall 5-7 years’ experience in web and software development</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Demonstrated knowledge of web technologies</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ability to work independently and multi-task effectively</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Demonstrated understanding of projects from the perspective of business stakeholders and end users.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Flexible and willing to accept a change in priorities as necessary</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Strong attention to detail</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Proven knowledge of the most current security and web development programming languages</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;In-depth knowledge of programming for diverse operating systems and platforms using development tools</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Excellent understanding of software design and programming principles.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Certified application developer is a plus</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;In-depth knowledge of programming for diverse operating systems and platforms using development tools</p><p>   </p><p class=\"ql-align-center\"><strong>Skill Set</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Web application development Including C#, ASP.NET (Web Forms and MVC), ASP.NET Web APIs, HTML, JavaScript, Angular 2+, SharePoint (2013, 2016, Online), jQuery, Object Oriented Programming and Design, Design Patterns, Web Services</p><p>&nbsp;</p>', '<p> <strong>Software Application Developer</strong></p><p>   </p><p class=\"ql-align-center\"><strong>Responsibilities</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Develop and implement new software programs.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Maintain and improve the performance of existing software.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Clearly and regularly communicate with management and technical support colleagues</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Design and update software database</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Test and maintain software products to ensure strong functionality and optimization</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Recommend improvements to existing software programs as necessary</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Update existing applications to meet the security and functionality standards</p><p>as outlined in the company’s website policies</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Troubleshoot and debug applications</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Evaluate existing applications to reprogram, update and add new features</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Develop technical documents and handbooks to accurately represent application design and code</p><p class=\"ql-align-center\">   <strong>Qualification</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Bachelor’s Degree in Computer Science or relevant.</p><p>   </p><p><br></p><p><br></p><p class=\"ql-align-center\"><strong>Experience</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Overall 5-7 years’ experience in web and software development</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Demonstrated knowledge of web technologies</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ability to work independently and multi-task effectively</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Demonstrated understanding of projects from the perspective of business stakeholders and end users.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Flexible and willing to accept a change in priorities as necessary</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Strong attention to detail</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Proven knowledge of the most current security and web development programming languages</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;In-depth knowledge of programming for diverse operating systems and platforms using development tools</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Excellent understanding of software design and programming principles.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Certified application developer is a plus</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;In-depth knowledge of programming for diverse operating systems and platforms using development tools</p><p>   </p><p class=\"ql-align-center\"><strong>Skill Set</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Web application development Including C#, ASP.NET (Web Forms and MVC), ASP.NET Web APIs, HTML, JavaScript, Angular 2+, SharePoint (2013, 2016, Online), jQuery, Object Oriented Programming and Design, Design Patterns, Web Services</p>', 'mtech', '2025-08-22 05:59:31', '2025-08-22 05:59:31'),
(5, 'RQ0005', '2-5 years', 'software_engineer', '', 'north_america', '<p class=\"ql-align-center\"><br></p><p> <strong>Software Application Developer</strong></p><p>   </p><p class=\"ql-align-center\"><strong>Responsibilities</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Develop and implement new software programs.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Maintain and improve the performance of existing software.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Clearly and regularly communicate with management and technical support colleagues</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Design and update software database</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Test and maintain software products to ensure strong functionality and optimization</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Recommend improvements to existing software programs as necessary</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Update existing applications to meet the security and functionality standards</p><p>as outlined in the company’s website policies</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Troubleshoot and debug applications</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Evaluate existing applications to reprogram, update and add new features</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Develop technical documents and handbooks to accurately represent application design and code</p><p class=\"ql-align-center\">   <strong>Qualification</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Bachelor’s Degree in Computer Science or relevant.</p><p>   </p><p><br></p><p><br></p><p class=\"ql-align-center\"><strong>Experience</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Overall 5-7 years’ experience in web and software development</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Demonstrated knowledge of web technologies</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ability to work independently and multi-task effectively</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Demonstrated understanding of projects from the perspective of business stakeholders and end users.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Flexible and willing to accept a change in priorities as necessary</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Strong attention to detail</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Proven knowledge of the most current security and web development programming languages</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;In-depth knowledge of programming for diverse operating systems and platforms using development tools</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Excellent understanding of software design and programming principles.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Certified application developer is a plus</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;In-depth knowledge of programming for diverse operating systems and platforms using development tools</p><p>   </p><p class=\"ql-align-center\"><strong>Skill Set</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Web application development Including C#, ASP.NET (Web Forms and MVC), ASP.NET Web APIs, HTML, JavaScript, Angular 2+, SharePoint (2013, 2016, Online), jQuery, Object Oriented Programming and Design, Design Patterns, Web Services</p><p>&nbsp;</p>', '<p> <strong>Software Application Developer</strong></p><p>   </p><p class=\"ql-align-center\"><strong>Responsibilities</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Develop and implement new software programs.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Maintain and improve the performance of existing software.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Clearly and regularly communicate with management and technical support colleagues</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Design and update software database</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Test and maintain software products to ensure strong functionality and optimization</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Recommend improvements to existing software programs as necessary</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Update existing applications to meet the security and functionality standards</p><p>as outlined in the company’s website policies</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Troubleshoot and debug applications</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Evaluate existing applications to reprogram, update and add new features</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Develop technical documents and handbooks to accurately represent application design and code</p><p class=\"ql-align-center\">   <strong>Qualification</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Bachelor’s Degree in Computer Science or relevant.</p><p>   </p><p><br></p><p><br></p><p class=\"ql-align-center\"><strong>Experience</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Overall 5-7 years’ experience in web and software development</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Demonstrated knowledge of web technologies</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ability to work independently and multi-task effectively</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Demonstrated understanding of projects from the perspective of business stakeholders and end users.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Flexible and willing to accept a change in priorities as necessary</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Strong attention to detail</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Proven knowledge of the most current security and web development programming languages</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;In-depth knowledge of programming for diverse operating systems and platforms using development tools</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Excellent understanding of software design and programming principles.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Certified application developer is a plus</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;In-depth knowledge of programming for diverse operating systems and platforms using development tools</p><p>   </p><p class=\"ql-align-center\"><strong>Skill Set</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Web application development Including C#, ASP.NET (Web Forms and MVC), ASP.NET Web APIs, HTML, JavaScript, Angular 2+, SharePoint (2013, 2016, Online), jQuery, Object Oriented Programming and Design, Design Patterns, Web Services</p>', 'mtech', '2025-08-22 06:03:14', '2025-08-22 06:03:14'),
(6, 'RQ0006', '2-5 years', 'software_engineer', '', 'north_america', '<p class=\"ql-align-center\"><br></p><p> <strong>Software Application Developer</strong></p><p>   </p><p class=\"ql-align-center\"><strong>Responsibilities</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Develop and implement new software programs.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Maintain and improve the performance of existing software.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Clearly and regularly communicate with management and technical support colleagues</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Design and update software database</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Test and maintain software products to ensure strong functionality and optimization</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Recommend improvements to existing software programs as necessary</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Update existing applications to meet the security and functionality standards</p><p>as outlined in the company’s website policies</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Troubleshoot and debug applications</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Evaluate existing applications to reprogram, update and add new features</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Develop technical documents and handbooks to accurately represent application design and code</p><p class=\"ql-align-center\">   <strong>Qualification</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Bachelor’s Degree in Computer Science or relevant.</p><p>   </p><p><br></p><p><br></p><p class=\"ql-align-center\"><strong>Experience</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Overall 5-7 years’ experience in web and software development</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Demonstrated knowledge of web technologies</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ability to work independently and multi-task effectively</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Demonstrated understanding of projects from the perspective of business stakeholders and end users.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Flexible and willing to accept a change in priorities as necessary</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Strong attention to detail</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Proven knowledge of the most current security and web development programming languages</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;In-depth knowledge of programming for diverse operating systems and platforms using development tools</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Excellent understanding of software design and programming principles.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Certified application developer is a plus</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;In-depth knowledge of programming for diverse operating systems and platforms using development tools</p><p>   </p><p class=\"ql-align-center\"><strong>Skill Set</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Web application development Including C#, ASP.NET (Web Forms and MVC), ASP.NET Web APIs, HTML, JavaScript, Angular 2+, SharePoint (2013, 2016, Online), jQuery, Object Oriented Programming and Design, Design Patterns, Web Services</p><p>&nbsp;</p>', '<p> <strong>Software Application Developer</strong></p><p>   </p><p class=\"ql-align-center\"><strong>Responsibilities</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Develop and implement new software programs.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Maintain and improve the performance of existing software.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Clearly and regularly communicate with management and technical support colleagues</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Design and update software database</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Test and maintain software products to ensure strong functionality and optimization</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Recommend improvements to existing software programs as necessary</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Update existing applications to meet the security and functionality standards</p><p>as outlined in the company’s website policies</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Troubleshoot and debug applications</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Evaluate existing applications to reprogram, update and add new features</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Develop technical documents and handbooks to accurately represent application design and code</p><p class=\"ql-align-center\">   <strong>Qualification</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Bachelor’s Degree in Computer Science or relevant.</p><p>   </p><p><br></p><p><br></p><p class=\"ql-align-center\"><strong>Experience</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Overall 5-7 years’ experience in web and software development</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Demonstrated knowledge of web technologies</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ability to work independently and multi-task effectively</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Demonstrated understanding of projects from the perspective of business stakeholders and end users.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Flexible and willing to accept a change in priorities as necessary</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Strong attention to detail</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Proven knowledge of the most current security and web development programming languages</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;In-depth knowledge of programming for diverse operating systems and platforms using development tools</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Excellent understanding of software design and programming principles.</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Certified application developer is a plus</p><p>·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;In-depth knowledge of programming for diverse operating systems and platforms using development tools</p><p>   </p><p class=\"ql-align-center\"><strong>Skill Set</strong></p><p> ·&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Web application development Including C#, ASP.NET (Web Forms and MVC), ASP.NET Web APIs, HTML, JavaScript, Angular 2+, SharePoint (2013, 2016, Online), jQuery, Object Oriented Programming and Design, Design Patterns, Web Services</p>', 'mtech', '2025-08-22 06:20:05', '2025-08-22 06:20:05');

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
-- Table structure for table `reference_check`
--

DROP TABLE IF EXISTS `reference_check`;
CREATE TABLE IF NOT EXISTS `reference_check` (
  `id` int NOT NULL AUTO_INCREMENT,
  `candidate_id` int DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `designation` varchar(100) DEFAULT NULL,
  `reporting_manager_name` varchar(100) DEFAULT NULL,
  `official_email` varchar(254) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `candidate_id` (`candidate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `reference_check`
--

INSERT INTO `reference_check` (`id`, `candidate_id`, `first_name`, `last_name`, `designation`, `reporting_manager_name`, `official_email`, `phone_number`) VALUES
(1, 1, 'Amit', 'Verma', 'Manager', 'Suresh', 'amit@example.com', '9998887771'),
(2, 1, 'Amit', 'Verma', 'Manager', 'Suresh', 'amit@example.com', '9998887771'),
(3, 1, 'Amit', 'Verma', 'Manager', 'Suresh', 'amit@example.com', '9998887771'),
(4, 1, 'Amit', 'Verma', 'Manager', 'Suresh', 'amit@example.com', '9998887771'),
(5, 1, 'Amit', 'Verma', 'Manager', 'Suresh', 'amit@example.com', '9998887771');

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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `requisition_details`
--

INSERT INTO `requisition_details` (`id`, `requisition_id`, `internal_title`, `external_title`, `job_position`, `business_line`, `business_unit`, `division`, `department`, `location`, `geo_zone`, `employee_group`, `employee_sub_group`, `contract_start_date`, `contract_end_date`, `career_level`, `company_client_name`, `client_id`, `band`, `sub_band`, `primary_skills`, `secondary_skills`, `working_model`, `requisition_type`, `client_interview`, `required_score`, `onb_coordinator`, `onb_coordinator_team`, `isg_team`, `interviewer_teammate_employee_id`, `created_at`, `updated_at`, `requisition_date`, `due_requisition_date`) VALUES
(1, 'RQ0001', 'Software Engineer I', 'Software Engineer I', 'Software Engineer', 'Finance', 'Banking', 'Banking', 'Banking', 'Bangalore', 'ASIA', 'General Employee Group', 'General Sub Group', NULL, NULL, 'L4', 'Accenture', '', 'P4', 'P4.2', 'Design, java, QA', 'aws, graphql, jenkins', 'hybrid', 'Full Time', 'Yes', 0, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-08-05 10:14:14', '2025-08-05 10:14:14', NULL, NULL),
(2, 'RQ0002', 'Software Engineer I', 'Software Engineer II', 'Software Engineer', 'Finance', 'Banking', 'Banking', 'Banking', 'San Francisco, Bangalore', 'ASIA', 'General Employee Group', 'General Sub Group', NULL, NULL, 'L4', 'CloudNexa', '', 'P4', 'P4.2', 'Golang', 'aws', 'hybrid', 'Full Time', 'No', 0, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-08-17 22:58:54', '2025-08-17 23:14:41', NULL, NULL),
(3, 'RQ0003', 'Product Owner I', 'Product Owner I', 'Software Engineer', 'Finance', 'Banking', 'Banking', 'Banking', 'New York', 'EAST', 'General Employee Group', 'General Sub Group', NULL, NULL, 'senior', 'HCL', '', 'P3', 'P3.1', 'Design, java, Golang', 'aws, graphql, jenkins, docker', 'Remote', 'Full Time', 'Yes', 0, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-08-22 05:51:48', '2025-08-22 05:51:48', NULL, NULL),
(4, 'RQ0004', 'Product Owner I', 'Product Owner I', 'Software Engineer', 'Finance', 'Banking', 'Banking', 'Banking', 'New York', 'EAST', 'General Employee Group', 'General Sub Group', NULL, NULL, 'senior', 'HCL', '', 'P3', 'P3.1', 'Design, java, Golang', 'aws, graphql, jenkins, docker', 'Remote', 'Full Time', 'Yes', 0, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-08-22 05:59:31', '2025-08-22 05:59:31', NULL, NULL),
(5, 'RQ0005', 'Product Owner I', 'Product Owner I', 'Software Engineer', 'Finance', 'Banking', 'Banking', 'Banking', 'New York', 'EAST', 'General Employee Group', 'General Sub Group', NULL, NULL, 'senior', 'HCL', '', 'P3', 'P3.1', 'Design, java, Golang', 'aws, graphql, jenkins, docker', 'Remote', 'Full Time', 'Yes', 0, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-08-22 06:03:14', '2025-08-22 06:03:14', NULL, NULL),
(6, 'RQ0006', 'Product Owner I', 'Product Owner I', 'Software Engineer', 'Finance', 'Banking', 'Banking', 'Banking', 'New York', 'EAST', 'General Employee Group', 'General Sub Group', NULL, NULL, 'senior', 'HCL', '', 'P3', 'P3.1', 'Design, java, Golang', 'aws, graphql, jenkins, docker', 'Remote', 'Full Time', 'Yes', 0, 'Not Assigned', 'No Team Assigned', 'No ISG Team Assigned', 'Not Available', '2025-08-22 06:20:05', '2025-08-22 06:20:05', NULL, NULL);

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
  `RoleName` enum('Hiring Manager','Recruiter','Business Ops','Interviewer','Vendor') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`RoleID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `userrole`
--

INSERT INTO `userrole` (`RoleID`, `RoleName`) VALUES
(1, 'Hiring Manager'),
(2, 'Recruiter'),
(3, 'Business Ops'),
(4, 'Interviewer'),
(5, 'Vendor');

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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users_details`
--

INSERT INTO `users_details` (`id`, `Name`, `RoleID`, `Email`, `PasswordHash`, `ResetToken`, `Created_at`) VALUES
(1, 'PixelHR', 1, 'pixelhr@gmail.com', 'pbkdf2_sha256$1000000$N1sbu22wbKw9gJTFmbpq4R$vpDXvWtFyAzqayvxGYm7EM54rRst5xNuRJMOFbmPlVg=', NULL, '2025-05-26 05:10:52'),
(2, 'PixelREQ', 2, 'pixelreq@gmail.com', 'pbkdf2_sha256$1000000$N1sbu22wbKw9gJTFmbpq4R$vpDXvWtFyAzqayvxGYm7EM54rRst5xNuRJMOFbmPlVg=', NULL, '2025-05-26 05:10:52'),
(3, 'PixelBO', 3, 'pixelbo@gmail.com', 'pbkdf2_sha256$1000000$N1sbu22wbKw9gJTFmbpq4R$vpDXvWtFyAzqayvxGYm7EM54rRst5xNuRJMOFbmPlVg=', NULL, '2025-05-26 05:10:52'),
(4, 'PixelCan', 4, 'pixelint@gmail.com', 'pbkdf2_sha256$1000000$N1sbu22wbKw9gJTFmbpq4R$vpDXvWtFyAzqayvxGYm7EM54rRst5xNuRJMOFbmPlVg=', NULL, '2025-05-26 05:10:52'),
(5, 'ANAND', 1, 'anand040593@gmail.com', 'pbkdf2_sha256$1000000$s5wZjZTM19ND2LpAqQOOzD$lNsk5Rxt9kUB3yHXp0c9EUo3ZmW7CB/BsddEbUcQWSA=', 'KulesSJQnXgQqCyZOhoE71udhj6ukHnz', '2025-05-26 05:10:52'),
(6, 'Kumar', 4, 'kumar.sachidanand@gmail.com', 'pbkdf2_sha256$1000000$s5wZjZTM19ND2LpAqQOOzD$lNsk5Rxt9kUB3yHXp0c9EUo3ZmW7CB/BsddEbUcQWSA=', NULL, '2025-05-26 05:10:52'),
(7, 'Pixelvendor', 5, 'pixelven@gmail.com', 'pbkdf2_sha256$1000000$N1sbu22wbKw9gJTFmbpq4R$vpDXvWtFyAzqayvxGYm7EM54rRst5xNuRJMOFbmPlVg=', NULL, '2025-05-26 05:10:52');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `approver`
--
ALTER TABLE `approver`
  ADD CONSTRAINT `fk_requisition` FOREIGN KEY (`requisition_id`) REFERENCES `jobrequisition` (`RequisitionID`) ON DELETE CASCADE;

--
-- Constraints for table `banking_details`
--
ALTER TABLE `banking_details`
  ADD CONSTRAINT `banking_details_ibfk_1` FOREIGN KEY (`candidate_id`) REFERENCES `candidate_profile` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `bg_check_request`
--
ALTER TABLE `bg_check_request`
  ADD CONSTRAINT `bg_check_request_ibfk_1` FOREIGN KEY (`requisition_id`) REFERENCES `jobrequisition` (`RequisitionID`) ON DELETE CASCADE,
  ADD CONSTRAINT `bg_check_request_ibfk_2` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`CandidateID`) ON DELETE CASCADE,
  ADD CONSTRAINT `bg_check_request_ibfk_3` FOREIGN KEY (`vendor_id`) REFERENCES `bg_vendor` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `bg_check_request_ibfk_4` FOREIGN KEY (`selected_package_id`) REFERENCES `bg_package` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `bg_package`
--
ALTER TABLE `bg_package`
  ADD CONSTRAINT `fk_vendor` FOREIGN KEY (`vendor_id`) REFERENCES `bg_vendor` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `bg_package_detail`
--
ALTER TABLE `bg_package_detail`
  ADD CONSTRAINT `bg_package_detail_vendor_id_fk` FOREIGN KEY (`vendor_id`) REFERENCES `bg_vendor` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `candidate_approval`
--
ALTER TABLE `candidate_approval`
  ADD CONSTRAINT `fk_candidate_approval_approver` FOREIGN KEY (`approver_id`) REFERENCES `approver` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_candidate_approval_candidate` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`CandidateID`) ON DELETE CASCADE;

--
-- Constraints for table `candidate_education`
--
ALTER TABLE `candidate_education`
  ADD CONSTRAINT `candidate_education_ibfk_1` FOREIGN KEY (`submission_id`) REFERENCES `candidate_submission` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `candidate_employment`
--
ALTER TABLE `candidate_employment`
  ADD CONSTRAINT `candidate_employment_ibfk_1` FOREIGN KEY (`submission_id`) REFERENCES `candidate_submission` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `candidate_form_invite`
--
ALTER TABLE `candidate_form_invite`
  ADD CONSTRAINT `candidate_form_invite_ibfk_1` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`CandidateID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `candidate_personal`
--
ALTER TABLE `candidate_personal`
  ADD CONSTRAINT `candidate_personal_ibfk_1` FOREIGN KEY (`submission_id`) REFERENCES `candidate_submission` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `candidate_reviews`
--
ALTER TABLE `candidate_reviews`
  ADD CONSTRAINT `can_id_fk` FOREIGN KEY (`CandidateID`) REFERENCES `candidates` (`CandidateID`) ON DELETE CASCADE ON UPDATE RESTRICT;

--
-- Constraints for table `document_item`
--
ALTER TABLE `document_item`
  ADD CONSTRAINT `document_item_ibfk_1` FOREIGN KEY (`candidate_id`) REFERENCES `candidate_profile` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `financial_documents`
--
ALTER TABLE `financial_documents`
  ADD CONSTRAINT `financial_documents_ibfk_1` FOREIGN KEY (`candidate_id`) REFERENCES `candidate_profile` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `generated_offer`
--
ALTER TABLE `generated_offer`
  ADD CONSTRAINT `generated_offer_ibfk_1` FOREIGN KEY (`requisition_id`) REFERENCES `jobrequisition` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `generated_offer_ibfk_2` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`CandidateID`) ON DELETE CASCADE;

--
-- Constraints for table `insurance_detail`
--
ALTER TABLE `insurance_detail`
  ADD CONSTRAINT `insurance_detail_ibfk_1` FOREIGN KEY (`candidate_id`) REFERENCES `candidate_profile` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `interviewer`
--
ALTER TABLE `interviewer`
  ADD CONSTRAINT `fk_user_interviewer` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `interview_review`
--
ALTER TABLE `interview_review`
  ADD CONSTRAINT `fk_candidate_review` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`CandidateID`) ON DELETE CASCADE,
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
  ADD CONSTRAINT `fk_round_id` FOREIGN KEY (`round_id`) REFERENCES `job_interview_design_parameters` (`interview_desing_params_id`),
  ADD CONSTRAINT `int_fk_id` FOREIGN KEY (`interviewer_id`) REFERENCES `interviewer` (`interviewer_id`) ON DELETE CASCADE ON UPDATE RESTRICT;

--
-- Constraints for table `nominee`
--
ALTER TABLE `nominee`
  ADD CONSTRAINT `nominee_ibfk_1` FOREIGN KEY (`candidate_id`) REFERENCES `candidate_profile` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `offer_negotiation`
--
ALTER TABLE `offer_negotiation`
  ADD CONSTRAINT `fk_candidate_offer` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`CandidateID`) ON DELETE CASCADE;

--
-- Constraints for table `offer_salary_component`
--
ALTER TABLE `offer_salary_component`
  ADD CONSTRAINT `offer_salary_component_ibfk_1` FOREIGN KEY (`offer_id`) REFERENCES `generated_offer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `offer_variable_pay_component`
--
ALTER TABLE `offer_variable_pay_component`
  ADD CONSTRAINT `offer_variable_pay_component_ibfk_1` FOREIGN KEY (`offer_id`) REFERENCES `generated_offer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `personal_details`
--
ALTER TABLE `personal_details`
  ADD CONSTRAINT `personal_details_ibfk_1` FOREIGN KEY (`candidate_id`) REFERENCES `candidate_profile` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `reference_check`
--
ALTER TABLE `reference_check`
  ADD CONSTRAINT `reference_check_ibfk_1` FOREIGN KEY (`candidate_id`) REFERENCES `candidate_profile` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
