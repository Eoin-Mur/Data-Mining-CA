library(DBI)

con <- dbConnect(RMySQL::MySQL(), group='data-mining-as')

cmd = "SELECT Year, Sum(Cost) as Cost FROM TransferHistory GROUP BY Year"
res <- dbSendQuery(con,cmd)

transferCost.All <- fetch(res, n = -1)
transferCost.All
dbClearResult(res)

##PremierShip
cmd = "SELECT Year, Sum(Cost) as Cost FROM TransferHistory WHERE League = 'barclays-premier-league' GROUP BY Year"
res <- dbSendQuery(con,cmd)

transferCost.Premier <- fetch(res,n = -1)
dbClearResult(res)

##Champions
cmd = "SELECT Year, Sum(Cost) as Cost FROM TransferHistory WHERE League = 'champions-league' GROUP BY Year"
res <- dbSendQuery(con,cmd)

transferCost.Champions <- fetch(res,n = -1)
dbClearResult(res)

##League 1
cmd = "SELECT Year, Sum(Cost) as Cost FROM TransferHistory WHERE League = 'english-league-one' GROUP BY Year"
res <- dbSendQuery(con,cmd)

transferCost.League1 <- fetch(res,n = -1)
dbClearResult(res)

##League 2
cmd = "SELECT Year, Sum(Cost) as Cost FROM TransferHistory WHERE League = 'english-league-two' GROUP BY Year"
res <- dbSendQuery(con,cmd)

transferCost.League2 <- fetch(res,n = -1)
dbClearResult(res)

transferCost.All
transferCost.Premier
transferCost.Champions
transferCost.League1
transferCost.League2

plot(transferCost.All$Year, transferCost.All$Cost, type="l", col="red")
lines(transferCost.All$Year, transferCost.Premier$Cost, col="blue")
lines(transferCost.All$Year, transferCost.Champions$Cost, col="yellow")
lines(transferCost.All$Year, transferCost.League1$Cost, col="green")
lines(transferCost.All$Year, transferCost.League2$Cost, col="black")

dbDisconnect(con)