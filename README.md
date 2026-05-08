# 🛒 E-Commerce Sales Analysis — SQL Project

## 📌 Project Overview

This project performs an end-to-end SQL analysis of an e-commerce business to uncover insights across **sales performance**, **customer behaviour**, **product trends**, **regional patterns**, and **return/refund analytics**.

The analysis covers 6 key analytical areas with 20+ business questions answered using advanced PostgreSQL queries including CTEs, window functions, multi-table joins, and aggregations.

---

## 🗂️ Database Schema

The database consists of **5 tables**:

| Table | Description |
|-------|-------------|
| `customers` | Customer details including region mapping |
| `products` | Product catalog with price and category |
| `orders` | Order-level data with date and return status |
| `orderdetails` | Line-item level data linking orders and products |
| `regions` | Region reference table |

### Entity Relationships
```
customers ──< orders ──< orderdetails >── products
    │
    └──> regions
```

---

## ❓ Business Questions Answered

### 1. 📊 General Sales Insights
- Total revenue generated over the entire period
- Revenue excluding returned orders
- Total revenue broken down by Year / Month
- Revenue by product category
- Average Order Value (AOV) across all orders
- AOV trends by Year / Month
- Average order size by region

### 2. 👥 Customer Insights
- Top 10 customers by total revenue spent
- Repeat customer rate
- Average time between consecutive orders (region-wise)
- Customer segmentation by total spend:
  - 🏆 **Platinum** — Spend > ₹1500
  - 🥇 **Gold** — ₹1000–1500
  - 🥈 **Silver** — ₹500–999
  - 🥉 **Bronze** — < ₹500
- Customer Lifetime Value (CLV)

### 3. 📦 Product & Order Insights
- Top 10 most sold products by quantity
- Top 10 most sold products by revenue
- Products with the highest return rate
- Return rate by category
- Average product price per region
- Sales trend for each product category

### 4. 📅 Temporal Trends
- Monthly sales trends over the period
- AOV change by month and week

### 5. 🗺️ Regional Insights
- Regions with highest and lowest order volume
- Revenue comparison across regions

### 6. 🔄 Return & Refund Insights
- Overall return rate by product category
- Overall return rate by region
- Customers making the most frequent returns

---

## 🛠️ SQL Concepts Used

| Concept | Usage |
|--------|-------|
| `CTEs (WITH clause)` | Customer segmentation, return rate calculations |
| `Window Functions` | `ROW_NUMBER`, `RANK` for ranking |
| `Multi-table JOINs` | Combining up to 5 tables in a single query |
| `CASE WHEN` | Customer tier segmentation |
| `EXTRACT / TO_CHAR` | Date-based aggregations (year, month, week) |
| `NULLIF / COALESCE` | Safe division and null handling |
| `Aggregate Functions` | `SUM`, `COUNT`, `ROUND`, `AVG` |
| `Subqueries` | Nested logic for return rate calculations |

---

## 📁 Project Structure

```
ecommerce-sql-analysis/
│
├── ecommerce_analysis.sql     # All queries — organized by section
├── Final_Project_Ecommerce.pdf  # Project brief and question list
└── README.md
```

---

## 💡 Key Insights (Sample)

- **Return Rate Analysis** — Identified top products and categories with highest return rates using dual CTEs comparing returned vs total quantity.
- **Customer Segmentation** — Classified customers into 4 spend tiers (Platinum → Bronze) to enable targeted marketing strategies.
- **Regional Performance** — Revenue and order volume comparison across regions to identify high-performing and underperforming markets.
- **AOV Trends** — Monthly and weekly AOV calculations to detect seasonal patterns in purchase behaviour.

---

## ⚙️ How to Run

1. Set up PostgreSQL and create a new database
2. Import the 5 tables (`customers`, `products`, `orders`, `orderdetails`, `regions`)
3. Open `ecommerce_analysis.sql` in pgAdmin or any PostgreSQL client
4. Execute queries section by section

---

## 👤 Author

**Shivam Shrestha**
Data Analyst | SQL • Power BI • Excel

- LinkedIn: [linkedin.com/in/shivam-shrestha](https://www.linkedin.com/in/shivam-shrestha)
- GitHub: [github.com/shivamshrestha](https://github.com/shivamshrestha)

---

> 💬 *Feel free to fork, explore, or raise an issue if you spot anything interesting!*
