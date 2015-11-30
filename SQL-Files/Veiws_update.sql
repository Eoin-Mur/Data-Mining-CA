ALTER VIEW transfer_table_join
AS
	SELECT TableHistory.team, TableHistory.league,TableHistory.season,t1.Spend,t2.Income, TableHistory.points, TableHistory.Position FROM TableHistory
    LEFT JOIN transfers_Spend_v as t1 ON t1.League = TableHistory.league AND t1.Team = TableHistory.team AND t1.Year = TableHistory.season
    LEFT JOIN transfers_Income_v as t2 ON t2.League = TableHistory.league AND t2.Team = TableHistory.team AND t2.Year = TableHistory.season
    WHERE tablehistory.position <> 0 
    GROUP BY TableHistory.team, TableHistory.league,TableHistory.season
    order by team ASC,season DESC;


ALTER View cleaned_table_join 
AS	
	SELECT 
		team,
		league,
		season, 
		#case spend WHEN 0 then 1 else spend end as spend,
        #case income WHEN 0 then 1 else income end as income, 
        spend,
        income,
        points,
        position
	FROM 
		transfer_table_join 
        WHERE team IN (SELECT team FROM transfer_table_join Group BY Team HAVING COUNT(Team) = 10)
        GROUP BY team,season;

ALTER View cleaned_table_join 
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
    
    
CREATE view teamMinMax
as
	select team, MIN(spend) as minSpend, max(spend) as maxSpend,min(income) as minIncome, MAX(income) as maxIncome FROM transfer_table_join GROUP BY team;
    
ALTER View cleaned_table_join 
AS	
	SELECT 
		transfer_table_join.team,
		transfer_table_join.league,
		transfer_table_join.season, 
        SUM( (spend -  t1.minSpend) / ( t1.maxSpend  - t1.minSpend ) )  as spend,
        SUM( (income -  t1.minIncome) / ( t1.maxIncome - t1.minIncome) )  as income,
        transfer_table_join.points,
        transfer_table_join.position
	FROM 
		transfer_table_join 
	left outer join teamMinMax as t1 ON t1.team = transfer_table_join.team
	WHERE transfer_table_join.team IN (SELECT team FROM transfer_table_join Group BY Team HAVING COUNT(Team) = 10)
    GROUP BY transfer_table_join.team,transfer_table_join.season;
    

