-- Name:Xiaoxiao Cao,ID:103043833
-- ////////////////////////////Task1.1///////////////////////////////////////////////
-- SELECT name
-- from sys.databases;
-- create database DW3833
use DW3833
IF OBJECT_ID('ERROREVENT') IS NOT NULL
DROP TABLE ERROREVENT;
GO
CREATE TABLE ERROREVENT
(
    ERRORID INTEGER IDENTITY(1,1),
    SOURCE_ID NVARCHAR(50),
    SOURCE_TABLE NVARCHAR(50),
    FILTERID INTEGER,
    [DATETIME] DATETIME,
    [ACTION] NVARCHAR(50),
    CONSTRAINT ERROREVENTACTION CHECK (ACTION IN ('SKIP','MODIFY'))
);
-- ////////////////////////////////////////Task1.2/////////////////////////////////////
IF OBJECT_ID('DWPROD') IS NOT NULL
DROP TABLE DWPROD;
IF OBJECT_ID('DWCUST') IS NOT NULL
DROP TABLE DWCUST;
IF OBJECT_ID('DWSALE') IS NOT NULL
DROP TABLE DWSALE;
GO
-- use TPS
-- SELECT table_catalog[database], table_schema [schema], table_name name, table_type type
-- FROM INFORMATION_SCHEMA.TABLES
-- GO
-- SELECT *
-- FROM TPS.dbo.PRODUCT
-- Where Prodname is null
-- -- WHERE Prodcategory NOT IN (1,2,3,5,6,9)
-- -- OR Prodcategory is null
-- -- WHERE Manufacturercode IS NULL
-- SELECT *
-- FROM TPS.dbo.PRODCATEGORY
-- SELECT *
-- FROM TPS.dbo.MANUFACTURER
-- SELECT *
-- FROM TPS.dbo.SHIPPING
-- SELECT *
-- FROM TPS.dbo.SALEMELB
-- WHERE Prodid =10780
-- or Prodid=10746
-- or Prodid=10813
-- SELECT *
-- FROM TPS.dbo.SALEBRIS
-- WHERE Prodid =10780
-- or Prodid=10746
-- or Prodid=10813
-- SELECT *
-- FROM TPS.dbo.CUSTCATEGORY
-- SELECT*
-- FROM TPS.dbo.CUSTBRIS
-- SELECT *
-- FROM TPS.dbo.CUSTMELB
-- SELECT *
-- FROM TPS.dbo.SALEBRIS
-- WHERE Prodid=10744
-- OR  Prodid=10767
-- SELECT *
-- FROM TPS.dbo.SALEMELB
-- WHERE Prodid=10744
-- OR  Prodid=10767

CREATE TABLE DWPROD
(
    DWPRODID INT IDENTITY(1,1),
    DWSOURCETABLE NVARCHAR(10) DEFAULT 'PRODUCT',
    DWSOURCEID INT NOT NULL,
    PRODNAME NVARCHAR(50),
    PRODCATNAME NVARCHAR(50),
    PRODMANUNAME NVARCHAR(50),
    PRODSHIPNAME NVARCHAR(50),
    PRIMARY KEY (DWPRODID)
);
CREATE TABLE DWCUST
(
    DWCUSTID int IDENTITY(1,1),
    DWSOURCEIDBRIS INT ,
    DWSOURCEIDMELB INT,
    FIRSTNAME NVARCHAR(20),
    SURNAME NVARCHAR(20),
    GENDER NVARCHAR CHECK(GENDER IN('F','M')),
    -- GENDER COLUMN HAVE SOME ERROR DATA
    PHONE INT CHECK(LEN(PHONE)=10),
    -- PHONE COLUMN HAVE SOME ERROR DATA
    POSTCODE INT CHECK(LEN(POSTCODE)=4),
    CITY NVARCHAR(50),
    STATE NVARCHAR,
    CUSTCATNAME NVARCHAR(20),
    PRIMARY KEY (DWCUSTID)
);
CREATE TABLE DWSALE
(
    DWSALEID int IDENTITY(1,1),
    DWCUSTID int,
    DWPRODID int,
    DWSOURCEIDBRIS int,
    DWSOURCEIDMELB int,
    QTY int,
    SALE_DWDATEID int,
    SHIP_DWDATEID int,
    SALEPRICE decimal,
    PRIMARY KEY (DWSALEID),
    FOREIGN KEY (DWCUSTID) REFERENCES DWCUST,
    FOREIGN KEY (DWPRODID) REFERENCES DWPROD

)
-- //////////////////////////////////////////TASK1.3////////////////////////////////////////
IF OBJECT_ID('GENDERSPELLING') IS NOT NULL
DROP TABLE GENDERSPELLING;
GO
CREATE TABLE GENDERSPELLING(
    [Invalid Value] NVARCHAR(10),
    [New Value] NVARCHAR(1)
)
INSERT INTO  GENDERSPELLING([Invalid Value],  [New Value] )VALUES

    ('MAIL','M'),
    ('WOMAN','F'),
    ('FEM','F'),
    ('FEMALE','F'),
    ('MALE','M'),
    ('GENTLEMAN','M'),
    ('MM','M'),
    ('FF','F'),
    ('FEMAIL','F')
-- SELECT *
-- FROM GENDERSPELLING
-- ////////////////////////////////////////////TASK2.1 Filter #1////////////////////////////////////////
-- Question for TIM: HERE DATETIME INCLUDE SALEDATE AND SHIPDATE OR IS IT THE SYSTERM DATE?????
INSERT INTO ERROREVENT(SOURCE_ID)
SELECT P.Prodid
FROM TPS.dbo.PRODUCT P
WHERE P.Prodname IS NULL
​
UPDATE ERROREVENT
SET SOURCE_TABLE='PRODUCT',
   FILTERID=1,
   [ACTION]='SKIP'
-- TEST----
-- SELECT * FROM ERROREVENT
-- /////////////////////////////////////////TASK2.2 Filter #2//////////////////////////////////////////////////////

INSERT INTO ERROREVENT(SOURCE_ID)
SELECT P.Prodid
FROM TPS.dbo.PRODUCT P
WHERE P.Manufacturercode IS NULL
​
UPDATE ERROREVENT
SET SOURCE_TABLE='PRODUCT',
   FILTERID=2,
   [ACTION]='MODIFY'
   WHERE FILTERID IS NULL

--   TEST RESULT
-- SELECT * FROM ERROREVENT
-- NOTE: NOTHING INSERTED INTO THE TABLE
-- //////////////////////////////////////////////////TASK2.3 Filter#3///////////////////////////////////////////


INSERT INTO ERROREVENT(SOURCE_ID)
SELECT P.Prodid
FROM TPS.dbo.PRODUCT P
 WHERE P.Prodcategory NOT IN (
     SELECT Productcategory 
     FROM 
     TPS.dbo.PRODCATEGORY)
OR P.Prodcategory is null

​UPDATE ERROREVENT
SET SOURCE_TABLE='PRODUCT',
   FILTERID=3,
   [ACTION]='MODIFY'
   WHERE FILTERID IS NULL
--    ////////////////////////////////////////TASK2.4.1////////////////////////////
-- SELECT * FROM
-- TPS.dbo.PRODUCT
-- WHERE Prodid NOT IN (
--     SELECT SOURCE_ID FROM ERROREVENT)
​
-- ////////////////////////////////////////////TASK2.4.2///////////////////////////
-- SELECT PR.Prodid,PR.Prodname,PC.CATEGORYNAME,M.Manuname,SH.DESCRIPTION
-- FROM TPS.dbo.PRODUCT PR
-- left JOIN
-- TPS.dbo.PRODCATEGORY PC
-- ON
-- PR.Prodcategory=PC.Productcategory
-- left JOIN
-- TPS.dbo.MANUFACTURER M
-- ON
-- PR.Manufacturercode=M.Manucode
-- left JOIN
-- TPS.dbo.SHIPPING SH
-- ON
-- PR.Shippingcode=SH.Shippingcode
-- WHERE Prodid NOT IN (
--     SELECT SOURCE_ID FROM ERROREVENT)

-- /////////////////////////////////////////TASK2.4.3//////////////////////

INSERT INTO  DWPROD
(DWSOURCEID,PRODNAME,PRODCATNAME,PRODMANUNAME,PRODSHIPNAME) 
SELECT PR.Prodid,PR.Prodname,PC.CATEGORYNAME,M.Manuname,SH.DESCRIPTION
FROM TPS.dbo.PRODUCT PR
left JOIN
TPS.dbo.PRODCATEGORY PC
ON
PR.Prodcategory=PC.Productcategory
left JOIN
TPS.dbo.MANUFACTURER M
ON
PR.Manufacturercode=M.Manucode
left JOIN
TPS.dbo.SHIPPING SH
ON
PR.Shippingcode=SH.Shippingcode
WHERE Prodid NOT IN (
    SELECT SOURCE_ID FROM ERROREVENT)
-- SELECT *
-- FROM DWPROD
-- ------------------------------------------TASK2.4.4//////////////////////
INSERT INTO  DWPROD
(DWSOURCEID,PRODNAME,PRODCATNAME,PRODMANUNAME,PRODSHIPNAME) 
SELECT PR.Prodid,PR.Prodname,PC.CATEGORYNAME,M.Manuname,SH.DESCRIPTION
FROM TPS.dbo.PRODUCT PR
left JOIN
TPS.dbo.PRODCATEGORY PC
ON
PR.Prodcategory=PC.Productcategory
left JOIN
TPS.dbo.MANUFACTURER M
ON
PR.Manufacturercode=M.Manucode
left JOIN
TPS.dbo.SHIPPING SH
ON
PR.Shippingcode=SH.Shippingcode
INNER JOIN
ERROREVENT ER
ON PR.Prodid=ER.SOURCE_ID
WHERE ER.FILTERID=2

UPDATE DWPROD
SET PRODMANUNAME='UNKNOWN'
WHERE PRODMANUNAME IS NULL
-- /////////////////////////////////////////TASK 2.4.5/////////////////////////
INSERT INTO  DWPROD
(DWSOURCEID,PRODNAME,PRODCATNAME,PRODMANUNAME,PRODSHIPNAME) 
SELECT PR.Prodid,PR.Prodname,PC.CATEGORYNAME,M.Manuname,SH.DESCRIPTION
FROM TPS.dbo.PRODUCT PR
left JOIN
TPS.dbo.PRODCATEGORY PC
ON
PR.Prodcategory=PC.Productcategory
left JOIN
TPS.dbo.MANUFACTURER M
ON
PR.Manufacturercode=M.Manucode
left JOIN
TPS.dbo.SHIPPING SH
ON
PR.Shippingcode=SH.Shippingcode
INNER JOIN
ERROREVENT ER
ON PR.Prodid=ER.SOURCE_ID
WHERE ER.FILTERID=3

UPDATE DWPROD
SET PRODCATNAME='UNKNOWN'
WHERE PRODMANUNAME IS NULL