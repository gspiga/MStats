####### STA 100 C Discussion 1 -- R Basics


### GOALS:
#  1. Become comfortable with using R as a calculator
#  2. Be able to use some basic R functions
#  3. Understand how R finds files on the computer
#  4. Reporting R homework with R appendix

### OUTSIDE RESOURCES:
#  1. Some R basics resources can be found in Canvas.
#  2. If you're unfamiliar with files/file directories on your computer, you can
#     look up tutorials online (if someone knows of a good one, let me know...)
#  3. Lots of cheatsheets online, here's one:
#     https://sites.calvin.edu/scofield/courses/m143/materials/RcmdsFromClass.pdf

##################################
# Some R basics
##################################

##### Arithmetic calculations

1+2
2^3
5+3*2
(5+3)*2
# e^2   # Doesn't work
# e^2
exp(2)  # This does

##### Object creation and modification

a <- 4 # Creates an object called "a" that contains the value 4
a

a = 4   # Equivalent
# 4 = a does not work
a <- 6
a
a+2
a <- a+2
b <- a^2
b+a

# NOTE: Not all names are valid object names.
#       - Numbers cannot start an object name (x3 OK, 3x not OK)
#       - Certain special characters cannot be anywhere in the name (!, ?, a space, etc)
# Unfortunately the error R spits out won't say you gave it a bad object name, so
#     this is just something you'll have to know to check for!

##### Vectors

#### Creating vectors (basic)

#Input vector 
thisisavector <- c(2,3,90,14) # A vector of numbers
thisisavector

alsoavector <- c("student","Instructor","TA")  # Can save other classes
# Above is characters
class(alsoavector)
testvector <- c("student", 3)
testvector
class(testvector)

logicalvector <- c(T, F, TRUE, FALSE) # A vector of booleans
logicalvector

thisisavector + 3
thisisavector*2
mean(thisisavector)
sum(thisisavector)
2+3+90+14
sd(thisisavector)

# NOTE: R is case sensitive, so t and f would be different from T and F.

#### Creating vectors that have patterns using R functions

# A function f is used with parentheses, e.g. f()
# What you give it inside the parentheses are called ARGUMENTS, i.e. its inputs are called arguments
# What the function returns after it is run is called its VALUE, sometimes people call it its output
# c() is actually a function as well, so you've already been using them!

# Now we'll use the functions `rep` and `seq`
# For a function, you can figure out what they do by calling up the help manual using ?
?rep
??rep  # This is for if ? doesn't work

# Using the manual as a reference, we now know how to use rep:

rep(1,5) #replicate 1 5 times
rep(x = 1, times = 5)
rep(c(1,2,3),times=5) #replicate the vector (1,2,3) 5 times

rep(c(1,2,3), each=5) 

rep(c(1,2,3), c(2,1,5))

# Once the arguments are named, the order they are written doesn't matter
rep(times = 5, x = 1)
rep(5,1) # Unnamed, it goes by order in the Usage section of help file

### We can use seq for a different scenario:
seq(1,10, by=2) #sequence of numbers from 1 to 10 with gap 1
seq(to = 10, by = 2) # Equivalent because default value of from is 1
seq(1,9, length = 5)
seq(1,10, length = 5)

1:10 # Quick way to do sequential integers
(-1:-10)
(-10:-1)

seq(1,2, by=0.1)

# Note that you can usually combine functions however you like

mynumbers <- seq(3,5, by = 0.5)
rep(mynumbers, 4)

rep(seq(1,2, by = 0.5), 4)

### Some useful functions

avector <- rep(c(1,2,3), c(2,1,5))
mean(avector) # Mean of a vector
sum(avector) # Sum of all the numbers in a vector
length(avector)
sum(avector)/length(avector)

var(avector) # variance
sd(avector) #standard deviation
median(avector)

summary(avector) #gives you mean, 1st 2nd and 3rd quartile, minimum and maximum

# Note: summary() is what we call a generic function; it does different things when you give it different object types/classes


##### Matrices

### how to input a matrix 
?matrix # help(matrix) does the same job
thisisamatrix <- matrix(data=c(1,2,3,4,5,6),
                        nrow=2,ncol=3, byrow=T) #byrow=FALSE is default
thisisamatrix

alsoamatrix <- matrix(data=thisisavector,nrow=2,ncol=2)
alsoamatrix

alsoamatrix[,2] #produces 2nd column of the matrix
alsoamatrix[1,] #produces 1st row
alsoamatrix[1,2] #produces element from 1st row and 2nd column

diag(1,5) #5*5 diagonal matrix with 1 as the diagonal element
diag(alsoamatrix) #extracts only the diagonal of a matrix

### Helpful commands

# Slightly different from vector case due to the dimensions

dim(thisisamatrix)
nrow(thisisamatrix)
ncol(thisisamatrix)

# Matrix operations
M1 <- thisisamatrix #a 2*3 matrix
M2 <- alsoamatrix #a 2*2 matrix
M3 <- M2+2 # adds 2 to all elements of M2
M2+M3 # term by term addition
M2*M3 #term by term multiplication
M2%*%M3 #actual matrix multiplication
M2%*%M1
diag(1,2) #2*2 diagonal matrix with 1 as the diagonal element
solve(M2,diag(1,2)) #Inverse of M2
solve(M2,M3) #postmultiply inverse of M2 by M3
solve(M2,diag(1,2))%*%M3



##### Working with data #####

# Your WORKING DIRECTORY is the folder/file path on your computer that R looks
#   for all files in, and will save to.

# To navigate through files and directories, you should use Windows Explorer on Windows,
#   or Finder app on macOS.

### You can check what your current working directory is using the function getwd()

getwd()

### You can change your working directory using setwd()
#   The argument should be a CHARACTER STRING of the filepath
#   (This just means it should be enclosed in either single or double quotes)

setwd("C:/Users/emily/Documents/papers 2022/STA 100 F22/disc/")
# The line above sets the working directory to this folder on my computer.
# Modify this to the appropriate folder on your computer. I recommend creating a new folder
#    that will have all your R stuff and set it there.
# ASIDE: Windows Explorer/Finder should be helpful in
#        finding the folder you want/creating folders/moving files into certain folders.

# If you use \ slash, you'll need two of them:
setwd("C:\\Users\\emily\\Documents\\papers 2022\\STA 100 F22\\disc")   # Equivalent


list.files() # Shows you all the file names in your working directory

## Packages/libraries

# Install packages

# install MASS package
install.packages("MASS")

# Load packages
library(MASS)

##### Data entry

#### Entering data manually

x <- c(9,9,9,7,7,7,5,5,5,3,3,3,1,1,1)
y <- c(0.07,0.09,0.08,0.16,0.17,0.21,0.49,0.58,0.53,1.22,1.15,1.07,2.84,2.57,3.10)
length(x)
length(x) == length(y)
plot(x,y)

### Reading data from a file using dropdown menus

exampledata1 <- read.table("~/papers 2022/STA 100 F22/disc/exampledata.DAT", quote="\"", comment.char="",
                            stringsAsFactors = FALSE)
xydata <- exampledata1
xydata[2,1]
xydata[4:6,1]
xydata[4:6, 1:2]
xydata[3,]
y <- xydata[,1]
x <- xydata[,2]
class(xydata)
names(xydata)
names(xydata) <- c("response", "predictor")
xydata$response
xydata$predictor
xydata$predictor

summary(xydata$response)

### Reading data from a file

xydata <- read.table("exampledata.DAT") # read.csv
xydata
xydata[2,1]
xydata[2:4,1]
xydata[2,]
y <- xydata[,1]
x <- xydata[,2]
class(xydata)
names(xydata)
names(xydata) = c("response","predictor")
xydata
xydata$response
xydata$predictor

summary(x)
summary(y)

### summary statistics for a data frame
summary(xydata)

# Scatterplot
plot(x,y)
plot(response ~ predictor, data = xydata)
plot(response ~ predictor)  # doesn't work

# Boxplot
boxplot(xydata$response)
boxplot(y)

# Grouped boxplot
boxplot(response ~ predictor, data = xydata)

## For this one, we'll use an in-built R dataset iris

# QQ-plot
qqnorm(xydata$response)

##################################
# Short R quiz
##################################

# 1. Create an object called `price_oranges` (without the quotes) that is
#     assigned the value .89
price_oranges <- .89

# 2. Create a vector with first element 3 and second element 5 and
#    assign it the name `number_oranges`
number_oranges <- c(3, 5)

# 3. Calculate the total price of purchasing 3 or 5 oranges at .89 cents per orange
#    using your answers from 1 and 2.
#    Save your answer into an object called `total_price`
total_price <- price_oranges * number_oranges

# 4. Which of the following are valid object names?
#    inv.ops
#    3machines
#    fin_Parties
#    name list

## ANS: inv.ops and fin_Parties are valid object names

# 5. How do you identify a function (vs. an object)?

## ANS: When you use a function, it needs parentheses.
## When you just call a function using its name (e.g., type mean into the console, not mean()),
#     it will also say `function` in the first line

# 6. How can you tell if you have already created an object?

## ANS: It should appear in the environment pane in the top right

# 7. Find your working directory

getwd()

# 8. Download LABprob1.txt from Canvas and put it in your working directory.
#    If you've done it correctly, the following code should run:

read.table(file = "LABprob1.txt")

###### ADDITIONAL NOTE

# You can refer to this link for how to extract all code in an R Markdown file to put in an appendix:
# https://bookdown.org/yihui/rmarkdown-cookbook/code-appendix.html
# This website is also very helpful for any other questions you have about Rmds!
