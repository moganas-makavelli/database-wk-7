--Question 1: Achieving 1NF (First Normal Form

--first create the Unnormalized table
-- Drop the table if it already exists to allow for a clean run
DROP TABLE IF EXISTS ProductDetail;

-- Create the un-normalized ProductDetail table
CREATE TABLE ProductDetail (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255),
    Products VARCHAR(255)
);

-- Insert the sample data as provided in the assignment
-- The 'Products' column contains multiple, comma-separated values,
-- which violates First Normal Form (1NF).
INSERT INTO ProductDetail (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Query the table to show the un-normalized data
SELECT * FROM ProductDetail;


--second normalize the table
SELECT OrderID, CustomerName, 'Laptop' AS Product
FROM ProductDetail
WHERE Products LIKE '%Laptop%'
UNION ALL
SELECT OrderID, CustomerName, 'Mouse' AS Product
FROM ProductDetail
WHERE Products LIKE '%Mouse%'
UNION ALL
SELECT OrderID, CustomerName, 'Tablet' AS Product
FROM ProductDetail
WHERE Products LIKE '%Tablet%'
UNION ALL
SELECT OrderID, CustomerName, 'Keyboard' AS Product
FROM ProductDetail
WHERE Products LIKE '%Keyboard%'
UNION ALL
SELECT OrderID, CustomerName, 'Phone' AS Product
FROM ProductDetail
WHERE Products LIKE '%Phone%';



-- Question 2: Achieving 2NF (Second Normal Form)
         -- Drop tables if they exist to ensure a clean slate for the script
                        DROP TABLE IF EXISTS OrderItems;
                        DROP TABLE IF EXISTS Orders;
                        
                        -- This is the original un-normalized table (already in 1NF)
                        -- For demonstration purposes, we'll create it first
                        -- and then normalize it.
                        CREATE TABLE OrderDetails (
                            OrderID INT,
                            CustomerName VARCHAR(255),
                            Product VARCHAR(255),
                            Quantity INT
                        );
                        
                        INSERT INTO OrderDetails (OrderID, CustomerName, Product, Quantity) VALUES
                        (101, 'John Doe', 'Laptop', 2),
                        (101, 'John Doe', 'Mouse', 1),
                        (102, 'Jane Smith', 'Tablet', 3),
                        (102, 'Jane Smith', 'Keyboard', 1),
                        (102, 'Jane Smith', 'Mouse', 2),
                        (103, 'Emily Clark', 'Phone', 1);

            -- Step 1: Create the 'Orders' table to remove the partial dependency
             -- The CustomerName now fully depends on the primary key, OrderID.
                    CREATE TABLE Orders (
                        OrderID INT PRIMARY KEY,
                        CustomerName VARCHAR(255)
                    );

             -- Insert unique OrderID and CustomerName pairs into the new Orders table
                INSERT INTO Orders (OrderID, CustomerName)
                SELECT DISTINCT OrderID, CustomerName
                FROM OrderDetails;
                    

       -- Step 2: Create the 'OrderItems' table
-- This table will hold the line item details of each order.
-- Its composite primary key (OrderID, Product) ensures that Quantity
-- is fully dependent on the entire key.
                CREATE TABLE OrderItems (
                    OrderID INT,
                    Product VARCHAR(255),
                    Quantity INT,
                    PRIMARY KEY (OrderID, Product),
                    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
                );
                
                -- Insert the product and quantity data into the new OrderItems table
                INSERT INTO OrderItems (OrderID, Product, Quantity)
                SELECT OrderID, Product, Quantity
                FROM OrderDetails;
                
                -- To confirm the normalization, you can view the new tables
                SELECT * FROM Orders;
                SELECT * FROM OrderItems;


