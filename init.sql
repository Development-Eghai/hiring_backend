-- MySQL dump 10.13  Distrib 8.0.43, for Linux (x86_64)
--
-- Host: localhost    Database: pixeladvant_hiring
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `applications`
--

DROP TABLE IF EXISTS `applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `applications` (
  `ApplicationID` int NOT NULL AUTO_INCREMENT,
  `CandidateID` int NOT NULL,
  `RequisitionID` int NOT NULL,
  `Status` enum('Applied','Screened','Interview Scheduled','Selected','Rejected') DEFAULT 'Applied',
  `SubmittedDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ApplicationID`),
  KEY `CandidateID` (`CandidateID`),
  KEY `RequisitionID` (`RequisitionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications`
--

LOCK TABLES `applications` WRITE;
/*!40000 ALTER TABLE `applications` DISABLE KEYS */;
/*!40000 ALTER TABLE `applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `approval_status`
--

DROP TABLE IF EXISTS `approval_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `approval_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `offer_negotiation_id` int NOT NULL,
  `approver_id` int NOT NULL,
  `status` varchar(20) NOT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `offer_negotiation_id` (`offer_negotiation_id`),
  KEY `approver_id` (`approver_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `approval_status`
--

LOCK TABLES `approval_status` WRITE;
/*!40000 ALTER TABLE `approval_status` DISABLE KEYS */;
INSERT INTO `approval_status` VALUES (25,19,40,'Approved','2025-09-07 16:48:00');
/*!40000 ALTER TABLE `approval_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `approver`
--

DROP TABLE IF EXISTS `approver`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `approver` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
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
  KEY `fk_requisition` (`requisition_id`),
  CONSTRAINT `fk_requisition` FOREIGN KEY (`requisition_id`) REFERENCES `jobrequisition` (`RequisitionID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `approver`
--

LOCK TABLES `approver` WRITE;
/*!40000 ALTER TABLE `approver` DISABLE KEYS */;
INSERT INTO `approver` VALUES (40,'34','MANAGER','A','P','abhik.paul@outlook.com','••••••••••','Manager','2025-09-07 16:26:49','Yes','RQ0003');
/*!40000 ALTER TABLE `approver` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `asset_details`
--

DROP TABLE IF EXISTS `asset_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asset_details` (
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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asset_details`
--

LOCK TABLES `asset_details` WRITE;
/*!40000 ALTER TABLE `asset_details` DISABLE KEYS */;
INSERT INTO `asset_details` VALUES (16,'RQ0003','Windows','Yes','No','NA','2025-09-07 16:13:54','2025-09-07 16:13:57'),(17,'RQ0004','Windows','No','No','adadf','2025-09-07 17:00:18','2025-09-07 17:00:18');
/*!40000 ALTER TABLE `asset_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissions_group_id_b120cbf9` (`group_id`),
  KEY `auth_group_permissions_permission_id_84c5c92e` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  KEY `auth_permission_content_type_id_2f476e4b` (`content_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add candidates',7,'add_candidates'),(26,'Can change candidates',7,'change_candidates'),(27,'Can delete candidates',7,'delete_candidates'),(28,'Can view candidates',7,'view_candidates'),(29,'Can add user details',8,'add_userdetails'),(30,'Can change user details',8,'change_userdetails'),(31,'Can delete user details',8,'delete_userdetails'),(32,'Can view user details',8,'view_userdetails'),(33,'Can add userrole details',9,'add_userroledetails'),(34,'Can change userrole details',9,'change_userroledetails'),(35,'Can delete userrole details',9,'delete_userroledetails'),(36,'Can view userrole details',9,'view_userroledetails'),(37,'Can add job requisition',10,'add_jobrequisition'),(38,'Can change job requisition',10,'change_jobrequisition'),(39,'Can delete job requisition',10,'delete_jobrequisition'),(40,'Can view job requisition',10,'view_jobrequisition'),(41,'Can add posting',11,'add_posting'),(42,'Can change posting',11,'change_posting'),(43,'Can delete posting',11,'delete_posting'),(44,'Can view posting',11,'view_posting'),(45,'Can add job requisition extra details',12,'add_jobrequisitionextradetails'),(46,'Can change job requisition extra details',12,'change_jobrequisitionextradetails'),(47,'Can delete job requisition extra details',12,'delete_jobrequisitionextradetails'),(48,'Can view job requisition extra details',12,'view_jobrequisitionextradetails'),(49,'Can add billing details',13,'add_billingdetails'),(50,'Can change billing details',13,'change_billingdetails'),(51,'Can delete billing details',13,'delete_billingdetails'),(52,'Can view billing details',13,'view_billingdetails'),(53,'Can add interview team',14,'add_interviewteam'),(54,'Can change interview team',14,'change_interviewteam'),(55,'Can delete interview team',14,'delete_interviewteam'),(56,'Can view interview team',14,'view_interviewteam'),(57,'Can add posting details',15,'add_postingdetails'),(58,'Can change posting details',15,'change_postingdetails'),(59,'Can delete posting details',15,'delete_postingdetails'),(60,'Can view posting details',15,'view_postingdetails'),(61,'Can add requisition details',16,'add_requisitiondetails'),(62,'Can change requisition details',16,'change_requisitiondetails'),(63,'Can delete requisition details',16,'delete_requisitiondetails'),(64,'Can view requisition details',16,'view_requisitiondetails'),(65,'Can add teams',17,'add_teams'),(66,'Can change teams',17,'change_teams'),(67,'Can delete teams',17,'delete_teams'),(68,'Can view teams',17,'view_teams');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'temporarypassword',NULL,0,'hiring','','','hiring@pixeladvant.com',0,1,'2025-07-16 08:21:16.755939'),(2,'pbkdf2_sha256$1000000$0YwnwKLw6vy7CDVea4m7MU$kA4acs1GFa8HXporfpQ8OXBD4scoYzX006aKj+nGS0k=',NULL,0,'pixelhr@gmail.com','','','pixelhr@gmail.com',0,1,'2025-07-19 02:21:49.471282'),(3,'pbkdf2_sha256$1000000$yiOWhpERHOQpMYK1dNETpv$ygvqwkGqW7h0nTEbotpQdgVmojvD6WS5q2CNcna5PH4=',NULL,0,'pixelbo@gmail.com','','','pixelbo@gmail.com',0,1,'2025-07-19 02:39:15.076782'),(4,'pbkdf2_sha256$1000000$0yzrBqecOCpG0hW1Fh8it7$RVp+Fnq077Hst2ISkCLh7r4refWvXJjaHbaysBkC/zs=',NULL,0,'pixelreq@gmail.com','','','pixelreq@gmail.com',0,1,'2025-07-19 02:39:25.558270'),(5,'pbkdf2_sha256$1000000$JtViLKCDbU0aQD7IwV1ohW$1CQnWfRZXqmZcYvvAHddqs7JHxTy4v41jZIr964dOXM=',NULL,0,'pixelcan@gmail.com','','','pixelcan@gmail.com',0,1,'2025-07-30 15:12:30.899243'),(6,'pbkdf2_sha256$1000000$gpo49ukoQzVCmSRFXcdZ21$LfA0Z4ypSxYUFEpqHyFDnBBiJPExqnACTO9EyNEb6Qs=',NULL,0,'pixelven@gmail.com','','','pixelven@gmail.com',0,1,'2025-08-14 15:01:52.228611'),(7,'pbkdf2_sha256$1000000$22eLnXsVdUk3PwEwnlpFYi$77pV9/GX6eRqqLTlWVDAIASo1i0t8o5PjKM+xQV+zpQ=',NULL,0,'pixelint@gmail.com','','','pixelint@gmail.com',0,1,'2025-08-15 08:12:36.563024');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_user_id_6a12ed8b` (`user_id`),
  KEY `auth_user_groups_group_id_97559544` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permissions_user_id_a95ead1b` (`user_id`),
  KEY `auth_user_user_permissions_permission_id_1fbb5f2c` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `banking_details`
--

DROP TABLE IF EXISTS `banking_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `banking_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `candidate_id` int DEFAULT NULL,
  `bank_name` varchar(100) DEFAULT NULL,
  `account_number` varchar(50) DEFAULT NULL,
  `ifsc_code` varchar(20) DEFAULT NULL,
  `branch_address` text,
  `bank_statement` varchar(255) DEFAULT NULL,
  `cancel_cheque` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `candidate_id` (`candidate_id`),
  CONSTRAINT `banking_details_ibfk_1` FOREIGN KEY (`candidate_id`) REFERENCES `candidate_profile` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banking_details`
--

LOCK TABLES `banking_details` WRITE;
/*!40000 ALTER TABLE `banking_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `banking_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `benefit`
--

DROP TABLE IF EXISTS `benefit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `benefit` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `benefit`
--

LOCK TABLES `benefit` WRITE;
/*!40000 ALTER TABLE `benefit` DISABLE KEYS */;
INSERT INTO `benefit` VALUES (1,'Insurance'),(3,'Joining Bonus'),(2,'Relocation Amount');
/*!40000 ALTER TABLE `benefit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bg_check_request`
--

DROP TABLE IF EXISTS `bg_check_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bg_check_request` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `requisition_id` varchar(255) NOT NULL,
  `candidate_id` int NOT NULL,
  `vendor_id` int NOT NULL,
  `custom_checks` json DEFAULT NULL,
  `status` varchar(50) DEFAULT 'Initiated',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `requisition_id` (`requisition_id`),
  KEY `candidate_id` (`candidate_id`),
  KEY `vendor_id` (`vendor_id`),
  CONSTRAINT `bg_check_request_ibfk_1` FOREIGN KEY (`requisition_id`) REFERENCES `jobrequisition` (`RequisitionID`) ON DELETE CASCADE,
  CONSTRAINT `bg_check_request_ibfk_2` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`CandidateID`) ON DELETE CASCADE,
  CONSTRAINT `bg_check_request_ibfk_3` FOREIGN KEY (`vendor_id`) REFERENCES `bg_vendor` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bg_check_request`
--

LOCK TABLES `bg_check_request` WRITE;
/*!40000 ALTER TABLE `bg_check_request` DISABLE KEYS */;
INSERT INTO `bg_check_request` VALUES (8,'RQ0003',52,12,'[\"employement check\"]','Initiated','2025-09-07 16:58:00');
/*!40000 ALTER TABLE `bg_check_request` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bg_check_request_selected_packages`
--

DROP TABLE IF EXISTS `bg_check_request_selected_packages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bg_check_request_selected_packages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bgcheckrequest_id` bigint NOT NULL,
  `bgpackage_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `bgcheckrequest_id` (`bgcheckrequest_id`,`bgpackage_id`),
  KEY `bgpackage_id` (`bgpackage_id`),
  CONSTRAINT `bg_check_request_selected_packages_ibfk_1` FOREIGN KEY (`bgcheckrequest_id`) REFERENCES `bg_check_request` (`id`) ON DELETE CASCADE,
  CONSTRAINT `bg_check_request_selected_packages_ibfk_2` FOREIGN KEY (`bgpackage_id`) REFERENCES `bg_package` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bg_check_request_selected_packages`
--

LOCK TABLES `bg_check_request_selected_packages` WRITE;
/*!40000 ALTER TABLE `bg_check_request_selected_packages` DISABLE KEYS */;
INSERT INTO `bg_check_request_selected_packages` VALUES (7,8,35);
/*!40000 ALTER TABLE `bg_check_request_selected_packages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bg_package`
--

DROP TABLE IF EXISTS `bg_package`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bg_package` (
  `id` int NOT NULL AUTO_INCREMENT,
  `vendor_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `rate` decimal(10,2) NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `verification_items` text,
  PRIMARY KEY (`id`),
  KEY `fk_vendor` (`vendor_id`),
  CONSTRAINT `fk_vendor` FOREIGN KEY (`vendor_id`) REFERENCES `bg_vendor` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bg_package`
--

LOCK TABLES `bg_package` WRITE;
/*!40000 ALTER TABLE `bg_package` DISABLE KEYS */;
INSERT INTO `bg_package` VALUES (32,12,'Advances',2500.00,'all checks','2025-08-21 14:56:04','Phone,  ID Proof'),(33,12,'Basic',2500.00,'good','2025-08-21 14:56:31','Email, ID Proof'),(35,12,'Advances',2500.00,'all checks','2025-08-22 14:38:39','Address Proof, Phone'),(36,13,'Advances',2500.00,'all checks','2025-08-22 14:39:19','Email, Address Proof'),(37,14,'Drug Check',7000.00,'NA','2025-08-30 08:40:40','ID Proof, Address Proof'),(38,14,'Education Check',2000.00,'NA','2025-08-30 08:40:40','Address Proof,  ID Proof'),(39,14,'BG Check',1000.00,'NA','2025-08-30 08:41:29','Email');
/*!40000 ALTER TABLE `bg_package` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bg_package_detail`
--

DROP TABLE IF EXISTS `bg_package_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bg_package_detail` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `vendor_id` int NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `rate` decimal(10,2) NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `bg_package_detail_vendor_id_fk` (`vendor_id`),
  CONSTRAINT `bg_package_detail_vendor_id_fk` FOREIGN KEY (`vendor_id`) REFERENCES `bg_vendor` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bg_package_detail`
--

LOCK TABLES `bg_package_detail` WRITE;
/*!40000 ALTER TABLE `bg_package_detail` DISABLE KEYS */;
INSERT INTO `bg_package_detail` VALUES (26,12,'employement check','good',1000.00,'2025-08-21 14:56:30.536444'),(27,12,'employement check','good',1000.00,'2025-08-22 14:38:39.160560'),(28,13,'employement check','good',1000.00,'2025-08-22 14:39:19.379660');
/*!40000 ALTER TABLE `bg_package_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bg_vendor`
--

DROP TABLE IF EXISTS `bg_vendor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bg_vendor` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_email` varchar(254) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `mobile_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bg_vendor`
--

LOCK TABLES `bg_vendor` WRITE;
/*!40000 ALTER TABLE `bg_vendor` DISABLE KEYS */;
INSERT INTO `bg_vendor` VALUES (12,'American adventage','hiring@pixeladvant.com','bangalore','2025-08-21 14:56:04','09994551690'),(13,'Vendor2','anandsivakumar27@gmail.com','bangalore','2025-08-22 14:39:19',''),(14,'ABC Company','abc@xyz.com','Jhumritalaya, Lucknow','2025-08-30 08:40:40','9884477549');
/*!40000 ALTER TABLE `bg_vendor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `billing_details`
--

DROP TABLE IF EXISTS `billing_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `billing_details` (
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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billing_details`
--

LOCK TABLES `billing_details` WRITE;
/*!40000 ALTER TABLE `billing_details` DISABLE KEYS */;
INSERT INTO `billing_details` VALUES (19,'RQ0003','Onetime','2025-10-31','2025-09-07 16:13:54','2025-09-07 16:13:57','2025-12-31',NULL,NULL),(20,'RQ0004','Onetime','2025-09-19','2025-09-07 17:00:18','2025-09-07 17:00:18','2025-09-04',NULL,NULL);
/*!40000 ALTER TABLE `billing_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `candidate_approval`
--

DROP TABLE IF EXISTS `candidate_approval`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `candidate_approval` (
  `id` int NOT NULL AUTO_INCREMENT,
  `candidate_id` int NOT NULL,
  `approver_id` bigint unsigned NOT NULL,
  `role` varchar(20) NOT NULL,
  `decision` varchar(20) DEFAULT 'Awaiting',
  `comment` text,
  `reviewed_at` datetime DEFAULT NULL,
  `assigned_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_assignment` (`candidate_id`,`approver_id`,`role`),
  KEY `fk_candidate_approval_approver` (`approver_id`),
  CONSTRAINT `fk_candidate_approval_approver` FOREIGN KEY (`approver_id`) REFERENCES `approver` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_candidate_approval_candidate` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`CandidateID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=107 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `candidate_approval`
--

LOCK TABLES `candidate_approval` WRITE;
/*!40000 ALTER TABLE `candidate_approval` DISABLE KEYS */;
INSERT INTO `candidate_approval` VALUES (106,52,40,'MANAGER','Approved',NULL,'2025-09-07 16:28:38','2025-09-07 16:28:27');
/*!40000 ALTER TABLE `candidate_approval` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `candidate_education`
--

DROP TABLE IF EXISTS `candidate_education`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `candidate_education` (
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
  KEY `submission_id` (`submission_id`),
  CONSTRAINT `candidate_education_ibfk_1` FOREIGN KEY (`submission_id`) REFERENCES `candidate_submission` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `candidate_education`
--

LOCK TABLES `candidate_education` WRITE;
/*!40000 ALTER TABLE `candidate_education` DISABLE KEYS */;
/*!40000 ALTER TABLE `candidate_education` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `candidate_employment`
--

DROP TABLE IF EXISTS `candidate_employment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `candidate_employment` (
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
  KEY `submission_id` (`submission_id`),
  CONSTRAINT `candidate_employment_ibfk_1` FOREIGN KEY (`submission_id`) REFERENCES `candidate_submission` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `candidate_employment`
--

LOCK TABLES `candidate_employment` WRITE;
/*!40000 ALTER TABLE `candidate_employment` DISABLE KEYS */;
/*!40000 ALTER TABLE `candidate_employment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `candidate_form_invite`
--

DROP TABLE IF EXISTS `candidate_form_invite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `candidate_form_invite` (
  `id` int NOT NULL AUTO_INCREMENT,
  `candidate_id` int NOT NULL,
  `token` char(36) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `expires_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `candidate_id` (`candidate_id`),
  CONSTRAINT `candidate_form_invite_ibfk_1` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`CandidateID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `candidate_form_invite`
--

LOCK TABLES `candidate_form_invite` WRITE;
/*!40000 ALTER TABLE `candidate_form_invite` DISABLE KEYS */;
INSERT INTO `candidate_form_invite` VALUES (13,52,'e0c8d593c0f34ec7acbcc7a95261d695','2025-09-07 16:46:33','2025-09-12 16:46:33'),(14,52,'a523535812404b809b4fefa5fcc1ef09','2025-09-07 16:51:38','2025-09-12 16:51:38'),(15,52,'dc59970c85964d76830a1bbdecda5e5d','2025-09-07 16:54:38','2025-09-12 16:54:38'),(16,52,'fae938f3a85d4a609e93e05af5530312','2025-09-07 16:54:56','2025-09-12 16:54:56'),(17,52,'d891d75821de441597bc6458cd25bc73','2025-09-07 16:58:41','2025-09-12 16:58:41'),(18,52,'b61afa74425f4e68a7494e4eb479dfc9','2025-09-08 18:16:04','2025-09-13 18:16:04');
/*!40000 ALTER TABLE `candidate_form_invite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `candidate_interview_stages`
--

DROP TABLE IF EXISTS `candidate_interview_stages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `candidate_interview_stages` (
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
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `candidate_interview_stages`
--

LOCK TABLES `candidate_interview_stages` WRITE;
/*!40000 ALTER TABLE `candidate_interview_stages` DISABLE KEYS */;
INSERT INTO `candidate_interview_stages` VALUES (72,52,'RQ0003','Hiring Manager Screen','2025-09-08','video_interview','Good',5,'Selected','Completed'),(73,52,'RQ0003','Technical Round 1','2025-09-11','video_interview','good',5,'Selected','Completed');
/*!40000 ALTER TABLE `candidate_interview_stages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `candidate_personal`
--

DROP TABLE IF EXISTS `candidate_personal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `candidate_personal` (
  `id` int NOT NULL AUTO_INCREMENT,
  `submission_id` int NOT NULL,
  `title` varchar(20) DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `submission_id` (`submission_id`),
  CONSTRAINT `candidate_personal_ibfk_1` FOREIGN KEY (`submission_id`) REFERENCES `candidate_submission` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `candidate_personal`
--

LOCK TABLES `candidate_personal` WRITE;
/*!40000 ALTER TABLE `candidate_personal` DISABLE KEYS */;
/*!40000 ALTER TABLE `candidate_personal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `candidate_profile`
--

DROP TABLE IF EXISTS `candidate_profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `candidate_profile` (
  `id` int NOT NULL AUTO_INCREMENT,
  `candidate_id` varchar(20) NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `date_of_joining` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `candidate_id` (`candidate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `candidate_profile`
--

LOCK TABLES `candidate_profile` WRITE;
/*!40000 ALTER TABLE `candidate_profile` DISABLE KEYS */;
INSERT INTO `candidate_profile` VALUES (10,'52','Manjunath','Rathore','2025-09-15');
/*!40000 ALTER TABLE `candidate_profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `candidate_reference`
--

DROP TABLE IF EXISTS `candidate_reference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `candidate_reference` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `candidate_reference`
--

LOCK TABLES `candidate_reference` WRITE;
/*!40000 ALTER TABLE `candidate_reference` DISABLE KEYS */;
/*!40000 ALTER TABLE `candidate_reference` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `candidate_reviews`
--

DROP TABLE IF EXISTS `candidate_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `candidate_reviews` (
  `ReviewID` int NOT NULL AUTO_INCREMENT,
  `CandidateID` int NOT NULL,
  `ParameterDefined` varchar(100) DEFAULT NULL,
  `Guidelines` varchar(100) DEFAULT NULL,
  `MinimumQuestions` text,
  `ActualRating` decimal(3,1) DEFAULT NULL,
  `Feedback` text,
  `Created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Weightage` int DEFAULT NULL,
  `ScreeningDate` date DEFAULT NULL,
  PRIMARY KEY (`ReviewID`),
  KEY `can_id_fk` (`CandidateID`),
  CONSTRAINT `can_id_fk` FOREIGN KEY (`CandidateID`) REFERENCES `candidates` (`CandidateID`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=165 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `candidate_reviews`
--

LOCK TABLES `candidate_reviews` WRITE;
/*!40000 ALTER TABLE `candidate_reviews` DISABLE KEYS */;
INSERT INTO `candidate_reviews` VALUES (163,52,NULL,NULL,NULL,5.0,'','2025-09-07 16:28:27',NULL,'2025-09-07'),(164,52,NULL,NULL,NULL,5.0,'','2025-09-07 16:28:27',NULL,'2025-09-07');
/*!40000 ALTER TABLE `candidate_reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `candidate_submission`
--

DROP TABLE IF EXISTS `candidate_submission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `candidate_submission` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `candidate_submission`
--

LOCK TABLES `candidate_submission` WRITE;
/*!40000 ALTER TABLE `candidate_submission` DISABLE KEYS */;
/*!40000 ALTER TABLE `candidate_submission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `candidatefeedback`
--

DROP TABLE IF EXISTS `candidatefeedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `candidatefeedback` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `candidate_id` int NOT NULL,
  `recruiter_name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `interview_date` date NOT NULL,
  `assessment_score` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `interviewer_feedback` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `recruiter_feedback` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `reason_not_selected` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `skills` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `current_employer` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `current_location` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_ctc` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `follow_up_date` date DEFAULT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_candidate_feedback` (`candidate_id`),
  CONSTRAINT `fk_candidate_feedback` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`CandidateID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `candidatefeedback`
--

LOCK TABLES `candidatefeedback` WRITE;
/*!40000 ALTER TABLE `candidatefeedback` DISABLE KEYS */;
INSERT INTO `candidatefeedback` VALUES (7,52,'Drake B','2025-09-08','4','good','Recommended','Long Notice Period','ABCD','ACCC','C','123','Declined','2025-09-24','C','2025-09-08 01:33:59'),(8,52,'Akon S','2025-09-11','4','good','Recommended','Long Notice Period','ABCD','ACCC','C','123','Declined','2025-09-24','C','2025-09-08 01:33:59');
/*!40000 ALTER TABLE `candidatefeedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `candidates`
--

DROP TABLE IF EXISTS `candidates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `candidates` (
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
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `candidates`
--

LOCK TABLES `candidates` WRITE;
/*!40000 ALTER TABLE `candidates` DISABLE KEYS */;
INSERT INTO `candidates` VALUES (52,'RQ0003','candidate6757@gmail.com','Manjunath Rathod.pdf',5,'y','Recommended','2025-09-07 16:27:34','This is a sample cover letter for candidate6757.','Dice',NULL,'9999999999','Manjunath','Rathore');
/*!40000 ALTER TABLE `candidates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `competency`
--

DROP TABLE IF EXISTS `competency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `competency` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `competency`
--

LOCK TABLES `competency` WRITE;
/*!40000 ALTER TABLE `competency` DISABLE KEYS */;
/*!40000 ALTER TABLE `competency` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `config_hiring_data`
--

DROP TABLE IF EXISTS `config_hiring_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `config_hiring_data` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `category_name` varchar(500) NOT NULL DEFAULT '',
  `category_values` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=306 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config_hiring_data`
--

LOCK TABLES `config_hiring_data` WRITE;
/*!40000 ALTER TABLE `config_hiring_data` DISABLE KEYS */;
INSERT INTO `config_hiring_data` VALUES (3,'Position Role','Python developer'),(4,'Screening Type','Online Test'),(5,'Screening Type','Telephonic interview'),(8,'Location','Bangalore'),(9,'Designation','Senior Developer'),(10,'Designation','Software Engineer I'),(11,'Designation','Software Engineer II'),(12,'Tech Stack','Python'),(13,'Tech Stack','Django'),(14,'Tech Stack','AWS'),(15,'Target Companies','HCL'),(16,'Target Companies','Accenture'),(17,'Working Model','Onsite'),(20,'Role Type','Full Time'),(21,'Role Type','Part Time'),(22,'Job Type','Contract'),(23,'Job Type','Permanant'),(24,'Mode of Working','Hybrid'),(25,'Mode of Working','Work from home'),(26,'Shift Timings','Day Shift'),(27,'Shift Timings','Night Shift'),(28,'Education Qualification','BE'),(29,'Education Qualification','B Tech'),(30,'Education Qualification','MBA'),(32,'Education Qualification','M Tech'),(33,'Communication Language','English'),(34,'Communication Language','Hindi'),(35,'Communication Language','Tamil'),(38,'Position Role','Product Manager'),(39,'Position Role','UX Designer'),(41,'Working Model','Remote'),(42,'Working Model','client site'),(43,'Location','New York'),(44,'Location','San Francisco'),(45,'Location','London'),(46,'Location','Berlin'),(47,'Location','Tokyo'),(48,'Location','Toronto'),(49,'Location','Sydney'),(50,'Location','Dubai'),(51,'Location','Singapore'),(52,'Working Model','Hybrid'),(53,'Position Role','Finance Manager'),(54,'Designation','Finance Manager'),(55,'Target Companies','Zendesk'),(56,'Target Companies','Zuora'),(57,'Target Companies','Freshworks'),(58,'Target Companies','Servicenow'),(59,'Tech Stack','SAP Concur'),(60,'Tech Stack','Tally'),(61,'Tech Stack','Oracle Netsuite'),(62,'Position Role','Financial Analyst'),(63,'Education Qualification','CA'),(64,'Education Qualification','CS'),(65,'Communication Language','German'),(66,'Score Card','Leadership'),(70,'Score Card','Product Management'),(76,'Score Card','Technical Round 1'),(77,'Score Card','Technical Round 2'),(79,'Score Card','Recruiter Screen'),(80,'Score Card','Written/Aptitude'),(81,'Score Card','Hiring Manager Screen'),(82,'Score Card','Coding/Whiteboard'),(83,'Score Card','Values/Personality'),(84,'Score Card','HR Round'),(85,'Score Card','Managerial Round'),(94,'Position Role','Software Engineer'),(95,'Primary Skills','Design thinking'),(96,'Secondary Skills','Azure'),(97,'Location','Pune'),(98,'Position Role','Sales Analyst'),(99,'Position Role','Sales Director'),(100,'Tech Stack','Salesforce'),(101,'Tech Stack','CRM'),(102,'Designation','Sales Analyst'),(104,'Internal Job Title','Sales Analyst'),(105,'Internal Job Title','Sales Director'),(106,'Business Line','Sales'),(107,'External Job Title','Sales Analyst'),(108,'External Job Title','Sales Director'),(109,'Internal Job Title','Software Engineer I'),(110,'Internal Job Title','Software Engineer II'),(111,'External Job Title','Software Engineer I'),(112,'External Job Title','Software Engineer II'),(114,'Business Line','Finance'),(115,'Business Unit','Banking'),(117,'Division','Banking'),(119,'Business Line','Product'),(120,'Business Unit','Product'),(121,'Business Unit','Insurance'),(122,'Business Line','Insurance'),(123,'Division','Healthcare'),(125,'Division','Insurance'),(126,'Department','Finance'),(127,'Department','Product'),(128,'Department','SWE'),(129,'Internal Job Title','Sr Software Engineer'),(130,'External Job Title','Sr Software Engineer'),(131,'External Job Title','Staff Software Engineer'),(132,'Internal Job Title','Staff Software Engineer'),(133,'Internal Job Title','Principal Software Engineer'),(134,'External Job Title','Principal Software Engineer'),(135,'External Job Title','Distinguished Engineer'),(136,'Internal Job Title','Distinguished Engineer'),(137,'Internal Job Title','Product Owner I'),(138,'External Job Title','Product Owner I'),(139,'External Job Title','Product Owner II'),(140,'External Job Title','Product Owner III'),(141,'Internal Job Title','Product Owner II'),(142,'Internal Job Title','Product Owner III'),(143,'Internal Job Title','Sr Director, Engineering'),(144,'External Job Title','Sr Director, Engineering'),(145,'Geo Zone','NAM'),(146,'Geo Zone','LATAM'),(147,'Geo Zone','ASIA'),(148,'Geo Zone','EMEA'),(149,'Geo Zone','APAC'),(150,'Geo Zone','EAST'),(161,'Sub Band','P3.1'),(162,'Sub Band','P3.2'),(163,'Sub Band','P3.3'),(164,'Sub Band','P4.1'),(165,'Sub Band','P4.2'),(166,'Sub Band','P4.3'),(167,'Sub Band','M1.1'),(168,'Sub Band','M1.2'),(169,'Sub Band','M2.1'),(170,'Sub Band','M2.2'),(171,'Band','P3'),(172,'Band','P4'),(173,'Band','M1'),(174,'Band','M2'),(175,'Client Interview','Yes'),(176,'Client Interview','No'),(177,'Requisition Type','Part Time'),(178,'Requisition Type','Full Time'),(179,'Requisition Type','Contractor'),(180,'Primary Skills','Python'),(181,'Primary Skills','AWS'),(182,'Primary Skills','Golang'),(183,'Mode of Working','Remote'),(184,'Mode of Working','Onsite'),(185,'Position','Project Manager'),(186,'Position','Software Engineer'),(187,'Secondary Skills','docker'),(188,'Secondary Skills','graphql'),(189,'Experience','0-2'),(192,'Experience','2-5'),(194,'Experience','10+ years'),(195,'Qualification','Btech'),(196,'Qualification','Mtech'),(197,'Qualification','B.Sc'),(198,'Qualification','M.Sc'),(199,'Qualification','MBA'),(200,'Job Region','North America'),(201,'Job Region','Europe'),(202,'Job Region','Asia'),(203,'Job Region','Middle East'),(204,'Job Region','Australia'),(205,'Primary Skills','Design'),(207,'Primary Skills','UI'),(208,'Primary Skills','Java'),(209,'Internal Job Title','Sr Director'),(210,'Internal Job Title','Engineering'),(211,'External Job Title','Sr Director'),(212,'External Job Title','Engineering'),(213,'Position','Sales Analyst'),(214,'Business Line','SWE'),(215,'Department','Insurance'),(216,'Career Level','P4'),(217,'Career Level','M3'),(219,'Qualification','B Tech'),(220,'Primary Skills','Automation'),(221,'Secondary Skills','kubernetes'),(225,'Position','Sales Director'),(226,'Qualification','CA'),(227,'Qualification','CS'),(228,'Job Region','Sales Analyst'),(229,'Experience','5-10'),(230,'Background Verification','Advances'),(231,'Position','Product Manager'),(232,'Division','Product'),(233,'Qualification','BE'),(234,'Qualification','M Tech'),(235,'Job Region','Software Engineer I'),(236,'Job Region','Senior Developer'),(237,'Position Role','Database Architect'),(238,'Target Companies','Oracle'),(239,'Target Companies','Netazza'),(240,'Tech Stack','Oracle'),(241,'Tech Stack','SQL'),(242,'Designation','Database Architect'),(243,'Citizen Country','US'),(245,'Internal Job Title','Database Architect'),(246,'External Job Title','Database Architect'),(247,'Position','Database Architect'),(248,'Job Region','Database Architect'),(249,'Position Role','Marketing Manager'),(250,'Designation','Marketing Manager'),(251,'Target Companies','Adobe'),(252,'Shift Timings','Australian Shift'),(253,'Internal Job Title','Marketing Manager'),(254,'External Job Title','Marketing Manager'),(255,'Business Line','Marketing'),(256,'Business Unit','Marketing'),(257,'Department','Marketing'),(258,'Location','Gurgaon'),(260,'Background Verification','Basic'),(263,'Division','Marketing'),(264,'Position','Marketing Manager'),(265,'Job Region','Marketing Manager'),(273,'Position','Python developer'),(274,'Job Region','Software Engineer II'),(275,'Citizen Country','USA'),(276,'Citizen Country','India'),(278,'planning_templates','PL0001'),(279,'Job Region','Finance Manager'),(280,'Position Role','Data Engineer'),(281,'Designation','Data Engineer II'),(282,'Internal Job Title','Data Engineer'),(283,'External Job Title','Data Engineer II'),(284,'Position','Data Engineer'),(286,'planning_templates','PL0002'),(287,'Job Region','Data Engineer II'),(289,'planning_templates','PL0003'),(290,'Communication Language','French'),(291,'Communication Language','Chinese'),(292,'Communication Language','English:Advanced'),(293,'Communication Language','Tamil:Intermediate'),(300,'Position Role','Project Manager'),(301,'Position Role','Salesforce Architect'),(302,'Internal Job Title','Salesforce Architect'),(303,'External Job Title','Salesforce Architect'),(304,'planning_templates','PL0004'),(305,'Position','Salesforce Architect');
/*!40000 ALTER TABLE `config_hiring_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `config_job_position`
--

DROP TABLE IF EXISTS `config_job_position`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `config_job_position` (
  `id` int NOT NULL AUTO_INCREMENT,
  `position_role` varchar(500) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config_job_position`
--

LOCK TABLES `config_job_position` WRITE;
/*!40000 ALTER TABLE `config_job_position` DISABLE KEYS */;
INSERT INTO `config_job_position` VALUES (1,'Project Manager'),(2,'Backend Developer'),(3,'Frontend Developer');
/*!40000 ALTER TABLE `config_job_position` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `config_score_card`
--

DROP TABLE IF EXISTS `config_score_card`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `config_score_card` (
  `id` int NOT NULL AUTO_INCREMENT,
  `score_card_name` varchar(500) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config_score_card`
--

LOCK TABLES `config_score_card` WRITE;
/*!40000 ALTER TABLE `config_score_card` DISABLE KEYS */;
INSERT INTO `config_score_card` VALUES (1,'Technical Skills'),(2,'Communication'),(3,'Problem Solving');
/*!40000 ALTER TABLE `config_score_card` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `config_screening_type`
--

DROP TABLE IF EXISTS `config_screening_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `config_screening_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `screening_type_name` varchar(500) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config_screening_type`
--

LOCK TABLES `config_screening_type` WRITE;
/*!40000 ALTER TABLE `config_screening_type` DISABLE KEYS */;
INSERT INTO `config_screening_type` VALUES (1,'Online Test'),(2,'Telephonic Screen'),(3,'Video Screen'),(4,'Technical Interview');
/*!40000 ALTER TABLE `config_screening_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2025-05-26 05:30:04.707766'),(2,'auth','0001_initial','2025-05-26 05:30:05.206388'),(3,'admin','0001_initial','2025-05-26 05:30:05.395228'),(4,'admin','0002_logentry_remove_auto_add','2025-05-26 05:30:05.403536'),(5,'admin','0003_logentry_add_action_flag_choices','2025-05-26 05:30:05.412651'),(6,'contenttypes','0002_remove_content_type_name','2025-05-26 05:30:05.484701'),(7,'auth','0002_alter_permission_name_max_length','2025-05-26 05:30:05.523143'),(8,'auth','0003_alter_user_email_max_length','2025-05-26 05:30:05.555431'),(9,'auth','0004_alter_user_username_opts','2025-05-26 05:30:05.562959'),(10,'auth','0005_alter_user_last_login_null','2025-05-26 05:30:05.599466'),(11,'auth','0006_require_contenttypes_0002','2025-05-26 05:30:05.602692'),(12,'auth','0007_alter_validators_add_error_messages','2025-05-26 05:30:05.607571'),(13,'auth','0008_alter_user_username_max_length','2025-05-26 05:30:05.643469'),(14,'auth','0009_alter_user_last_name_max_length','2025-05-26 05:30:05.674665'),(15,'auth','0010_alter_group_name_max_length','2025-05-26 05:30:05.710646'),(16,'auth','0011_update_proxy_permissions','2025-05-26 05:30:05.717704'),(17,'auth','0012_alter_user_first_name_max_length','2025-05-26 05:30:05.750223'),(18,'myapp','0001_initial','2025-05-26 05:30:05.753447'),(19,'myapp','0002_userroledetails','2025-05-26 05:30:05.754993'),(20,'sessions','0001_initial','2025-05-26 05:30:05.788015'),(21,'myapp','0003_jobrequisition','2025-05-26 07:30:50.947302'),(22,'myapp','0004_posting_jobrequisition_no_of_positions_and_more','2025-06-01 05:38:34.318535'),(23,'token_blacklist','0001_initial','2025-07-19 02:25:36.549408'),(24,'token_blacklist','0002_outstandingtoken_jti_hex','2025-07-19 02:25:36.587653'),(25,'token_blacklist','0003_auto_20171017_2007','2025-07-19 02:25:36.603929');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('rwv83m8axcqjughixkhje6umpvetn77e','eyJyb2xlX25hbWUiOiJIaXJpbmcgTWFuYWdlciIsIlVzZXJJRCI6MX0:1uPZor:FUqaRhL0uOL1wftt7PLBRotMAYuXQLQpZvJGYJEGMaY','2025-06-26 04:45:41.212096'),('xdcx6oeso5rhsejbpx4g83hgh0s8s0wh','eyJyb2xlX25hbWUiOiJIaXJpbmcgTWFuYWdlciIsIlVzZXJJRCI6MX0:1uPZv0:GBm6uH63-bQgQ_lXSAH50frRIk9QNTtbF0UgMo8E0K8','2025-06-26 04:52:02.921308');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `document_item`
--

DROP TABLE IF EXISTS `document_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `document_item` (
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
  KEY `candidate_id` (`candidate_id`),
  CONSTRAINT `document_item_ibfk_1` FOREIGN KEY (`candidate_id`) REFERENCES `candidate_profile` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document_item`
--

LOCK TABLES `document_item` WRITE;
/*!40000 ALTER TABLE `document_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `document_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `financial_documents`
--

DROP TABLE IF EXISTS `financial_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `financial_documents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `candidate_id` int DEFAULT NULL,
  `pf_number` varchar(50) DEFAULT NULL,
  `uan_number` varchar(50) DEFAULT NULL,
  `pran_number` varchar(50) DEFAULT NULL,
  `form_16` varchar(255) DEFAULT NULL,
  `salary_slips` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `candidate_id` (`candidate_id`),
  CONSTRAINT `financial_documents_ibfk_1` FOREIGN KEY (`candidate_id`) REFERENCES `candidate_profile` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `financial_documents`
--

LOCK TABLES `financial_documents` WRITE;
/*!40000 ALTER TABLE `financial_documents` DISABLE KEYS */;
/*!40000 ALTER TABLE `financial_documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `generated_offer`
--

DROP TABLE IF EXISTS `generated_offer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `generated_offer` (
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
  KEY `candidate_id` (`candidate_id`),
  CONSTRAINT `generated_offer_ibfk_1` FOREIGN KEY (`requisition_id`) REFERENCES `jobrequisition` (`id`) ON DELETE CASCADE,
  CONSTRAINT `generated_offer_ibfk_2` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`CandidateID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `generated_offer`
--

LOCK TABLES `generated_offer` WRITE;
/*!40000 ALTER TABLE `generated_offer` DISABLE KEYS */;
INSERT INTO `generated_offer` VALUES (12,46,52,'pixelreq@gmail.com','Developer','Select city','India','INR','2025-09-15','Generated','2025-09-07 16:58:33','2025-09-08 18:15:58');
/*!40000 ALTER TABLE `generated_offer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `insurance_detail`
--

DROP TABLE IF EXISTS `insurance_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `insurance_detail` (
  `id` int NOT NULL AUTO_INCREMENT,
  `candidate_id` int DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `candidate_id` (`candidate_id`),
  CONSTRAINT `insurance_detail_ibfk_1` FOREIGN KEY (`candidate_id`) REFERENCES `candidate_profile` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `insurance_detail`
--

LOCK TABLES `insurance_detail` WRITE;
/*!40000 ALTER TABLE `insurance_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `insurance_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `interview`
--

DROP TABLE IF EXISTS `interview`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interview` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interview`
--

LOCK TABLES `interview` WRITE;
/*!40000 ALTER TABLE `interview` DISABLE KEYS */;
/*!40000 ALTER TABLE `interview` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `interview_review`
--

DROP TABLE IF EXISTS `interview_review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interview_review` (
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
  KEY `fk_candidate_review` (`candidate_id`),
  CONSTRAINT `fk_candidate_review` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`CandidateID`) ON DELETE CASCADE,
  CONSTRAINT `fk_schedule` FOREIGN KEY (`schedule_id`) REFERENCES `interview_schedule` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interview_review`
--

LOCK TABLES `interview_review` WRITE;
/*!40000 ALTER TABLE `interview_review` DISABLE KEYS */;
INSERT INTO `interview_review` VALUES (31,72,'','','2025-09-06 15:14:05','\"Hiring Manager Screen\"','\"good\"','\"python\"','4',50,'\"good\"','2025-09-06 15:14:05',52),(32,73,'','','2025-09-06 15:14:05','\"Technical Round 1\"','\"good\"','\"python\"','4',50,'\"good\"','2025-09-06 15:14:05',52);
/*!40000 ALTER TABLE `interview_review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `interview_schedule`
--

DROP TABLE IF EXISTS `interview_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interview_schedule` (
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
  KEY `fk_interviewer` (`interviewer_id`),
  CONSTRAINT `fk_candidate` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`CandidateID`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_interviewer` FOREIGN KEY (`interviewer_id`) REFERENCES `interviewer` (`interviewer_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interview_schedule`
--

LOCK TABLES `interview_schedule` WRITE;
/*!40000 ALTER TABLE `interview_schedule` DISABLE KEYS */;
INSERT INTO `interview_schedule` VALUES (72,52,50,'Hiring Manager Screen','2025-09-08','22:00:00','22:30:00','https://us05web.zoom.us/j/86949902936?pwd=m1mNJRGCmscBJQr0vwLL2GjhwkmA9E.1','2025-09-07 16:33:17','Zoom','IST','Hiring Manager Screen','video_interview','[{\"name\": \"Imran\", \"email\": \" shaikimran97108@gmail.com\"}]','30 mins'),(73,52,51,'Technical Round 1','2025-09-11','21:00:00','21:30:00','https://us05web.zoom.us/j/83170013581?pwd=5aiZyj5kzABASR0yR7JDUTtjMOib7D.1','2025-09-07 16:34:13','Zoom','IST','Technical Round 1','video_interview','[]','30 mins');
/*!40000 ALTER TABLE `interview_schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `interview_slot`
--

DROP TABLE IF EXISTS `interview_slot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interview_slot` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `interviewer_id` bigint DEFAULT NULL,
  `date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `round_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `int_fk_id` (`interviewer_id`),
  KEY `fk_round_id` (`round_id`),
  CONSTRAINT `fk_round_id` FOREIGN KEY (`round_id`) REFERENCES `job_interview_design_parameters` (`interview_desing_params_id`),
  CONSTRAINT `int_fk_id` FOREIGN KEY (`interviewer_id`) REFERENCES `interviewer` (`interviewer_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=160 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interview_slot`
--

LOCK TABLES `interview_slot` WRITE;
/*!40000 ALTER TABLE `interview_slot` DISABLE KEYS */;
INSERT INTO `interview_slot` VALUES (158,50,'2025-09-08','22:00:00','23:00:00','2025-09-07 16:31:24',NULL),(159,51,'2025-09-11','21:00:00','22:30:00','2025-09-07 16:32:27',NULL);
/*!40000 ALTER TABLE `interview_slot` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `interview_team`
--

DROP TABLE IF EXISTS `interview_team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interview_team` (
  `id` int NOT NULL AUTO_INCREMENT,
  `requisition_id` varchar(50) NOT NULL,
  `employee_id` varchar(50) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interview_team`
--

LOCK TABLES `interview_team` WRITE;
/*!40000 ALTER TABLE `interview_team` DISABLE KEYS */;
/*!40000 ALTER TABLE `interview_team` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `interviewer`
--

DROP TABLE IF EXISTS `interviewer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interviewer` (
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
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `fk_user_interviewer` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interviewer`
--

LOCK TABLES `interviewer` WRITE;
/*!40000 ALTER TABLE `interviewer` DISABLE KEYS */;
INSERT INTO `interviewer` VALUES (50,'RQ0003','','Drake','B','Salesforce Architect','video_interview','Hiring Manager Screen','abhikp124@gmail.com',NULL,'2025-09-07 16:31:24',NULL),(51,'RQ0003','','Akon','S','Salesforce Architect','video_interview','Technical Round 1','abhik.paul@outlook.com',NULL,'2025-09-07 16:32:27',NULL);
/*!40000 ALTER TABLE `interviewer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_communication_skills`
--

DROP TABLE IF EXISTS `job_communication_skills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_communication_skills` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `plan_id` varchar(50) NOT NULL,
  `skill_name` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `skill_value` varchar(200) NOT NULL DEFAULT '',
  `updt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_communication_skills`
--

LOCK TABLES `job_communication_skills` WRITE;
/*!40000 ALTER TABLE `job_communication_skills` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_communication_skills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_hiring_overview`
--

DROP TABLE IF EXISTS `job_hiring_overview`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_hiring_overview` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `hiring_plan_id` varchar(50) NOT NULL DEFAULT '',
  `job_position` varchar(500) NOT NULL DEFAULT '',
  `tech_stacks` text,
  `jd_details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `designation` text,
  `experience_range` text,
  `target_companies` text,
  `compensation` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `working_model` text,
  `interview_status` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `location` text,
  `education_decision` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `relocation` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `travel_opportunities` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `domain_knowledge` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `visa_requirements` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `background_verification` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `bg_verification_type` text,
  `shift_timings` text,
  `role_type` text,
  `job_type` text,
  `communication_language` text,
  `notice_period` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `additional_comp` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `citizen_requirement` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `career_gap` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `sabbatical` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `screening_questions` text,
  `job_health_requirement` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `social_media_links` text,
  `social_media_data` json DEFAULT NULL,
  `compensation_range` text,
  `language_proficiency` text,
  `requisition_template` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `no_of_openings` int DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `mode_of_working` varchar(255) DEFAULT NULL,
  `relocation_amount` varchar(255) DEFAULT NULL,
  `domain_yn` varchar(255) DEFAULT NULL,
  `domain_name` varchar(255) DEFAULT NULL,
  `citizen_describe` varchar(255) DEFAULT NULL,
  `health_describe` varchar(255) DEFAULT NULL,
  `education_qualification` text,
  `visa_country` varchar(255) DEFAULT NULL,
  `visa_type` varchar(255) DEFAULT NULL,
  `github_link` varchar(255) DEFAULT NULL,
  `currency_type` varchar(50) DEFAULT NULL,
  `relocation_currency_type` varchar(50) DEFAULT NULL,
  `sub_domain_name` varchar(255) DEFAULT NULL,
  `citizen_countries` text,
  `job_role` text,
  `domain_details` json DEFAULT NULL,
  `visa_details` json DEFAULT NULL,
  `client_name` varchar(255) DEFAULT NULL,
  `client_id` varchar(50) DEFAULT NULL,
  `social_media_link` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_client_id` (`client_id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_hiring_overview`
--

LOCK TABLES `job_hiring_overview` WRITE;
/*!40000 ALTER TABLE `job_hiring_overview` DISABLE KEYS */;
INSERT INTO `job_hiring_overview` VALUES (31,'PL0001','Project Manager, Python developer','Python','Sample','Software Engineer I','2-5','Accenture',NULL,'Remote',NULL,'Bangalore, London',NULL,'Yes','55',NULL,NULL,NULL,'Basic, Advances','Day Shift','Full Time','Permanant','English:Advanced',NULL,NULL,'Yes','Yes',NULL,NULL,NULL,'','\"\"','0-5','Advanced',NULL,25,'2025-09-06 14:53:45',NULL,'25000',NULL,'',NULL,NULL,'BE','','',NULL,'INR','INR','','','Project Manager, Python developer','[{\"domain_name\": \"Finance\", \"sub_domain_name\": \"Finance\"}]','[{\"visa_type\": \"H1B\", \"visa_country\": \"USA\"}]','Accenture','CL0001','No'),(32,'PL0002','Data Engineer','Python, SQL','Test for Data Engineer','Data Engineer II','5-10','Netazza, Adobe',NULL,'client site, Remote',NULL,'Bangalore, Gurgaon, Pune',NULL,'Yes','30',NULL,NULL,NULL,'','Australian Shift, Day Shift','Full Time','Permanant','English:Intermediate',NULL,NULL,'No','No',NULL,NULL,NULL,'','\"\"','0-5','Intermediate',NULL,4,'2025-09-06 16:15:08',NULL,'50000',NULL,'',NULL,NULL,'MBA, B Tech','','',NULL,'INR','INR','','','Data Engineer','[{\"domain_name\": \"\", \"sub_domain_name\": \"\"}]','[{\"visa_type\": \"\", \"visa_country\": \"\"}]','Informatica','CL0002','Yes'),(33,'PL0003','Python developer, Product Manager, UX Designer, Python Developer','Django, Python','Sample','Software Engineer I','5-10','Accenture',NULL,'Remote',NULL,'New York',NULL,'Yes','55',NULL,NULL,NULL,'Basic','Night Shift','Part Time','Permanant','English:Advanced, Tamil:Intermediate',NULL,NULL,'Yes','Yes',NULL,NULL,NULL,'','\"\"','0-5','Advanced, Intermediate',NULL,35,'2025-09-07 05:53:29',NULL,'25000',NULL,'',NULL,NULL,'B Tech','','',NULL,'INR','INR','','','Python developer, Product Manager, UX Designer, Python Developer','[{\"domain_name\": \"\", \"sub_domain_name\": \"\"}]','[{\"visa_type\": \"H1B\", \"visa_country\": \"USA\"}]','Adobe','CL0003','No'),(34,'PL0004','Salesforce Architect','SQL','Test','Senior Developer','10+ years','Zendesk, Oracle, Servicenow, Freshworks',NULL,'Remote, Hybrid',NULL,'Bangalore, Pune',NULL,'No','30',NULL,NULL,NULL,'','Night Shift, Day Shift','Full Time','Permanant','German:Advanced',NULL,NULL,'No','No',NULL,NULL,NULL,':','\": \"','0-5','Advanced',NULL,4,'2025-09-07 16:09:20',NULL,'',NULL,'',NULL,NULL,'B Tech, BE',NULL,NULL,NULL,'INR','','','','Salesforce Architect','[{\"domain_name\": \"\", \"sub_domain_name\": \"\"}]','[{\"visa_type\": \"\", \"visa_country\": \"\"}]','Zuora','CL0004','No');
/*!40000 ALTER TABLE `job_hiring_overview` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_interview_design_parameters`
--

DROP TABLE IF EXISTS `job_interview_design_parameters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_interview_design_parameters` (
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
  `skills` json DEFAULT NULL,
  `round_no` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`interview_desing_params_id`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_interview_design_parameters`
--

LOCK TABLES `job_interview_design_parameters` WRITE;
/*!40000 ALTER TABLE `job_interview_design_parameters` DISABLE KEYS */;
INSERT INTO `job_interview_design_parameters` VALUES (50,'',16,'Technical Round 1','mandatory','NA',0,'telephonic_interview',40,50,'','NA','mins','\"Python\"','1'),(51,'',16,'Hiring Manager Screen','mandatory','NA',0,'video_interview',40,50,'','NA','mins','\"Data Engineering\"','2'),(52,'',15,'Technical Round 1','optionals','good',0,'video_interview',2,50,'','good','hours','\"python\"','1'),(53,'',15,'Technical Round 2','optionals','good',0,'assessment',3,50,'','good','hours','\"React\"','2'),(54,'',17,'Hiring Manager Screen','optionals','NA',0,'video_interview',60,50,'','NA','mins','\"NA\"','1'),(55,'',17,'Technical Round 1','mandatory','NA',0,'video_interview',60,50,'','NA','mins','\"NA\"','2');
/*!40000 ALTER TABLE `job_interview_design_parameters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_interview_design_screen`
--

DROP TABLE IF EXISTS `job_interview_design_screen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_interview_design_screen` (
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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_interview_design_screen`
--

LOCK TABLES `job_interview_design_screen` WRITE;
/*!40000 ALTER TABLE `job_interview_design_screen` DISABLE KEYS */;
INSERT INTO `job_interview_design_screen` VALUES (15,'PL0001','RQ0001','','Python','',2,0,'',''),(16,'PL0002','RQ0002','','Python, SQL','',2,0,'',''),(17,'PL0004','RQ0003','','SQL','',2,0,'','');
/*!40000 ALTER TABLE `job_interview_design_screen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_interview_planning`
--

DROP TABLE IF EXISTS `job_interview_planning`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_interview_planning` (
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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_interview_planning`
--

LOCK TABLES `job_interview_planning` WRITE;
/*!40000 ALTER TABLE `job_interview_planning` DISABLE KEYS */;
INSERT INTO `job_interview_planning` VALUES (16,'PL0001','RQ0001',10,0,8,4,30,0,3,2,1,17,2,40,120,0,120,240,240,6,24,39),(17,'','RQ0002',10,0,8,4,10,0,2,2,1,5,30,40,40,0,40,80,80,2,8,9);
/*!40000 ALTER TABLE `job_interview_planning` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_request_interview_rounds`
--

DROP TABLE IF EXISTS `job_request_interview_rounds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_request_interview_rounds` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `plan_id` varchar(50) NOT NULL,
  `requisition_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `round_name` varchar(500) NOT NULL,
  `updt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_request_interview_rounds`
--

LOCK TABLES `job_request_interview_rounds` WRITE;
/*!40000 ALTER TABLE `job_request_interview_rounds` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_request_interview_rounds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_stage_responsibility`
--

DROP TABLE IF EXISTS `job_stage_responsibility`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_stage_responsibility` (
  `stage_id` bigint unsigned NOT NULL AUTO_INCREMENT,
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_stage_responsibility`
--

LOCK TABLES `job_stage_responsibility` WRITE;
/*!40000 ALTER TABLE `job_stage_responsibility` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_stage_responsibility` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobrequisition`
--

DROP TABLE IF EXISTS `jobrequisition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobrequisition` (
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
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobrequisition`
--

LOCK TABLES `jobrequisition` WRITE;
/*!40000 ALTER TABLE `jobrequisition` DISABLE KEYS */;
INSERT INTO `jobrequisition` VALUES (46,'RQ0003','34','Salesforce Architect',1,'PixelREQ',4,'0','B.Tech','Move ahead','Zuora','CL0004','Approved','2025-09-07 16:09:43','2025-09-07 16:14:57','2025-10-21','2025-12-31'),(47,'RQ0004',NULL,'Python developer',1,'Not Assigned',122,'0','B.Tech','','Abc','CL0005','Pending Approval','2025-09-07 16:59:36','2025-09-07 17:00:18','2025-10-04','2025-10-31');
/*!40000 ALTER TABLE `jobrequisition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nominee`
--

DROP TABLE IF EXISTS `nominee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nominee` (
  `id` int NOT NULL AUTO_INCREMENT,
  `candidate_id` int DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `share_percentage` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `candidate_id` (`candidate_id`),
  CONSTRAINT `nominee_ibfk_1` FOREIGN KEY (`candidate_id`) REFERENCES `candidate_profile` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nominee`
--

LOCK TABLES `nominee` WRITE;
/*!40000 ALTER TABLE `nominee` DISABLE KEYS */;
/*!40000 ALTER TABLE `nominee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `offer_negotiation`
--

DROP TABLE IF EXISTS `offer_negotiation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `offer_negotiation` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
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
  KEY `fk_candidate_offer` (`candidate_id`),
  CONSTRAINT `fk_candidate_offer` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`CandidateID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `offer_negotiation`
--

LOCK TABLES `offer_negotiation` WRITE;
/*!40000 ALTER TABLE `offer_negotiation` DISABLE KEYS */;
INSERT INTO `offer_negotiation` VALUES (19,'RQ0003','Zuora','CL0004','Manjunath','Rathore','Salesforce Architect',20000.00,25000.00,'Architect','Developer','Bangalore','Hubbali','2025-09-30','2025-09-15','Onsite','Remote','Successful','Yes','2025-09-07 16:46:13','2025-09-08 18:15:32',52);
/*!40000 ALTER TABLE `offer_negotiation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `offer_negotiation_benefits`
--

DROP TABLE IF EXISTS `offer_negotiation_benefits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `offer_negotiation_benefits` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `offer_negotiation_id` int NOT NULL,
  `benefit_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `offernegotiation_id` (`offer_negotiation_id`,`benefit_id`),
  KEY `benefit_id` (`benefit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `offer_negotiation_benefits`
--

LOCK TABLES `offer_negotiation_benefits` WRITE;
/*!40000 ALTER TABLE `offer_negotiation_benefits` DISABLE KEYS */;
/*!40000 ALTER TABLE `offer_negotiation_benefits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `offer_salary_component`
--

DROP TABLE IF EXISTS `offer_salary_component`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `offer_salary_component` (
  `id` int NOT NULL AUTO_INCREMENT,
  `offer_id` int NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `value` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `offer_id` (`offer_id`),
  CONSTRAINT `offer_salary_component_ibfk_1` FOREIGN KEY (`offer_id`) REFERENCES `generated_offer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `offer_salary_component`
--

LOCK TABLES `offer_salary_component` WRITE;
/*!40000 ALTER TABLE `offer_salary_component` DISABLE KEYS */;
INSERT INTO `offer_salary_component` VALUES (28,12,'Base Salary','25000.00');
/*!40000 ALTER TABLE `offer_salary_component` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `offer_variable_pay_component`
--

DROP TABLE IF EXISTS `offer_variable_pay_component`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `offer_variable_pay_component` (
  `id` int NOT NULL AUTO_INCREMENT,
  `offer_id` int NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `value` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `offer_id` (`offer_id`),
  CONSTRAINT `offer_variable_pay_component_ibfk_1` FOREIGN KEY (`offer_id`) REFERENCES `generated_offer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `offer_variable_pay_component`
--

LOCK TABLES `offer_variable_pay_component` WRITE;
/*!40000 ALTER TABLE `offer_variable_pay_component` DISABLE KEYS */;
/*!40000 ALTER TABLE `offer_variable_pay_component` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `offerletter`
--

DROP TABLE IF EXISTS `offerletter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `offerletter` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `offerletter`
--

LOCK TABLES `offerletter` WRITE;
/*!40000 ALTER TABLE `offerletter` DISABLE KEYS */;
/*!40000 ALTER TABLE `offerletter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_details`
--

DROP TABLE IF EXISTS `personal_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_details` (
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
  UNIQUE KEY `candidate_id` (`candidate_id`),
  CONSTRAINT `personal_details_ibfk_1` FOREIGN KEY (`candidate_id`) REFERENCES `candidate_profile` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_details`
--

LOCK TABLES `personal_details` WRITE;
/*!40000 ALTER TABLE `personal_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `personal_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posting_details`
--

DROP TABLE IF EXISTS `posting_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `posting_details` (
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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posting_details`
--

LOCK TABLES `posting_details` WRITE;
/*!40000 ALTER TABLE `posting_details` DISABLE KEYS */;
INSERT INTO `posting_details` VALUES (19,'RQ0003','10+ years','Software Engineer I','','Software Engineer I','<p>Test</p>','<p>Test</p>','BE, B Tech','2025-09-07 16:13:54','2025-09-07 16:13:57'),(20,'RQ0004','2-5','Software Engineer I','','Senior Developer','<p>adsfas</p>','<p>gadfdag</p>','MBA','2025-09-07 17:00:18','2025-09-07 17:00:18');
/*!40000 ALTER TABLE `posting_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `questions` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questions`
--

LOCK TABLES `questions` WRITE;
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;
/*!40000 ALTER TABLE `questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reference_check`
--

DROP TABLE IF EXISTS `reference_check`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reference_check` (
  `id` int NOT NULL AUTO_INCREMENT,
  `candidate_id` int DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `designation` varchar(100) DEFAULT NULL,
  `reporting_manager_name` varchar(100) DEFAULT NULL,
  `official_email` varchar(254) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `candidate_id` (`candidate_id`),
  CONSTRAINT `reference_check_ibfk_1` FOREIGN KEY (`candidate_id`) REFERENCES `candidate_profile` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reference_check`
--

LOCK TABLES `reference_check` WRITE;
/*!40000 ALTER TABLE `reference_check` DISABLE KEYS */;
/*!40000 ALTER TABLE `reference_check` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requisition_competency`
--

DROP TABLE IF EXISTS `requisition_competency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requisition_competency` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requisition_competency`
--

LOCK TABLES `requisition_competency` WRITE;
/*!40000 ALTER TABLE `requisition_competency` DISABLE KEYS */;
/*!40000 ALTER TABLE `requisition_competency` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requisition_details`
--

DROP TABLE IF EXISTS `requisition_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requisition_details` (
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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requisition_details`
--

LOCK TABLES `requisition_details` WRITE;
/*!40000 ALTER TABLE `requisition_details` DISABLE KEYS */;
INSERT INTO `requisition_details` VALUES (19,'RQ0003','Salesforce Architect','Salesforce Architect','Salesforce Architect','Insurance','Insurance','Insurance','Insurance','Bangalore, Pune','APAC','General Employee Group','General Sub Group',NULL,NULL,'','Zuora','','P4','P4.2','Automation','kubernetes','Remote, Hybrid','Full Time','Yes',0,'Not Assigned','No Team Assigned','No ISG Team Assigned','Not Available','2025-09-07 16:13:54','2025-09-07 16:13:57',NULL,NULL),(20,'RQ0004','Software Engineer II','Sales Director','Python developer','Finance','Product','Healthcare','Product','New York','LATAM','General Employee Group','General Sub Group',NULL,NULL,'','Abc','','P4','P4.2','Python','docker','Remote','Part Time','Yes',0,'Not Assigned','No Team Assigned','No ISG Team Assigned','Not Available','2025-09-07 17:00:18','2025-09-07 17:00:18',NULL,NULL);
/*!40000 ALTER TABLE `requisition_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requisition_question`
--

DROP TABLE IF EXISTS `requisition_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requisition_question` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requisition_question`
--

LOCK TABLES `requisition_question` WRITE;
/*!40000 ALTER TABLE `requisition_question` DISABLE KEYS */;
/*!40000 ALTER TABLE `requisition_question` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teams`
--

DROP TABLE IF EXISTS `teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teams` (
  `id` int NOT NULL AUTO_INCREMENT,
  `requisition_id` varchar(50) NOT NULL,
  `team_type` varchar(50) DEFAULT NULL,
  `team_name` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teams`
--

LOCK TABLES `teams` WRITE;
/*!40000 ALTER TABLE `teams` DISABLE KEYS */;
/*!40000 ALTER TABLE `teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userrole`
--

DROP TABLE IF EXISTS `userrole`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userrole` (
  `RoleID` int NOT NULL AUTO_INCREMENT,
  `RoleName` enum('Hiring Manager','Recruiter','Business Ops','Interviewer','Vendor') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`RoleID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userrole`
--

LOCK TABLES `userrole` WRITE;
/*!40000 ALTER TABLE `userrole` DISABLE KEYS */;
INSERT INTO `userrole` VALUES (1,'Hiring Manager'),(2,'Recruiter'),(3,'Business Ops'),(4,'Interviewer'),(5,'Vendor');
/*!40000 ALTER TABLE `userrole` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_details`
--

DROP TABLE IF EXISTS `users_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_details` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_details`
--

LOCK TABLES `users_details` WRITE;
/*!40000 ALTER TABLE `users_details` DISABLE KEYS */;
INSERT INTO `users_details` VALUES (1,'PixelHR',1,'pixelhr@gmail.com','pbkdf2_sha256$1000000$N1sbu22wbKw9gJTFmbpq4R$vpDXvWtFyAzqayvxGYm7EM54rRst5xNuRJMOFbmPlVg=',NULL,'2025-05-26 05:10:52'),(2,'PixelREQ',2,'pixelreq@gmail.com','pbkdf2_sha256$1000000$N1sbu22wbKw9gJTFmbpq4R$vpDXvWtFyAzqayvxGYm7EM54rRst5xNuRJMOFbmPlVg=',NULL,'2025-05-26 05:10:52'),(3,'PixelBO',3,'pixelbo@gmail.com','pbkdf2_sha256$1000000$N1sbu22wbKw9gJTFmbpq4R$vpDXvWtFyAzqayvxGYm7EM54rRst5xNuRJMOFbmPlVg=',NULL,'2025-05-26 05:10:52'),(4,'PixelInt',4,'pixelint@gmail.com','pbkdf2_sha256$1000000$N1sbu22wbKw9gJTFmbpq4R$vpDXvWtFyAzqayvxGYm7EM54rRst5xNuRJMOFbmPlVg=',NULL,'2025-05-26 05:10:52'),(5,'ANAND',1,'anand040593@gmail.com','pbkdf2_sha256$1000000$s5wZjZTM19ND2LpAqQOOzD$lNsk5Rxt9kUB3yHXp0c9EUo3ZmW7CB/BsddEbUcQWSA=','KulesSJQnXgQqCyZOhoE71udhj6ukHnz','2025-05-26 05:10:52'),(6,'Kumar',4,'kumar.sachidanand@gmail.com','pbkdf2_sha256$1000000$s5wZjZTM19ND2LpAqQOOzD$lNsk5Rxt9kUB3yHXp0c9EUo3ZmW7CB/BsddEbUcQWSA=',NULL,'2025-05-26 05:10:52'),(7,'Pixelvendor',5,'pixelven@gmail.com','pbkdf2_sha256$1000000$N1sbu22wbKw9gJTFmbpq4R$vpDXvWtFyAzqayvxGYm7EM54rRst5xNuRJMOFbmPlVg=',NULL,'2025-05-26 05:10:52');
/*!40000 ALTER TABLE `users_details` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-09  5:22:24
