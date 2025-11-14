# 🍕 Pizza Sales Analysis Project

A complete end-to-end data analytics project analyzing pizza store sales using SQL, Power BI, and DAX.

---

## 📌 **Project Overview**

This project analyzes transactional pizza sales data to identify insights, trends, and KPIs that support business decisions in sales, marketing, and operations.

Dataset: `pizza_sales.csv`

Technologies Used:

* PostgreSQL (Data Cleaning, Modeling, Views)
* Power BI (Dashboard & Visualizations)
* DAX (KPIs & Measures)
* DirectQuery Mode

---

## 🎯 **Business Objectives**

* Calculate **Total Revenue, Total Pizzas Sold, Total Orders**.
* Analyze **sales by category, size, ingredients, and time trends**.
* Identify **top & bottom performing pizzas**.
* Understand customer behavior through **AOV** & **Avg. Pizza per Order**.
* Create **interactive dashboards** for insights.

---

## 📊 **Project Report Screenshots**

### 🖼️ Home Page

![Home Page](home_page.png)

### 🖼️ Analysis Page

![Analysis Page](analysis_page.png)

### 🖼️ Summary Page

![Summary Page](summary_page.png)

---

## 📊 Key Performance Indicators (KPIs)

* **Total Revenue** = SUM(total_price)
* **Total Pizzas Sold** = SUM(quantity)
* **Total Orders** = DISTINCTCOUNT(order_id)
* **Average Order Value (AOV)** = Revenue / Orders
* **Average Pizza per Order** = Pizzas Sold / Orders

---

## 🧱 **Database Schema – PostgreSQL**

### **Create Table: `pizza_sales`**

```sql
CREATE TABLE pizza_sales
(
  pizza_id INT PRIMARY KEY NOT NULL,
  order_id INT NOT NULL,
  pizza_name_id VARCHAR(250),
  quantity INT NOT NULL,
  order_date DATE NOT NULL,
  order_time TIME NOT NULL,
  unit_price FLOAT NOT NULL,
  total_price FLOAT NOT NULL,
  pizza_size VARCHAR(5),
  pizza_category VARCHAR(250),
  pizza_ingredients TEXT NOT NULL,
  pizza_name VARCHAR(500) NOT NULL
);
```

### **Key SQL Metrics**

```sql
-- Total Revenue
SELECT ROUND(SUM(total_price)::numeric,2) AS "Total Revenue"
FROM pizza_sales;

-- Total Pizzas Sold
SELECT SUM(quantity) AS "Total Pizzas Sold" FROM pizza_sales;

-- Total Orders
SELECT COUNT(DISTINCT order_id) AS "Total Orders" FROM pizza_sales;

-- Average Order Value
SELECT ROUND(SUM(total_price)::decimal/COUNT(DISTINCT order_id), 2) AS "AOV" FROM pizza_sales;

-- Average Pizza per Order
SELECT ROUND(SUM(quantity)::decimal/COUNT(DISTINCT order_id), 2) AS "Avg Pizza per Order" FROM pizza_sales;
```

---

## 🧼 **Data Cleaning & Optimization**

### Rename Main ID

```sql
ALTER TABLE pizza_sales
RENAME COLUMN pizza_id TO sale_id;
```

### Create Menu Dimension View

```sql
CREATE OR REPLACE VIEW dim_menu AS
SELECT
  ROW_NUMBER() OVER (ORDER BY pizza_name_id ASC) AS pizza_id,
  pizza_name,
  pizza_name_id,
  unit_price,
  pizza_size,
  pizza_category
FROM pizza_sales
GROUP BY pizza_name, pizza_name_id, pizza_category, unit_price, pizza_size
ORDER BY pizza_id;
```

### Create Orders View

```sql
CREATE OR REPLACE VIEW orders AS
SELECT pd.sale_id, pd.order_id, dm.pizza_id, pd.order_date, pd.order_time,
       pd.total_price, pd.quantity
FROM pizza_sales pd
LEFT JOIN dim_menu dm
ON pd.pizza_name_id = dm.pizza_name_id
ORDER BY sale_id ASC;
```

### Create Calendar Dimension View

```sql
CREATE OR REPLACE VIEW dim_calendar AS
SELECT DISTINCT
  order_date,
  EXTRACT(DAY FROM order_date) AS date_of_order,
  EXTRACT(MONTH FROM order_date) AS month,
  EXTRACT(YEAR FROM order_date) AS year,
  EXTRACT(DOW FROM order_date) AS day_of_week_number,
  EXTRACT(QUARTER FROM order_date) AS quarter_num,
  EXTRACT(HOUR FROM order_time) AS hour,
  TO_CHAR(order_date, 'Dy') AS day_name,
  TO_CHAR(order_date, 'Mon') AS month_name
FROM pizza_sales;
```

---

## 📈 **Power BI Measures (DAX)**

### **Base KPIs**

```dax
Total Revenue = SUM(orders[total_price])
Total Pizzas Sold = SUM(orders[quantity])
Total Orders = DISTINCTCOUNT(orders[order_id])
Average Order Value = DIVIDE([Total Revenue], [Total Orders])
Average Pizza per Order = DIVIDE([Total Pizzas Sold], [Total Orders])
```

### **% of Total Metrics**

```dax
% of Total Sales = DIVIDE([Total Revenue] * 100, CALCULATE([Total Revenue], ALL(orders)))
% of Total Quantity = DIVIDE([Total Pizzas Sold] * 100, CALCULATE([Total Pizzas Sold], ALL(orders)))
```

### **Dynamic Title**

```dax
SUBLINE =
"FROM " & FORMAT(MIN(dim_calendar[order_date]), "DD-MMM-YYYY") &
" TO " & FORMAT(MAX(dim_calendar[order_date]), "DD-MMM-YYYY")
```

### **Field Parameters**

#### Category & Size

```dax
Size & Category = {
    ("% of Sales", NAMEOF('orders'[% of Total Sales]), 0),
    ("% of Quantity", NAMEOF('orders'[% of Total Quantity]), 1)
}
```

#### Trend Parameter

```dax
Trend Parameter = {
    ("Hour", NAMEOF('dim_calendar'[hour]), 0),
    ("Day", NAMEOF('dim_calendar'[day_name]), 1),
    ("Month", NAMEOF('dim_calendar'[month_name]), 2),
    ("Quarter", NAMEOF('dim_calendar'[quarter_num]), 3)
}
```

---

## 📊 **Dashboards Created**

### **1. Summary Dashboard**

* Top 5 & Bottom 5 Pizzas
* Revenue & Quantity KPIs
* Sales by Category
* Executive Summary

### **2. Analysis Dashboard**

* Revenue Trends (Hour, Day, Month, Quarter)
* Sales by Category & Size
* Orders by Day
* Quantity vs Sales split

### **3. Home Page**

* Project introduction
* Timeline
* Branding & creator details

---

## 🧠 **Business Insights**

* Classic pizzas dominate both revenue & quantity.
* Large (L) size contributes the highest revenue.
* Friday records the highest orders.
* Quarter 2 is the peak revenue period.
* Some pizzas consistently underperform → candidates for menu review.

---

## 📝 **Deliverables**

* PostgreSQL Scripts
* Power BI dashboard (.pbix)
* BRD Documentation
* Insights & Recommendations

---

## 👨‍💻 **Created By**

**Vara Prasad**
[varaprasaddata@gmail.com](mailto:varaprasaddata@gmail.com)
