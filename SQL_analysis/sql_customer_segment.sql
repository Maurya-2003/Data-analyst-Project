CREATE DATABASE sentiment;
USE sentiment;

CREATE TABLE customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100),
    Age INT,
    Gender VARCHAR(10),
    Region VARCHAR(50),
    Total_Spend DECIMAL(10,2),
    Orders_Count INT,
    Last_Purchase_Date DATE,
    Loyalty_Score INT
);

INSERT INTO customers VALUES
(1, 'Rahul Sharma', 25, 'Male', 'North', 12000, 5, '2024-11-12', 60),
(2, 'Anita Verma', 32, 'Female', 'South', 45000, 12, '2024-12-01', 85),
(3, 'Amit Singh', 45, 'Male', 'West', 8000, 3, '2024-09-15', 40),
(4, 'Neha Gupta', 29, 'Female', 'East', 22000, 7, '2024-11-28', 70),
(5, 'Rohit Kumar', 38, 'Male', 'North', 60000, 15, '2024-12-05', 95),
(6, 'Priya Das', 22, 'Female', 'South', 4000, 2, '2024-08-10', 25),
(7, 'Sanjay Patel', 50, 'Male', 'West', 30000, 10, '2024-10-20', 78),
(8, 'Kavita Iyer', 35, 'Female', 'South', 52000, 13, '2024-12-08', 90),
(9, 'Arjun Mehta', 28, 'Male', 'East', 15000, 6, '2024-11-02', 65),
(10, 'Simran Kaur', 41, 'Female', 'North', 9000, 4, '2024-09-30', 50); 


SELECT COUNT(*) AS Total_Customers
FROM customers;

SELECT AVG(Total_Spend) AS Avg_Spend
FROM customers;

SELECT Customer_Name, Total_Spend
FROM customers
WHERE Total_Spend > 40000; 

SELECT Region, COUNT(*) AS Customer_Count
FROM customers
GROUP BY Region; 

SELECT Customer_Name, Total_Spend
FROM customers
ORDER BY Total_Spend DESC
LIMIT 5; 


-- Segmentation by Age Group
SELECT
CASE
    WHEN Age < 25 THEN 'Young'
    WHEN Age BETWEEN 25 AND 40 THEN 'Adult'
    ELSE 'Senior'
END AS Age_Group,
COUNT(*) AS Total_Customers
FROM customers
GROUP BY Age_Group;


SELECT Customer_Name, Loyalty_Score
FROM customers
WHERE Loyalty_Score > 80;

SELECT Customer_Name, Total_Spend, Loyalty_Score
FROM customers
WHERE Total_Spend < 10000 AND Loyalty_Score < 50; 

SELECT Region, AVG(Orders_Count) AS Avg_Orders
FROM customers
GROUP BY Region;
  
-- Recent Active Customers (Last 30 Days)  
SELECT Customer_Name, Last_Purchase_Date
FROM customers
WHERE Last_Purchase_Date >= CURDATE() - INTERVAL 30 DAY;  
 
-- Customer Value Segmentation
SELECT Customer_Name,
CASE
    WHEN Total_Spend > 40000 THEN 'Premium'
    WHEN Total_Spend BETWEEN 15000 AND 40000 THEN 'Regular'
    ELSE 'Basic'
END AS Customer_Segment
FROM customers;  

-- Top Region by Total Spend
SELECT Region, SUM(Total_Spend) AS Region_Revenue
FROM customers
GROUP BY Region
ORDER BY Region_Revenue DESC
LIMIT 1;

-- Customer Lifetime Value (CLV Approximation)
SELECT 
Customer_Name,
(Total_Spend / Orders_Count) * Loyalty_Score AS Estimated_CLV
FROM customers;


  









