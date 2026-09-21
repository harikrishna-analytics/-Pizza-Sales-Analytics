select * from Pizza_Sales;
select count( cast(order_id as nvarchar(50))) as orders_count  from Pizza_Sales;
select * from Pizza_Sales;


select
pizza_category,
count( cast(order_id as nvarchar(50))) as orders_count  
from Pizza_Sales group by pizza_category  having       count(cast(order_id as nvarchar(50)))<  ( select count(cast(order_id as nvarchar(50)))  as total_orders 
from Pizza_Sales)

union all 

select  pizza_category ,count(cast(order_id as nvarchar(50))) as orders 
from Pizza_Sales
group by pizza_category;




select
pizza_category,
count( cast(order_id as nvarchar(50))) as orders_count  
from Pizza_Sales group by pizza_category  having       count(cast(order_id as nvarchar(50)))<  ( select count(cast(order_id as nvarchar(50)))  as total_orders 
from Pizza_Sales)

union 

select  pizza_category ,count(cast(order_id as nvarchar(50))) as orders 
from Pizza_Sales
group by pizza_category;




SELECT
    pizza_category,
    COUNT(DISTINCT CAST(order_id AS NVARCHAR(50))) AS orders_count
FROM Pizza_Sales
GROUP BY pizza_category
HAVING COUNT(DISTINCT CAST(order_id AS NVARCHAR(50))) >
(
    SELECT AVG(category_orders)
    FROM
    (
        SELECT
            pizza_category,
            COUNT(DISTINCT CAST(order_id AS NVARCHAR(50))) AS category_orders
        FROM Pizza_Sales
        GROUP BY pizza_category
    ) AS x
)
ORDER BY orders_count DESC;


=====================================================================
--------- Total pizza sold------------------------

select   pizza_category ,sum(quantity) as total_sold
 from pizza_sales  group by pizza_category

 ----------------------- Revenue by Pizza type ---------------
 
select   pizza_category ,    format(sum(quantity*total_price) ,'c','en_us')
as total_revenue
 from pizza_sales  group by pizza_category order by total_revenue desc 
 ----------- Revenue and orders by pizza type --------------

 
 
select   pizza_category ,    format(sum(quantity*total_price) ,'c','en_us')
as total_revenue,count(distinct cast(order_id as nvarchar(50))) as total_aorders 
 from pizza_sales  group by pizza_category order by total_revenue desc ;

 -----------========= MOnthly pizza sold----------------------

 select datename(month, order_date) as month_name, count(distinct cast(order_id as nvarchar(50))) as total_orders 
    from pizza_sales  group by datename(month,order_date) 
     order by total_orders desc 


    ============================p====================================================================================
    ---------------- top 10 sales and orders  with pizza name -------------------


    select top 10
    pizza_name,
    count(distinct cast(order_id as nvarchar(50))) as total_orders,
    sum(quantity) as total_sold,
    sum(quantity*total_price) as Revenue 
    from pizza_sales
    group by pizza_name 
     order by Revenue desc 


     ---------------- Bottom 10 sales and orders with pizza name ------------------

      select top 10
    pizza_name,
    count(distinct cast(order_id as nvarchar(50))) as total_orders,
    sum(quantity) as total_sold,
    sum(quantity*total_price) as Revenue 
    from pizza_sales
    group by pizza_name 
     order by Revenue asc ;


     -----------------------------------------------------------------------------------------------
     =====================================================================================================================================

     ----------------- monthly pizza type sales ---------------------

           select 
           datename(month, order_date) as month_name,
    pizza_name,
    count(distinct cast(order_id as nvarchar(50))) as total_orders,
    sum(quantity) as total_sold,
    sum(quantity*total_price) as Revenue 
    from pizza_sales
    group by 
    datename(month, order_date) ,
    pizza_name 
     order by Revenue asc ;
     ===========================================================================================

     --------------- top 10 saels of pizza monthly-----------------------------


          select  top 10
           datename(month, order_date) as month_name,
    pizza_name,
    count(distinct cast(order_id as nvarchar(50))) as total_orders,
    sum(quantity) as total_sold,
    sum(quantity*total_price) as Revenue 
    from pizza_sales
    group by 
    datename(month, order_date) ,
    pizza_name 
     order by Revenue asc ;

=========================================================================================

 ------------------- Timeline pizza sales -----------------------------

 select
  year(order_date) as year_name,
  month(order_date) as month_number,
   datename(month,order_date) as month_name,
     count(distinct cast(order_id as nvarchar(50))) as total_orders,
    sum(quantity) as total_sold,
    sum(quantity*total_price) as Revenue 
    from pizza_sales

    group by

    year(order_date),
    month(order_date),
    datename(month,order_date)
    order by Revenue desc 


    ======================================================================================================
       ----------- views------------


   CREATE VIEW vw_Monthly_Pizza_Sales AS
SELECT
    YEAR(order_date) AS year_name,
    MONTH(order_date) AS month_number,
    DATENAME(MONTH, order_date) AS month_name,
    COUNT(DISTINCT CAST(order_id AS NVARCHAR(50))) AS total_orders,
    SUM(quantity) AS total_sold,
    SUM(quantity * total_price) AS Revenue
FROM Pizza_Sales
GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    DATENAME(MONTH, order_date);

    select  * from  vw_Monthly_Pizza_Sales ;

    ============================================================================================

    --------------- Stored Procedures ----------------------------


               SELECT
    pizza_category,
    SUM(quantity) AS total_sold,
    SUM(quantity * total_price) AS Revenue
FROM Pizza_Sales
GROUP BY pizza_category
order by Revenue ;


create  procedure sp_category_sales
as 

 BEGIN 

 SELECT
    pizza_category,
    SUM(quantity) AS total_sold,
    SUM(quantity * total_price) AS Revenue
FROM Pizza_Sales
GROUP BY pizza_category;

 END  ;

 EXEC sp_category_sales;
  

 =================================================================================================================================
 ----------------- MOnthly_Revenue BY Pizza Sales ------------------------

 select 
  datename(month,order_date) as month_name,
  pizza_category,
  sum(quantity * total_price) as Revenue,
  sum(quantity) as total_sold 
   from pizza_sales 
   group  by
   datename(month,order_date),
   pizza_category
    order by Revenue desc 


    -------------------------- sp_Monthly_Pizza_Sales --------------------------------------

    create procedure sp_Monthly_Pizza_Sales 
    as 
    begin 
    select 
  datename(month,order_date) as month_name,
  pizza_category,
  sum(quantity * total_price) as Revenue,
  sum(quantity) as total_sold 
   from pizza_sales 
   group  by
   datename(month,order_date),
   pizza_category
    order by Revenue desc 
end;

exec sp_Monthly_Pizza_Sales ;

====================================================================================================

---------------------------- year wise and pizza type  wise sales -------------

  select top 10
   year(order_date) as year_name,
   pizza_name ,
   sum(quantity*total_price)as  Revenue,
   sum(quantity) as total_sold
    from pizza_sales
     group by 
     year(order_date),
     pizza_name
      order by Revenue desc 
      ======================================================================================

      -------------------- sp_Year_Pizza_Sales ------------------------------------------

      

      create procedure    sp_Year_Pizza_Sales 
      as 
       begin 
  select top 10
   year(order_date) as year_name,
   pizza_name ,
   sum(quantity*total_price)as  Revenue,
   sum(quantity) as total_sold
    from pizza_sales
     group by 
     year(order_date),
     pizza_name
      order by Revenue desc 

      end 

      exec sp_Year_Pizza_Sales 
      ==================================================================



      CREATE PROCEDURE sp_Monthly_Pizza_Sales_By_Year
    @Year INT
AS
BEGIN

    SELECT
        DATENAME(MONTH, order_date) AS month_name,
        pizza_category,
        SUM(quantity * total_price) AS Revenue,
        SUM(quantity) AS total_sold
    FROM Pizza_Sales
    WHERE YEAR(order_date) = @Year
    GROUP BY
        DATENAME(MONTH, order_date),
        pizza_category
    ORDER BY Revenue DESC;

END;

exec sp_Monthly_Pizza_Sales_By_Year;
===============================================
use PizzaSalesAnalytics

select  pizza_category , sum(quantity*total_price) as Revenue,
sum(quantity) as total_sold,
count(distinct cast( order_id as nvarchar(50))) as total_orders 
from pizza_sales

group by pizza_category
order by  2 desc 


SELECT   pizza_category,
         format(sum(quantity * total_price), 'c', 'en_us') AS Revenue,
         sum(quantity) AS total_sold,
         count(DISTINCT CAST (order_id AS NVARCHAR (50))) AS total_orders
FROM     pizza_sales
GROUP BY pizza_category
ORDER BY 2 DESC; 


select pizza_name,
 format(sum(quantity * total_price), 'c', 'en_us') AS Revenue,
dense_rank()
over(  partition 





select pizza_category,
format (round(sum(quantity*total_price),2),'c','en_us') as revenue 
 from pizza_sales 
 group by pizza_categoryby pizza_name order by sum(quantity * total_price) desc)  as  revenue_rank
from pizza_sales 
