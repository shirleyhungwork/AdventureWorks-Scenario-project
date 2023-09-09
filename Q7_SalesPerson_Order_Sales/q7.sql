/*
Q7: Display the total number of sales orders and sales amount each sales representative receives annually and sorted by SalesPersonID and year of order.
*/
select salespersonid, extract(year from orderdate) as SalesYear,
count(salesorderid) as TotalSales, sum(SubTotal) as TotalSalesAmount
from Sales.SalesOrderHeader
group by salespersonid, extract(year from orderdate)
order by salespersonid, extract(year from orderdate)