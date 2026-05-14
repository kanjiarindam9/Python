USE CAPSTONE;

SELECT * FROM black_friday_data;

-- Modifying Data type
ALTER TABLE black_friday_data
MODIFY User_ID INT NOT NULL;

ALTER TABLE black_friday_data
MODIFY Product_ID VARCHAR(9) NOT NULL;

ALTER TABLE black_friday_data
MODIFY Purchase INT NOT NULL CHECK(Purchase>0);

ALTER TABLE black_friday_data
ADD PRIMARY KEY (User_ID, Product_ID); -- COMPOSITE KEY

SET SQL_SAFE_UPDATES=0;
-- Standardizing Stay_In_Current_City_Years
-- Removing the '+' sign to allow for numerical analysis
UPDATE black_friday_data
SET Stay_In_Current_City_Years = REPLACE(Stay_In_Current_City_Years, '+', '');

-- 3. Changing Column Types
-- Convert the stay years to an integer after cleaning
ALTER TABLE black_friday_data 
MODIFY Stay_In_Current_City_Years INT;

-- Handling Null Values in Product Categories
-- Replacing NULLs with 0 to indicate the absence of a secondary/tertiary category
UPDATE black_friday_data 
SET Product_Category_2 = 0 
WHERE Product_Category_2 = '' OR Product_Category_2 IS NULL;

UPDATE black_friday_data 
SET Product_Category_3 = 0 
WHERE Product_Category_3 = '' OR Product_Category_3 IS NULL;

-- Convert Product_Category_1, Product_Category_2, Product_Category_3 to an integer after cleaning 
ALTER TABLE black_friday_data 
MODIFY Product_Category_1 INT;

ALTER TABLE black_friday_data 
MODIFY Product_Category_2 INT;

ALTER TABLE black_friday_data 
MODIFY Product_Category_3 INT;

-- CREATING VIEWS Customer Info (Demographics Dimension)
CREATE VIEW customer_info AS
SELECT DISTINCT 
    User_ID, 
    Gender, 
    Age, 
    Occupation, 
    City_Category, 
    Stay_In_Current_City_Years, 
    Marital_Status
FROM black_friday_data;

-- CREATING VIEWS Product Info (Product Dimension)
CREATE VIEW product_info AS
SELECT DISTINCT 
    Product_ID, 
    Product_Category_1, 
    Product_Category_2, 
    Product_Category_3
FROM black_friday_data;

-- CREATING VIEWS Transaction Data (Sales Fact Table)
CREATE VIEW transaction_data AS
SELECT 
    User_ID, 
    Product_ID, 
    Purchase
FROM black_friday_data;

select * from transaction_data;

-- TOTAL TRANSACTIONS
SELECT COUNT(*) AS Total_transactions FROM black_friday_data;

-- TOTAL CUSTOMERS
SELECT COUNT(DISTINCT User_ID) AS unique_customer_count from black_friday_data;

-- TOTAL UNIQUE PRODUCTS
SELECT COUNT(DISTINCT Product_ID) AS unique_product_count 
FROM black_friday_data;

-- REPEAT PURCHASE
SELECT User_ID, Count(*) AS Repeat_Purchase
FROM black_friday_data
GROUP BY User_ID 
HAVING Count(*)>1
ORDER BY Repeat_Purchase DESC;
