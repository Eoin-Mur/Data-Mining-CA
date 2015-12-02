#SELECT *  FROM transfer_table_join WHERE Spend = 0 order by team, season DESC;

#SELECT League, team, season,Points FROM transfer_table_join WHERE Spend = 0 order by League ASC, team ASC, season DESC;


SELECT League,team,avg(Points),sqrt(variance(Points)),Count(team) FROM transfer_table_join WHERE Spend = 0 Group BY League,team;

CREATE VIEW No_SpendOrIncome_stats AS
	SELECT League,team,avg(Points) as AvgPoints,sqrt(variance(Points)) as SDPoints,Count(team) as Count
    FROM transfer_table_join 
    WHERE Spend = 0 AND Income = 0 GROUP BY League, team;
    
CREATE VIEW No_Spend_stats AS
	SELECT League,team,avg(Points) as AvgPoints,sqrt(variance(Points)) as SDPoints,Count(team) as Count
    FROM transfer_table_join 
    WHERE Spend = 0 GROUP BY League, team;
    
CREATE VIEW TeamsOccerenceInLeagues as
	SELECT League,team,Count(team) as years_in_league FROM transfer_table_join group by League,team;
    
SELECT t1.League, t1.team, t1.AvgPoints, t1.SDPoints, t1.Count,t2.years_in_league FROM No_SPendOrIncome_stats AS t1 
LEFT OUTER JOIN TeamsOccerenceInLeagues as t2 ON t2.League = t1.League AND t2.team = t1.team;

SELECT t1.League, t1.team, t1.AvgPoints, t1.SDPoints, t1.Count,t2.years_in_league FROM No_Spend_stats AS t1 
LEFT OUTER JOIN TeamsOccerenceInLeagues as t2 ON t2.League = t1.League AND t2.team = t1.team;

SELECT * FROM No_SpendOrIncome_stats WHERE Count <> 1;
SELECT * FROM No_Spend_stats WHERE Count <> 1 Order BY SDPoints DESC;

SELECT league, AVG(SDPoints) FROM No_Spend_Stats WHERE Count <> 1 GROUP BY League;
SELECT League, AVG(SDPoints) FROM No_SpendOrIncome_stats WHERE Count <> 1 GROUP BY League;

CREATE VIEW SpendAndIncome_stats AS
	SELECT League,team,avg(Points) as AvgPoints,sqrt(variance(Points)) as SDPoints,Count(team) as Count
    FROM transfer_table_join 
    WHERE Spend <> 0 AND Income <> 0 GROUP BY League, team;
    
CREATE VIEW Spend_stats AS
	SELECT League,team,avg(Spend) as AvgSpend,avg(Points) as AvgPoints,sqrt(variance(Points)) as SDPoints,Count(team) as Count
    FROM transfer_table_join 
    WHERE Spend <> 0 GROUP BY League, team;


SELECT * FROM Spend_stats;
SELECT League,Count(Team) FROM Spend_stats Group BY League;

SELECT league, AVG(SDPoints) FROM Spend_Stats GROUP BY League;
SELECT League, AVG(SDPoints) FROM SpendAndIncome_stats GROUP BY League;

SELECT t1.Team FROM (SELECT Team, Count(Team) as c FROM transfer_table_join Group BY Team) as t1 WHERE t1.c = 10


