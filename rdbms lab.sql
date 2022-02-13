DROP DATABASE IF EXISTS `order-directory`;
CREATE DATABASE `order-directory` ;
USE `order-directory`;

CREATE TABLE IF NOT EXISTS `supplier` (
    `SUPP_ID` INT PRIMARY KEY,
    `SUPP_NAME` VARCHAR(50),
    `SUPP_CITY` VARCHAR(50),
    `SUPP_PHONE` VARCHAR(10)
);
CREATE TABLE IF NOT EXISTS `customer` (
    `CUS_ID` INT NOT NULL,
    `CUS_NAME` VARCHAR(20) NULL DEFAULT NULL,
    `CUS_PHONE` VARCHAR(10),
    `CUS_CITY` VARCHAR(30),
    `CUS_GENDER` CHAR,
    PRIMARY KEY (`CUS_ID`)
);
CREATE TABLE IF NOT EXISTS `category` (
    `CAT_ID` INT NOT NULL,
    `CAT_NAME` VARCHAR(20) NULL DEFAULT NULL,
    PRIMARY KEY (`CAT_ID`)
);

CREATE TABLE IF NOT EXISTS `product` (
    `PRO_ID` INT NOT NULL,
    `PRO_NAME` VARCHAR(20) NULL DEFAULT NULL,
    `PRO_DESC` VARCHAR(60) NULL DEFAULT NULL,
    `CAT_ID` INT NOT NULL,
    PRIMARY KEY (`PRO_ID`),
    FOREIGN KEY (`CAT_ID`)
        REFERENCES CATEGORY (`CAT_ID`)
);

CREATE TABLE IF NOT EXISTS `product_details` (
    `PROD_ID` INT NOT NULL,
    `PRO_ID` INT NOT NULL,
    `SUPP_ID` INT NOT NULL,
    `PROD_PRICE` INT NOT NULL,
    PRIMARY KEY (`PROD_ID`),
    FOREIGN KEY (`PRO_ID`)
        REFERENCES PRODUCT (`PRO_ID`),
    FOREIGN KEY (`SUPP_ID`)
        REFERENCES SUPPLIER (`SUPP_ID`)
);
CREATE TABLE IF NOT EXISTS `order` (
    `ORD_ID` INT NOT NULL,
    `ORD_AMOUNT` INT NOT NULL,
    `ORD_DATE` DATE,
    `CUS_ID` INT NOT NULL,
    `PROD_ID` INT NOT NULL,
    PRIMARY KEY (`ORD_ID`),
    FOREIGN KEY (`CUS_ID`)
        REFERENCES CUSTOMER (`CUS_ID`),
    FOREIGN KEY (`PROD_ID`)
        REFERENCES PRODUCT_DETAILS (`PROD_ID`)
);
CREATE TABLE IF NOT EXISTS `rating` (
    `RAT_ID` INT NOT NULL,
    `CUS_ID` INT NOT NULL,
    `SUPP_ID` INT NOT NULL,
    `RAT_RATSTARS` INT NOT NULL,
    PRIMARY KEY (`RAT_ID`),
    FOREIGN KEY (`SUPP_ID`)
        REFERENCES SUPPLIER (`SUPP_ID`),
    FOREIGN KEY (`CUS_ID`)
        REFERENCES CUSTOMER (`CUS_ID`)
);
  
insert into `supplier` values(1,"Rajesh Retails","Delhi",'1234567890');
insert into `supplier` values(2,"Appario Ltd.","Mumbai",'2589631470');
insert into `supplier` values(3,"Knome products","Banglore",'9785462315');
insert into `supplier` values(4,"Bansal Retails","Kochi",'8975463285');
insert into `supplier` values(5,"Mittal Ltd.","Lucknow",'7898456532');

INSERT INTO `CUSTOMER` VALUES(1,"AAKASH",'9999999999',"DELHI",'M');
INSERT INTO `CUSTOMER` VALUES(2,"AMAN",'9785463215',"NOIDA",'M');
INSERT INTO `CUSTOMER` VALUES(3,"NEHA",'9999999999',"MUMBAI",'F');
INSERT INTO `CUSTOMER` VALUES(4,"MEGHA",'9994562399',"KOLKATA",'F');
INSERT INTO `CUSTOMER` VALUES(5,"PULKIT",'7895999999',"LUCKNOW",'M');

INSERT INTO `CATEGORY` VALUES( 1,"BOOKS");
INSERT INTO `CATEGORY` VALUES(2,"GAMES");
INSERT INTO `CATEGORY` VALUES(3,"GROCERIES");
INSERT INTO `CATEGORY` VALUES (4,"ELECTRONICS");
INSERT INTO `CATEGORY` VALUES(5,"CLOTHES");

INSERT INTO `PRODUCT` VALUES(1,"GTA V","DFJDJFDJFDJFDJFJF",2);
INSERT INTO `PRODUCT` VALUES(2,"TSHIRT","DFDFJDFJDKFD",5);
INSERT INTO `PRODUCT` VALUES(3,"ROG LAPTOP","DFNTTNTNTERND",4);
INSERT INTO `PRODUCT` VALUES(4,"OATS","REURENTBTOTH",3);
INSERT INTO `PRODUCT` VALUES(5,"HARRY POTTER","NBEMCTHTJTH",1);

INSERT INTO PRODUCT_DETAILS VALUES(1,1,2,1500);
INSERT INTO PRODUCT_DETAILS VALUES(2,3,5,30000);
INSERT INTO PRODUCT_DETAILS VALUES(3,5,1,3000);
INSERT INTO PRODUCT_DETAILS VALUES(4,2,3,2500);
INSERT INTO PRODUCT_DETAILS VALUES(5,4,1,1000);

INSERT INTO `ORDER` VALUES (50,2000,"2021-10-06",2,1);
INSERT INTO `ORDER` VALUES(20,1500,"2021-10-12",3,5);
INSERT INTO `ORDER` VALUES(25,30500,"2021-09-16",5,2);
INSERT INTO `ORDER` VALUES(26,2000,"2021-10-05",1,1);
INSERT INTO `ORDER` VALUES(30,3500,"2021-08-16",4,3);

INSERT INTO `RATING` VALUES(1,2,2,4);
INSERT INTO `RATING` VALUES(2,3,4,3);
INSERT INTO `RATING` VALUES(3,5,1,5);
INSERT INTO `RATING` VALUES(4,1,3,2);
INSERT INTO `RATING` VALUES(5,4,5,4);

#3  Display the number of the customer group by their genders who have placed any order of amount greater than or equal to Rs.3000.
SELECT `customer`.CUS_GENDER, COUNT(`customer`.CUS_GENDER) AS count
FROM `customer`
INNER JOIN `order` ON `customer`.CUS_ID = `order`.CUS_ID
WHERE ORD_AMOUNT >= 3000
GROUP BY `customer`.CUS_GENDER;


#4)	Display all the orders along with the product name ordered by a customer having Customer_Id=2.
SELECT `order`.*, `product`.PRO_NAME
FROM `order`
INNER JOIN `product_details` ON `order`.PROD_ID = `product_details`.PROD_ID
INNER JOIN `product` ON `product_details`.PRO_ID = `product`.PRO_ID
WHERE `order`.CUS_ID = 2;


#5)	Display the Supplier details who can supply more than one product.
SELECT `supplier`.* 
FROM supplier 
INNER JOIN product_details ON supplier.SUPP_ID = product_details.SUPP_ID 
GROUP BY supplier.SUPP_ID 
HAVING count(supplier.SUPP_ID)>1;


#6)	Find the category of the product whose order amount is minimum.
SELECT `category` .* FROM `category` 
INNER JOIN `product` ON `category`.CAT_ID = `product`.CAT_ID
INNER JOIN `product_details` ON `product_details`.PRO_ID = `product`.PRO_ID
INNER JOIN `order` ON `product_details`.PROD_ID = `order`.PROD_ID 
HAVING min(ORD_AMOUNT);

SELECT CAT_NAME FROM `category` 
INNER JOIN `product` ON `category`.CAT_ID = `product`.CAT_ID
INNER JOIN `product_details` ON `product_details`.PRO_ID = `product`.PRO_ID
INNER JOIN `order` ON `product_details`.PROD_ID = `order`.PROD_ID 
WHERE ORD_AMOUNT = (SELECT min(ORD_AMOUNT) FROM `order`);


#7)	Display the Id and Name of the Product ordered after “2021-10-05”.
SELECT `product`.PRO_ID, `PRODUCT`.PRO_NAME
FROM `order`
INNER JOIN `product_details` ON `order`.PROD_ID = `product_details`.PROD_ID
INNER JOIN `product` ON `product_details`.PRO_ID = `product`.PRO_ID
WHERE `order`.ORD_DATE > '2021-10-05';


#8)	Display customer name and gender whose names start or end with character 'A'.
SELECT `customer`.CUS_NAME, `customer`.CUS_GENDER 
FROM `customer`
WHERE`customer`.CUS_NAME LIKE 'A%' OR `customer`.CUS_NAME LIKE '%a';



#9)	Create a stored procedure to display the Rating for a Supplier if any along with the Verdict on that rating if any like 
# if rating >4 then “Genuine Supplier” if rating >2 “Average Supplier” else “Supplier should not be considered”. 
DELIMITER $$
USE  `order-directory` $$
DROP PROCEDURE IF EXISTS rate_suppliers $$
CREATE PROCEDURE rate_suppliers()
BEGIN
SELECT supplier.SUPP_ID, supplier.SUPP_NAME, rating.RAT_RATSTARS,
CASE
WHEN rating.RAT_RATSTARS > 4 THEN "Genuine_Supplier"
WHEN rating.RAT_RATSTARS > 2 THEN "Average Supplier"
ELSE "Supplier should not be considered"
END AS verdict 
FROM supplier INNER JOIN rating ON supplier.SUPP_ID = rating.SUPP_ID;
END $$
-- To call above procedure
CALL rate_suppliers ();


