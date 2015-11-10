
UPDATE transferhistory SET League = 'english-league-championship' WHERE League = 'champions-league'; ## fix champions league being different

UPDATE transferhistory SET TTeam = REPLACE(TTeam,'"','');
UPDATE tablehistory SET Team = REPLACE(Team,'"','');


ALTER VIEW transfers_Spend_v 
	AS
		SELECT League,Year,Team,SUM(Cost) as Spend FROM TransferHistory WHERE TransferType='arrival' group by Year,League,Team;

ALTER VIEW transfers_Income_v
	AS
		SELECT League,Year,Team,SUM(Cost) as Income FROM TransferHistory WHERE TransferType='departure' group by Year,League,Team;

ALTER VIEW transfer_table_join
AS
	SELECT TableHistory.team, TableHistory.league,TableHistory.season,t1.Spend,t2.Income, SUM(t2.Income - t1.Spend) AS Nett, TableHistory.points, TableHistory.Position FROM TableHistory
    LEFT JOIN transfers_Spend_v as t1 ON t1.League = TableHistory.league AND t1.Team = TableHistory.team AND t1.Year = TableHistory.season
    LEFT JOIN transfers_Income_v as t2 ON t2.League = TableHistory.league AND t2.Team = TableHistory.team AND t2.Year = TableHistory.season
    WHERE tablehistory.position <> 0
    GROUP BY TableHistory.team, TableHistory.league,TableHistory.season
    order by team ASC,season DESC;

SELECT * FROM transfer_table_join

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
            
				SET LikeVar = concat('%',C_SplitName);
                SET LikeVar = concat(LikeVar,'%');
                
				UPDATE TransferHistory SET Team = C_TeamName WHERE Team LIKE LikeVar;
                INSERT INTO DEBUG_LOG
				SELECT LikeVar;
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

CALL match_transfer_teams_to_table();

SELECT * FROM DEBUG_LOG;
DELETE FROM DEBUG_LOG;
#DROP PROCEDURE match_transfer_teams_to_table; 
