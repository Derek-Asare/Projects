
--What is the most popular plan for 2021?

--What is the average lifespan of a subscriber before cancelation? min and max?

--Data cleaning

SELECT*
FROM customer_info$

SELECT*
FROM customer_product_1$

--Combine customer_info$ and customer_product_1$ with join to combine customer and product information into one table.

SELECT customer_info$.customer_id,age,gender,product,signup_date_time,cancel_date_time
FROM customer_info$
Inner Join customer_product_1$
ON customer_info$.customer_id = customer_product_1$.customer_id

--Create new table

SELECT customer_info$.customer_id,age,gender,product,signup_date_time,cancel_date_time
INTO customer_subscription_info
FROM customer_info$
Inner Join customer_product_1$
ON customer_info$.customer_id = customer_product_1$.customer_id

--Check new table Custome_subscription_data2

SELECT*
FROM customer_subscription_info


--Add subscription_type column to differentiate between Annual and Monthly subscribers

Alter Table customer_subscription_info
ADD Member_type nvarchar(255)

--Created case statement to assign annual_subscritpion to cusomters that bought PRD_1 and monthly_subscription to memebers that bought Prd_2.

SELECT product,
CASE
WHEN product = 'prd_1' THEN 'Annual_Member'
WHEN product = 'prd_2' THEN 'Monthly_Member'
ELSE null
END AS subscription_type
FROM customer_subscription_info

--Updated subscription column.

Update customer_subscription_info
SET Member_type = CASE
WHEN product = 'prd_1' THEN 'Annual_Member'
WHEN product = 'prd_2' THEN 'Monthly_Member'
ELSE null
END


--Created CTE to delete duplicate customer_id rows

WITH RownumCTE AS(
SELECT*,
	ROW_NUMBER() OVER (
	PARTITION BY customer_id,
				 age,
				 gender,
				 product,
				 signup_date_time,
				 cancel_date_time,
				 Member_type
				 Order by
					customer_id
					) row_num
FROM customer_subscription_info
)
SELECT*
FROM RownumCTE
WHERE row_num > 1

---Deleting duplicate rows.

WITH RownumCTE AS(
SELECT*,
	ROW_NUMBER() OVER (
	PARTITION BY customer_id,
				 age,
				 gender,
				 product,
				 signup_date_time,
				 cancel_date_time,
				 Member_type
				 Order by
					customer_id
					) row_num
FROM customer_subscription_info
)
DELETE
FROM RownumCTE
WHERE row_num > 1

---Check Table

SELECT*
FROM customer_subscription_info


--Next step is to subtract signup_date with cancel_date to get the number of days a customer has been a memeber before cancelation. After that get the average amongst those days. That will tell you the average amount of time before cancelation.

--convert dates to 12-13-2020 format.


ALTER TABLE customer_subscription_info
ADD signup_date DATE

ALTER TABLE customer_subscription_info
ADD cancel_date nvarchar(255)


UPDATE customer_subscription_info
SET signup_date=signup_date_time

UPDATE customer_subscription_info
SET cancel_date=cancel_date_time


--Need to put members with canceled subscirptions in a seperate table.

SELECT*
INTO canceled_subscription_customers
FROM customer_subscription_info
WHERE Cancel_date <> 'NA'

SELECT*
FROM canceled_subscription_customers

--Convert datatype of cancel_date column to "date" format

ALTER TABLE canceled_subscription_customers
ALTER COLUMN cancel_date date;

-- subtract signup_date from cancel_date to get number of days subscribed before cancelation(NumofSUBdays)

SELECT DATEDIFF(DAY, signup_date, cancel_date) AS 'NumofSUBdays' 
FROM canceled_subscription_customers

--ADD NUMofSUBdays column to canceled_subscription_customers table. Then perform aggragate functions.

ALTER TABLE canceled_subscription_customers
ADD NumofSUBdays varchar

UPDATE canceled_subscription_customers
SET NumofSUBdays = DATEDIFF(DAY, signup_date, cancel_date) 
FROM canceled_subscription_customers

--update worked but only single digit days were coming up....need to increase character length in column.

--changed varchar from 1 to 100

ALTER TABLE canceled_subscription_customers
ALTER COLUMN NumofSUBdays varchar(100);

--Drop signup_date_time and cancel_date_time

ALTER TABLE canceled_subscription_customers
DROP COLUMN signup_date_time, cancel_date_time

--Change dataype to numeric date type to perform Aggregate functions

ALTER TABLE canceled_subscription_customers
ALTER COLUMN NumofSUBdays int;

--Check table

SELECT*
FROM canceled_subscription_customers

--Data is Cleaned


--Whats the average lifespan of a member before they cancel their subscription?

SELECT AVG(NumofSUBdays) AS AvgSUBday
FROM canceled_subscription_customers

----459 days


----Whats the Minimum lifespan of a Monthly member before they cancel their subscription?

SELECT MIN(NumofSUBdays)
FROM canceled_subscription_customers
WHERE Member_type = 'Monthly_member'

----1 day

----Whats the Maximum lifespan of a Monthly member before they cancel their subscription?

SELECT Max(NumofSUBdays)
FROM canceled_subscription_customers
WHERE Member_type = 'Monthly_member'

----1808 days

----Whats the Minimum lifespan of a Annual member before they cancel their subscription?

SELECT Min(NumofSUBdays)
FROM canceled_subscription_customers
WHERE Member_type = 'Annual_member'

----1 day

----Whats the Maximum lifespan of a Annual member before they cancel their subscription?

SELECT Max(NumofSUBdays)
FROM canceled_subscription_customers
WHERE Member_type = 'Annual_member'

----1821 days

--Whats the most popular membership plan for 2021?

SELECT member_type,COUNT(member_type) AS NumofSUB
FROM customer_subscription_info
WHERE year(signup_date) = 2021
GROUP BY member_type

----ANS Monthly membership

----Whats the average lifespan of a Annual member before they cancel their subscription?

SELECT AVG(NumofSUBdays)
FROM canceled_subscription_customers
WHERE Member_type = 'Annual_member'

----505 days

----Whats the average lifespan of a Monthly member before they cancel their subscription?

SELECT AVG(NumofSUBdays)
FROM canceled_subscription_customers
WHERE Member_type = 'Monthly_member'

----385 days






















