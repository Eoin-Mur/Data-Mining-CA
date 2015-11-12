DELIMITER $$
CREATE PROCEDURE getBinnedColumns()
BEGIN
	#########I know these declares and sets are horrible but fuck it only ment to run once, just insert into a new table and use that instead of calling this monster everytime :P##################

	#Spend
    DECLARE min_p,min_c,min_l1,min_l2 int;
    DECLARE max_p,max_c,max_l1,max_l2 int;
    DECLARE sep_p,sep_c,sep_l1,sep_l2 int;
    
    #Income
     DECLARE imin_p,imin_c,imin_l1,imin_l2 int;
    DECLARE imax_p,imax_c,imax_l1,imax_l2 int;
    DECLARE isep_p,isep_c,isep_l1,isep_l2 int;
    
    #Points
    DECLARE pmax_p,pmax_c,pmax_l1,pmax_l2 int;
    DECLARE psep_p,psep_c,psep_l1,psep_l2 int;
    
    #Spend
    SET min_p = (SELECT MIN(Spend) FROM cleaned_table_join WHERE league = 'barclays-premier-league' AND Spend <> 0);
    SET min_c = (SELECT MIN(Spend) FROM cleaned_table_join WHERE league = 'english-league-championship' AND Spend <> 0);
    SET min_l1 = (SELECT MIN(Spend) FROM cleaned_table_join WHERE league = 'english-league-one' AND Spend <> 0);
    SET min_l2 = (SELECT MIN(Spend) FROM cleaned_table_join WHERE league = 'english-league-two' AND Spend <> 0);
    
    SET max_p = (SELECT MAX(Spend) FROM cleaned_table_join WHERE league = 'barclays-premier-league' AND Spend <> 0);
    SET max_c = (SELECT MAX(Spend) FROM cleaned_table_join WHERE league = 'english-league-championship' AND Spend <> 0);
    SET max_l1 = (SELECT MAX(Spend) FROM cleaned_table_join WHERE league = 'english-league-one' AND Spend <> 0);
    SET max_l2 = (SELECT MAX(Spend) FROM cleaned_table_join WHERE league = 'english-league-two' AND Spend <> 0);
    
    SET sep_p = (SELECT SUM((max_p - min_p) / 3));
    SET sep_c = (SELECT SUM((max_c - min_c) / 3));
    SET sep_l1 = (SELECT SUM((max_l1 - min_l1) / 3));
    SET sep_l2 = (SELECT SUM((max_l2 - min_l2) / 3));
    
    #Income
	SET imin_p = (SELECT MIN(Income) FROM cleaned_table_join WHERE league = 'barclays-premier-league' AND Income <> 0);
    SET imin_c = (SELECT MIN(Income) FROM cleaned_table_join WHERE league = 'english-league-championship' AND Income <> 0);
    SET imin_l1 = (SELECT MIN(Income) FROM cleaned_table_join WHERE league = 'english-league-one' AND Income <> 0);
    SET imin_l2 = (SELECT MIN(Income) FROM cleaned_table_join WHERE league = 'english-league-two' AND Income <> 0);
    
    SET imax_p = (SELECT MAX(Income) FROM cleaned_table_join WHERE league = 'barclays-premier-league' AND Income <> 0);
    SET imax_c = (SELECT MAX(Income) FROM cleaned_table_join WHERE league = 'english-league-championship' AND Income <> 0);
    SET imax_l1 = (SELECT MAX(Income) FROM cleaned_table_join WHERE league = 'english-league-one' AND Income <> 0);
    SET imax_l2 = (SELECT MAX(Income) FROM cleaned_table_join WHERE league = 'english-league-two' AND Income <> 0);
    
    SET isep_p = (SELECT SUM((imax_p - imin_p) / 3));
    SET isep_c = (SELECT SUM((imax_c - imin_c) / 3));
    SET isep_l1 = (SELECT SUM((imax_l1 - imin_l1) / 3));
    SET isep_l2 = (SELECT SUM((imax_l2 - imin_l2) / 3));
    
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
        SpendClass varchar(30),
        IncomeClass varchar(30),
        Nett varchar(30),
        Points varchar(30),
        Position int
    );
    
    INSERT INTO temp
    SELECT 
		team,
        league,
        season,
        CASE WHEN Spend  = 0 THEN 'NoSpend' WHEN Spend < sep_p THEN 'LowSpend' WHEN Spend > sep_p AND Spend < SUM(sep_p * 2) THEN 'MediumSpend' WHEN Spend > SUM(sep_p * 2) THEN 'HighSpend' ELSE NULL END as Spend,
        CASE WHEN Income  = 0 THEN 'NoIncome' WHEN Income < isep_p THEN 'LowIncome' WHEN Income > isep_p AND Income< SUM(isep_p * 2) THEN 'MediumIncome' WHEN Income > SUM(isep_p * 2) THEN 'HighIncome' ELSE NULL END as Income,
        CASE WHEN Nett = 0 THEN 'Even' WHEN Nett < 0 THEN 'Negative' WHEN Nett > 0 THEN 'Profit' END as Nett,
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
        CASE WHEN Spend  = 0 THEN 'NoSpend' WHEN Spend < sep_c THEN 'LowSpend' WHEN Spend > sep_c AND Spend < SUM(sep_c * 2) THEN 'MediumSpend' WHEN Spend > SUM(sep_c * 2) THEN 'HighSpend' ELSE NULL END as Spend,
        CASE WHEN Income  = 0 THEN 'NoIncome' WHEN Income < isep_c THEN 'LowIncome' WHEN Income > isep_c AND Income< SUM(isep_c * 2) THEN 'MediumIncome' WHEN Income > SUM(isep_c * 2) THEN 'HighIncome' ELSE NULL END as Income,
        CASE WHEN Nett = 0 THEN 'Even' WHEN Nett < 0 THEN 'Negative' WHEN Nett > 0 THEN 'Profit' END as Nett,
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
        CASE WHEN Spend  = 0 THEN 'NoSpend' WHEN Spend < sep_l1 THEN 'LowSpend' WHEN Spend > sep_l1 AND Spend < SUM(sep_l1 * 2) THEN 'MediumSpend' WHEN Spend > SUM(sep_l1 * 2) THEN 'HighSpend' ELSE NULL END as Spend,
        CASE WHEN Income  = 0 THEN 'NoIncome' WHEN Income < isep_l1 THEN 'LowIncome' WHEN Income > isep_l1 AND Income< SUM(isep_l1 * 2) THEN 'MediumIncome' WHEN Income > SUM(isep_l1 * 2) THEN 'HighIncome' ELSE NULL END as Income,
        CASE WHEN Nett = 0 THEN 'Even' WHEN Nett < 0 THEN 'Negative' WHEN Nett > 0 THEN 'Profit' END as Nett,
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
        CASE WHEN Spend  = 0 THEN 'NoSpend' WHEN Spend < sep_l2 THEN 'LowSpend' WHEN Spend > sep_l2 AND Spend < SUM(sep_l2 * 2) THEN 'MediumSpend' WHEN Spend > SUM(sep_l2 * 2) THEN 'HighSpend' ELSE NULL END as Spend,
        CASE WHEN Income  = 0 THEN 'NoIncome' WHEN Income < isep_l2 THEN 'LowIncome' WHEN Income > isep_l2 AND Income< SUM(isep_l2 * 2) THEN 'MediumIncome' WHEN Income > SUM(isep_l2 * 2) THEN 'HighIncome' ELSE NULL END as Income,
        CASE WHEN Nett = 0 THEN 'Even' WHEN Nett < 0 THEN 'Negative' WHEN Nett > 0 THEN 'Profit' END as Nett,
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

CALL getBinnedColumns();
#DROP PROCEDURE getBinnedColumns;


