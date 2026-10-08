-- ============================================================
--  Glow Cosmetics - MySQL database
--  Run this file once in MySQL Workbench / phpMyAdmin
-- ============================================================
CREATE DATABASE IF NOT EXISTS cosmetics_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE cosmetics_db;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS cart;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS brands;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    full_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(150) NOT NULL UNIQUE,
    phone         VARCHAR(15)  NULL,
    password_hash VARCHAR(200) NOT NULL,
    role          VARCHAR(10)  NOT NULL DEFAULT 'user',   -- 'user' or 'admin'
    created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Main category (parent_id NULL) e.g. Makeup;  Sub-category e.g. Lipstick (parent_id = Makeup)
CREATE TABLE categories (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255) NULL,
    parent_id   INT NULL,
    CONSTRAINT fk_cat_parent FOREIGN KEY (parent_id) REFERENCES categories(id)
);

CREATE TABLE brands (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255) NULL,
    is_active   TINYINT(1)   NOT NULL DEFAULT 1
);

CREATE TABLE products (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    brand_id    INT NULL,
    category_id INT NOT NULL,      -- sub-category (Lipstick, Foundation ...)
    name        VARCHAR(150) NOT NULL,
    description TEXT NULL,
    price       DECIMAL(10,2) NOT NULL,
    stock       INT NOT NULL DEFAULT 0,
    image       VARCHAR(200) NULL,
    is_active   TINYINT(1) NOT NULL DEFAULT 1,
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_prod_cat FOREIGN KEY (category_id) REFERENCES categories(id),
    CONSTRAINT fk_prod_brand FOREIGN KEY (brand_id) REFERENCES brands(id)
);

CREATE TABLE cart (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT NOT NULL,
    product_id INT NOT NULL,
    quantity   INT NOT NULL DEFAULT 1,
    UNIQUE KEY uq_cart (user_id, product_id),
    CONSTRAINT fk_cart_user FOREIGN KEY (user_id)    REFERENCES users(id)    ON DELETE CASCADE,
    CONSTRAINT fk_cart_prod FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

CREATE TABLE orders (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    user_id             INT NOT NULL,
    total               DECIMAL(10,2) NOT NULL,
    ship_name           VARCHAR(100) NOT NULL,
    ship_phone          VARCHAR(15)  NOT NULL,
    ship_address        VARCHAR(300) NOT NULL,
    ship_city           VARCHAR(80)  NOT NULL,
    ship_pincode        VARCHAR(10)  NOT NULL,
    payment_method      VARCHAR(10)  NOT NULL,              -- 'COD' or 'ONLINE'
    payment_status      VARCHAR(10)  NOT NULL DEFAULT 'Pending',   -- Pending / Paid / Failed
    order_status        VARCHAR(15)  NOT NULL DEFAULT 'Placed',    -- Placed / Shipped / Delivered / Cancelled
    razorpay_order_id   VARCHAR(60)  NULL,
    razorpay_payment_id VARCHAR(60)  NULL,
    created_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ord_user FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE order_items (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    order_id     INT NOT NULL,
    product_id   INT NOT NULL,
    product_name VARCHAR(150) NOT NULL,
    price        DECIMAL(10,2) NOT NULL,
    quantity     INT NOT NULL,
    CONSTRAINT fk_oi_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- Sample data
-- Admin login  ->  admin@glow.com  /  Admin@123
-- ------------------------------------------------------------
INSERT INTO users (full_name, email, phone, password_hash, role) VALUES
('Site Admin', 'admin@glow.com', '9999999999',
 'AQIDBAUGBwgJCgsMDQ4PEA==:rJPsxUC5qMZAY/awUbhVdQPeOX+4Z12BD7E/F7/y5pA=', 'admin');

INSERT INTO categories (name, description) VALUES
('Skincare',  'Cleansers, moisturisers, serums and sunscreens'),
('Makeup',    'Lipsticks, foundations, kajal and more'),
('Haircare',  'Shampoos, conditioners and hair oils'),
('Fragrance', 'Perfumes and body mists');

-- Brands
INSERT IGNORE INTO brands (name, description) VALUES
('Lakme', 'Indian beauty classic - everyday makeup and skincare'),
('Maybelline', 'Bold, easy makeup for every day'),
('Sugar', 'Fun, high-pigment makeup'),
('Mamaearth', 'Toxin-free skincare and haircare'),
('Biotique', 'Herbal, ayurvedic skin and hair care'),
('Engage', 'Fresh everyday fragrances');

-- Sub-categories (product types) under each main category
INSERT IGNORE INTO categories (name, description, parent_id)
SELECT v.n, v.d, m.id FROM (SELECT 'Face Wash' AS n, 'Gentle daily cleansers' AS d UNION ALL SELECT 'Moisturiser' AS n, 'Hydrating creams and gels' AS d UNION ALL SELECT 'Sunscreen' AS n, 'Sun protection' AS d UNION ALL SELECT 'Serum' AS n, 'Targeted skin treatments' AS d) v JOIN categories m ON m.name='Skincare' AND m.parent_id IS NULL;
INSERT IGNORE INTO categories (name, description, parent_id)
SELECT v.n, v.d, m.id FROM (SELECT 'Lipstick' AS n, 'Matte and creme lip colour' AS d UNION ALL SELECT 'Foundation' AS n, 'Base makeup for even skin' AS d UNION ALL SELECT 'Kajal' AS n, 'Smudge-proof eye pencils' AS d UNION ALL SELECT 'Compact' AS n, 'Powder for a matte finish' AS d) v JOIN categories m ON m.name='Makeup' AND m.parent_id IS NULL;
INSERT IGNORE INTO categories (name, description, parent_id)
SELECT v.n, v.d, m.id FROM (SELECT 'Shampoo' AS n, 'Cleansing shampoos' AS d UNION ALL SELECT 'Hair Oil' AS n, 'Nourishing hair oils' AS d) v JOIN categories m ON m.name='Haircare' AND m.parent_id IS NULL;
INSERT IGNORE INTO categories (name, description, parent_id)
SELECT v.n, v.d, m.id FROM (SELECT 'Perfume' AS n, 'Long-lasting eau de parfum' AS d UNION ALL SELECT 'Body Mist' AS n, 'Light everyday mists' AS d) v JOIN categories m ON m.name='Fragrance' AND m.parent_id IS NULL;

-- Brand-wise products (each product belongs to ONE brand and ONE type)
INSERT INTO products (brand_id, category_id, name, description, price, stock, image)
SELECT b.id, c.id, 'Lakme Matte Lipstick - Ruby Red', 'Long-wear matte lipstick in a deep ruby red shade. Comfortable on lips all day.', 450, 60, 'placeholder.svg' FROM brands b, categories c
WHERE b.name='Lakme' AND c.name='Lipstick' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Lakme Matte Lipstick - Ruby Red');
INSERT INTO products (brand_id, category_id, name, description, price, stock, image)
SELECT b.id, c.id, 'Lakme Creme Lipstick - Nude Pink', 'Creamy, moisturising lipstick in a soft nude pink. Perfect for daily wear.', 399, 70, 'placeholder.svg' FROM brands b, categories c
WHERE b.name='Lakme' AND c.name='Lipstick' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Lakme Creme Lipstick - Nude Pink');
INSERT INTO products (brand_id, category_id, name, description, price, stock, image)
SELECT b.id, c.id, 'Lakme Liquid Foundation - Natural Beige', 'Medium coverage liquid foundation with a natural, skin-like finish.', 650, 40, 'placeholder.svg' FROM brands b, categories c
WHERE b.name='Lakme' AND c.name='Foundation' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Lakme Liquid Foundation - Natural Beige');
INSERT INTO products (brand_id, category_id, name, description, price, stock, image)
SELECT b.id, c.id, 'Lakme Smudge-proof Kajal', 'Deep black kajal that stays in place for hours.', 199, 120, 'placeholder.svg' FROM brands b, categories c
WHERE b.name='Lakme' AND c.name='Kajal' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Lakme Smudge-proof Kajal');
INSERT INTO products (brand_id, category_id, name, description, price, stock, image)
SELECT b.id, c.id, 'Lakme Oil-control Compact', 'Pressed powder compact that controls shine and gives a matte look.', 285, 55, 'placeholder.svg' FROM brands b, categories c
WHERE b.name='Lakme' AND c.name='Compact' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Lakme Oil-control Compact');
INSERT INTO products (brand_id, category_id, name, description, price, stock, image)
SELECT b.id, c.id, 'Lakme SPF 50 Sunscreen Lotion', 'Lightweight sunscreen lotion with SPF 50 and no white cast.', 350, 50, 'placeholder.svg' FROM brands b, categories c
WHERE b.name='Lakme' AND c.name='Sunscreen' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Lakme SPF 50 Sunscreen Lotion');
INSERT INTO products (brand_id, category_id, name, description, price, stock, image)
SELECT b.id, c.id, 'Maybelline Matte Lipstick - Coral Crush', 'Rich matte lipstick in a bright coral shade with a smooth feel.', 599, 50, 'placeholder.svg' FROM brands b, categories c
WHERE b.name='Maybelline' AND c.name='Lipstick' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Maybelline Matte Lipstick - Coral Crush');
INSERT INTO products (brand_id, category_id, name, description, price, stock, image)
SELECT b.id, c.id, 'Maybelline Fit Me Liquid Foundation', 'Lightweight liquid foundation that matches Indian skin tones.', 549, 45, 'placeholder.svg' FROM brands b, categories c
WHERE b.name='Maybelline' AND c.name='Foundation' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Maybelline Fit Me Liquid Foundation');
INSERT INTO products (brand_id, category_id, name, description, price, stock, image)
SELECT b.id, c.id, 'Maybelline Waterproof Kajal', 'Waterproof kajal with intense black colour and creamy texture.', 249, 90, 'placeholder.svg' FROM brands b, categories c
WHERE b.name='Maybelline' AND c.name='Kajal' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Maybelline Waterproof Kajal');
INSERT INTO products (brand_id, category_id, name, description, price, stock, image)
SELECT b.id, c.id, 'Maybelline Compact Powder', 'Soft compact powder for a fresh, natural matte finish.', 325, 40, 'placeholder.svg' FROM brands b, categories c
WHERE b.name='Maybelline' AND c.name='Compact' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Maybelline Compact Powder');
INSERT INTO products (brand_id, category_id, name, description, price, stock, image)
SELECT b.id, c.id, 'Sugar Matte Lipstick - Brick Brown', 'High-pigment matte lipstick in a warm brick brown shade.', 499, 45, 'placeholder.svg' FROM brands b, categories c
WHERE b.name='Sugar' AND c.name='Lipstick' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Sugar Matte Lipstick - Brick Brown');
INSERT INTO products (brand_id, category_id, name, description, price, stock, image)
SELECT b.id, c.id, 'Sugar Foundation Stick', 'Easy-to-apply foundation stick with buildable coverage.', 799, 30, 'placeholder.svg' FROM brands b, categories c
WHERE b.name='Sugar' AND c.name='Foundation' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Sugar Foundation Stick');
INSERT INTO products (brand_id, category_id, name, description, price, stock, image)
SELECT b.id, c.id, 'Sugar Smudge-proof Kajal Pencil', 'Twist-up kajal pencil that stays smudge-free through the day.', 349, 80, 'placeholder.svg' FROM brands b, categories c
WHERE b.name='Sugar' AND c.name='Kajal' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Sugar Smudge-proof Kajal Pencil');
INSERT INTO products (brand_id, category_id, name, description, price, stock, image)
SELECT b.id, c.id, 'Mamaearth Vitamin C Face Wash', 'Brightening face wash with Vitamin C for fresh, clean skin.', 299, 75, 'placeholder.svg' FROM brands b, categories c
WHERE b.name='Mamaearth' AND c.name='Face Wash' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Mamaearth Vitamin C Face Wash');
INSERT INTO products (brand_id, category_id, name, description, price, stock, image)
SELECT b.id, c.id, 'Mamaearth Vitamin C Face Serum', 'Daily serum that helps reduce dullness and dark spots.', 549, 40, 'placeholder.svg' FROM brands b, categories c
WHERE b.name='Mamaearth' AND c.name='Serum' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Mamaearth Vitamin C Face Serum');
INSERT INTO products (brand_id, category_id, name, description, price, stock, image)
SELECT b.id, c.id, 'Mamaearth Ultra Light Sunscreen', 'Ultra light sunscreen for everyday protection.', 449, 55, 'placeholder.svg' FROM brands b, categories c
WHERE b.name='Mamaearth' AND c.name='Sunscreen' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Mamaearth Ultra Light Sunscreen');
INSERT INTO products (brand_id, category_id, name, description, price, stock, image)
SELECT b.id, c.id, 'Mamaearth Aloe Vera Gel', 'Cooling aloe vera gel to hydrate skin and hair.', 299, 60, 'placeholder.svg' FROM brands b, categories c
WHERE b.name='Mamaearth' AND c.name='Moisturiser' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Mamaearth Aloe Vera Gel');
INSERT INTO products (brand_id, category_id, name, description, price, stock, image)
SELECT b.id, c.id, 'Mamaearth Onion Shampoo', 'Onion shampoo that helps reduce hair fall.', 379, 50, 'placeholder.svg' FROM brands b, categories c
WHERE b.name='Mamaearth' AND c.name='Shampoo' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Mamaearth Onion Shampoo');
INSERT INTO products (brand_id, category_id, name, description, price, stock, image)
SELECT b.id, c.id, 'Mamaearth Onion Hair Oil', 'Onion hair oil to support strong and healthy hair.', 349, 70, 'placeholder.svg' FROM brands b, categories c
WHERE b.name='Mamaearth' AND c.name='Hair Oil' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Mamaearth Onion Hair Oil');
INSERT INTO products (brand_id, category_id, name, description, price, stock, image)
SELECT b.id, c.id, 'Biotique Neem Face Wash', 'Purifying neem face wash for oily and acne-prone skin.', 199, 65, 'placeholder.svg' FROM brands b, categories c
WHERE b.name='Biotique' AND c.name='Face Wash' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Biotique Neem Face Wash');
INSERT INTO products (brand_id, category_id, name, description, price, stock, image)
SELECT b.id, c.id, 'Biotique Almond Moisturiser', 'Nourishing almond moisturiser for soft, smooth skin.', 249, 50, 'placeholder.svg' FROM brands b, categories c
WHERE b.name='Biotique' AND c.name='Moisturiser' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Biotique Almond Moisturiser');
INSERT INTO products (brand_id, category_id, name, description, price, stock, image)
SELECT b.id, c.id, 'Biotique Bhringraj Shampoo', 'Herbal shampoo with bhringraj to keep hair strong.', 329, 45, 'placeholder.svg' FROM brands b, categories c
WHERE b.name='Biotique' AND c.name='Shampoo' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Biotique Bhringraj Shampoo');
INSERT INTO products (brand_id, category_id, name, description, price, stock, image)
SELECT b.id, c.id, 'Biotique Bhringraj Hair Oil', 'Herbal hair oil to nourish the scalp and hair.', 299, 55, 'placeholder.svg' FROM brands b, categories c
WHERE b.name='Biotique' AND c.name='Hair Oil' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Biotique Bhringraj Hair Oil');
INSERT INTO products (brand_id, category_id, name, description, price, stock, image)
SELECT b.id, c.id, 'Engage Eau de Parfum for Women', 'Fresh floral perfume with a long-lasting fragrance.', 299, 60, 'placeholder.svg' FROM brands b, categories c
WHERE b.name='Engage' AND c.name='Perfume' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Engage Eau de Parfum for Women');
INSERT INTO products (brand_id, category_id, name, description, price, stock, image)
SELECT b.id, c.id, 'Engage Eau de Parfum for Men', 'Woody and fresh perfume for everyday wear.', 299, 60, 'placeholder.svg' FROM brands b, categories c
WHERE b.name='Engage' AND c.name='Perfume' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Engage Eau de Parfum for Men');
INSERT INTO products (brand_id, category_id, name, description, price, stock, image)
SELECT b.id, c.id, 'Engage Rose Body Mist', 'Light rose body mist for a fresh feeling all day.', 199, 80, 'placeholder.svg' FROM brands b, categories c
WHERE b.name='Engage' AND c.name='Body Mist' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Engage Rose Body Mist');

-- Contact Us page ke messages
CREATE TABLE IF NOT EXISTS contact_messages (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100)  NOT NULL,
    email       VARCHAR(150)  NOT NULL,
    phone       VARCHAR(15)   NULL,
    subject     VARCHAR(100)  NOT NULL,
    message     VARCHAR(1000) NOT NULL,
    is_read     TINYINT(1)    NOT NULL DEFAULT 0,
    created_at  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;
