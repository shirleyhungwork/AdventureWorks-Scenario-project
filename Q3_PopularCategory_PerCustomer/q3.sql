/*
Q3: Display product categories that have the greatest sales performace/are most popular (quantities sold) for each target customers.
And list out the total net profit earned and count of orders purchased.
*/
with ProductSales as (
	
	select TargetCustomer, ProductSubCategory, 
	  count(ProductID) as CountOfOrder,
	  sum(orderqty) as SalesTotal,
	  sum(netprofit) as netprofit
	
	-- Subquery
	from (select s.ProductID, s.UnitPrice, s.OrderQty, s.UnitPriceDiscount, p.StandardCost, 
		  (s.UnitPrice*s.orderqty*(1-s.UnitPriceDiscount) - p.StandardCost) as NetProfit,
		  -- Define the target customers from column "Style"
		  (
			  case when p.Style = 'W' then 'Womens'
			  when p.Style = 'M' then 'Mens'
			  when p.Style = 'U' then 'Universal'
			  else 'Unknown' end
		  ) as TargetCustomer, 
		  
		  p.ProductSubcategoryID, sub.Name as ProductSubCategory
		  from Sales.SalesOrderDetail s
		  left join Production.Product p
		  on s.ProductID = p.ProductID
		  left join Production.ProductSubcategory sub
		  on p.ProductSubcategoryID = sub.ProductSubcategoryID)
	group by TargetCustomer, ProductSubCategory
	order by TargetCustomer, salestotal desc, netprofit desc)

SELECT TargetCustomer, ProductSubcategory, CountOfOrder, SalesTotal, NetProfit
FROM (
 SELECT *, ROW_NUMBER() OVER (PARTITION BY
 TargetCustomer ORDER BY TargetCustomer, SalesTotal desc) AS row_number
 FROM ProductSales
) AS p
WHERE p.row_number = 1