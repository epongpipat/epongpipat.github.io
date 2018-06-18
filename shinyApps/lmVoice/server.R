library(shiny)
shinyServer(function(input, output) {
  
  # load carData
  dataset <- carData::Salaries
  
  # rename heading
  colnames(dataset) <- c("rank","discipline","years since phd","years of service", "sex", "salary")
  
  # rename discipline factor
  dataset <- dataset %>%
    mutate(discipline = ifelse(discipline == "A", "theoretical", "applied"))
  
  # ensure discipline is a factor
  dataset$discipline <- as.factor(dataset$discipline)
  
  # output: list of variables
  output$variable_list <- renderText({
    variables <- colnames(dataset)
    paste(shQuote(variables, type="cmd"), collapse=", ")
  })
  
  # reative: lm summary
  voice.lmSummary <- reactive({
    
    # set DV and check
    DV <- tolower(input$DV)
    if ( DV %in% colnames(dataset) ) {
      cat(paste("DV: ",DV,"\n",sep=""))
    } else {
      cat(paste("DV of ",DV," is vot valid option\n",sep=""))
    }
    
    # set IV and check
    IV <- tolower(input$IV)
    if ( IV %in% colnames(dataset) ) {
      
      # do this is actual IV
      
      if ( is.factor(dataset[[IV]]) ) {
        
        # categorical IV
        contrast <- input$contrast
        cat(paste("IV: ",IV," (categorical)\n",sep=""))
        
        if (contrast == "dummy") {
          
          # dummy code
          dataset[[IV]] <- as.factor(dataset[[IV]])
          IV_length <- length(levels(dataset[[IV]]))
          contrasts(dataset[[IV]]) <- contr.treatment(IV_length)
        } else if (contrast == "deviant" || contrast == "effects") {
          
          # deviant/effects code
          contrast <- "deviant (effects)"
          dataset[[IV]] <- as.factor(dataset[[IV]])
          IV_length <- length(levels(dataset[[IV]]))
          contrasts(dataset[[IV]]) <- contr.sum(IV_length)
          
        } else {
          
          # invalid contrast
          cat(paste("Contrast option of ",input$contrast," is not valid. Defaulting to dummy.\n",sep=""))
          contrast <- "dummy"
          dataset[[IV]] <- as.factor(dataset[[IV]])
          IV_length <- length(levels(dataset[[IV]]))
          contrasts(dataset[[IV]]) <- contr.treatment(IV_length)
        }
        
        # print
        cat(paste("Contrast Code: ",contrast,"\n",sep=""))
        cat("\n")
        print(contrasts(dataset[[IV]]))
        
      } else {
        
        # continuous IV
        
        # print
        cat(paste("IV: ",IV," (continuous)\n",sep=""))
      }
    } else {
      
      # invalid IV
      
      # print
      print(paste("IV of ",IV," is vot valid option",sep=""))
    }
    
    # only summarize if variables are valid
    if (DV %in% colnames(dataset) && IV %in% colnames(dataset)) {
      model <- lm(dataset[[DV]] ~ dataset[[IV]])
      cat("\n")
      print(Anova(model, type = c("III")))
      cat("\n")
      cat("Coefficients Table\n")
      print(summary(model)$coefficients)
      cat("\n")
      cat("Effect Size\n")
      cat(paste("Multiple R-squared: ",format(round(summary(model)$r.squared,3),nsmall=2),", Adjusted R-squared: ",format(round(summary(model)$adj.r.squared,3),nsmall=2),"\n",sep=""))
    }
    
 })
  
  # output: summary of linear model
  output$summary <- renderPrint({
    voice.lmSummary()
  })
  
  # reactive: plot
  voice.lmVisualization <- reactive({
    
    # set DV and IV
    DV <- tolower(input$DV)
    IV <- tolower(input$IV)
    
    # only plot if variables are valid
    if (DV %in% colnames(dataset) && IV %in% colnames(dataset)) {
      
      if (is.factor(dataset[[IV]])) {
        
        # categorical IV
        
        # descriptive stats/build 95% CI
        datasetSummary <- dataset %>%
          group_by(IV = eval(as.name(IV))) %>%
          summarize(mean = mean(eval(as.name(DV))),
                    sd = sd(eval(as.name(DV))),
                    n = n(),
                    df = n-1,
                    tcrit = abs(qt(0.05/2, df)),
                    SEM = sd/sqrt(n),
                    ME = tcrit*SEM)
        
        # dot plot with 95% CI
        ggplot(datasetSummary, aes(x = IV, y = mean, group=1)) + 
          geom_pointrange(aes(ymin = mean-ME, ymax = mean+ME))+
          expand_limits(x = 0, y = 0)+
          theme_classic()+
          labs(x = IV, y = DV, caption = "Note: Bars represent 95% CI")
        
      } else {
        
        # continuous IV
        ggplot(mapping = aes(x = dataset[[IV]], y = dataset[[DV]])) + 
          geom_point() + 
          geom_smooth(method = "lm", color = "black")+
          theme_classic()+
          labs(x = IV, y = DV, caption = "Note: Gray band represents the 95% CI")
      }
      
    }
  })
  
  # output: plot
  output$visualization <- renderPlot({
    voice.lmVisualization()
  })
  
})
