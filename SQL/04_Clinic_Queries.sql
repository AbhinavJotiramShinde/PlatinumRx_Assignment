-- 1. Use the correct database
USE clinic_management;

-- 2. Find the revenue we got from each sales channel in a given year (2021)
SELECT 
    sales_channel, 
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE EXTRACT(YEAR FROM datetime) = 2021
GROUP BY sales_channel;

-- 3. Find top 10 the most valuable customers for a given year (2021)
SELECT 
    uid, 
    SUM(amount) AS total_spent
FROM clinic_sales
WHERE EXTRACT(YEAR FROM datetime) = 2021
GROUP BY uid
ORDER BY total_spent DESC
LIMIT 10;

-- 4. Find month wise revenue, expense, profit, status (profitable / not-profitable) for 2021
WITH MonthlyRevenue AS (
    SELECT 
        EXTRACT(MONTH FROM datetime) AS mo, 
        SUM(amount) AS rev
    FROM clinic_sales 
    WHERE EXTRACT(YEAR FROM datetime) = 2021 
    GROUP BY 1
),
MonthlyExpenses AS (
    SELECT 
        EXTRACT(MONTH FROM datetime) AS mo, 
        SUM(amount) AS ex
    FROM expenses 
    WHERE EXTRACT(YEAR FROM datetime) = 2021 
    GROUP BY 1
)
SELECT 
    COALESCE(r.mo, e.mo) AS month_number,
    COALESCE(r.rev, 0) AS revenue,
    COALESCE(e.ex, 0) AS expense,
    (COALESCE(r.rev, 0) - COALESCE(e.ex, 0)) AS profit,
    CASE 
        WHEN (COALESCE(r.rev, 0) - COALESCE(e.ex, 0)) > 0 THEN 'Profitable' 
        ELSE 'Not-profitable' 
    END AS status
FROM MonthlyRevenue r
LEFT JOIN MonthlyExpenses e ON r.mo = e.mo
ORDER BY month_number;

-- 5. For each city find the most profitable clinic for a given month (September 2021)
WITH CityClinicProfit AS (
    SELECT 
        c.city, 
        c.cid, 
        c.clinic_name,
        SUM(s.amount) AS total_revenue -- Revenue used as profit metric per schema
    FROM clinics c
    JOIN clinic_sales s ON c.cid = s.cid
    WHERE EXTRACT(YEAR FROM s.datetime) = 2021 
      AND EXTRACT(MONTH FROM s.datetime) = 9
    GROUP BY 1, 2, 3
),
RankedClinics AS (
    SELECT 
        city, cid, clinic_name, total_revenue,
        RANK() OVER(PARTITION BY city ORDER BY total_revenue DESC) AS rnk
    FROM CityClinicProfit
)
SELECT city, cid, clinic_name, total_revenue
FROM RankedClinics
WHERE rnk = 1;

-- 6. For each state find the second least profitable clinic for a given month (September 2021)
WITH StateClinicProfit AS (
    SELECT 
        c.state, 
        c.cid, 
        c.clinic_name,
        SUM(s.amount) AS total_revenue
    FROM clinics c
    JOIN clinic_sales s ON c.cid = s.cid
    WHERE EXTRACT(YEAR FROM s.datetime) = 2021 
      AND EXTRACT(MONTH FROM s.datetime) = 9
    GROUP BY 1, 2, 3
),
RankedClinics AS (
    SELECT 
        state, cid, clinic_name, total_revenue,
        DENSE_RANK() OVER(PARTITION BY state ORDER BY total_revenue ASC) AS rnk
    FROM StateClinicProfit
)
SELECT state, cid, clinic_name, total_revenue
FROM RankedClinics
WHERE rnk = 2;