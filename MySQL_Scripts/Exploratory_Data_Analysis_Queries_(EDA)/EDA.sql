-- EXPLORATORY DATA ANALYSIS
-- 1. Overview of the Dataset
-- 1.1. Summary Statistics
SELECT 
	COUNT(*) AS Total_Records,
    AVG(Quantity) AS Avg_Quantity,
    MIN(Quantity) AS Min_Quantity,
    MAX(Quantity) AS Max_Quantity,
    AVG(UnitPrice_In_Dollars) AS Avg_UnitPrice,
    MIN(UnitPrice_In_Dollars) AS Min_UnitPrice,
    MAX(UnitPrice_In_Dollars) AS Max_UnitPrice,
    AVG(TotalPrice_In_Dollars) AS Avg_TotalPrice,
    MIN(TotalPrice_In_Dollars) AS Min_TotalPrice,
    MAX(TotalPrice_In_Dollars) AS Max_TotalPrice
FROM sales_datac1;

-- 1.2. Data Distribution
-- Quantity
SELECT Quantity, COUNT(*) AS Frequency
FROM sales_datac1
GROUP BY Quantity
ORDER BY Frequency DESC;

-- UnitPrice
SELECT UnitPrice_In_Dollars, COUNT(*) AS Frequency
FROM sales_datac1
GROUP BY UnitPrice_In_Dollars
ORDER BY Frequency DESC;

-- 2. Analyzing Sales Trends
-- 2.1. Sales Over Time
SELECT 
	OrderDate,
    SUM(TotalPrice_In_Dollars) AS Total_Sales
FROM sales_datac1
GROUP BY OrderDate
ORDER BY OrderDate;

-- 2.2. Top Products
SELECT
	ProductName,
    SUM(Quantity) AS Total_Quantity,
    SUM(TotalPrice_In_Dollars) AS Total_Revenue
FROM sales_datac1
GROUP BY ProductName
ORDER BY Total_Revenue DESC
LIMIT 10;

-- 2.3. Sales by Category
SELECT
	ProductCategory,
    SUM(TotalPrice_In_Dollars) AS Total_Revenue
FROM sales_datac1
GROUP BY ProductCategory
ORDER BY Total_Revenue DESC;

-- 3. Geographic Analysis
-- 3.1. Sales by Country
SELECT
	Country,
    SUM(TotalPrice_In_Dollars) AS Total_Revenue
FROM sales_datac1
GROUP BY Country
ORDER BY Total_Revenue DESC;

-- 3.2. Sales by City
SELECT
	City,
    SUM(TotalPrice_In_Dollars) AS Total_Revenue
FROM sales_datac1
GROUP BY City
ORDER BY Total_Revenue DESC;

-- 4. Customer Analysis
-- 4.1. Customer Segmentation
SELECT
	CustomerID,
    SUM(TotalPrice_In_Dollars) AS Total_Spend
FROM sales_datac1
GROUP BY CustomerID
ORDER BY Total_Spend DESC;

-- 4.2. Repeat Customer Vs New Customer
SELECT
	CustomerID,
    COUNT(OrderDate) AS Purchase_Frequency,
    SUM(TotalPrice_In_Dollars) AS Total_Spend
FROM sales_datac1
GROUP BY CustomerID
HAVING Purchase_Frequency > 1
ORDER BY Purchase_Frequency DESC;

-- 5. Channel Performance
-- 5.1. Sales by Channel
SELECT
	Channel,
    SUM(TotalPrice_In_Dollars) AS Total_Revenue
FROM sales_datac1
GROUP BY Channel
ORDER BY Total_Revenue DESC;

-- 5.2. Conversion Rates by Channel
SELECT
	Channel,
    AVG(ConversionRate) AS Avg_ConversionRate
FROM sales_datac1
GROUP BY Channel
ORDER BY Avg_ConversionRate DESC;

-- 6. Correlation Analysis
-- 6.1. Correlation Matrix
SELECT
	(CORR(Quantity, TotalPrice_In_Dollars)) AS Correlation_Quantity_TotalPrice,
    (CORR(Spend, ConversionRate)) AS Correlation_Spend_ConversionRate
FROM sales_datac1;

select * from sales_datac1;

-- 7. SalesPersons
-- 7.1. Performance of SalesPerson
SELECT 
	Salesperson,
    COUNT(*) AS Number_Of_Sales
FROM sales_datac1
GROUP BY Salesperson
ORDER BY Number_Of_Sales DESC;

-- 7.1. Finding the Number of SalesPersons
SELECT
    COUNT(DISTINCT SalesPerson) AS Total_SalesPersons
FROM sales_datac1;

-- 7.2. Total Sales by each SalesPerson
SELECT
	SalesPerson,
    SUM(TotalPrice_In_Dollars) AS Total_Sales_In_Dollars
FROM sales_datac1
GROUP BY Salesperson
ORDER BY Total_Sales_In_Dollars DESC;

-- 7.3. Top Products Sold by each Salesperson
SELECT 
	SalesPerson, 
    ProductName,
    COUNT(*) AS ProductCount
FROM sales_datac1 AS s1
GROUP BY Salesperson, ProductName
HAVING ProductCount = (
	SELECT COUNT(*) AS ProductCount
    FROM sales_datac1 AS s2
    WHERE s2.Salesperson = s1.Salesperson
    GROUP BY s2.Salesperson, s2.ProductName
    LIMIT 1
)
ORDER BY Salesperson, ProductCount DESC;


-- 8. Data Validation
-- 8.1. Validating the Total Price
SELECT 
	Quantity, 
    UnitPrice_In_Dollars, 
    TotalPrice_In_Dollars,
	(Quantity * UnitPrice_In_Dollars) AS Calculated_Total_Price,
CASE
	WHEN TotalPrice_In_Dollars != (Quantity * UnitPrice_In_Dollars) 
		THEN 'Mismatch'
	ELSE
		'Match'
END AS Validation
FROM sales_datac1 LIMIT 10;


-- NOTE: Data Cleaning on ProductName Vs ProductCategory
UPDATE sales_datac1
	SET ProductCategory = CASE
		WHEN ProductName='Aloe Vera' THEN 'Personal Care'
		WHEN ProductName='Kikoy Throw' THEN 'Fashion and Accessories'
		WHEN ProductName='Maasai Shuka' THEN 'Fashion and Accessories'
		WHEN ProductName='Sukuma Wiki' THEN 'Food and Beverages'
		WHEN ProductName='Chai Tea' THEN 'Food and Beverages'
        WHEN ProductName='Kitenge Fabric' THEN 'Fashion and Accessories'
        WHEN ProductName='Wooden Bowls' THEN 'Handicrafts and Home Decor'
        WHEN ProductName='African Hair Care Products' THEN 'Fashion and Accessories'
	ELSE ConversionRate
	END;

-- 9. Products Analysis
-- 9.1. Total Number of Orders Received per product category in Ghana.
SELECT 
	ProductCategory,
    COUNT(*), 
    Country, 
    SUM(Quantity) AS Total_Number_of_Orders
FROM sales_datac1
WHERE Country = 'Ghana'
GROUP BY ProductCategory;

-- 9.2. Total Number of Orders Received per product category in Kenya.
SELECT 
	ProductCategory,
    COUNT(*), 
    Country, 
    SUM(Quantity) AS Total_Number_of_Orders
FROM sales_datac1
WHERE Country = 'Kenya'
GROUP BY ProductCategory;

-- 9.3. Total Number of Orders Received per product category in Tanzania.
SELECT 
	ProductCategory,
    COUNT(*), 
    Country, 
    SUM(Quantity) AS Total_Number_of_Orders
FROM sales_datac1
WHERE Country = 'Tanzania'
GROUP BY ProductCategory;

-- 9.4. Total Number of Orders Received per product category in Angola.
SELECT 
	ProductCategory,
    COUNT(*), 
    Country, 
    SUM(Quantity) AS Total_Number_of_Orders
FROM sales_datac1
WHERE Country = 'Angola'
GROUP BY ProductCategory;

-- 9.5. Total Number of Orders Received per product category in Ethiopia.
SELECT 
	ProductCategory,
    COUNT(*), 
    Country, 
    SUM(Quantity) AS Total_Number_of_Orders
FROM sales_datac1
WHERE Country = 'Ethiopia'
GROUP BY ProductCategory;

-- 9.6. Total Number of Orders Received per product category in Nigeria.
SELECT 
	ProductCategory,
    COUNT(*), 
    Country, 
    SUM(Quantity) AS Total_Number_of_Orders
FROM sales_datac1
WHERE Country = 'Nigeria'
GROUP BY ProductCategory;

-- 9.7. Total Number of Orders Received per product category in Soutn Africa.
SELECT 
	ProductCategory,
    COUNT(*), 
    Country, 
    SUM(Quantity) AS Total_Number_of_Orders
FROM sales_datac1
WHERE Country = 'South Africa'
GROUP BY ProductCategory;

-- 9.8. Distribution of productNames
SELECT
	ProductName,
    COUNT(*) AS Frequency
FROM sales_datac1
GROUP BY ProductName
ORDER BY Frequency DESC;

-- 9.9. Top Products by Total Sales
SELECT 
	ProductName,
	SUM(TotalPrice_In_Dollars) AS TotalSales
FROM sales_datac1
GROUP BY ProductName
ORDER BY TotalSales DESC;

-- 10.0. Top ProductCategory by Total Sales
SELECT 
	ProductCategory,
	SUM(TotalPrice_In_Dollars) AS TotalSales
FROM sales_datac1
GROUP BY ProductCategory
ORDER BY TotalSales DESC;

-- 10. Distribution of Sales by Country. Focuses on Number of Sales Transactions
SELECT 
	Country,
	COUNT(*) AS NumberOfSales
FROM sales_datac1
GROUP BY Country
ORDER BY NumberOfSales DESC;

-- 11. Top Countries by Total Sales. Focuses on the total sales revenue
SELECT 
	Country,
	SUM(TotalPrice_In_Dollars) AS TotalSales
FROM sales_datac1
GROUP BY Country
ORDER BY TotalSales DESC;


-- 12. Analysis on Channel, Leads and ConversionRates.
-- 12.1. Distribution of Sales by Channel
SELECT
	Channel,
    COUNT(*) AS NumberOfSales
FROM sales_datac1
GROUP BY Channel
ORDER BY NumberOfSales DESC;

-- 12.2. Total leads generated by channel
SELECT
	Channel,
    SUM(LeadsGenerated) AS TotalLeads
FROM sales_datac1
GROUP BY Channel
ORDER BY TotalLeads DESC;

-- 12.3. Average conversion rates by channel
SELECT
	Channel,
    AVG(ConversionRate) AS AverageConversionRate
FROM sales_datac1
GROUP BY Channel
ORDER BY AverageConversionRate DESC;

-- 12.4. Top Products by leads generated
SELECT 
	ProductName,
    SUM(LeadsGenerated) AS TotalLeads
FROM sales_datac1
GROUP BY ProductName
ORDER BY TotalLeads DESC;

-- 12.5. Top Products by Conversion Rate
SELECT 
	ProductName,
    AVG(ConversionRate) AS AverageConversionRate
FROM sales_datac1
GROUP BY ProductName
ORDER BY AverageConversionRate DESC;

-- 13. City-Based Analysis
-- 13.1. Distribution of Sales by City
SELECT
	City,
    COUNT(*) AS Numberofsales
FROM sales_datac1
GROUP BY City
ORDER BY Numberofsales DESC;

-- 13.2. Top Cities by sales revenue
SELECT
	City,
    SUM(TotalPrice_In_Dollars) AS Totalsales
FROM sales_datac1
GROUP BY City
ORDER BY Totalsales DESC;
