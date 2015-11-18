DELIMITER $$
CREATE PROCEDURE getBinnedPoints()
BEGIN

    #Points
    DECLARE pmax_p,pmax_c,pmax_l1,pmax_l2 int;
    DECLARE psep_p,psep_c,psep_l1,psep_l2 int;
    
    #Points
    SET pmax_p = (SELECT MAX(Points) FROM cleaned_table_join WHERE league = 'barclays-premier-league' );
    SET pmax_c = (SELECT MAX(Points) FROM cleaned_table_join WHERE league = 'english-league-championship' );
    SET pmax_l1 = (SELECT MAX(Points) FROM cleaned_table_join WHERE league = 'english-league-one' );
    SET pmax_l2 = (SELECT MAX(Points) FROM cleaned_table_join WHERE league = 'english-league-two' );
    
    SET psep_p = (SELECT SUM(pmax_p / 10));
    SET psep_c = (SELECT SUM(pmax_c / 10));
    SET psep_l1 = (SELECT SUM(pmax_l1 / 10));
    SET psep_l2 = (SELECT SUM(pmax_l2 / 10));
    
    CREATE TABLE IF NOT EXISTS temp(
        Team varchar(30),
        League varchar(30),
        Season int,
        Spend varchar(30),
        Income varchar(30),
        Nett varchar(30),
        Points varchar(30),
        Position int
    );
    
    INSERT INTO temp
    SELECT 
		team,
        league,
        season,
        Spend,
        Income,
		Nett,
        CASE 
			WHEN Points <= psep_p THEN 't10' 
            WHEN Points >= psep_p AND Points <= SUM(psep_p * 2) THEN 't9'
            WHEN Points >= SUM(psep_p * 2) AND Points <= SUM(psep_p * 3) THEN 't8'
            WHEN Points >= SUM(psep_p * 3) AND Points <= SUM(psep_p * 4) THEN 't7'
            WHEN Points >= SUM(psep_p * 4) AND Points <= SUM(psep_p * 5) THEN 't6'
            WHEN Points >= SUM(psep_p * 5) AND Points <= SUM(psep_p * 6) THEN 't5'
            WHEN Points >= SUM(psep_p * 6) AND Points <= SUM(psep_p * 7) THEN 't4'
            WHEN Points >= SUM(psep_p * 7) AND Points <= SUM(psep_p * 8) THEN 't3'
            WHEN Points >= SUM(psep_p * 8) AND Points <= SUM(psep_p * 9) THEN 't2'
            WHEN Points >= SUM(psep_p * 9)  THEN 't1' END AS Points,
        Position
	FROM cleaned_table_join
    WHERE cleaned_table_join.league = 'barclays-premier-league'
    Group BY  cleaned_table_join.Team, cleaned_table_join.season;
    
    INSERT INTO temp
    SELECT 
		team,
        league,
        season,
        Spend,
        Income,
		Nett,
        CASE 
			WHEN Points <= psep_c THEN 't10' 
            WHEN Points >= psep_c AND Points <= SUM(psep_p * 2) THEN 't9'
            WHEN Points >= SUM(psep_c * 2) AND Points <= SUM(psep_c * 3) THEN 't8'
            WHEN Points >= SUM(psep_c * 3) AND Points <= SUM(psep_c * 4) THEN 't7'
            WHEN Points >= SUM(psep_c * 4) AND Points <= SUM(psep_c * 5) THEN 't6'
            WHEN Points >= SUM(psep_c * 5) AND Points <= SUM(psep_c * 6) THEN 't5'
            WHEN Points >= SUM(psep_c * 6) AND Points <= SUM(psep_c * 7) THEN 't4'
            WHEN Points >= SUM(psep_c * 7) AND Points <= SUM(psep_c * 8) THEN 't3'
            WHEN Points >= SUM(psep_c * 8) AND Points <= SUM(psep_c * 9) THEN 't2'
            WHEN Points >= SUM(psep_c * 9)  THEN 't1' END AS Points,
        Position
	FROM cleaned_table_join
    WHERE cleaned_table_join.league = 'english-league-championship'
    Group BY  cleaned_table_join.Team, cleaned_table_join.season;
    
    INSERT INTO temp
    SELECT 
		team,
        league,
        season,
        Spend,
        Income,
		Nett,
        CASE 
			WHEN Points <= psep_l1 THEN 't10' 
            WHEN Points >= psep_l1 AND Points <= SUM(psep_p * 2) THEN 't9'
            WHEN Points >= SUM(psep_l1 * 2) AND Points <= SUM(psep_l1 * 3) THEN 't8'
            WHEN Points >= SUM(psep_l1 * 3) AND Points <= SUM(psep_l1 * 4) THEN 't7'
            WHEN Points >= SUM(psep_l1 * 4) AND Points <= SUM(psep_l1 * 5) THEN 't6'
            WHEN Points >= SUM(psep_l1 * 5) AND Points <= SUM(psep_l1 * 6) THEN 't5'
            WHEN Points >= SUM(psep_l1 * 6) AND Points <= SUM(psep_l1 * 7) THEN 't4'
            WHEN Points >= SUM(psep_l1 * 7) AND Points <= SUM(psep_l1 * 8) THEN 't3'
            WHEN Points >= SUM(psep_l1 * 8) AND Points <= SUM(psep_l1 * 9) THEN 't2'
            WHEN Points >= SUM(psep_l1 * 9)  THEN 't1' END AS Points,
        Position
	FROM cleaned_table_join
    WHERE cleaned_table_join.league = 'english-league-one'
    Group BY  cleaned_table_join.Team, cleaned_table_join.season;
    
    INSERT INTO temp
    SELECT 
		team,
        league,
        season,
		Spend,
        Income,
		Nett,
        CASE 
			WHEN Points <= psep_l2 THEN 't10' 
            WHEN Points >= psep_l2 AND Points <= SUM(psep_p * 2) THEN 't9'
            WHEN Points >= SUM(psep_l2 * 2) AND Points <= SUM(psep_l2 * 3) THEN 't8'
            WHEN Points >= SUM(psep_l2 * 3) AND Points <= SUM(psep_l2 * 4) THEN 't7'
            WHEN Points >= SUM(psep_l2 * 4) AND Points <= SUM(psep_l2 * 5) THEN 't6'
            WHEN Points >= SUM(psep_l2 * 5) AND Points <= SUM(psep_l2 * 6) THEN 't5'
            WHEN Points >= SUM(psep_l2 * 6) AND Points <= SUM(psep_l2 * 7) THEN 't4'
            WHEN Points >= SUM(psep_l2 * 7) AND Points <= SUM(psep_l2 * 8) THEN 't3'
            WHEN Points >= SUM(psep_l2 * 8) AND Points <= SUM(psep_l2 * 9) THEN 't2'
            WHEN Points >= SUM(psep_l2 * 9)  THEN 't1' END AS Points,
        Position
	FROM cleaned_table_join
    WHERE cleaned_table_join.league = 'english-league-two'
    Group BY  cleaned_table_join.Team, cleaned_table_join.season;


	SELECT * FROM temp;
    DROP TABLE temp;

END $$
DELIMITER ;

#drop procedure getBinnedPoints

CALL getBinnedPoints();
