#################################################################
# Statistics 133, Lecture 2, Spring 2015
# Final Exam, Monday May 11th, 11:30 am - 14:30 pm

# Please read all instructions carefully.
#################################################################
# IMPORTANT
# Enter your personal information here, between the quotation marks:
name <- "Qiyin Wu"
github.name <- "Joranson"
email.address <- "joranson.wu@berkeley.edu"

#################################################################
# The exam has a total of 100 points and for each task 
# the point is given in square brackets.
# The exam has 6 parts and the total number of points by part is:
# 15 pts : Part I, general R commands
# 20 pts : Part II, plotting
# 15 pts : Part III, apply and by statements
# 15 pts : Part IV, functions 
# 15 pts : Part V, simulations
# 20 pts : Part VI, string manipulation and regular expressions
#100 pts in Total

# If you spend about 30 min or so reading instructions and the like
# this gives you 1.5 min per point -- the exam is LONG ON PURPOSE!
# Please just work your way through it the best you can, prioritizing
# things you can easily do and remember everyone else is also
# racing the clock and will be graded on a curve.

#################################################################
# DO NOT manually set the path anywhere in this script, instead:

# RIGHT NOW!!   In the RStudio menu select:
# Session > Set Working Directory > To Source File Location

# NOTE!
# All "load" statements are included in the file already,
# DO NOT change them in any way or add a path to them,
# it will prevent us from being able to run your script.

# NOTE!
# There are a few calls to the function set.seed()
# DO NOT change these in any way.

#################################################################

#### PART I : General R commands [15 pts]

# [1 pt]
# Create [x], a numeric vector of length 1200 with 
# entries: 3, 6, 9, 12, etc
x <- 1:1200*3

  
# [2 pts]
# Create [y], a list of length 10 where list k
# stores the output of the k-times multiplication
# table, including values up to 1000 so
# y[[1]] is 1, 2, 3, ..., 1000
# y[[2]] is 2, 4, 6, ..., 1000
# y[[3]] is 3, 6, 9, ..., 999

y <- list()
for (i in 1:10) {
  time = 1000%/% i
  y[[i]] = 1:time * i
}


# [1 pt]
# Create [z], a logical vector of length 5000 with entries
# TRUE and FALSE, where each value has
#  a probability 0.3 of being TRUE and 0.7 of being FALSE
# Hint: you can e.g. use [sample()], you will need to set all 4 arguments
set.seed(42)
z <- sample(c(TRUE, FALSE), 5000, T, c(0.3, 0.7))
  
  
# [1 pt]
# Create [v], a numeric vector with the results of 100 rolls of a dice,
# i.e. each element is one of the numbers 1 through 6, with equal probability.
  set.seed(31415)
v <- sample(1:6, 100, T)


# [1 pt]
# Create [w], a character vector of length 26 with entries:
# "aa", "ab", "ac", "ad", ..., "az"
# Hint: the variable [letters] is an inbuilt constant in R 
# and stores the alphabet (try typing letters)
set.seed(2718)
w <- paste("a", letters, sep="")

  
# [1 pt]
# Create [m], a matrix of size 10x10 with entries that are 
# Normal random variables (hint: rnorm) with mean 8
# (arrange the values by column, as per default)
set.seed(344)
m <- matrix(rnorm(100, mean=8), nrow=10)

  
# For the next few tasks you will use the data frame ChickWeight
# This data frame comes with R so you do not need to load any data.
# To get the size of the data frame type
# dim(ChickWeight)
# To see the first few lines type
# head(ChickWeight)
# There are 4 variables in the dataframe:
# > names(ChickWeight)
# [1] "weight" "Time"   "Chick"  "Diet"  

# [1 pt]
# Create [cw1] a subset of ChickWeight with Chicks on 
# Diet 1 at time 0
cw1 <- ChickWeight[ChickWeight$Diet==1 & ChickWeight$Time==0,]

  
# [1 pt]
# Create [cw2] a subset of ChickWeight with only Chicks that
# weighed more than 41 at Time 0
cw2 <- ChickWeight[ChickWeight$weight>41 & ChickWeight$Time==0,]

  
# [1 pt]
# Create [cw3] a single number, the average chick weight at time 0
cw3 <- mean(ChickWeight[ChickWeight$Time==0,]$weight)
  

# [1 pt]
# Create [cw4] a random subset of 200 ChickWeight observations (any 200)
cw4 <- ChickWeight[sample(1:dim(ChickWeight)[1], 200, F),]
  

# for the next two tasks you will use the data frame infants (size 1236x15)
# LEAVE AS IS:
load("KaiserBabies.rda") 

# [1 pt]
# Create a table [t1] of the smoking history of the mothers using the variables
# [smoke] for the rows of the table and  [number] for the columns.
# 
t1 <- table(infants$number,infants$smoke)


# [1 pt] 
# Now create a table [t2] which is the same table as before except restricted
# to mothers with College education (use [ed])
# 
t2 <- table(infants[infants$ed=="College",]$number,infants[infants$ed=="College",]$smoke)


# [2 pts] 
# Calculate [bdiff], the difference in average birthweight [column bwt] between babies born to mothers
# that are 35 years or older and mothers that are under 35 years of age [use column age for mothers age]
#  
bdiff <- mean(infants[infants$age>=35,]$bwt, na.rm=T)-mean(infants[infants$age<35,]$bwt, na.rm=T)

#################################################################
#### PART II : Plotting [20 pts]

##### Cars [8 pts total, 2+3+3]
# We will now use the dataset "mtcars" which is icluded in the R package.
# To look at the dataframe you can just type "mtcars" at the prompt
# It is a data frame of size 32x12

# [2 pts]
# Make a box plot of [mpg] by [cyl] (so 3 boxplots in one plot)
boxplot(mtcars$mpg ~ mtcars$cyl)

# [3 pts]
# Use the function [lm()] to fit a regression model of [qsec] (1/4 mile time) regressed on [hp] (horsepower)
# Make a scatterplot of [qsec] versus [hp] and add the regression line to it
# Hint: the regression coefficients are stored in [coef] in the lm object and you can use [abline()] to
# add a line to a plot
plot(mtcars$hp, mtcars$qsec)
model = lm(mtcars$qsec~mtcars$hp)
abline(model$coef)

# [3 pt]
# Make a scatterplot of [disp] (on y-axis) versus [wt] 
# where disp is the engine displacement in cu. in. and wt is the weight of the car in lb/1000.
# Color the plotting symbol by [am] (automatic or manual) (any 2 colors)
# Edit the labels on the x-axis and y-axis to state what the variables are.
# Hint: first do the plot without adding the colors.
plot(x=mtcars$wt, y=mtcars$disp, col=mtcars$am+1, new=T,xlab="weight of the car in lb/1000", ylab=" engine displacement in cu. in.")
##### We will now use the World Bank Data [12 pts]
load("WorldBank.RData")

# [4 pts]
# Make a scatterplot of life expectancy ["life.expectancy"] vs. fertility ["fertility.rate"]
# The plotting symbol should be a small dot (.)
# Please color the symbols by region (pick any color for each region)
# You do _NOT_ need to add a legend saying which color is which region.
# Put on custom made x-axis and y-axis labels that fully describe the variables
# Add a vertical line at fertility=2.1 (the rate needed to maintain constant population size)
plot(x=WorldBank$fertility.rate, y=WorldBank$life.expectancy, pch=".", col=as.numeric(WorldBank$region), xlab="fertility rate", ylab="life expectancy")
abline(v=2.1)
# [4 pts]
# Do you see patterns in the plot?  You just plotted these variables for all years between 1960 and 2014.
# Please redo the plot, but this time put two plots side by side (hint: before plotting set par(mfrow=...) )
# The left plot should include only data from 1960, the right one only from 2013.
par(mfrow = c(1,2))
data.1960 = WorldBank[WorldBank$year==1960,]
data.2013 = WorldBank[WorldBank$year==2013,]
plot(x=data.1960$fertility.rate, y=data.1960$life.expectancy, col=as.numeric(WorldBank$region), xlab="fertility rate (1960)", ylab="life expectancy (1960)")
plot(x=data.2013$fertility.rate, y=data.2013$life.expectancy, col=as.numeric(WorldBank$region), xlab="fertility rate (2013)", ylab="life expectancy (2013)")

# [4 pts]
# Make a histogram of GDP only for observations where the lending rating is "IDA"
# The width of the bars should be approximately 250 (use breaks to set how many bars)
# Add an x-axis label and a title.
par(mfrow = c(1,1))
hist(WorldBank[WorldBank$lending=="IDA",]$GDP, breaks=max(WorldBank[WorldBank$lending=="IDA",]$GDP, na.rm=T)%/%250, main="GDP of Country with Lending Rate 'IDA'", xlab="GDP in USD")

#################################################################
##### PART III : apply statements [15 pts]

# For the next few tasks you will use the list rain
# (list of length 5, each element is a numeric vector of various lengths)
# LEAVE AS IS:
load("rainfallCO.rda")

# [2 pts]
# Create [max.rain], a vector where each entry is the _maximum_ element of the
# corresponding vector in the list rain

max.rain <- sapply(rain, function(x) max(x, na.rm=T))

    
# [5 pts]
# Create [max.diff.rain], a vector of length 5 where each entry is the 
# __maximum absolute difference__ in rainfall on two consecutive days
# Hint: you can use the function [diff()] to get the difference between entry i and i+1 in a vector 
# and the function [abs()] for absolute value
max.diff.rain <- sapply(rain, function(x) max(abs(diff(x))))


# [5 pts]
# Create [prop.rain], a vector of length 5 where each entry is the 
# number of rain days (i.e. rain > 0) as a fraction of total days
adding <- function(x) {
  num = 0
  for (i in 1:length(x)) {
    if (x[i]>0) {
      num=num+1
    }
  }
  return(num/length(x))
}
prop.rain <- sapply(rain, adding)
  

# [3 pts]
# Make a plot with 6 panels and plot the histogram of the rainfall for each weather station
# in a separate panel (there will be one empty panel)
# use an apply statment to the the plotting
par(mfrow=c(2,3))
sapply(rain, function(x){hist(x)})

#################################################################
##### PART IV : functions [20 pts]

# [6 pts]
# Write a function, [GenNorm()] which generates a vector of random normal
# plots a histogram, if desired.
# Input :
#   mean (the mean of the normal), default 0
#   sd (the standard deviation), default 1
#   n (the number of observations), default 1000
#   plot.hist (a logical variable, should we plot a histogram), default TRUE
# Output: 
#   a vector of n normal random variables with mean=mean and sd=sd
#   an optional plot
par(mfrow=c(1,1))
GenNorm <- function(mean=0, sd=1, n=1000, plot.hist=TRUE) {
  vector = rnorm(n, mean=mean, sd=sd)
  if (plot.hist) {
    hist(vector)
  }
  return (vector)
}


# [6 pts]
# Write a function [standardizeVar] with
# Input :
#     [m] : a numeric matrix
#     [cols] : TRUE or FALSE (default TRUE)
# Output :
#     a matrix of the same size as [m] where if cols==TRUE the columns have been standardized
#     and if cols==FALSE the rows have been standardized
#     we standardize by subtracting the mean of the column/row and dividing by the sd of the column/row


standardizeVar <- function(m, cols=TRUE){
  r = dim(m)[1]
  c = dim(m)[2]
  newm = matrix(1:(r*c), nrow=r)
  if (cols) {
    for (i in 1:c) {
      newm[1:r,i] = (m[1:r,i]-mean(m[1:r,i]))/sd(m[1:r,i])
    }
  } else {
    for (j in 1:r) {
      newm[j,1:c] = (m[j,1:c]-mean(m[j,1:c]))/sd(m[j,1:c])
    }
  }
  return (newm)
}


# [8 pts]
# Write a function [PermDiff()] that takes
# Inputs
#    [cases] : a numeric vector 
#    [controls] : a numeric vector 
#    [k] : a scalar, the number of permutations, default=5000

#    Assume that [cases] was of length kk and [controls] of length m
#    Now select at random kk individuals from the whole sample (i.e. all kk+m observations)
#    and assign them to be cases, and the remaining m individuals as controls
#    Calculate the value [mean(cases)-mean(controls)] for each of these new samples

# Output
#    A vector of length k where each element is the value 
#    mean(cases)-mean(controls) for one permutation



PermDiff <- function(cases, controls, k=5000){
  kk = length(cases)
  m = length(controls)
  tot = 1:(m+kk)
  for (i in 1:kk) {
    tot[i] = cases[i]
  }
  for (j in 1:m) {
    tot[kk+j] = controls[j]
  }
  result= 1:k
  for (i in 1:k) {
    indexes = sample(1:(kk+m), size=kk, replace=F)
    cases = tot[indexes]
    controls = tot[-indexes]
    result[i] = mean(cases)-mean(controls)
  }
  return(result)
}



#################################################################
##### PART V : simulations [15 pts]

# leave this here:
set.seed(123456)

# Simulate a simplified lottery and return the number of people who share the
# jackpot.

# Setup:
# Each player can pick 3 numbers from the numbers 1 through 19 (no duplicates)
# There are [k] players that buy a ticket.
# All player with the winning numbers share the jackpot

# Write a function NumJackpot with:

# Input
#    k : number of players
#    B : number of lottery games

# Output:
#    n.jackpot : vector of length B where each entry is the number of people
#                who shared the jackpot in that game

# So in each of the B games you have to :
#    generate the winning numbers
#    set a counter for jackpot winners to 0
#    generate a ticket for each player in turn, if they had the winning numbers 
#    increase the counter by 1

NumJackpot <- function(k, B){
  n.jackpot = 1:B
  for (i in 1:B) {
    winnum = sort(sample(1:19, size=3, replace=F))
    counter = 0
    for (j in 1:k) {
      tickets = sort(sample(1:19, size=3, replace=F))
      if (all(tickets==winnum)) {
        counter = counter+1
      }
    }
    n.jackpot[i] = counter
  }
  return(n.jackpot)
}

# For B = 1000 and each value of k = 100, 500, 1000, 5000
# Plot a histogram of the output from NumJackpot (i.e. four histograms)

par(mfrow = c(2,2))
hist(NumJackpot(100, 50))
hist(NumJackpot(500, 50))
hist(NumJackpot(1000, 50))
hist(NumJackpot(500, 50))


#################################################################
##### PART VI : string manipulation and regular expressions [20 pts]

phrases <- c("stone", "steel", "sled", "Star", "silly", "cat", "dog", "catcat", "why?", "really!", "how much?", "atatat", "bar", "car")

# [2 pts]
# Create a vector [text1] that lists the elements in phrases that start
# with "st" (case doesn't matter)
text1 <- grep("\\<[Ss][Tt]", phrases)


# [1 pt]
# Create a vector [text2] that lists the elements in phrases that have 
# a match to "ar", _at the end of the phrase_ 
text2 <- grep("ar\\>", phrases)


# [2 pts]
# Create a vector [text3] that lists the elements in phrases that have 
# a match to any multiple of "ta"
text3 <- grep(".+((ta){1,}).+",phrases)

# [2 pts]
# Create a vector [text4] that has the first 3 characters of each element in phrases

text4 <- sapply(phrases, FUN=function(x){substr(x, 1,3)})
names(text4)=NULL


# [2 pts]
# Create a vector [text5] that has all the elements in phrases that have a punctuation mark 
text5 <- grep("[[:punct:]]", phrases)


# [2 pts]
# Create a vector [phrases2] where you have replaced the first instance of the letter "a" in each word with "@"
phrases2 <- sapply(phrases, function(x){sub("a", "@", x)})
names(phrases2)=NULL


# [2 pts]
dna <- c("AGGATGATT", "AGCCTTAGC", "AGAGAGCT", "AGTTTCGTA", "CGTGGTGC", "CTAAGTGAC", "GTGGGACC", "GGTAGAGAC", "TAGATTACC")
# Create a vector [match1] with the index for all matches to "A*T" or "G*T"
match1 <- grep("(A*T)|(G*T)", dna)

# [2 pts]
# Create a vector [dna2] where you have removed all entries whose length is not a multiple of 3
check3 <- function(y) {
  x=character()
  counter = 0
  size = length(y)
  for (i in 1:size) {
    if (nchar(y[i])%%3==0) {
      counter=counter+1
      x[counter]=y[i]
    }
  }
  return(x)
}
dna2 <- check3(dna)
#################################################################

