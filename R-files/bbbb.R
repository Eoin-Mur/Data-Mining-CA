library(DBI)

con <- dbConnect(RMySQL::MySQL(), group='data-mining-as')

cmd = "SELECT * FROM transfer_table_join"
res <- dbSendQuery(con,cmd)

t.all <- fetch(res, n = -1)
dbClearResult(res)

cmd = "SELECT * FROM transfer_table_join WHERE league = 'barclays-premier-league'"
res <- dbSendQuery(con,cmd)

t.p <- fetch(res,n = -1)
dbClearResult(res)

cmd = "SELECT * FROM transfer_table_join WHERE league = 'english-league-championship'"
res <- dbSendQuery(con,cmd)
t.c <- fetch(res,n = -1)

cmd = "SELECT * FROM transfer_table_join WHERE league = 'english-league-one'"
res <- dbSendQuery(con,cmd)
t.l1 <- fetch(res,n = -1)
dbClearResult(res)

cmd = "SELECT * FROM transfer_table_join WHERE league = 'english-league-two'"
res <- dbSendQuery(con,cmd)
t.l2 <- fetch(res,n = -1)
dbClearResult(res)

length(t.p$Spend)
length(t.p$points)
options(scipen=5)

colorsList <- colors()
t.p_TeamList <- t.p[!duplicated(t.p[1]),]$team
t.p_TeamList
for(i in 1:length(t.p_TeamList)){
	if(i == 1){
		s <- subset(t.p, team == t.p_TeamList[i])
		plot(s$season, s$points,main='barclays-premier-league', ,ylab='Points',xlab='Spend', col='black')
	}else {
		s <- subset(t.p, team == t.p_TeamList[i])
		points(s$season,s$points, col=colorsList[i+10])
		usedColors <- c(usedColors,colorsList[i*5+10])
	}
}