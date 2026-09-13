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
# I need just (wine, liquor, beer,non alcahol)
data <- subset(data, item_type == "WINE" | item_type == "LIQUOR" | item_type == "BEER" | item_type == "NON-ALCOHOL")

# 5) Column Selection
data <- data[, c("year","month","item_type","retail_sales","retail_transfers","warehouse_sales")]
# I did not use these columns; supplier, item_code, item_description , because there is too many unique values not used.

