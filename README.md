# Nashville Housing Data Cleaning Project

This project focuses on cleaning and preparing housing market data from **Nashville, Tennessee** using **MySQL** and **Excel**.  
The goal was to transform raw housing records into a clean, reliable dataset suitable for further analysis or visualization.

---

## Tools Used
- **Microsoft Excel** – for initial data preparation (formatting, blank-to-NULL conversion)
- **MySQL Workbench** – for importing, cleaning, and transforming data using SQL queries

---

## Project Workflow

1. **Data Preparation in Excel**
   - Loaded the raw dataset into Excel.
   - Converted all blank cells into `NULL` to prevent import errors.
   - Saved the file as a `.csv` for easy import into MySQL.

2. **Data Import**
   - Used **MySQL Table Import Wizard** to load the dataset into a new table.

3. **Data Cleaning in SQL**
   The cleaning process included:
   - **Handling NULL values** to ensure consistency.
   - **Removing duplicate records** based on unique combinations of key fields.
   - **Standardizing date formats** (e.g., converting `SaleDate` to proper `DATE` type).
   - **Breaking down composite fields** (e.g., separating `Address` into `Address`, `City`, `State`).
   - **Normalizing data** to improve readability and relational structure.
   - **Populating missing values** where logical relationships could be inferred.

4. **Verification**
   - Cross-checked record counts before and after cleaning to ensure no data loss.
   - Performed random spot checks to confirm successful transformations.

---

## Key SQL Operations

Some highlights from the SQL script (`Nashville data cleaning project.sql`):

```sql
-- Example: Standardize date format
UPDATE nashville_housing
SET SaleDate = STR_TO_DATE(SaleDate, '%M %d, %Y');

-- Example: Remove duplicates
DELETE n1 FROM nashville_housing n1
JOIN nashville_housing n2 
ON n1.ParcelID = n2.ParcelID AND n1.UniqueID > n2.UniqueID;

-- Example: Split property address
UPDATE nashville_housing
SET PropertyAddress = TRIM(SUBSTRING_INDEX(PropertyAddress, ',', 1)),
    City = TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1));
---
```

## Outcomes

- Produced a **clean, consistent dataset** free from duplicates and structural issues.
- Improved data reliability for future analytical or visualization work (e.g., Tableau, Power BI).
- Strengthened SQL proficiency in handling real-world messy data.

## What I Learned

- How to integrate Excel preprocessing with SQL-based data cleaning.
- Handling import issues and NULL values during data ingestion.
- Writing structured, step-by-step SQL queries to clean and normalize large datasets.

Data Analytics Journey 2025
