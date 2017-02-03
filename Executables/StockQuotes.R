#------- getQuote() adjusted ---------

#library(quantmod)

#Since getQuote can't return the quotes from the same ticker more than
#one time I had to make adjustments

#Parameters can be adjusted but everything else is useless for my kind of work
#although it's not that hard so i might do it if someone asks.
getQuote0 <- function (tickers) {
  quotes <- data.frame(as.character(), as.character())
  colnames(quotes) <-
    c(as.character("Trade Time"), as.character("Last"))
  for (i in 1:length(tickers)) {
    quotes <- rbind (quotes, getQuote.google (tickers[i])[1:2])
  }
  return(quotes)
}

#------- getQuote.google() fix -------

#library(RJSONIO)

#Since the outdated function wasnt giving out dates correctyl, i made a quick fix to it.
getQuote.google <- function (Symbols, ...)
{
  syms <- gsub(" ", "", unlist(strsplit(Symbols, ",|;")))
  sym.string <- paste(syms, collapse = ",")
  length.of.symbols <- length(syms)
  base.url <- "http://finance.google.com/finance/info?client=ig&q="
  if (length.of.symbols > 100) {
    all.symbols <- lapply(seq(1, length.of.symbols, 100),
                          function(x)
                            na.omit(syms[x:(x + 99)]))
    df <- NULL
    cat("downloading set: ")
    for (i in 1:length(all.symbols)) {
      Sys.sleep(0.1)
      cat(i, ", ")
      df <- rbind(df, getQuote.google(all.symbols[[i]]))
    }
    cat("...done\n")
    return(df)
  }
  L <- fromJSON(gsub("^// ", "", paste(readLines(
    paste(base.url,
          sym.string, sep = "")
  ), collapse = "")))
  do.call(rbind, lapply(L, function(x) {
    data.frame(
      TradeTime = x["lt"],
      Last = as.numeric(gsub(",",
                             "", x["l"])),
      Change = as.numeric(x["c"]),
      PctChg = as.numeric(x["cp"]),
      Exchange = x["e"],
      GoogleID = x["id"],
      row.names = x["t"],
      stringsAsFactors = FALSE
    )
  }))
}

library (quantmod)
library (RJSONIO)

tickers <- c('spy','iwm','cvx','bac','eem','bmy','jpm','xlf','jnj','c','cl','wfc','xom','gdx','vz','ge','wmt','abbv','baba','ba','cvs','gd','pg','apd','t')
dfs <- list()
slpt <- 60/length(tickers) 
#Stocks update every minute, therefore I try to match it while also trying to
#reduce the chance of Yahoo treating me as DDOS attack.

for (i in 1:length(tickers)){
  df <- getQuote0(tickers[i])
  row.names(df) <- 0:(nrow(df) - 1)
  dfs[[length(dfs)+1]] <- df
  Sys.sleep(slpt)
}

tm <- proc.time()[3]
while ((proc.time()[3] - tm < 120)){ #This should be set to 23340. (6.5 hours) 
  
  for (i in 1:length(tickers)){
    df <- getQuote0(tickers[i])
    row.names(df) <- 0:(nrow(df) - 1)
    dfs[[i]] <- rbind(dfs[[i]], df)
    Sys.sleep(2.4)
  }
  
}

files <- dir(paste(substr(getwd(), 1, nchar(getwd()) -12), '/Data/Articles', sep =''))
for (fil in files){
  nam <- substr(fil, 1, nchar(fil) -4)
  ind <- which(tickers == nam)
  df <- dfs[[ind]]
  write.table(df, paste(substr(getwd(), 1, nchar(getwd()) -12), "/Data/Quotes", "/Quotes", fil, sep = ""))
}