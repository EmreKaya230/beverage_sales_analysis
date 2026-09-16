data <- readRDS("clean_full.rds")

# Descriptive statistics 

#Summary
summary(data[c("retail_sales","warehouse_sales","total_sales")])

# mean, median, standard deviation of total sales
mean(data[["total_sales"]])
median(data[["total_sales"]])
sd(data[["total_sales"]])
# here I can tell clearly both of columns are right skewed because median is clearly smaller than mean.
# but I ll check with histogram

# check skewness with simple histograms
hist(data[["retail_sales"]], main = "Retail Sales", xlab = "Retail sales")
hist(data[["warehouse_sales"]], main = "Warehouse Sales", xlab = "Warehouse sales")
hist(data[["total_sales"]], main = "Total Sales", xlab = "Total sales")
# Clearly they are right skewed .

# by category
tapply(data[["total_sales"]], data[["item_type"]], mean)
table(data[["item_type"]])

