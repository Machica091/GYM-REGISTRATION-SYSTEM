-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: 127.0.0.1    Database: gym_registration_db
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `archive_records`
--

DROP TABLE IF EXISTS `archive_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `archive_records` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `record_type` varchar(40) NOT NULL,
  `record_id` varchar(100) NOT NULL,
  `display_name` varchar(300) NOT NULL DEFAULT '',
  `archived_at` datetime NOT NULL,
  `archived_by` varchar(100) NOT NULL DEFAULT '',
  `details` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_archive_record` (`record_type`,`record_id`),
  KEY `idx_archive_date` (`archived_at`),
  KEY `idx_archive_type` (`record_type`)
) ENGINE=InnoDB AUTO_INCREMENT=409 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `archive_records`
--

LOCK TABLES `archive_records` WRITE;
/*!40000 ALTER TABLE `archive_records` DISABLE KEYS */;
INSERT INTO `archive_records` VALUES (5,'DailyGymVisit','DG-20261115142829181','Joshua','2026-11-15 15:37:28','admin','2026-11-15'),(18,'Expense','EXP-20261117210613570566','Machine','2026-11-17 21:09:32','admin','Amount: 500.00; Category: Maintenance and Repairs'),(19,'Staff','staff','Llyod M. Ruga','2026-11-17 21:35:12','stephen','Staff'),(43,'Staff','admin','System Administrator','2026-11-17 21:50:37','admin2@universalgym.ph','Staff'),(142,'Staff','stephen','Stephen Samoson','2026-11-17 22:22:43','cariaso','Front Desk Staff');
/*!40000 ALTER TABLE `archive_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attendance_records`
--

DROP TABLE IF EXISTS `attendance_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attendance_records` (
  `id` varchar(80) NOT NULL,
  `member_id` varchar(50) NOT NULL,
  `member_name` varchar(300) NOT NULL,
  `attendance_date` date NOT NULL,
  `check_in_time` datetime NOT NULL,
  `recorded_by` varchar(100) NOT NULL DEFAULT '',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_attendance_member_day` (`member_id`,`attendance_date`),
  KEY `idx_attendance_date` (`attendance_date`),
  CONSTRAINT `fk_attendance_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance_records`
--

LOCK TABLES `attendance_records` WRITE;
/*!40000 ALTER TABLE `attendance_records` DISABLE KEYS */;
INSERT INTO `attendance_records` VALUES ('ATT-20261115153545795','GM2611159712025','Andrei R. Machica','2026-11-15','2026-11-18 13:58:42','admin',0,NULL,''),('ATT-20261115153637820','GM2611159689531','Cusehse S. Cariaso','2026-11-15','2026-11-18 13:58:42','admin',0,NULL,''),('ATT-20261115160234698','GM2611157656825','Joshua Manila','2026-11-15','2026-11-18 13:58:42','admin',0,NULL,''),('ATT-20261116162806687','GM2611153032815','Mary Grace','2026-11-16','2026-11-18 13:58:42','admin',0,NULL,''),('ATT-20261116162818486','GM2611157656825','Joshua Manila','2026-11-16','2026-11-18 13:58:42','admin',0,NULL,''),('ATT-20261117190139630','GM2611171675773','Adraine Tallon','2026-11-15','2026-11-18 13:58:42','admin',0,NULL,''),('ATT-20261117190210478','GM2611171675773','Adraine Tallon','2026-11-17','2026-11-18 13:58:42','admin',0,NULL,''),('ATT-20261118115916920','GM2611171675773','Adraine Tallon','2026-11-18','2026-11-18 13:58:42','cariaso',0,NULL,'');
/*!40000 ALTER TABLE `attendance_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `daily_gym_visits`
--

DROP TABLE IF EXISTS `daily_gym_visits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `daily_gym_visits` (
  `id` varchar(80) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL DEFAULT '',
  `member_id` varchar(50) DEFAULT NULL,
  `is_gym_member` tinyint(1) NOT NULL DEFAULT 0,
  `visit_date` date NOT NULL,
  `fee` decimal(10,2) NOT NULL DEFAULT 0.00,
  `payment_method` varchar(50) NOT NULL DEFAULT 'Cash',
  `payment_reference` varchar(100) NOT NULL DEFAULT '',
  `registered_by` varchar(100) NOT NULL DEFAULT '',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `idx_visits_date` (`visit_date`),
  KEY `idx_visits_member` (`member_id`),
  CONSTRAINT `fk_visit_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `daily_gym_visits`
--

LOCK TABLES `daily_gym_visits` WRITE;
/*!40000 ALTER TABLE `daily_gym_visits` DISABLE KEYS */;
INSERT INTO `daily_gym_visits` VALUES ('DG-20261115142248253','Madi','',NULL,0,'2026-11-15',50.00,'Cash','PAY-202611155909806','admin',0,NULL,''),('DG-20261115142504245','Alli','',NULL,0,'2026-11-15',50.00,'Cash','PAY-202611155733120','admin',0,NULL,''),('DG-20261115142542300','Andrei','Machica','GM2611159712025',1,'2026-11-15',0.00,'Included','','admin',0,NULL,''),('DG-20261115142829181','Joshua','',NULL,0,'2026-11-15',50.00,'Cash','PAY-202611159473339','staff',0,NULL,''),('DG-20261115153637459','Cusehse','Cariaso','GM2611159689531',1,'2026-11-15',0.00,'Included','','admin',0,NULL,''),('DG-20261115160234272','Joshua','Manila','GM2611157656825',1,'2026-11-15',0.00,'Included','','admin',0,NULL,''),('DG-20261115160239747','Joshua','Manila','GM2611157656825',1,'2026-11-15',0.00,'Included','','admin',0,NULL,''),('DG-20261115161032361','Mae','',NULL,0,'2026-11-15',100.00,'Cash','PAY-202611158302082','admin',0,NULL,''),('DG-20261115161109165','JAMES','',NULL,0,'2026-11-15',50.00,'Cash','PAY-202611153781922','admin',0,NULL,''),('DG-20261115161134742','mARK','',NULL,0,'2026-11-15',100.00,'Cash','PAY-202611155052568','admin',0,NULL,''),('DG-20261115161453123','Babe','',NULL,0,'2026-11-15',100.00,'Cash','PAY-202611155018904','admin',0,NULL,''),('DG-20261115161512257','Mom','',NULL,0,'2026-11-15',50.00,'Cash','PAY-202611156699447','admin',0,NULL,''),('DG-20261116162806621','Mary','Grace','GM2611153032815',1,'2026-11-16',0.00,'Included','','admin',0,NULL,''),('DG-20261116162818775','Joshua','Manila','GM2611157656825',1,'2026-11-16',0.00,'Included','','admin',0,NULL,''),('DG-20261116162923929','Joshua','',NULL,0,'2026-11-16',50.00,'Cash','PAY-202611165812558','admin',0,NULL,''),('DG-20261117190139168','Adraine','Tallon','GM2611171675773',1,'2026-11-15',0.00,'Included','','admin',0,NULL,''),('DG-20261117190210431','Adraine','Tallon','GM2611171675773',1,'2026-11-17',0.00,'Included','','admin',0,NULL,''),('DG-20261117190221166','Wecks','',NULL,0,'2026-11-17',50.00,'Cash','PAY-202611174914205','admin',0,NULL,''),('DG-20261117190333693','Adraine','',NULL,0,'2026-11-17',50.00,'Cash','PAY-202611173923564','admin',0,NULL,''),('DG-20261117220749992','Adrainee','',NULL,0,'2026-11-17',50.00,'Cash','PAY-202611173747768','admin2@universalgym.ph',0,NULL,''),('DG-20261118115916833','Adraine','Tallon','GM2611171675773',1,'2026-11-18',0.00,'Included','','cariaso',0,NULL,''),('DG-20261118115922648','Adraine','',NULL,0,'2026-11-18',50.00,'Cash','PAY-202611187847138','cariaso',0,NULL,''),('DG-20261118115936478','Adraineee','',NULL,0,'2026-11-17',50.00,'Cash','PAY-202611182795938','cariaso',0,NULL,''),('DG-20261118115950682','Adrainei','',NULL,0,'2026-11-18',50.00,'Cash','PAY-202611187248808','cariaso',0,NULL,''),('DG-20261118122737175','Adrainej','',NULL,0,'2026-11-18',50.00,'Cash','PAY-202611188164404','cariaso',0,NULL,'');
/*!40000 ALTER TABLE `daily_gym_visits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expense_categories`
--

DROP TABLE IF EXISTS `expense_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `expense_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(120) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=355 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expense_categories`
--

LOCK TABLES `expense_categories` WRITE;
/*!40000 ALTER TABLE `expense_categories` DISABLE KEYS */;
INSERT INTO `expense_categories` VALUES (1,'Electricity Bill',1,'2026-11-17 21:02:34'),(2,'Water Bill',1,'2026-11-17 21:02:34'),(3,'Internet Bill',0,'2026-11-17 21:02:34'),(4,'Rental Payment',1,'2026-11-17 21:02:34'),(5,'Cleaning Supplies',1,'2026-11-17 21:02:34'),(6,'Maintenance and Repairs',1,'2026-11-17 21:02:34'),(7,'Office Supplies',1,'2026-11-17 21:02:34'),(8,'Other Expenses',1,'2026-11-17 21:02:34');
/*!40000 ALTER TABLE `expense_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expenses`
--

DROP TABLE IF EXISTS `expenses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `expenses` (
  `id` varchar(80) NOT NULL,
  `expense_name` varchar(200) NOT NULL,
  `category` varchar(120) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `expense_date` date NOT NULL,
  `payment_method` varchar(50) NOT NULL DEFAULT 'Cash',
  `description` text DEFAULT NULL,
  `recorded_by` varchar(100) NOT NULL DEFAULT '',
  `status` varchar(30) NOT NULL DEFAULT 'Active',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` varchar(100) NOT NULL DEFAULT '',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_expenses_date` (`expense_date`),
  KEY `idx_expenses_category` (`category`),
  KEY `idx_expenses_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expenses`
--

LOCK TABLES `expenses` WRITE;
/*!40000 ALTER TABLE `expenses` DISABLE KEYS */;
INSERT INTO `expenses` VALUES ('EXP-20261117210613570566','Machine','Maintenance and Repairs',500.00,'2026-11-17','Cash','The is broken','admin','Voided',1,'2026-11-17 21:09:32','admin','2026-11-17 21:06:13','2026-11-17 21:09:32'),('EXP-20261117211240460585','KURYENTE PO','Electricity Bill',900.00,'2026-11-17','Cash','','admin','Active',0,NULL,'','2026-11-17 21:12:40','2026-11-17 21:12:40'),('EXP-20261118115530326837','alcohol','Cleaning Supplies',150.00,'2026-11-18','Cash','OUT OF STOCK','cariaso','Active',0,NULL,'','2026-11-18 11:55:30','2026-11-18 11:55:30');
/*!40000 ALTER TABLE `expenses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gym_plans`
--

DROP TABLE IF EXISTS `gym_plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gym_plans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `months` int(11) NOT NULL DEFAULT 1,
  `price` decimal(12,2) NOT NULL DEFAULT 0.00,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_gym_plans_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=198 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gym_plans`
--

LOCK TABLES `gym_plans` WRITE;
/*!40000 ALTER TABLE `gym_plans` DISABLE KEYS */;
INSERT INTO `gym_plans` VALUES (1,'Monthly',1,600.00,1),(2,'2-Month Plan',2,1200.00,1),(3,'Annual Plan',12,7200.00,0),(4,'Yearly',12,10000.00,1),(11,'Daily',1,50.00,0),(179,'asdasdas',12,15000.00,0);
/*!40000 ALTER TABLE `gym_plans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `members` (
  `id` varchar(50) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT '',
  `last_name` varchar(100) NOT NULL,
  `full_name` varchar(300) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT '',
  `plan` varchar(30) NOT NULL DEFAULT 'Monthly',
  `fee` decimal(10,2) NOT NULL DEFAULT 0.00,
  `start_date` date NOT NULL,
  `expiry_date` date NOT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'Active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `idx_phone` (`phone`),
  KEY `idx_email` (`email`),
  KEY `idx_full_name` (`full_name`),
  KEY `idx_status` (`status`),
  KEY `idx_expiry_date` (`expiry_date`),
  KEY `idx_start_date` (`start_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES ('GM2611153032815','Mary','','Grace','Mary Grace','09202747475','Divine@gmail.com','Monthly',600.00,'2026-11-17','2026-12-17','Active','2026-11-15 07:20:58','2026-11-17 14:41:23',0,NULL,''),('GM2611154042871','Regine','','Velasquez','Regine Velasquez','09287466466','avi@gmail.com','Monthly',600.00,'2026-11-15','2026-12-15','Active','2026-11-15 07:51:03','2026-11-15 07:51:03',0,NULL,''),('GM2611155562373','Mark','M.','Maglasang','Mark M. Maglasang','09284747474','mark@gmail.com','Monthly',600.00,'2026-10-14','2026-11-17','Expired','2026-11-15 07:04:38','2026-11-18 03:46:33',0,NULL,''),('GM2611157656825','Joshua','','Manila','Joshua Manila','09302773777','Manila@gmail.com','Monthly',600.00,'2026-11-15','2026-12-15','Active','2026-11-15 07:08:24','2026-11-15 07:08:24',0,NULL,''),('GM2611159480970','Zedrick','','Calzada','Zedrick Calzada','09274885456','calzada@gmail.com','Monthly',600.00,'2026-11-15','2026-12-15','Active','2026-11-15 07:13:59','2026-11-15 07:13:59',0,NULL,''),('GM2611159689531','Cusehse','S.','Cariaso','Cusehse S. Cariaso','09284658599','Cariaso@gmail.com','Monthly',600.00,'2026-11-15','2026-12-15','Active','2026-11-15 06:35:23','2026-11-15 07:19:57',0,NULL,''),('GM2611159712025','Andrei','R.','Machica','Andrei R. Machica','09303334365','andrei@gmail.com','Monthly',600.00,'2026-11-15','2026-12-15','Active','2026-11-15 06:18:21','2026-11-15 06:18:21',0,NULL,''),('GM2611171675773','Adraine','','Tallon','Adraine Tallon','09321312312','tallon@gmail.com','2-Month Plan',1200.00,'2026-11-17','2027-01-17','Active','2026-11-17 10:59:02','2026-11-17 10:59:02',0,NULL,''),('GM2611176037016','Jasie','09','Machicas','Jasie 09 Machicas','09123123123','andrei@gmail.com','Monthly',600.00,'2026-11-17','2026-12-17','Active','2026-11-17 14:26:08','2026-11-17 14:26:08',0,NULL,''),('GM2611176578703','nellah','','paras','nellah paras','09758932323','Machic1@gmail.com','Monthly',600.00,'2026-11-17','2026-12-17','Active','2026-11-17 14:33:01','2026-11-17 14:33:01',0,NULL,''),('GM2611179554136','Mam','','Daisy','Mam Daisy','09328328382','machica@gmail.com','Monthly',600.00,'2026-11-17','2026-12-17','Active','2026-11-17 13:16:52','2026-11-17 13:16:52',0,NULL,''),('GM2611185105843','Stephen','S','Samoson','Stephen S Samoson','09235421231','samson@gmail.com','Yearly',10000.00,'2026-11-18','2027-11-18','Active','2026-11-18 04:26:42','2026-11-18 04:26:42',0,NULL,'');
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `membership_renewals`
--

DROP TABLE IF EXISTS `membership_renewals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `membership_renewals` (
  `reference` varchar(100) NOT NULL,
  `member_id` varchar(50) NOT NULL,
  `member_name` varchar(300) NOT NULL,
  `previous_plan` varchar(30) NOT NULL DEFAULT '',
  `new_plan` varchar(30) NOT NULL DEFAULT '',
  `previous_status` varchar(30) NOT NULL DEFAULT '',
  `previous_start_date` date NOT NULL,
  `previous_expiry_date` date NOT NULL,
  `previous_fee` decimal(10,2) NOT NULL DEFAULT 0.00,
  `new_start_date` date NOT NULL,
  `new_expiry_date` date NOT NULL,
  `new_fee` decimal(10,2) NOT NULL DEFAULT 0.00,
  `amount_paid` decimal(10,2) NOT NULL DEFAULT 0.00,
  `outstanding_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `payment_method` varchar(50) NOT NULL DEFAULT 'Cash',
  `payment_reference` varchar(100) NOT NULL DEFAULT '',
  `renewal_date` datetime NOT NULL,
  `processed_by` varchar(100) NOT NULL DEFAULT '',
  `status` varchar(30) NOT NULL DEFAULT 'Completed',
  PRIMARY KEY (`reference`),
  KEY `idx_renewals_member` (`member_id`),
  KEY `idx_renewals_date` (`renewal_date`),
  CONSTRAINT `fk_renewal_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `membership_renewals`
--

LOCK TABLES `membership_renewals` WRITE;
/*!40000 ALTER TABLE `membership_renewals` DISABLE KEYS */;
INSERT INTO `membership_renewals` VALUES ('REN-202611153810602','GM2611159689531','Cusehse S. Cariaso','Monthly','Monthly','Expired','2026-10-01','2026-11-02',600.00,'2026-11-15','2026-12-15',600.00,600.00,0.00,'Cash','PAY-202611155011888','2026-11-15 15:18:23','admin','Completed'),('REN-202611157221798','GM2611159689531','Cusehse S. Cariaso','Monthly','Monthly','Expired','2026-10-01','2026-11-02',600.00,'2026-11-15','2026-12-15',600.00,600.00,0.00,'Cash','PAY-202611158409711','2026-11-15 15:19:57','admin','Completed'),('REN-202611158019715','GM2611159689531','Cusehse S. Cariaso','Monthly','2M Plan','Expired','2026-10-15','2026-11-13',600.00,'2026-11-15','2027-01-15',1200.00,2000.00,0.00,'Cash','PAY-202611158091506','2026-11-15 15:01:28','admin','Completed'),('REN-202611158488448','GM2611159689531','Cusehse S. Cariaso','Monthly','Monthly','Expired','2026-10-15','2026-11-13',600.00,'2026-11-15','2026-12-15',600.00,600.00,0.00,'Cash','PAY-202611158002909','2026-11-15 15:07:13','admin','Completed'),('REN-202611159945394','GM2611159689531','Cusehse S. Cariaso','Monthly','Monthly','Expired','2026-10-15','2026-11-13',600.00,'2026-11-15','2026-12-15',600.00,600.00,0.00,'Cash','PAY-202611153489429','2026-11-15 15:01:48','admin','Completed'),('REN-202611177305264','GM2611153032815','Mary Grace','Monthly','Monthly','Expired','2026-10-08','2026-11-08',600.00,'2026-11-17','2026-12-17',600.00,600.00,0.00,'Cash','PAY-202611176921982','2026-11-17 22:41:23','cariaso','Completed');
/*!40000 ALTER TABLE `membership_renewals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reference` varchar(100) NOT NULL,
  `member_id` varchar(50) DEFAULT NULL,
  `member_name` varchar(300) NOT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `method` varchar(50) NOT NULL DEFAULT 'Cash',
  `date` datetime NOT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'Paid',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `amount_paid` decimal(10,2) NOT NULL DEFAULT 0.00,
  `change_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `payment_type` varchar(60) NOT NULL DEFAULT 'Membership Payment',
  `collected_by` varchar(100) NOT NULL DEFAULT '',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `reference` (`reference`),
  KEY `idx_reference` (`reference`),
  KEY `idx_member_id` (`member_id`),
  KEY `idx_date` (`date`),
  KEY `idx_status` (`status`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1144 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (15,'PAY-202611152439893','GM2611159712025','Andrei R. Machica',600.00,'Cash','2026-11-15 14:18:21','Paid','2026-11-15 06:18:21','2026-11-15 06:18:21',600.00,0.00,'Membership Payment','admin',0,NULL,''),(32,'PAY-202611155909806',NULL,'Madi',50.00,'Cash','2026-11-15 00:00:00','Paid','2026-11-15 06:22:48','2026-11-15 06:22:48',50.00,0.00,'Daily Gym Pass','admin',0,NULL,''),(52,'PAY-202611155733120',NULL,'Alli',50.00,'Cash','2026-11-15 00:00:00','Paid','2026-11-15 06:25:04','2026-11-15 06:25:04',50.00,0.00,'Daily Gym Pass','admin',0,NULL,''),(65,'PAY-202611159473339',NULL,'Joshua',50.00,'Cash','2026-11-15 00:00:00','Paid','2026-11-15 06:28:29','2026-11-15 06:28:29',50.00,0.00,'Daily Gym Pass','staff',0,NULL,''),(133,'PAY-202611158091506','GM2611159689531','Cusehse S. Cariaso',1200.00,'Cash','2026-11-15 15:01:28','Paid','2026-11-15 07:01:28','2026-11-15 07:01:28',2000.00,800.00,'Membership Renewal','admin',0,NULL,''),(140,'PAY-202611153489429','GM2611159689531','Cusehse S. Cariaso',600.00,'Cash','2026-11-15 15:01:48','Paid','2026-11-15 07:01:48','2026-11-15 07:01:48',600.00,0.00,'Membership Renewal','admin',0,NULL,''),(148,'PAY-202611156646196','GM2611155562373','Mark M. Maglasang',600.00,'Cash','2026-11-15 15:04:38','Paid','2026-11-15 07:04:38','2026-11-15 07:04:38',600.00,0.00,'Membership Payment','admin',0,NULL,''),(157,'PAY-202611158002909','GM2611159689531','Cusehse S. Cariaso',600.00,'Cash','2026-11-15 15:07:13','Paid','2026-11-15 07:07:13','2026-11-15 07:07:13',600.00,0.00,'Membership Renewal','admin',0,NULL,''),(167,'PAY-202611157970654','GM2611157656825','Joshua Manila',600.00,'Cash','2026-11-15 15:08:24','Paid','2026-11-15 07:08:24','2026-11-15 07:08:24',600.00,0.00,'Membership Payment','admin',0,NULL,''),(178,'PAY-202611153269932','GM2611159480970','Zedrick Calzada',600.00,'Cash','2026-11-15 15:13:59','Paid','2026-11-15 07:13:59','2026-11-15 07:13:59',600.00,0.00,'Membership Payment','admin',0,NULL,''),(190,'PAY-202611155011888','GM2611159689531','Cusehse S. Cariaso',600.00,'Cash','2026-11-15 15:18:23','Paid','2026-11-15 07:18:23','2026-11-15 07:18:23',600.00,0.00,'Membership Renewal','admin',0,NULL,''),(203,'PAY-202611158409711','GM2611159689531','Cusehse S. Cariaso',600.00,'Cash','2026-11-15 15:19:57','Paid','2026-11-15 07:19:57','2026-11-15 07:19:57',600.00,0.00,'Membership Renewal','admin',0,NULL,''),(217,'PAY-202611156013599','GM2611153032815','Mary Grace',600.00,'Cash','2026-11-15 15:20:58','Paid','2026-11-15 07:20:58','2026-11-15 07:20:58',600.00,0.00,'Membership Payment','admin',0,NULL,''),(309,'PAY-202611151343587','GM2611154042871','Regine Velasquez',600.00,'Cash','2026-11-15 15:51:03','Paid','2026-11-15 07:51:03','2026-11-15 07:51:03',600.00,0.00,'Membership Payment','admin',0,NULL,''),(352,'PAY-202611158302082',NULL,'Mae',100.00,'Cash','2026-11-15 00:00:00','Paid','2026-11-15 08:10:32','2026-11-15 08:10:32',100.00,0.00,'Daily Gym Pass','admin',0,NULL,''),(368,'PAY-202611153781922',NULL,'JAMES',50.00,'Cash','2026-11-15 00:00:00','Paid','2026-11-15 08:11:09','2026-11-15 08:11:09',50.00,0.00,'Daily Gym Pass','admin',0,NULL,''),(385,'PAY-202611155052568',NULL,'mARK',100.00,'Cash','2026-11-15 00:00:00','Paid','2026-11-15 08:11:35','2026-11-15 08:11:35',100.00,0.00,'Daily Gym Pass','admin',0,NULL,''),(403,'PAY-202611155018904',NULL,'Babe',100.00,'Cash','2026-11-15 00:00:00','Paid','2026-11-15 08:14:53','2026-11-15 08:14:53',100.00,0.00,'Daily Gym Pass','admin',0,NULL,''),(422,'PAY-202611156699447',NULL,'Mom',50.00,'Cash','2026-11-15 00:00:00','Paid','2026-11-15 08:15:12','2026-11-15 08:15:12',50.00,0.00,'Daily Gym Pass','admin',0,NULL,''),(480,'PAY-202611165812558',NULL,'Joshua',50.00,'Cash','2026-11-16 00:00:00','Paid','2026-11-16 08:29:23','2026-11-16 08:29:23',50.00,0.00,'Daily Gym Pass','admin',0,NULL,''),(501,'PAY-202611176676652','GM2611171675773','Adraine Tallon',1200.00,'Cash','2026-11-17 18:59:02','Paid','2026-11-17 10:59:02','2026-11-17 10:59:02',1200.00,0.00,'Membership Payment','admin',0,NULL,''),(565,'PAY-202611174914205',NULL,'Wecks',50.00,'Cash','2026-11-17 00:00:00','Paid','2026-11-17 11:02:22','2026-11-17 11:02:22',50.00,0.00,'Daily Gym Pass','admin',0,NULL,''),(830,'PAY-202611173923564',NULL,'Adraine',50.00,'Cash','2026-11-17 00:00:00','Paid','2026-11-17 11:03:34','2026-11-17 11:03:34',50.00,0.00,'Daily Gym Pass','admin',0,NULL,''),(854,'PAY-202611175174897','GM2611179554136','Mam Daisy',600.00,'Cash','2026-11-17 21:16:52','Paid','2026-11-17 13:16:52','2026-11-17 13:16:52',600.00,0.00,'Membership Payment','admin',0,NULL,''),(879,'PAY-202611173747768',NULL,'Adrainee',50.00,'Cash','2026-11-17 00:00:00','Paid','2026-11-17 14:07:49','2026-11-17 14:07:49',50.00,0.00,'Daily Gym Pass','admin2@universalgym.ph',0,NULL,''),(905,'PAY-202611179787517','GM2611176037016','Jasie 09 Machicas',600.00,'Cash','2026-11-17 22:26:08','Paid','2026-11-17 14:26:08','2026-11-17 14:26:08',9000.00,8400.00,'Membership Payment','step',0,NULL,''),(932,'PAY-202611173813613','GM2611176578703','nellah paras',600.00,'Cash','2026-11-17 22:33:01','Paid','2026-11-17 14:33:01','2026-11-17 14:33:01',600.00,0.00,'Membership Payment','cariaso',0,NULL,''),(960,'PAY-202611176921982','GM2611153032815','Mary Grace',600.00,'Cash','2026-11-17 22:41:23','Paid','2026-11-17 14:41:23','2026-11-17 14:41:23',600.00,0.00,'Membership Renewal','cariaso',0,NULL,''),(1017,'PAY-202611187847138',NULL,'Adraine',50.00,'Cash','2026-11-18 00:00:00','Paid','2026-11-18 03:59:22','2026-11-18 03:59:22',50.00,0.00,'Daily Gym Pass','cariaso',0,NULL,''),(1047,'PAY-202611182795938',NULL,'Adraineee',50.00,'Cash','2026-11-17 00:00:00','Paid','2026-11-18 03:59:36','2026-11-18 03:59:36',50.00,0.00,'Daily Gym Pass','cariaso',0,NULL,''),(1078,'PAY-202611187248808',NULL,'Adrainei',50.00,'Cash','2026-11-18 00:00:00','Paid','2026-11-18 03:59:50','2026-11-18 03:59:50',50.00,0.00,'Daily Gym Pass','cariaso',0,NULL,''),(1110,'PAY-202611182043172','GM2611185105843','Stephen S Samoson',10000.00,'Cash','2026-11-18 12:26:42','Paid','2026-11-18 04:26:42','2026-11-18 04:26:42',10000.00,0.00,'Membership Payment','cariaso',0,NULL,''),(1143,'PAY-202611188164404',NULL,'Adrainej',50.00,'Cash','2026-11-18 00:00:00','Paid','2026-11-18 04:27:37','2026-11-18 04:27:37',50.00,0.00,'Daily Gym Pass','cariaso',0,NULL,'');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_activity`
--

DROP TABLE IF EXISTS `staff_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `staff_activity` (
  `id` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `staff_name` varchar(300) NOT NULL DEFAULT '',
  `account_type` varchar(30) NOT NULL DEFAULT 'Staff',
  `action` varchar(100) NOT NULL,
  `details` text NOT NULL,
  `member_id` varchar(50) DEFAULT NULL,
  `occurred_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_activity_user_date` (`username`,`occurred_at`),
  KEY `idx_activity_member` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_activity`
--

LOCK TABLES `staff_activity` WRITE;
/*!40000 ALTER TABLE `staff_activity` DISABLE KEYS */;
INSERT INTO `staff_activity` VALUES ('ACT-20261115141504668665','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 14:15:04'),('ACT-20261115141521181932','admin','System Administrator','Owner','Member archived','Archived member Isabella Rose Mendoza.','MEM010','2026-11-15 14:15:21'),('ACT-20261115141821738533','admin','System Administrator','Owner','Member registration','Registered Andrei R. Machica; payment PAY-202611152439893.','GM2611159712025','2026-11-15 14:18:21'),('ACT-20261115141922768991','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 14:19:22'),('ACT-20261115142147170492','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 14:21:47'),('ACT-20261115142453121252','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 14:24:53'),('ACT-20261115142740820217','admin','System Administrator','Owner','Logout','Staff signed out.',NULL,'2026-11-15 14:27:40'),('ACT-20261115142814549650','staff','Llyod M. Ruga','Staff','Login','Staff account signed in.',NULL,'2026-11-15 14:28:14'),('ACT-20261115142902606369','staff','Llyod M. Ruga','Staff','Logout','Staff signed out.',NULL,'2026-11-15 14:29:02'),('ACT-20261115142912865170','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 14:29:12'),('ACT-20261115143313532833','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-15 14:33:13'),('ACT-20261115143324632482','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 14:33:24'),('ACT-20261115143340695794','admin','System Administrator','Owner','Logout','Staff signed out.',NULL,'2026-11-15 14:33:40'),('ACT-20261115143351137321','staff','Llyod M. Ruga','Staff','Login','Staff account signed in.',NULL,'2026-11-15 14:33:51'),('ACT-20261115143523458866','staff','Llyod M. Ruga','Staff','Member registration','Registered Cusehse S. Cariaso; payment PAY-202611155875552.','GM2611159689531','2026-11-15 14:35:23'),('ACT-20261115143541689645','staff','Llyod M. Ruga','Staff','Logout','Staff signed out.',NULL,'2026-11-15 14:35:41'),('ACT-20261115143549253372','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 14:35:49'),('ACT-20261115144032956669','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-15 14:40:32'),('ACT-20261115144042329441','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 14:40:42'),('ACT-20261115144347468116','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-15 14:43:47'),('ACT-20261115144359472974','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 14:43:59'),('ACT-20261115144722641528','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-15 14:47:22'),('ACT-20261115144749972577','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 14:47:49'),('ACT-20261115144828799410','admin','System Administrator','Owner','Logout','Staff signed out.',NULL,'2026-11-15 14:48:28'),('ACT-20261115144842402602','staff','Llyod M. Ruga','Staff','Login','Staff account signed in.',NULL,'2026-11-15 14:48:42'),('ACT-20261115144910983798','staff','Llyod M. Ruga','Staff','Logout','Staff signed out.',NULL,'2026-11-15 14:49:10'),('ACT-20261115144916056825','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 14:49:16'),('ACT-20261115144933061137','admin','System Administrator','Owner','Logout','Staff signed out.',NULL,'2026-11-15 14:49:33'),('ACT-20261115144939066409','staff','Llyod M. Ruga','Staff','Login','Staff account signed in.',NULL,'2026-11-15 14:49:39'),('ACT-20261115144956888202','staff','Llyod M. Ruga','Staff','Logout','Staff signed out.',NULL,'2026-11-15 14:49:56'),('ACT-20261115145003802969','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 14:50:03'),('ACT-20261115145134977408','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-15 14:51:34'),('ACT-20261115145143120215','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 14:51:43'),('ACT-20261115145225598684','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-15 14:52:25'),('ACT-20261115145350951657','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 14:53:50'),('ACT-20261115150047457198','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 15:00:47'),('ACT-20261115150128775749','admin','System Administrator','Owner','Membership renewal','Renewed Cusehse S. Cariaso to 2M Plan; payment PAY-202611158091506.','GM2611159689531','2026-11-15 15:01:28'),('ACT-20261115150148320599','admin','System Administrator','Owner','Membership renewal','Renewed Cusehse S. Cariaso to Monthly; payment PAY-202611153489429.','GM2611159689531','2026-11-15 15:01:48'),('ACT-20261115150151636461','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-15 15:01:51'),('ACT-20261115150203118734','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 15:02:03'),('ACT-20261115150438746790','admin','System Administrator','Owner','Member registration','Registered Mark M. Maglasang; payment PAY-202611156646196.','GM2611155562373','2026-11-15 15:04:38'),('ACT-20261115150713057321','admin','System Administrator','Owner','Membership renewal','Renewed Cusehse S. Cariaso to Monthly; payment PAY-202611158002909.','GM2611159689531','2026-11-15 15:07:13'),('ACT-20261115150719493122','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-15 15:07:19'),('ACT-20261115150730383988','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 15:07:30'),('ACT-20261115150824949589','admin','System Administrator','Owner','Member registration','Registered Joshua Manila; payment PAY-202611157970654.','GM2611157656825','2026-11-15 15:08:24'),('ACT-20261115151220091609','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 15:12:20'),('ACT-20261115151244549272','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-15 15:12:44'),('ACT-20261115151251221528','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 15:12:51'),('ACT-20261115151253126239','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-15 15:12:53'),('ACT-20261115151320482879','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 15:13:20'),('ACT-20261115151359981389','admin','System Administrator','Owner','Member registration','Registered Zedrick Calzada; payment PAY-202611153269932.','GM2611159480970','2026-11-15 15:13:59'),('ACT-20261115151413440600','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-15 15:14:13'),('ACT-20261115151427812871','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 15:14:27'),('ACT-20261115151430005417','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-15 15:14:30'),('ACT-20261115151618450156','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 15:16:18'),('ACT-20261115151736402545','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-15 15:17:36'),('ACT-20261115151815090662','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 15:18:15'),('ACT-20261115151823476434','admin','System Administrator','Owner','Membership renewal','Renewed Cusehse S. Cariaso to Monthly; payment PAY-202611155011888.','GM2611159689531','2026-11-15 15:18:23'),('ACT-20261115151904545980','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-15 15:19:04'),('ACT-20261115151952374286','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 15:19:52'),('ACT-20261115151957204967','admin','System Administrator','Owner','Membership renewal','Renewed Cusehse S. Cariaso to Monthly; payment PAY-202611158409711.','GM2611159689531','2026-11-15 15:19:57'),('ACT-20261115152058571324','admin','System Administrator','Owner','Member registration','Registered Mary Grace; payment PAY-202611156013599.','GM2611153032815','2026-11-15 15:20:58'),('ACT-20261115152315728629','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-15 15:23:15'),('ACT-20261115152337311295','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 15:23:37'),('ACT-20261115152608228279','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 15:26:08'),('ACT-20261115152914097277','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-15 15:29:14'),('ACT-20261115153550596710','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 15:35:50'),('ACT-20261115153612820746','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-15 15:36:12'),('ACT-20261115153620868505','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 15:36:20'),('ACT-20261115153812608322','admin','System Administrator','Owner','Member archived','Archived member Mary Grace.','GM2611153032815','2026-11-15 15:38:12'),('ACT-20261115153908319622','admin','System Administrator','Owner','Member archived','Archived member Mary Grace.','GM2611153032815','2026-11-15 15:39:08'),('ACT-20261115154209051359','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-15 15:42:09'),('ACT-20261115154324709285','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 15:43:24'),('ACT-20261115154335375368','admin','System Administrator','Owner','Member archived','Archived member Mary Grace.','GM2611153032815','2026-11-15 15:43:35'),('ACT-20261115155001623646','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-15 15:50:01'),('ACT-20261115155009963142','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 15:50:09'),('ACT-20261115155103163996','admin','System Administrator','Owner','Member registration','Registered Regine Velasquez; payment PAY-202611151343587.','GM2611154042871','2026-11-15 15:51:03'),('ACT-20261115155714973819','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-15 15:57:14'),('ACT-20261115155948618249','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 15:59:48'),('ACT-20261115160141458314','admin','System Administrator','Owner','Logout','Staff signed out.',NULL,'2026-11-15 16:01:41'),('ACT-20261115160146544729','staff','Llyod M. Ruga','Staff','Login','Staff account signed in.',NULL,'2026-11-15 16:01:46'),('ACT-20261115160158797338','staff','Llyod M. Ruga','Staff','Logout','Staff signed out.',NULL,'2026-11-15 16:01:58'),('ACT-20261115160209614719','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 16:02:09'),('ACT-20261115160407770714','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-15 16:04:07'),('ACT-20261115160502656193','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 16:05:02'),('ACT-20261115160554727321','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-15 16:05:54'),('ACT-20261115160603019969','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 16:06:03'),('ACT-20261115160818313229','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-15 16:08:18'),('ACT-20261115161000898932','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 16:10:00'),('ACT-20261115161442470735','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 16:14:42'),('ACT-20261115161615213531','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-15 16:16:15'),('ACT-20261115161817223754','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-15 16:18:17'),('ACT-20261115162011102155','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-15 16:20:11'),('ACT-20261116162747469414','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-16 16:27:47'),('ACT-20261116163123221381','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-16 16:31:23'),('ACT-20261116163207373544','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-16 16:32:07'),('ACT-20261116163237569465','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-16 16:32:37'),('ACT-20261117185741116538','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-17 18:57:41'),('ACT-20261117185902864217','admin','System Administrator','Owner','Member registration','Registered Adraine Tallon; payment PAY-202611176676652.','GM2611171675773','2026-11-17 18:59:02'),('ACT-20261117204830983163','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-17 20:48:30'),('ACT-20261117205832372309','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-17 20:58:32'),('ACT-20261117210239139104','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-17 21:02:39'),('ACT-20261117210613611892','admin','System Administrator','Owner','Expense added','Machine: ₱500.00 (Maintenance and Repairs)',NULL,'2026-11-17 21:06:13'),('ACT-20261117210932186309','admin','System Administrator','Owner','Expense voided','Voided expense EXP-20261117210613570566.',NULL,'2026-11-17 21:09:32'),('ACT-20261117211119014602','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-17 21:11:19'),('ACT-20261117211240491160','admin','System Administrator','Owner','Expense added','KURYENTE PO: ₱900.00 (Electricity Bill)',NULL,'2026-11-17 21:12:40'),('ACT-20261117211417938493','admin','System Administrator','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-17 21:14:17'),('ACT-20261117211426156875','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-17 21:14:26'),('ACT-20261117211652195767','admin','System Administrator','Owner','Member registration','Registered Mam Daisy; payment PAY-202611175174897.','GM2611179554136','2026-11-17 21:16:52'),('ACT-20261117212408108457','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-17 21:24:08'),('ACT-20261117212504714312','admin','System Administrator','Owner','Logout','Staff signed out.',NULL,'2026-11-17 21:25:04'),('ACT-20261117212508817948','staff','Llyod M. Ruga','Staff','Login','Staff account signed in.',NULL,'2026-11-17 21:25:08'),('ACT-20261117212519259569','staff','Llyod M. Ruga','Staff','Logout','Staff signed out.',NULL,'2026-11-17 21:25:19'),('ACT-20261117212524023967','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-17 21:25:24'),('ACT-20261117212647943339','admin','System Administrator','Owner','Logout','Staff signed out.',NULL,'2026-11-17 21:26:47'),('ACT-20261117212653791912','staff','Llyod M. Ruga','Admin','Login','Admin account signed in.',NULL,'2026-11-17 21:26:53'),('ACT-20261117212715641845','staff','Llyod M. Ruga','Admin','Logout','Staff signed out.',NULL,'2026-11-17 21:27:15'),('ACT-20261117212721224880','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-17 21:27:21'),('ACT-20261117212735105989','admin','System Administrator','Owner','Logout','Staff signed out.',NULL,'2026-11-17 21:27:35'),('ACT-20261117212741096783','staff','Llyod M. Ruga','Admin','Login','Admin account signed in.',NULL,'2026-11-17 21:27:41'),('ACT-20261117212745049142','staff','Llyod M. Ruga','Admin','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-17 21:27:45'),('ACT-20261117212818538318','admin','System Administrator','Owner','Login','Owner account signed in.',NULL,'2026-11-17 21:28:18'),('ACT-20261117213232433769','admin','System Administrator','Admin','Logout','Staff signed out.',NULL,'2026-11-17 21:32:32'),('ACT-20261117213244300326','stephen','Stephen Samoson','Admin','Login','Admin account signed in.',NULL,'2026-11-17 21:32:44'),('ACT-20261117213317666176','stephen','Stephen Samoson','Admin','Logout','Staff signed out.',NULL,'2026-11-17 21:33:17'),('ACT-20261117213322190826','staff','Llyod M. Ruga','Admin','Login','Admin account signed in.',NULL,'2026-11-17 21:33:22'),('ACT-20261117213336125128','staff','Llyod M. Ruga','Admin','Logout','Staff signed out.',NULL,'2026-11-17 21:33:36'),('ACT-20261117213350639668','admin','System Administrator','Admin','Login','Admin account signed in.',NULL,'2026-11-17 21:33:50'),('ACT-20261117213408144720','admin','System Administrator','Admin','Logout','Staff signed out.',NULL,'2026-11-17 21:34:08'),('ACT-20261117213412212201','staff','Llyod M. Ruga','Admin','Login','Admin account signed in.',NULL,'2026-11-17 21:34:12'),('ACT-20261117213424486457','staff','Llyod M. Ruga','Staff','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-17 21:34:24'),('ACT-20261117213433978258','staff','Llyod M. Ruga','Staff','Login','Staff account signed in.',NULL,'2026-11-17 21:34:33'),('ACT-20261117213441698535','staff','Llyod M. Ruga','Staff','Logout','Staff signed out.',NULL,'2026-11-17 21:34:41'),('ACT-20261117213448989570','stephen','Stephen Samoson','Admin','Login','Admin account signed in.',NULL,'2026-11-17 21:34:48'),('ACT-20261117213558669794','stephen','Stephen Samoson','Admin','Logout','Staff signed out.',NULL,'2026-11-17 21:35:58'),('ACT-20261117213608611321','llyod','Lloyd Ruga','Staff','Login','Staff account signed in.',NULL,'2026-11-17 21:36:08'),('ACT-20261117213654848696','llyod','Lloyd Ruga','Staff','Logout','Staff signed out.',NULL,'2026-11-17 21:36:54'),('ACT-20261117213727093796','admin','System Administrator','Admin','Login','Admin account signed in.',NULL,'2026-11-17 21:37:27'),('ACT-20261117213748272362','admin','System Administrator','Admin','Logout','Staff signed out.',NULL,'2026-11-17 21:37:48'),('ACT-20261117213811222976','stephen','Stephen Samoson','Admin','Login','Admin account signed in.',NULL,'2026-11-17 21:38:11'),('ACT-20261117213823400913','stephen','Stephen Samoson','Admin','Logout','Staff signed out.',NULL,'2026-11-17 21:38:23'),('ACT-20261117213829258127','stephen','Stephen Samoson','Admin','Login','Admin account signed in.',NULL,'2026-11-17 21:38:29'),('ACT-20261117213848509478','stephen','Stephen Samoson','Admin','Logout','Staff signed out.',NULL,'2026-11-17 21:38:48'),('ACT-20261117213854499213','llyod','Lloyd Ruga','Staff','Login','Staff account signed in.',NULL,'2026-11-17 21:38:54'),('ACT-20261117213931072113','llyod','Lloyd Ruga','Staff','Logout','Staff signed out.',NULL,'2026-11-17 21:39:31'),('ACT-20261117213938273845','stephen','Stephen Samoson','Admin','Login','Admin account signed in.',NULL,'2026-11-17 21:39:38'),('ACT-20261117214010791318','stephen','Stephen Samoson','Admin','Logout','Staff signed out.',NULL,'2026-11-17 21:40:10'),('ACT-20261117214016196979','llyod','Lloyd Ruga','Admin','Login','Admin account signed in.',NULL,'2026-11-17 21:40:16'),('ACT-20261117214020300614','llyod','Lloyd Ruga','Admin','Logout','Staff signed out.',NULL,'2026-11-17 21:40:20'),('ACT-20261117214026182106','stephen','Stephen Samoson','Admin','Login','Admin account signed in.',NULL,'2026-11-17 21:40:26'),('ACT-20261117214039195627','stephen','Stephen Samoson','Admin','Logout','Staff signed out.',NULL,'2026-11-17 21:40:39'),('ACT-20261117214043302337','llyod','Lloyd Ruga','Admin','Login','Admin account signed in.',NULL,'2026-11-17 21:40:43'),('ACT-20261117214501862482','llyod','Lloyd Ruga','Admin','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-17 21:45:01'),('ACT-20261117214523120799','admin','System Administrator','Staff','Login','Staff account signed in.',NULL,'2026-11-17 21:45:23'),('ACT-20261117214525985737','admin','System Administrator','Staff','Logout','Staff signed out.',NULL,'2026-11-17 21:45:25'),('ACT-20261117214532019314','stephen','Stephen Samoson','Staff','Login','Staff account signed in.',NULL,'2026-11-17 21:45:32'),('ACT-20261117214841619748','stephen','Stephen Samoson','Staff','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-17 21:48:41'),('ACT-20261117214927845908','admin2@universalgym.ph','admin2@universalgym.ph','Owner','Login','Owner account signed in.',NULL,'2026-11-17 21:49:27'),('ACT-20261117215054390476','admin2@universalgym.ph','admin2@universalgym.ph','Owner','Logout','Staff signed out.',NULL,'2026-11-17 21:50:54'),('ACT-20261117215059626651','stephen','Stephen Samoson','Staff','Login','Staff account signed in.',NULL,'2026-11-17 21:50:59'),('ACT-20261117215102565557','stephen','Stephen Samoson','Staff','Logout','Staff signed out.',NULL,'2026-11-17 21:51:02'),('ACT-20261117215106811560','admin2@universalgym.ph','admin2@universalgym.ph','Owner','Login','Owner account signed in.',NULL,'2026-11-17 21:51:06'),('ACT-20261117215123435344','admin2@universalgym.ph','admin2@universalgym.ph','Owner','Logout','Staff signed out.',NULL,'2026-11-17 21:51:23'),('ACT-20261117215127320611','llyod','Lloyd Ruga','Staff','Login','Staff account signed in.',NULL,'2026-11-17 21:51:27'),('ACT-20261117215142654209','llyod','Lloyd Ruga','Staff','Logout','Staff signed out.',NULL,'2026-11-17 21:51:42'),('ACT-20261117215149575890','admin2@universalgym.ph','admin2@universalgym.ph','Owner','Login','Owner account signed in.',NULL,'2026-11-17 21:51:49'),('ACT-20261117215504156414','admin2@universalgym.ph','admin2@universalgym.ph','Owner','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-17 21:55:04'),('ACT-20261117215512882228','admin2@universalgym.ph','admin2@universalgym.ph','Owner','Login','Owner account signed in.',NULL,'2026-11-17 21:55:12'),('ACT-20261117215617107902','admin2@universalgym.ph','admin2@universalgym.ph','Owner','Logout','Staff signed out.',NULL,'2026-11-17 21:56:17'),('ACT-20261117215626865890','llyod','Lloyd Ruga','Staff','Login','Staff account signed in.',NULL,'2026-11-17 21:56:26'),('ACT-20261117215850797593','llyod','Lloyd Ruga','Staff','Logout','Staff signed out.',NULL,'2026-11-17 21:58:50'),('ACT-20261117215902233994','admin2@universalgym.ph','admin2@universalgym.ph','Owner','Login','Owner account signed in.',NULL,'2026-11-17 21:59:02'),('ACT-20261117220711134598','admin2@universalgym.ph','admin2@universalgym.ph','Owner','Login','Owner account signed in.',NULL,'2026-11-17 22:07:11'),('ACT-20261117220800175226','admin2@universalgym.ph','admin2@universalgym.ph','Owner','Logout','Staff signed out.',NULL,'2026-11-17 22:08:00'),('ACT-20261117220804317613','llyod','Lloyd Ruga','Staff','Login','Staff account signed in.',NULL,'2026-11-17 22:08:04'),('ACT-20261117220823773761','llyod','Lloyd Ruga','Staff','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-17 22:08:23'),('ACT-20261117220848447849','admin2@universalgym.ph','admin2@universalgym.ph','Owner','Login','Owner account signed in.',NULL,'2026-11-17 22:08:48'),('ACT-20261117220920781514','admin2@universalgym.ph','admin2@universalgym.ph','Owner','Logout','Staff signed out.',NULL,'2026-11-17 22:09:20'),('ACT-20261117220931686925','Andrei','Andrei Machica','Staff','Login','Staff account signed in.',NULL,'2026-11-17 22:09:31'),('ACT-20261117221023569162','Andrei','Andrei Machica','Staff','Logout','Staff signed out.',NULL,'2026-11-17 22:10:23'),('ACT-20261117221046017651','stephen','Stephen Samoson','Staff','Login','Staff account signed in.',NULL,'2026-11-17 22:10:46'),('ACT-20261117221048780403','stephen','Stephen Samoson','Staff','Logout','Staff signed out.',NULL,'2026-11-17 22:10:48'),('ACT-20261117221055387705','llyod','Lloyd Ruga','Admin','Login','Staff account signed in.',NULL,'2026-11-17 22:10:55'),('ACT-20261117221059379519','llyod','Lloyd Ruga','Admin','Logout','Staff signed out.',NULL,'2026-11-17 22:10:59'),('ACT-20261117221103813409','Andrei','Andrei Machica','Staff','Login','Staff account signed in.',NULL,'2026-11-17 22:11:03'),('ACT-20261117221535227704','Andrei','Andrei Machica','Staff','Login','Staff account signed in.',NULL,'2026-11-17 22:15:35'),('ACT-20261117221605108125','Andrei','Andrei Machica','Staff','Logout','Staff signed out.',NULL,'2026-11-17 22:16:05'),('ACT-20261117221611316171','llyod','Lloyd Ruga','Admin','Login','Admin account signed in.',NULL,'2026-11-17 22:16:11'),('ACT-20261117221651013848','llyod','Lloyd Ruga','Admin','Logout','Staff signed out.',NULL,'2026-11-17 22:16:51'),('ACT-20261117221701708883','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-17 22:17:01'),('ACT-20261117221811895390','cariaso','Cueshe Cariaso','Admin','Logout','Staff signed out.',NULL,'2026-11-17 22:18:11'),('ACT-20261117221815936243','Andrei','Andrei Machica','Admin','Login','Admin account signed in.',NULL,'2026-11-17 22:18:15'),('ACT-20261117221823403744','Andrei','Andrei Machica','Admin','Logout','Staff signed out.',NULL,'2026-11-17 22:18:23'),('ACT-20261117221827168905','stephen','Stephen Samoson','Staff','Login','Staff account signed in.',NULL,'2026-11-17 22:18:27'),('ACT-20261117221835249622','stephen','Stephen Samoson','Staff','Logout','Staff signed out.',NULL,'2026-11-17 22:18:35'),('ACT-20261117221858331916','admin2@universalgym.ph','admin2@universalgym.ph','Owner','Login','Owner account signed in.',NULL,'2026-11-17 22:18:58'),('ACT-20261117221929321497','admin2@universalgym.ph','admin2@universalgym.ph','Owner','Logout','Staff signed out.',NULL,'2026-11-17 22:19:29'),('ACT-20261117221934003423','Andrei','Andrei Machica','Front Desk Staff','Login','Front Desk Staff account signed in.',NULL,'2026-11-17 22:19:34'),('ACT-20261117221947562703','Andrei','Andrei Machica','Front Desk Staff','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-17 22:19:47'),('ACT-20261117221959996768','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-17 22:20:00'),('ACT-20261117222145467309','cariaso','Cueshe Cariaso','Admin','Logout','Staff signed out.',NULL,'2026-11-17 22:21:45'),('ACT-20261117222151884913','stephen','Stephen Samoson','Front Desk Staff','Login','Front Desk Staff account signed in.',NULL,'2026-11-17 22:21:51'),('ACT-20261117222153675936','stephen','Stephen Samoson','Front Desk Staff','Logout','Staff signed out.',NULL,'2026-11-17 22:21:53'),('ACT-20261117222200170684','Andrei','Andrei Machica','Front Desk Staff','Login','Front Desk Staff account signed in.',NULL,'2026-11-17 22:22:00'),('ACT-20261117222227241102','Andrei','Andrei Machica','Front Desk Staff','Logout','Staff signed out.',NULL,'2026-11-17 22:22:27'),('ACT-20261117222235801820','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-17 22:22:35'),('ACT-20261117222304522959','cariaso','Cueshe Cariaso','Admin','Logout','Staff signed out.',NULL,'2026-11-17 22:23:04'),('ACT-20261117222309067733','Andrei','Andrei Machica','Front Desk Staff','Login','Front Desk Staff account signed in.',NULL,'2026-11-17 22:23:09'),('ACT-20261117222323141971','Andrei','Andrei Machica','Front Desk Staff','Logout','Staff signed out.',NULL,'2026-11-17 22:23:23'),('ACT-20261117222331631671','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-17 22:23:31'),('ACT-20261117222446379636','cariaso','Cueshe Cariaso','Admin','Logout','Staff signed out.',NULL,'2026-11-17 22:24:46'),('ACT-20261117222502443680','step','Stephen Sex Samson','Front Desk Staff','Login','Front Desk Staff account signed in.',NULL,'2026-11-17 22:25:02'),('ACT-20261117222608839306','step','Stephen Sex Samson','Front Desk Staff','Member registration','Registered Jasie 09 Machicas; payment PAY-202611179787517.','GM2611176037016','2026-11-17 22:26:08'),('ACT-20261117222618199661','step','Stephen Sex Samson','Front Desk Staff','Logout','Staff signed out.',NULL,'2026-11-17 22:26:18'),('ACT-20261117222624846668','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-17 22:26:24'),('ACT-20261117223101072266','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-17 22:31:01'),('ACT-20261117223147789269','cariaso','Cueshe Cariaso','Admin','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-17 22:31:47'),('ACT-20261117223214111550','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-17 22:32:14'),('ACT-20261117223301734289','cariaso','Cueshe Cariaso','Admin','Member registration','Registered nellah paras; payment PAY-202611173813613.','GM2611176578703','2026-11-17 22:33:01'),('ACT-20261117223310312959','cariaso','Cueshe Cariaso','Admin','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-17 22:33:10'),('ACT-20261117223339482210','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-17 22:33:39'),('ACT-20261117223604697284','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-17 22:36:04'),('ACT-20261117223912873443','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-17 22:39:12'),('ACT-20261117224059560327','cariaso','Cueshe Cariaso','Admin','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-17 22:40:59'),('ACT-20261117224111486995','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-17 22:41:11'),('ACT-20261117224123494471','cariaso','Cueshe Cariaso','Admin','Membership renewal','Renewed Mary Grace to Monthly; payment PAY-202611176921982.','GM2611153032815','2026-11-17 22:41:23'),('ACT-20261117224740074896','cariaso','Cueshe Cariaso','Admin','Logout','Staff signed out.',NULL,'2026-11-17 22:47:40'),('ACT-20261117224817849162','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-17 22:48:17'),('ACT-20261117224819144102','cariaso','Cueshe Cariaso','Admin','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-17 22:48:19'),('ACT-20261117224914660711','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-17 22:49:14'),('ACT-20261117224953500797','cariaso','Cueshe Cariaso','Admin','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-17 22:49:53'),('ACT-20261117225006010221','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-17 22:50:06'),('ACT-20261117225451687452','cariaso','Cueshe Cariaso','Admin','Logout','Staff signed out.',NULL,'2026-11-17 22:54:51'),('ACT-20261117225456066348','Andrei','Andrei Machica','Front Desk Staff','Login','Front Desk Staff account signed in.',NULL,'2026-11-17 22:54:56'),('ACT-20261117225500842805','Andrei','Andrei Machica','Front Desk Staff','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-17 22:55:00'),('ACT-20261117225510049509','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-17 22:55:10'),('ACT-20261117225808856618','cariaso','Cueshe Cariaso','Admin','Logout','Staff signed out.',NULL,'2026-11-17 22:58:08'),('ACT-20261117225812807941','Andrei','Andrei Machica','Front Desk Staff','Login','Front Desk Staff account signed in.',NULL,'2026-11-17 22:58:12'),('ACT-20261117225816660521','Andrei','Andrei Machica','Front Desk Staff','Logout','Staff signed out.',NULL,'2026-11-17 22:58:16'),('ACT-20261117225821687852','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-17 22:58:21'),('ACT-20261117225833141864','cariaso','Cueshe Cariaso','Admin','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-17 22:58:33'),('ACT-20261117225926859860','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-17 22:59:26'),('ACT-20261117230007100627','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-17 23:00:07'),('ACT-20261117230210879504','cariaso','Cueshe Cariaso','Admin','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-17 23:02:10'),('ACT-20261117230224113114','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-17 23:02:24'),('ACT-20261117230740762565','cariaso','Cueshe Cariaso','Admin','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-17 23:07:40'),('ACT-20261117231159413397','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-17 23:11:59'),('ACT-20261117231816496715','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-17 23:18:16'),('ACT-20261117232000491433','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-17 23:20:00'),('ACT-20261117232023894697','cariaso','Cueshe Cariaso','Admin','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-17 23:20:23'),('ACT-20261118114633034564','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-18 11:46:33'),('ACT-20261118114858510695','cariaso','Cueshe Cariaso','Admin','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-18 11:48:58'),('ACT-20261118114906737296','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-18 11:49:06'),('ACT-20261118114947742461','cariaso','Cueshe Cariaso','Admin','Logout','Staff signed out.',NULL,'2026-11-18 11:49:47'),('ACT-20261118114956328711','llyod','Lloyd Ruga','Admin','Login','Admin account signed in.',NULL,'2026-11-18 11:49:56'),('ACT-20261118115058735242','llyod','Lloyd Ruga','Admin','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-18 11:50:58'),('ACT-20261118115132168161','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-18 11:51:32'),('ACT-20261118115510573610','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-18 11:55:10'),('ACT-20261118115530404381','cariaso','Cueshe Cariaso','Admin','Expense added','alcohol: ₱150.00 (Cleaning Supplies)',NULL,'2026-11-18 11:55:30'),('ACT-20261118115549913493','cariaso','Cueshe Cariaso','Admin','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-18 11:55:49'),('ACT-20261118115612712678','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-18 11:56:12'),('ACT-20261118120110215452','cariaso','Cueshe Cariaso','Admin','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-18 12:01:10'),('ACT-20261118120157783154','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-18 12:01:57'),('ACT-20261118120436417437','cariaso','Cueshe Cariaso','Admin','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-18 12:04:36'),('ACT-20261118120446565230','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-18 12:04:46'),('ACT-20261118120852008679','cariaso','Cueshe Cariaso','Admin','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-18 12:08:52'),('ACT-20261118120930292551','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-18 12:09:30'),('ACT-20261118121359932667','cariaso','Cueshe Cariaso','Admin','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-18 12:13:59'),('ACT-20261118121416476163','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-18 12:14:16'),('ACT-20261118121945471302','cariaso','Cueshe Cariaso','Admin','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-18 12:19:45'),('ACT-20261118121954263280','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-18 12:19:54'),('ACT-20261118122030509395','cariaso','Cueshe Cariaso','Admin','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-18 12:20:30'),('ACT-20261118122218438233','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-18 12:22:18'),('ACT-20261118122642380801','cariaso','Cueshe Cariaso','Admin','Member registration','Registered Stephen S Samoson; payment PAY-202611182043172.','GM2611185105843','2026-11-18 12:26:42'),('ACT-20261118132227559255','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-18 13:22:27'),('ACT-20261118132616163444','cariaso','Cueshe Cariaso','Admin','Session timeout / application closed','Session ended when the application closed.',NULL,'2026-11-18 13:26:16'),('ACT-20261118133135104836','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-18 13:31:35'),('ACT-20261118134011766237','cariaso','Cueshe Cariaso','Admin','Login','Admin account signed in.',NULL,'2026-11-18 13:40:11');
/*!40000 ALTER TABLE `staff_activity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_positions`
--

DROP TABLE IF EXISTS `staff_positions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `staff_positions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_positions`
--

LOCK TABLES `staff_positions` WRITE;
/*!40000 ALTER TABLE `staff_positions` DISABLE KEYS */;
INSERT INTO `staff_positions` VALUES (2,'Front Desk Staff','2026-11-15 06:03:33'),(3,'Admin','2026-11-15 06:03:33');
/*!40000 ALTER TABLE `staff_positions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(30) NOT NULL DEFAULT 'Staff',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `full_name` varchar(300) NOT NULL DEFAULT '',
  `email` varchar(150) NOT NULL DEFAULT '',
  `phone_number` varchar(30) NOT NULL DEFAULT '',
  `birthday` date DEFAULT NULL,
  `home_address` varchar(300) NOT NULL DEFAULT '',
  `joined_date` date DEFAULT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'Active',
  `permissions_json` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `idx_username` (`username`),
  KEY `idx_role` (`role`)
) ENGINE=InnoDB AUTO_INCREMENT=1008 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'owner','PBKDF2-SHA256$100000$913tt4RZLmp5s9D7eUihGQ==$I6AOJ9UOIA2KRdJ6eb80b9MGdG14O+XqAvXYWLIZVhU=','Owner','2026-10-16 09:35:59','2026-11-15 06:14:56','','admin','',NULL,'',NULL,'Active',NULL,1,0,NULL,''),(16,'admin','PBKDF2-SHA256$100000$Cq6bWZ3cXZnPCWDdpIa78w==$ApWP/rT7LMjMcbi/TMU9GhOw3PUmgfCHtHT4+I4yzsY=','Staff','2026-11-15 06:14:46','2026-11-17 13:50:37','System Administrator','','','2026-11-15','','2026-11-15','Inactive','{\"CanViewMembers\":true,\"CanAddMembers\":true,\"CanEditMembers\":true,\"CanDeleteMembers\":true,\"CanManagePayments\":true,\"CanManageDailyGym\":true,\"CanViewOverviewMemberships\":true,\"CanViewOverviewDailyGym\":true,\"CanViewOverviewPayments\":true,\"CanViewOverviewRevenue\":false,\"CanViewReports\":false,\"CanManageExpenses\":false,\"CanManageStaff\":false,\"CanViewDeletedRecords\":false}',0,1,'2026-11-17 21:50:37','admin2@universalgym.ph'),(270,'llyod','PBKDF2-SHA256$100000$A6hmNoxc7zLM4BZ1YvDcGA==$JzAZQDkDEQ48STQmYEKShma3BysavrYQn1Tg3xnGO/w=','Admin','2026-11-17 13:35:43','2026-11-17 14:15:56','Lloyd Ruga','llyod@universalgym.ph','09231312542','2026-11-17','asdjbnajsbdnjkasndjuad','2026-11-17','Active','{\"CanViewMembers\":true,\"CanAddMembers\":true,\"CanEditMembers\":true,\"CanDeleteMembers\":true,\"CanManagePayments\":true,\"CanManageDailyGym\":true,\"CanViewOverviewMemberships\":true,\"CanViewOverviewDailyGym\":true,\"CanViewOverviewPayments\":true,\"CanViewOverviewRevenue\":true,\"CanViewReports\":true,\"CanManageExpenses\":true,\"CanManageStaff\":true,\"CanViewDeletedRecords\":true}',1,0,NULL,''),(331,'admin2@universalgym.ph','PBKDF2-SHA256$100000$afgHTS+zQKKvE1mRxgPOoA==$4L30nLVYC4oZLbF4taWoxko3v0qXSkKSVwFtjUdNZws=','Owner','2026-11-17 13:49:07','2026-11-17 13:49:07','','','',NULL,'',NULL,'Active',NULL,1,0,NULL,''),(396,'Andrei','PBKDF2-SHA256$100000$tnpdH5u9S8Cm/QmMqaBevw==$vjV8I7JaB+Gi2jw/ta9PDUxYdh8n79JHWaTtU0Ymw38=','Front Desk Staff','2026-11-17 14:09:12','2026-11-17 14:58:31','Andrei Machica','Andrei@universalgym.ph','09123122523','2026-11-17','asdasdasdas','2026-11-17','Active','{\"CanViewMembers\":true,\"CanAddMembers\":true,\"CanEditMembers\":true,\"CanDeleteMembers\":true,\"CanManagePayments\":true,\"CanManageDailyGym\":true,\"CanViewOverviewMemberships\":false,\"CanViewOverviewDailyGym\":false,\"CanViewOverviewPayments\":false,\"CanViewOverviewRevenue\":false,\"CanViewReports\":true,\"CanManageExpenses\":false,\"CanManageStaff\":false,\"CanViewDeletedRecords\":false}',1,0,NULL,''),(452,'cariaso','PBKDF2-SHA256$100000$1n1evYHQi/NAt3dit4xcOQ==$lJkxjw16/CLk7N12zh73ZXPLrhTRQ/7ghlwG0YPKvNY=','Admin','2026-11-17 14:16:40','2026-11-17 14:17:14','Cueshe Cariaso','cariaso@universalgym.ph','01239129319','2026-11-17','asdasdasdasdas','2026-11-17','Active','{\"CanViewMembers\":true,\"CanAddMembers\":true,\"CanEditMembers\":true,\"CanDeleteMembers\":true,\"CanManagePayments\":true,\"CanManageDailyGym\":true,\"CanViewOverviewMemberships\":true,\"CanViewOverviewDailyGym\":true,\"CanViewOverviewPayments\":true,\"CanViewOverviewRevenue\":true,\"CanViewReports\":true,\"CanManageExpenses\":true,\"CanManageStaff\":true,\"CanViewDeletedRecords\":true}',1,0,NULL,''),(611,'step','PBKDF2-SHA256$100000$Pt1rRmZ+pBUsdER1hbY8xA==$CH3Aip682GlQmWEfEMwGrGcYY9mAUp5SBHjBhYg/Km8=','Front Desk Staff','2026-11-17 14:24:34','2026-11-17 14:24:34','Stephen Sex Samson','step@universalgym.ph','01923123123','2026-11-17','asdasdasdasdasdasd','2026-11-17','Active','{\"CanViewMembers\":true,\"CanAddMembers\":true,\"CanEditMembers\":false,\"CanDeleteMembers\":false,\"CanManagePayments\":true,\"CanManageDailyGym\":true,\"CanViewOverviewMemberships\":true,\"CanViewOverviewDailyGym\":true,\"CanViewOverviewPayments\":true,\"CanViewOverviewRevenue\":false,\"CanViewReports\":false,\"CanManageExpenses\":false,\"CanManageStaff\":false,\"CanViewDeletedRecords\":false}',1,0,NULL,'');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `vw_active_members`
--

DROP TABLE IF EXISTS `vw_active_members`;
/*!50001 DROP VIEW IF EXISTS `vw_active_members`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vw_active_members` AS SELECT
 1 AS `id`,
  1 AS `full_name`,
  1 AS `phone`,
  1 AS `email`,
  1 AS `plan`,
  1 AS `fee`,
  1 AS `start_date`,
  1 AS `expiry_date`,
  1 AS `status`,
  1 AS `days_remaining` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_expired_members`
--

DROP TABLE IF EXISTS `vw_expired_members`;
/*!50001 DROP VIEW IF EXISTS `vw_expired_members`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vw_expired_members` AS SELECT
 1 AS `id`,
  1 AS `full_name`,
  1 AS `phone`,
  1 AS `email`,
  1 AS `plan`,
  1 AS `fee`,
  1 AS `start_date`,
  1 AS `expiry_date`,
  1 AS `status`,
  1 AS `days_expired` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_outstanding_balances`
--

DROP TABLE IF EXISTS `vw_outstanding_balances`;
/*!50001 DROP VIEW IF EXISTS `vw_outstanding_balances`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vw_outstanding_balances` AS SELECT
 1 AS `id`,
  1 AS `full_name`,
  1 AS `phone`,
  1 AS `email`,
  1 AS `plan`,
  1 AS `fee`,
  1 AS `start_date`,
  1 AS `expiry_date`,
  1 AS `status`,
  1 AS `total_paid`,
  1 AS `balance_due` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_payment_summary`
--

DROP TABLE IF EXISTS `vw_payment_summary`;
/*!50001 DROP VIEW IF EXISTS `vw_payment_summary`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vw_payment_summary` AS SELECT
 1 AS `payment_date`,
  1 AS `transaction_count`,
  1 AS `total_amount`,
  1 AS `payment_methods` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_revenue_by_plan`
--

DROP TABLE IF EXISTS `vw_revenue_by_plan`;
/*!50001 DROP VIEW IF EXISTS `vw_revenue_by_plan`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vw_revenue_by_plan` AS SELECT
 1 AS `plan`,
  1 AS `member_count`,
  1 AS `total_revenue`,
  1 AS `avg_fee` */;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'gym_registration_db'
--

--
-- Final view structure for view `vw_active_members`
--

/*!50001 DROP VIEW IF EXISTS `vw_active_members`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_active_members` AS select `members`.`id` AS `id`,`members`.`full_name` AS `full_name`,`members`.`phone` AS `phone`,`members`.`email` AS `email`,`members`.`plan` AS `plan`,`members`.`fee` AS `fee`,`members`.`start_date` AS `start_date`,`members`.`expiry_date` AS `expiry_date`,`members`.`status` AS `status`,to_days(`members`.`expiry_date`) - to_days(curdate()) AS `days_remaining` from `members` where `members`.`status` = 'Active' and `members`.`expiry_date` >= curdate() order by `members`.`full_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_expired_members`
--

/*!50001 DROP VIEW IF EXISTS `vw_expired_members`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_expired_members` AS select `members`.`id` AS `id`,`members`.`full_name` AS `full_name`,`members`.`phone` AS `phone`,`members`.`email` AS `email`,`members`.`plan` AS `plan`,`members`.`fee` AS `fee`,`members`.`start_date` AS `start_date`,`members`.`expiry_date` AS `expiry_date`,`members`.`status` AS `status`,to_days(curdate()) - to_days(`members`.`expiry_date`) AS `days_expired` from `members` where `members`.`expiry_date` < curdate() order by `members`.`expiry_date` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_outstanding_balances`
--

/*!50001 DROP VIEW IF EXISTS `vw_outstanding_balances`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_outstanding_balances` AS select `m`.`id` AS `id`,`m`.`full_name` AS `full_name`,`m`.`phone` AS `phone`,`m`.`email` AS `email`,`m`.`plan` AS `plan`,`m`.`fee` AS `fee`,`m`.`start_date` AS `start_date`,`m`.`expiry_date` AS `expiry_date`,`m`.`status` AS `status`,coalesce(sum(case when `p`.`status` = 'Paid' then `p`.`amount` else 0 end),0) AS `total_paid`,`m`.`fee` - coalesce(sum(case when `p`.`status` = 'Paid' then `p`.`amount` else 0 end),0) AS `balance_due` from (`members` `m` left join `payments` `p` on(`m`.`id` = `p`.`member_id`)) group by `m`.`id`,`m`.`full_name`,`m`.`phone`,`m`.`email`,`m`.`plan`,`m`.`fee`,`m`.`start_date`,`m`.`expiry_date`,`m`.`status` having `balance_due` > 0 order by `m`.`fee` - coalesce(sum(case when `p`.`status` = 'Paid' then `p`.`amount` else 0 end),0) desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_payment_summary`
--

/*!50001 DROP VIEW IF EXISTS `vw_payment_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_payment_summary` AS select cast(`payments`.`date` as date) AS `payment_date`,count(0) AS `transaction_count`,sum(`payments`.`amount`) AS `total_amount`,group_concat(distinct `payments`.`method` separator ', ') AS `payment_methods` from `payments` where `payments`.`status` = 'Paid' group by cast(`payments`.`date` as date) order by cast(`payments`.`date` as date) desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_revenue_by_plan`
--

/*!50001 DROP VIEW IF EXISTS `vw_revenue_by_plan`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_revenue_by_plan` AS select `m`.`plan` AS `plan`,count(distinct `m`.`id`) AS `member_count`,sum(`p`.`amount`) AS `total_revenue`,avg(`m`.`fee`) AS `avg_fee` from (`members` `m` left join `payments` `p` on(`m`.`id` = `p`.`member_id` and `p`.`status` = 'Paid')) group by `m`.`plan` order by sum(`p`.`amount`) desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-18 14:00:25
