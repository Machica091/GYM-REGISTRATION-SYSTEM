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
-- Current Database: `gym_registration_db`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `gym_registration_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

USE `gym_registration_db`;

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
INSERT INTO `members` VALUES ('MEM001','Juan','Carlos','Santos','Juan Carlos Santos','09171234567','juan.santos@email.com','Monthly',1500.00,'2024-01-15','2025-01-15','Active','2026-10-16 09:35:59','2026-10-16 09:35:59'),('MEM002','Maria','Grace','Rodriguez','Maria Grace Rodriguez','09172345678','maria.rodriguez@email.com','Quarterly',4000.00,'2024-02-10','2025-05-10','Active','2026-10-16 09:35:59','2026-10-16 09:35:59'),('MEM003','Jose','','Cruz','Jose Cruz','09173456789','jose.cruz@email.com','Yearly',14000.00,'2023-03-20','2025-03-20','Active','2026-10-16 09:35:59','2026-10-16 09:35:59'),('MEM004','Ana','Marie','Lopez','Ana Marie Lopez','09174567890','ana.lopez@email.com','Monthly',1500.00,'2024-11-01','2024-12-01','Active','2026-10-16 09:35:59','2026-10-16 09:35:59'),('MEM005','Pedro','Manuel','Garcia','Pedro Manuel Garcia','09175678901','pedro.garcia@email.com','Weekly',400.00,'2024-12-10','2024-12-17','Inactive','2026-10-16 09:35:59','2026-10-16 09:35:59'),('MEM006','Rosa','Lyn','Fernandez','Rosa Lyn Fernandez','09176789012','rosa.fernandez@email.com','Monthly',1500.00,'2024-10-15','2024-11-15','Inactive','2026-10-16 09:35:59','2026-10-16 09:35:59'),('MEM007','Miguel','Angel','Ruiz','Miguel Angel Ruiz','09177890123','miguel.ruiz@email.com','Quarterly',4000.00,'2024-09-01','2024-12-01','Active','2026-10-16 09:35:59','2026-10-16 09:35:59'),('MEM008','Carmen','Sofia','Torres','Carmen Sofia Torres','09178901234','carmen.torres@email.com','Monthly',1500.00,'2024-11-20','2024-12-20','Active','2026-10-16 09:35:59','2026-10-16 09:35:59'),('MEM009','Felipe','Diego','Morales','Felipe Diego Morales','09179012345','felipe.morales@email.com','Monthly',1500.00,'2024-12-01','2025-01-01','Active','2026-10-16 09:35:59','2026-10-16 09:35:59'),('MEM010','Isabella','Rose','Mendoza','Isabella Rose Mendoza','09180123456','isabella.mendoza@email.com','Daily',100.00,'2024-12-14','2024-12-14','Active','2026-10-16 09:35:59','2026-10-16 09:35:59');
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
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
  `member_id` varchar(50) NOT NULL,
  `member_name` varchar(300) NOT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `method` varchar(50) NOT NULL DEFAULT 'Cash',
  `date` datetime NOT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'Paid',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `reference` (`reference`),
  KEY `idx_reference` (`reference`),
  KEY `idx_member_id` (`member_id`),
  KEY `idx_date` (`date`),
  KEY `idx_status` (`status`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (1,'PAY20241201001','MEM001','Juan Carlos Santos',1500.00,'Cash','2024-12-01 09:30:00','Paid','2026-10-16 09:35:59','2026-10-16 09:35:59'),(2,'PAY20241201002','MEM002','Maria Grace Rodriguez',4000.00,'Debit Card','2024-12-02 10:15:00','Paid','2026-10-16 09:35:59','2026-10-16 09:35:59'),(3,'PAY20241203003','MEM003','Jose Cruz',14000.00,'Cash','2024-03-20 14:45:00','Paid','2026-10-16 09:35:59','2026-10-16 09:35:59'),(4,'PAY20241205004','MEM004','Ana Marie Lopez',1500.00,'GCash','2024-12-05 11:20:00','Paid','2026-10-16 09:35:59','2026-10-16 09:35:59'),(5,'PAY20241206005','MEM005','Pedro Manuel Garcia',400.00,'Cash','2024-12-06 08:00:00','Paid','2026-10-16 09:35:59','2026-10-16 09:35:59'),(6,'PAY20241207006','MEM006','Rosa Lyn Fernandez',1500.00,'Debit Card','2024-10-15 15:30:00','Paid','2026-10-16 09:35:59','2026-10-16 09:35:59'),(7,'PAY20241208007','MEM007','Miguel Angel Ruiz',4000.00,'Cash','2024-09-01 09:00:00','Paid','2026-10-16 09:35:59','2026-10-16 09:35:59'),(8,'PAY20241209008','MEM008','Carmen Sofia Torres',1500.00,'GCash','2024-11-20 13:45:00','Paid','2026-10-16 09:35:59','2026-10-16 09:35:59'),(9,'PAY20241210009','MEM009','Felipe Diego Morales',1500.00,'Cash','2024-12-01 10:30:00','Paid','2026-10-16 09:35:59','2026-10-16 09:35:59'),(10,'PAY20241211010','MEM010','Isabella Rose Mendoza',100.00,'Cash','2024-12-14 16:00:00','Paid','2026-10-16 09:35:59','2026-10-16 09:35:59'),(11,'PAY20241212011','MEM001','Juan Carlos Santos',1500.00,'Debit Card','2024-11-15 09:30:00','Paid','2026-10-16 09:35:59','2026-10-16 09:35:59'),(12,'PAY20241213012','MEM002','Maria Grace Rodriguez',1000.00,'GCash','2024-11-10 14:20:00','Paid','2026-10-16 09:35:59','2026-10-16 09:35:59'),(13,'PAY20241214013','MEM003','Jose Cruz',500.00,'Cash','2024-12-14 11:45:00','Pending','2026-10-16 09:35:59','2026-10-16 09:35:59');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_positions`
--

LOCK TABLES `staff_positions` WRITE;
/*!40000 ALTER TABLE `staff_positions` DISABLE KEYS */;
INSERT INTO `staff_positions` VALUES (1,'CLEANER','2026-10-25 12:57:08');
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `idx_username` (`username`),
  KEY `idx_role` (`role`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'owner','owner123','Owner','2026-10-16 09:35:59','2026-10-16 09:35:59'),(2,'manager','manager123','Manager','2026-10-16 09:35:59','2026-10-16 09:35:59'),(3,'staff1','staff123','Staff','2026-10-16 09:35:59','2026-10-16 09:35:59'),(4,'staff2','staff456','Staff','2026-10-16 09:35:59','2026-10-16 09:35:59'),(5,'receptionist','reception123','Staff','2026-10-16 09:35:59','2026-10-16 09:35:59');
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
-- Dumping events for database 'gym_registration_db'
--

--
-- Dumping routines for database 'gym_registration_db'
--

--
-- Current Database: `gym_registration_db`
--

USE `gym_registration_db`;

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

-- Dump completed on 2026-11-15 13:59:04
