/*
Q2: Create descriptive table describing count of cusomters, maximum/minimum/average/standard deviation of total purchase YTD amount aggregated by their preference in email subscription:
0 = Contact does not wish to receive e-mail promotions
1 = Contact does wish to receive e-mail promotions from AdventureWorks
2 = Contact does wish to receive e-mail promotions from AdventureWorks and selected partners

Extract attributes from table Person.person, Sales.Customer
using column 'BusinessEntityId' as key
*/

with customer as (
	select p.EmailPromotion,
	
	--To extract total purchase year-to-date from column 'demographics' and convert data type from xml to decimal
	(xpath('//IndividualSurvey:TotalPurchaseYTD/text()', p.demographics,
		   ARRAY[ARRAY['IndividualSurvey', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey']])::text[])[1]::Decimal(12,5) as TotalPurchaseYTD
	
	from person.person p 
	left join Sales.Customer s
	on p.businessentityid = s.PersonID
	
	--To exclude those that are employee / vendor 
	where s.CustomerID is not null
) 
	
select emailpromotion, count(1) as CountOfPerson, 
max(TotalPurchaseYTD) as MaxPurchaseYTD, min(TotalPurchaseYTD) as MinPurchaseYTD, 
round(avg(TotalPurchaseYTD),4) as AvgPurchaseYTD, round(stddev(TotalPurchaseYTD),4) as STDPurchaseYTD
from customer
group by emailpromotion