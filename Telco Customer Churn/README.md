# Customer Churn Analysis

This repository contains a series of SQL queries to analyze customer churn data, focusing on understanding factors affecting customer retention and identifying trends in customer behavior. The queries are based on a dataset with customer information, such as `Churn`, `Contract`, `tenure`, `MonthlyCharges`, `PaymentMethod`, `InternetService`, `Gender`, and `SeniorCitizen`.

## Table of Contents

1. [Basic Customer Data Query](#basic-customer-data-query)
2. [Churn Analysis](#churn-analysis)
3. [Contract Length and Churn](#contract-length-and-churn)
4. [Churned Customers by Internet Service](#churned-customers-by-internet-service)
5. [Average Monthly Charges by Churn Status](#average-monthly-charges-by-churn-status)
6. [Most Popular Payment Methods](#most-popular-payment-methods)
7. [Contract Types and Churn Percentage](#contract-types-and-churn-percentage)
8. [Customer Tenure Groups](#customer-tenure-groups)
9. [Churn by Gender](#churn-by-gender)
10. [Churn by Senior Citizen Status](#churn-by-senior-citizen-status)
11. [Churn by Gender and Senior Citizen Status](#churn-by-gender-and-senior-citizen-status)
12. [Customer Lifetime Value](#customer-lifetime-value)
13. [Customer Lifetime Value by Churn Status](#customer-lifetime-value-by-churn-status)
14. [Identifying High-Risk Customers](#identifying-high-risk-customers)
15. [Churn Rate by Payment Method](#churn-rate-by-payment-method)
16. [Churn Rate by Internet Service](#churn-rate-by-internet-service)

## Queries

### 1. Basic Customer Data Query
```sql
USE customer_churn;

SELECT 
    *
FROM
    customers;
```

### 2. Churn Analysis
```sql
SELECT 
    COUNT(churn) AS total_churn
FROM
    customers
WHERE
    churn = 'yes';
```

### 3. Contract Length and Churn
```sql
SELECT 
    Churn, AVG(tenure) AS avg_contract_length
FROM
    customers
GROUP BY Churn;
```

### 4. Churned Customers by Internet Service
```sql
SELECT 
    InternetService, COUNT(*) AS churned_count
FROM
    customers
WHERE
    Churn = 'Yes'
GROUP BY InternetService
ORDER BY churned_count DESC
LIMIT 1;
```

### 5. Average Monthly Charges by Churn Status
```sql
SELECT 
    Churn, AVG(MonthlyCharges) AS avg_monthly_charges
FROM
    customers
GROUP BY Churn;
```

### 6. Most Popular Payment Methods
```sql
SELECT 
    PaymentMethod, COUNT(*) AS payment_count
FROM
    customers
GROUP BY PaymentMethod
ORDER BY payment_count DESC
LIMIT 1;
```

### 7. Contract Types and Churn Percentage
```sql
SELECT 
    Contract,
    COUNT(*) AS contract_count,
    (COUNT(*) * 100.0 / (SELECT 
            COUNT(*)
        FROM
            customers)) AS percentage
FROM
    customers
GROUP BY Contract
ORDER BY percentage DESC;
```

### 8. Customer Tenure Groups
```sql
SELECT 
    CASE
        WHEN tenure BETWEEN 1 AND 12 THEN '1 year or less'
        WHEN tenure BETWEEN 13 AND 24 THEN '1-2 years'
        WHEN tenure BETWEEN 25 AND 36 THEN '2-3 years'
        ELSE '3+ years'
    END AS tenure_group,
    COUNT(*) AS customer_count
FROM
    customers
GROUP BY tenure_group
ORDER BY tenure_group;
```

### 9. Churn by Gender
```sql
SELECT 
    Gender,
    COUNT(*) AS total_customers,
    SUM(CASE
        WHEN Churn = 'Yes' THEN 1
        ELSE 0
    END) AS churned_customers,
    (SUM(CASE
        WHEN Churn = 'Yes' THEN 1
        ELSE 0
    END) * 100.0 / COUNT(*)) AS churn_rate
FROM
    customers
GROUP BY Gender;
```

### 10. Churn by Senior Citizen Status
```sql
SELECT 
    SeniorCitizen,
    COUNT(*) AS total_customers,
    SUM(CASE
        WHEN Churn = 'Yes' THEN 1
        ELSE 0
    END) AS churned_customers,
    (SUM(CASE
        WHEN Churn = 'Yes' THEN 1
        ELSE 0
    END) * 100.0 / COUNT(*)) AS churn_rate
FROM
    customers
GROUP BY SeniorCitizen;
```

### 11. Churn by Gender and Senior Citizen Status
```sql
SELECT 
    Gender,
    SeniorCitizen,
    COUNT(*) AS total_customers,
    SUM(CASE
        WHEN Churn = 'Yes' THEN 1
        ELSE 0
    END) AS churned_customers,
    (SUM(CASE
        WHEN Churn = 'Yes' THEN 1
        ELSE 0
    END) * 100.0 / COUNT(*)) AS churn_rate
FROM
    customers
GROUP BY Gender , SeniorCitizen
ORDER BY Gender , SeniorCitizen;
```

### 12. Customer Lifetime Value
```sql
SELECT 
    AVG(MonthlyCharges) AS avg_monthly_revenue,
    AVG(tenure) AS avg_customer_lifetime,
    (AVG(MonthlyCharges) * AVG(tenure)) AS lifetime_value
FROM
    customers;
```

### 13. Customer Lifetime Value by Churn Status
```sql
SELECT 
    Churn,
    AVG(MonthlyCharges) AS avg_monthly_revenue,
    AVG(tenure) AS avg_customer_lifetime,
    (AVG(MonthlyCharges) * AVG(tenure)) AS lifetime_value
FROM
    customers
GROUP BY Churn;
```

### 14. Identifying High-Risk Customers
```sql
WITH CustomerRisk AS (
    SELECT 
        CustomerID,
        Churn,
        tenure,
        MonthlyCharges,
        NTILE(4) OVER (ORDER BY tenure ASC) AS tenure_risk,  
        NTILE(4) OVER (ORDER BY MonthlyCharges DESC) AS charge_risk  
    FROM customers
)
SELECT 
    CustomerID, 
    tenure, 
    MonthlyCharges, 
    Churn,
    tenure_risk,
    charge_risk,
    CASE  
        WHEN tenure_risk = 1 AND charge_risk = 1 THEN 'High Risk'  
        WHEN tenure_risk = 1 OR charge_risk = 1 THEN 'Medium Risk'  
        ELSE 'Low Risk'  
    END AS risk_category
FROM CustomerRisk;
```

### 15. Churn Rate by Payment Method
```sql
SELECT 
    PaymentMethod,
    COUNT(*) AS total_customers,
    SUM(CASE
        WHEN Churn = 'Yes' THEN 1
        ELSE 0
    END) AS churned_customers,
    (SUM(CASE
        WHEN Churn = 'Yes' THEN 1
        ELSE 0
    END) * 100.0 / COUNT(*)) AS churn_rate
FROM
    customers
GROUP BY PaymentMethod
ORDER BY churn_rate ASC;
```

### 16. Churn Rate by Internet Service
```sql
SELECT 
    InternetService,
    COUNT(*) AS total_customers,
    AVG(tenure) AS avg_tenure
FROM
    customers
GROUP BY InternetService
ORDER BY avg_tenure DESC;
```

## Setup

To use the queries, ensure you have access to the `customer_churn` database and the `customers` table. Each query can be executed in an SQL environment, such as MySQL, PostgreSQL, or similar database management systems. Adjust the queries according to your environment if necessary.

## License

This project is licensed under the MIT License.
