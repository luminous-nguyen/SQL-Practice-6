-- Ex 1
WITH cte as (
SELECT company_id, 
       title, 
       description, 
       count(job_id) as total_jobs
From job_listings
Group by company_id, title, description
)
SELECT count(total_jobs) as duplicate_companies
FROM cte
WHERE total_jobs >1
-- Ex 2
WITH cte as (
SELECT category,
       product,
       sum(spend) as total_spend,
       rank() over( partition by category
       order by sum(spend) desc) as ranking
FROM product_spend
WHERE extract(YEAR FROM transaction_date) = 2022
GROUP BY category, product
)
SELECT category, product, total_spend
FROM cte
Where ranking IN (1,2)
-- Ex 3
WITH cte as (
SELECT policy_holder_id, count(case_id) as total_calls
FROM callers
GROUP BY policy_holder_id
)
SELECT COUNT(policy_holder_id) as member_count
FROM cte 
WHERE total_calls >=3
-- Ex 4
SELECT a.page_id
FROM pages as a
   LEFT JOIN page_likes as b
   On a.page_id = b.page_id
   Where b.page_id is NULL
-- Ex 5
WITH CTE AS (
SELECT user_id,
       event_id,
       event_type,
       event_type
FROM user_actions
WHERE EXTRACT(MONTH FROM event_date) = 06
AND event_type IN ('sign-in', 'like', 'comment')
)
SELECT EXTRACT(MONTH FROM A.event_date) AS month,
       COUNT(DISTINCT A.user_id ) AS monthly_active_users
FROM user_actions AS A
INNER JOIN CTE AS B
ON A.user_id=B.user_id
WHERE EXTRACT(MONTH FROM A.event_date) = 07
AND A.event_type IN ('sign-in', 'like', 'comment')
GROUP BY EXTRACT(MONTH FROM A.event_date)
-- EX 6
SELECT TO_CHAR(trans_date::DATE, 'YYYY-MM') as month,
       country,
       COUNT(id) AS trans_count,
       COUNT(ID) FILTER(WHERE state = 'approved') AS approved_count,
       SUM(amount) AS trans_total_amount,
       SUM(amount) FILTER(WHERE state = 'approved') AS approved_total_amount
from Transactions
GROUP BY TO_CHAR(trans_date::DATE, 'YYYY-MM'), country
-- Ex 7
SELECT product_id, min(year) AS first_year, quantity,  price
FROM Sales
GROUP BY product_id
-- EX 8
WITH CTE AS (SELECT customer_id, COUNT(product_key) AS total_product
FROM Customer
GROUP BY customer_id
ORDER BY customer_id
)
SELECT customer_id
FROM CTE 
WHERE total_product = 2
-- EX 9
SELECT employee_id
FROM Employees
WHERE manager_id NOT IN (
    SELECT employee_id FROM Employees
)
-- EX 11

(SELECT A.NAME AS results
FROM Users AS A
LEFT JOIN MovieRating B
ON A.user_id = B.user_id
GROUP BY A.NAME 
ORDER BY COUNT(B.rating) DESC 
LIMIT 1 
)
UNION ALL 
(SELECT C.title 
FROM Movies AS C
LEFT JOIN MovieRating D
ON C.movie_id = D.movie_id
WHERE EXTRACT(YEAR_MONTH FROM created_at) = 202002
GROUP BY C.title 
ORDER BY AVG(D.RATING) DESC,1
LIMIT 1
)






