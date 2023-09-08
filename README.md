# Adventure Works Cycles Business Scenario Project
<p align="center">
  <img src="https://i0.wp.com/blog.jpries.com/wp-content/uploads/2015/12/AdventureWorks-Logo_blog.jpg" alt="Image" width="600">
</p>

## Introduction

AdventureWorks is a sample database provided by Microsoft SQL Server, which supports standard online transaction processing scenarios for Adventure Works Cycles, a fictitious bicycle manufacturer that produces and sells metal and composite bicycles to worldwide. There are a total of 68 tables in the sample database constituted by 9 scenarios (i.e. Business Entities, People, Human Resources, Products, Manufacturing, Purchasing, Inventory, Sales, and Admin). Knowing that customers' demographic and sales-related information are crucial for driving business strategy in real life, this project aims to implement SQL querying techniques in PostgreSQL to explore, manipulate data in "People" and "Sales" scenarios, and transform it into useful business report.

## People Scenario Tables (Schema "Person")
This schema consists of names and addresses of individual customers, vendors, and employees. There are 13 tables in this schema:

- Person.Address
- Person.AddressType
- Person.BusinessEntity
- Person.BusinessEntityAddress
- Person.BusinessEntityContact
- Person.ContactType
- Person.CountryRegion
- Person.EmailAddress
- Person.Password
- Person.Person
- Person.PersonPhone
- Person.PhoneNumberType
- Person.StateProvince

Entity Relationship diagram is shown below:
<p align="center">
  <img src="ERD/People.jpg" alt="Image" width="600">
</p>

## Sales Scenario Tables (Schema "Sales")
This schema contains information about shopping cart, sales orders, special offers and sales people. There are 19 tables in this schema:

- Sales.CountryRegionCurrency
- Sales.CreditCard
- Sales.Currency
- Sales.CurrencyRate
- Sales.Customer
- Sales.PersonCreditCard
- Sales.SalesOrderDetail
- Sales.SalesOrderHeader
- Sales.SalesOrderHeaderSalesReason
- Sales.SalesPerson
- Sales.SalesPersonQuotaHistory
- Sales.SalesReason
- Sales.SalesTaxRate
- Sales.SalesTerritory
- Sales.SalesTerritoryHistory
- Sales.ShoppingCartItem
- Sales.SpecialOffer
- Sales.SpecialOfferProduct
- Sales.Store

Entity Relationship diagram is shown below:
<p align="center">
  <img src="ERD/Sales.jpg" alt="Image" width="600">
</p>

## The Workflow

The process for building this report was as follows (and can be viewed in the yaml file in the repo):


#### Imports

Using the Civis platform, two imports kicked off the daily scheduled updating of this report. The first import was an update of the event participant list, which had to be manually exported to a google sheet every morning (to reflect shift status updates and newly scheduled shifts). The second import was part of a weekly updated VAN export for all people in the My Campaign side of VAN who belonged to each organizing region.

#### SQL Queries

The workhorse query of this process is the va02_event_participant_moded query which adds the transforms the base event participant list int the following ways:

- Adds the turfed Field Organizer (from the organizing region import) to each VAN ID entry
- Adds the latest Field Organizer who *recruited* that particular VAN ID
- Adds a scheduled boolean value (whether or not that VAN ID is scheduled for a future event)
- Adds total completed shifts over the course of the cycle (not currently utilized in report)
- Adds total declined/no show shifts to determine flake rate (not currently utilized in report)
- Calculates 14 and 30 day rolling counts for how many events a particular VAN ID has completed to calculate status of VAN IDs over time (not currently utilized in report)
- Creates a "proper_organizer" column that assigns a volunteer to an organizer based on last_recruit (if no assigned organizer exists) or prefers the last recruit in certain special cases

Next, the set_current_status query checks all vanids for how many events they've completed in the last 14 and 30 days, and assigns a status based on the count. Currently it is set up as follows:

- Super Active: at least 2 completed shifts in the last 14 days
- Active: less than 2 completed shifts in the last 14 days, at least 2 completed in the last 30 days
- Almost Active: 1 completed  shift in the last 30 days
- Drop Off: Has once signed up, but has not completed a shift in the last 30 days

## Tool
- PostgreSQL (Version: 16.RC1)

## Dataset
- [Link](https://github.com/lorint/AdventureWorks-for-Postgres)

## Author
- [Shirley Hung](www.linkedin.com/in/shirley-hung-54a749229)

