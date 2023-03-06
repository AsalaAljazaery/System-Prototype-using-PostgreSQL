 
 
 /*Create customer table*/
DROP TABLE IF EXISTS customer CASCADE;
create TABLE customer(
 Customer_Id VARCHAR(3) NOT NULL PRIMARY KEY,
 Customer_Sname VARCHAR(20) NOT NULL,
 Customer_Fname VARCHAR(20) NOT NULL,
 Customer_address VARCHAR(20), 
 Customer_telephone VARCHAR(11) NOT NULL,
 Customer_DOB DATE NOT NULL,
 Bank_Name VARCHAR(24) NOT NULL,
 Bank_Address VARCHAR(20) NOT NULL,
 Sort_Code NUMERIC(10) NOT NULL,
 Account_Number NUMERIC(10) NOT NULL);
 
 /*Create store table*/
DROP TABLE IF EXISTS store CASCADE;
create TABLE store(
Store_Id VARCHAR(3) PRIMARY KEY NOT NULL,
Store_address VARCHAR(24) NOT NULL,
Store_Phone VARCHAR(11) NOT NULL);

 /*Create product table*/
DROP TABLE IF EXISTS product CASCADE; 
create TABLE product(
product_id NUMERIC(3) NOT NULL PRIMARY KEY , 
Product_type VARCHAR(20) NOT NULL, 
Product_name VARCHAR(20) NOT NULL,
Product_description VARCHAR(24) NOT NULL,
Product_cost VARCHAR(20) NOT NULL,
Store_Id VARCHAR(20) NOT NULL REFERENCES Store(Store_Id) );


   /*Create warehouse table*/
DROP TABLE IF EXISTS warehouse CASCADE;
create TABLE warehouse(
warehouse_ID NUMERIC(3) NOT NULL PRIMARY KEY , 
Product_id NUMERIC(3) NOT NULL REFERENCES product(product_id)
);
 

   /*Create transaction table*/
DROP TABLE IF EXISTS transaction CASCADE; 
create TABLE transaction(
Customer_Id VARCHAR(3) NOT NULL REFERENCES customer(Customer_Id),
Transaction_Id NUMERIC(10) NOT NULL PRIMARY KEY, 
Transaction_date DATE NOT NULL,
Store_Id VARCHAR(20) NOT NULL REFERENCES Store(Store_Id),
Transaction_details VARCHAR(20) NOT NULL,
paid_amount DECIMAL NOT NULL,
remaining_amount DECIMAL NOT NULL
);
 

 /*Insert data into customer table*/
INSERT INTO customer VALUES
(001,'Manley','ANNA','Aalto Place','+941766322',to_date('30-AUG-1998', 'DD-MON-YYYY'),'ADIB','Dubai','246898','983736');
INSERT INTO customer VALUES
(002,'Albara','Serien','Abaco Path','+9617338822',to_date('29-JUL-2010', 'DD-MON-YYYY'),'ADIB','Dubai','08427','99273');
INSERT INTO customer VALUES
(003,'Adams','Adrienne','Ashley Street','+951733322',to_date('27-JAN-1995', 'DD-MON-YYYY'),'ADIB','Dubai','8575343','99353');
INSERT INTO customer VALUES
(004,'Ann','Adrienne','Ardmore Way','+981738822',to_date('20-OCT-1990', 'DD-MON-YYYY'),'ADIB','Dubai','0736533','993673');
INSERT INTO customer VALUES
(006,'Augustinus','Ardson','Aquino Lane','+941819922',to_date('17-JUL-2002', 'DD-MON-YYYY'),'ADIB','Dubai','102733','926343');

 /*View customer table*/
Select * FROM customer;

 /*Insert data into store table*/
INSERT INTO store VALUES
(001,'Ashley Street','+9617333322');
INSERT INTO store VALUES
(002,'Ardson Street','+9617333322');
INSERT INTO store VALUES
(003,'Albara Street','+9617333322');
INSERT INTO store VALUES
(004,'Ardmore Street','+9617333322');

 /*View store table*/
Select * FROM store;


 /*Insert data into product table*/
INSERT INTO product VALUES
(001,'media','printed music','instrument','200',001);
INSERT INTO product VALUES
(002,'musical','books','instrument','300',002);
INSERT INTO product VALUES
(003,'musical','CD','instrument','1200',003);
INSERT INTO product VALUES
(004,'media','DVD','instrument','200',004);

 /*View product table*/
Select * FROM product;


 /*Insert data into transaction table*/
INSERT INTO transaction VALUES
(001,1,to_date('12-JUL-2022', 'DD-MON-YYYY'),001,'cash',50,60.0);
INSERT INTO transaction VALUES
(001,2,to_date('16-JUL-2022', 'DD-MON-YYYY'),002,'cash',50,60.0);
INSERT INTO transaction VALUES
(002,3,to_date('13-JUL-2022', 'DD-MON-YYYY'),003,'cash', 404,555);
INSERT INTO transaction VALUES
(002,4,to_date('20-JUL-2022', 'DD-MON-YYYY'),004,'cash',100, 200);
INSERT INTO transaction VALUES
(004,5,to_date('19-JUL-2022', 'DD-MON-YYYY'),004,'cash',300, 0);

 /*View transaction table*/
Select * FROM transaction;


 /*Insert data into warehouse table*/
INSERT INTO warehouse VALUES
(002,001);
INSERT INTO warehouse VALUES
(001,001);
INSERT INTO warehouse VALUES
(005,004);

 /*View warehouse table*/
Select * FROM warehouse;


 /*This query will retrieve all the information from the product table about the specific product id */
SELECT * FROM product where product_id= '001';

 /*This query will retrieve all the information from the product table about the specific product type */
SELECT * FROM product where Product_type= 'musical';

 /*This query will show in which warehouses the product is available */
SELECT * FROM warehouse where Product_id= '001';

 /*This query will show the customer's first name and surname only */
SELECT Customer_Fname ||', '|| Customer_Sname FROM customer;

 /*This query will show customers with their transactions */
SELECT customer.customer_id,Customer_Fname FROM customer,transaction WHERE customer.customer_id = transaction.customer_id ;

 /*This query will show all sales at stores between specific dates*/
SELECT transaction.Store_Id,Transaction_date,store_address FROM transaction, store WHERE transaction.Store_Id = store.Store_Id and transaction.Transaction_date between '12-JUL-2022' and '14-JUL-2022' ;


/*This query will move the product from one store to another */
UPDATE product
SET store_id= 3
WHERE product_id = '4'

Select * FROM product;


/*This query will search for the product name and return successfully if the product was found*/

DO $$
 <<annonymous_block1>>
DECLARE
 Search_Product product.product_name%TYPE;
BEGIN 
 SELECT product_name
 INTO STRICT Search_Product
 FROM product
 WHERE product_name='DVD';
 RAISE NOTICE 'product name: %', Search_Product;
EXCEPTION
 WHEN NO_DATA_FOUND THEN    
  RAISE EXCEPTION 'The product in not available';
END annonymous_block1 $$


 /*Procedure to return each customer's first name and last name together*/
 
CREATE OR REPLACE PROCEDURE All_customers()
LANGUAGE 'plpgsql' AS
$BODY$
DECLARE
customer_cursor CURSOR FOR SELECT Customer_Fname,Customer_Sname FROM customer;
BEGIN
 FOR tc IN customer_cursor
  LOOP
    RAISE NOTICE '% %', tc.Customer_Fname, tc.Customer_Sname;
  END LOOP;
END;
$BODY$

 /*Call the previous procedure*/
CALL All_customers();




 /* Task 1 (i).Stored procedure to register new customer */

CREATE PROCEDURE Add_customer(Customer_Id INTEGER, Customer_Sname VARCHAR, Customer_Fname VARCHAR, Customer_address VARCHAR, Customer_telephone VARCHAR, Customer_DOB DATE , Bank_Name VARCHAR, Bank_Address VARCHAR , Sort_Code VARCHAR, Account_Number VARCHAR)
LANGUAGE SQL
AS $$
INSERT INTO customer VALUES (Customer_Id,Customer_Sname,Customer_Fname,Customer_address,Customer_telephone, Customer_DOB , Bank_Name , Bank_Address ,(CAST(Sort_Code AS INT )),(CAST(Account_Number AS INT )) );
$$;

 /*Call the procedure with the new customer data to register*/
CALL Add_customer(040,'Lina','NEIR','Prince Place','+941766322',to_date('20-OCT-1990', 'DD-MON-YYYY'),'ADIB','Dubai','249999','96999');
 
 /*Check if customer has been registered*/
SELECT * FROM customer




 /* Delivery slots for the next task, which customer can choose from*/
DROP TABLE IF EXISTS delivery_options CASCADE;
create TABLE delivery_options(
delivery_ID  VARCHAR(3) PRIMARY KEY NOT NULL,
delivery_slot TIMESTAMP NOT NULL)

INSERT INTO delivery_options VALUES (001,'2022-10-19 10:23:54');
INSERT INTO delivery_options VALUES (002,'2022-10-20 10:23:54');
INSERT INTO delivery_options VALUES (003,'2022-10-21 10:23:54');
INSERT INTO delivery_options VALUES (004,'2022-10-22 10:23:54');

SELECT * FROM delivery_options


/* Task 1 (ii). The stored procedure allows an existing customer to purchase a product, depending on the Delivery slot and product name
  RUN as below: 
 1. Run the purchase_product procedure first, THEN 
 2. Specify in check transaction function => 1. Product name, and 2. Delivery date THEN Run it
 3. Run the Create trigger query afterwards ( you have to run it every time you change the delivery date or product name in the previous transaction to update the triggers)
 4. Call purchase_product with the transaction details record. */	


 /* Create a procedure that allows an existing customer to purchase a product
 --a straightforward procedure that only adds a record to the transaction table
 --The trigger will control this procedure by checking the delivery slot and product name before entering the record
 */	
CREATE PROCEDURE purchase_product(Customer_Id VARCHAR,Transaction_Id NUMERIC, Transaction_date DATE, Store_Id VARCHAR, Transaction_details VARCHAR,paid_amount DECIMAL,remaining_amount DECIMAL)
LANGUAGE SQL
AS $$
INSERT INTO transaction VALUES (Customer_Id ,Transaction_Id,Transaction_date ,Store_Id ,Transaction_details  ,paid_amount ,remaining_amount);
$$;


 /* Then, we create a trigger function to customize the product name and delivery date.
 --Every time we want to make a new transaction, we can specify the product name and delivery slot here,
 and then we run the trigger creator every time.
--The new transaction would be entered if a delivery slot and product were available. Otherwise, it will raise notice. 
 */
DROP FUNCTION IF EXISTS check_transaction CASCADE;
CREATE FUNCTION check_transaction() RETURNS trigger AS $check_transaction$
    BEGIN
        -- Check that product_name and delivery_slot are found
        IF NOT EXISTS (SELECT FROM product WHERE product_name='DVD')  THEN
            RAISE EXCEPTION 'This product is not available. ';
        END IF;
        IF NOT EXISTS (SELECT FROM delivery_options WHERE delivery_slot='2022-10-20 10:23:54')THEN
            RAISE EXCEPTION 'The delivery slot is not available.';
        END IF;
		RETURN NEW;
	END;
$check_transaction$ LANGUAGE plpgsql;

 /* Create a trigger to call the check_transaction before inserting new transaction. 
 --We have to run it every time we make any changes to the product name or delivery slot in the trigger function(check_transaction)*/
CREATE TRIGGER check_transaction BEFORE INSERT OR UPDATE ON transaction
FOR EACH ROW EXECUTE FUNCTION check_transaction();	

 /* Call purchase_product(stored procedure) to enter new transaction record depends on 
 the specified product name and delivery slot, which were specified in the check_transaction function 
 --If a delivery slot or product is not available, it will  return a notice 
 --Make sure to choose from existing Customers ID and add different Transaction ID every time. 
 --Purchase product=> (Customer_Id ,Transaction_Id , Transaction_date , Store_Id , Transaction_details ,paid_amount ,remaining_amount )
 --Make sure if you want to change the date or product name to create the trigger again after modifying the entries.
 */

CALL purchase_product('1','185',to_date('16-JUL-2022', 'DD-MON-YYYY'),'3','cash','40.0','50.0');


SELECT * FROM transaction
SELECT * FROM customer




/* EXTRA*/
   /*-- Trigger function to check if Sort code and account number are given when registering new customer record*/
CREATE FUNCTION check_customer() RETURNS trigger AS $check_customer$
    BEGIN
        -- Check that Sort_Code and Account_Number are given
        IF NEW.Sort_Code IS NULL THEN
            RAISE EXCEPTION 'Sort_Code cannot be null';
        END IF;
        IF NEW.Account_Number IS NULL THEN
            RAISE EXCEPTION '% cannot have null Account_Number', NEW.Account_Number;
        END IF;
		RETURN NEW;
	END;
$check_customer$ LANGUAGE plpgsql;

 /* Run the trigger function before any insert or update to the customer table*/
CREATE TRIGGER check_customer BEFORE INSERT OR UPDATE ON customer
FOR EACH ROW EXECUTE FUNCTION check_customer();	
	
  /* Try insert query to the customer table without sort code*/
INSERT INTO customer VALUES
(006,'','Ardson','Aquino Lane','+941819922',to_date('17-JUL-2002', 'DD-MON-YYYY'),'ADIB','Dubai');




