-- Daffodil Cottage Co. SQL Portfolio Queries
-- Database style: SQLite-friendly SQL
-- Import each CSV or workbook sheet as its own table before running.

-- 1. Revenue and profit by service category
SELECT s.Service_Category, COUNT(t.Transaction_ID) AS transaction_count,
       ROUND(SUM(t.Revenue), 2) AS total_revenue,
       ROUND(SUM(t.Gross_Profit), 2) AS gross_profit,
       ROUND(SUM(t.Gross_Profit) * 1.0 / NULLIF(SUM(t.Revenue), 0), 3) AS gross_margin
FROM Transactions t
JOIN Services s ON t.Service_ID = s.Service_ID
GROUP BY s.Service_Category
ORDER BY total_revenue DESC;

-- 2. Top 10 clients by revenue
SELECT c.Client_ID, c.Client_Name, COUNT(t.Transaction_ID) AS transactions,
       ROUND(SUM(t.Revenue), 2) AS total_revenue,
       ROUND(SUM(t.Gross_Profit), 2) AS gross_profit
FROM Transactions t
JOIN Clients c ON t.Client_ID = c.Client_ID
GROUP BY c.Client_ID, c.Client_Name
ORDER BY total_revenue DESC
LIMIT 10;

-- 3. Client value segmentation
WITH client_revenue AS (
    SELECT c.Client_ID, c.Client_Name, SUM(t.Revenue) AS total_revenue
    FROM Clients c
    JOIN Transactions t ON c.Client_ID = t.Client_ID
    GROUP BY c.Client_ID, c.Client_Name
)
SELECT Client_ID, Client_Name, ROUND(total_revenue, 2) AS total_revenue,
       CASE WHEN total_revenue >= 1000 THEN 'High Value'
            WHEN total_revenue >= 500 THEN 'Mid Value'
            ELSE 'Starter' END AS client_value_segment
FROM client_revenue
ORDER BY total_revenue DESC;

-- 4. Monthly revenue trend
SELECT cal.Year, cal.Month_Number, cal.Month_Name, COUNT(t.Transaction_ID) AS transactions,
       ROUND(SUM(t.Revenue), 2) AS total_revenue,
       ROUND(SUM(t.Gross_Profit), 2) AS gross_profit
FROM Transactions t
JOIN Calendar cal ON t.Service_Date = cal.Date
GROUP BY cal.Year, cal.Month_Number, cal.Month_Name
ORDER BY cal.Year, cal.Month_Number;

-- 5. Acquisition channel performance
SELECT c.Acquisition_Channel, COUNT(DISTINCT c.Client_ID) AS clients,
       COUNT(t.Transaction_ID) AS transactions,
       ROUND(SUM(t.Revenue), 2) AS total_revenue,
       ROUND(SUM(t.Revenue) * 1.0 / COUNT(DISTINCT c.Client_ID), 2) AS revenue_per_client
FROM Transactions t
JOIN Clients c ON t.Client_ID = c.Client_ID
GROUP BY c.Acquisition_Channel
ORDER BY total_revenue DESC;

-- 6. City-zone performance
SELECT z.City_Zone, z.Market_Type, COUNT(DISTINCT c.Client_ID) AS clients,
       COUNT(t.Transaction_ID) AS transactions,
       ROUND(SUM(t.Revenue), 2) AS total_revenue,
       ROUND(SUM(t.Gross_Profit), 2) AS gross_profit
FROM Transactions t
JOIN Clients c ON t.Client_ID = c.Client_ID
JOIN City_Zones z ON c.City_Zone_ID = z.City_Zone_ID
GROUP BY z.City_Zone, z.Market_Type
ORDER BY total_revenue DESC;

-- 7. Marketing campaign ROI
SELECT m.Campaign_Name, m.Campaign_Goal, m.Campaign_Cost,
       COUNT(t.Transaction_ID) AS transactions,
       ROUND(SUM(t.Revenue), 2) AS campaign_revenue,
       ROUND(SUM(t.Gross_Profit), 2) AS campaign_gross_profit,
       ROUND((SUM(t.Gross_Profit) - m.Campaign_Cost) * 1.0 / NULLIF(m.Campaign_Cost, 0), 2) AS estimated_roi
FROM Marketing_Campaigns m
LEFT JOIN Transactions t ON m.Campaign_ID = t.Campaign_ID
GROUP BY m.Campaign_ID, m.Campaign_Name, m.Campaign_Goal, m.Campaign_Cost
ORDER BY estimated_roi DESC;

-- 8. Follow-up workload by service category
SELECT s.Service_Category, t.Follow_Up_Required, COUNT(*) AS transaction_count
FROM Transactions t
JOIN Services s ON t.Service_ID = s.Service_ID
GROUP BY s.Service_Category, t.Follow_Up_Required
ORDER BY s.Service_Category, transaction_count DESC;

-- 9. Pending payment report
SELECT c.Client_Name, t.Transaction_ID, t.Service_Date, s.Service_Name,
       ROUND(t.Revenue, 2) AS revenue, t.Payment_Status
FROM Transactions t
JOIN Clients c ON t.Client_ID = c.Client_ID
JOIN Services s ON t.Service_ID = s.Service_ID
WHERE t.Payment_Status = 'Pending'
ORDER BY t.Service_Date DESC;

-- 10. Service ranking by revenue using a window function
SELECT s.Service_Name, s.Service_Category, COUNT(t.Transaction_ID) AS transactions,
       ROUND(SUM(t.Revenue), 2) AS total_revenue,
       RANK() OVER (ORDER BY SUM(t.Revenue) DESC) AS revenue_rank
FROM Transactions t
JOIN Services s ON t.Service_ID = s.Service_ID
GROUP BY s.Service_Name, s.Service_Category
ORDER BY revenue_rank;

-- 11. Top Revenue-Generating Services
SELECT 
    service_type,
    COUNT(*) AS total_bookings,
    SUM(service_price) AS total_revenue,
    AVG(service_price) AS avg_service_value
FROM transactions
GROUP BY service_type
ORDER BY total_revenue DESC;
