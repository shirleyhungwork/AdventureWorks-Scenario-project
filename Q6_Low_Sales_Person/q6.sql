/*
Q6: List top 10 sales person's demographic having lowest growth in sales comparing to last year 
and calculate the projected net profit received by company if sales person meets the sales quota after excluding commission and bonus
*/

with lowsales as (select salesquota, salesytd, saleslastyear,
(salesquota*(1-commissionpct)-bonus) as NetProfitMet, businessentityid
from sales.salesperson
order by salesytd asc limit 10)

select e.NationalIDNumber, l.*, e.birthdate, e.jobtitle, e.maritalstatus, e.gender, e.salariedflag, e.vacationhours, e.sickleavehours, e.currentflag
from humanresources.employee e left join lowsales l
on e.BusinessEntityID = l.BusinessEntityID
where l.BusinessEntityID is not null
order by l.salesytd asc