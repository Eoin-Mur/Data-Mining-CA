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

options(scipen=5)

colorsList <- colors()



data.frame(mean(t.p$Spend),mean(t.c$Spend),mean(t.l1$Spend),mean(t.l2$Spend))
data.frame(median(t.p$Spend),median(t.c$Spend),median(t.l1$Spend),median(t.l2$Spend))

m <- aggregate(Nett ~ season, t.p,mean)
m2 <- aggregate(Spend~ season, t.p,mean)
par(mfrow=c(2,2))
plot(m$season ,m$Nett, type="l", main='barclays-premier-league', ylab='Spend',xlab='Year')
lines(m2$season,m2$Spend, col="blue")
m <- aggregate(Nett~ season, t.c,mean)
m2 <- aggregate(Spend~ season, t.c,mean)
plot(m$season ,m$Nett, type="l" , main='english-league-championship', ylab='Spend',xlab='Year')
lines(m2$season,m2$Spend, col="blue")
m <- aggregate(Nett~ season, t.l1,mean)
m2 <- aggregate(Spend~ season, t.l1,mean)
plot(m$season ,m$Nett, type="l" , main='english-league-one', ylab='Spend',xlab='Year')
lines(m2$season,m2$Spend, col="blue")
m <- aggregate(Nett~ season, t.l2,mean)
m2 <- aggregate(Spend~ season, t.l2,mean)
plot(m$season ,m$Nett, type="l" , main='english-league-two', ylab='Spend',xlab='Year')
lines(m2$season,m2$Spend, col="blue")



