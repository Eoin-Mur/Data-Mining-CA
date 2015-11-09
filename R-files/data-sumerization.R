library(DBI)

con <- dbConnect(RMySQL::MySQL(), group='data-mining-as')

cmd = "SELECT * FROM TransferHistory"
res <- dbSendQuery(con,cmd)

transfer.df <- fetch(res, n = -1)

Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

x <- as.matrix(subset(transfer.df, select = c(Cost)))
m <- mean(x)
me <- median(x)
mo <- Mode(x)


transfer.all = data.frame(m,me,mo)
row.names(transfer.all) <- c("All Transfers")
colnames(transfer.all) <- c("mean","median","mode")

# arr/debSub = All Arrival/departure Transfers
# arr/debSub1 = Arrival/departure Transfers Excluding Loans/BackLoans
# arr/debSub2 = Arrival/departure Transfers that have a cost associated to them


transfer.arrSub <- subset(transfer.df, 
					TransferType == 'arrival',
					select = c(League,Cost))
transfer.arrSub1 <- subset(transfer.df, 
					TransferType == 'arrival' &
					BackLoan == 0 &
					Loan == 0,
					select = c(League,Cost))
transfer.arrSub2 <- subset(transfer.df,
					TransferType == 'arrival' &
					Cost != 0,
					select = c(League,Cost))

transfer.debSub <- subset(transfer.df, 
					TransferType == 'departure',
					select = c(League,Cost))
transfer.debSub1 <- subset(transfer.df, 
					TransferType == 'departure' &
					BackLoan == 0 &
					Loan == 0,
					select = c(League,Cost))
transfer.debSub2 <- subset(transfer.df,
					TransferType == 'departure' &
					Cost != 0,
					select = c(League,Cost))

plot(arrSub)


f <- c(aggregate(formula = Cost ~ League, data = transfer.df, FUN = mean))
a <- c(aggregate(formula = Cost ~ League, data = transfer.arrSub, FUN = mean))
a1 <- c(aggregate(formula = Cost ~ League, data = transfer.arrSub1, FUN = mean))
a2 <- c(aggregate(formula = Cost ~ League, data = transfer.arrSub2, FUN = mean))

a3 <- c(aggregate(formula = Cost ~ League, data = transfer.debSub, FUN = mean))
a4 <- c(aggregate(formula = Cost ~ League, data = transfer.debSub1, FUN = mean))
a5 <- c(aggregate(formula = Cost ~ League, data = transfer.debSub2, FUN = mean))

transfer.mean = data.frame(f["Cost"],a["Cost"],a1["Cost"],a2["Cost"],a3["Cost"],a4["Cost"],a5["Cost"])

row.names(transfer.mean) = c("premier league","champions league","league one","league two")
colnames(transfer.mean) = c("arr&dep","arrSub","arrSub1","arrSub2","depSub","depSub1","depSub2")

f <- c(aggregate(formula = Cost ~ League, data = transfer.df, FUN = median))
a <- c(aggregate(formula = Cost ~ League, data = transfer.arrSub, FUN = median))
a1 <- c(aggregate(formula = Cost ~ League, data = transfer.arrSub1, FUN = median))
a2 <- c(aggregate(formula = Cost ~ League, data = transfer.arrSub2, FUN = median))

a3 <- c(aggregate(formula = Cost ~ League, data = transfer.debSub, FUN = median))
a4 <- c(aggregate(formula = Cost ~ League, data = transfer.debSub1, FUN = median))
a5 <- c(aggregate(formula = Cost ~ League, data = transfer.debSub2, FUN = median))

transfer.median = data.frame(f["Cost"],a["Cost"],a1["Cost"],a2["Cost"],a3["Cost"],a4["Cost"],a5["Cost"])

row.names(transfer.median) = c("premier league","champions league","league one","league two")
colnames(transfer.median) = c("arr&dep","arrSub","arrSub1","arrSub2","depSub","depSub1","depSub2")

f <- c(aggregate(formula = Cost ~ League, data = transfer.df, FUN = Mode))
a <- c(aggregate(formula = Cost ~ League, data = transfer.arrSub, FUN = Mode))
a1 <- c(aggregate(formula = Cost ~ League, data = transfer.arrSub1, FUN = Mode))
a2 <- c(aggregate(formula = Cost ~ League, data = transfer.arrSub2, FUN = Mode))

a3 <- c(aggregate(formula = Cost ~ League, data = transfer.debSub, FUN = Mode))
a4 <- c(aggregate(formula = Cost ~ League, data = transfer.debSub1, FUN = Mode))
a5 <- c(aggregate(formula = Cost ~ League, data = transfer.debSub2, FUN = Mode))

transfer.mode = data.frame(f["Cost"],a["Cost"],a1["Cost"],a2["Cost"],a3["Cost"],a4["Cost"],a5["Cost"])
row.names(transfer.mode) = c("premier league","champions league","league one","league two")
colnames(transfer.mode) = c("arr&dep","arrSub","arrSub1","arrSub2","depSub","depSub1","depSub2")

transfer.all
transfer.mean
transfer.median
transfer.mode



dbClearResult(res)
dbDisconnect(con)
