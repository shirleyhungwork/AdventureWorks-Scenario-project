/*
Q5: List top 10 sales person's demographic having highest growth in sales comparing to last year 
and calculate the projected net profit received by company if sales person meets the sales quota after excluding commission and bonus
*/

with topsales as (select salesquota, salesytd, saleslastyear,
(salesquota*(1-commissionpct)-bonus) as NetProfitMet, businessentityid
from sales.salesperson
order by salesytd desc limit 10)

select e.NationalIDNumber, t.*, e.birthdate, e.jobtitle, e.maritalstatus, e.gender, e.salariedflag, e.vacationhours, e.sickleavehours, e.currentflag
from humanresources.employee e left join topsales t
on e.BusinessEntityID = t.BusinessEntityID
where t.BusinessEntityID is not null