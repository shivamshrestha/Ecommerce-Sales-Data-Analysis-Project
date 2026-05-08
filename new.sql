


-- General Sales Insights

-- What is the total revenue generated over the entire period?
select * from orders;
select * from customers;
select * from orderdetails;
select * from products;
select * from regions;

select sum(price*quantity) as total_revenue from products as p
join orderdetails as od on od.productid=p.productid

-- Revenue Excluding Returned Orders

select sum(price*quantity) as total_revenue from products as p
join orderdetails as od on od.productid=p.productid
join orders as o on o.orderid=od.orderid
where isreturned = 'false'


-- Total Revenue per Year / Month

select 
 extract(year from orderdate) as years,
 extract(month from orderdate) as months,
 sum(price*quantity) as monthly_revenue
 from orders as o
 join orderdetails as od on o.orderid=od.orderid
 join products as p on p.productid=od.productid
 group by 1,2 
 order by 1,2 


-- Revenue by Product / Category
select category,sum(price*quantity) as total_revenue from products as p
join orderdetails as od on p.productid=od.productid
group by 1

-- What is the average order value (AOV) across all orders?
select sum(price*quantity)/count(distinct o.orderid) from products as p
join orderdetails as od on p.productid=od.productid
join orders as o on o.orderid=od.orderid

-- AOV per Year / Month
select 
 extract(year from orderdate) as years,
 extract(month from orderdate) as months,
 round(sum(price*quantity)/count(distinct o.orderid),2) as average_monthly_revenue
 from orders as o
 join orderdetails as od on o.orderid=od.orderid
 join products as p on p.productid=od.productid
 group by 1,2 
 order by 1,2 

-- What is the average order size by region?

select regionname,sum(quantity) from regions as r
join customers as c on c.regionid=r.regionid
join orders as o on o.customerid=c.customerid
join orderdetails as od on o.orderid=od.orderid
group by 1



-- Customer Insights

-- Who are the top 10 customers by total revenue spent?
select customername,sum(price*quantity) as total_revenue from customers as c
join orders as o on c.customerid=o.customerid
join orderdetails as od on od.orderid=o.orderid
join products as p on p.productid=od.productid
group by 1
order by 2 desc



-- What is the repeat customer rate?
-- What is the average time between two consecutive orders for the same customer Region-wise?

-- Customer Segment (based on total spend)
-- Platinum: Total Spend > 1500
-- Gold: 1000–1500
-- Silver: 500–999
-- Bronze: < 500
with cte as (
select o.customerid,c.customername,sum(p.price*od.quantity) as totalspent from customers c
join orders o on o.customerid=c.customerid
join orderdetails od on od.orderid=o.orderid
join products p on p.productid=od.productid
group by 1,2
)
select cte.customername,totalspent,
        case 
		     when totalspent >1500 then 'Platinum'
		     when totalspent between 1000 and 1500 then 'Gold'
			 when totalspent between 500 and 999 then 'silver'
			 else 'Bronze' 
			 end as CustomerSegment
	from cte 
	join customers c on cte.customerid=c.customerid

-- What is the customer lifetime value (CLV)? CLV= total revenue per customer

select c.customername,sum(p.price*od.quantity) as total_spent from customers c 
join orders o on o.customerid=c.customerid
join orderdetails od on od.orderid=o.orderid
join products p on p.productid=od.productid
group by 1 
order by 2 desc	


-- Product & Order Insights
-- What are the top 10 most sold products (by quantity)?
select productname,sum(quantity) as quantitySold from orderdetails od
join products p on p.productid=od.productid
group by 1
order by 2 desc
limit 10


-- What are the top 10 most sold products (by revenue)?

select p.productname,sum(p.price*od.quantity) as total_spent from customers c 
join orders o on o.customerid=c.customerid
join orderdetails od on od.orderid=o.orderid
join products p on p.productid=od.productid
group by 1
order by 2 desc
limit 10

-- Which products have the highest return rate?

with returnedproducts as 
    (select p.productname,sum(quantity) as totalquantityreturned from customers c 
join orders o on o.customerid=c.customerid
join orderdetails od on od.orderid=o.orderid
join products p on p.productid=od.productid
where isreturned ='true'
group by 1),
totalorders as (
select p.productname,sum(quantity) as totalquantityorder from customers c 
join orders o on o.customerid=c.customerid
join orderdetails od on od.orderid=o.orderid
join products p on p.productid=od.productid
group by 1
)
select t.productname,round((totalquantityreturned::numeric / totalquantityorder),2)*100 as ReturnedRate
from products as p
join totalorders as t on p.productname=t.productname
join returnedproducts as r on r.productname=p.productname
order by 2 desc 
limit 10

-- Return Rate by Category
with RRPC as (
select category,sum(quantity) as ReturnRate from customers c 
join orders o on o.customerid=c.customerid
join orderdetails od on od.orderid=o.orderid
join products p on p.productid=od.productid
where isreturned ='true'
group by 1),
TOPC as (
select category,sum(quantity) as TotalQuantity from customers c 
join orders o on o.customerid=c.customerid
join orderdetails od on od.orderid=o.orderid
join products p on p.productid=od.productid
group by 1
)
select TOPC.category,round((ReturnRate::numeric/TotalQuantity)*100,2) as ReturnRatePerCategory 
from RRPC 
join TOPC on TOPC.category=RRPC.category

-- What is the average price of products per region?
select r.regionname,sum(price*quantity)/sum(quantity) AvgPricePerOrder 
		from orders o 
		join customers c on c.customerid=o.customerid
		join regions r on r.regionid=c.regionid
		join orderdetails od on od.orderid=o.orderid
		join products p on p.productid=od.orderid
		
group by 1
order by 2 desc

-- What is the sales trend for each product category?
select * from orders;
select * from customers;
select * from orderdetails;
select * from products;
select * from regions;


select Years || '-' || months as periods,category,revenue
from
(
select 
		extract (year from orderdate) as Years,
		extract (month from orderdate) as months,
	
		p.category,sum(p.price*od.quantity) as revenue 

		from orders as o 
	join orderdetails od on od.orderid=o.orderid
join products p on p.productid=od.productid
group by 1,2,3
order by 1,2 
)



-- Temporal Trends
-- What are the monthly sales trends over the past year?




-- How does the average order value (AOV) change by month or week?
select to_char(o.orderdate , 'YYYY-MM') as month,
		round(sum(p.price*od.quantity)::numeric /count(distinct o.orderid),2) as AOV 

		from orders as o 
	join orderdetails od on od.orderid=o.orderid
join products p on p.productid=od.productid
group by 1
			

select 
to_char(o.orderdate , 'YYYY-MM') as month,extract (WEEK from orderdate) as weeks,
		round(sum(p.price*od.quantity)::numeric /count(distinct o.orderid),2) as AOV 

		from orders as o 
	join orderdetails od on od.orderid=o.orderid
join products p on p.productid=od.productid
group by 1,2
order by 1,2

-- Regional Insights
-- Which regions have the highest order volume and which have the lowest?

select r.regionname,sum(od.quantity) as volume 

from orders o 
		join customers c on c.customerid=o.customerid
		join regions r on r.regionid=c.regionid
		join orderdetails od on od.orderid=o.orderid
		join products p on p.productid=od.productid
group by 1
order by 2 desc

-- What is the revenue per region and how does it compare across different regions?

select r.regionname,sum(p.price*od.quantity) as revenue 

from orders o 
		join customers c on c.customerid=o.customerid
		join regions r on r.regionid=c.regionid
		join orderdetails od on od.orderid=o.orderid
		join products p on p.productid=od.productid
group by 1
order by 2 desc

-- Return & Refund Insights
-- What is the overall return rate by product category? Returned Rate = Returned orders/Total Orders *100

with RRPC as (
select category,sum(quantity) as ReturnedQuantity from customers c 
join orders o on o.customerid=c.customerid
join orderdetails od on od.orderid=o.orderid
join products p on p.productid=od.productid
where isreturned ='true'
group by 1),
TOPC as (
select category,sum(quantity) as TotalQuantity from customers c 
join orders o on o.customerid=c.customerid
join orderdetails od on od.orderid=o.orderid
join products p on p.productid=od.productid
group by 1
)
select TOPC.category,round((ReturnedQuantity::numeric/TotalQuantity)*100,2) as ReturnRatePerCategory 
from RRPC 
join TOPC on TOPC.category=RRPC.category


-- What is the overall return rate by region?
with RRPC as (
select regionname,sum(quantity) as ReturnedQuantity from customers c 
join orders o on o.customerid=c.customerid
join orderdetails od on od.orderid=o.orderid
join products p on p.productid=od.productid
join regions as r on c.regionid=r.regionid
where isreturned ='true'
group by 1),
TOPC as (
select regionname,sum(quantity) as TotalQuantity from customers c 
join orders o on o.customerid=c.customerid
join orderdetails od on od.orderid=o.orderid
join products p on p.productid=od.productid
join regions as r on c.regionid=r.regionid
group by 1
)
select TOPC.regionname,round((ReturnedQuantity::numeric/TotalQuantity),2) as ReturnRatePerCategory 
from RRPC 
join TOPC on TOPC.regionname=RRPC.regionname

-- Which customers are making frequent returns?


select 			customername,count(isreturned) as ReturnedQuantity from orders as o
		join customers c on o.customerid=c.customerid
		
where isreturned ='true'
group by 1
order by 2 desc
