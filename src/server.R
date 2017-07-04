
library(shiny)
library(XML)
library("rvest")
library(stringr)
library(data.table)

# Define server logic required to draw a histogram
shinyServer(
  function(input, output,session) 
  {
      
    #code for yield prediction..
    
    data<-read.csv(file="FinalDatasetDel.csv")
    data2=data
    data2$C=data2$C*1000
    #data
    relation1<-lm(Y~R+C,data=data2)
    relation2<-lm(Y~R*C,data=data2)
    #summary(relation1)
    #summary(relation2)
    c1<-relation1$coefficients
    c2<-relation2$coefficients
    
    output$yeild_stat_table<-renderTable(
      {
        rainfall=input$slider_irrigation
        irrigation=input$slider_rainfall
        yield1=rainfall*c1[2]+irrigation*c1[3]+c1[1]
        yield1=as.integer(yield1)
        
        rainfall=input$slider_irrigation
        irrigation=input$slider_rainfall
        yield2=rainfall*c2[2]+irrigation*c2[3]+c2[1]
        
        yield2=as.integer(yield2)
        
        
        tot_area=input$slider_totarea
        tot_prod1=yield1*tot_area
        tot_prod2=yield2*tot_area
        
        yield1=paste("",yield1,"KG/HECTARE")
        yield2=paste("",yield2,"KG/HECTARE")
        
        tot_prod1=paste("",tot_prod1,"KG")
        tot_prod2=paste("",tot_prod2,"KG")
        
        
        
        yield_table=data.frame(c("Model 1","Model 2"),c(yield1,yield2),c(tot_prod1,tot_prod2))
        colnames(yield_table)<-c("","Production Per Hectare","Total Production")
        row.names(yield_table)<-c("Model 1","Model 2")
        yield_table
      }
    )
    
    #code for price fetching....
  
    tryCatch(
      {
        
        df=Sys.Date()
        day=format(as.Date(df,format="%Y-%m-%d"), "%d")
        month=format(as.Date(df,format="%Y-%m-%d"), "%m")
        year=format(as.Date(df,format="%Y-%m-%d"), "%Y")
        
        date=paste(day,"/",month,"/",year,sep="")
        #date="11/04/2017"
        # date
        
        
        
        url=paste("http://agmarknet.nic.in/cmm2_home.asp?comm=Paddy(Dhan)&dt=",date,sep="")
        table=readHTMLTable(url,which=4)
        colnames(table)=c("market","arrival","origin","variety","min_Price","max_Price","modal_Price")
        table$origin<-NULL
        table$arrival<-NULL
        
        
        
        
        table <- data.frame(lapply(table, as.character), stringsAsFactors=FALSE)
        
        table$market=substr(table$market,1,nchar(table$market)-1)
        table$variety=substr(table$variety,1,nchar(table$variety)-1)
        table$min_Price=substr(table$min_Price,1,nchar(table$min_Price)-1)
        table$max_Price=substr(table$max_Price,1,nchar(table$max_Price)-1)
        table$modal_Price=substr(table$modal_Price,1,nchar(table$modal_Price)-1)
      },
      error=function(cond)
      {
        message("nreadHTML problem...")
        return(NA)
       
      }
    )
    
    
   
      output$state_table<-renderTable(
        tryCatch({
         
          
          a=paste(table$market,sep="")
          
          #assign state value depending upon user selection (only in lowercase)
          state=input$select_state
          state=tolower(state)
          start=which(grepl(state,tolower(a)))
          #start
          market=c()
          variety=c()
          min_Price=c()
          max_Price=c()
          modal_Price=c()
          
          start=start+1
          row=table[paste(start,sep=""),]
          i=1
          while(is.na(row[3])==FALSE)
          {
            
            market[i]=row[1]
            variety[i]=row[2]
            min_Price[i]=row[3]
            max_Price[i]=row[4]
            modal_Price[i]=row[5]
            #print(row)
            i=i+1
            start=start+1
            row=table[paste(start,sep=""),]
            
            
            
          }
          
          state_table=data.frame(unlist(market),unlist(variety),unlist(min_Price),unlist(max_Price),unlist(modal_Price))
          colnames(state_table)=c("market","variety","min_Price","max_Price","modal_Price")
          
          
          state_table=data.table(state_table)
          state_table
          
        },
        error=function(cond)
          {
            message("Not Reported")
            ta<-data.frame(c("NOT REPORTED"))
            colnames(ta)=c("")
            return(ta)
        }
        )
        )
      output$table<-renderTable(
        tryCatch(
          {
            table
          },
          error=function(cond)
          {
            message("Not Reported")
            ta<-data.frame(c("NOT REPORTED"))
            colnames(ta)=c("")
            return(ta)
          }
        )
          
      )
      output$state_table_header<-renderText(
        {
          date2=Sys.Date()
          day=format(as.Date(df,format="%Y-%m-%d"), "%d")
          month=format(as.Date(df,format="%Y-%m-%d"), "%m")
          year=format(as.Date(df,format="%Y-%m-%d"), "%Y")
          
          date2=paste(day,"/",month,"/",year,sep="")
          paste("Markets Reported On Date ",date2," In ",input$select_state,sep = "")
        }
       
      )
      output$table_header<-renderText(
        {
          date2=Sys.Date()
          day=format(as.Date(df,format="%Y-%m-%d"), "%d")
          month=format(as.Date(df,format="%Y-%m-%d"), "%m")
          year=format(as.Date(df,format="%Y-%m-%d"), "%Y")
          
          date2=paste(day,"/",month,"/",year,sep="")
          paste("All India Markets reported On Date ",date2,sep = "")
        }
      )
      
      
      
      
      observeEvent(input$submit, {
        updateTabsetPanel(session,"navbar",selected = "home")
      })
      
      
      #code for new fetching..
      htmlpage1<-read_html("http://www.indexmundi.com/commodities/news/rice/india")
      myhtml1<-html_nodes(htmlpage1,"p")
      
      display1<-html_text(myhtml1[[2]])
      display1<-str_replace_all(display1, "[\r\n]" , "")
      
      display2<-html_text(myhtml1[[3]])
      display2<-str_replace_all(display2, "[\r\n]" , "")
      
      display3<-html_text(myhtml1[[4]])
      display3<-str_replace_all(display3, "[\r\n]" , "")
      
      display4<-html_text(myhtml1[[5]])
      display4<-str_replace_all(display4, "[\r\n]" , "")
      
      
      #first news
     # display1
      
      #display2
      #display3
      
      
      #second news
      #display4
      output$news1<-renderText(
        {
          display1
        }
      )
      
      output$news2<-renderText(
        {
          display2
        }
      )
      
      output$news3<-renderText(
        {
          display3
        }
      )
      
      output$news4<-renderText(
        {
          display4
        }
      )
      
      output$news5<-renderText(
        {
          htmlpage2<-read_html("http://www.agriwatch.com/grains/rice/")
          myhtml2<-html_nodes(htmlpage2,"p")
          t2<-myhtml2[[7]]
          display4<-html_text(t2)
          display4<-str_replace_all(display4,"[\r\n\t]","")
          display4
        }
      )
      
      
  }
)
