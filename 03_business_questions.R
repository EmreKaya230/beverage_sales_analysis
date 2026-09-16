#Business Questions
# Q1) What predicts warehouse sales?
# Q2) Is channel related to product category?
# Q3) Are sales different for each drink type?

data <- readRDS("clean_full.rds")
# sales are very skewed , I ll fix with using log transform.
data[["log_sales"]] <- log1p(data[["total_sales"]])

# Q1) What predicts warehouse sales?
# multiple linear regression
# I used lm function and it takes a formule like (y ~ x1 + x2)
model <- lm(log1p(warehouse_sales) ~ item_type + season + retail_sales, data = data)
summary(model) # summary going to show coefficients, their p values and R square
# Beer sells most in the warehouse and higher retail sales mean higher warehouse sales
# the model explains about 31% ,adj R2 = 0.31

#graph
plot(model)

###

# Q2) Is channel related to product category?
# chi square test
# I m going to look relationship between 2 categorical variables.
# First; I am going to build a cross table .
tbl <- table(data[["item_type"]], data[["channel"]])
tbl

# I am going to use chi square test because it s going to check relationship in this table.
# If the p values is lower than 0.05 , there is relationship.

chisq.test(tbl)
# X-squared = 109605, df = 2, p-value <2.2e-16
# that means, p < 0.05 and reject H0
# Channel and product category are not independent.
# There is strong relationship between them.
# This showes , The drink type affects if it is sold more in retail or wholesale.

# graph
barplot(prop.table(tbl, 1), beside = TRUE,col = c("orange", "blue","red"),legend = TRUE, args.legend = list(cex = 0.5),main = "Channel share by drink type")

###

# Q3) Are sales different for each drink type?
# Anova
# I am going to compare mean sales of this 3 categories
# Wine, Liqour, Beer 

anova1 <- aov(log_sales ~ item_type, data = data)

summary(anova1) # if p < 0.05, at least one category differs from the others.

tapply(data[["total_sales"]], data[["item_type"]], mean)
# BEER = 82.9, LIQUOR = 14.0, WINE = 10.2
# Beer sells more than liquor and wine.
# This confirms the ANOVA result, Sales change a lot between drink types.

#graph
boxplot(log_sales ~ item_type, data = data,
        col = c("orange", "blue", "red"),
        main = "Sales by drink type",
        xlab = "", ylab = "log sales")
