**A trilinguist journey through Exploratory Data Analysis (R, SAS, Python)**
---------------------------------------------------------

This repository contains code and results of exploring data using three different types of tool/languages: SAS, R, and Python.

Before diving into the approaches taken across the tool sets, here's a brief introduction to the data set used for the exercise

------
### The data set
This data set consists of survey responses from (prospective) customers of a major retailer captured in the past 21-months period.  The survey captures sentiments/perception of various attributes of the retailer across the country delineated by [Designated Market Area (DMA)](http://seventhpoint.com/wp-content/uploads/2013/11/nielsen_dma_map_compressed.pdf).  Attributes captured include Pricing, Assortment, Access, Services, Corporate Reputation, and others.  The responses (results) from the survey are in percentage units, which translate to the percentage of respondents that agree or believe a particular applies to the retailer.  For example, if the survey question  was, "Lowest Price" and 53% was the measure's value, that means 53% of respondents believe this particular retailer has the lowest price amongst its peers (competitors).  Since some of the responses were on a scale format, I calculate the percentage of answer in the top-3 / -4 scale in order to arrive with a percentage unit.  That way, all measures are consistent, thereby we can compare and contrast these measures appropriately.

Two form of data set was used for this EDA exercise: 
  - Panel Data: 21-months of data at month level for each DMAs. (dimensions: temporal & geography)
  - Cross-sectional data: data summarised across all 21-months for each DMAs. (dimension: geography)


----------
### EDA using SAS
In SAS, **proc SGSCATTER** was used to illustrate the relationship between Price perception and the retailer's Market Share / Sales / Traffic.  A linear regression fitting and cofidnece interval was included to the scatter plot (using "reg = (degree=1 clm nogroup);") to further illustrate its trend and fit.  That said, a numeric trendline value was calculated using **proc REG**.

 1. The panel-data plot is created to illustrate Price perception in relations to Market Share / Sales- / Traffic index over the 21-months period.  Results can be seen [here](SAS/Results/Panel_plot__SAS.png).
 2. The cross-sectional relationship between Price Perception and retailer's Market Share / Sales- / Traffic index can be found [here](SAS/Results/Cross_section__SAS.png).


### EDA using R
In R, **dplyr** was the primarily library used to explore the dataset, while **ggvis** was used to create the visualization.  At the time of this writing (Dec 2014), a lot of the interactivity (e.g., linked-brush) are still in beta stage, so not the interactivity could be buggy on its current sharing platform, shinyapps.io.  I also published plots using **plotly**, not only to illustrates its maturity since its launch few weeks ago, but I think it's a quick and elegant method to share plots especially given plotly tight integration with R and Python (as well as text file or Excel file).

 1. Mirroring to what was created with SAS, the same cross-sectional plat is created with R, which you can find [here](R/Results/Cross_section__R.png).
 2. Similar to the panel-data plot created by SAS, check out the same results using R [here](R/Results/Panel_plot__R.png).

> For a consolidated view of results produced by R, check out the results at [Rpubs](https://rpubs.com/rtheman/52343).

By leveraging the **reactive** feature of ggvis (linked-brush), one can select point(s) on the left plot and the corresponding points will be highlighted on the plot to its right.  Check out this spify plot at [ShinyApps.io](http://rtheman.shinyapps.io/EDA_viz_v1). ([screenshot](R/Results/ggvis_interactive.png))


### EDA using Python
(coming soon)


------
### Code

**SAS**

 1. EDA via [SAS](SAS/Code/QC__ADS_Summ__BB_20141226.sas)

**R**

 1. EDA via [R](R/Code/EDA_Viz.R)
  - [Results](https://rpubs.com/rtheman/52343) in [R Markdown](R/Code/EDA_Viz.Rmd) format
 2. Reactive (linked-brush) [plot](R/Code/EDA_viz__Reactive.Rmd)


**Python**

 1. (coming soon)


-----
References:

SAS:
 - [Creating High-Quality Scatter Plots: An Old Story Told by the New SGSCATTER procedure](http://support.sas.com/resources/papers/proceedings10/057-2010.pdf); SAS Global Forum 2010

R:
 - Intro to [Interactive Document](http://shiny.rstudio.com/articles/interactive-docs.html)
 - R Markdown [Interactive Document](http://rmarkdown.rstudio.com/authoring_shiny_advanced.html)
 - [Shiny tutorial](http://shiny.rstudio.com/tutorial/)
 - [Tutorial](http://shiny.rstudio.com/articles/shinyapps.html) for the first timer with ShinyApps.io
 - [ggvis overview](http://ggvis.rstudio.com/)
 - a great R Studio [webinar](http://pages.rstudio.net/Webinar-Series-Recording-Essential-Tools-for-R.html) on dplyr and ggvis (reactive and interactive)
 - [ggplot2 vignettes](http://docs.ggplot2.org/current/index.html)
 - a presentation on [Data visualization](https://rpubs.com/conniez/datavis)


*created by [stackedit.io](https://stackedit.io/editor#fn:stackedit)*