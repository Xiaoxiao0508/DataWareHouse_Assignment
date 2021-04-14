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

IF OBJECT_ID('DWSALE') IS NOT NULL
DROP TABLE DWSALE;
IF OBJECT_ID('DWPROD') IS NOT NULL
DROP TABLE DWPROD;
IF OBJECT_ID('DWCUST') IS NOT NULL
DROP TABLE DWCUST;

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
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, NUMERIC_SCALE
FROM INFORMATION_SCHEMA. COLUMNS
WHERE TABLE_NAME='CUSTBRIS'
CREATE TABLE DWPROD
(
    DWPRODID INT IDENTITY(1,1),
    DWSOURCETABLE NVARCHAR(10) DEFAULT 'PRODUCT',
    DWSOURCEID INT NOT NULL,
    PRODNAME NVARCHAR(100),
    PRODCATNAME NVARCHAR(30),
    PRODMANUNAME NVARCHAR(30),
    PRODSHIPNAME NVARCHAR(30),
    PRIMARY KEY (DWPRODID)
);
CREATE TABLE DWCUST
(
    DWCUSTID int IDENTITY(1,1),
    DWSOURCEIDBRIS INT ,
    DWSOURCEIDMELB INT,
    FIRSTNAME NVARCHAR(30),
    SURNAME NVARCHAR(30),
    GENDER NVARCHAR(10),
    PHONE NVARCHAR(20),
    POSTCODE INT CHECK(LEN(POSTCODE)=4),
    CITY NVARCHAR(50),
    [STATE] NVARCHAR(10),
    CUSTCATNAME NVARCHAR(30),
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
CREATE TABLE GENDERSPELLING
(
    [Invalid Value] NVARCHAR(10),
    [New Value] NVARCHAR(1)
)
INSERT INTO  GENDERSPELLING
    ([Invalid Value], [New Value] )
VALUES

    ('MAIL', 'M'),
    ('WOMAN', 'F'),
    ('FEM', 'F'),
    ('FEMALE', 'F'),
    ('MALE', 'M'),
    ('GENTLEMAN', 'M'),
    ('MM', 'M'),
    ('FF', 'F'),
    ('FEMAIL', 'F')
-- SELECT *
-- FROM GENDERSPELLING
-- ////////////////////////////////////////////TASK2.1 Filter #1////////////////////////////////////////
-- INSERT INTO ERROREVENT
--     (SOURCE_ID)
-- SELECT P.Prodid
-- FROM TPS.dbo.PRODUCT P
-- WHERE P.Prodname IS NULL
-- ​
-- UPDATE ERROREVENT
-- SET SOURCE_TABLE='PRODUCT',
--    FILTERID=1,
--    [ACTION]='SKIP'
INSERT INTO ERROREVENT
    (SOURCE_ID,SOURCE_TABLE,FILTERID,[DATETIME],[ACTION])
SELECT Prodid
, 'PRODUCT', 1, (SELECT GETDATE()), 'SKIP'
FROM TPS.dbo.PRODUCT
WHERE Prodname IS NULL


-- TEST----
-- SELECT * FROM ERROREVENT
-- /////////////////////////////////////////TASK2.2 Filter #2//////////////////////////////////////////////////////

-- INSERT INTO ERROREVENT
--     (SOURCE_ID)
-- SELECT P.Prodid
-- FROM TPS.dbo.PRODUCT P
-- WHERE P.Manufacturercode IS NULL
-- ​
-- UPDATE ERROREVENT
-- SET SOURCE_TABLE='PRODUCT',
--    FILTERID=2,
--    [ACTION]='MODIFY'
--    WHERE FILTERID IS NULL



INSERT INTO ERROREVENT
    (SOURCE_ID,SOURCE_TABLE,FILTERID,[DATETIME],[ACTION])
SELECT Prodid
, 'PRODUCT', 2, (SELECT GETDATE()), 'MODIFY'
FROM TPS.dbo.PRODUCT P
WHERE P.Manufacturercode IS NULL

--   TEST RESULT
-- SELECT * FROM ERROREVENT
-- NOTE: NOTHING INSERTED INTO THE TABLE
-- //////////////////////////////////////////////////TASK2.3 Filter#3///////////////////////////////////////////


-- INSERT INTO ERROREVENT
--     (SOURCE_ID)
-- SELECT P.Prodid
-- FROM TPS.dbo.PRODUCT P
-- WHERE P.Prodcategory NOT IN (
--      SELECT Productcategory
--     FROM
--         TPS.dbo.PRODCATEGORY)
--     OR P.Prodcategory is null

-- ​
-- UPDATE ERROREVENT
-- SET SOURCE_TABLE='PRODUCT',
--    FILTERID=3,
--    [ACTION]='MODIFY'
--    WHERE FILTERID IS NULL



INSERT INTO ERROREVENT
    (SOURCE_ID,SOURCE_TABLE,FILTERID,[DATETIME],[ACTION])
SELECT Prodid
, 'PRODUCT', 3, (SELECT GETDATE()), 'MODIFY'
FROM TPS.dbo.PRODUCT P
WHERE P.Prodcategory NOT IN (
     SELECT Productcategory
    FROM
        TPS.dbo.PRODCATEGORY)
    OR P.Prodcategory is null

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
SELECT PR.Prodid, PR.Prodname, PC.CATEGORYNAME, M.Manuname, SH.DESCRIPTION
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
    SELECT SOURCE_ID
FROM ERROREVENT)
-- SELECT *
-- FROM DWPROD
-- ------------------------------------------TASK2.4.4//////////////////////
INSERT INTO  DWPROD
    (DWSOURCEID,PRODNAME,PRODCATNAME,PRODMANUNAME,PRODSHIPNAME)
SELECT PR.Prodid, PR.Prodname, PC.CATEGORYNAME, M.Manuname, SH.DESCRIPTION
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
SELECT PR.Prodid, PR.Prodname, PC.CATEGORYNAME, M.Manuname, SH.DESCRIPTION
FROM TPS.dbo.PRODUCT PR
    LEFT JOIN
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
-- //////////////////////////////////////TASK3.1 Filter 4//////////////////////
-- INSERT INTO ERROREVENT(SOURCE_ID)
--     SELECT C.Custid
--     FROM TPS.dbo.CUSTBRIS C
--     WHERE C.Custcatcode NOT IN (
--     SELECT Custcatcode
--     FROM
--     TPS.dbo.CUSTCATEGORY)
--     OR C.Custcatcode IS NULL

-- ​
-- UPDATE ERROREVENT
-- SET SOURCE_TABLE='CUSTBRIS',
--    FILTERID=4,
--    [ACTION]='MODIFY'
--    WHERE FILTERID IS NULL

INSERT INTO ERROREVENT
(SOURCE_ID,SOURCE_TABLE,FILTERID,[DATETIME],[ACTION])
SELECT C.Custid, 'CUSTBRIS', 4, (SELECT GETDATE()), 'MODIFY'
FROM TPS.dbo.CUSTBRIS C
WHERE C.Custcatcode NOT IN (
    SELECT Custcatcode
    FROM TPS.dbo.CUSTCATEGORY) OR C.Custcatcode IS NULL

--    //////////////////////////////////////TASK 3.2 Filter 5/////////////
-- INSERT INTO ERROREVENT(SOURCE_ID)
--     SELECT C.Custid
--     FROM TPS.dbo.CUSTBRIS C
--     WHERE CHARINDEX(' ',Phone) > 0
--     OR
--     CHARINDEX('-',Phone) > 0;

-- ​
-- UPDATE ERROREVENT
-- SET SOURCE_TABLE='CUSTBRIS',
--    FILTERID=5,
--    [ACTION]='MODIFY'
--    WHERE FILTERID IS NULL

INSERT INTO ERROREVENT
(SOURCE_ID,SOURCE_TABLE,FILTERID,[DATETIME],[ACTION])
SELECT C.Custid, 'CUSTBRIS', 5, (SELECT GETDATE()), 'MODIFY'
FROM TPS.dbo.CUSTBRIS C
WHERE CHARINDEX(' ',Phone) > 0
OR
    CHARINDEX('-',Phone) > 0;
--    /////////////////////////////////////TASK3.3 Filter 6///////////////////////
-- INSERT INTO ERROREVENT
--     (SOURCE_ID)
-- SELECT C.Custid
-- FROM TPS.dbo.CUSTBRIS C
-- WHERE LEN(C.Phone)!=10
--     AND CHARINDEX(' ',C.Phone) = 0
--     AND CHARINDEX('-',C.Phone) = 0

-- ​
-- UPDATE ERROREVENT
-- SET SOURCE_TABLE='CUSTBRIS',
--    FILTERID=6,
--    [ACTION]='SKIP'
--    WHERE FILTERID IS NULL

INSERT INTO ERROREVENT
(SOURCE_ID,SOURCE_TABLE,FILTERID,[DATETIME],[ACTION])
SELECT C.Custid, 'CUSTBRIS', 6, (SELECT GETDATE()), 'SKIP'
FROM TPS.dbo.CUSTBRIS C
WHERE LEN(C.Phone)!=10
    AND CHARINDEX(' ',C.Phone) = 0
    AND CHARINDEX('-',C.Phone) = 0

-- ///////////////////////////////////////TASK3.4 Filter 7//////////////////////////////

-- INSERT INTO ERROREVENT
--     (SOURCE_ID)
-- SELECT C.Custid
-- FROM TPS.dbo.CUSTBRIS C
-- WHERE C.Gender NOT IN ('F','M')
--     OR C.Gender IS NULL

-- ​
-- UPDATE ERROREVENT
-- SET SOURCE_TABLE='CUSTBRIS',
--    FILTERID=7,
--    [ACTION]='MODIFY'
--    WHERE FILTERID IS NULL

INSERT INTO ERROREVENT
(SOURCE_ID,SOURCE_TABLE,FILTERID,[DATETIME],[ACTION])
SELECT C.Custid, 'CUSTBRIS', 7, (SELECT GETDATE()), 'MODIFY'
FROM TPS.dbo.CUSTBRIS C
WHERE C.Gender NOT IN ('F','M')
    OR C.Gender IS NULL

-- //////////////////////////////////////TASK 3.5.1////////////////////////////////// *


INSERT INTO DWCUST
    (DWSOURCEIDBRIS,FIRSTNAME,SURNAME,GENDER,PHONE,POSTCODE,CITY,[STATE],CUSTCATNAME)
SELECT CB.Custid, CB.Fname, CB.Sname, UPPER(Gender), CB.Phone, CB.Postcode, CB.City, CB.[State], CC.CUSTCATNAME
FROM TPS.dbo.CUSTBRIS CB
    LEFT JOIN
    TPS.dbo.CUSTCATEGORY CC
    ON CB.Custcatcode=CC.Custcatcode
WHERE Custid NOT IN 
(SELECT SOURCE_ID
FROM ERROREVENT
WHERE SOURCE_TABLE='CUSTBRIS')
-- //////////////////////////////////TASK 3.5.2//////////////////////////////////////////
INSERT INTO DWCUST
    (DWSOURCEIDBRIS,FIRSTNAME,SURNAME,GENDER,PHONE,POSTCODE,CITY,[STATE],CUSTCATNAME)
SELECT CB.Custid, CB.Fname, CB.Sname, UPPER(Gender), CB.Phone, CB.Postcode, CB.City, CB.[State], CC.CUSTCATNAME
FROM TPS.dbo.CUSTBRIS CB
    LEFT JOIN
    TPS.dbo.CUSTCATEGORY CC
    ON CB.Custcatcode=CC.Custcatcode
    LEFT JOIN
    ERROREVENT ER
    ON CB.Custid=ER.SOURCE_ID
WHERE ER.FILTERID=4
UPDATE DWCUST
SET CUSTCATNAME='UNKNOWN'
WHERE CUSTCATNAME IS NULL
--  ///////////////////////////////////////TASK3.5.3//////////////////////////////////////

INSERT INTO DWCUST
    (DWSOURCEIDBRIS,FIRSTNAME,SURNAME,GENDER,PHONE,POSTCODE,CITY,[STATE],CUSTCATNAME)
SELECT CB.Custid, CB.Fname, CB.Sname, UPPER(Gender), REPLACE(CB.Phone,' ',''), CB.Postcode, CB.City, CB.[State], CC.CUSTCATNAME
FROM TPS.dbo.CUSTBRIS CB
    LEFT JOIN
    TPS.dbo.CUSTCATEGORY CC
    ON CB.Custcatcode=CC.Custcatcode
    LEFT JOIN
    ERROREVENT ER
    ON CB.Custid=ER.SOURCE_ID
WHERE ER.FILTERID=5

UPDATE DWCUST
SET PHONE=REPLACE(PHONE,'-','')


-- /////////////////////////////////////TASK3.5.4////////////////////////////////////////
-- 1084 mail
-- 1086 woman
-- 1089fEM
-- 1094 NULL
-- 1097 gentleMan
-- 1100 Mm
-- 1104 Feminine
 select *
 from GENDERSPELLING

INSERT INTO DWCUST
    (DWSOURCEIDBRIS,FIRSTNAME,SURNAME,GENDER,PHONE,POSTCODE,CITY,[STATE],CUSTCATNAME)
SELECT CB.Custid, CB.Fname, CB.Sname, UPPER(Gender), CB.Phone, CB.Postcode, CB.City, CB.[State], CC.CUSTCATNAME
FROM TPS.dbo.CUSTBRIS CB
    LEFT JOIN
    TPS.dbo.CUSTCATEGORY CC
    ON CB.Custcatcode=CC.Custcatcode
    LEFT JOIN
    ERROREVENT ER
    ON CB.Custid=ER.SOURCE_ID
WHERE ER.FILTERID=7

UPDATE DWCUST
SET GENDER=
(SELECT [New Value]
FROM GENDERSPELLING
WHERE DWCUST.GENDER=GENDERSPELLING.[Invalid Value]
)
WHERE DWSOURCEIDBRIS IN(
    SELECT SOURCE_ID
FROM ERROREVENT
WHERE FILTERID=7
)

UPDATE DWCUST
SET GENDER='U'
WHERE GENDER IS null


-- ///////////////////////////////////TASK 4.1////////////////////////////////////////////////
SELECT *
FROM TPS.dbo.CUSTCATEGORY
SELECT *
FROM TPS.dbo.CUSTMELB
SELECT *
FROM ERROREVENT
SELECT *
FROM DWCUST
SELECT*
FROM TPS.dbo.CUSTBRIS
-- SELECT *
-- FROM TPS.dbo.SALEBRIS
-- WHERE Prodid=10744
-- OR  Prodid=10767
-- SELECT *
-- FROM TPS.dbo.SALEMELB
-- WHERE Prodid=10744
-- OR  Prodid=10767

-- 441
-- 478
-- 686
-- 759
-- 906
-- 959
-- 1007
-- 1009

--  UPDATE DWCUST
--  SET DWSOURCEIDMELB=(
--       SELECT CM.Custid 
--  FROM TPS.dbo.CUSTMELB CM
--  INNER JOIN DWCUST DC 
--  ON  CM.Fname=DC.FIRSTNAME
--  AND CM.Sname=DC.SURNAME
--  AND CM.Postcode=DC.POSTCODE)

--  WHERE FIRSTNAME IN (SELECT CM.Fname
--  FROM TPS.dbo.CUSTMELB CM
--  INNER JOIN DWCUST DC 
--  ON  CM.Fname=DC.FIRSTNAME
--  AND CM.Sname=DC.SURNAME
--  AND CM.Postcode=DC.POSTCODE
--  )





--  INSERT INTO DWCUST(DWSOURCEIDMELB,FIRSTNAME,SURNAME,GENDER,PHONE,POSTCODE,CITY,[STATE],CUSTCATNAME)
--  SELECT CM.Custid,CM.Fname,CM.Sname,UPPER(Gender),CM.Phone,CM.Postcode,CM.City,CM.[State],CC.CUSTCATNAME
-- FROM TPS.dbo.CUSTMELB CM
-- INNER JOIN
-- TPS.dbo.CUSTCATEGORY CC
-- ON CM.Custcatcode=CC.Custcatcode
-- WHERE CM.Custid NOT IN
-- (
--  SELECT CM.Custid
--  FROM TPS.dbo.CUSTMELB CM
--  INNER JOIN DWCUST DC 
--  ON  CM.Fname=DC.FIRSTNAME
--  AND CM.Sname=DC.SURNAME
--  AND CM.Postcode=DC.POSTCODE
-- )