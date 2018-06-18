library(shiny)
library(shinythemes)
library(shinycssloaders)
library(tidyverse)
library(dplyr)
library(car)

# loading spinner options
options(spinner.color = '#158CBA', spinner.type = 6)

shinyUI(fluidPage(
  theme = shinytheme("lumen"),
  singleton(tags$head(
    tags$script(src="//cdnjs.cloudflare.com/ajax/libs/annyang/1.4.0/annyang.min.js"),
    includeScript('init.js'))),
  h1("Simple Linear Regression via Voice Command"),
  p("You can run a simple linear regression using just voice commands. Try it out."),
  p("To change the DV, just say DV [insert variable here] or dependent variable [insert variable here]. 
    For example, 'DV salary' or 'dependent variable salary'"),
  p("To change the IV, just say IV [insert variable here] or independent variable [insert variable here]. 
    For example, 'IV sex' or 'independent variable sex.' 
    If the IV is a categorical variable, you can change the contrast coding scheme to either dummy, deviant (effects), or helmert. 
    To change the contrast coding scheme, just say contrast [insert contrast here].
    For example, 'contrast dummy' or 'contrast deviant'"),
  hr(),
  p(strong("List of Variables (Salaries Dataset within carData Package):")),
  textOutput("variable_list"),
  hr(),
  fluidRow(column(width = 6,
                  HTML("<CENTER><B>Output</B></CENTER>"),
                  verbatimTextOutput("summary") %>% withSpinner()),
           column(width = 6,
                  HTML("<CENTER><B>Visualization</B></CENTER>"),
                  plotOutput("visualization") %>% withSpinner())),
  hr(),
  HTML("References: 
        <OL>
          <LI>Shiny Voice App Template -  https://github.com/yihui/shiny-apps/tree/master/voice</LI>
          <LI>Salaries Dataset - Fox J. and Weisberg, S. (2011) An R Companion to Applied Regression, Second Edition Sage.</LI>
        </OL>")
))