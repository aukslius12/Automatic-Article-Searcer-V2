# Automatic-Article-Searcer-V2
This was a script, running on a remote tablet with linux installed on it via ssh.

The goal of this script was to:

 * scrape in real time
  1) _every single article_ that came from 7 different sources of online newspapers, writing about S&P 500 stocks;
  2) minute interval stock price changes on all of the S&P 500 stocks. Back at the time, I couldn't find minute interval data of those stocks.
 * process the data from raw HTML into a single data frame, containing:
  1) article text (processed), source, link, etc.
  2) stock price and volatility changes over time, starting at the time of the release of the related article.

_Did anything good came out of this money-wise?_ No, because teams with PHD's already make money out of this algorithm with insane high-speed computation and 0 latency internet connections. 
Quants at my local bank (I asked to meet them during my internship) said that it works, but it's expensive to make (time and skill required wise) and profits are small
