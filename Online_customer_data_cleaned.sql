-- Business Question

Whats our yearly earnings?
-which segment is paying the most?
-What states are are earning the most?


--AD hoc analysis
--Display yearly earnings
--Display earnings by segment
--Display earnings by state
--Display method of payment
--Display avg age range per segment


SELECT*
FROM Online_customer_data

--Data Cleaning


--reduce number of decimal places to 2 in AMount_spent
--ALTER TABLE Online_customer_data
--Alter column Amount_spent decimal(10,2)


WITH CTE_customer_data as
(
SELECT*
FROM Online_customer_data
Where Amount_spent IS NOT NULL
) 
,Employment_table as
(
SELECT*,
CASE 
When Employees_status = 'workers' THEN 'Employed'
When Employees_status = 'Employees' THEN 'Employed'
When Employees_status IS NULL THEN 'Undetermined'
When Employees_status = 'Unemployment' THEN 'Unemployed'
When Employees_status = 'self-employed' THEN 'Self-employed'
END AS Employment_status
FROM CTE_customer_data
) 
, Gender_table as
(
SELECT*,
CASE
WHEN Gender is NULL THEN 'Undetermined'
WHEN Gender = 'Male' THEN 'Male'
WHEN Gender = 'Female' THEN 'Female'
END AS Gender2
FROM Employment_table
)
,dup_flag_table as
(
SELECT*,
ROW_NUMBER() over (partition by Transaction_ID order by Transaction_date)dup_flag	
FROM Gender_table
)
SELECT*
--INTO Online_customer_data_info
FROM Dup_flag_table
WHERE dup_flag = 1 AND Age is not null 


--Check table
SELECT*
FROM Online_customer_data_info

--change missing to undetermined in segment

UPDATE Online_customer_data_info
SET segment = 'undetermined'
Where segment = 'Missing'


--ALTER TABLE Online_customer_data_info,
--RENAME COLUMN 'Amount_spent' to 'Revenue'
--RENAME COLUMN 'Segment' to 'Membership'
--RENAME COLUMN 'Gender2' to 'Gender'


SELECT*
FROM Online_customer_data_info

----Rename columns Amount_spent,Segment,and Gender2 to Revenue,Membership and Gender.

--EXEC sp_rename 'Online_customer_data_info.Amount_spent', 'Revenue'
--EXEC sp_rename 'Online_customer_data_info.Segment', 'Membership'
--EXEC sp_rename 'Online_customer_data_info.Gender2', 'Gender'

--add abbreviated state names column and abbreviations. 

ALTER TABLE Online_customer_data_info
ADD ABBV_state nvarchar(50)

UPDATE Online_customer_data_info
SET ABBV_state = 
CASE 
WHEN State_names ='Alabama' THEN 'AL' 
WHEN State_names = 'Alaska' THEN 'AK' 
WHEN State_names = 'Arizona' THEN 'AZ' 
WHEN State_names = 'Arkansas' THEN 'AR' 
WHEN State_names = 'California' THEN 'CA' 
WHEN State_names = 'Colorado' THEN 'CO' 
WHEN State_names = 'Connecticut' THEN 'CT' 
WHEN State_names = 'Delaware' THEN 'DE' 
WHEN State_names = 'District of Columbia' THEN 'DC' 
WHEN State_names = 'Florida' THEN 'FL' 
WHEN State_names = 'Georgia' THEN 'GA' 
WHEN State_names ='Hawaii' THEN 'HI' 
WHEN State_names ='Idaho' THEN 'ID' 
WHEN State_names ='Illinois' THEN 'IL' 
WHEN State_names = 'Indiana' THEN 'IN' 
WHEN State_names = 'Iowa' THEN 'IA' 
WHEN State_names = 'Kansas' THEN 'KS' 
WHEN State_names = 'Kentucky' THEN 'KY' 
WHEN State_names = 'Louisiana' THEN 'LA' 
WHEN State_names = 'Maine' THEN 'ME' 
WHEN State_names = 'Maryland' THEN 'MD' 
WHEN State_names = 'Massachusetts' THEN 'MA' 
WHEN State_names = 'Michigan' THEN 'MI' 
WHEN State_names = 'Minnesota' THEN 'MN' 
WHEN State_names = 'Mississippi' THEN 'MS' 
WHEN State_names = 'Missouri' THEN 'MO' 
WHEN State_names = 'Montana' THEN 'MT' 
WHEN State_names = 'Nebraska' THEN 'NE' 
WHEN State_names = 'Nevada' THEN 'NV' 
WHEN State_names = 'New Hampshire' THEN 'NH' 
WHEN State_names = 'New Jersey' THEN 'NJ' 
WHEN State_names = 'New Mexico' THEN 'NM' 
WHEN State_names = 'New York' THEN 'NY' 
WHEN State_names = 'North Carolina' THEN 'NC' 
WHEN State_names = 'North Dakota' THEN 'ND' 
WHEN State_names = 'Ohio' THEN 'OH' 
WHEN State_names = 'Oklahoma' THEN 'OK' 
WHEN State_names = 'Oregon' THEN 'OR' 
WHEN State_names = 'Pennsylvania' THEN 'PA' 
WHEN State_names = 'Rhode Island' THEN 'RI' 
WHEN State_names = 'South Carolina' THEN 'SC' 
WHEN State_names = 'South Dakota' THEN 'SD' 
WHEN State_names = 'Tennessee' THEN 'TN' 
WHEN State_names = 'Texas' THEN 'TX' 
WHEN State_names = 'Utah' THEN 'UT' 
WHEN State_names = 'Vermont' THEN 'VT' 
WHEN State_names = 'Virginia' THEN 'VA' 
WHEN State_names = 'Washington' THEN 'WA' 
WHEN State_names = 'West Virginia' THEN 'WV' 
WHEN State_names = 'Wisconsin' THEN 'WI' 
WHEN State_names = 'Wyoming' THEN 'WY' 
    ELSE NULL
END
Where ABBV_state is null


--Drop Gender,Age,and Referal

--ALTER TABLE Online_customer_data_info
--DROP Column Gender,Age,Referal

----Drop Employees_status

--ALTER TABLE Online_customer_data_info
--DROP Column Employees_status

--Data is clean













