-- Question one
-- soln: using postgresql that supports unnested and string_to_array
-- string_to_array function splits a comma separated list into array of values
-- unnested takes an array of values and expands it into multiple rows, one row per array element
-- Trim then removes extra white spaces around each element

SELECT 
    OrderID,
    CustomerName,
    TRIM(unnested_product) AS Product
FROM (
    SELECT 
        OrderID,
        CustomerName,
        unnest(string_to_array(Products, ',')) AS unnested_product
    FROM ProductDetail
) AS expanded;

-- Question 2
-- Ensure that all non-key elements depend only on the primary key
-- Primary keys in this case are product and order id
-- customer name only depends on the order id
-- we therefore split the table into two orders and orderItems

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;