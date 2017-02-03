import pandas as pd
import os
from dateutil.parser import parse
from datetime import timedelta

def dateCnvFromArticle (dataframe):
    for i in range(len(dataframe['Dates'])):
        dataframe['Dates'][i] = parse(dataframe['Dates'][i], ignoretz = True)
    return (dataframe)

def dateCnvFromQuote (dataframe):
    for i in range(len(dataframe['TradeTime'])):
        dataframe['TradeTime'][i] = parse(dataframe['TradeTime'][i]) + timedelta(hours=5) #GMT - EST = 2hrs
    return(dataframe)

def quotesMatching (article, quotes, toffset = 0):
    resQ = pd.DataFrame()
    for i in range(len(article)):
        times = abs(quotes['TradeTime'] - (article['Dates'][i] + timedelta(minutes = toffset)))
        ind = times.idxmin(times)
        resQ = resQ.append(quotes.iloc[ind], ignore_index = True)
    return (resQ)

tickers = os.listdir(os.getcwd()[:-11] + '\Data\Articles')
dir = os.getcwd()[:-11] + '\Data\\'

for tick in tickers:
    article = pd.read_csv(dir + 'Articles\\' + tick, encoding = 'ISO-8859-1')
    article = dateCnvFromArticle(article)
    quotes = pd.read_csv(dir + 'Quotes\Quotes' + tick, sep = " ")
    quotes = dateCnvFromQuote(quotes)
    matched = quotesMatching(article, quotes)
    matched20 = quotesMatching(article, quotes, toffset = 20)
    matched60 = quotesMatching(article, quotes, toffset = 60)
    matched120 = quotesMatching(article, quotes, toffset = 120)
    results = pd.concat([article, matched, matched20, matched60, matched120], axis = 1)
    results.to_csv(dir + 'Results\Results%s' % (tick))
