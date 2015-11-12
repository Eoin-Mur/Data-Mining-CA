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
par(mfrow=c(2,2))

t.p_TeamList <- t.p[!duplicated(t.p[1]),]$team

plot(t.p$Spend, t.p$points,main='barclays-premier-league',ylab='Points',xlab='Spend', col='black')

for(i in 1:length(t.p_TeamList)){
	s <- subset(t.p, team == t.p_TeamList[i])
	points(s$Spend,s$points, col=colorsList[i+10])
	usedColors <- c(usedColors,colorsList[i*5+10])
}

t.c_TeamList <- t.c[!duplicated(t.c[1]),]$team

plot(t.c$Spend, t.c$points, main='english-league-championship', ylab='Points',xlab='Spend', col='black')

for(i in 1:length(t.c_TeamList)){
	s <- subset(t.c, team == t.c_TeamList[i])
	points(s$Spend,s$points, col=colorsList[i+10])
	usedColors <- c(usedColors,colorsList[i*5+10])
}

t.l1_TeamList <- t.l1[!duplicated(t.l1[1]),]$team

plot(t.l1$Spend, t.l1$points,main='english-league-one',ylab='Points',xlab='Spend', col='black')

for(i in 1:length(t.l1_TeamList)){
	s <- subset(t.l1, team == t.l1_TeamList[i])
	points(s$Spend,s$points, col=colorsList[i+10])
	usedColors <- c(usedColors,colorsList[i*5+10])
}

t.l2_TeamList <- t.l2[!duplicated(t.l2[1]),]$team
plot(t.l2$Spend, t.l2$points,main='english-league-two',ylab='Points',xlab='Spend', col='black')

for(i in 1:length(t.l2_TeamList)){
	s <- subset(t.l2, team == t.l2_TeamList[i])
	points(s$Spend,s$points, col=colorsList[i+10])
	usedColors <- c(usedColors,colorsList[i*5+10])
}
