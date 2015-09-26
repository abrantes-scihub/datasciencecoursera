library(shiny)

# Define UI for regression models demo application
shinyUI(pageWithSidebar(

  #  Application title
  headerPanel("Linear Regression Models"),

  sidebarPanel(
    tags$h3("Define Data Set"),
    selectInput("dataset", "Select data set:",
                list("mtcars", 
                     "swiss"),
                selected="mtcars"
                ),
    br(),
    uiOutput("choose_result"),
    
    uiOutput("choose_regressors"),
    br(),

    h3("Define model"),

    selectInput("regression", "Define regression model:",
                list("y~x", 
                     "y~x2",
                     "y~x3",
                     "y~sqrtx",
                     "y~logx",                   
                     "y~expx",
                     "y~x+x2",
                     "y~x+sqrtx",
                     "y~x+logx",
                     "y~x+expx",
                     "y~sqrtx+logx",
                     "y~x+x2+expx",
                     "y~x+sqrtx+logx"
                )),

    checkboxInput("constant", "Include Constant", TRUE),

    h5("Plot"),
    checkboxInput("showdata", "Show Data Points", TRUE),
    checkboxInput("predict", "Show Predicted Values", TRUE),
    checkboxInput("resid", "Show Residuals", FALSE),
    tags$br()
  ),

  # Show the main display
  mainPanel(
    tabsetPanel(
      tabPanel("Documentation",  # load MathJax library so LaTeX can be used for math equations
               withMathJax(), 
               h3("Regression models applied to datasets"), # paragraph and bold text
               p("Several ", strong("linear regression models")," can be calculated for ", strong(em("two")),
                 " different datasets:", strong("mtcars or swiss.") ),
               p("The layout of the application contains one sidebarPanel, and two tabPanels: 
                 Documentation and Application."), 
               p("The ", 
                 strong("Documentation tabPanel "), 
                 "contains the information you are reading just now, whereas the ", 
                 strong("Application tabPanel "), 
                 "displays the plot of the regression and statistical tables with the results of the regression."),
               # break used to space sections
               br(), 
               p("To experiment empirically with linear regressions, in the ",
               strong("sidebarPanel "), 
               " you may, at any moment: "), 
               br(), # ordered list
               tags$ol(
                 tags$li("In the first ", em("drop down box, "), 
                         "select the database to be used."), 
                 tags$li("In the second ", em("drop down box, "), 
                         "pick the resulting variable of the regression."), 
                 tags$li("In the ", em("radio buttons, "), 
                         "choose one of the regressors for the linear regression."), 
                 tags$li("In the following", em("drop down box "),
                         "you are able to define which one, of the several predefined linear models, will be used."),
                 tags$li("Finally, in the ", em("check boxes "),
                         "you basically define characteristics of the resulting plot.")
               ),
               p( strong("Ref.: "), "Thanks to Francis Smart for his idea and a portion of statistical R code at: ",
                  "[A Shiny App for Playing with OLS]
                (http://www.econometricsbysimulation.com/2013/11/a-shiny-app-for-playing-with-ols.html)"
               )
     ),
      tabPanel("Application",     
               plotOutput("scatter"),
               tableOutput("lmStats"),
               tableOutput("lmResults"),
               tableOutput("values"))
    ) 
  )
))
