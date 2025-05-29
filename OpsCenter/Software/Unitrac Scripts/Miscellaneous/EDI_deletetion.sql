USE EDI

SELECT 'docaudittbl',  COUNT(*) 
FROM docaudittbl d
WHERE d.ActionTimestamp <= '1578635999000'
--7,218,252

SELECT 'taskaudittbl', COUNT(*) 
FROM taskaudittbl t
WHERE t.ActionTimestamp <= '1578635999000'
--1148344

SELECT'bpaudittbl' , COUNT(*) 
FROM bpaudittbl b
WHERE b.ActionTimestamp <= '1578635999000'
--174261

---Delete docaudittbl records

SELECT  COUNT(*) 
FROM docaudittbl d
WHERE d.actiontimestamp BETWEEN '1420070550844' and '1451610000000'
--1417266
--Start Wednesday, December 31, 2014 7:02:30.844 PM 
--End Thursday, December 31, 2015 8:00:00 PM

SELECT  COUNT(*) 
FROM docaudittbl d
WHERE d.actiontimestamp BETWEEN '1451610001000' and '1483232400000'
--1399928
--Start Thursday, December 31, 2015 8:00:01 PM
--End Saturday, December 31, 2016 8:00:00 PM

SELECT  COUNT(*) 
FROM docaudittbl d
WHERE d.actiontimestamp BETWEEN '1483232401000' and '1514768400000'
--1405626
--Start Saturday, December 31, 2016 8:00:01 PM
--End Sunday, December 31, 2017 8:00:00 PM


SELECT  COUNT(*) 
FROM docaudittbl d
WHERE d.actiontimestamp BETWEEN '1514768401000' and '1546304400000'
--1471479
--Start Sunday, December 31, 2017 8:00:01 PM
--End Monday, December 31, 2018 8:00:00 PM



SELECT  COUNT(*) 
FROM docaudittbl d
WHERE d.actiontimestamp BETWEEN '1546304401000' and '1578635999000'
--1523953
--Start Monday, December 31, 2018 8:00:01 PM
--End  Friday, January 10, 2020 11:59:59 PM










-----------------------delete taskaudittbl records


SELECT  COUNT(*) 
FROM taskaudittbl t
WHERE t.actiontimestamp BETWEEN '1420070550847' and '1451610000000'
--216556
--Start Wednesday, December 31, 2014 7:02:30.844 PM 
--End Thursday, December 31, 2015 8:00:00 PM

SELECT  COUNT(*) 
FROM taskaudittbl t
WHERE t.actiontimestamp BETWEEN '1451610001000' and '1483232400000'
--223667
--Start Thursday, December 31, 2015 8:00:01 PM
--End Saturday, December 31, 2016 8:00:00 PM

SELECT  COUNT(*) 
FROM taskaudittbl t
WHERE t.actiontimestamp BETWEEN '1483232401000' and '1514768400000'
--223667
--Start Saturday, December 31, 2016 8:00:01 PM
--End Sunday, December 31, 2017 8:00:00 PM


SELECT  COUNT(*) 
FROM taskaudittbl t
WHERE t.actiontimestamp BETWEEN '1514768401000' and '1546304400000'
--240117
--Start Sunday, December 31, 2017 8:00:01 PM
--End Monday, December 31, 2018 8:00:00 PM



SELECT  COUNT(*) 
FROM taskaudittbl t
WHERE t.actiontimestamp BETWEEN '1546304401000' and '1578635999000'
--1523953
--Start Monday, December 31, 2018 8:00:01 PM
--End  Friday, January 10, 2020 11:59:59 PM

----------------------- delete bpaudittbl records 

SELECT  COUNT(*) 
FROM bpaudittbl b
WHERE b.actiontimestamp BETWEEN '1420070551054' and '1451610000000'
--33398
--Start Wednesday, December 31, 2014 7:02:30.844 PM 
--End Thursday, December 31, 2015 8:00:00 PM

SELECT  COUNT(*) 
FROM bpaudittbl b
WHERE b.actiontimestamp BETWEEN '1451610001000' and '1483232400000'
--34539
--Start Thursday, December 31, 2015 8:00:01 PM
--End Saturday, December 31, 2016 8:00:00 PM

SELECT  COUNT(*) 
FROM bpaudittbl b
WHERE b.actiontimestamp BETWEEN '1483232401000' and '1514768400000'
--37920
--Start Saturday, December 31, 2016 8:00:01 PM
--End Sunday, December 31, 2017 8:00:00 PM


SELECT  COUNT(*) 
FROM bpaudittbl b
WHERE b.actiontimestamp BETWEEN '1514768401000' and '1546304400000'
--35662
--Start Sunday, December 31, 2017 8:00:01 PM
--End Monday, December 31, 2018 8:00:00 PM



SELECT  COUNT(*) 
FROM bpaudittbl b
WHERE b.actiontimestamp BETWEEN '1546304401000' and '1578635999000'
--32742
--Start Monday, December 31, 2018 8:00:01 PM
--End  Friday, January 10, 2020 11:59:59 PM
