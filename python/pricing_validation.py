import pandas as pd
from pathlib import Path

DATA = Path("../data")
customers = pd.read_csv(DATA / "customers.csv")
products = pd.read_csv(DATA / "products.csv")
pricing = pd.read_csv(DATA / "pricing_conditions.csv")
requests = pd.read_csv(DATA / "pricing_requests.csv")

# Convert dates
pricing["effective_date"] = pd.to_datetime(pricing["effective_date"], errors="coerce")
pricing["expiry_date"] = pd.to_datetime(pricing["expiry_date"], errors="coerce")
requests["request_date"] = pd.to_datetime(requests["request_date"], errors="coerce")

today = pd.Timestamp("2026-09-24")

# Validate pricing conditions
pricing["customer_exists"] = pricing["customer_id"].isin(customers["customer_id"])
pricing["product_exists"] = pricing["product_id"].isin(products["product_id"])
pricing["missing_price"] = pricing["customer_price"].isna()
pricing["invalid_discount"] = pricing["discount_pct"] > pricing["max_allowed_discount_pct"]
pricing["invalid_dates"] = pricing["effective_date"] > pricing["expiry_date"]
pricing["expired"] = pricing["expiry_date"] < today

pricing["validation_status"] = "Valid"
pricing.loc[
    (~pricing["customer_exists"]) |
    (~pricing["product_exists"]) |
    pricing["missing_price"] |
    pricing["invalid_discount"] |
    pricing["invalid_dates"],
    "validation_status"
] = "Exception"

pricing["exception_reason"] = ""
conditions = [
    ~pricing["customer_exists"],
    ~pricing["product_exists"],
    pricing["missing_price"],
    pricing["invalid_discount"],
    pricing["invalid_dates"]
]
reasons = [
    "Customer ID not found",
    "Product ID not found",
    "Customer price missing",
    "Discount exceeds policy limit",
    "Effective date after expiry date"
]
for cond, reason in zip(conditions, reasons):
    pricing.loc[cond, "exception_reason"] = pricing.loc[cond, "exception_reason"].replace("", reason)

# Renewal bucket
pricing["renewal_bucket"] = "More than 30 days"
pricing.loc[pricing["expiry_date"].between(today, today + pd.Timedelta(days=30)), "renewal_bucket"] = "Expiring in 30 days"
pricing.loc[pricing["expiry_date"] < today, "renewal_bucket"] = "Expired"

# Validate requests
requests["customer_exists"] = requests["customer_id"].isin(customers["customer_id"])
requests["product_exists"] = requests["product_id"].isin(products["product_id"])
requests["missing_requested_price"] = requests["requested_price"].isna()
requests["policy_violation"] = requests["requested_discount_pct"] > 15
requests["validation_status"] = "Valid"
requests.loc[
    (~requests["customer_exists"]) |
    (~requests["product_exists"]) |
    requests["missing_requested_price"] |
    requests["policy_violation"],
    "validation_status"
] = "Exception"

# Outputs for Power BI / reporting
pricing.to_csv(DATA / "pricing_validation_output.csv", index=False)
requests.to_csv(DATA / "pricing_request_validation_output.csv", index=False)

print("Pricing conditions:", len(pricing))
print("Pricing exceptions:", (pricing["validation_status"] == "Exception").sum())
print("Expired conditions:", pricing["expired"].sum())
print("Request exceptions:", (requests["validation_status"] == "Exception").sum())
