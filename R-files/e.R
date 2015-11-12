library(DBI)

con <- dbConnect(RMySQL::MySQL(), group='data-mining-as')

cmd = "SELECT * FROM Spend_stats order by League ASC, AvgPoints DESC"
res <- dbSendQuery(con,cmd)

df <- fetch(res, n = -1)
dbClearResult(res)

teamList <- df[!duplicated(df[1]),]$team

df.p <- subset(df, League == 'barclays-premier-league')
df.c <- subset(df, League == 'english-league-championship')
df.l1 <- subset(df, League == 'english-league-one')
df.l2 <- subset(df,League == 'english-league-two')

par(mfrow=c(1,2))
barplot(df.p$AvgPoints,las="2", names.arg=(df.p$team),main='Points')
barplot(df.p$AvgSpend, las="2", names.arg=(df.p$team),main='Spend')
dbDisconnect(con)