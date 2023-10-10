
--Whats the most popular plan for 2021?

--What is the average lifespan of a subscriber before cancelation? min and max?

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
INTO customer_subscription_info
FROM customer_info$
Inner Join customer_product_1$
ON customer_info$.customer_id = customer_product_1$.customer_id

--Check new table Custome_subscription_data2

SELECT*
FROM customer_subscription_info


--add subscription_type column to differentiate between Annual and Monthly subscribers

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
				 Member_type
				 Order by
					customer_id
					) row_num
FROM customer_subscription_info
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
				 Member_type
				 Order by
					customer_id
					) row_num
FROM customer_subscription_info
)
DELETE
FROM RownumCTE
WHERE row_num > 1

---checking table again

SELECT*
FROM customer_subscription_info

--may need to redo this table to include row number to keep table numerically in order

--What is the most popular plan?

SELECT Member_type,
COUNT(Member_type) AS NUMofSubscribers
FROM customer_subscription_info
GROUP BY Member_type 

--Annual


--average lifespan of a subscriber
--who is our oldest subscriber

--Subtract signup_date with cancel_date to get the number of days a customer has been a memeber before cancelation. After that get the average amongst those days. That will tell you the average amount of time.

--convert dates to 12-13-2020 format


ALTER TABLE customer_subscription_info
ADD signup_date DATE

ALTER TABLE customer_subscription_info
ADD cancel_date nvarchar(255)


UPDATE customer_subscription_info
SET signup_date=signup_date_time

UPDATE customer_subscription_info
SET cancel_date=cancel_date_time


--need to put members with canceled subscirptions in a seperate table  


SELECT*
INTO canceled_subscription_customers
FROM customer_subscription_info
WHERE Cancel_date <> 'NA'

SELECT*
FROM canceled_subscription_customers

--convert datatype of cancel_date column to "date" format

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

--SELECT AVG(NumofSUBdays)
--FROM canceled_subscription_customers

--Msg 8117, Level 16, State 1, Line 181
--Operand data type varchar is invalid for avg operator.

--need to change dataype to numeric date type to perform Aggregate functions

ALTER TABLE canceled_subscription_customers
ALTER COLUMN NumofSUBdays int;


--Check table

SELECT*
FROM canceled_subscription_customers

--Data Cleaned


--Whats the average lifespan of a member before they cancel their subscription?

--SELECT AVG(NumofSUBdays)
--FROM canceled_subscription_customers

----459 days

----- quicker answer

--SELECT AVG(DATEDIFF(DAY, signup_date, cancel_date)) AS AvgSUBday 
--FROM canceled_subscription_customers


----Whats the average lifespan of a Annual member before they cancel their subscription?

--SELECT AVG(NumofSUBdays)
--FROM canceled_subscription_customers
--WHERE Member_type = 'Annual_member'

----505 days

----Whats the average lifespan of a Monthly member before they cancel their subscription?

--SELECT AVG(NumofSUBdays)
--FROM canceled_subscription_customers
--WHERE Member_type = 'Monthly_member'

----385 days


----Whats the Minimum lifespan of a Monthly member before they cancel their subscription?

--SELECT MIN(NumofSUBdays)
--FROM canceled_subscription_customers
--WHERE Member_type = 'Monthly_member'

----1 day

----Whats the Maximum lifespan of a Monthly member before they cancel their subscription?

--SELECT Max(NumofSUBdays)
--FROM canceled_subscription_customers
--WHERE Member_type = 'Monthly_member'

----1808 days

----Whats the Minimum lifespan of a Annual member before they cancel their subscription?

--SELECT Min(NumofSUBdays)
--FROM canceled_subscription_customers
--WHERE Member_type = 'Annual_member'

----1 day

----Whats the Maximum lifespan of a Annual member before they cancel their subscription?

--SELECT Max(NumofSUBdays)
--FROM canceled_subscription_customers
--WHERE Member_type = 'Annual_member'

----1821 days

--Whats the most popular plan for 2021?

--SELECT member_type,COUNT(member_type) AS NumofSUB
--FROM customer_subscription_info
--WHERE year(signup_date) = 2020
--GROUP BY member_type


--Monthly subscribtion

------Whats the most popular plan for female subscribers?

--SELECT member_type,Count(gender) AS Female_Subscribers
--FROM customer_subscription_info
--Where gender = 'female' and year(signup_date) = 2021
--Group by member_type


------Monthly subscribtion

------Whats the most popular plan for male subscribers?

--SELECT member_type,Count(gender) AS Male_Subscribers
--FROM customer_subscription_info
--Where gender = 'male' and year(signup_date) = 2021
--Group by member_type

------Monthly subscribtion













----customer info

--SELECT*
--INTO C_sub_info2
--FROM customer_subscription_info

--SELECT*
--FROM C_sub_info2

--UPDATE C_sub_info2
--SET cancel_date = null
--where cancel_date = 'NA'

--ALTER TABLE C_sub_info2
--ALTER COLUMN cancel_date DATE









----Whats the average earnings from a monthly member before cancelation?

--SELECT CAST((AVG(NumofSUBdays)) AS Float(3))/365*12*125
--FROM canceled_subscription_customers
--WHERE Member_type = 'Monthly_member'

----$1582

----Whats the average earnings from an annual member before cancelation?

--SELECT CAST((AVG(NumofSUBdays)) AS Float(3))/365*1200
--FROM canceled_subscription_customers
--WHERE Member_type = 'Monthly_member'

----$1265


--SELECT*
--FROM canceled_subscription_customers
--WHERE year(signup_date) = 2021

----Update customer_subscription_info drop signup_date_time and Cancel_date_time

--ALTER TABLE customer_subscription_info
--DROP COLUMN signup_date_time,cancel_date_time

----check table

--SELECT*
--FROM customer_subscription_info











					
				






