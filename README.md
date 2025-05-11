# 🛍️ Apparel-E-commerce-EDA-Customer-Retention-Analysis

## 1. Objective
This project explores customer behavior, sales trends, and cohort analysis of TheLook, an e-commerce website selling clothes, from January 2022 to January 2025 by using SQL (BigQuery) and Excel. It covers exploratory data analysis (EDA) to solve ad-hoc tasks and customer cohort-based retention analysis to uncover spending patterns and retention trends across customer groups, supporting long-term engagement strategies.

## 2. Tools used
- SQL (BigQuery): Used for data cleaning and analysis
- Excel: Used for data visualization

## 3. Repository Structure

```
thelook-ecommerce/
├── sql_queries/                        # All SQL analysis scripts
│   ├── 01_data_preparation/            # Data preparation queries
│   ├── 02_exploratory_analysis/        # Initial investigations
│   └── 03_customer_retention_cohort_analysis.sql
├── outputs/                            # Query results (CSV/XLSX)
│   ├── exploratory/      
│   └── retention_cohort.xlsx
├── insights/                           # Insights and Recommendations
│   ├── 01_exploratory_analysis.md
│   ├── 02_customer_retention_cohort_analysis.md
└── README.md                           # Project documentation
```

## 4. How to Navigate This Analysis

1. **Data Preparation**: See `/sql_queries/data_preparation/`
2. **Run Analyses**: SQL scripts in `/sql_queries/`
3. **View Results**:
    - Raw outputs: `/outputs/`
    - Insights: `/insights/`
  
## 5. Technical Implementation

### Data Pipeline
```mermaid
graph LR
    A[Raw Data] --> B[Data Cleaning]
    B --> C[Exploratory Analysis]
    C --> D[Business Insights]
    D --> E[Visualization]
```


## 6. Key Findings Summary

- The platform has a sustained growth, providing a foundation for future expansion and operational scaling.
- Average Order Value has no correlation with user growth. The ecommerce platform needs to focus on strategies to drive more revenue per customer, such as testing targeted promotions or campaigns.
- The youngest and oldest age groups show a relatively balanced gender distribution, indicating no significant gender bias within these segments. While these edge groups show **interesting demographic skews**, these groups are not substantial enough to drive **major strategic decisions**.
- Top-performing products: products in Outerwear & Coats and Active categories maintain top-3 position during 3 years.
- Customer retention rate has been consistently low and stagnant, indicating most users do not return after their first purchase. This requires further analysis for more tailored strategies.


## 7. Core SQL Techniques
- Window functions (`RANK()`, `LAG()`), Aggregate functions, Join, Case-When
- Cohort analysis with date bucketing
