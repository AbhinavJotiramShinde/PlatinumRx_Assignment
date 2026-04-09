USE hotel_management;

-- 1. For every user, get user_id and last booked room_no
SELECT user_id, room_no
FROM (
    SELECT user_id, room_no, 
           ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY booking_date DESC) as rn
    FROM bookings
) t WHERE rn = 1;

-- 2. Booking_id and total billing amount for November 2021
SELECT b.booking_id, SUM(bc.item_quantity * i.item_rate) as total_billing
FROM bookings b
JOIN booking_commercials bc ON b.booking_id = bc.booking_id
JOIN items i ON bc.item_id = i.item_id
WHERE bc.bill_date >= '2021-11-01' AND bc.bill_date < '2021-12-01'
GROUP BY b.booking_id;

-- 3. Bill_id and amount for October 2021 where amount > 1000
SELECT bc.bill_id, SUM(bc.item_quantity * i.item_rate) as bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE bc.bill_date >= '2021-10-01' AND bc.bill_date < '2021-11-01'
GROUP BY bc.bill_id
HAVING bill_amount > 1000;

-- 4. Most and least ordered item of each month in 2021
WITH MonthlyStats AS (
    SELECT EXTRACT(MONTH FROM bill_date) as mo, item_id, SUM(item_quantity) as qty
    FROM booking_commercials WHERE EXTRACT(YEAR FROM bill_date) = 2021 GROUP BY 1, 2
),
Ranked AS (
    SELECT mo, item_id, qty,
           RANK() OVER(PARTITION BY mo ORDER BY qty DESC) as r_most,
           RANK() OVER(PARTITION BY mo ORDER BY qty ASC) as r_least
    FROM MonthlyStats
)
SELECT mo as month, item_id, qty, 
       CASE WHEN r_most = 1 THEN 'Most Ordered' ELSE 'Least Ordered' END as status
FROM Ranked WHERE r_most = 1 OR r_least = 1;

-- 5. Customers with second highest bill value of each month in 2021
WITH UserBills AS (
    SELECT EXTRACT(MONTH FROM bc.bill_date) as mo, b.user_id, SUM(bc.item_quantity * i.item_rate) as bill_val
    FROM booking_commercials bc
    JOIN bookings b ON bc.booking_id = b.booking_id
    JOIN items i ON bc.item_id = i.item_id
    WHERE EXTRACT(YEAR FROM bc.bill_date) = 2021
    GROUP BY 1, 2
),
RankedBills AS (
    SELECT mo, user_id, bill_val, DENSE_RANK() OVER(PARTITION BY mo ORDER BY bill_val DESC) as rnk
    FROM UserBills
)
SELECT mo as month, user_id, bill_val FROM RankedBills WHERE rnk = 2;
