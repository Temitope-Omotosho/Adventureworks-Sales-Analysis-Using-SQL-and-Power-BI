--other tables such as purchase,sales,sales territory,sales reason, employee, were connected directly to powerbi since there was no need for transformation
--To retrieve unique products and catergories
select salesorderdetail.SalesOrderID, 
       product.ProductID, 
       OrderQty, 
       product.Name as ProductName,
       productsubcategory.Name as ProductSubcategory,
       productcategory.Name as ProductCategory
from `adwentureworks_db.salesorderdetail` salesorderdetail
join `adwentureworks_db.salesorderheader` salesorderheader
on salesorderdetail.SalesOrderID = salesorderheader.SalesOrderID
join `adwentureworks_db.product` product
on salesorderdetail.ProductID = product.ProductID
join `adwentureworks_db.productsubcategory` productsubcategory
on product.ProductSubcategoryID = productsubcategory.ProductSubcategoryID
join `adwentureworks_db.productcategory` productcategory
on productsubcategory.ProductCategoryID = productcategory.ProductCategoryID;

--To retrieve unique customer details, the total number of orders per customer and toral amount spent by them
SELECT customer.CustomerID,
       CONCAT(contact.Firstname,' ',contact.LastName) as FullName,
       customer.CustomerType,
       address.City,
       state.Name as StateName,
       CAST(COUNT(SalesOrderID) AS INT) Number_of_Orders,
       ROUND(SUM(TotalDue),3) as Total_Amount
FROM `adwentureworks_db.customer` as customer
LEFT JOIN `adwentureworks_db.individual` as individual
ON customer.CustomerID = individual.CustomerID
LEFT JOIN `adwentureworks_db.contact` as contact
ON individual.ContactID = contact.ContactId
LEFT JOIN `adwentureworks_db.customeraddress` as customer_address
ON customer.CustomerID = customer_address.CustomerID
LEFT JOIN `adwentureworks_db.address` as address
ON customer_address.AddressID = address.AddressID
LEFT JOIN `adwentureworks_db.stateprovince` as state
ON state.StateProvinceID = address.StateProvinceID
LEFT JOIN `adwentureworks_db.countryregion` as country
ON state.CountryRegionCode = country.CountryRegionCode
LEFT JOIN `adwentureworks_db.salesorderheader` as sales
ON sales.CustomerID = customer.CustomerID
WHERE customer_address.AddressID = 
      (SELECT MAX(AddressId) FROM `adwentureworks_db.customeraddress` customer_address2
      WHERE customer_address2.CustomerID = customer.CustomerID )
GROUP BY ALL
