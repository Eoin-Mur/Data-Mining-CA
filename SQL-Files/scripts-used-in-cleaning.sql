
###############################################
######## Import transfers adn clean ###########
###############################################

#CALL TransferHistoryImport()
#DROP PROCEDURE TransferHistoryImport;
DELIMITER $$
CREATE PROCEDURE TransferHistoryImport()
BEGIN

    #Flag for when our text cursor is finished
    DECLARE CursorDone INT DEFAULT 0;
    #declare var's to hold cursor values.
    DECLARE c_Id,c_Text,c_TransType,c_Year,c_Season,c_Player,c_RowId,c_Team,c_Owner,c_TransTypeId VARCHAR(100) DEFAULT "";
    DECLARE m_Id, m_Year, m_Season, m_RowId, m_TransTypeId VARCHAR(100) DEFAULT "";
    #declare our cursors
    DECLARE TextCursor CURSOR FOR SELECT Id,TransferType,Text,Year,Season,Player,RowId,Team,Owner,TransferTypeId FROM data_mining_assignment.TransfersImport;
    DECLARE MissingCursor CURSOR FOR SELECT CleanedId,CleanedYear,CleanedSeason,CleanedRowId,CleanedTransTypeId FROM CleanedTransfers WHERE CleanedOwner = "";
    DECLARE ImportCursor CURSOR FOR SELECT * FROM CleanedTransfers;
    #declare NOT FOUND handlier 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET CursorDone = 1;
	#create a table to hold the text values for clean up.
    CREATE TEMPORARY TABLE IF NOT EXISTS CleanedTransfers
    (
		CleanedId int,
		CleanedTransType varchar(10),
		CleanedText varchar(255),
        CleanedYear varchar(10),
        CleanedSeason int,
        CleanedPlayer varchar(100),
        CleanedRowId int,
        CleanedTeam varchar(100),
        CleanedOwner varchar(100),
        CleanedTransTypeId int
    );

	OPEN TextCursor;
    
   #loop through all our Text rows with a cursor
    CleanTextLoop: LOOP
		FETCH TextCursor INTO c_Id,c_TransType, c_Text,c_Year,c_Season,c_Player,c_RowId,c_Team,c_Owner,c_TransTypeId;
        #if our Flag for NOT FOUND is set then leave the loop
        IF CursorDone = 1 THEN
			LEAVE CleanTextLoop;
		END IF;
        
		INSERT INTO CleanedTransfers
        SELECT c_Id,c_TransType, CleanTransfersText(c_Text),c_Year,c_Season,c_Player,c_RowId,c_Team,c_Owner,c_TransTypeId;
        
    END LOOP;
    
    CLOSE TextCursor;
    
    #now that we have the transfers in a table with the text cleaned
    #need to fill the missing owner values
    SET CursorDone = 0;
    
    #Create a duplicate temp table
    CREATE TEMPORARY TABLE IF NOT EXISTS CleanedTransfersDupe
    (
		CleanedId int,
		CleanedTransType varchar(10),
		CleanedText varchar(255),
        CleanedYear varchar(10),
        CleanedSeason int,
        CleanedPlayer varchar(100),
        CleanedRowId int,
        CleanedTeam varchar(100),
        CleanedOwner varchar(100),
        CleanedTransTypeId int
    );
    
    INSERT CleanedTransfersDupe
    SELECT * FROM CleanedTransfers;
    
    #now need to loop through the cleaned table to insert the missing owner values
    #do this using the ids i added durng the scrape
    OPEN MissingCursor;
    MissingLoop: LOOP
		FETCH MissingCursor INTO m_Id, m_Year, m_Season, m_RowId, m_TransTypeId;
        IF CursorDone = 1 THEN
			LEAVE MissingLoop;
		END IF;
		
        UPDATE CleanedTransfers
        SET CleanedTransfers.CleanedOwner = 
			(
				SELECT CleanedTransfersDupe.CleanedOwner 
				FROM CleanedTransfersDupe 
				WHERE 
					CleanedTransfersDupe.CleanedYear = m_Year AND 
					CleanedTransfersDupe.CleanedSeason = m_Season AND 
					CleanedTransfersDupe.CleanedRowId = m_RowId AND
					CleanedTransfersDupe.CleanedTransTypeId = 1
				LIMIT 1
			)
		WHERE CleanedTransfers.CleanedId = m_Id;
	END Loop;
    
    CLOSE MissingCursor;
    
    SET CursorDone = 0;
    
    #now the import the cleaned data in the correct format to the TransferHistory Table
    OPEN ImportCursor;
    ImportLoop: LOOP
		FETCH ImportCursor INTO c_Id,c_TransType, c_Text,c_Year,c_Season,c_Player,c_RowId,c_Team,c_Owner,c_TransTypeId;
        IF CursorDone = 1 THEN
			LEAVE ImportLoop;
		END IF;
		
        IF c_Text = "" THEN
			INSERT TransferHistory(Team,League,LeagueId,Year,TransferType,PlayerSurname,Cost,Loan,BackLoan,TTeam)
            SELECT
				c_Owner,
				CASE
					WHEN c_Season = 1 THEN 'barclays-premier-league'
                    WHEN c_Season = 2 THEN 'champions-league'
                    WHEN c_Season = 3 THEN 'english-league-one'
					ELSE 'english-league-two'
				END,
                c_Season,
                c_Year,
                c_TransType,
                c_Player,
                0,
                0,
                0,
                c_Team;
                
		ELSEIF LOCATE('€',c_Text) > 0 THEN
			INSERT TransferHistory(Team,League,LeagueId,Year,TransferType,PlayerSurname,Cost,Loan,BackLoan,TTeam)
            SELECT
				c_Owner,
				CASE
					WHEN c_Season = 1 THEN 'barclays-premier-league'
                    WHEN c_Season = 2 THEN 'champions-league'
                    WHEN c_Season = 3 THEN 'english-league-one'
					ELSE 'english-league-two'
				END,
                c_Season,
                c_Year,
                c_TransType,
                c_Player,
                ConvertTextToReal(c_Text),
                0,
                0,
                c_Team;
	
		ELSEIF LOCATE('B',c_Text) > 0 THEN
			INSERT TransferHistory(Team,League,LeagueId,Year,TransferType,PlayerSurname,Cost,Loan,BackLoan,TTeam)
            SELECT
				c_Owner,
				CASE
					WHEN c_Season = 1 THEN 'barclays-premier-league'
                    WHEN c_Season = 2 THEN 'champions-league'
                    WHEN c_Season = 3 THEN 'english-league-one'
					ELSE 'english-league-two'
				END,
                c_Season,
                c_Year,
                c_TransType,
                c_Player,
                0,
                0,
                1,
                c_Team;
		
		ELSE
			INSERT TransferHistory(Team,League,LeagueId,Year,TransferType,PlayerSurname,Cost,Loan,BackLoan,TTeam)
            SELECT
				c_Owner,
				CASE
					WHEN c_Season = 1 THEN 'barclays-premier-league'
                    WHEN c_Season = 2 THEN 'champions-league'
                    WHEN c_Season = 3 THEN 'english-league-one'
					ELSE 'english-league-two'
				END,
                c_Season,
                c_Year,
                c_TransType,
                c_Player,
                0,
                1,
                0,
                c_Team;
			
       END IF;
       
	END LOOP;

	CLOSE ImportCursor;
    
	#SELECT * FROM CleanedTransfers;
    #SELECT * FROM TransferHistory;
    DROP TABLE CleanedTransfers;
    DROP TABLE CleanedTransfersDupe;
    
END$$
DELIMITER ;


#Function That takes in a Text Value from our TransfersImport Table
#and cleans it up by selecting what is inbetween the last ',' and ')'

#SELECT CleanTransfersText(' , (,, 5 M€) - 31 Augu 2006')
#DROP FUNCTION CleanTransfersText
DELIMITER $$
CREATE FUNCTION CleanTransfersText(Text varchar(255))  RETURNS VARCHAR(255) 
BEGIN
	DECLARE c VARCHAR(255);
	
    SET c = SUBSTRING(Text, 1,LOCATE(')',Text)-1);
    
	WHILE LOCATE(',',c) > 0 DO
		SET c = SUBSTRING(c, LOCATE(',',c) + 1,LENGTH(c));
	END WHILE;
    
    RETURN c;
END$$
DELIMITER ;

#SELECT ConvertTextToReal('125 k€');
#SELECT ConvertTextToReal('1 M€');
#SELECT ConvertTextToReal('2.5 M€');
#DROP FUNCTION ConvertTextToReal
DELIMITER $$
CREATE FUNCTION ConvertTextToReal(Text VARCHAR(100)) RETURNS REAL
BEGIN
	DECLARE r REAL;
    IF LOCATE('M',Text) > 0 THEN
		SET Text = SUBSTRING(Text,1,LOCATE('M',Text) -1);
        SET r = Text * 1000000;
	ELSEIF LOCATE('k',Text) > 0 THEN 
		SET Text = SUBSTRING(Text,1,LOCATE('k',Text) -1);
        SET r = Text * 1000;
	ELSE 
		SET r = 0;
	END IF;
    RETURN r;
END$$
DELIMITER ;



####################################
######## join two tables ###########
####################################


UPDATE transferhistory SET League = 'english-league-championship' WHERE League = 'champions-league'; ## fix champions league being different

##remove double qoutes
UPDATE transferhistory SET Team = REPLACE(Team,'"','');
UPDATE transferhistory SET TTeam = REPLACE(TTeam,'"','');
UPDATE transferhistory SET PlayerSurname = REPLACE(PlayerSurname,'"','');
UPDATE tablehistory SET Team = REPLACE(Team,'"','');

##### data scrubing procedreu to fix inconsitencies acrros the two table

DELIMITER $$
CREATE PROCEDURE match_transfer_teams_to_table()
BEGIN

    DECLARE CursorDone,Cursor2Done INT DEFAULT 0;
    DECLARE C_TeamName, C_SplitName,s varchar(100) DEFAULT '';
    DECLARE del VARCHAR(1) default ' ';
    DECLARE LikeVar varchar(102);
    DECLARE TeamCursor CURSOR FOR SELECT Distinct team FROM TableHistory WHERE Position <> 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET CursorDone = 1;
    CREATE TEMPORARY TABLE IF NOT EXISTS temp(word varchar(100));
    
    OPEN TeamCursor;
    
    TeamLoop: LOOP
        FETCH TeamCursor INTO C_TeamName;
        #if our Flag for NOT FOUND is set then leave the loop
        IF CursorDone = 1 THEN
            CLOSE TeamCursor;
            LEAVE TeamLoop;
        END IF;
        
        IF (SELECT COUNT(*) FROM TransferHistory WHERE Team = C_TeamName) = 0 THEN
            
            SET s = C_TeamName;
            
            IF LOCATE(del,s) = 0 THEN
                INSERT INTO temp 
                SELECT s;
            END IF;
             
             WHILE LOCATE(del,s) > 0 do
             
                INSERT INTO temp 
                SELECT SUBSTRING(s, 1,LOCATE(del,s) - 1);
                
                SET s = SUBSTRING(s, LOCATE(del,s) + 1,LENGTH(s));
                IF LOCATE(del,s) = 0 THEN
                    INSERT INTO temp 
                    SELECT s;
                END IF;
             END WHILE;
            
            SET C_SplitName = (SELECT word FROM temp LIMIT 0,1);
            IF C_SplitName <> 'AFC' THEN
                IF C_SplitName = 'West' THEN
                    SET C_SplitName = concat(C_SplitName,concat(' ',(SELECT word FROM temp LIMIT 1,1)));
                    SET LikeVar = concat('%',C_SplitName);
                    SET LikeVar = concat(LikeVar,'%');
                    
                    UPDATE TransferHistory SET Team = C_TeamName WHERE Team LIKE LikeVar;
                    INSERT INTO DEBUG_LOG
                    SELECT LikeVar;
                ELSE
                    SET LikeVar = concat('%',C_SplitName);
                    SET LikeVar = concat(LikeVar,'%');
                    
                    UPDATE TransferHistory SET Team = C_TeamName WHERE Team LIKE LikeVar;
                    INSERT INTO DEBUG_LOG
                    SELECT LikeVar;
                END IF;
            ELSE 
                SET C_SplitName = (SELECT word FROM temp LIMIT 1,1);
                SET LikeVar = concat('%',C_SplitName);
                SET LikeVar = concat(LikeVar,'%');
                UPDATE TransferHistory SET Team = C_TeamName WHERE Team LIKE LikeVar;
                INSERT INTO DEBUG_LOG
                SELECT LikeVar;
            END IF;
            
            DELETE FROM temp;
        END IF;
    END LOOP;
    DROP TABLE temp;
    
END$$
DELIMITER ;

##DROP PROCEDURE match_transfer_teams_to_table;

CREATE TABLE DEBUG_LOG(Log VARCHAR(10000))
SELECT * FROM DEBUG_LOG; ##log just to aid in debuging the matching as we are doing direct updates need to make sure data is not getting overwriten that shouldnt

CREATE VIEW transfers_Spend_v 
    AS
        SELECT League,Year,Team,SUM(Cost) as Spend FROM TransferHistory WHERE TransferType='arrival' group by Year,League,Team;

CREATE VIEW transfers_Income_v
    AS
        SELECT League,Year,Team,SUM(Cost) as Income FROM TransferHistory WHERE TransferType='departure' group by Year,League,Team;

CREATE VIEW transfer_table_join
AS
    SELECT TableHistory.team, TableHistory.league,TableHistory.season,t1.Spend,t2.Income, TableHistory.points, TableHistory.Position FROM TableHistory
    LEFT JOIN transfers_Spend_v as t1 ON t1.League = TableHistory.league AND t1.Team = TableHistory.team AND t1.Year = TableHistory.season
    LEFT JOIN transfers_Income_v as t2 ON t2.League = TableHistory.league AND t2.Team = TableHistory.team AND t2.Year = TableHistory.season
    WHERE tablehistory.position <> 0 
    GROUP BY TableHistory.team, TableHistory.league,TableHistory.season
    order by team ASC,season DESC;


#DROP PROCEDURE match_transfer_teams_to_table; 



##############################################
######## create final cleaned view ###########
##############################################


CREATE View cleaned_table_join 
AS  
    SELECT 
        team,
        league,
        season, 
        SUM( (spend - (SELECT MIN(spend) FROM transfer_table_join) ) / ( (SELECT MAX(spend) FROM transfer_table_join)  - (SELECT MIN(spend) FROM transfer_table_join) ) )  as spend,
        SUM( (income - (SELECT MIN(income) FROM transfer_table_join) ) / ( (SELECT MAX(income) FROM transfer_table_join)  - (SELECT MIN(income) FROM transfer_table_join) ) )  as income,
        points,
        position
    FROM 
        transfer_table_join 
        WHERE team IN (SELECT team FROM transfer_table_join Group BY Team HAVING COUNT(Team) = 10)
        GROUP BY team,season;


CREATE TABLE FinalDataset(
    team varchar(100),
    league varchar(100),
    season varchar(100), 
    spend real,
    income real,
    points real,
    position int
);

INSERT INTO FinalDataset
SELECT * FROM cleaned_table_join;