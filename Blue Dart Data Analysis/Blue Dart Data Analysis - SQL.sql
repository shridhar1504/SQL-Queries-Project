--- OVER-VIEWING THE DATA
SELECT * FROM ORDER_DETAILS
SELECT * FROM ORDERS
SELECT * FROM PRODUCTS
SELECT * FROM SHIPPERS
SELECT * FROM SUPPLIERS
SELECT * FROM CATEGORIES
SELECT * FROM EMPLOYEE_DETAILS

--- TOTAL REVENUE
SELECT FORMAT(SUM(OD.QUANTITY * P.PRICE),'C','EN-US') AS TOTAL_REVENUE
FROM ORDER_DETAILS AS OD JOIN PRODUCTS AS P ON OD.PRODUCTID = P.PRODUCTID 

--- TOTAL ORDERS
SELECT COUNT(ORDERID) AS TOTAL_ORDERS FROM ORDER_DETAILS 

--- TOTAL QUANTITY
SELECT SUM(QUANTITY) AS TOTAL_QUANTITY FROM ORDER_DETAILS

--- SHOWCASING EMPLOYEES NAME, EMPLOYEE ID, QUALIFICATION BY THEIR AGE
SELECT NAME, EMPLOYEEID, AGE, QUALIFICATION FROM EMPLOYEE_DETAILS ORDER BY AGE

--- SHOWCASING SHIPPERS NAME, RATE, CARRIER TYPE, SERVICE COVERAGE
SELECT SHIPPERSNAME, [RATES ], [CARRIER TYPE], [SERVICE COVERAGE] FROM SHIPPERS

--- VIEWING SUPPLIERS COUNT BY COUNTRY
SELECT COUNTRY, COUNT(SUPPLIERID) AS TOTAL_SUPPLIERS FROM SUPPLIERS GROUP BY COUNTRY

--- REVENUE BY EACH YEAR
SELECT DATEPART(YEAR,O.ORDERDATE) AS YEAR,
FORMAT(SUM(OD.QUANTITY * P.PRICE),'C','EN-US') AS TOTAL_REVENUE
FROM ORDER_DETAILS AS OD JOIN ORDERS AS O ON OD.ORDERID = O.ORDERID
JOIN PRODUCTS AS P ON OD.PRODUCTID = P.PRODUCTID
GROUP BY DATEPART(YEAR,O.ORDERDATE)
ORDER BY YEAR

--- REVENUE BY EACH QUARTER FOR EVERY YEAR
SELECT SQ.YEAR, 
FORMAT(SUM(CASE WHEN SQ.YEAR_QUARTER = 1 THEN SQ.TOTAL_REVENUE ELSE 0 END),'C','EN-US') AS Q1_REVENUE,
FORMAT(SUM(CASE WHEN SQ.YEAR_QUARTER = 2 THEN SQ.TOTAL_REVENUE ELSE 0 END),'C','EN-US') AS Q2_REVENUE,
FORMAT(SUM(CASE WHEN SQ.YEAR_QUARTER = 3 THEN SQ.TOTAL_REVENUE ELSE 0 END),'C','EN-US') AS Q3_REVENUE,
FORMAT(SUM(CASE WHEN SQ.YEAR_QUARTER = 4 THEN SQ.TOTAL_REVENUE ELSE 0 END),'C','EN-US') AS Q4_REVENUE
FROM(SELECT DATEPART(YEAR,O.ORDERDATE) AS YEAR,
DATEPART(QUARTER,O.ORDERDATE) AS YEAR_QUARTER,
SUM(OD.QUANTITY * P.PRICE) AS TOTAL_REVENUE
FROM ORDER_DETAILS AS OD JOIN ORDERS AS O ON OD.ORDERID = O.ORDERID
JOIN PRODUCTS AS P ON OD.PRODUCTID = P.PRODUCTID
GROUP BY DATEPART(YEAR,O.ORDERDATE),DATEPART(QUARTER,O.ORDERDATE)) AS SQ
GROUP BY SQ.YEAR
ORDER BY SQ.YEAR

--- TOP 5 PRODUCTS SOLD BY QUANTITY
SELECT TOP 5 OD.PRODUCTID, P.PRODUCTNAME, SUM(OD.QUANTITY) AS TOTAL_QUANTITY
FROM ORDER_DETAILS AS OD JOIN PRODUCTS AS P ON OD.PRODUCTID = P.PRODUCTID
GROUP BY OD.PRODUCTID, P.PRODUCTNAME
ORDER BY TOTAL_QUANTITY DESC

--- BOTTOM 5 PRODUCTS SOLD BY QUANTITY
SELECT TOP 5 OD.PRODUCTID, P.PRODUCTNAME, SUM(OD.QUANTITY) AS TOTAL_QUANTITY
FROM ORDER_DETAILS AS OD JOIN PRODUCTS AS P ON OD.PRODUCTID = P.PRODUCTID
GROUP BY OD.PRODUCTID, P.PRODUCTNAME
ORDER BY TOTAL_QUANTITY

--- 5 HIGH REVENUE GENERATED PRODUCTS
SELECT TOP 5 OD.PRODUCTID, P.PRODUCTNAME, 
FORMAT(SUM(OD.QUANTITY * P.PRICE),'C','EN-US') AS TOTAL_REVENUE
FROM ORDER_DETAILS AS OD JOIN PRODUCTS AS P ON OD.PRODUCTID = P.PRODUCTID
GROUP BY OD.PRODUCTID, P.PRODUCTNAME
ORDER BY SUM(OD.QUANTITY * P.PRICE) DESC

--- 5 LOW REVENUE GENERATED PRODUCTS
SELECT TOP 5 OD.PRODUCTID, P.PRODUCTNAME, 
FORMAT(SUM(OD.QUANTITY * P.PRICE),'C','EN-US') AS TOTAL_REVENUE
FROM ORDER_DETAILS AS OD JOIN PRODUCTS AS P ON OD.PRODUCTID = P.PRODUCTID
GROUP BY OD.PRODUCTID, P.PRODUCTNAME
ORDER BY SUM(OD.QUANTITY * P.PRICE)

--- 5 MOST ORDERED PRODUCTS
SELECT TOP 5 OD.PRODUCTID, P.PRODUCTNAME, COUNT(OD.ORDERID)AS TOTAL_ORDERS
FROM ORDER_DETAILS AS OD JOIN PRODUCTS AS P ON OD.PRODUCTID = P.PRODUCTID
GROUP BY OD.PRODUCTID, P.PRODUCTNAME
ORDER BY TOTAL_ORDERS DESC

--- 5 LEAST ORDERED PRODUCTS
SELECT TOP 5 OD.PRODUCTID, P.PRODUCTNAME, COUNT(OD.ORDERID)AS TOTAL_ORDERS
FROM ORDER_DETAILS AS OD JOIN PRODUCTS AS P ON OD.PRODUCTID = P.PRODUCTID
GROUP BY OD.PRODUCTID, P.PRODUCTNAME
ORDER BY TOTAL_ORDERS

--- SALES BY CATEGORY
SELECT P.CATEGORYID, C.CATEGORYNAME, COUNT(OD.ORDERID) AS TOTAL_ORDERS,
FORMAT(SUM(OD.QUANTITY * P.PRICE),'C','EN-US') AS TOTAL_REVENUE
FROM ORDER_DETAILS AS OD JOIN PRODUCTS AS P ON OD.PRODUCTID = P.PRODUCTID
JOIN CATEGORIES AS C ON P.CATEGORYID = C.CATEGORYID
GROUP BY P.CATEGORYID, C.CATEGORYNAME
ORDER BY TOTAL_ORDERS

--- MOST USED PAYMENT METHOD
SELECT O.[PAYMENT MODE], COUNT(O.[PAYMENT MODE]) AS NO_OF_PAYMENTS
FROM ORDER_DETAILS AS OD JOIN ORDERS AS O ON OD.ORDERID = O.ORDERID
GROUP BY O.[PAYMENT MODE]
ORDER BY NO_OF_PAYMENTS DESC