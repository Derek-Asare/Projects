
--Business questions

--Whats the on-time delivery percentage per year?
--Whats the average number of days late on a shipment per year?
--What was the total number of shipments per year? 


--Cleaning Data in MSSQL

SELECT*
FROM DataCoSupplyChainDataset

--SELECT Order_Item_Quantity, COUNT(Order_Item_Quantity)
--FROM DataCoSupplyChainDataset
--Group by Order_Item_Quantity


SELECT Days_for_shipping_real,Days_for_shipment_scheduled,Delivery_status,Late_delivery_risk,Category_name,Customer_id,Customer_Country,Customer_Segment,customer_state,customer_street,customer_zipcode,Latitude,Longitude,Market,Order_city,Order_country,Order_date_DateOrders,Order_id,Order_region,Order_state,Order_status,Order_Zipcode,Product_Name,shipping_date_DateOrders,Shipping_Mode
INTO Transportation_dataset
FROM DataCoSupplyChainDataset

--Moved Days_for_shipping_real,Days_for_shipment_scheduled,Delivery_status,Late_delivery_risk,Category_name,Customer_id,Customer_Country,Customer_Segment,customer_state,customer_street,customer_zipcode,Latitude,Longitude,Market,Order_city,Order_country,Order_date_DateOrders,Order_id,Order_region,Order_state,Order_status,Order_Zipcode,Product_Name,shipping_date_DateOrders,Shipping_Mode
--All other tables were exculded since this is primarily foucusing on discovering OTD percentage.

--Checked for number of rows.

SELECT*
FROM Transportation_dataset
Order by Customer_id

--180,519 records

--Next step is to filter out canceled orders by using the Delviery_status column to get the true total numbers of orders that actaully shipped. 

SELECT*
FROM Transportation_dataset
Where Delivery_status <> 'shipping canceled'

--172,765 records

--Lets seperate the the shipments by year based off the order dates.
--First lets check to see what the min and max order dates are to check for the year range.

SELECT Min(order_date_DateOrders)
FROM Transportation_dataset

--Earliest order date is 1-1-2015

SELECT Max(order_date_DateOrders)
FROM Transportation_dataset

---Oldest order date is 1-31-2018

--We will use the years between 2015-2017 and exclude 2018 since the the max date for 2018 ends at 1/31/2018.


--The Order_Country is listed in a different language so exported the transportation_dataset to google sheets and used the google translate function to translate the spanish named countries into english.
--Removed Order_city,Order_state, and order Zicode due to numerous null values and too many city and state names with missing letters to properly translate with Googletranslate function. 
--Changed Days_for_shipping_real to Real_Transit_Time.(used =proper function in excel to capitalize first letter of each word)
--Changed Days_for_shipment_schdueled to Scheduled_Transit_Time(used =proper function in excel to capitalize first letter of each word)

--Uploaded sheets version of transportation dataset to MSSQL and saved it as Transportation_Dataset_2

SELECT*
FROM Transportation_Dataset_2


Delete FROM Transportation_dataset_2 Where Delivery_status = 'shipping canceled'


--The country "The savior" needs to be updated to show El Salvador. The googletranlate function in sheets technically translated it from spanish to english,but its mostly commonly referred to as El Salvador.

SELECT*
FROM Transportation_Dataset_2

Where Order_Destination_Country = 'The savior'

UPDATE Transportation_Dataset_2
SET Order_Destination_Country = 'El Salvador'
Where Order_Destination_Country = 'The Savior'

SELECT*
FROM Transportation_Dataset_2
Where Order_Destination_Country = 'El Salvador'


SELECT*
FROM Transportation_Dataset_2

----------Data cleaned



--Answering business questions

--To calculate the OTD(on-time delviery) percentage see below 
--OTD = (Number of items delivered on time) / (Total number of deliveries) * 100
--Also by solving this calculation we will also get the total numebr of shipments per year as well. 


--2015 



-- Whats the total number of shipments delviered on time in 2015?

SELECT Count(Delivery_Status) AS NumofOntimeDeliveries
FROM Transportation_Dataset_2
Where Delivery_status <> 'shipping canceled' AND Late_delivery_Risk = 0 AND year(Shipping_Date_Dateorders) = 2015

--25390 records delviered on time for 2015


-- Whats the total number of shipments for 2015?

SELECT Count(Shipping_Date_Dateorders) As TotalNumofshipments
FROM Transportation_Dataset_2
Where year(Shipping_Date_Dateorders) = 2015

--59330 total number of shipments for 2015


-- Whats the OTD percentage for 2015?

SELECT CAST((Count(Delivery_Status)*1.0) / 59330 AS decimal(10,2))* 100
FROM Transportation_Dataset_2
Where Delivery_status <> 'shipping canceled' AND Late_delivery_Risk = 0 AND year(Shipping_Date_Dateorders) = 2015

--43 Percent on-time delviery rate for 2015



--2016



-- Whats the total numebr of shipments delviered on time in 2016?

SELECT Count(Delivery_Status) AS NumofOntimeDeliveries
FROM Transportation_Dataset_2
Where Delivery_status <> 'shipping canceled' AND Late_delivery_Risk = 0 AND year(Shipping_Date_Dateorders) = 2016

--25468 records of on time deliveries in 2016


--Whats the total number of shipments for 2016?

SELECT Count(Delivery_status) As TotalNumofshipments
FROM Transportation_Dataset_2
Where Delivery_status <> 'shipping canceled' AND year(Shipping_Date_Dateorders) = 2016

--59982 total number of shipments for 2016


-- Whats the OTD percentage for 2015?

SELECT CAST((Count(Delivery_Status)*1.0) / 59982 AS decimal(10,2))* 100 AS On_Time_Percent
FROM Transportation_Dataset_2
Where Delivery_status <> 'shipping canceled' AND Late_delivery_Risk = 0 AND year(Shipping_Date_Dateorders) = 2016

--42 Percent on-time delviery rate for 2016



--2017


-- Whats the total numebr of shipments delviered on time in 2017?

SELECT Count(Delivery_Status) AS NumofOntimeDeliveries
FROM Transportation_Dataset_2
Where Delivery_status <> 'shipping canceled' AND Late_delivery_Risk = 0 AND year(Shipping_Date_Dateorders) = 2017

--22002 records of on time deliveries in 2017.


--Whats the total number of shipments for 2017?

SELECT Count(Delivery_status) As TotalNumofshipments
FROM Transportation_Dataset_2
Where Delivery_status <> 'shipping canceled' AND year(Shipping_Date_Dateorders) = 2017

--51180 total number of shipments for 2017


-- Whats the OTD percentage for 2015?

SELECT CAST((Count(Delivery_Status)*1.0) / 51180 AS decimal(10,2))* 100
FROM Transportation_Dataset_2
Where Delivery_status <> 'shipping canceled' AND Late_delivery_Risk = 0 AND year(Shipping_Date_Dateorders) = 2017


--43 Percent on-time delviery rate for 2017


--Whats the average days late on a shipment?

SELECT CAST(AVG(Real_Transit_Time - Scheduled_transit_time) AS decimal(10,2)) AS AVGdayslate
FROM Transportation_dataset_2
Where Late_Delivery_Risk = 1 
Group BY year(Shipping_Date_Dateorders)

--AVG 1.62 days late for the years 2015-2017

--Add avgdayslate column to Transportation_dataset_2

SELECT (Real_Transit_Time - Scheduled_transit_time) AS AVGdayslate
FROM Transportation_dataset_2
Where Late_Delivery_Risk = 1 


--ALTER TABLE transportation_dataset_2
--ADD AVGdayslate float


--Update transportation_dataset_2
--SET Avgdayslate = (Real_Transit_Time - Scheduled_transit_time)
--FROM Transportation_dataset_2


--Whats the average days late on a shipment per year?

SELECT AVG(Avgdayslate)
FROM Transportation_dataset_2
Where Late_Delivery_Risk = 1 AND year(Order_Date_Dateorders) = 2015

--1.62 days late

SELECT AVG(Avgdayslate)
FROM Transportation_dataset_2
Where Late_Delivery_Risk = 1 AND year(Order_Date_Dateorders) = 2016

--1.61 days late

SELECT AVG(Avgdayslate)
FROM Transportation_dataset_2
Where Late_Delivery_Risk = 1 AND year(Order_Date_Dateorders) = 2017

--1.61 days late


Select*
From Late_shipments



