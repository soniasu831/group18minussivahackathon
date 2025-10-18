#' @name spcTest
#' @param averages a vector of subgroup average values
#' @param sigma the standard deviation of the averages
#' @description output whether or not the average data inputted passes 
#' each test, TRUE = pass, FALSE = fail
spcTest = function(averages, sigma){
  
# initialize output
  output = tibble(
    test2 = NA,
    test3 = NA,
    test4 = NA,
    test5 = NA,
    test6 = NA,
    test7 = NA,
    test8 = NA
  )
  
  #' @name window
  #' @param data a vector of booleans
  #' @param len the window size
  #' @description outputs the number of TRUEs within each window
  window = function(data, len){
    output = c()

    if (len < length(data)){
      # look through data in windows of length len
      for (i in 1:(length(data)-(len-1))){
        temp = sum(data[i:(i+(len-1))])
        output = append(output, temp)
      }
    }else {
      output = NA
    }

    return(output)
  }

  # test 2 #################

  xbbar = mean(averages)

  greater_than_2s = averages > (xbbar + sigma*2)
  less_than_2s = averages < (xbbar - sigma*2)

  # count the number of times there are at least 2 values within a 
  # window of length 3 that are greater than 2s or less than 2s from 
  # the centerline
  test2 = sum(window(greater_than_2s, 3) >= 2) + sum(window(less_than_2s, 3) >= 2)

  # update output vector
  if(!is.na(test2)){
    if (sum(test2) == 0){
      output$test2 = TRUE
    } else if (sum(test2) >= 1){
      output$test2 = FALSE
    }
  }

  # test 3 #################

  greater_than_1s = averages > (xbbar + sigma)
  less_than_1s = averages < (xbbar - sigma)

  # count the number of times there are at least 4 values within a window 
  # of length 5 that are greater than 1s or less than 1s from the centerline
  test3 = sum(window(greater_than_1s, 5) >= 4) + sum(window(less_than_1s, 5) >= 4)

  # update output vector
  if(!is.na(test3)){
    if (sum(test3) == 0){
      output$test3 = TRUE
    } else if (sum(test3) >= 1){
      output$test3 = FALSE
    }
  }

  # test 4 #################

  greater_than_c = averages > xbbar
  less_than_c = averages < xbbar

  # count the number of times there are at least 8 values within a window 
  # of length 8 that are greater than or less than the centerline
  test4 = sum(window(greater_than_c, 8) >= 8) + 
    sum(window(less_than_c, 8) >= 8)

  # update output vector
  if(!is.na(test4)){
    if (sum(test4) == 0){
      output$test4 = TRUE
    } else if (sum(test4) >= 1){
      output$test4 = FALSE
    }
  }

  # test 5 #################

  # evaluate whether the next point is greater than or less than the previous
  increasing = averages[-length(averages)] < averages[-1]
  decreasing = averages[-length(averages)] > averages[-1]

  # count the number of times there are at least 6 values within a window 
  # of length 6 that are increasing or decreasing
  # since increasing or decreasing is a difference, we look for >=5 
  # consequtive values
  test5 = sum(window(increasing, 5) >= 5) + sum(window(decreasing, 5) >= 5)

  # update output vector
  if(!is.na(test5)){
    if (sum(test5) == 0){
      output$test5 = TRUE
    } else if (sum(test5) >= 1){
      output$test5 = FALSE
    }
  }

  # test 6 #################

  # evaluate whether each point is within 1s
  within_1s = c()
  for (i in 1:length(averages)){
    point = averages[i]
    # if the point is above the centerline
    if (point > xbbar){
      # if the point is within 1s
      if (point < (xbbar + sigma)){ 
        within_1s = append(within_1s, TRUE)
      } else{
        within_1s = append(within_1s, FALSE)
      }
    } else{ # below the centerline
      # if the point is within 1s
      if (point > (xbbar - sigma)){ 
        within_1s = append(within_1s, TRUE)
      } else{
        within_1s = append(within_1s, FALSE)
      }
    }
  }
    
  # count the number of times there are at least 15 values within a window 
  # of length 15 that are within 1s of the centerline
  test6 = sum(window(within_1s, 15) >= 15)

  # update output vector
  if(!is.na(test6)){
    if (sum(test6) == 0){
      output$test6 = TRUE
    } else if (sum(test6) >= 1){
      output$test6 = FALSE
    }
  }

  # test 7 #################

  # evaluate whether each point is outside 1s
  outside_1s = c()
  for (i in 1:length(averages)){
    point = averages[i]
    # if the point is above the centerline
    if (point > xbbar){
      # if the point is outside 1s
      if (point > (xbbar + sigma)){ 
        outside_1s = append(outside_1s, TRUE)
      } else{
        outside_1s = append(outside_1s, FALSE)
      }
    } else{ # below the centerline
      # if the point is outside 1s
      if (point < (xbbar - sigma)){ 
        outside_1s = append(outside_1s, TRUE)
      } else{
        outside_1s = append(outside_1s, FALSE)
      }
    }
  }

  # count the number of times there are at least 8 values within a window 
  # of length 8 that are within 1s of the centerline
  test7 = sum(window(outside_1s, 8) >= 8)

  # update output vector
  if(!is.na(test7)){
    if (sum(test7) == 0){
      output$test7 = TRUE
    } else if (sum(test7) >= 1){
      output$test7 = FALSE
    }
  }

  # test 8 #################

  # evaluate whether the previous point is on the opposide side of the 
  # centerline
  # 0 means didn't cross the centerline 
  # 2 means going from above centerline to below centerline
  # -2 means going from below centerline to above centerline
  changedsign = (sign(averages[-length(averages)] - xbbar)) - 
    (sign(averages[-1] - xbbar))

  # count the number of times there are at least 14 values within a window 
  # of length 14 that are alternating above and below the centerline
  test8 = sum(window(changedsign != 0, 8) >= 8)

  # update output vector
  if(!is.na(test8)){
    if (sum(test8) == 0){
      output$test8 = TRUE
    } else if (sum(test8) >= 1){
      output$test8 = FALSE
    }
  }

  return(output)
}