# EDA and Interactive Visualization
# 
# Resources:
# a.) Intro to dplyr and ggvis incl interactive plot (R Studio Webinar: http://pages.rstudio.net/Webinar-Series-Recording-Essential-Tools-for-R.html?aliId=726264)

# Code Workflow
# 	1.) Cross-section of relationship btw Price Perception & Sales- / Trips Index / Mkt Share for all BldgBlks (41)
# 		a. Create sub data set
# 		b. Plot
# 		c. Create trendline with coefficients and p-Value
# 	2.) Panel data of relationship btw Price Perception & Sales- / Trips Index / Mkt Share for all BldgBlks (41) for all Year-Months (21)
# 		a. Create sub data set
# 		b. Plot
# 		c. Create trendline with coefficients and p-Value
#   3.) Market Share over time (21 mo.)


library(ggplot2)
library(ggvis)
library(dplyr)
py <- plotly()



# Initializing working directory
dir_Main     	= "/Users/richleung/Dropbox/Projects/EDA_3languages/R/Code"
dir_ADS_Summary = "/Users/richleung/Dropbox/Documents/Accenture/Walmart/g. ADS_Summary"
dir_ADS_BB		= "/Users/richleung/Dropbox/Documents/Accenture/Walmart/a. by Building Blocks"
setwd(dir_Main)



# Import raw data file
setwd(dir_ADS_Summary)
Summ_BB <- read.table("Summary_BB.csv", sep=",", header=TRUE)

setwd(dir_ADS_BB)
ADS_BB <- read.table("ADS_WMT__N_BLDBLK_UPDATED07.csv", sep=",", header=TRUE)





# ==-- Quick EDA --==
# a quick glimpse of the ADS_Summary (Building Block level) data set
glimpse(Summ_BB)

# Number of unique Building Blocks in data set [41]
distinct(select(Summ_BB, Bldblk)) %>%
	tally(sort = TRUE)

# histogram of Price Perception from ADS-BB
g <- ADS_BB %>% 
	ggvis(~C2_110_wgt, fill := "steelblue") %>% 
# 	layer_histograms(width = 0.01) %>% 
	layer_histograms(width = input_slider(0, 0.1, step = 0.001, label = "width"))
	add_axis("x", title = "Price Perception (C2_110)") %>% 
	add_axis("y", title = "count")
print(g)





# orient code to point to working directory
setwd(dir_Main)

# ==-- 1.) Cross-section of relationship btw Price Perception & Mkt Share (Index) for all BldgBlks (41) --==
# {market share}

# a. Create sub data set
tmp1 <- Summ_BB %>%
	select(Bldblk, C2_110_wgt_avg_21mo, sales_index_yrmon_strtyp_21MO, Trips_index_yrmon_strtyp_21MO, MKT_SHARE_Nielsen_21MO)

# b. Plot relationship between Price Perception & Market Share
# g1 <- 
# 	ggplot(tmp1, aes(x = C2_110_wgt_avg_21mo, y = MKT_SHARE_Nielsen_21MO)) + 
# 	geom_point(color = "steelblue") + 
# 	geom_smooth(method = "lm") + 
# 	labs(x = "Price Percep", y = "Mkt Share", title = "Relationship btw Price Perception & Market Share by Bldg_Blks") + 
# 	ggsave(filename = "plot.png")
# print(g1)

# (using ggvis instead)
g1 <- tmp1 %>% 
	ggvis(~C2_110_wgt_avg_21mo, ~MKT_SHARE_Nielsen_21MO, fill := "darkblue") %>% 
	layer_points() %>% 
	layer_model_predictions(model = "lm", se = TRUE) %>%
	add_axis("x", title = "Price Perception (C2_110)") %>% 
	add_axis("y", title = "Market Share") %>% 
#  	add_title(title = "Relationship btw Price Perception & Market Share by Building Block")
 	add_axis("x", orient = "top", ticks = 0, title = "Relationship btw Price Perception and Market Share by Building Block")
print(g1)

# (using Plotly via ggplot)
g1 <- ggplot(tmp1, aes(C2_110_wgt_avg_21mo, MKT_SHARE_Nielsen_21MO)) + 
  geom_point() + 
  geom_smooth(method = "lm", se = FALSE, color = "blue", aes(group = 1))

r <- py$ggplotly(g1)
r$response$url



# {market share index}

# a. Create sub data set
tmp2 <- Summ_BB %>%
  select(Bldblk, C2_110_wgt_avg_21mo, sales_index_yrmon_strtyp_21MO, Trips_index_yrmon_strtyp_21MO, mkt_share_strtyp)

# b. Plot relationship between Price Perception & Market Share
# g2 <- 
# 	ggplot(tmp2, aes(x = C2_110_wgt_avg_21mo, y = mkt_share_strtyp)) + 
# 	geom_point(color = "steelblue") + 
# 	geom_smooth(method = "lm") + 
# 	labs(x = "Price Percep", y = "Mkt Share Index", title="Relationship btw Price Perception & Market Share Index by Bldg_Blks") + 
# 	ggsave(filename = "plot.png")
# print(g2)

# (using ggvis instead)
g2 <- tmp2 %>% 
	ggvis(~C2_110_wgt_avg_21mo, ~mkt_share_strtyp, fill := "steelblue") %>% 
	layer_points() %>% 
 ▸ 	layer_model_predictions(model = "lm", se = TRUE) %>% 
	add_axis("x", title = "Price Perception (C2_110)") %>% 
	add_axis("y", title = "Market Share Index") %>% 
# 	add_title(title = "Relationship btw Price Perception & Market Share Index by Building Block")
	add_axis("x", orient = "top", ticks = 0, title = "Relationship btw Price Perception and Market Share Index by Building Block")
print(g2)





# ==-- 2.) Panel data of relationship btw Price Perception & Sales- / Trips Index / Mkt Share for all BldgBlks (41) for all Year-Months (21) --==
# {market share}

# a. Create sub data set
tmp1 <- ADS_BB %>%
	select(bldblk, C2_110_wgt, Sales_index_yrmon_strtyp, Trips_index_yrmon_strtyp, mkt_share_nielsen)

# b. Plot relationship between Price Perception & Market Share
# g1 <- 
# 	ggplot(tmp1, aes(x = C2_110_wgt, y = mkt_share_nielsen)) + 
# 	geom_point(color = "steelblue") + 
# 	geom_smooth(method = "lm") + 
# 	labs(x = "Price Percep", y = "Mkt Share", title = "Relationship btw Price Perception & Market Share by Bldg_Blks by Yr-Mo.") + 
# 	ggsave(filename = "plot.png")
# print(g1)

# (using ggvis instead)
g1 <- tmp1 %>% 
	ggvis(~C2_110_wgt, ~mkt_share_nielsen, fill := "darkblue") %>% 
	layer_points() %>% 
	layer_model_predictions(model = "lm", se = TRUE) %>% 
	add_axis("x", title = "Price Perception (C2_110)") %>% 
	add_axis("y", title = "Market Share") %>% 
# 	add_title(title = "Relationship btw Price Perception & Market Share Index by Building Block")
	add_axis("x", orient = "top", ticks = 0, title = "Relationship btw Price Perception and Market Share by Building Block by Year-Months")
print(g1)

# (using Plotly via ggplot)
g1 <- ggplot(tmp1, aes(C2_110_wgt, mkt_share_nielsen)) + 
  geom_point() + 
  geom_smooth(method = "lm", se = FALSE, color = "blue", aes(group = 1))

r <- py$ggplotly(g1)
r$response$url



# {market share index}

# a. Create sub data set
tmp2 <- ADS_BB %>%
	select(bldblk, C2_110_wgt, Sales_index_yrmon_strtyp, Trips_index_yrmon_strtyp, mkt_share_Strtyp)

# b. Plot relationship between Price Perception & Market Share
# g2 <- 
# 	ggplot(tmp2, aes(x = C2_110_wgt, y = mkt_share_Strtyp)) + 
# 	geom_point(color = "steelblue") + 
# 	geom_smooth(method = "lm") + 
# 	labs(x = "Price Percep", y = "Mkt Share Index", title = "Relationship btw Price Perception & Market Share Index by Bldg_Blks by Yr-Mo.") + 
# 	ggsave(filename = "plot.png")
# print(g2)

# (using ggvis instead)
g2 <- tmp2 %>% 
	ggvis(~C2_110_wgt, ~mkt_share_Strtyp, fill := "steelblue") %>% 
	layer_points() %>% 
	layer_model_predictions(model = "lm", se = TRUE) %>% 
	add_axis("x", title = "Price Perception (C2_110)") %>% 
	add_axis("y", title = "Market Share Index") %>% 
# 	add_title(title = "Relationship btw Price Perception & Market Share Index by Building Block")
	add_axis("x", orient = "top", ticks = 0, title = "Relationship btw Price Perception and Market Share Index by Building Block by Year-Months") 
  # export_png <- function(vis, file = NULL) {
  #   vega_file(vis, file = Panel_MktShrIDX, type = "png")
  }
print(g2)






# ==-- 3.) Time-Series (21 mo.) --==
# 3a1.) Price perception over time avg across bldg blks (41)
tmp1 <- ADS_BB %>% 
	group_by(Wave) %>% 
	summarise_each(funs(mean(., na.rm = TRUE)), C2_110_wgt, Sales_index_yrmon_strtyp)

# g <- 
# 	ggplot(tmp, aes(x = Wave, y = C2_110_wgt)) + 
# 	geom_point(aes(colour = Sales_index_yrmon_strtyp)) + 
# 	# geom_smooth(method = "lm") + 
# 	labs(x = "Wave", y = "Price Perception", title = "Price Perception over time (21 mo.) avg across bldg blks (41)")
# 	ggsave(filename = "plot.png")
# print(g)

# (using ggvis instead)
g1 <- tmp1 %>% 
	ggvis(~Wave, ~C2_110_wgt) %>% 
	layer_lines() %>% 
	add_axis("x", title = "Year-Months (wave)") %>% 
	add_axis("y", title = "Price Perception (C2_110)") %>% 
	add_axis("x", orient = "top", ticks = 0, title = "Price perception over time (21 mo.) avg across bldg blks (41)")
print (g1)


# 3a2.) Price perception over time by bldg blk (41) with mouse-over information
tmp2 <- ADS_BB %>% 
  select(Wave, bldblk, C2_110_wgt)

# for mouse-over
tmp2$id <- 1:nrow(tmp2)
all_values <- function(x) {
  if(is.null(x)) return(NULL)
  row <- tmp2[tmp2$id == x$id, ]
  paste0(names(row), ": ", format(row), collapse = "<br />")
}

# plot using ggvis
g2 <- tmp2 %>% 
  ggvis(~Wave, ~C2_110_wgt, key := ~id, fill := "darkgreen") %>% 
  layer_points() %>% 
  add_axis("x", title = "Year-Months (wave)") %>% 
  add_axis("y", title = "Price Perception (C2_110)") %>% 
  add_axis("x", orient = "top", ticks = 0, title = "Price perception over time (21 mo.) by bldg blks (41)") %>% 
  add_tooltip(all_values, "hover")
print(g2)



# 3b1.) Market Share over time
tmp1 <- ADS_BB %>% 
	group_by(Wave) %>% 
	summarise_each(funs(mean(., na.rm = TRUE)), mkt_share_nielsen, Sales_index_yrmon_strtyp)

# (using ggvis instead)
g <- tmp1 %>% 
	ggvis(~Wave, ~mkt_share_nielsen, stroke = ~Sales_index_yrmon_strtyp, stroke = ~Sales_index_yrmon_strtyp) %>% 
	layer_lines() %>% 
	add_axis("x", title = "Year-Months (wave)") %>% 
	add_axis("y", title = "Market Share") %>% 
	add_axis("x", orient = "top", ticks = 0, title = "Market Share over time (21 mo.)") 
print (g)


# 3b2.) Market Share over time by bldg blk (41)
tmp2 <- ADS_BB %>% 
	select(Wave, bldblk, mkt_share_nielsen)

# for mouse-over
tmp2$id <- 1:nrow(tmp2)
all_values <- function(x) {
  if(is.null(x)) return(NULL)
  row <- tmp2[tmp2$id == x$id, ]
  paste0(names(row), ": ", format(row), collapse = "<br />")
}

# plot using ggvis
g2 <- tmp2 %>% 
  ggvis(~Wave, ~mkt_share_nielsen, key := ~id, fill := "darkgreen") %>% 
  layer_points() %>% 
  add_axis("x", title = "Year-Months (wave)") %>% 
  add_axis("y", title = "Market Share") %>% 
  add_axis("x", orient = "top", ticks = 0, title = "Market Share over time (21 mo.) by bldg blks (41)") %>% 
  add_tooltip(all_values, "hover")
print(g2)