# Data Dictionary

| Table | Key | Purpose |
|---|---|---|
| customers | customer_id | Customer master |
| products | product_id | Product master |
| sales_representatives | sales_rep_id | Sales team reference |
| pricing_conditions | condition_id | Current/historical customer-product pricing |
| pricing_requests | request_id | Incoming pricing/renewal requests |
| pricing_powerbi_ready | condition_id | Flattened dataset for Power BI |

## Important Fields
- `customer_price`: price currently maintained for the customer-product combination.
- `discount_pct`: discount applied to the reference/list price.
- `max_allowed_discount_pct`: simulated pricing policy limit.
- `effective_date`: start date of the pricing condition.
- `expiry_date`: date on which the condition expires.
- `requested_price`: price requested by Sales.
- `requested_expiry_date`: requested validity end date.
