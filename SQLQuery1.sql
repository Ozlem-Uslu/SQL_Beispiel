--2. Customers tablosundan adı‘A’ harfi ile başlayan kişileri çeken sorguyu yazınız.
SELECT NAMESURNAME FROM CUSTOMERS
WHERE NAMESURNAME LIKE 'A%'

--3. 1990 ve 1995 yılları arasında doğan müşterileri çekiniz. 1990 ve1995 yılları dahildir.
SELECT ID, NAMESURNAME, BIRTHDATE FROM CUSTOMERS
WHERE YEAR(BIRTHDATE) BETWEEN 1990 AND 1995

--4. İstanbul’da yaşayan kişileri Join kullanarak getiren sorguyu yazınız.
SELECT C.ID, C.NAMESURNAME, CT.CITY
FROM CUSTOMERS C
JOIN CITIES CT ON C.CITYID=CT.ID
WHERE CT.CITY='İSTANBUL'
.
--5. İstanbul’da yaşayan kişileri subquery kullanarak getiren sorguyu yazınız.
SELECT NAMESURNAME FROM CUSTOMERS C
WHERE C.CITYID in (SELECT ID from CITIES where CITY='İSTANBUL')

--6. Hangi şehirde kaç müşterimizin olduğu bilgisini getiren sorguyu yazınız.
SELECT CT.CITY, COUNT(C.ID) musteri_sayisi 
FROM CUSTOMERS C
JOIN CITIES CT ON CT.ID=C.CITYID
GROUP BY CT.CITY
ORDER BY COUNT(C.ID) DESC

--7. 10’dan fazla müşterimiz olan şehirleri müşteri sayısı ile birlikte müşteri 
--sayısına göre fazladan aza doğru sıralı şekilde getiriniz. 
SELECT C.CITYID, CT.CITY, COUNT(C.ID)musteri_sayisi 
FROM CUSTOMERS C
Join CITIES CT on CT.ID=C.CITYID
GROUP BY C.CITYID, CITY
HAVING COUNT(C.ID)> 10 
ORDER BY 3 DESC

--8. Hangi şehirde kaç erkek, kaç kadın müşterimizin olduğu bilgisini getiren sorguyu yazınız.
SELECT CT.CITY, GENDER, COUNT(C.ID)  
FROM CUSTOMERS C
Join CITIES CT on CT.ID=C.CITYID
GROUP BY GENDER, CT.CITY 
ORDER BY CITY, GENDER


--9. Customers tablosuna yaş grubu için yeni bir alan ekleyiniz. Bu işlemi hem management 
--studio ile hem de sql kodu ile yapınız. Alanı adı AGEGROUP veritipi Varchar(50)

ALTER TABLE CUSTOMERS			--SQL KODU (ALTER TABLE) ile ALTER TABLE deyimi mevcut bir tabloya sütun eklemek, silmek veya değiştirmek için kullanılır.
ADD AGEGROUP Varchar(50);		--ALTER TABLE ifadesi aynı zamanda mevcut bir tabloya çeşitli kısıtlamalar eklemek ve bırakmak için de kullanılır.




--10. Customers tablosuna eklediğiniz AGEGROUP alanını 20-35 yaş arası,36-45 yaş arası,
--46-55 yaş arası,55-65 yaş arası ve 65 yaş üstü olarak güncelleyiniz.

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

-- yaslari gruplandirabilmek icin yas sütunu da olusturabilirim.
UPDATE CUSTOMERS
SET AGE =DATEDIFF(YEAR, BIRTHDATE, GETDATE())
SELECT * FROM CUSTOMERS

--11. İstanbul’da yaşayıp ilçesi ‘Kadıköy’ dışında olanları listeleyiniz.
SELECT C.ID, NAMESURNAME, DISTRICT 
FROM CUSTOMERS AS C
JOIN CITIES AS CT ON CT.ID= C.CITYID
JOIN DISTRICTS AS D ON D.ID=C.DISTRICTID
WHERE CITY='İSTANBUL'and DISTRICT <> 'KADIKÖY'

--2.yol
SELECT * FROM CUSTOMERS 
WHERE CITYID IN (SELECT ID FROM CITIES WHERE CITY='İSTANBUL') 
AND DISTRICTID NOT IN (SELECT ID FROM DISTRICTS WHERE DISTRICT='KADIKÖY')

--asagidaki kod ile istanbulda oturanlarin listesi 47 kisi gelir.
SELECT NAMESURNAME, CITY 
FROM CUSTOMERS C
JOIN CITIES CT on C.CITYID=CT.ID
WHERE CITY ='İSTANBUL'

--NOT: neden istanbulda oturup kadiköy disindakiler listesi istanbulda oturanlar ile ayni
--satir geliyor?


--12. Müşterilerimizin telefon numalarının operatör bilgisini getirmek istiyoruz. 
--TELNR1 ve TELNR2 alanlarının yanına operatör numarasını (532),(505) gibi getirmek istiyoruz. 
--Bu sorgu için gereken SQL cümlesini yazınız.

SELECT*,
LEFT(TELNR1,5) AS OPERATOR1,
LEFT(TELNR2,5) AS OPERATOR2
FROM CUSTOMERS


--13 ANLAMADIM!!
--13. Müşterilerimizin telefon numaralarının operatör bilgisini getirmek istiyoruz. 
--Örneğin telefon numaraları “50” ya da “55” ile başlayan “X” operatörü “54” 
--ile başlayan “Y” operatörü “53” ile başlayan “Z” operatörü olsun. 
--Burada hangi operatörden ne kadar müşterimiz olduğu bilgisini getirecek sorguyu yazınız.

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

--Hangi operatörden nekadar müsteri kullaniyor sorgusu nasil gelir?



--14. Her ilde en çok müşteriye sahip olduğumuz ilçeleri müşteri sayısına göre 
--çoktan aza doğru sıralı şekilde şekildeki gibi getirmek için gereken sorguyu yazınız. 

SELECT CITY, DISTRICT,Count(C.ID) MÜSTERI_SAYISI  
FROM CUSTOMERS C
JOIN  DISTRICTS D ON C.DISTRICTID=D.ID
JOIN   CITIES CT   ON CT.ID=D.CITYID
GROUP BY CITY, DISTRICT 
ORDER BY Count(C.ID) DESC


--15. Müşterilerin doğum günlerini haftanın günü(Pazartesi, Salı, Çarşamba..) 
--olarak getiren sorguyu yazınız.

SELECT DATEPART(WEEKDAY, C.BIRTHDATE) DAY_ FROM CUSTOMERS C
--dogum günü tarihinin haftanin kacinci günü oldugu bilgisini verir.mesela 12.05 haftanin 2. günü yani dienstag imis.

SELECT C.ID, C.NAMESURNAME, C.BIRTHDATE, 
DATENAME(WEEKDAY, C.BIRTHDATE) DAYNAME_ 
FROM CUSTOMERS C
GROUP BY C.ID, C.NAMESURNAME,C.BIRTHDATE,
DATEPART(DAY, C.BIRTHDATE), DATENAME(WEEKDAY, C.BIRTHDATE)





