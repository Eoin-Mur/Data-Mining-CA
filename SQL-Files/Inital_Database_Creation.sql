CREATE SCHEMA IF NOT EXISTS data_mining_assignment;

USE data_mining_assignment;

CREATE TABLE IF NOT EXISTS TransferHistory
(
	TransferId INT NOT NULL AUTO_INCREMENT,
	Team VARCHAR(35) NOT NULL,
    League varchar(60) NOT NULL,
    LeagueId int NOT NULL,
    Year YEAR NOT NULL,
    TransferType VARCHAR(10),
    PlayerSurname VARCHAR(55),
    Cost REAL,
    Loan INT NOT NULL,
    BackLoan INT NOT NULL,
    TTeam VARCHAR(100),    
    primary key(TransferId)
);


#SELECT * FROM TransferHistory;

#DELETE FROM TransferHistory;

#ALTER TABLE TransferHistory AUTO_INCREMENT = 1;

#Most pain in the arse function ever!!!
#first doenst allow file_name as a paramater 
#and then is not allowed to be in stored procedures!!!! WHY!

#work around:
#just create what was supposed to be a temp table in a procedure as a proper one
#import it and then just do all the clean up from a procedure working of this table

CREATE TABLE IF NOT EXISTS TransfersImport
(
	Id int NOT NULL AUTO_INCREMENT,
	TransferType varchar(10),
    Text varchar(255),
    Year year,
    Season int,
    Player varchar(255),
    RowId int,
    Team varchar(255),
    Owner varchar(255),
    TransferTypeId varchar(255),
    PRIMARY KEY(Id)
);
 
load data local infile 'C:/Users/Eoin/Documents/GitHub/Data-Mining-CA/Web-Scrape/football_transfers/Extracted_csv_files/full_extract.csv' 
INTO TABLE TransfersImport
FIELDS 
	TERMINATED BY ','
    ENCLOSED BY '"'
LINES 
	TERMINATED BY '\n'
IGNORE 1 LINES
(TransferType,Text,Year,Season,Player,RowId,Team,Owner,TransferTypeId);

#SELECT * FROM transfersimport;

SELECT * FROM transfersimport
WHERE Year = 2005
AND Owner = 'Brighton & Hove'
AND Season = 2
AND Team = 'Aston Villa B'


