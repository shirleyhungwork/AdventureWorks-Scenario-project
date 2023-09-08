/*
Q2: Create list of customer demographic (i.e. contact number, email address, name, total purchase price ytd, preference to receive receive e-mail promotions)
Extract attributes from table Person.person, Person.EmailAddress, Person.Personphone, HumanResources.employee
using column 'BusinessEntityId' as key
*/

with customer as (
	select p.BusinessEntityID, concat(p.FirstName, ' ', p.LastName) as PersonName, p.EmailPromotion, e.EmailAddress, pp.PhoneNumber,
	
	--To extract total purchase year-to-date from column 'demographics' and convert data type from xml to decimal
	(xpath('//IndividualSurvey:TotalPurchaseYTD/text()', p.demographics,
		   ARRAY[ARRAY['IndividualSurvey', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey']])::text[])[1]::Decimal(12,5) as TotalPurchaseYTD
	
	from person.person p 
	left join humanresources.employee em
	on p.businessentityid = em.businessentityid
	left join person.emailaddress e
	on p.BusinessEntityID = e.BusinessEntityID
	left join person.personphone pp
	on p.BusinessEntityID = pp.BusinessEntityID
	where em.loginid is null) 
	
select * from customer
where TotalPurchaseYTD > 0
order by TotalPurchaseYTD desc;