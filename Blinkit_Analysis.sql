DROP TABLE IF EXISTS Blinkit_Data;
CREATE TABLE Blinkit_Data(
Item_Fat_Content VARCHAR(50),
Item_Identifier VARCHAR(50),
Item_Type VARCHAR(50),
Outlet_Establishment_Year INT,
Outlet_Identifier VARCHAR(50),
Outlet_Location_Type VARCHAR(50),
Outlet_Size VARCHAR(50),
Outlet_Type VARCHAR(50),
Item_Visibility	NUMERIC(10,9),
Item_Weight NUMERIC(10,3),
Sales NUMERIC(10,4),
Rating FLOAT);

SELECT * FROM Blinkit_Data;

UPDATE Blinkit_Data
SET Item_Fat_Content=
CASE 
WHEN Item_Fat_Content IN ('LF','low fat') THEN 'Low Fat'
WHEN Item_Fat_Content ='reg' THEN 'Regular'
ELSE Item_Fat_Content
END

SELECT DISTINCT Item_Fat_Content FROM Blinkit_Data;

--Sum of Sales
SELECT CAST(SUM(Sales)/1000000 AS DECIMAL(10,2)) AS Total_sales_millions
FROM Blinkit_Data;

--Avg Sales
SELECT CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_sales
FROM Blinkit_Data;

--Number of items
SELECT COUNT(*) AS No_of_sales
FROM Blinkit_Data;

--Average Ratings
SELECT CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_rating
FROM Blinkit_Data;

--GRANULAR REQIREMENT

--1) Total sales by fat content
SELECT Item_Fat_Content,CAST(SUM(Sales)/1000 AS DECIMAL(10,2)) AS Total_sales_thousands,
                        CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_sales,
						COUNT(*) AS No_of_sales,
						CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_rating
FROM Blinkit_Data
GROUP BY Item_Fat_Content
ORDER BY Total_sales_thousands DESC;

--2) Total sales by item type
SELECT Item_Type,CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_sales,
                 CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_sales,
				 COUNT(*) AS No_of_sales,
			     CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_rating       
FROM Blinkit_Data
GROUP BY Item_Type
ORDER BY Total_sales DESC
LIMIT 5;


-- 3)Fat content by outlet for total sales
SELECT Outlet_Location_Type, Item_Fat_Content,CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_sales									            
FROM Blinkit_Data
GROUP BY Outlet_Location_Type, Item_Fat_Content
ORDER BY Total_sales DESC
LIMIT 5;


--4)Total sales by outlet estalishment
SELECT Outlet_Establishment_Year,CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_sales,
                                 CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_sales,
								 COUNT(*) AS No_of_sales,
							     CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_rating     
FROM Blinkit_Data
GROUP BY Outlet_Establishment_Year
ORDER BY Total_sales DESC;


--CHART REQUIREMENTS

--1)Percentage of sales by outlet size
SELECT Outlet_Size,
       CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_sales,
	   CAST(SUM(sales)*100.0/SUM(SUM(Sales)) OVER() AS DECIMAL(10,2)) AS Sales_percentage
FROM Blinkit_Data
GROUP BY Outlet_Size
ORDER BY Total_sales DESC;

--2)Sales by outlet location
SELECT Outlet_Location_Type,CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_sales,
                            CAST(SUM(sales)*100.0/SUM(SUM(Sales)) OVER() AS DECIMAL(10,2)) AS Sales_percentage,
                            CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_sales,
						    COUNT(*) AS No_of_sales,
							CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_rating          
FROM Blinkit_Data
GROUP BY Outlet_Location_Type
ORDER BY Total_sales DESC;

--3)All metrics by outlet type
SELECT Outlet_Type,CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_sales,
                            CAST(SUM(sales)*100.0/SUM(SUM(Sales)) OVER() AS DECIMAL(10,2)) AS Sales_percentage,
                            CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_sales,
						    COUNT(*) AS No_of_sales,
							CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_rating          
FROM Blinkit_Data
GROUP BY Outlet_Type
ORDER BY Total_sales DESC;
