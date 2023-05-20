# plumber.R
# author: Iraitz Montalban
# date: May, 2023

# Execution:
# > library(plumber)
# > r<-plumb("plumber_async.R")$run(port=9999)

library(plumber)
library(stringr)

#* @get /random_numbers
#* @param maxn
function(maxn) {
  maxn<-as.numeric(maxn)
  runif(1,min=0,max=maxn)
}

# Example call:
# curl http://127.0.0.1:9999/random_numbers?maxn=5

#* @post /operation
#* @param numbers vector of numbers
#* @param metric
function(numbers, metric) {
  if(metric == 'mean')
    mean(numbers)
  else if(metric == 'sd')
    sd(numbers)
  else if(metric == 'min')
    min(numbers)
  else if(metric == 'max')
    max(numbers)
  else
    "Wrong metric! use mean, sd, min or max"
}

# Example call:
# curl -X POST \
# -H "Content-Type: application/json" \
# -d '{"numbers":[1,3,5,12,30,3,100],"metric":"mean"}' \
# http://localhost:9999/operation 

#* @get /data
function(mean, sd) {
  data.frame(x=seq(10), letters=letters[1:10])
}
#* @get /data_csv
#* @serializer csv
function(mean, sd) {
  data.frame(x=seq(10), letters=letters[1:10])
}

# Example call:
# curl -X GET http://localhost:9999/data
# curl -X GET http://localhost:9999/data_csv


