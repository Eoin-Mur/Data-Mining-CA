#Procedure to clean up the data scraped and imported to the Table TransfersImport
#and once cleaned up insertred it to the Table TransferHistory.

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