######################################################
##### Homework 7 due Friday April 10 by midnight
## Please read through the whole assignment before starting it.

## For the assingment you will work with the full text of the 
## State of the Union speeches from 1790 until 2012.
## The speeches are all in the file "stateoftheunion1790-2012.txt".

## You will first read the text into R and manipulate it in order to 
## create a dataframe with information about each speech 
## (President's name, year and month, length of the speech, #sentences, #words)
## You will also create a list that contains the full text of each speech,  
## which in turn is used to create a word vector of *all* words that appear
## in *any* if the speeches - and to count their occurrances in each speech.

## You will then be able to make some comparisons of the speeches/presidents.

## The package SnowballC has a function to find the "stem" of dictionary words.
## Please install it on your computer, using: install.packages("SnowballC")
## but do NOT include that install statement in this file.
## Load the library:
library("SnowballC")

## STOP : Have you done : Session > Set Working Directory > To Source File Location ?

## We provide a function [ computeSJDistance() ] to calculate the 
## Shannon-Jensen divergence between two word vectors.
## The function is the file computeSJDistance.R, please *keep* the source
## statement in the file:
source("computeSJDistance.R")

######################################################
## Use regular expression to create: 
## [speechYr], [speechMo], [presidents]

# We start by reading the textfile into the variable [speeches] using readLines().
# Note that readLines() first argument is a connection, 
# and that you can use the R command file() to open a connection.
# Read the help for readLines() and file().
# Check the class and dimension of [speeches].  Open the textfile in 
# an editor and compare it to [speeches]

speeches <- readLines(con=file("stateoftheunion1790-2012.txt"))

# The speeches are separated by a line with three stars (***).
# Create a numeric vector [breaks] with the line numbers of ***.
# Create the variable [n.speeches] a numeric variable with the number of speeches
# Question: Does every single *** in the file indicate the beginning of a speech?

breaks <- grep("\\*\\*\\*", speeches)
breaks <- breaks[-length(breaks)]
n.speeches <- length(breaks)

# Hint : look at the file and/or your object speeches, where,
# each speech has the same format, whererelative to breaks 
# are the items we pull out next (the names, dates, etc).
    
# Use the vector [breaks] and [speeches] to create a 
# character vector [presidents]
# with the name of the president delivering the address

presidents <- speeches[breaks+3]

# Use [speeches] and the vector [breaks] to create [tempDates], 
# a character vector with the dates of each speech
# Now, using tempDates create:
# a numeric vector [speechYr] with the year of each speech, and
# a character vector [speechMo] with the month of each speech
# Note: you may need to use two lines of code to create one/both variables.
# and apply may come in handy.
    
tempDates <- speeches[breaks+4]
speechYr <- as.numeric(sapply(tempDates, function(x) substr(x, nchar(x)-3, nchar(x))))
names(speechYr) <- NULL

# Create a list variable [speechesL] which has the full text of each speech.
# The variable [speechesL] should have one element for each speech.
# Each element in [speechesL] should be a character vector, where each
# element in the vector is a character string corresponding to one sentence.

# You already have "breaks" to help index where each speech starts and stops.
    
# Note: The line breaks in the text file do not correspond to sentences so you have to
# -- pull out the text of one speech
# -- collapse all the lines of a speech into one long character string (use paste())
# -- and then split up that string on punctuation marks [.?!]
# When you use paste() pay special attention to the arguments sep and collapse,
# what do they each do?  The default is collapse=NULL, try also collapse=" ",
# how does that change the output?
    
# Use a for-loop over the number of speeches to do these two steps.
# We define speechesL as an empty list before the for-loop and in
# step i of the for-loop you assign the value of speechesL[[i]]

# Before creating [speechesL] run the following commands to remove 
# some fullstops that are not at the end of a sentence:
speeches <- gsub("Mr.", "Mr", speeches)
speeches <- gsub("Mrs.", "Mrs", speeches)
speeches <- gsub("U.S.", "US", speeches)


speechesL <- list()
breaks <- c(breaks, length(speeches)-1)
for(i in 1:n.speeches){
  str <- paste(speeches[(breaks[i]+6):(breaks[i+1]-1)], sep=" ", collapse=" ") 
  speechesL[[i]] <- unlist(strsplit(str, "[.?!]"))
}

#### Word Vectors 
# For each speech we are going to collect the following information:
# -- # of sentences
# -- # of words
# -- # of characters
# 
# We will also create a word vector for every speech.  The word vector 
# should have one entry for every word that appears in *any* speech
# and the value of the entry should be the number of times the word appears.
# The entries should be in alphabetical order.  
# Once all the word vectors are in place we will combine them into a matrix
# with one row for every word that appears and one column for every speech.
#
# Do this in a few steps:
# Write a function, [speechToWords], that takes a character vector and 
# creates a word vector of all the words in the input variable.  
# The function should have :
# Input  : sentences, a character string
# Output : words, a character vector where each element is one word 

# In other words it should take a string of text and:
# -- cut it into words
# -- remove all punctuation marks (anything in :punct:)
# -- make all characters lower case
# -- Remove the phrase "Applause." and the word "Laughter."
# -- use the function wordStem() from the package SnowballC to 
#    get the stem of each work
# -- finally, remove all empty words, i.e. strings that match "" 
#    both BEFORE running wordStem() *and* AFTER

#### The function wordStem() returns the "stem" of each word, e.g.:
#> wordStem(c("national", "nationalistic", "nation"))
#[1] "nation"      "nationalist" "nation"     

speechToWords = function(sentences) {
# Input  : sentences, a character string
# Output : words, a character vector where each element is one word 

  # Eliminate apostrophes and numbers, 
  # and turn characters to lower case.
  # <your code here>
  sen = gsub("'", "", sentences)
  sen = tolower(gsub("[0-9]+s*", "", sen))
    
  # Drop the words (Applause. and Laughter.)
  # <your code here>
  sen = gsub("\\(applause.\\)", "", sen)

  
  # Split the text up by blanks and punctuation  (hint: strsplit, unlist)
  # <your code here>
  words = unlist(strsplit(sen, "[[:punct:][:blank:]]+"))
  
  # Drop any empty words 
  # <your code here>
  words = words[words != ""]
  
  # Use wordStem() to stem the words
  # check the output from wordStem(), do you get all valid words?  any empty ("") strings?
  # <your code here>
  words = wordStem(words)
  words = words[words != ""]
  
  # return a character vector of all words in the speech
  return(words)
}


#### Apply the function speechToWords() to each speach
# Create a list, [speechWords], where each element of the list is a vector
# with the words from that speech.
speechWords <- sapply(speechesL, speechToWords)

# Unlist the variable speechWords (use unlist()) to get a list of all words in all speeches,
# then create:
# [uniqueWords] : a vector with every word that appears in the speeches in alphabetic order
uniqueWords <- sort(unique(unlist(speechWords)))

# I get 12965 unique words when I run my code - if you don't try to check that all preceeding
# steps were ok.  Keep the line below in the code, if you get a different number of
# unique words and can't figure out why, just continue with the project.
no.uniqueWords <- length(uniqueWords)
    
# Create a matrix [wordCount]
# the number of rows should be the same as the length of [uniqueWords]
# the number of columns should be the same as the number of speeches (i.e. the length of [speechesL])
# the element wordCounts[i,j] should be the number of times the word i appears in speech j

# Use the function table() to count how often each word appears in each speech
# Then you have to match up the words in the speech to the words in [uniqueWords]
# To do that use assignment/indexing and remember : 
# if counts = table(x) then names(counts) is a vector with the elements of x
# and counts a vector with the number of times each element appeared, e.g.
# > x <- c("a", "b", "a", "c", "c", "c")
# > counts <- table(x)
# > counts
# x
# a b c 
# 2 1 3 
# > names(counts)
# [1] "a" "b" "c"


# your code to create [wordMat] here:

emptyVec = rep(0, length(uniqueWords))
names(emptyVec) = uniqueWords

wordVecs = lapply(speechWords, function(x){
  counts = table(x)
  temp = emptyVec
  temp[names(counts)] = counts
  return(temp)
})
wordMat = matrix(unlist(wordVecs), ncol=length(wordVecs), byrow=FALSE)

# You may want to use an apply statment to first create a list of word vectors, one for each speech.
# Think about what you want to do for each element, maybe put that in a little function and call in an lapply statement
# wordVecs <- <your code here>

# Create a matrix out of wordVecs:

# Load the dataframe [speechesDF] which has two variables,
# president and party affiliation (make sure to keep this line in your code):

  load("speeches_dataframe.Rda")

## Now add the following variables to the  dataframe [speechesDF]:
# yr - year of the speech (numeric) (i.e. [speechYr], created above)
# month - month of the speech (numeric) (i.e. [speechMo], created above)
## Using wordVecs calculate the following 
# words - number of words in the speech (use [speechWords] to calculate)
# chars - number of letters in the speech (use [speechWords] to calculate)
# sent - number of sentences in the speech (use [speechesL] to calculate this)

words <- sapply(speechWords, length)
chars <- sapply(speechWords, function(x) sum(nchar(x)))
sentences <- sapply(speechesL, length)


# Update the data frame
speechesDF <- data.frame(speechesDF, year=speechYr, month=speechMo, sentences, words, chars)

######################################################################
## Create a matrix [presidentWordMat] 
# This matrix should have one column for each president (instead of one for each speech)
# and that colum is the sum of all the columns corresponding to speeches make by said president.

# note that your code will be a few lines...
presidentWordMat <- matrix(nrow=nrow(wordMat),ncol=length(unique(speechesDF$Pres)))
for (i in 1:length(unique(speechesDF$Pres))){
  name <- unique(speechesDF$Pres)[i]
  if (length(grep(name,speechesDF$Pres))==1){
    presidentWordMat[,i] <- wordMat[,grep(name,speechesDF$Pres)]
  }
  else{
    presidentWordMat[,i] <- apply(wordMat[,grep(name,speechesDF$Pres)],1,sum)
  }
}
rownames(presidentWordMat) <- uniqueWords
colnames(presidentWordMat) <- unique(speechesDF$Pres)
  
# At the beginning of this file we sourced in a file "computeSJDistance.R"
# It has the following function:
# computeSJDistance = (tf, df, terms, logdf = TRUE, verbose = TRUE)
# where
# terms - a character vector of all the unique words, length numTerms (i.e. uniqueWords)
# df - a numeric vector, length numTerms, number of docs that contains term (i.e. df)
# tf - a matrix, with numTerms rows and numCols cols (i.e. the word matrix)
  
# Document Frequency
# [docFreq]: vector of the same length as [uniqueWords], 
# count the number of presidents that used the word
docFreq <- c(rep(-1,nrow(presidentWordMat)))
for (i in 1:nrow(presidentWordMat)){ 
  number.of.presidents.who.used.word <- 0
  for (j in 1:ncol(presidentWordMat)){
    if (presidentWordMat[i,j]>0){
      number.of.presidents.who.used.word <- number.of.presidents.who.used.word + 1
    }
  }
  docFreq[i] <- number.of.presidents.who.used.word
}
    
# Call the function computeSJDistance() with the arguments
# presidentWordMat, docFreq and uniqueWords
# and save the return value in the matrix [presDist]
presDist <- computeSJDistance(tf=presidentWordMat, df=docFreq, terms=uniqueWords)

## Visuzlise the distance matrix using multidimensional scaling.
# Call the function cmdscale() with presDist as input.
# Store the result in the variable [mds] by 
mds <- cmdscale(presDist)

# First do a simple plot the results:
plot(mds)

# Customize this plot by:
# -- remove x and y labels and put the title "Presidents" on the plot
# -- color the observations by party affiliation 
# -- using the presidents name as a plotting symbol

# Create a variable presParty, a vector of length 41 where each element
# is the party affiliation and the names attribute has the names of the presidents.
# Hint: the info is in speechesDF$party and speechesDF$Pres
presParty <- tapply(speechesDF$party, speechesDF$Pres, function(x) x[1])
  
# use rainbow() to pick one unique color for each party (there are 6 parties)
cols <- rainbow(length(unique(speechesDF$party)))

# Now we are ready to plot again.
# First plot mds by calling plot() with type='n' (it will create the axes but not plot the points)
# you set the title and axes labels in the call to plot()
# then call text() with the presidents' names as labels and the color argument
# col = cols[presParty[rownames(presDist)]]
rownames(presDist) <- names(presParty)
plot(mds,type="n",ylab="",xlab="",main="Presidents")
text(x=mds[,1],y=mds[,2],labels=names(presParty),col = cols[presParty[rownames(presDist)]])

### Use hierarchical clustering to produce a visualization of  the results.
# Compare the two plots.
hc = hclust(as.dist(presDist))
plot(hc)

## Final part 
# Use the data in the dataframe speechesDF to create the plots:
# x-axis: speech year, y-axis: # of sentences
# x-axis: speech year, y-axis: # of words
# x-axis: speech year, y-axis: # of characters
# x-axis: speech year, y-axis: average word length (char/word)
# x-axis: speech year, y-axis: average sentence length (word/sent)

# your plot statements below:

plot(speechesDF$year, speechesDF$sent, xlab="Year", ylab="#sentences")
plot(speechesDF$year, speechesDF$word, xlab="Year", ylab="#words")
plot(speechesDF$year, speechesDF$char, xlab="Year", ylab="#characters")
plot(speechesDF$year, speechesDF$char/speechesDF$word, xlab="Year", ylab="ave word length")
plot(speechesDF$year, speechesDF$word/speechesDF$sent, xlab="Year", ylab="ave sentence length")










