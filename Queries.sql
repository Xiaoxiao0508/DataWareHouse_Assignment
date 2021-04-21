-- Name:Xiaoxiao Cao,ID:103043833
use DW3833
-- ///////////////////////////////////TASK8.1///////////////////////////////////
select DD.DayName AS [WEEKDAY],SUM(DS.QTY*DS.SALEPRICE) AS [TOTAL SALES]
from DWDATE DD
INNER JOIN DWSALE DS
ON DD.DateKey=DS.SALE_DWDATEID
WHERE DD.IsWeekday=1
GROUP BY [DayName]
ORDER BY [TOTAL SALES] DESC

-- ///////////////////////////////////TASK8.2///////////////////////////////////
-- SELECT *
-- FROM DWSALE
SELECT *
FROM DWCUST

SELECT DC.CUSTCATNAME,SUM(DS.QTY*DS.SALEPRICE) AS [TOTAL SALES]
FROM DWSALE DS
INNER JOIN DWCUST DC
ON DS.DWCUSTID=DC.DWCUSTID
GROUP BY CUSTCATNAME
ORDER BY [TOTAL SALES] ASC
-- ///////////////////////////////////TASK8.3///////////////////////////////////
SELECT DP.PRODMANUNAME,SUM(DS.QTY*DS.SALEPRICE) AS [TOTAL SALES]
FROM DWSALE DS
INNER JOIN DWPROD DP
ON DS.DWPRODID=DP.DWPRODID
GROUP BY PRODMANUNAME
ORDER BY [TOTAL SALES] DESC
-- /////////////////////////////////TASK 8.4/////////////////////////////////////
SELECT TOP 10 DC.DWCUSTID ,
DC.FIRSTNAME,
DC.SURNAME,
SUM(DS.QTY*DS.SALEPRICE) AS [TOTAL SALES]
FROM DWSALE DS 
INNER JOIN DWCUST DC 
ON DS.DWCUSTID=DC.DWCUSTID
GROUP BY DC.DWCUSTID,FIRSTNAME,SURNAME
ORDER BY[TOTAL SALES] DESC
-- //////////////////////////////////TASK8.5//////////////////////////////////////////
 
SELECT TOP 10 DP.DWPRODID ,
DP.PRODNAME,
SUM(DS.QTY*DS.SALEPRICE) AS [TOTAL SALES]
FROM DWSALE DS 
INNER JOIN DWPROD DP 
ON DS.DWPRODID=DP.DWPRODID
GROUP BY DP.DWPRODID,PRODNAME
ORDER BY[TOTAL SALES] ASC



-- SELECT  DP.DWPRODID ,
-- DP.PRODNAME,
-- SUM(DS.QTY*DS.SALEPRICE) AS [TOTAL SALES]
-- FROM DWSALE DS 
-- INNER JOIN DWPROD DP 
-- ON DS.DWPRODID=DP.DWPRODID
-- GROUP BY DP.DWPRODID,PRODNAME
-- ORDER BY[TOTAL SALES] DESC
-- ////////////////////////////////TASK8.6///////////////////////////////////////////

SELECT DC.[STATE] AS [STATE],(SELECT TOP 1 DC.CITY FROM DWCUST)AS CITY,(SELECT TOP 1 SUM(DS.QTY*DS.SALEPRICE)) AS [TOTAL SALES]
FROM DWSALE DS
INNER JOIN DWCUST DC 
ON DS.DWCUSTID=DC.DWCUSTID
GROUP BY [STATE]
ORDER BY[TOTAL SALES] DESC

SELECT TOP 1 CITY AS CITY, [TOTAL SALES]
FROM 
(SELECT TOP 100 DC.[STATE] , DC.CITY, SUM(DS.QTY*DS.SALEPRICE) AS [TOTAL SALES]
FROM DWSALE DS
INNER JOIN DWCUST DC 
ON DS.DWCUSTID=DC.DWCUSTID
GROUP BY [STATE],CITY
ORDER BY[TOTAL SALES] DESC
) AS A

SELECT DC.[STATE] , DC.CITY ,SUM(DS.QTY*DS.SALEPRICE) AS [TOTAL SALES]
FROM DWSALE DS
INNER JOIN DWCUST DC 
ON DS.DWCUSTID=DC.DWCUSTID
GROUP BY [STATE] ,CITY
ORDER BY[TOTAL SALES] DESC

