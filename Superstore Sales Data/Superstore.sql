select * from mydb.superstore;
use mydb;

#1) Retrieve the total sales for each product category.
select Category,sum(Sales) as Total_Sales 
from superstore
group by Category;


#2) Find the top 5 customers who generated the most revenue.
SELECT `Customer Name`, SUM(Sales) AS Revenue
FROM superstore
GROUP BY `Customer Name`
ORDER BY Revenue DESC
LIMIT 5;


#3) Identify the region with the highest profit.
SELECT `Region`, SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY `Region`
ORDER BY Total_Profit DESC
LIMIT 1;


#4) Determine the most sold product in terms of quantity.
SELECT `Product Name`, SUM(Quantity) AS Total_Quantity
FROM superstore
GROUP BY `Product Name`
ORDER BY Total_Quantity DESC
LIMIT 1;



#5) Find the total sales and profit per year.
SELECT YEAR(`Order Date`) AS Year, 
       SUM(Sales) AS Total_Sales, 
       SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY YEAR(`Order Date`)
ORDER BY Year;



#6) Identify orders with negative profit margins.
SELECT `Order ID`, `Order Date`, `Customer Name`, `Product Name`, Sales, Profit
FROM superstore
WHERE Profit < 0
ORDER BY Profit ASC;



#7) Find the average order value for each customer segment.
SELECT `Segment`, 
       AVG(Sales) AS Average_Order_Value
FROM superstore
GROUP BY `Segment`
ORDER BY Average_Order_Value DESC;


#8) Determine the effect of discounts on profit.
SELECT 
    Discount, 
    COUNT(*) AS Order_Count, 
    SUM(Sales) AS Total_Sales, 
    SUM(Profit) AS Total_Profit, 
    AVG(Profit) AS Avg_Profit
FROM superstore
GROUP BY Discount
ORDER BY Discount ASC;


#9) Identify repeat customers and their total spending.
SELECT `Customer Name`, 
       COUNT(`Order ID`) AS Order_Count, 
       SUM(Sales) AS Total_Spending
FROM superstore
GROUP BY `Customer Name`
HAVING Order_Count > 1
ORDER BY Total_Spending DESC;



#10) Rank the top 3 products by sales using window functions.
SELECT 
    `Product Name`,
    SUM(Sales) AS Total_Sales,
    RANK() OVER (ORDER BY SUM(Sales) DESC) AS Sales_Rank
FROM superstore
GROUP BY `Product Name`
ORDER BY Sales_Rank
LIMIT 3;


#11) Find the percentage contribution of each region to total sales.
SELECT 
    Region,
    SUM(Sales) AS Total_Sales,
    (SUM(Sales) / SUM(SUM(Sales)) OVER ()) * 100 AS Percentage_Contribution
FROM superstore
GROUP BY Region
ORDER BY Total_Sales DESC;


#12) Identify the busiest month for sales.
SELECT 
    DATE_FORMAT(STR_TO_DATE(`Order Date`, '%m/%d/%Y'), '%Y-%m') AS Month,
    SUM(Sales) AS Total_Sales
FROM superstore
WHERE `Order Date` IS NOT NULL
GROUP BY Month
ORDER BY Total_Sales DESC
LIMIT 1;



#13) Compare sales performance before and after a given date.
SELECT 
    CASE 
        WHEN `Order Date` < '2022-01-01' THEN 'Before'
        ELSE 'After'
    END AS Period,
    SUM(Sales) AS Total_Sales
FROM superstore
WHERE `Order Date` IS NOT NULL
GROUP BY Period;




