library(shiny)

print(getwd())
# "print" comments were scaffolding for debugging the application
data.maker <- function(data, y, x) {
#   print("Line 6")
#   print(y)
  if(is.null(y)) res1=data[, 1] else res1=data[, y]
#   print(res1)
  if(is.null(x)) regr1=data[, 6] else regr1=data[, x]
#   print(x)
#   print("Line 12")
  x2 <<- regr1^2
  x3 <<- regr1^3
  sqrtx <<- sapply(regr1, function(x) {if(x > 0) sqrt(x) else 0})
  logx <<- sapply(regr1, function(x) {if(x > 0) log(x) else -100})
  expx <<- exp(regr1)
  data.frame(x=regr1,x2=x2,x3=x3,sqrtx=sqrtx,logx=logx,expx=expx,y=res1)
}

shinyServer(function(input, output) {
  mydata <- reactive({
    
#     print("Line 24. First line after mydata <- reactive ")
    # Define the data set and its columns
    # If missing input, return to avoid error later in function
    if(is.null(input$dataset))
      return()
#     print("Line 29")
    dat <<- get(input$dataset)
#    print(dat)
#     print("Line 32")
    columns <<- colnames(dat)
#     print(columns)
    # Make sure columns are correct for data set (when data set changes, the
    # columns will initially be for the previous data set)
    if (is.null(columns) || !(columns %in% names(dat)))
      return()

#     print("Line 40. Before selecting input$result ")
    res <<- input$result
#     print(res)
#     
#     print("Line 44")
    # Make sure result is correct for data set (when data set changes, the
    # result will initially be for the previous data set)
    if (is.null(input$regressors) || !(input$regressors %in% names(dat)))
      return()
    
    regr <<- input$regressors
#     print(regr)
#     print("Line 52. Just before data.maker ")
    data.maker(data=dat, y=res, x=regr)
  })
  
  # Pick the resulting variable
  output$choose_result <- renderUI({
#     print("Line 58. Within choose_result")
    dat <<- get(input$dataset)
#     print("Line 60. Within choose_result")
    # Make sure columns are correct for data set (when data set changes, the
    # columns will initially be for the previous data set)
    columns <<- colnames(dat)
#     print(columns)
    if (is.null(columns) || !(columns %in% names(dat)))
      return()
#     print("Line 67. Within choose_result")
    selectInput("result","Pick resulting variable",
                as.list(columns),
                selected=columns[1])
  })
  
  # Select the required regressors (Check boxes)
  output$choose_regressors <- renderUI({
#     print("Line 75")
    dat <<- get(input$dataset)
#     print("Line 77. Within choose_regressors ")
    columns <<- colnames(dat)
    # Make sure columns are correct for data set (when data set changes, the
    # columns will initially be for the previous data set)
    if (is.null(columns) || !(columns %in% names(dat)))
      return()
#     print("Line 83")
    # Create the checkboxes and select the default regressor
    radioButtons("regressors", "Choose regressors", 
                       choices  = columns,
                       selected = columns[6])
  })
  
  output$values <- renderTable({
#       print("Line 91. Within output$values")
      mydata()
  })

  lmResults <- reactive({
#     print("Line 96. Within lmResults")
    
    regress.exp <<- input$regression
    if (!input$constant) regress.exp <- paste(input$regression, "- 1")

#     print("Line 101. Before lm(...")
#     print(regress.exp)
#    print(mydata())
    lm(regress.exp, data=mydata())
  })

  output$lmStats <- renderTable({
    
    # Make sure result is correct for data set (when data set changes, the
    # result will initially be for the previous data set)
    if (is.null(input$result) || !(input$result %in% names(dat)))
      return()
#     print("Line 113. Before results <- summary(lmResults())")
    
    results <<- summary(lmResults())
    data.frame(R2=results$r.squared,
               adj.R2=results$adj.r.squared,
               DOF.model=results$df[1],
               DOF.available=results$df[2],
               DOF.total=sum(results$df[1:2]),
               f.value=results$fstatistic[1],
               f.denom=results$fstatistic[2],
               f.numer=results$fstatistic[3],
               p=1-pf(results$fstatistic[1],
                      results$fstatistic[2],
                      results$fstatistic[3]))
  })


  # Show coefficients
  output$lmResults <- renderTable({
    
    # Make sure result is correct for data set (when data set changes, the
    # result will initially be for the previous data set)
    if (is.null(input$result) || !(input$result %in% names(dat)))
      return()
#     print("Line 137. Before summary(lmResults())")
    
    summary(lmResults())
  })

  # Show plot of points, regression line, residuals
  output$scatter <- renderPlot({
#     print("Line 144. Beginning scatterPlot")
# print(mydata())     
    data1 <<- mydata()
if(length(data1) > 0){
#     print("Line 148")
#     print(data1$x)
    x <<- data1$x
#     print("Line 151")
#     print(data1$y)
    y <<- data1$y
#     print("Line 154")
    xcon <- seq(min(x)-.1, max(x)+.1, .025)
    x2 <<- xcon^2
    x3 <<- xcon^3
    sqrtx <<- sapply(xcon, function(x) {if(x > 0) sqrt(x) else 0})
    logx <<- sapply(xcon, function(x) {if(x > 0) log(x) else -100})
    expx <<- exp(xcon)

    predictor <<- data.frame(x=xcon,x2=x2,x3=x3,sqrtx=sqrtx,logx=logx,expx=expx)
    yhat <<- predict(lmResults())
    yline <<- predict(lmResults(), predictor)
    plot(c(min(x),max(x))
         ,c(min(y,yline),max(y,yline)),
         type="n",
         xlab=as.character(input$regressors),
         ylab=as.character(input$result),
         main=paste0("Regression Model: ", input$regression))

    if (input$predict) lines(xcon, yline, lwd=15, col=grey(.9))
    if (input$resid) for (j in 1:length(x))
      lines(rep(x[j],2), c(yhat[j],y[j]), col="red")
    if (input$showdata) points(x,y)
    if (input$predict) lines(xcon, yline, lwd=2, col="blue")
}

  })
})
