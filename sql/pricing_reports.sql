-- Operational and management reports

-- 1. Active pricing conditions
SELECT pc.condition_id, c.customer_name, p.product_name,
       pc.customer_price, pc.currency, pc.expiry_date
FROM pricing_conditions pc
JOIN customers c ON pc.customer_id = c.customer_id
JOIN products p ON pc.product_id = p.product_id
WHERE pc.expiry_date >= CAST(GETDATE() AS DATE);

-- 2. Prices expiring in the next 30 days
SELECT c.customer_name, p.product_name,
       pc.customer_price, pc.currency, pc.expiry_date
FROM pricing_conditions pc
JOIN customers c ON pc.customer_id = c.customer_id
JOIN products p ON pc.product_id = p.product_id
WHERE pc.expiry_date BETWEEN CAST(GETDATE() AS DATE)
                         AND DATEADD(DAY,30,CAST(GETDATE() AS DATE))
ORDER BY pc.expiry_date;

-- 3. Policy exceptions
SELECT condition_id, customer_id, product_id,
       discount_pct, max_allowed_discount_pct
FROM pricing_conditions
WHERE discount_pct > max_allowed_discount_pct
   OR customer_price IS NULL;

-- 4. Customer-wise pricing summary
SELECT c.customer_name,
       COUNT(pc.condition_id) AS pricing_conditions,
       AVG(pc.customer_price) AS avg_customer_price
FROM customers c
LEFT JOIN pricing_conditions pc ON c.customer_id = pc.customer_id
GROUP BY c.customer_name
ORDER BY pricing_conditions DESC;

-- 5. Pending renewal requests
SELECT pr.request_id, c.customer_name, p.product_name,
       pr.current_price, pr.requested_price,
       pr.request_date, pr.requested_expiry_date
FROM pricing_requests pr
JOIN customers c ON pr.customer_id = c.customer_id
JOIN products p ON pr.product_id = p.product_id
WHERE pr.request_status = 'Pending'
ORDER BY pr.request_date;

-- 6. Price change analysis
SELECT c.customer_name, p.product_name,
       pr.current_price, pr.requested_price,
       ROUND((pr.requested_price-pr.current_price)
             / NULLIF(pr.current_price,0)*100,2) AS price_change_pct
FROM pricing_requests pr
JOIN customers c ON pr.customer_id = c.customer_id
JOIN products p ON pr.product_id = p.product_id
WHERE pr.requested_price IS NOT NULL;
