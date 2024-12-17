--Rename table

/*alter table dimcustomer rename to customer;
alter table dimproduct rename to product;
alter table factsales rename to sales;*/




/*Question 1: Retrieve all customer's names alongside the quantity of product bought. 
Include customers who haven't made any purchases (if any).*/

select * from customer
	select * from sales
 select customer.firstname, customer.lastname, sales.quantitysold
from customer
left join sales on customer.customerid = sales.customerid;


--OR

select c.firstname, c.lastname, s.quantitysold
	from customer c 
	left join sales s on c.customerid = s.customerid;


--Question 2: Retrieve all sales_id, sale_date and customer_email. Include sales records without corresponding customer information (if any).

select * from sales

select * from customer
select customer.email, sales.saleid, sales.saledate
from customer
right join sales on sales.customerid = customer.customerid;

--Question3: List all id of products sold along with the customer's first name
select * from sales
	select * from customer

select customer.firstname, sales.productid
from sales
inner join customer on sales.customerid = customer.customerid;


--Question 4: List all product name and cast their prices as text.

select * from product

select product.productname,
cast (price as text) as pricetext
from product;


/*Question 5: Retrieve all customers names(first and last) and show the sale amount of product purchases if 
available; otherwise, show “No amount” or 0.
select * from sales*/

select customer.firstname, customer.lastname, 
	coalesce(sum(saleamount),'no amount' as saleamount
	from customer
	left join sales on customer.customerid = sales.customerid
	group by customer.firstname, customer.lastname;

OR

select firstname, lastname, saleamount
	coalesce(sum(saleamount), 0) as salesamount
	from customer
	left join sales on customer.customerid = sales.customerid
	group by firstname, lastname


or
	
	select firstname, lastname, coalesce(saleamount),0
	from customer
	left join sales on customer.customerid = sales.customerid

--Question 6: List all products name and show the total quantity sold, with 0 if no sales.


select product.productname,
coalesce(sum(sales.quantity), 0) as TotalQuantitySold
from product
left join sales on product.productid = sales.productid
group by 
    product.productname;


OR

select productname, coalesce(sum(quantitysold), 0)
from product
left join sales on product.productid = sales.productid
	group by productname;


--Question 7: Retrieve the sale amount as a decimal with three decimal places.

select cast(saleamount as decimal(10,3)) from sales


/*Question 8: Classify products based on their stock levels. 
Return the product name, category,and a label that indicates
whether the product is "Low Stock" (less than 10 units),
"Medium Stock" (10 to 50 units), or "High Stock" 
(more than 50 units)*/

select productname, category,
	CASE WHEN stockquantity < 10 then 'low stock'
		 WHEN stockquantity between 10 and 50 then 'medium stock'
		 WHEN stockquantity > 50 then 'high stock'
	ELSE 'null'
	END as newstocklevel
	FROM product;
	


--Question 9: extract the saleid,saledate and the sale month.
select * from sales
	
select saleid, saledate, extract(month from saledate) as salemonth 
	from sales

/*Question 10: Return the sale ID, sale date, and a label 
indicating "Q1" (January to March), 
"Q2" (April to June), "Q3" (July to September), or 
"Q4" (October to December).*/

select saleid, saledate,
	case when saledate = january - march then 'Q1'
		 when saledate = april - june then 'Q2'
		 when saledate = july - september then 'Q3'
		 when saledate = october - december then 'Q4'
	end as quarter
	from sales




SELECT 
    Sales.SaleID,
    Sales.SaleDate,
    CASE 
        WHEN EXTRACT(MONTH FROM Sales.SaleDate) BETWEEN 1 AND 3 THEN 'Q1'
        WHEN EXTRACT(MONTH FROM Sales.SaleDate) BETWEEN 4 AND 6 THEN 'Q2'
        WHEN EXTRACT(MONTH FROM Sales.SaleDate) BETWEEN 7 AND 9 THEN 'Q3'
		when extract(month from sales.saledate) between 10 and 12 then 'Q4'
        ELSE NULL
    END AS Quarter
FROM 
    Sales;