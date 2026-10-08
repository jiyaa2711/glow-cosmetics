-- ============================================================
--  UPGRADE to V3 : Brands + Sub-categories   (keeps your data)
--  Run this ONCE in phpMyAdmin (select cosmetics_db > SQL tab)
-- ============================================================
USE cosmetics_db;

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

CREATE TABLE brands (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255) NULL,
    is_active   TINYINT(1)   NOT NULL DEFAULT 1
);

ALTER TABLE categories ADD COLUMN parent_id INT NULL;
ALTER TABLE categories ADD CONSTRAINT fk_cat_parent FOREIGN KEY (parent_id) REFERENCES categories(id);
ALTER TABLE products   ADD COLUMN brand_id INT NULL;
ALTER TABLE products   ADD CONSTRAINT fk_prod_brand FOREIGN KEY (brand_id) REFERENCES brands(id);

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

-- Move your old 10 sample products under a brand + sub-category
UPDATE products p, brands b, categories c SET p.brand_id=b.id, p.category_id=c.id WHERE p.name='Vitamin C Face Serum' AND b.name='Mamaearth' AND c.name='Serum';
UPDATE products p, brands b, categories c SET p.brand_id=b.id, p.category_id=c.id WHERE p.name='Aloe Vera Moisturiser' AND b.name='Mamaearth' AND c.name='Moisturiser';
UPDATE products p, brands b, categories c SET p.brand_id=b.id, p.category_id=c.id WHERE p.name='SPF 50 Sunscreen' AND b.name='Lakme' AND c.name='Sunscreen';
UPDATE products p, brands b, categories c SET p.brand_id=b.id, p.category_id=c.id WHERE p.name='Matte Red Lipstick' AND b.name='Lakme' AND c.name='Lipstick';
UPDATE products p, brands b, categories c SET p.brand_id=b.id, p.category_id=c.id WHERE p.name='Waterproof Kajal' AND b.name='Maybelline' AND c.name='Kajal';
UPDATE products p, brands b, categories c SET p.brand_id=b.id, p.category_id=c.id WHERE p.name='Liquid Foundation' AND b.name='Lakme' AND c.name='Foundation';
UPDATE products p, brands b, categories c SET p.brand_id=b.id, p.category_id=c.id WHERE p.name='Argan Oil Shampoo' AND b.name='Biotique' AND c.name='Shampoo';
UPDATE products p, brands b, categories c SET p.brand_id=b.id, p.category_id=c.id WHERE p.name='Onion Hair Oil' AND b.name='Mamaearth' AND c.name='Hair Oil';
UPDATE products p, brands b, categories c SET p.brand_id=b.id, p.category_id=c.id WHERE p.name='Rose Body Mist' AND b.name='Engage' AND c.name='Body Mist';
UPDATE products p, brands b, categories c SET p.brand_id=b.id, p.category_id=c.id WHERE p.name='Oud Eau de Parfum' AND b.name='Engage' AND c.name='Perfume';

-- Products you added yourself have no brand yet: open Admin > Products > Edit and choose Brand + Type.
