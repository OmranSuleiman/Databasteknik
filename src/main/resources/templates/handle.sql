-- Ta bort tabeller i rätt ordning (pga foreign keys)

IF OBJECT_ID('order_items', 'U') IS NOT NULL DROP TABLE order_items;
IF OBJECT_ID('orders', 'U') IS NOT NULL DROP TABLE orders;
IF OBJECT_ID('cart_items', 'U') IS NOT NULL DROP TABLE cart_items;
IF OBJECT_ID('carts', 'U') IS NOT NULL DROP TABLE carts;
IF OBJECT_ID('products', 'U') IS NOT NULL DROP TABLE products;
IF OBJECT_ID('users', 'U') IS NOT NULL DROP TABLE [users];


-- Skapa tabeller igen (Azure SQL version)

CREATE TABLE [users] (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    email NVARCHAR(255) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    full_name NVARCHAR(255) NOT NULL,
    created_at DATETIME2 DEFAULT SYSDATETIME()
);

CREATE TABLE products (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    image_path NVARCHAR(255)
);

CREATE TABLE carts (
    cart_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    created_at DATETIME2 DEFAULT SYSDATETIME(),
    FOREIGN KEY (user_id) REFERENCES [users](user_id)
);

CREATE TABLE cart_items (
    cart_item_id INT IDENTITY(1,1) PRIMARY KEY,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (cart_id) REFERENCES carts(cart_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT UQ_cart_product UNIQUE (cart_id, product_id)
);

CREATE TABLE orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    order_date DATETIME2 DEFAULT SYSDATETIME(),
    status NVARCHAR(50) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES [users](user_id)
);

CREATE TABLE order_items (
    order_item_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price_at_purchase DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


-- Lägg in enkel testdata (herrkläder)

INSERT INTO [users] (email, password, full_name)
VALUES
('omran@test.com', '123456', 'Omran Suleiman'),
('alex@test.com', '123456', 'Alex Johansson');

INSERT INTO products (name, description, price, stock, image_path)
VALUES
('Black T-shirt', 'Cotton black t-shirt for men', 199.00, 25, 'tshirt_black.jpg'),
('Blue Jeans', 'Slim fit blue jeans', 599.00, 15, 'jeans_blue.jpg'),
('Grey Hoodie', 'Warm grey hoodie', 499.00, 20, 'hoodie_grey.jpg'),
('Leather Jacket', 'Black leather jacket', 1299.00, 5, 'jacket_black.jpg');


-- SELECT * FROM [users];
-- SELECT * FROM products;
-- update products set [name] = 'Sommar jacka' WHERE product_id = 4;
-- DELETE FROM products WHERE product_id = 4;
-- INSERT INTO products (name, description, price, stock, image_path) VALUES ('Black T-shirt', 'Cotton black t-shirt for men', 199.00, 25, 'tshirt_black.jpg');
-- DROP TABLE products;
-- ALTER TABLE products ADD size NVARCHAR(50);
-- TRUNCATE TABLE products; snabbar än delete, radera allt data men behåll tabellen
-- SELECT u.full_name, o.order_id FROM [users] u JOIN orders o ON u.user_id = o.user_id;
-- SELECT * FROM products WHERE price > 500; filtrera
-- SELECT * FROM products ORDER BY price DESC; sortera
-- SELECT status, COUNT(*)FROM orders GROUP BY status; gruppera

