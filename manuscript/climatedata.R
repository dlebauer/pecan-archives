 
data <- read.csv('climatedata.csv', skip = 1)
means <- data[data$Month == 'Total',]
MAP <- mean(means$Precipitation) * 25.4 # X in * 25.4 = Y mm
MAT <- (mean(means$Mean) - 32) * 5/9    # X (F - 32) * 5/9
