
--Whats are the total earnings per year?

--Which plan is more popular?

--What is the average lifespan of a subscriber? annual memeber,monthly memeber

--How much do we earn in that lifespan?

--Data cleaning

SELECT*
FROM customer_info$

SELECT*
FROM customer_product_1$

--Combined customer_info$ and customer_product_1$ with join

SELECT customer_info$.customer_id,age,gender,product,signup_date_time,cancel_date_time
FROM customer_info$
Inner Join customer_product_1$
ON customer_info$.customer_id = customer_product_1$.customer_id

--create new table

SELECT customer_info$.customer_id,age,gender,product,signup_date_time,cancel_date_time
INTO customer_subscription_data2
FROM customer_info$
Inner Join customer_product_1$
ON customer_info$.customer_id = customer_product_1$.customer_id

--Check new table Custome_subscription_data2

SELECT*
FROM customer_subscription_data2


--add subscription_type column to differentiate between Annual and Monthly subscribers

Alter Table customer_subscription_data2
ADD subscription_type nvarchar(255)

--Created case statement to assign annual_subscritpion to cusomters that bought PRD_1 and monthly_subscription to memebers that bought Prd_2.

SELECT product,
CASE
WHEN product = 'prd_1' THEN 'Annual_subscription'
WHEN product = 'prd_2' THEN 'Monthly_subscription'
ELSE null
END AS subscription_type
FROM customer_subscription_data2

--Updated subscription column.

Update Customer_subscription_data2
SET subscription_type =CASE
WHEN product = 'prd_1' THEN 'Annual_subscription'
WHEN product = 'prd_2' THEN 'Monthly_subscription'
ELSE null
END


--Created CTE to delete duplicate cusotmer_id customers

WITH RownumCTE AS(
SELECT*,
	ROW_NUMBER() OVER (
	PARTITION BY customer_id,
				 age,
				 gender,
				 product,
				 signup_date_time,
				 cancel_date_time,
				 subscription_type
				 Order by
					customer_id
					) row_num
FROM customer_subscription_data2
)
SELECT*
FROM RownumCTE
WHERE row_num > 1

---Deleted duplicate rows.

WITH RownumCTE AS(
SELECT*,
	ROW_NUMBER() OVER (
	PARTITION BY customer_id,
				 age,
				 gender,
				 product,
				 signup_date_time,
				 cancel_date_time,
				 subscription_type
				 Order by
					customer_id
					) row_num
FROM customer_subscription_data2
)
DELETE
FROM RownumCTE
WHERE row_num > 1

---checking table again

SELECT*
FROM customer_subscription_data2
Order by signup_date_time ASC

--may need to redo this table to include row number to keep table numerically in order

--Most popular plan--annual
SELECT subscription_type,
COUNT(subscription_type) AS NUMofSubscribers
FROM customer_subscription_data2
GROUP BY subscription_type 

--average lifespan of a subscriber
--who is our oldest subscriber

--replace na with todays current date and then subtract signup date with cancel date to get the number of years or months and then get the average number of months 

--convert dates to 12-13-2020 format


SELECT CONVERT(varchar,getdate(







					
				






