
CREATE DATABASE IF NOT EXISTS handel DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE handel;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS cart_items;
DROP TABLE IF EXISTS carts;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS settings;

SET FOREIGN_KEY_CHECKS = 1;


CREATE TABLE users (
                       user_id INT AUTO_INCREMENT PRIMARY KEY,
                       email VARCHAR(255) NOT NULL UNIQUE,
                       password VARCHAR(255) NOT NULL,
                       full_name VARCHAR(255) NOT NULL,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE products (
                          product_id INT AUTO_INCREMENT PRIMARY KEY,
                          name VARCHAR(255) NOT NULL,
                          description TEXT,
                          price DECIMAL(10,2) NOT NULL,
                          stock INT NOT NULL,
                          image_path VARCHAR(255)
);


CREATE TABLE carts (
                       cart_id INT AUTO_INCREMENT PRIMARY KEY,
                       user_id INT NOT NULL,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       FOREIGN KEY (user_id) REFERENCES users(user_id)
);


CREATE TABLE cart_items (
                            cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
                            cart_id INT NOT NULL,
                            product_id INT NOT NULL,
                            quantity INT NOT NULL,
                            FOREIGN KEY (cart_id) REFERENCES carts(cart_id),
                            FOREIGN KEY (product_id) REFERENCES products(product_id),
                            UNIQUE (cart_id, product_id)
);


CREATE TABLE orders (
                        order_id INT AUTO_INCREMENT PRIMARY KEY,
                        user_id INT NOT NULL,
                        order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        status VARCHAR(50) NOT NULL,
                        total_amount DECIMAL(10,2) NOT NULL,
                        FOREIGN KEY (user_id) REFERENCES users(user_id)
);


CREATE TABLE order_items (
                             order_item_id INT AUTO_INCREMENT PRIMARY KEY,
                             order_id INT NOT NULL,
                             product_id INT NOT NULL,
                             quantity INT NOT NULL,
                             price_at_purchase DECIMAL(10,2) NOT NULL,
                             FOREIGN KEY (order_id) REFERENCES orders(order_id),
                             FOREIGN KEY (product_id) REFERENCES products(product_id)
);


-- EXEMPELDATA – HERRKLÄDER
INSERT INTO users (email, password, full_name) VALUES
                                                   ('erik@example.com', '12345df', 'Erik Eriksson'),
                                                   ('anders@example.com', '23245sd', 'Anders Andersson'),
                                                   ('johan@example.com', '543321aa', 'Johan Johansson');

INSERT INTO products (name, description, price, stock, image_path) VALUES
                                                                       ('Kardigan', 'Mjuk herrkardigan i ull, färger: svart, grå, beige. Storlekar S–XL.', 399.00, 40, '/img/product_1.png'),
                                                                       ('Jeans Slim', 'Slim fit herrjeans i stretch, mörkblå. Storlekar 28–38.', 599.00, 60, '/img/product_2.png'),
                                                                       ('T-shirt', '100% ekologisk bomull, herr-t-shirt. Många färger.', 149.00, 120, '/img/product_3.png'),
                                                                       ('Vinterjacka', 'Varm herrvinterjacka med foder, storlekar S–XL.', 899.00, 25, '/img/product_4.png');

INSERT INTO carts (user_id) VALUES
                                (1), (2);

INSERT INTO cart_items (cart_id, product_id, quantity) VALUES
                                                           (1, 1, 2),
                                                           (1, 4, 1),
                                                           (2, 2, 1);

INSERT INTO orders (user_id, status, total_amount) VALUES
                                                       (1, 'Skickad', 1697.00),
                                                       (2, 'Levererad', 599.00);

INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase) VALUES
                                                                                (1, 1, 2, 399.00),
                                                                                (1, 4, 1, 899.00),
                                                                                (2, 2, 1, 599.00);
