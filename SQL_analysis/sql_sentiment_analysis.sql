
USE sentiment;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    region VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50)
);

CREATE TABLE reviews (
    review_id  INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    rating  INT,                -- 1 to 5
    sentiment_label VARCHAR(10),        -- 'positive', 'negative', 'neutral'
    sentiment_score DECIMAL(4,2),       -- e.g., -1.00 to 1.00
    review_date  DATE,
    review_text  TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id)  REFERENCES products(product_id)
);


INSERT INTO customers (customer_id, customer_name, age, gender, region) VALUES
(1, 'Rahul Sharma', 25, 'Male',   'North'),
(2, 'Anita Verma',  32, 'Female', 'South'),
(3, 'Amit Singh',   45, 'Male',   'West'),
(4, 'Neha Gupta',   29, 'Female', 'East'),
(5, 'Rohit Kumar',  38, 'Male',   'North'),
(6, 'Priya Das',    22, 'Female', 'South');


INSERT INTO products (product_id, product_name, category) VALUES
(101, 'Wireless Earbuds',  'Electronics'),
(102, 'Fitness Band',      'Electronics'),
(103, 'Coffee Maker',      'Home Appliances'),
(104, 'Yoga Mat',          'Sports'),
(105, 'Running Shoes',     'Sports');

INSERT INTO reviews (review_id, customer_id, product_id, rating, sentiment_label, sentiment_score, review_date, review_text) VALUES
(1001, 1, 101, 5, 'positive',  0.95, '2024-10-01', 'Excellent sound quality and battery life.'),
(1002, 2, 101, 4, 'positive',  0.80, '2024-10-05', 'Good product, worth the price.'),
(1003, 3, 101, 2, 'negative', -0.70, '2024-09-20', 'Stopped working after a week.'),
(1004, 4, 102, 3, 'neutral',   0.10, '2024-11-02', 'Average features, nothing special.'),
(1005, 5, 103, 1, 'negative', -0.90, '2024-08-15', 'Terrible build quality, very disappointed.'),
(1006, 6, 103, 4, 'positive',  0.85, '2024-09-10', 'Makes great coffee, easy to use.'),
(1007, 1, 104, 5, 'positive',  0.92, '2024-11-10', 'Very comfortable and durable.'),
(1008, 2, 104, 4, 'positive',  0.75, '2024-11-18', 'Good grip and quality.'),
(1009, 3, 105, 2, 'negative', -0.65, '2024-09-05', 'Sole wore out quickly.'),
(1010, 4, 105, 3, 'neutral',   0.05, '2024-10-12', 'Okay for casual use.'),
(1011, 5, 102, 4, 'positive',  0.70, '2024-11-20', 'Good tracker, value for money.'),
(1012, 6, 102, 1, 'negative', -0.80, '2024-07-28', 'App connectivity issues, very buggy.');



--  Overall count of reviews by sentiment label
SELECT 
    sentiment_label,
    COUNT(*) AS review_count
FROM reviews
GROUP BY sentiment_label;

-- Average sentiment score per product (join with products)
SELECT 
    p.product_name,
    p.category,
    AVG(r.sentiment_score) AS avg_sentiment_score
FROM reviews r
JOIN products p ON r.product_id = p.product_id
GROUP BY p.product_name, p.category
ORDER BY avg_sentiment_score DESC;

-- Average rating and sentiment per category
SELECT 
    p.category,
    AVG(r.rating)          AS avg_rating,
    AVG(r.sentiment_score) AS avg_sentiment_score
FROM reviews r
JOIN products p ON r.product_id = p.product_id
GROUP BY p.category;

-- Sentiment distribution by region (join customers + reviews)
SELECT 
    c.region,
    r.sentiment_label,
    COUNT(*) AS review_count
FROM reviews r
JOIN customers c ON r.customer_id = c.customer_id
GROUP BY c.region, r.sentiment_label
ORDER BY c.region, r.sentiment_label;

-- Top 3 products by number of positive reviews
SELECT 
    p.product_name,
    COUNT(*) AS positive_reviews
FROM reviews r
JOIN products p ON r.product_id = p.product_id
WHERE r.sentiment_label = 'positive'
GROUP BY p.product_name
ORDER BY positive_reviews DESC
LIMIT 3;

-- Customers with most negative reviews (potential churn risk)
SELECT 
    c.customer_name,
    c.region,
    COUNT(*) AS negative_reviews
FROM reviews r
JOIN customers c ON r.customer_id = c.customer_id
WHERE r.sentiment_label = 'negative'
GROUP BY c.customer_name, c.region
ORDER BY negative_reviews DESC;


-- For each product, get rating vs sentiment comparison
SELECT 
    p.product_name,
    COUNT(*)             AS total_reviews,
    AVG(r.rating)        AS avg_rating,
    AVG(r.sentiment_score) AS avg_sentiment_score
FROM reviews r
JOIN products p ON r.product_id = p.product_id
GROUP BY p.product_name
ORDER BY avg_sentiment_score DESC;


--  Recently active unhappy customers (negative reviews in last 60 days)
SELECT 
    c.customer_name,
    c.region,
    r.product_id,
    r.rating,
    r.sentiment_label,
    r.review_date
FROM reviews r
JOIN customers c ON r.customer_id = c.customer_id
WHERE r.sentiment_label = 'negative'
  AND r.review_date >= CURDATE() - INTERVAL 60 DAY
ORDER BY r.review_date DESC;

-- Region & category combination with worst average sentiment
SELECT 
    c.region,
    p.category,
    AVG(r.sentiment_score) AS avg_sentiment_score
FROM reviews r
JOIN customers c ON r.customer_id = c.customer_id
JOIN products p  ON r.product_id  = p.product_id
GROUP BY c.region, p.category
ORDER BY avg_sentiment_score ASC;

-- Detect mismatch: good rating but negative sentiment (or bad rating but positive sentiment)
SELECT 
    r.review_id,
    c.customer_name,
    p.product_name,
    r.rating,
    r.sentiment_label,
    r.sentiment_score,
    r.review_text
FROM reviews r
JOIN customers c ON r.customer_id = c.customer_id
JOIN products p  ON r.product_id  = p.product_id
WHERE 
    (r.rating >= 4 AND r.sentiment_label = 'negative')
    OR
    (r.rating <= 2 AND r.sentiment_label = 'positive');






