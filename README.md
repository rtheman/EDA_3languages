
Exploratory Data Analysis in 3 languages (R, SAS, Python)
--
This repository contains code and results of exploring data using three different types of tool/languages: SAS, R, and Python.

In SAS, 

In R, **dplyr** was the primarily library used to explore the dataset, while **ggvis** was used to create the visualization.  At the time of this writing (Dec 2014), a lot of the interactivity (e.g., linked-brush) are still in beta stage.  As a result, I couldn't publish results with interactivity to platforms such as Rpubs or shinyapps.io.

In Python... (in progress)

------
### Brief intro. to the data set
Results of a survey that includes perceptions of a retailer's customer.  Results are represented as percentage.  As a result, if the question to the customer was, "Lowest Price" and 53% was the measure for such question, that means 53% of respondents believe this particular retailer has the lowest price amongst its peers (competitors.)


----------
**EDA using SAS**

 1. To begin, relationship between Price Perception and
    retailer's Market Share / Sales index / Traffic index (Panel data plot) can be found [here](SAS/Results/Panel_plot__SAS.png) in the [SAS/Results](SAS/) folder.


**EDA using R**

 1. Mirroring to what was accomplished using SAS, the same panel data is plotted with R can be found [here](R/Results/Panel_plot__R.png) in the [R/Results](R/) folder..

------
