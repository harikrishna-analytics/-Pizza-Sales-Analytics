use PizzaSalesAnalytics;

========================== Daily Revenue ====================================================


WITH DailyRevenue AS
(
    SELECT
        CAST(order_date AS DATE) AS order_date,
        SUM(total_price) AS daily_revenue
    FROM Pizza_Sales
    GROUP BY CAST(order_date AS DATE)
)
SELECT
    order_date,
    daily_revenue,
    AVG(daily_revenue) OVER
    (
        ORDER BY order_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS rolling_7_day_avg
FROM DailyRevenue
ORDER BY order_date;


===================================================================================================================================

=====------------------------------ Basket Analysis ---------------------------------------------

   WITH CleanPizza AS
(
    SELECT
        CAST(order_id AS NVARCHAR(100)) AS order_id,
        CAST(pizza_name AS NVARCHAR(200)) AS pizza_name
    FROM Pizza_Sales
)
SELECT
    a.pizza_name AS pizza_1,
    b.pizza_name AS pizza_2,
    COUNT(DISTINCT a.order_id) AS orders_together
FROM CleanPizza a
INNER JOIN CleanPizza b
    ON a.order_id = b.order_id
   AND a.pizza_name < b.pizza_name
GROUP BY
    a.pizza_name,
    b.pizza_name
ORDER BY
    orders_together DESC;
    


    ==========================================================================================================

    ----------------------- Top 3 pizza with pizza category -------------------------


    WITH PizzaRevenue AS
(
    SELECT
        pizza_category,
        pizza_name,
        SUM(total_price) AS revenue
    FROM Pizza_Sales
    GROUP BY
        pizza_category,
        pizza_name
),
RankedPizzas AS
(
    SELECT
        pizza_category,
        pizza_name,
        revenue,
        ROW_NUMBER() OVER
        (
            PARTITION BY pizza_category
            ORDER BY revenue DESC
        ) AS rn
    FROM PizzaRevenue
)
SELECT
    pizza_category,
    pizza_name,
    revenue
FROM RankedPizzas
WHERE rn <= 3
ORDER BY
    pizza_category,
    revenue DESC;




    select * from pizza_sales 

 
 with PizzaRevenue as 
(
      select
      pizza_category,
      pizza_size ,
      sum(quantity*total_price) as revenue ,
      sum(quantity) as pizza_sold 
       from pizza_sales
        group by 
        pizza_category,
        pizza_size
         )
        ,  RankedPizza 
        as ( 
         select
      pizza_category,
      pizza_size ,
      revenue,
      row_number() over( partition by pizza_category order by revenue desc) as rn 
       from PizzaRevenue)
       select 
       pizza_category,
       pizza_size,
       revenue 
        from RankedPizza
        where rn<= 3 
        order by 
        pizza_category,
        revenue desc;



        ====================================================================================================================================================



        WITH MonthlyRevenue AS
(
    SELECT
        YEAR(order_date) AS order_year,
        MONTH(order_date) AS order_month,

        SUM(total_price) AS revenue
    FROM Pizza_Sales
    GROUP BY
        YEAR(order_date),
        MONTH(order_date)
),
RevenueWithPrevious AS
(
    SELECT
        order_year,
        order_month,
        revenue,
        LAG(revenue) OVER
        (
            ORDER BY order_year, order_month
        ) AS previous_month_revenue
    FROM MonthlyRevenue
)
SELECT
    order_year,
    order_month,
    revenue,
    previous_month_revenue,
    ROUND(
        (revenue - previous_month_revenue)
        * 100.0
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS mom_growth_pct
FROM RevenueWithPrevious
ORDER BY
    order_year,
    order_month
 ;


 ======================================================================================================================

 ----------------------------- peak Hours Analysis ----------------------------------------

 SELECT
    DATEPART(HOUR, order_time) AS order_hour,
    COUNT(DISTINCT CAST(order_id AS NVARCHAR(50))) AS total_orders,
    SUM(quantity) AS pizzas_sold,
    SUM(quantity * total_price) AS revenue
FROM Pizza_Sales
GROUP BY
    DATEPART(HOUR, order_time)
ORDER BY
    total_orders DESC;

    =====================================================================================================================
        
   ----------------------------------------- Peak Days Analysis ---------------------------------

            select 
            datename(Day,order_date) as order_day_number,
            datename(weekday,order_date) as order_day,
            count(distinct cast(order_id as nvarchar(50))) as total_orders,
            sum(quantity) as pizzas_sold,
            sum(quantity * total_price) as revenue
            from pizza_sales
            group by 
             datename(day,order_date) ,
              datename(weekday,order_date)

              order by 
              total_orders desc 
       ====================================================================================================
       
            select 
            datename(Day,order_date) as order_day_number,
            datename(weekday,order_date) as order_day,
            count(distinct cast(order_id as nvarchar(50))) as total_orders,
            sum(quantity) as pizzas_sold,
            sum(quantity * total_price) as revenue
            from pizza_sales
            group by 
             datename(day,order_date) ,
              datename(weekday,order_date)

                 having sum(quantity) <=1000
              order by 
              total_orders desc 
           =====================================================================================================

           SELECT 
    DATENAME(DAY, order_date) AS order_day_number,
    DATENAME(WEEKDAY, order_date) AS order_day,
    COUNT(DISTINCT CAST(order_id AS NVARCHAR(50))) AS total_orders,
    SUM(quantity) AS pizzas_sold,
    SUM(quantity * total_price) AS revenue
FROM Pizza_Sales
GROUP BY 
    DATENAME(DAY, order_date),
    DATENAME(WEEKDAY, order_date)
HAVING 
    SUM(quantity) <= 1000
ORDER BY 
    total_orders DESC;

    ====================================================================================================================================

    SELECT 
    DATEPART(WEEKDAY, order_date) AS order_day_number,
    DATENAME(WEEKDAY, order_date) AS order_day,
    COUNT(DISTINCT CAST(order_id AS NVARCHAR(50))) AS total_orders,
    SUM(quantity) AS pizzas_sold,
    SUM(quantity * total_price) AS revenue
FROM Pizza_Sales
GROUP BY 
    DATEPART(WEEKDAY, order_date),
    DATENAME(WEEKDAY, order_date)
HAVING 
    SUM(quantity) > =500
ORDER BY 
    total_orders DESC;

==================================================================================================================================



SELECT 
    DATEPART(WEEKDAY, order_date) AS order_day_number,
    DATENAME(WEEKDAY, order_date) AS order_day,
    COUNT(DISTINCT CAST(order_id AS NVARCHAR(50))) AS total_orders,
    SUM(quantity) AS pizzas_sold,
    SUM(quantity * total_price) AS revenue
FROM Pizza_Sales
GROUP BY 
    DATEPART(WEEKDAY, order_date),
    DATENAME(WEEKDAY, order_date)
HAVING 
    SUM(quantity) >= 500
    or  SUM(quantity) <= 1000
ORDER BY 
    total_orders DESC;


    ======================================================================================================================================

    
 select * from pizza_sales


 SELECT DISTINCT pizza_category,
 count(distinct cast(order_id as nvarchar(50))) as total_orders
FROM Pizza_Sales
group by pizza_category
ORDER BY total_orders desc;

========================================================================


SELECT 
    pizza_category,
    COUNT(DISTINCT CAST(order_id AS NVARCHAR(50))) AS total_orders,
    SUM(quantity) AS pizzas_sold,
    SUM(quantity * total_price) AS revenue
FROM Pizza_Sales
GROUP BY pizza_category
ORDER BY revenue DESC;


=====================================================================================================================


