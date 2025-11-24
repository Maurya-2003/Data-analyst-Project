CREATE DATABASE sales_data;
USE sales_data;
SELECT * FROM data_set;

-- 1. find the total country in which company is selling its product
SELECT COUNT(DISTINCT(Country)) as total_country
FROM data_set;

-- 2. Total Sales Revenue
SELECT SUM(`Total Revenue`) AS Total_Sales_Revenue
FROM data_set;

-- 3. Sales by Region
SELECT Region, SUM(`Total Revenue`) AS Revenue
FROM data_set
GROUP BY Region
ORDER BY Revenue DESC;

-- 4. Profit by Country
SELECT Country, SUM(`Total Profit`) AS Profit
FROM data_set
GROUP BY Country
ORDER BY Profit DESC;
 
-- 5. Best Selling Item Type (by Units Sold)
SELECT `Item Type`, SUM(`Units Sold`) AS Total_Units
FROM data_set
GROUP BY `Item Type`
ORDER BY Total_Units DESC; 

-- 6. Highest Revenue Item Type
SELECT `Item Type`, SUM(`Total Revenue`) AS Revenue
FROM data_set
GROUP BY `Item Type`
ORDER BY Revenue DESC;

-- 7. Sales Channel Performance
SELECT `Sales Channel`, SUM(`Total Revenue`) AS Revenue
FROM data_set
GROUP BY `Sales Channel`; 

-- 8. Average Order Value
SELECT AVG(`Total Revenue`) AS Avg_Order_Value
FROM data_set; 

-- 9. Orders by Priority
SELECT `Order Priority`, COUNT(*) AS Total_Orders
FROM data_set
GROUP BY `Order Priority`;

-- 10. Monthly Sales Trend
SELECT 
    MONTH(`Order Date`) AS Month,
    SUM(`Total Revenue`) AS Revenue
FROM data_set
WHERE `Order Date` IS NOT NULL
GROUP BY MONTH(`Order Date`)
ORDER BY Month;

-- 11. Most Profitable Orders
SELECT `Order ID`, `Total Profit`
FROM data_set
ORDER BY `Total Profit` DESC
LIMIT 10;

-- 12. Profit Margin per Order
SELECT 
    `Order ID`,
    (`Total Profit` / `Total Revenue`) * 100 AS Profit_Margin_Percent
FROM data_set;


-- 13. Region-wise Sales Channel Preference
SELECT 
    Region,
    `Sales Channel`,
    COUNT(*) AS `Order Count`
FROM data_set
GROUP BY Region, `Sales Channel`
ORDER BY Region;







 
 



