USE customer_churn;

SELECT 
    *
FROM
    customers;


SELECT 
    COUNT(churn) AS total_churn
FROM
    customers
WHERE
    churn = 'yes';

SELECT 
    (SUM(CASE
        WHEN Churn = 'Yes' THEN 1
        ELSE 0
    END) * 100.0 / COUNT(*)) AS churn_rate
FROM
    customers;


SELECT 
    Churn, AVG(tenure) AS avg_contract_length
FROM
    customers
GROUP BY Churn;


SELECT 
    InternetService, COUNT(*) AS churned_count
FROM
    customers
WHERE
    Churn = 'Yes'
GROUP BY InternetService
ORDER BY churned_count DESC
LIMIT 1;


SELECT 
    Churn, AVG(MonthlyCharges) AS avg_monthly_charges
FROM
    customers
GROUP BY Churn;


SELECT 
    PaymentMethod, COUNT(*) AS payment_count
FROM
    customers
GROUP BY PaymentMethod
ORDER BY payment_count DESC
LIMIT 1;


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


SELECT 
    AVG(MonthlyCharges) AS avg_monthly_revenue,
    AVG(tenure) AS avg_customer_lifetime,
    (AVG(MonthlyCharges) * AVG(tenure)) AS lifetime_value
FROM
    customers;

SELECT 
    Churn,
    AVG(MonthlyCharges) AS avg_monthly_revenue,
    AVG(tenure) AS avg_customer_lifetime,
    (AVG(MonthlyCharges) * AVG(tenure)) AS lifetime_value
FROM
    customers
GROUP BY Churn;


SELECT 
    CustomerID, tenure, MonthlyCharges, Churn
FROM
    customers
WHERE
    tenure <= 12 AND MonthlyCharges >= 70;


#12) Detect customers likely to churn using window functions.
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


SELECT 
    InternetService,
    COUNT(*) AS total_customers,
    AVG(tenure) AS avg_tenure
FROM
    customers
GROUP BY InternetService
ORDER BY avg_tenure DESC;

