
# # install packages 
# BiocManager::install("rhdf5")
# BiocManager::install("HDF5Array")

# #------------------ load packages 
suppressMessages(library(nycflights13)) 
suppressMessages(library(rhdf5)) 
suppressMessages(library(HDF5Array)) 
suppressMessages(library(etl)) 
suppressMessages(library(RSQLite)) 
suppressMessages(library(RPostgreSQL)) 
suppressMessages(library(RMySQL)) 
suppressMessages(library(dplyr))  
# suppressMessages(library(evprof)) # EV PROFiling   
suppressMessages(library(ggplot2))  
suppressMessages(library(data.table))  
suppressMessages(library(evsim)) # EV SIMulation  
suppressMessages(library(tibble))  
suppressMessages(library(dygraphs)) # dygraph()   
suppressMessages(library(xts))  # xts() df to time series
suppressMessages(library(htmltools)) # save_html  
suppressMessages(library(survey)) # svydesign()


#------------------ ggplot theme 
theme <- theme(
  # remove Background
  panel.background = element_blank(),
  panel.border = element_blank(),
  panel.grid = element_blank(),
  axis.line = element_line(colour = "black"),
  # no legend 
  legend.position = "none",   
  # axis text 
  axis.text = element_text(size = 6),
  axis.title = element_text(size = 8),
  # X, Y axis text 
  axis.title.x = element_text(face="bold", colour="#e17b83", size=12),
  axis.title.y = element_text(face="bold", colour="#e17b83", size=12),
  # plot setting
  plot.margin = margin(0.3,.1,0.3,.1, "cm"),
  plot.caption = element_text(size = 6,
                              face = "italic")
)




