/*
Q4: Display product subcategories that have the greatest sales performace/are most popular (quantities sold) for each categories.
And list out the total net profit earned and count of orders purchased.
*/
with ProductSales as (
	
	select ProductCategory, ProductSubCategory, 
	  count(ProductID) as CountOfOrder,
	  sum(orderqty) as SalesTotal,
	  sum(netprofit) as netprofit
	
	-- Subquery
	from (select s.ProductID, s.UnitPrice, s.OrderQty, s.UnitPriceDiscount, p.StandardCost, 
		  (s.UnitPrice*s.orderqty*(1-s.UnitPriceDiscount) - p.StandardCost) as NetProfit,
		  p.ProductSubcategoryID, cat.Name as ProductCategory, sub.Name as ProductSubCategory
		  from Sales.SalesOrderDetail s
		  left join Production.Product p
		  on s.ProductID = p.ProductID
		  left join Production.ProductSubcategory sub
		  on p.ProductSubcategoryID = sub.ProductSubcategoryID
		  left join Production.ProductCategory cat
		  on sub.ProductCategoryID = cat.ProductCategoryID
		 )
	group by ProductCategory, ProductSubCategory
	order by ProductCategory, salestotal desc, netprofit desc)
	
SELECT ProductCategory, ProductSubcategory, CountOfOrder, SalesTotal, NetProfit
FROM (
 SELECT *, ROW_NUMBER() OVER (PARTITION BY
 ProductCategory ORDER BY ProductCategory, SalesTotal desc) AS row_number
 FROM ProductSales
) AS p
WHERE p.row_number = 1