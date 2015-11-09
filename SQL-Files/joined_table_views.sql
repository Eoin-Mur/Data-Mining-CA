
UPDATE TableHistory SET League = 'champions-league' WHERE League = 'english-league-championship'; ## fix champions league being different


CREATE VIEW transfers_Spend_v 
	AS
		SELECT League,Year,REPLACE(Team,'"','') as Team,SUM(Cost) as Spend FROM TransferHistory WHERE TransferType='arrival' group by Year,League,Team;

CREATE VIEW transfers_Income_v
	AS
		SELECT League,Year,REPLACE(Team,'"','') as Team,SUM(Cost) as Income FROM TransferHistory WHERE TransferType='departure' group by Year,League,Team;

ALTER VIEW transfer_table_join
AS
	SELECT TableHistory.team, TableHistory.league,TableHistory.season,t1.Spend,t2.Income, SUM(t2.Income - t1.Spend) AS Nett, points FROM TableHistory
    LEFT JOIN transfers_Spend_v as t1 ON t1.League = TableHistory.league AND t1.Team = TableHistory.team AND t1.Year = TableHistory.season
    LEFT JOIN transfers_Income_v as t2 ON t2.League = TableHistory.league AND t2.Team = TableHistory.team AND t2.Year = TableHistory.season
    WHERE tablehistory.position <> 0
    GROUP BY TableHistory.team, TableHistory.league,TableHistory.season
    order by team ASC,season DESC;
    
    
SELECT * FROM transfer_table_join
	
