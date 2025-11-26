
Use IndiaDB;

Create table sales_store (
Transaction_id varchar(20),
customer_id varchar(20),
customer_name varchar(20),
customer_age int,
Gender varchar(15),
product_id varchar(15),
product_name varchar (20),
Product_category varchar(20),
quantiy int,
prce int,

payment_mode Varchar(20),
purchase_date Date,
time_of_purchase Time,
Status Varchar(20)
);

DROP TABLE sales_store;

Create table sales_store (
Transaction_id varchar(20),
customer_id varchar(20),
customer_name varchar(20),
customer_age int,
Gender varchar(15),
product_id varchar(15),
product_name varchar (20),
Product_category varchar(20),
quantiy int,
prce int,

payment_mode Varchar(20),
purchase_date Date,
time_of_purchase Time,
Status Varchar(20)
);

select * from sales_store

------------date insertion------------
set dateformat dmy


Bulk insert sales_store 
from 'C:\Users\HP\Desktop\Unified Projects\Project 1 sales_store.csv'
with(
firstrow=2,
fieldterminator=',',
rowterminator='\n'
);
drop table sales_store ;
----------------------------------------------------------------------
-----------------------Starting---------------------------------------
create Table Sales_Store(
transaction_id Varchar (20),
customer_id varchar (15),
customer_name varchar (30),
customer_age Int,
gender Varchar (10),
product_id Varchar (30),
product_name Varchar (20),
product_category varchar (30),
quantiy int,
prce Float,
payment_mode varchar (30),
purchase_date Date,
time_of_purchase Time,
status varchar (20)
);

select * from Sales_Store

--data insertion---
set dateformat dmy

bulk insert sales_store
from 'C:\Users\HP\Desktop\Unified Projects\Project 1 sales_store.csv'
with (
fieldterminator = ',',
rowterminator = '\n',
firstrow = 2,
format = 'csv'
);


select * from Sales_Store


select * into store_sales from Sales_Store


select * from Sales_Store
select * from store_sales


use IndiaDB;
select * from store_sales

-------------------Data Cleaning---------------------

-----------To check duplicate data-------------

Select transaction_id,count(*) from store_sales
group by transaction_id 
having count(transaction_id)>1
 

SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY transaction_id) AS row_num
    FROM store_sales
) AS numbered_sales
WHERE row_num >1;

-----------------------------OR----------------------------------
WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY transaction_id) AS row_num
    FROM store_sales
)
SELECT *
FROM CTE
where transaction_id in('TXN240646','TXN342128','TXN855235','TXN981773');

WHERE row_num > 1;

----------------------------------------------------------------------------

WITH sales_with_rownum AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY transaction_id) AS row_num
    FROM store_sales
)
DELETE FROM store_sales
WHERE transaction_id IN (
    SELECT transaction_id
    FROM sales_with_rownum
    WHERE row_num > 1
);

select * from store_sales

------------------- Correction of header-----------------------

exec sp_rename 'store_sales.quantiy' , 'quantity','column'
exec sp_rename 'store_sales.prce' , 'price','column'

select * from store_sales

------------------ TO check data type-----------------------

select column_name, data_type 
from INFORMATION_SCHEMA.COLUMNS
where table_name ='store_sales'

-------------To check null count-------------------

DECLARE @TableName NVARCHAR(128) = 'YourTable';
DECLARE @SQL NVARCHAR(MAX) = '';

SELECT @SQL = STRING_AGG(
    'SELECT ''' + COLUMN_NAME + ''' AS ColumnName, COUNT(*) AS NullCount 
     FROM ' + @TableName + ' 
     WHERE [' + COLUMN_NAME + '] IS NULL',
    ' UNION ALL '
)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @TableName;

EXEC sp_executesql @SQL;

--------------To treat null value------------------

select * from Sales_store
where transaction_id is null
or
customer_id is null
or
customer_name is null
or
customer_age is null
or
gender is null
or
product_id is null
or 
product_name is null
or 
product_category is null
or
quantiy is null 
or
prce is null
or
payment_mode is null
or
purchase_date is null 
or
time_of_purchase is null 
or
status is null

---------------To delete null value-----------------

Delete from Sales_store
where transaction_id is null

SELECT * from Sales_store
where customer_name = 'Ehsaan Ram'


Update Sales_store
set customer_id= 'CUST9494'
where customer_name = 'Ehsaan Ram'

SELECT * from Store_sales
where customer_name = 'Damini Raju'


SELECT * from Sales_store
where customer_id= 'CUST1003'

Update Sales_store
set customer_name= 'Mahika saini'
where customer_id='CUST1003'

Update Sales_store
set customer_age= '35',
 gender= 'Male'
where customer_id='CUST1003'

-------------------distinct---------------------------
select distinct gender from Store_sales

update Store_sales set gender='Male' where gender = 'M'
update Store_sales set gender='Female' where gender = 'F'

select distinct payment_mode from Store_sales
update Store_sales set payment_mode='Credit Card' where payment_mode = 'CC'

select * from store_sales

---------------------Data Analysis----------------------
--------------------------------------------------------

Q.1) What are the top 5 best-selling products by quantity?

select top 5 product_name ,sum(quantity) as total_quantity_sold from store_sales
group by product_name
order by total_quantity_sold desc

----> business problem : we don't know which products are most in demand.
----> business impact : help prioritize  stock and boost sales through targeted promotion.

Q.2) Which product is most frequently canceled?

select top 5 product_name , count(*) as total_cancelled from store_sales 
where status = 'cancelled'
group by product_name
order by total_cancelled desc

----> business problem : frequent cancellation affect revenue and customer trust'
----> business impact : identify poor-performing products to improve quality or remove from catalog

Q,3) What time of the day has the highest number of purchases?

select 
       case
            when DATEPART(hour, time_of_purchase) between 0 and 5 then 'night'
            when DATEPART(hour, time_of_purchase) between 6 and 11 then 'morning'
            when DATEPART(hour, time_of_purchase) between 12 and 17 then 'afternoon'
            when DATEPART(hour, time_of_purchase) between 18 and 23 then 'evening'
            end as time_of_day,
            Count(*) As total_order
            from store_sales
            group by 
            case
            when DATEPART(hour, time_of_purchase) between 0 and 5 then 'night'
            when DATEPART(hour, time_of_purchase) between 6 and 11 then 'morning'
            when DATEPART(hour, time_of_purchase) between 12 and 17 then 'afternoon'
            when DATEPART(hour, time_of_purchase) between 18 and 23 then 'evening'
            end
            order by total_order desc
            
Q.4)Who are the top 5 highest spending customers?
                
select top 5 customer_name, sum(quantity*price) as amount_spent
from Store_sales
group by customer_name
order by amount_spent desc

Q5)	Which product categories generate the highest revenue?

select top 5 product_name, sum(quantity*price) as total_revenue
from Store_sales
group by product_name
order by total_revenue desc

 Q.6) what is the return / cancellation rate per product category ?

  select  product_category,
 format (count (case when status='cancelled' then 1 end) * 100.0/count(*),'N2')+'%' as cancelled_percent from Store_Sales
  group by product_category
  order by cancelled_percent desc

  -------------------- Return ----------------------
   select  product_category,
 format (count (case when status='returned' then 1 end)*100.0/count(*),'N2')+'%' as return_percent from Store_Sales
  group by product_category
  order by return_percent desc


  Q.7) what is the most perferred payment mode ?

  select payment_mode , count(payment_mode) as total_count from Store_Sales
  group by payment_mode
  order by total_count desc

 Q.8) How does the age group affect purchasing behavior? 

 select 
    case 
    when customer_age between 18 and 25 then '18-25'
    when customer_age between 26 and 35 then '26-35'
    when customer_age between 36 and 50 then '36-50'
else '51+'
end as customer_age,
FORMAT(sum(price*quantity),'C0','en-IN') as total_purchase from store_sales
group by case
             when customer_age between 18 and 25 then '18-25'
             when customer_age between 26 and 35 then '26-35'
             when customer_age between 36 and 50 then '36-50'
else '51+'
end 
order by sum(price*quantity) desc

----> Business problem : understand customer demographics 
----> Business Impact  : Targated marketing and product recommendation by age group 


Q.9) What is the monthly sales trend?

select 
FORMAT(purchase_date,'YYY-MM') as month_year,
sum(price*quantity) as total_sales from store_sales
group by FORMAT (purchase_date,'YYY-MM')

-----------> Method 2

select 
YEAR(purchase_date) as years,
Month(purchase_date) as months,
FORMAT(sum(price*quantity),'C0','en-In') as total_sales,
sum(quantity) as total_quantity from store_sales
group by YEAR(purchase_date),Month(purchase_date)
order by Months


Q.10) Are certain genders buying more specific product categories?

select
gender,product_category,count(product_category) as total_purchase from store_sales
group by gender, product_category
order by total_purchase desc

------------> method 2

select gender,product_category
from( 
select gender,product_category from store_sales
) as source_table
pivot
(
count(gender)
for gender in ([male],[female])
) as pivot_table
order by product_category

---------------------------------------------------------------------------

SELECT 
    product_category, 
    [male], 
    [female]
FROM 
(
    SELECT 
        product_category, 
        gender 
    FROM 
        store_sales
) AS source_table
PIVOT
(
    COUNT(gender)
    FOR gender IN ([male], [female])
) AS pivot_table
ORDER BY 
    product_category;
