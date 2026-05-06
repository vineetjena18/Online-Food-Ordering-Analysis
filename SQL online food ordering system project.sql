Create database Onlinefood_Ordering_System;
use Onlinefood_Ordering_System ;

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Email VARCHAR(150) UNIQUE,
    Phone VARCHAR(20),
    RegistrationDate DATE
);

CREATE TABLE Restaurants (
    RestaurantID INT PRIMARY KEY,
    RestaurantName VARCHAR(150),
    Address VARCHAR(255),
    CuisineType VARCHAR(100)
);

CREATE TABLE MenuItems (
    MenuItemID INT PRIMARY KEY,
    RestaurantID INT,
    ItemName VARCHAR(150),
    Price DECIMAL(10,2),
    Description TEXT,
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    RestaurantID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    MenuItemID INT,
    Quantity INT,
    ItemPrice DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (MenuItemID) REFERENCES MenuItems(MenuItemID)
);

CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY,
    RestaurantID INT,
    CustomerID INT,
    ReviewDate DATE,
    Rating DECIMAL(2,1),
    Comments TEXT,
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

select * from restaurants;
SELECT * 
FROM MenuItems 
WHERE Price < 10.00;

SELECT * 
FROM Orders 
WHERE TotalAmount BETWEEN 30 AND 50 
AND OrderDate >= '2024-01-01' 
AND OrderDate <= '2024-12-31';

SELECT * 
FROM Restaurants 
WHERE CuisineType LIKE '%Italian%';

SELECT ItemName, Price,
    CASE 
        WHEN Price > 15.00 THEN Price * 0.90 
        ELSE Price 
    END AS FinalPrice
FROM MenuItems;

SELECT FirstName, LastName 
FROM Customers 
WHERE CustomerID IN (
    SELECT CustomerID 
    FROM Orders 
    GROUP BY CustomerID 
    HAVING SUM(TotalAmount) > 1000
);

SELECT RestaurantID, COUNT(OrderID) AS TotalOrders
FROM Orders
GROUP BY RestaurantID;

SELECT RestaurantID, SUM(TotalAmount) AS TotalRevenue
FROM Orders
GROUP BY RestaurantID
HAVING SUM(TotalAmount) > 500;

SELECT * 
FROM MenuItems
ORDER BY Price DESC
LIMIT 3;

SELECT C.FirstName, C.LastName, O.OrderDate, O.TotalAmount
FROM Orders O
INNER JOIN Customers C ON O.CustomerID = C.CustomerID;

SELECT M.ItemName, OD.Quantity, OD.OrderID
FROM MenuItems M
LEFT OUTER JOIN OrderDetails OD ON M.MenuItemID = OD.MenuItemID;


SELECT RestaurantName, COUNT(MenuItemID) AS TotalMenuItems
FROM Restaurants R
LEFT JOIN MenuItems M ON R.RestaurantID = M.RestaurantID
GROUP BY RestaurantName;

SELECT RestaurantName
FROM Restaurants R
WHERE R.RestaurantID IN (
    SELECT RestaurantID
    FROM Reviews
    WHERE Rating > 4.0
    GROUP BY RestaurantID
    HAVING COUNT(DISTINCT CustomerID) >= 3
);

SELECT 
    r.RestaurantName,
    m.ItemName,
    m.Price
FROM Restaurants r
LEFT JOIN MenuItems m ON r.RestaurantID = m.RestaurantID;