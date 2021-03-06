source("R/dbInterface.R")

#' @export
showBallance <- function(symbols = NULL, showOpen = TRUE, showClosed = FALSE)
{
  cTotal <- 0
  oTotal <- 0

  if(is.null(symbols))
  {
    symbols <- getWallet()
  }

  for(symbol in symbols)
  {
    pos <- getPositions(symbol)

    for(p in pos)
    {
      state <- NULL

      if(showOpen && is.na(p$closeVal))
      {
        price <- p$openVal * p$size
        size <- p$size
        value <- lastPrice(symbol) * size
        proffit <- value - price
        state <- "open"
        oTotal <- oTotal + proffit
      }

      if(showClosed && !is.na(p$closeVal))
      {
        price <- p$openVal * p$size
        size <- p$size
        value <- p$closeVal * size
        proffit <- value - price
        state <- "closed"
        cTotal <- cTotal + proffit
      }

      if(!is.null(state))
      {
        print(paste(symbol, state, size, price, value, proffit))
      }
    }
  }

  if(showOpen && showClosed)
  {
    print(paste("Closed:", cTotal, "Open:", oTotal, "Total:", cTotal+oTotal))
  }
  else if(showOpen)
  {
    print(paste("Open:", oTotal))
  }
  else if(showClosed)
  {
    print(paste("Closed:", cTotal))
  }
}
