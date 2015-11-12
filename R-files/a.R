library(DBI)

con <- dbConnect(RMySQL::MySQL(), group='data-mining-as')

cmd = "SELECT * FROM cleaned_table_join order by league ASC, points DESC "
res <- dbSendQuery(con,cmd)

df <- fetch(res, n = -1)

df.p <- subset(df, league == 'barclays-premier-league' & season == '2005')
df.c <- subset(df, league == 'english-league-championship')
df.l1 <- subset(df, league == 'english-league-one')
df.l2 <- subset(df, league == 'english-league-two')

par(mfrow=c(1,2))
barplot(df.p$points,las="2", names.arg=(df.p$team),main='Points')
barplot(df.p$Spend, las="2", names.arg=(df.p$team),main='Spend')