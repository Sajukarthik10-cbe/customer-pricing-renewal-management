# Power BI Dashboard Build Guide

## Recommended relationships
If using the individual CSV files:
- Customers[customer_id] 1 → * Pricing_Conditions[customer_id]
- Products[product_id] 1 → * Pricing_Conditions[product_id]
- Customers[customer_id] 1 → * Pricing_Requests[customer_id]
- Products[product_id] 1 → * Pricing_Requests[product_id]

## Suggested DAX measures

```DAX
Total Customers = DISTINCTCOUNT(Customers[customer_id])

Pricing Conditions = COUNTROWS(Pricing_Conditions)

Pending Requests =
CALCULATE(
    COUNTROWS(Pricing_Requests),
    Pricing_Requests[request_status] = "Pending"
)

Expired Conditions =
CALCULATE(
    COUNTROWS(Pricing_Conditions),
    Pricing_Conditions[expiry_date] < DATE(2026,9,24)
)

Average Customer Price =
AVERAGE(Pricing_Conditions[customer_price])

Policy Exceptions =
CALCULATE(
    COUNTROWS(Pricing_Conditions),
    Pricing_Conditions[discount_pct] >
    Pricing_Conditions[max_allowed_discount_pct]
)
```

## Visuals
- KPI cards for Total Customers, Pricing Conditions, Pending Requests, Expired Conditions
- Bar chart: pricing conditions by customer segment
- Column chart: pricing conditions by product category
- Table: customer/product/price/expiry/renewal bucket
- Slicers: country, customer segment, industry, product category
