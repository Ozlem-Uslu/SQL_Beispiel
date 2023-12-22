--1. Schreiben Sie eine Abfrage, die Personen aus der Tabelle „Customers“ abruft, deren Namen mit dem Buchstaben „A“ beginnen.
SELECT NAMESURNAME FROM CUSTOMERS
WHERE NAMESURNAME LIKE 'A%'

--2. Schreiben Sie die Abfrage, die Kunden erfasst, die zwischen 1990 und 1995 geboren sind. Die Jahre 1990 und 1995 sind enthalten.
SELECT ID, NAMESURNAME, BIRTHDATE FROM CUSTOMERS
WHERE YEAR(BIRTHDATE) BETWEEN 1990 AND 1995

--3. Schreiben Sie die Abfrage, die Menschen, die in Istanbul leben, über Join anlockt.
SELECT C.ID, C.NAMESURNAME, CT.CITY
FROM CUSTOMERS C
JOIN CITIES CT ON C.CITYID=CT.ID
WHERE CT.CITY='İSTANBUL'
.
--4. Schreiben Sie mithilfe der Unterabfrage die Abfrage, die in Istanbul lebende Personen zurückgibt.
SELECT NAMESURNAME FROM CUSTOMERS C
WHERE C.CITYID in (SELECT ID from CITIES where CITY='İSTANBUL')

--5. Schreiben Sie die Abfrage, die Auskunft darüber gibt, wie viele Kunden wir in welcher Stadt haben.
SELECT CT.CITY, COUNT(C.ID) musteri_sayisi 
FROM CUSTOMERS C
JOIN CITIES CT ON CT.ID=C.CITYID
GROUP BY CT.CITY
ORDER BY COUNT(C.ID) DESC

--6. Listen Sie die Städte auf, in denen wir mehr als 10 Kunden haben, in der Reihenfolge von den meisten zu den wenigsten, entsprechend der Anzahl der Kunden.
SELECT C.CITYID, CT.CITY, COUNT(C.ID)musteri_sayisi 
FROM CUSTOMERS C
Join CITIES CT on CT.ID=C.CITYID
GROUP BY C.CITYID, CITY
HAVING COUNT(C.ID)> 10 
ORDER BY 3 DESC

--7. Schreiben Sie die Abfrage, die Aufschluss darüber gibt, wie viele männliche und weibliche Kunden wir in welcher Stadt haben.
SELECT CT.CITY, GENDER, COUNT(C.ID)  
FROM CUSTOMERS C
Join CITIES CT on CT.ID=C.CITYID
GROUP BY GENDER, CT.CITY 
ORDER BY CITY, GENDER


--8. Fügen Sie der Tabelle „Customers“ ein neues Feld für die Altersgruppe hinzu. Tun Sie dies sowohl mit Management 
Studio als auch mit SQL-Code. Feldname AGEGROUP-Datentyp Varchar(50)
	
ALTER TABLE CUSTOMERS			
ADD AGEGROUP Varchar(50);		

--9. Aktualisieren Sie das Feld AGEGROUP, das Sie der Customerstabelle hinzugefügt haben, als 20–35 Jahre, 36–45 Jahre, 46–55 Jahre, 55–65 Jahre und über 65 Jahre.

SELECT * FROM CUSTOMERS
UPDATE CUSTOMERS SET AGEGROUP = '20-35'
WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 20 AND 35
UPDATE CUSTOMERS SET AGEGROUP = '36-45'
WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 36 AND 45
UPDATE CUSTOMERS SET AGEGROUP = '46-55'
WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 46 AND 55
UPDATE CUSTOMERS SET AGEGROUP = '55-65'
WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 55 AND 65
UPDATE CUSTOMERS SET AGEGROUP = '65_yas_ustu'
WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) >65

--10. Listen Sie diejenigen auf, die in Istanbul leben und deren Bezirk außerhalb von „Kadıköy“ liegt.
	
SELECT C.ID, NAMESURNAME, DISTRICT 
FROM CUSTOMERS AS C
JOIN CITIES AS CT ON CT.ID= C.CITYID
JOIN DISTRICTS AS D ON D.ID=C.DISTRICTID
WHERE CITY='İSTANBUL'and DISTRICT <> 'KADIKÖY'

	
--11. Wir möchten dem Betreiber die Telefonnummern unserer Kunden mitteilen. Wir möchten die Betreibernummer wie (532), (505) neben die Felder TELNR1 und TELNR2 setzen. 
Schreiben Sie die für diese Abfrage erforderliche SQL-Anweisung.

SELECT*,
LEFT(TELNR1,5) AS OPERATOR1,
LEFT(TELNR2,5) AS OPERATOR2
FROM CUSTOMERS

--12. Wir möchten dem Betreiber die Telefonnummern unserer Kunden mitteilen
Angenommen, der Operator „X“, dessen Telefonnummern mit „50“ oder „55“ beginnen, ist der Operator „Y“, der mit „54“ beginnt, und der Operator „Z“ beginnt mit „53“.
Schreiben Sie hier die Abfrage, die Aufschluss darüber gibt, wie viele Kunden wir von welchem ​​Betreiber haben.
	
SELECT ID, NAMESURNAME,TELNR1, TELNR2, Op1, Op2 FROM CUSTOMERS 
UPDATE CUSTOMERS SET Op1 = 'X'
WHERE TELNR1 like '(50%' or TELNR1 like '(55%' 
UPDATE CUSTOMERS SET Op1 = 'Y'
WHERE TELNR1 like '(54%' 
UPDATE CUSTOMERS SET Op1 = 'Z'
WHERE TELNR1 like '(53%' 
UPDATE CUSTOMERS SET Op2 = 'X'
WHERE TELNR2 like '(50%' or TELNR2 like '(55%' 
UPDATE CUSTOMERS SET Op2 = 'Y'
WHERE TELNR2 like '(54%' 
UPDATE CUSTOMERS SET Op2 = 'Z'
WHERE TELNR2 like '(53%' 

SELECT COUNT(C.Op1 + C.Op2) FROM CUSTOMERS C
WHERE Op1='X' and Op2='X'
SELECT COUNT(C.Op1 + C.Op2) FROM CUSTOMERS C
WHERE Op1='Y' and Op2='Y'
SELECT COUNT(C.Op1 + C.Op2) FROM CUSTOMERS C
WHERE Op1='Z' and Op2='Z'


SELECT 
 SUM(TELNR1_XOPERATOR + TELNR2_XOPERATOR) AS XOPERATORCOUNT,
 SUM(TELNR1_YOPERATOR + TELNR2_YOPERATOR) AS YOPERATORCOUNT,
 SUM(TELNR1_ZOPERATOR + TELNR2_ZOPERATOR) AS ZOPERATORCOUNT
 FROM
 (SELECT
 CASE 
     WHEN TELNR1 LIKE '(50%' OR TELNR1 LIKE '(55%' THEN 1
	 ELSE 0
END AS TELNR1_XOPERATOR,
CASE 
     WHEN TELNR1 LIKE '(54%'  THEN 1
	 ELSE 0
END AS TELNR1_YOPERATOR,
 CASE 
     WHEN TELNR1 LIKE '(53%'  THEN 1
	 ELSE 0
END AS TELNR1_ZOPERATOR,
 CASE 
     WHEN TELNR2 LIKE '(50%' OR TELNR2 LIKE '(55%' THEN 1
	 ELSE 0
END AS TELNR2_XOPERATOR,
CASE 
     WHEN TELNR2 LIKE '(54%'  THEN 1
	 ELSE 0
END AS TELNR2_YOPERATOR,
 CASE 
     WHEN TELNR2 LIKE '(53%'  THEN 1
	 ELSE 0
END AS TELNR2_ZOPERATOR
FROM CUSTOMERS)T

--13. Schreiben Sie die erforderliche Abfrage, um die Bezirke, in denen wir in jeder Provinz die meisten Kunden haben, 
--in der Reihenfolge vom höchsten zum niedrigsten Wert entsprechend der Anzahl der Kunden anzuzeigen, wie in der Abbildung dargestellt.

SELECT CITY, DISTRICT,Count(C.ID) MÜSTERI_SAYISI  
FROM CUSTOMERS C
JOIN  DISTRICTS D ON C.DISTRICTID=D.ID
JOIN   CITIES CT   ON CT.ID=D.CITYID
GROUP BY CITY, DISTRICT 
ORDER BY Count(C.ID) DESC


--14. Schreiben Sie eine Abfrage, die die Geburtstage der Kunden als Wochentag (Montag, Dienstag, Mittwoch usw.) zurückgibt.
	
SELECT C.ID, C.NAMESURNAME, C.BIRTHDATE, 
DATENAME(WEEKDAY, C.BIRTHDATE) DAYNAME_ 
FROM CUSTOMERS C
GROUP BY C.ID, C.NAMESURNAME,C.BIRTHDATE,
DATEPART(DAY, C.BIRTHDATE), DATENAME(WEEKDAY, C.BIRTHDATE)





