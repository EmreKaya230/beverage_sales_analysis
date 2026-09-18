# Beverage Sales & Distribution Analysis

**Author:** Emre Kaya 


## Introduction
This project analyses the **Warehouse and Retail Sales** dataset from Montgomery County
(data.gov) to understand what shapes beverage sales and how products are distributed across
retail and wholesale channels. The goal is to support **inventory and distribution planning**
with data-driven decisions instead of guessing.

## Business Questions
| # | Question | Test |
|---|----------|------|
| Q1 | What predicts warehouse sales volume? | Multiple linear regression |
| Q2 | Is the channel related to product category? | Chi square |
| Q3 | Are sales different for each drink type? | ANOVA |

All tests use a significance level of alpha = 0.05.

## Data
- **Source:** Montgomery County Warehouse and Retail Sales data.gov
  https://catalog.data.gov/dataset/warehouse-and-retail-sales
- **Raw:** 341,037 rows x 9 columns -> **after cleaning + feature engineering:** 322,966 rows x 12 columns
- Cleaning: filled missing sales with 0, dropped missing item_type, filled supplier with "unknown",
  kept only wine/liquor/beer. Feature engineering: season, total_sales, channel.

## How to run
1. Open `beverage_sales_analysis.Rproj` in RStudio.
2. Install packages: `install.packages(c("car","lmtest"))`
3. Run the scripts in order:
   - `01_cleaning.R` — cleaning, feature engineering, sampling
   - `02_eda.R` — descriptive statistics + plots
   - `03_business_questions.R` — regression, chi-square, ANOVA

## Key findings
- **Beer sells the most** on average (82.9), far above liquor (14.0) and wine (10.2).
  Beer is a fast-selling, high volume product (chi-square and ANOVA both p < 0.001).
- **Channel and product category are strongly related** (chi-square, X-squared = 109,605, p < 0.001) 
  the drink type affects whether it sells more in retail or wholesale.
- **Warehouse sales are driven mainly by category and retail sales** (regression, adj R2 = 0.31);
  higher retail sales go with higher warehouse sales.

## Limitations
Regression residuals are not normal (many zeros in warehouse sales), and the very large sample
(approx. 323,000 rows) makes almost everything significant, so effect sizes were considered alongside
p-values. Results show relationships, not cause and effect.

## Author
Emre Kaya 
