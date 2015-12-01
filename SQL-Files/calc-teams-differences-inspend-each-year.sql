


DELIMITER $$
CREATE PROCEDURE calcDiff()
BEGIN
	
    #team count for our while
	DECLARE teamCount, i,innerTeamCount,j INT DEFAULT 1;
    DECLARE currTeam VARCHAR(100);
    DECLARE currYear VARCHAR(5);
	DECLARE prevSpend, prevIncome, PrevPosition INT;  
    
	CREATE TEMPORARY TABLE IF NOT EXISTS teams(
		team varchar(100)
    );

	CREATE TEMPORARY TABLE IF NOT EXISTS temp1(
		team varchar(100),
        league varchar(100),
        season varchar(5),
        spend int,
        income int,
        points int,
        position int
    );
   
   	CREATE TEMPORARY TABLE IF NOT EXISTS temp2(
		team varchar(100),
        league varchar(100),
        season varchar(5),
        spend int,
        income int,
        points int,
        position int
    );
    
	INSERT INTO teams
    SELECT DISTINCT team FROM cleaned_table_join;
   
	SET teamCount = (SELECT count(team) FROM teams);
    
    WHILE i < teamCount DO
		SET currTeam = (SELECT team FROM teams LIMIT 1);
		INSERT INTO temp1
        SELECT * FROM cleaned_table_join WHERE team = currTeam;
        SET innerTeamCount = (SELECT COUNT(team) FROM temp1);
        WHILE j < innerTeamCount DO
			SET currYear = (SELECT year FROM temp1 ORDER BY year ASC LIMIT 1);
			IF j = 1 THEN
            
            END IF;
            
        END WHILE;
        
        
	END WHILE;
   
END$$
DELIMITER ;
