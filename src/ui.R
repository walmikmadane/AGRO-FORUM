library(shiny)
library(shinythemes)
library(markdown)
shinyUI
(
fluidPage
(
shinythemes::themeSelector(),
includeCSS("1.css"),
 navbarPage(id="navbar",
            "AGRO-FORUM",
    
               
               
    tabPanel("HOME",
    
      
      fluidRow
      (
      
          column
          (
            3,
          selectInput("select_state", label = h3("Select State",color="blue"),
                      choices = list("Andhra Pradesh" = "Andhra Pradesh",
                                     "Arunachal Pradesh"="Arunachal Pradesh",
                                     "Assam" = "Assam",
                                     "Bihar"="Bihar",
                                     "Chattisgarh" = "Chattisgarh",
                                     "Goa"="Goa",
                                     "Haryana"="Haryana",
                                     "Himachal Pradesh"="Himachal Pradesh",
                                     "Jammu & Kashmir"="Jammu & Kashmir",
                                      "Gujarat"="Gujarat",
                                     "Jharkhand"="Jharkhand",
                                     "Karnataka"="Karnataka",
                                     "Kerala"="Kerala",
                                     "Madhya Pradesh"="Madhya Pradesh",
                                     "Maharashtra"="Maharashtra",
                                     "Manipur"="Manipur",
                                     "Meghalaya"="Meghalaya",
                                     "Mizoram"="Mizoram",
                                     "Nagaland"="Nagaland",
                                     "Orissa"="Orissa",
                                     "Punjab"="Punjab",
                                     "Pondicherry"="Pondicherry",
                                     "Rajasthan"="Rajasthan",
                                     "Sikkim"="Sikkim",
                                     "Tamil Nadu"="Tamil Nadu",
                                     "Telangana"="Telangana",
                                     "Tripura"="Tripura",
                                     "Uttar Pradesh"="Uttar Pradesh",
                                     "Uttranchal"="Uttranchal",
                                     "West Bengal"="West Bengal"
                      ),
                              selected = 1)
            
          ),
         column
        (
          5,
        sliderInput("slider_irrigation", label = h3("Select Area under Irrigation (In Hectare)",color="black"),
                    min = 0, max = 1000, value = 10),
        sliderInput("slider_totarea", label = h3("Select Total Area (In Hectare)",color="blue"),
                    min = 0, max = 1000, value = 10)
          
      
        ),
      column
      (
      4,
      sliderInput("slider_rainfall", label = h3("Select Rainfall (In MM)"),
                  min = 0, max = 12000, value = 50)
      
      )
        
      ),
      fluidRow
      (
      tabsetPanel(
        
        tabPanel(
          "RICE Yield Prediction",
          br(),
          h3("Yield Statistics"),
          tableOutput("yeild_stat_table")
          
          
        ),
        tabPanel("State Market Prices",br(),h3(textOutput("state_table_header")),br(),tableOutput("state_table")),
        tabPanel("All India Market Prices",br(),h3(textOutput("table_header")),br(),tableOutput("table")),
        tabPanel("Current Trending News..",
                 br(),
                 verbatimTextOutput("news1"),
                 hr(),
                 verbatimTextOutput("news2"),
                 hr(),
                 verbatimTextOutput("news3"),
                 hr(),
                 verbatimTextOutput("news4"),
                 hr(),
                 verbatimTextOutput("news5"),
                 hr()),
        tabPanel("TRADERS Reported..")
      )
          
      ),
      value = "home"
      
    ),
    tabPanel(
      "ABOUT US",value = "about us",
      includeHTML("about.html")
    ),
    tabPanel(
      "TRADER REPORTING",
      fluidRow
      (
        column
        (
          2
          
        ),
        column(
          8,
          textInput("trader_name",label = h3("Enter Name..")),
          selectInput("trader_select_state", label = h3("Select State"), 
                      choices = list("Andhra Pradesh" = "Andhra Pradesh",
                                     "Arunachal Pradesh"="Arunachal Pradesh",
                                     "Assam" = "Assam",
                                     "Bihar"="Bihar",
                                     "Chattisgarh" = "Chattisgarh",
                                     "Goa"="Goa",
                                     "Haryana"="Haryana",
                                     "Himachal Pradesh"="Himachal Pradesh",
                                     "Jammu & Kashmir"="Jammu & Kashmir",
                                     "Gujarat"="Gujarat",
                                     "Jharkhand"="Jharkhand",
                                     "Karnataka"="Karnataka",
                                     "Kerala"="Kerala",
                                     "Madhya Pradesh"="Madhya Pradesh",
                                     "Maharashtra"="Maharashtra",
                                     "Manipur"="Manipur",
                                     "Meghalaya"="Meghalaya",
                                     "Mizoram"="Mizoram",
                                     "Nagaland"="Nagaland",
                                     "Orissa"="Orissa",
                                     "Punjab"="Punjab",
                                     "Pondicherry"="Pondicherry",
                                     "Rajasthan"="Rajasthan",
                                     "Sikkim"="Sikkim",
                                     "Tamil Nadu"="Tamil Nadu",
                                     "Telangana"="Telangana",
                                     "Tripura"="Tripura",
                                     "Uttar Pradesh"="Uttar Pradesh",
                                     "Uttranchal"="Uttranchal",
                                     "West Bengal"="West Bengal"
                      ),
                      selected = 1),
          textAreaInput("trader_add",label = h3(" Enter Address..")),
          numericInput("trader_mobile", 
                       label = h3("Enter Mobile NO"),value = ""),
          numericInput("trader_min_price", 
                       label = h3("Enter MIN.PRICE"),value = ""),
          numericInput("trader_max_price", 
                       label = h3("Enter MAX.PRICE"),value = ""),
          actionButton("submit","GO")
          
          
          
          
          
          
        ),
      column(
        2
      )
      
        
      ),
      value = "trader"
    ),
    inverse = TRUE,
    collapsible = TRUE
    )
    
)
 

)