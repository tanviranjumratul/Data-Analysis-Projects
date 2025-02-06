# Superstore Database

## Overview
The `Superstore.sql` file contains a structured dataset for a retail superstore, useful for data analysis and SQL practice. This database includes sales, customers, orders, and product details, making it ideal for business intelligence and reporting tasks.

## Features
- Detailed transaction data including sales, discounts, and profit.
- Customer information with segmentation details.
- Product categories and subcategories.
- Order details including shipping information.

## Installation
1. Ensure you have MySQL or PostgreSQL installed.
2. Clone this repository:
   ```sh
   git clone https://github.com/your-repo/superstore.git
   ```
3. Import the SQL file into your database:
   ```sh
   mysql -u your_user -p your_database < Superstore.sql
   ```
   Or for PostgreSQL:
   ```sh
   psql -U your_user -d your_database -f Superstore.sql
   ```

## SQL Queries
### 1) Retrieve the total sales for each product category.
```sql
SELECT Category, SUM(Sales) AS Total_Sales 
FROM superstore
GROUP BY Category;
```

### 2) Find the top 5 customers who generated the most revenue.
```sql
SELECT `Customer Name`, SUM(Sales) AS Revenue
FROM superstore
GROUP BY `Customer Name`
ORDER BY Revenue DESC
LIMIT 5;
```

### 3) Identify the region with the highest profit.
```sql
SELECT `Region`, SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY `Region`
ORDER BY Total_Profit DESC
LIMIT 1;
```

### 4) Determine the most sold product in terms of quantity.
```sql
SELECT `Product Name`, SUM(Quantity) AS Total_Quantity
FROM superstore
GROUP BY `Product Name`
ORDER BY Total_Quantity DESC
LIMIT 1;
```

### 5) Find the total sales and profit per year.
```sql
SELECT YEAR(`Order Date`) AS Year, 
       SUM(Sales) AS Total_Sales, 
       SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY YEAR(`Order Date`)
ORDER BY Year;
```

### 6) Identify orders with negative profit margins.
```sql
SELECT `Order ID`, `Order Date`, `Customer Name`, `Product Name`, Sales, Profit
FROM superstore
WHERE Profit < 0
ORDER BY Profit ASC;
```

### 7) Find the average order value for each customer segment.
```sql
SELECT `Segment`, 
       AVG(Sales) AS Average_Order_Value
FROM superstore
GROUP BY `Segment`
ORDER BY Average_Order_Value DESC;
```

### 8) Determine the effect of discounts on profit.
```sql
SELECT 
    Discount, 
    COUNT(*) AS Order_Count, 
    SUM(Sales) AS Total_Sales, 
    SUM(Profit) AS Total_Profit, 
    AVG(Profit) AS Avg_Profit
FROM superstore
GROUP BY Discount
ORDER BY Discount ASC;
```

### 9) Identify repeat customers and their total spending.
```sql
SELECT `Customer Name`, 
       COUNT(`Order ID`) AS Order_Count, 
       SUM(Sales) AS Total_Spending
FROM superstore
GROUP BY `Customer Name`
HAVING Order_Count > 1
ORDER BY Total_Spending DESC;
```

### 10) Rank the top 3 products by sales using window functions.
```sql
SELECT 
    `Product Name`,
    SUM(Sales) AS Total_Sales,
    RANK() OVER (ORDER BY SUM(Sales) DESC) AS Sales_Rank
FROM superstore
GROUP BY `Product Name`
ORDER BY Sales_Rank
LIMIT 3;
```

### 11) Find the percentage contribution of each region to total sales.
```sql
SELECT 
    Region,
    SUM(Sales) AS Total_Sales,
    (SUM(Sales) / SUM(SUM(Sales)) OVER ()) * 100 AS Percentage_Contribution
FROM superstore
GROUP BY Region
ORDER BY Total_Sales DESC;
```

### 12) Identify the busiest month for sales.
```sql
SELECT 
    DATE_FORMAT(STR_TO_DATE(`Order Date`, '%m/%d/%Y'), '%Y-%m') AS Month,
    SUM(Sales) AS Total_Sales
FROM superstore
WHERE `Order Date` IS NOT NULL
GROUP BY Month
ORDER BY Total_Sales DESC
LIMIT 1;
```

### 13) Compare sales performance before and after a given date.
```sql
SELECT 
    CASE 
        WHEN `Order Date` < '2022-01-01' THEN 'Before'
        ELSE 'After'
    END AS Period,
    SUM(Sales) AS Total_Sales
FROM superstore
WHERE `Order Date` IS NOT NULL
GROUP BY Period;
```

## Contributions
Feel free to contribute by improving queries, adding new features, or enhancing the dataset. Fork the repository and submit a pull request!

## License
This project is licensed under the MIT License.

