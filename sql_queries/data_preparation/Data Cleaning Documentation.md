# 🧹 Data Cleaning Documentation

This document outlines the data cleaning steps applied to TheLook e-commerce dataset before performing any analysis.



## ✅ Null Value Checks

### orders and order_items tables:

- **Fields checked**: `order_id`, `user_id`, `status`
- **Result**: No null values found.

## ✅ Filtering Invalid Entries

### orders and order_items tables:

- Joined `orders` and `order_items` tables using `order_id`.
- Removed records where:
    - `num_of_item` ≤ 0
    - `sale_price` ≤ 0
- **Result**: No rows removed.

## ✅ Duplicate Detection

### orders and order_items tables:

- Checked for duplicates based on:
    - `order_id`, `product_id`, `num_of_item`
- **Condition**: Only rows where `status`='Complete'
- **Result**: One duplicate detected and removed using the `ROW_NUMBER()` function.

=> These datasets serve as the input for exploratory analysis, cohort tracking, and sales performance evaluation.
