-- MySQL dump 10.13  Distrib 8.0.42, for Linux (x86_64)
--
-- Host: localhost    Database: pixeladvant_hiring
-- ------------------------------------------------------
-- Server version	8.0.42

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `approval_status`
--

LOCK TABLES `approval_status` WRITE;
/*!40000 ALTER TABLE `approval_status` DISABLE KEYS */;
INSERT INTO `approval_status` VALUES (1,1,1,'Approved','2025-08-01 06:08:38');
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
  KEY `fk_requisition` (`requisition_id`),
  CONSTRAINT `fk_requisition` FOREIGN KEY (`requisition_id`) REFERENCES `jobrequisition` (`RequisitionID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `approver`
--

LOCK TABLES `approver` WRITE;
/*!40000 ALTER TABLE `approver` DISABLE KEYS */;
INSERT INTO `approver` VALUES (1,'PL0001','HR','Anand','Sivakumar','anandsivakumar27@gmail.com','09994551690','Software Engineer','2025-07-30 09:47:55','Yes','RQ0001');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asset_details`
--

LOCK TABLES `asset_details` WRITE;
/*!40000 ALTER TABLE `asset_details` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'temporarypassword',NULL,0,'hiring','','','hiring@pixeladvant.com',0,1,'2025-07-16 08:21:16.755939'),(2,'pbkdf2_sha256$1000000$0YwnwKLw6vy7CDVea4m7MU$kA4acs1GFa8HXporfpQ8OXBD4scoYzX006aKj+nGS0k=',NULL,0,'pixelhr@gmail.com','','','pixelhr@gmail.com',0,1,'2025-07-19 02:21:49.471282'),(3,'pbkdf2_sha256$1000000$yiOWhpERHOQpMYK1dNETpv$ygvqwkGqW7h0nTEbotpQdgVmojvD6WS5q2CNcna5PH4=',NULL,0,'pixelbo@gmail.com','','','pixelbo@gmail.com',0,1,'2025-07-19 02:39:15.076782'),(4,'pbkdf2_sha256$1000000$0yzrBqecOCpG0hW1Fh8it7$RVp+Fnq077Hst2ISkCLh7r4refWvXJjaHbaysBkC/zs=',NULL,0,'pixelreq@gmail.com','','','pixelreq@gmail.com',0,1,'2025-07-19 02:39:25.558270'),(5,'pbkdf2_sha256$1000000$JtViLKCDbU0aQD7IwV1ohW$1CQnWfRZXqmZcYvvAHddqs7JHxTy4v41jZIr964dOXM=',NULL,0,'pixelcan@gmail.com','','','pixelcan@gmail.com',0,1,'2025-07-30 15:12:30.899243');
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
  `id` int NOT NULL AUTO_INCREMENT,
  `requisition_id` varchar(50) NOT NULL,
  `candidate_id` int NOT NULL,
  `vendor_id` int NOT NULL,
  `selected_package_id` int DEFAULT NULL,
  `custom_checks` json DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'Initiated',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `requisition_id` (`requisition_id`),
  KEY `candidate_id` (`candidate_id`),
  KEY `vendor_id` (`vendor_id`),
  KEY `selected_package_id` (`selected_package_id`),
  CONSTRAINT `bg_check_request_ibfk_1` FOREIGN KEY (`requisition_id`) REFERENCES `jobrequisition` (`RequisitionID`),
  CONSTRAINT `bg_check_request_ibfk_2` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`CandidateID`),
  CONSTRAINT `bg_check_request_ibfk_3` FOREIGN KEY (`vendor_id`) REFERENCES `bg_vendor` (`id`),
  CONSTRAINT `bg_check_request_ibfk_4` FOREIGN KEY (`selected_package_id`) REFERENCES `bg_package` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bg_check_request`
--

LOCK TABLES `bg_check_request` WRITE;
/*!40000 ALTER TABLE `bg_check_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `bg_check_request` ENABLE KEYS */;
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
  `included_checks` json NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `vendor_id` (`vendor_id`),
  CONSTRAINT `bg_package_ibfk_1` FOREIGN KEY (`vendor_id`) REFERENCES `bg_vendor` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bg_package`
--

LOCK TABLES `bg_package` WRITE;
/*!40000 ALTER TABLE `bg_package` DISABLE KEYS */;
/*!40000 ALTER TABLE `bg_package` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bg_vendor`
--

DROP TABLE IF EXISTS `bg_vendor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bg_vendor` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `contact_email` varchar(254) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bg_vendor`
--

LOCK TABLES `bg_vendor` WRITE;
/*!40000 ALTER TABLE `bg_vendor` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billing_details`
--

LOCK TABLES `billing_details` WRITE;
/*!40000 ALTER TABLE `billing_details` DISABLE KEYS */;
INSERT INTO `billing_details` VALUES (1,'RQ0001','Recrruing','2025-07-30','2025-07-30 09:44:45','2025-07-30 09:44:45','2025-10-30','2025-07-30','2025-10-30');
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `candidate_approval`
--

LOCK TABLES `candidate_approval` WRITE;
/*!40000 ALTER TABLE `candidate_approval` DISABLE KEYS */;
INSERT INTO `candidate_approval` VALUES (2,2,1,'HR','Approve',NULL,'2025-07-31 05:57:01','2025-07-31 05:56:27'),(3,3,1,'HR','Approve',NULL,'2025-07-31 16:26:14','2025-07-31 16:25:35');
/*!40000 ALTER TABLE `candidate_approval` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `candidate_interview_stages`
--

LOCK TABLES `candidate_interview_stages` WRITE;
/*!40000 ALTER TABLE `candidate_interview_stages` DISABLE KEYS */;
INSERT INTO `candidate_interview_stages` VALUES (9,2,'RQ0001','Technical','2025-07-29','Online','good',4,'Selected','Completed'),(10,2,'RQ0001','Communication','2025-07-31','Online','good',5,'Selected','Completed'),(11,3,'RQ0001','Technical','2025-07-29','Online','good',3,'Selected','Completed');
/*!40000 ALTER TABLE `candidate_interview_stages` ENABLE KEYS */;
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
  `MinimumQuestions` int DEFAULT NULL,
  `ActualRating` decimal(3,1) DEFAULT NULL,
  `Feedback` text,
  `Created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ReviewID`),
  KEY `can_id_fk` (`CandidateID`),
  CONSTRAINT `can_id_fk` FOREIGN KEY (`CandidateID`) REFERENCES `candidates` (`CandidateID`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `candidate_reviews`
--

LOCK TABLES `candidate_reviews` WRITE;
/*!40000 ALTER TABLE `candidate_reviews` DISABLE KEYS */;
INSERT INTO `candidate_reviews` VALUES (3,2,'Technical','Good',25,5.0,'','2025-07-31 05:56:27'),(4,2,'Communication','Good',25,0.0,'','2025-07-31 05:56:27'),(5,3,'Technical','Good',25,3.0,'','2025-07-31 16:25:35'),(6,3,'Communication','Good',25,4.0,'','2025-07-31 16:25:35');
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `candidate_submission`
--

LOCK TABLES `candidate_submission` WRITE;
/*!40000 ALTER TABLE `candidate_submission` DISABLE KEYS */;
/*!40000 ALTER TABLE `candidate_submission` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `candidates`
--

LOCK TABLES `candidates` WRITE;
/*!40000 ALTER TABLE `candidates` DISABLE KEYS */;
INSERT INTO `candidates` VALUES (2,'RQ0001','anand040593@gmail.com','Anand_Sivakumar_March.pdf',5,'good','Recommended','2025-07-31 05:54:18','Resume.pdf','Refferal',85,'8667735882','Anand','Sivakumar'),(3,'RQ0001','candidate4042@gmail.com','Resume.pdf',4,'moving for approval','Recommended','2025-07-31 16:17:28','This is a sample cover letter for candidate4042.','Refferal',NULL,'9999999999','CandidateFirst4042','CandidateLast4042');
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
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config_hiring_data`
--

LOCK TABLES `config_hiring_data` WRITE;
/*!40000 ALTER TABLE `config_hiring_data` DISABLE KEYS */;
INSERT INTO `config_hiring_data` VALUES (2,'Position Role','Project Manager'),(3,'Position Role','Python developer'),(4,'Screening Type','Online Test'),(5,'Screening Type','Telephonic interview'),(6,'Score Card','Technical'),(7,'Score Card','Communication'),(8,'Location','Bangalore'),(9,'Designation','Senior Developer'),(10,'Designation','Software Engineer I'),(11,'Designation','Software Engineer II'),(12,'Tech Stack','Python'),(13,'Tech Stack','Django'),(14,'Tech Stack','AWS'),(15,'Target Companies','HCL'),(16,'Target Companies','Accenture'),(17,'Working Model','Onsite'),(18,'Working Model','Hybrid'),(19,'Working Model','WFH'),(20,'Role Type','Full Time'),(21,'Role Type','Part Time'),(22,'Job Type','Contract'),(23,'Job Type','Permanant'),(24,'Mode of Working','Hybrid'),(25,'Mode of Working','Work from home'),(26,'Shift Timings','Day Shift'),(27,'Shift Timings','Night Shift'),(28,'Education Qualification','BE'),(29,'Education Qualification','B Tech'),(30,'Education Qualification','MBA'),(32,'Education Qualification','M Tech'),(33,'Communication Language','English'),(34,'Communication Language','Hindi'),(35,'Communication Language','Tamil'),(36,'Location','Coimbatore'),(37,'Location','Chennai');
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
  `currency` varchar(10) NOT NULL,
  `salary` decimal(12,2) NOT NULL,
  `variable_pay` varchar(20) NOT NULL,
  `estimated_start_date` date DEFAULT NULL,
  `negotiation_status` varchar(20) NOT NULL DEFAULT 'Generated',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `requisition_id` (`requisition_id`),
  KEY `candidate_id` (`candidate_id`),
  CONSTRAINT `generated_offer_ibfk_1` FOREIGN KEY (`requisition_id`) REFERENCES `jobrequisition` (`id`) ON DELETE CASCADE,
  CONSTRAINT `generated_offer_ibfk_2` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`CandidateID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `generated_offer`
--

LOCK TABLES `generated_offer` WRITE;
/*!40000 ALTER TABLE `generated_offer` DISABLE KEYS */;
/*!40000 ALTER TABLE `generated_offer` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interview_review`
--

LOCK TABLES `interview_review` WRITE;
/*!40000 ALTER TABLE `interview_review` DISABLE KEYS */;
INSERT INTO `interview_review` VALUES (5,9,'','','2025-07-31 14:19:21','\"Technical\"','\"good\"','10','5',50,'\"good\"','2025-07-31 14:19:21',2),(6,10,'','','2025-07-31 14:19:40','\"Communication\"','\"good\"','10','5',50,'\"good\"','2025-07-31 14:19:40',2),(7,11,'','','2025-07-31 16:28:51','\"Technical\"','\"good\"','10','4',50,'\"good\"','2025-07-31 16:28:51',3);
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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interview_schedule`
--

LOCK TABLES `interview_schedule` WRITE;
/*!40000 ALTER TABLE `interview_schedule` DISABLE KEYS */;
INSERT INTO `interview_schedule` VALUES (9,2,1,'Technical','2025-07-29','14:30:00','15:00:00','https://us05web.zoom.us/j/86923806417?pwd=w4l3HApup8iS5y3x4uZauMoxgbtJFt.1','2025-07-31 14:16:50','Zoom','IST','Technical','Online','[]','30 mins'),(10,2,4,'Communication','2025-07-31','19:00:00','19:30:00','https://us05web.zoom.us/j/89201885153?pwd=7bP4gm06N9LSoGNErFsJBgbrxrppaa.1','2025-07-31 14:18:50','Zoom','IST','Communication','Online','[]','30 mins'),(11,3,1,'Technical','2025-07-29','14:30:00','15:00:00','https://us05web.zoom.us/j/86767083072?pwd=VK6Jpn5sk2l6zyq4Rzaboa1RXxAyDk.1','2025-07-31 16:26:48','Zoom','IST','Technical','Online','[]','30 mins');
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interview_slot`
--

LOCK TABLES `interview_slot` WRITE;
/*!40000 ALTER TABLE `interview_slot` DISABLE KEYS */;
INSERT INTO `interview_slot` VALUES (1,1,'2025-07-29','14:30:00','15:00:00','2025-07-30 09:48:27',NULL),(5,4,'2025-07-31','19:00:00','19:30:00','2025-07-31 14:18:29',NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interviewer`
--

LOCK TABLES `interviewer` WRITE;
/*!40000 ALTER TABLE `interviewer` DISABLE KEYS */;
INSERT INTO `interviewer` VALUES (1,'RQ0001','','Anand','Sivakumar','Software Engineer','Online','Technical','anand040593@gmail.com',NULL,'2025-07-30 09:48:27',NULL),(4,'RQ0001','','Anand','Sivakumar','Software Engineer','Online','Communication','anand040593@gmail.com',NULL,'2025-07-31 14:18:29',NULL);
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_hiring_overview`
--

LOCK TABLES `job_hiring_overview` WRITE;
/*!40000 ALTER TABLE `job_hiring_overview` DISABLE KEYS */;
INSERT INTO `job_hiring_overview` VALUES (1,'PL0001','Python developer','Django, AWS','<p>sample</p>','Software Engineer I','5-10','Accenture, HCL',NULL,'Hybrid',NULL,'Coimbatore',NULL,'Yes','55',NULL,'Yes','Yes','Adhaar','Day Shift','Full Time','Permanant','English',NULL,NULL,'Yes','Yes',NULL,NULL,'Yes',':','[{\'media_type\': \'\', \'media_link\': \'\'}]','0-8','Advanced',NULL,25,'2025-07-30 09:42:53',NULL,'2000','Yes','Finance','indian','good','B Tech','Usa','B1',NULL);
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
  PRIMARY KEY (`interview_desing_params_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_interview_design_parameters`
--

LOCK TABLES `job_interview_design_parameters` WRITE;
/*!40000 ALTER TABLE `job_interview_design_parameters` DISABLE KEYS */;
INSERT INTO `job_interview_design_parameters` VALUES (1,'',1,'Technical','4','Good',25,'Online',60,50,'Online','Good'),(2,'',1,'Communication','4','Good',25,'Online',60,50,'Online','Good');
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_interview_design_screen`
--

LOCK TABLES `job_interview_design_screen` WRITE;
/*!40000 ALTER TABLE `job_interview_design_screen` DISABLE KEYS */;
INSERT INTO `job_interview_design_screen` VALUES (1,'PL0001','RQ0001','','Django, AWS','Online Test',2,0,'','');
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_interview_planning`
--

LOCK TABLES `job_interview_planning` WRITE;
/*!40000 ALTER TABLE `job_interview_planning` DISABLE KEYS */;
INSERT INTO `job_interview_planning` VALUES (1,'PL0001','RQ0001',10,0,8,25,12,0,25,2,2,10,2,40,300,0,300,600,1200,30,120,495);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobrequisition`
--

LOCK TABLES `jobrequisition` WRITE;
/*!40000 ALTER TABLE `jobrequisition` DISABLE KEYS */;
INSERT INTO `jobrequisition` VALUES (1,'RQ0001','1','Software Engineer',1,'Not Assigned',25,'0','B.Tech','good','HCL','CL0001','Approved','2025-07-30 09:43:11','2025-07-30 09:49:29','2025-07-30','2025-09-30');
/*!40000 ALTER TABLE `jobrequisition` ENABLE KEYS */;
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `offer_negotiation`
--

LOCK TABLES `offer_negotiation` WRITE;
/*!40000 ALTER TABLE `offer_negotiation` DISABLE KEYS */;
INSERT INTO `offer_negotiation` VALUES (1,'RQ0001','HCL','CL0001','Anand','Sivakumar','Software Engineer',12.00,123.00,'123','2133','2','3333333','2025-07-11','2025-08-02','asd','asd','Successful','asdad','2025-07-31 06:37:36','2025-08-01 06:11:19');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `offer_salary_component`
--

LOCK TABLES `offer_salary_component` WRITE;
/*!40000 ALTER TABLE `offer_salary_component` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posting_details`
--

LOCK TABLES `posting_details` WRITE;
/*!40000 ALTER TABLE `posting_details` DISABLE KEYS */;
INSERT INTO `posting_details` VALUES (1,'RQ0001','2-5 years, 5-10 years','senior_developer, project_manager','','Asia','<p>Sample</p>','<p>Sample</p>','mtech, btech','2025-07-30 09:44:45','2025-07-30 09:44:45');
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requisition_details`
--

LOCK TABLES `requisition_details` WRITE;
/*!40000 ALTER TABLE `requisition_details` DISABLE KEYS */;
INSERT INTO `requisition_details` VALUES (1,'RQ0001','Product Owner I','Product Owner I','Software Engineer','Finance','Banking','Banking','Banking','Sydney','ASIA','General Employee Group','General Sub Group',NULL,NULL,'','HCL','','P3','P3.1','Design, UI, java','aws, docker','Remote','Full Time','Yes',0,'Not Assigned','No Team Assigned','No ISG Team Assigned','Not Available','2025-07-30 09:44:45','2025-07-30 09:44:45',NULL,NULL);
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
  `RoleName` enum('Hiring Manager','Recruiter','Business Ops','Interviewer') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`RoleID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userrole`
--

LOCK TABLES `userrole` WRITE;
/*!40000 ALTER TABLE `userrole` DISABLE KEYS */;
INSERT INTO `userrole` VALUES (1,'Hiring Manager'),(2,'Recruiter'),(3,'Business Ops'),(4,'Interviewer');
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_details`
--

LOCK TABLES `users_details` WRITE;
/*!40000 ALTER TABLE `users_details` DISABLE KEYS */;
INSERT INTO `users_details` VALUES (1,'PixelHR',1,'pixelhr@gmail.com','pbkdf2_sha256$1000000$N1sbu22wbKw9gJTFmbpq4R$vpDXvWtFyAzqayvxGYm7EM54rRst5xNuRJMOFbmPlVg=',NULL,'2025-05-26 05:10:52'),(2,'PixelREQ',2,'pixelreq@gmail.com','pbkdf2_sha256$1000000$N1sbu22wbKw9gJTFmbpq4R$vpDXvWtFyAzqayvxGYm7EM54rRst5xNuRJMOFbmPlVg=',NULL,'2025-05-26 05:10:52'),(3,'PixelBO',3,'pixelbo@gmail.com','pbkdf2_sha256$1000000$N1sbu22wbKw9gJTFmbpq4R$vpDXvWtFyAzqayvxGYm7EM54rRst5xNuRJMOFbmPlVg=',NULL,'2025-05-26 05:10:52'),(4,'PixelCan',4,'pixelcan@gmail.com','pbkdf2_sha256$1000000$N1sbu22wbKw9gJTFmbpq4R$vpDXvWtFyAzqayvxGYm7EM54rRst5xNuRJMOFbmPlVg=',NULL,'2025-05-26 05:10:52'),(5,'ANAND',1,'anand040593@gmail.com','pbkdf2_sha256$1000000$s5wZjZTM19ND2LpAqQOOzD$lNsk5Rxt9kUB3yHXp0c9EUo3ZmW7CB/BsddEbUcQWSA=','KulesSJQnXgQqCyZOhoE71udhj6ukHnz','2025-05-26 05:10:52'),(6,'Kumar',4,'kumar.sachidanand@gmail.com','pbkdf2_sha256$1000000$s5wZjZTM19ND2LpAqQOOzD$lNsk5Rxt9kUB3yHXp0c9EUo3ZmW7CB/BsddEbUcQWSA=',NULL,'2025-05-26 05:10:52');
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

-- Dump completed on 2025-08-01  8:14:35
