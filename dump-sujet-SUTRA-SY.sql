DROP TABLE IF EXISTS medecin CASCADE;
DROP TABLE IF EXISTS MedecinTraitant CASCADE;
DROP TABLE IF EXISTS Service_hopital CASCADE;
DROP TABLE IF EXISTS Dossier CASCADE;
DROP TABLE IF EXISTS Date_admission CASCADE;
DROP TABLE IF EXISTS Historique CASCADE;
DROP TABLE IF EXISTS Fichier CASCADE;
DROP TABLE IF EXISTS ActeMedical CASCADE;
DROP TABLE IF EXISTS Allergie CASCADE;
DROP TABLE IF EXISTS travaille CASCADE;
DROP TABLE IF EXISTS atteint CASCADE;
DROP TABLE IF EXISTS est_admis CASCADE;



--On crée la table medecin
CREATE TABLE Medecin (
	IdPro char(11) primary key,
	 nom varchar(30) not null,
	 prenom varchar(30) not null,
	 adresse varchar(100) not null,
	 mdp varchar(120)

);


--On créé la table medecin traitant
CREATE TABLE MedecinTraitant (
	IdTraitant char(11) primary key,
	 nom varchar(30) not null,
	 prenom varchar(30) not null,
	 adresse varchar(100) not null
);

--On crée la table service
CREATE TABLE Service_hopital (
	IdService varchar(5) primary key,
	 nom_service varchar(50) not null UNIQUE,
	 localisation varchar(50) not null
);

--On crée la table dossier
CREATE TABLE Dossier (
	NumSecu char(13) primary key,
	 nom varchar(30) not null,
	 prenom varchar(30)not null ,
	 adresse varchar(100)not null,
     IdTraitant char(11) not null

);


--On crée la table date
CREATE TABLE Date_admission (
	IDdate serial primary key,
	Date_admis date not null
);

--On crée la table historique 
CREATE TABLE Historique (
	IdHist serial primary key,
	anciennete integer not null,
	CONSTRAINT hist_check CHECK(anciennete>=0)

);

--On crée la table Acte Medical
CREATE TABLE ActeMedical (
	IdActe char(6) primary key,
	 resumé text not null,
	 date_acte date not null,
	 heure time not null,
     NumSecu char(13) not null
);



--On crée la table fichier
CREATE TABLE Fichier (
	IdFichier char(6) primary key,
	 nom varchar(30) not null,
	 format_fichier bytea not null,
	 IdActe char(6) not null
);



--On crée la table Allergie
CREATE TABLE Allergie (
	code char(5) primary key,
	 dangerosite integer not null,
	 CONSTRAINT dangerosite CHECK(dangerosite BETWEEN 1 AND 10)
);

--On crée la table travaille
CREATE TABLE travaille (
	 IdPro char(11),
	 IDHist integer not null,
	 IdService char(5) not null,
	 fonction varchar(50) not null,
     CONSTRAINT cle_prim_travaille primary key(IdPro,IDHist,IdService)
);


--On crée la table atteint
CREATE TABLE atteint (
	code char(5),
	 NumSecu char(13),
	 debut date not null,
	 fin date not null,
	 CONSTRAINT check_date CHECK(debut < fin),
     CONSTRAINT cle_prim_atteint primary key(code,NumSecu)
);



--On crée la table est admis
CREATE TABLE est_admis (
	IDdate integer not null, 
	 NumSecu char(13) not null,
	 IdService char(5) not null,
     CONSTRAINT cle_prim_admis primary key(IDdate,NumSecu,idService)
);

--On definit les clés étrangères
ALTER TABLE est_admis
	ADD constraint est_admis_fkey1 FOREIGN KEY (IDdate) REFERENCES Date_admission(IDdate);
	

ALTER TABLE est_admis
	ADD constraint est_admis_fkey2 FOREIGN KEY (NumSecu) REFERENCES dossier(NumSecu);

ALTER TABLE est_admis
	ADD constraint est_admis_fkey3 FOREIGN KEY (IdService) REFERENCES Service_hopital(idService);

ALTER TABLE Dossier
	ADD constraint dossier_fkey FOREIGN KEY (IdTraitant) REFERENCES MedecinTraitant(IdTraitant);

ALTER TABLE ActeMedical
	ADD constraint ActeMedical_fkey FOREIGN KEY (NumSecu) REFERENCES dossier(NumSecu);

ALTER TABLE Fichier
	ADD constraint fichier_fkey FOREIGN KEY (IdActe) REFERENCES ActeMedical(IdActe);

ALTER TABLE travaille
	ADD constraint travaille_fkey1 FOREIGN KEY (IdPro) REFERENCES medecin(IdPro);

ALTER TABLE travaille
	ADD constraint travaille_fkey2 FOREIGN KEY (IdHist) REFERENCES Historique(IdHist);

ALTER TABLE travaille
	ADD constraint travaille_fkey3 FOREIGN KEY (IdService) REFERENCES Service_hopital(IdService);

ALTER TABLE atteint
	ADD constraint atteint_fkey1 FOREIGN KEY (code) REFERENCES Allergie(code);

ALTER TABLE atteint
	ADD constraint atteint_fkey2 FOREIGN KEY (NumSecu) REFERENCES Dossier(NumSecu);



--Données:
--medecin
INSERT INTO medecin VALUES ('01750192003','Boudjellal','Zino','15 Rue du Plateau 77470 Trilport','$2b$12$yKB3gKOiKg4qH0VCDt01we/lKsIdLPFTGlU8e.0BZdu/iEf1FyDBu');
INSERT INTO medecin VALUES ('01750112003','Sutra','Jérémy','27 Rue JP Timbaud 75011 Paris','$2b$12$se0LRGfnv4ZBh0MO9g2PJOgsAFZ0j8Mx7Q94kQmodUIdPZfWqyR36');
INSERT INTO medecin VALUES ('02921401965','Dupont','Jean','3 Avenue de la Republique 75010 Paris','$2b$12$qpT0HvfaZL.Qdf37sUHXpO9OrpZ5gULxFrjCRL7v7vZmiWhp/vuzy');

--medecin traitant:
INSERT INTO MedecinTraitant VALUES ('0675001998','Messi','Lionnel','8 Place de la coupe du monde');
INSERT INTO MedecinTraitant VALUES ('4578001998','Clément','Martin','5 Avenue des Champs-Elysées');
INSERT INTO MedecinTraitant VALUES ('5686002098','Gasly','Pierre','1 Boulevard du championnat');

--Service_hopital
INSERT INTO Service_hopital VALUES ('BLOC1','Bloc operatoire 1','Batiment A Etage -1');
INSERT INTO Service_hopital VALUES ('ONCOL','Oncologie','Batiment B Etage 3');
INSERT INTO Service_hopital VALUES ('URGEN','Urgences','Batiment A Etage RDC');

--dossier
INSERT INTO Dossier VALUES ('1031275011011','Lappe','Kevin','3 Chemin du vent 77420 Champs Sur Marne','0675001998');
INSERT INTO Dossier VALUES ('2270393190101','Martin','Lola','16 Rue de Noisy 77700 Chessy','0675001998');
INSERT INTO Dossier VALUES ('1080177000011','Martin','Kevin','16 Rue de Noisy 77700 Chessy','5686002098');
INSERT INTO Dossier VALUES ('2150611100011','Vergne','Camille','48 Sentier de la mer 93330 Neuilly Sur Marne','4578001998');
INSERT INTO Dossier VALUES ('1150633300011','Hage','Marc','99 Rue de la montagne 92140 Clamart','5686002098');
--date
INSERT INTO Date_admission (Date_admis) VALUES ('2012-11-11');
INSERT INTO Date_admission (Date_admis) VALUES ('2017-12-11');
INSERT INTO Date_admission (Date_admis) VALUES ('2013-10-10');
INSERT INTO Date_admission (Date_admis) VALUES ('2019-12-03');

--Historique
INSERT INTO Historique(anciennete) VALUES (5);
INSERT INTO Historique(anciennete) VALUES (28);
INSERT INTO Historique(anciennete) VALUES (18);
INSERT INTO Historique(anciennete) VALUES (56);

--Acte Medical
INSERT INTO ActeMedical VALUES ('F01B05',' 20 Points de suture sur l arcarde droite','2022-12-11','02:08:36','1031275011011');
INSERT INTO ActeMedical VALUES ('A65P80',' 20 Points de suture sur l arcarde droite','2022-10-10','08:08:36','1080177000011');
INSERT INTO ActeMedical VALUES ('A66P80',' Platre bras gauche dû à une chute de skate','2022-11-11','12:58:00','2270393190101');
INSERT INTO ActeMedical VALUES ('B01P90',' Passage annuel pour prevention de cancer','2022-12-11','18:08:00','2150611100011');
INSERT INTO ActeMedical VALUES ('C01P90',' Extraction dents de sagesse','2019-12-03','15:55:00','2270393190101');
INSERT INTO ActeMedical VALUES ('A01P60',' Extraction dents de sagesse','2019-12-03','18:08:00','1031275011011');
INSERT INTO ActeMedical VALUES ('Y89P74',' Operation de l appendicite','2019-12-03','13:37:11','2150611100011');


--Fichier
INSERT INTO Fichier VALUES ('a0001','photo.png','photo.png','F01B05');
INSERT INTO Fichier VALUES ('a0002','img.png','img.png','C01P90');
INSERT INTO Fichier VALUES ('a0003','photo.png','photo.png','A65P80');
INSERT INTO Fichier VALUES ('a0004','scan.png','scan.png','B01P90');
INSERT INTO Fichier VALUES ('a0005','img.png','img.png','A01P60');
INSERT INTO Fichier VALUES ('a0005','image.png','image.png','Y89P74');

--Allergie
INSERT INTO Allergie VALUES ('FELD1',5);
INSERT INTO Allergie VALUES ('AE06A',9);
INSERT INTO Allergie VALUES ('SIMP0',1);

--travaille
INSERT INTO travaille VALUES ('01750192003',4,'ONCOL','Chercheur');
INSERT INTO travaille VALUES ('01750192003',3,'BLOC1','Assistant opératoire');
INSERT INTO travaille VALUES ('01750112003',1,'URGEN','Responsable Urgentiste');
INSERT INTO travaille VALUES ('02921401965',2,'URGEN','Urgentiste');
INSERT INTO travaille VALUES ('02921401965',3,'BLOC1','Chirurgien');

--atteint
INSERT INTO atteint VALUES ('FELD1','2150611100011','2015-10-30','2020-11-11');
INSERT INTO atteint VALUES ('SIMP0','1031275011011','2022-09-07','2023-09-07');
INSERT INTO atteint VALUES ('AE06A','1031275011011','2012-02-17','2020-09-07');
INSERT INTO atteint VALUES ('AE06A','1150633300011','1999-03-17','2040-09-07');
INSERT INTO atteint VALUES ('FELD1','1150633300011','2005-10-12','2020-11-11');
INSERT INTO atteint VALUES ('SIMP0','1150633300011','2022-07-07','2023-07-07');

--est_admis
INSERT INTO est_admis VALUES (4,'1031275011011','BLOC1');
INSERT INTO est_admis VALUES (2,'1031275011011','URGEN');
INSERT INTO est_admis VALUES (1,'1080177000011','URGEN');
INSERT INTO est_admis VALUES (3,'2270393190101','URGEN');
INSERT INTO est_admis VALUES (2,'2270393190101','BLOC1');
INSERT INTO est_admis VALUES (1,'2150611100011','ONCOL');
INSERT INTO est_admis VALUES (4,'2150611100011','BLOC1');

CREATE VIEW vue1 AS (SELECT medecin.nom,medecin.prenom,count( DISTINCT dossier.NumSecu) AS nb_patients_guerris FROM medecin NATURAL JOIN travaille NATURAL JOIN service_hopital NATURAL JOIN est_admis JOIN dossier ON est_admis.numsecu=dossier.numsecu JOIN atteint ON dossier.numsecu=atteint.numsecu WHERE fin<'2022-11-22' GROUP BY medecin.nom,medecin.prenom ORDER BY nb_patients_guerris DESC); 
CREATE VIEW vue2 AS (SELECT count(IdActe) as nb_actes,prenom,nom FROM atteint NATURAL JOIN Dossier NATURAL JOIN ActeMedical GROUP BY prenom,nom);
CREATE VIEW vue3 AS (SELECT dangerosite, ((count(atteint.NumSecu)/count(dossier.NumSecu))*100) AS pourcentage_personnes_atteintes FROM dossier NATURAL JOIN atteint NATURAL JOIN Allergie GROUP BY  dangerosite);