data <- read_csv(file.choose())
###
#
# Shape of data
dim(data)  # Result = 341037 row, 9 col 

# Understanding data
head(data)
class(data) 
str(data)
#Column names 
names(data) # column names are inconsisten

#Summary statistics
summary(data)

# Missing Values Control
colSums(is.na(data)) # there is missing values 

# Duplicated Control
sum(duplicated(data)) # ther is no duplicated  values

# Unique values of the key categorical column
table(data$`ITEM TYPE`)


#  1) Data Cleaning
# Data types ;
# RETAIL SALES , RETAIL TRANSFERS, WAREHOUSE SALES are chr because there is " " that's why its chr , I will convert as a numerical
# Item code is chr also but I ll not convert as a numerical because item code is identifier.
cols <- c("RETAIL SALES", "RETAIL TRANSFERS", "WAREHOUSE SALES")
data[cols] <- lapply(data[cols], as.numeric)
#Some blank cells could not be converted to numbers, so they became NA . I will  fill with 0 .

# Rename columns;
names(data) <- tolower(names(data))  # lower case 
names(data) <- gsub(" ", "_", names(data)) # adding  "_"
data

# 2) Duplicate Control Again
sum(duplicated(data)) #There is no duplicated Values 

# 3) Missing values
colSums(is.na(data))
data
# supplier , 204 missing values 
# item_type , 1 missing values 
# retail_sales , 166 missing values
# retail_transfers, 1070 missing values
# warehouse_sales, 2142 missing values

#  Blank sales values mean no sales that month. I ll fill them with 0
#(retail_sales,warehouse_sales,retail_transfers)
data$retail_sales[is.na(data$retail_sales)]         <- 0
data$warehouse_sales[is.na(data$warehouse_sales)]   <- 0
data$retail_transfers[is.na(data$retail_transfers)] <- 0

# I cannot guess the category. I ll drop 
# (item_type)
data <- data[!is.na(data$item_type), ]

# supplier is text that's why I ll fill them with Unknown 
#(supplier)
data$supplier[is.na(data$supplier)] <- "Unknown"

#control
colSums(is.na(data)) # Handled missing values.

# 4) Noise 
# Is there negative sales?
sum(data$retail_sales < 0)   # there is no negative sales
sum(data$warehouse_sales < 0)  # there is no negative sales 

# I am going to keep only the drink categories I need
table(data$item_type) 
# I need just (wine, liquor, beer)
data <- subset(data, item_type == "WINE" | item_type == "LIQUOR" | item_type == "BEER")

# 5) Column Selection
data <- data[, c("year","month","item_type","retail_sales","retail_transfers","warehouse_sales")]
# I did not use these columns; supplier, item_code, item_description , because there is too many unique values not used

# 6) Feature Engineering
# season 
# I ll group months into 4 seasons because analyzing seasonal sales patterns more clearly.
# each month matching their seasons. For example : months ; 6,7,8 = Summer 
data["season"] <- "Autumn"
data[["season"]][data[["month"]] == 12 | data[["month"]] == 1 | data[["month"]] == 2] <- "Winter"
data[["season"]][data[["month"]] == 3  | data[["month"]] == 4 | data[["month"]] == 5] <- "Spring"
data[["season"]][data[["month"]] == 6  | data[["month"]] == 7 | data[["month"]] == 8] <- "Summer"
data[["season"]] <- factor(data[["season"]])  # I am  convert to factor so R treats it as a category .

# total sales
# I need total sales because it gives the overall volume of a product and it helps to compute retail share
data[["total_sales"]] <- data[["retail_sales"]] + data[["warehouse_sales"]]

# drop rows where total is 0
# I am dropping rows where total_sales is 0 , because total sales is the  denominator and would make the result undefined
data <- data[data[["total_sales"]] > 0, ]

# adding new column name as retail_share 
data[["retail_share"]] <- data[["retail_sales"]] / data[["total_sales"]]

# channel label
# If half or more of the sales are retail, label it retail heavy, otherwise wholesale heavy , I m doing for the chi square test
data[["channel"]] <- ifelse(data[["retail_share"]] >= 0.5, "retail heavy", "wholesale-heavy")
data[["channel"]] <- factor(data[["channel"]]) # I am  convert to factor so R treats it as a category same as a season column
names(data)

# 7) Outliers
# I am going to use boxplot to defined outliers.
boxplot(data[["total_sales"]], main = "Total sales outliers")

# IQR method for counting high outliers
Q1 <- quantile(data[["total_sales"]], 0.25)
Q3 <- quantile(data[["total_sales"]], 0.75)
IQR_value <- Q3 - Q1
upper <- Q3 + 1.5 * IQR_value
sum(data[["total_sales"]] > upper) 
# there is 46.360 outliers.
# Sales are naturally skewed, so I m going to keep outliers.

# 8) Normalization: z score 
data[["retail_sales_z"]]    <- scale(data[["retail_sales"]])
data[["warehouse_sales_z"]] <- scale(data[["warehouse_sales"]])
summary(data[["retail_sales_z"]])
# Z score normalization;  rescale numeric sales to mean 0 and standard deviation 1

# 9) save clean data
saveRDS(data, "clean_full.rds")


