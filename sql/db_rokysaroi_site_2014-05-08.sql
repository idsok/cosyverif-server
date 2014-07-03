# ************************************************************
# Sequel Pro SQL dump
# Version 4096
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# H�te: 127.0.0.1 (MySQL 5.6.16)
# Base de donn�es: db_rokysaroi_site
# Temps de g�n�ration: 2014-05-08 09:11:43 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Affichage de la table Address
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Address`;

CREATE TABLE `Address` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `street` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `zip` varchar(100) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `status` int(1) DEFAULT NULL,
  `idUser` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `Address` WRITE;
/*!40000 ALTER TABLE `Address` DISABLE KEYS */;

INSERT INTO `Address` (`id`, `street`, `city`, `zip`, `country`, `status`, `idUser`)
VALUES
	(1,'1 allée des écoles','Rosny Sous Bois','93110','France',1,1);

/*!40000 ALTER TABLE `Address` ENABLE KEYS */;
UNLOCK TABLES;


# Affichage de la table CentreInteret
# ------------------------------------------------------------

DROP TABLE IF EXISTS `CentreInteret`;

CREATE TABLE `CentreInteret` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `libelle` varchar(100) DEFAULT NULL,
  `idType` int(11) DEFAULT NULL,
  `idCV` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `CentreInteret` WRITE;
/*!40000 ALTER TABLE `CentreInteret` DISABLE KEYS */;

INSERT INTO `CentreInteret` (`id`, `libelle`, `idType`, `idCV`)
VALUES
	(1,'Sport',1,1),
	(2,'Musique',1,1),
	(3,'Lecture',1,1);

/*!40000 ALTER TABLE `CentreInteret` ENABLE KEYS */;
UNLOCK TABLES;


# Affichage de la table Competance
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Competance`;

CREATE TABLE `Competance` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `libelle` varchar(100) DEFAULT NULL,
  `niveau` int(11) DEFAULT NULL,
  `status` int(1) DEFAULT '1',
  `idType` int(11) DEFAULT NULL,
  `idDomaine` int(11) DEFAULT '1',
  `idCV` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `Competance` WRITE;
/*!40000 ALTER TABLE `Competance` DISABLE KEYS */;

INSERT INTO `Competance` (`id`, `libelle`, `niveau`, `status`, `idType`, `idDomaine`, `idCV`)
VALUES
	(1,'Algorithmique réparti avancé',3,1,1,1,1),
	(2,'modélisation des systèmes répartis',3,1,1,1,1),
	(3,'noyaux des systèmes d\'exploitation',2,1,1,1,1),
	(4,'systèmes embarqués',1,1,1,1,1),
	(5,'systèmes temps réel',2,1,1,1,1),
	(6,'systèmes synchrones',2,1,1,1,1),
	(7,'base de données répartis',3,1,1,1,1),
	(8,'simulation et calcul scientifique',2,1,1,1,1),
	(9,'réseaux',2,1,1,1,1),
	(10,'JAVA (awt/Swing/jdbc)',3,1,2,1,1),
	(11,'J2EE',3,1,2,1,1),
	(12,'C (POSIX/POSIX-RT)',3,1,2,1,1),
	(13,'IOS (Objective-c)',3,1,2,1,1),
	(14,'VB',3,1,2,1,1),
	(15,'SQL',3,1,2,1,1),
	(16,'C++',2,1,3,1,1),
	(17,'Android',2,1,3,1,1),
	(18,'Ada',1,1,3,1,1),
	(19,'Langage synchrone (Lustre et Esterel)',1,1,3,1,1),
	(20,'PHP',3,1,4,1,1),
	(21,'J2EE',3,1,4,1,1),
	(22,'HTML/CSS',3,1,4,1,1),
	(23,'XML',2,1,4,1,1),
	(24,'Javascript',2,1,4,1,1),
	(25,'Ajax',1,1,4,1,1),
	(26,'Spring',2,1,5,1,1),
	(27,'Hibernate',2,1,5,1,1),
	(28,'JSF',2,1,5,1,1),
	(29,'Struts',2,1,5,1,1),
	(30,'EJB',2,1,5,1,1),
	(31,'RPC',2,1,5,1,1),
	(32,'RMI',3,1,5,1,1),
	(33,'Corba',2,1,5,1,1),
	(34,'Hadoop (Map Reduce)',2,1,5,1,1),
	(35,'Peersim (Plateforme de simulation)',2,1,5,1,1),
	(36,'MPI-OpenMP',2,1,5,1,1),
	(37,'CUDA',2,1,5,1,1),
	(38,'OSGI',2,1,5,1,1),
	(39,'UML',3,1,6,1,1),
	(40,'Merise',2,1,6,1,1),
	(41,'AADL',1,1,6,1,1),
	(42,'Oracle',1,1,7,1,1),
	(43,'MySQL',3,1,7,1,1),
	(44,'LDAP',2,1,7,1,1),
	(45,'Active Directory',2,1,7,1,1),
	(46,'Access',2,1,7,1,1),
	(47,'OS (Linux, Mac OSX, Windows)',2,1,8,1,1),
	(48,'IDE (Eclipse, NetBeans, Sublime text 2, Gedit, Vim, Xcode)',2,1,8,1,1),
	(49,'VCS (Git, SVN)',2,1,8,1,1),
	(50,'Français(Lu, écrit et parlé)',2,1,9,1,1),
	(51,'Anglais(notions)',1,1,9,1,1),
	(52,'Arabe(notions)',1,1,9,1,1),
	(53,'Soninké (langue maternelle)',3,1,9,1,1);

/*!40000 ALTER TABLE `Competance` ENABLE KEYS */;
UNLOCK TABLES;


# Affichage de la table CV
# ------------------------------------------------------------

DROP TABLE IF EXISTS `CV`;

CREATE TABLE `CV` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `photo` varchar(100) DEFAULT NULL,
  `title` varchar(250) DEFAULT NULL,
  `status` text,
  `idUser` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `CV` WRITE;
/*!40000 ALTER TABLE `CV` DISABLE KEYS */;

INSERT INTO `CV` (`id`, `photo`, `title`, `status`, `idUser`)
VALUES
	(1,'cv_photo.jpg','Ingenieur  des systemes et applications repartis','Recherche de stage de fin d\'etudes dans le cadre de mon Master 2 Systemes et applications repartis a l\'Universite Pierre et Marie Curie',1);

/*!40000 ALTER TABLE `CV` ENABLE KEYS */;
UNLOCK TABLES;


# Affichage de la table DomaineCompetance
# ------------------------------------------------------------

DROP TABLE IF EXISTS `DomaineCompetance`;

CREATE TABLE `DomaineCompetance` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `libelle` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `DomaineCompetance` WRITE;
/*!40000 ALTER TABLE `DomaineCompetance` DISABLE KEYS */;

INSERT INTO `DomaineCompetance` (`id`, `libelle`)
VALUES
	(1,'Informatique'),
	(2,'Génie civile');

/*!40000 ALTER TABLE `DomaineCompetance` ENABLE KEYS */;
UNLOCK TABLES;


# Affichage de la table Experience
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Experience`;

CREATE TABLE `Experience` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `libelle` varchar(100) DEFAULT NULL,
  `description` text,
  `etablissement` varchar(100) DEFAULT NULL,
  `lieu` varchar(100) DEFAULT NULL,
  `dateGegin` varchar(11) DEFAULT NULL,
  `dateEnd` varchar(11) DEFAULT NULL,
  `ordre` int(11) DEFAULT NULL,
  `idType` int(11) DEFAULT NULL,
  `idCV` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `Experience` WRITE;
/*!40000 ALTER TABLE `Experience` DISABLE KEYS */;

INSERT INTO `Experience` (`id`, `libelle`, `description`, `etablissement`, `lieu`, `dateGegin`, `dateEnd`, `ordre`, `idType`, `idCV`)
VALUES
	(1,'Stage ',NULL,'au Laboratoire LIP6','Paris (France)','07/2013','09/2013',1,2,1),
	(2,'Stage ',NULL,'chez Bell Ingénierie','Dakar (Sénégal)','10/2009','12/2010',2,2,1),
	(3,'SOCOM et SUNNUGAL',NULL,'chez SOCOM et SUNNUGAL','Dakar (Sénégal)','07/2007','05/2008',3,1,1),
	(4,'Stage universitaire ','Mise en place d\'un portail captif web d?un réseau WIFI','auprès de l\'école supérieure de technologie et de management\r(ESTM)','Dakar (Sénégal)','07/2006','09/2006',4,2,1),
	(5,'BBBBB','BBBBBBb','BBBBBBBb','Paris (France)','09/2010','09/2010',5,2,1),
	(6,'BBBBB','BBBBBBb','BBBBBBBb','Paris (France)','09/2010','09/2010',6,2,1),
	(7,'BBBBB','BBBBBBb','BBBBBBBb','Paris (France)','09/2010','09/2010',7,2,1),
	(8,'BBBBB','BBBBBBb','BBBBBBBb','Paris (France)','09/2010','09/2010',8,2,1),
	(9,'BBBBB','BBBBBBb','BBBBBBBb','Paris (France)','09/2010','09/2010',9,2,1),
	(10,'BBBBB','BBBBBBb','BBBBBBBb','Paris (France)','09/2010','09/2010',10,2,1),
	(11,'BBBBB','BBBBBBb','BBBBBBBb','Paris (France)','09/2010','09/2010',11,2,1);

/*!40000 ALTER TABLE `Experience` ENABLE KEYS */;
UNLOCK TABLES;


# Affichage de la table Formation
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Formation`;

CREATE TABLE `Formation` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `libelle` varchar(100) DEFAULT NULL,
  `description` text,
  `etablissement` varchar(100) DEFAULT NULL,
  `lieu` varchar(100) DEFAULT NULL,
  `dateBegin` varchar(11) DEFAULT NULL,
  `dateEnd` varchar(11) DEFAULT NULL,
  `ordre` varchar(11) DEFAULT NULL,
  `idCV` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `Formation` WRITE;
/*!40000 ALTER TABLE `Formation` DISABLE KEYS */;

INSERT INTO `Formation` (`id`, `libelle`, `description`, `etablissement`, `lieu`, `dateBegin`, `dateEnd`, `ordre`, `idCV`)
VALUES
	(1,'Baccalauréat option sciences de la vie','Baccalauréat option sciences de la vie, Lycée El Ourwa, Nouakchott (Mauritanie)','Lycée El Ourwa','Nouakchott (Mauritanie)','2003','2004','4',1),
	(2,'Licence en Téléinformatique, option : Génie logiciel et administration réseaux','Licence en Téléinformatique, option : Génie logiciel et administration réseaux, à l\'école supérieure de technologie et de management (ESTM), Dakar (Sénégal)',' à l\'école supérieure de technologie et de management (ESTM)','Dakar (Sénégal)','2004','2007','3',1),
	(3,'Master en Téléinformatique','Master en Téléinformatique, à l\'école supérieure de technologie et de management (ESTM), Dakar (Sénégal)','à l\'école supérieure de technologie et de management (ESTM)','Dakar (Sénégal)','2007','2011','2',1),
	(4,'Master Informatique spécialité systèmes et applications répartis','Master Informatique spécialité systèmes et applications répartis, à l\'université Pierre et Marie Curie (UPMC), Paris (France)','à l\'université Pierre et Marie Curie','Paris (France)','2011','2014','1',1);

/*!40000 ALTER TABLE `Formation` ENABLE KEYS */;
UNLOCK TABLES;


# Affichage de la table Phone
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Phone`;

CREATE TABLE `Phone` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `number` varchar(100) DEFAULT NULL,
  `idType` int(11) DEFAULT NULL,
  `idUser` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `Phone` WRITE;
/*!40000 ALTER TABLE `Phone` DISABLE KEYS */;

INSERT INTO `Phone` (`id`, `number`, `idType`, `idUser`)
VALUES
	(1,'06 51 94 44 71',1,1);

/*!40000 ALTER TABLE `Phone` ENABLE KEYS */;
UNLOCK TABLES;


# Affichage de la table Task
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Task`;

CREATE TABLE `Task` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `libelle` varchar(100) DEFAULT NULL,
  `description` text,
  `idExperience` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `Task` WRITE;
/*!40000 ALTER TABLE `Task` DISABLE KEYS */;

INSERT INTO `Task` (`id`, `libelle`, `description`, `idExperience`)
VALUES
	(1,'Intégration des outils de vérification','Intégration des outils de vérification dans le plateforme de vérification des systèmes, CosyVerif.',1),
	(2,'Application web de gestion','Application web de gestion d\'ordinateurs et de fournitures de bureau en J2EE (JSF/JDBC) et php',2),
	(3,'Application web de gestion des produits sanitaires','Application web de gestion des produits sanitaires en HTML/CSS/PHP/MySQL',2),
	(4,'Application de gestion des services','Application de gestion des services de l\'entreprise (stock, ventes, ...) en JAVA/Swing/JDBC',2),
	(5,'Réalisation d\'une application de gestion','Réalisation d\'une application de gestion de quincaillerie et d\'une application de gestion des produits alimentaires en VB',3),
	(6,'Mise en place d\'un portail captif web','Mise en place d?un portail captif web d\'un réseau WIFI',4),
	(7,'BB BB BB BB BB','BB BB bBB bBB',5),
	(8,'BB BB BB BB BB','BB BB bBB bBB',5),
	(9,'BB BB BB BB BB','BB BB bBB bBB',6),
	(10,'BB BB BB BB BB','BB BB bBB bBB',6),
	(11,'BB BB BB BB BB','BB BB bBB bBB',7),
	(12,'BB BB BB BB BB','BB BB bBB bBB',7),
	(13,'BB BB BB BB BB','BB BB bBB bBB',8),
	(14,'BB BB BB BB BB','BB BB bBB bBB',8),
	(15,'BB BB BB BB BB','BB BB bBB bBB',9),
	(16,'BB BB BB BB BB','BB BB bBB bBB',9),
	(17,'BB BB BB BB BB','BB BB bBB bBB',10),
	(18,'BB BB BB BB BB','BB BB bBB bBB',10),
	(19,'BB BB BB BB BB','BB BB bBB bBB',10),
	(20,'BB BB BB BB BB','BB BB bBB bBB',11),
	(21,'BB BB BB BB BB','BB BB bBB bBB',11),
	(22,'BB BB BB BB BB','BB BB bBB bBB',11),
	(23,'BB BB BB BB BB','BB BB bBB bBB',11);

/*!40000 ALTER TABLE `Task` ENABLE KEYS */;
UNLOCK TABLES;


# Affichage de la table TypeCentreInteret
# ------------------------------------------------------------

DROP TABLE IF EXISTS `TypeCentreInteret`;

CREATE TABLE `TypeCentreInteret` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `libelle` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `TypeCentreInteret` WRITE;
/*!40000 ALTER TABLE `TypeCentreInteret` DISABLE KEYS */;

INSERT INTO `TypeCentreInteret` (`id`, `libelle`)
VALUES
	(1,'Loisirs');

/*!40000 ALTER TABLE `TypeCentreInteret` ENABLE KEYS */;
UNLOCK TABLES;


# Affichage de la table TypeCompetance
# ------------------------------------------------------------

DROP TABLE IF EXISTS `TypeCompetance`;

CREATE TABLE `TypeCompetance` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `libelle` varchar(100) DEFAULT NULL,
  `ordre` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `TypeCompetance` WRITE;
/*!40000 ALTER TABLE `TypeCompetance` DISABLE KEYS */;

INSERT INTO `TypeCompetance` (`id`, `libelle`, `ordre`)
VALUES
	(1,'Compétences théoriques',1),
	(2,'Langages pratiqués',2),
	(3,'Langages connus',3),
	(4,'Technologies web',4),
	(5,'Frameworks et API',5),
	(6,'Modélisation',6),
	(7,'Base de données',7),
	(8,'Environnements de développement',8),
	(9,'Langues',9);

/*!40000 ALTER TABLE `TypeCompetance` ENABLE KEYS */;
UNLOCK TABLES;


# Affichage de la table TypeExperience
# ------------------------------------------------------------

DROP TABLE IF EXISTS `TypeExperience`;

CREATE TABLE `TypeExperience` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `libelle` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `TypeExperience` WRITE;
/*!40000 ALTER TABLE `TypeExperience` DISABLE KEYS */;

INSERT INTO `TypeExperience` (`id`, `libelle`)
VALUES
	(1,'Job'),
	(2,'Stage');

/*!40000 ALTER TABLE `TypeExperience` ENABLE KEYS */;
UNLOCK TABLES;


# Affichage de la table TypePhone
# ------------------------------------------------------------

DROP TABLE IF EXISTS `TypePhone`;

CREATE TABLE `TypePhone` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `libelle` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `TypePhone` WRITE;
/*!40000 ALTER TABLE `TypePhone` DISABLE KEYS */;

INSERT INTO `TypePhone` (`id`, `libelle`)
VALUES
	(1,'Portable'),
	(2,'Fixe'),
	(3,'Bureau');

/*!40000 ALTER TABLE `TypePhone` ENABLE KEYS */;
UNLOCK TABLES;


# Affichage de la table User
# ------------------------------------------------------------

DROP TABLE IF EXISTS `User`;

CREATE TABLE `User` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `firstName` varchar(100) DEFAULT NULL,
  `lastName` varchar(100) DEFAULT NULL,
  `surName` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;

INSERT INTO `User` (`id`, `firstName`, `lastName`, `surName`, `email`)
VALUES
	(1,'Idrissa','SOKHONA','Roky','sokhona_idrissa@yahoo.fr');

/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
