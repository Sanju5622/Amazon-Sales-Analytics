use sales_report;

CREATE TABLE sales (
    Order_index INT PRIMARY KEY,
    Order_ID VARCHAR(50),
    Date DATETIME,
    Year INT,
    Month VARCHAR(20),
    Month_Number INT,
    Quarter VARCHAR(5),
    Day_name VARCHAR(20),
    Status VARCHAR(100),
    Status_Group VARCHAR(100),
    Fulfilment VARCHAR(50),
    Sales_Channel VARCHAR(50),
    `ship-service-level` VARCHAR(50),
    Style VARCHAR(100),
    SKU VARCHAR(100),
    Category VARCHAR(50),
    Size VARCHAR(20),
    ASIN VARCHAR(20),
    `Courier Status` VARCHAR(100),
    Courier_Final_Status VARCHAR(100),
    Qty INT,
    currency VARCHAR(10),
    Amount DOUBLE,
    `ship-city` VARCHAR(100),
    `ship-state` VARCHAR(100),
    `ship-postal-code` INT,
    `ship-country` VARCHAR(100),
    `promotion-ids` TEXT,
    B2B VARCHAR(10),
    `fulfilled-by` VARCHAR(50),
    Fulfilled_by VARCHAR(50)
);


LOAD DATA LOCAL INFILE 'C:/Users/HP/Downloads/Sales.csv'
INTO TABLE sales
CHARACTER SET latin1
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


// total records
Select Count(*) from sales;

//Total Order count

Select count(Order_ID) as Total_Orders from sales;

//Total revenue

Select round(sum(Amount),0) as Total_Revenue from sales;

//Revenue by Category

Select Category, round(sum(Amount),0) as Revenue from sales 
group by Category order by Revenue desc;

//Top 10 States by Sales

Select `ship-state`, round(sum(Amount),0) as Revenue_by_State from sales 
group by `ship-state` order by Revenue_by_State desc 
limit 10;

//Monthly Sales

SELECT Month,
       ROUND(SUM(Amount),0) AS Monthly_Sales
FROM sales
GROUP BY Month, Month_Number
ORDER BY Month_Number;

//Order Status Count

Select `Status`, Status_Group,count(*) as Orders from sales
group by `Status`,Status_Group order by Orders desc;

//Revenue by Year and Quarter

Select Year, round(sum(Amount),0) as Revenue from sales
group by Year order by Revenue;


//Top 10 products

SELECT SKU,
       Category,
       ROUND(SUM(Amount),0) AS Revenue
FROM sales
GROUP BY SKU, Category
ORDER BY Revenue DESC
LIMIT 10;

//Top 10 Cities by Sales

Select `ship-city`, round(sum(Amount),0) as Revenue_by_City from sales 
group by `ship-city` order by Revenue_by_City desc 
limit 10;

//Category wise Quantity sold

Select Category, sum(Qty) as Quantity, round(sum(Amount),0) as Quantity_wise_Sales from sales
group by Category order by Quantity_wise_Sales;

//window Function 

WITH StateRevenue AS
(
    SELECT
        `ship-state`,
        ROUND(SUM(Amount),0) AS Revenue
    FROM sales
    GROUP BY `ship-state`
)
SELECT *,
       RANK() OVER(ORDER BY Revenue DESC) AS rnk
FROM StateRevenue;


WITH StateRevenue AS
(
    SELECT
        `ship-city`,
        ROUND(SUM(Amount),0) AS Revenue
    FROM sales
    GROUP BY `ship-city`
)

SELECT *,
       RANK() OVER(ORDER BY Revenue DESC) AS rnk
FROM StateRevenue limit 10;

//Monthly Revenue Analysis

WITH MonthlySales AS
(
    SELECT
        Month_Number,
        Month,
        ROUND(SUM(Amount),0) AS Revenue
    FROM sales
    GROUP BY Month_Number, Month
)

SELECT
    Month,
    Revenue,
    LAG(Revenue) OVER(ORDER BY Month_Number) AS Previous_Month_Revenue
FROM MonthlySales;


//Average State Revenue


WITH StateRevenue AS
(
    SELECT
        `ship-state`,
        ROUND(SUM(Amount),0) AS Revenue
    FROM sales
    GROUP BY `ship-state`
)

SELECT
    `ship-state`,
    Revenue,
    ROUND(AVG(Revenue) OVER(),0) AS Average_Revenue
FROM StateRevenue;
