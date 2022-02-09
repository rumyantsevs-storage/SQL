-- Задание 1.


CREATE DATABASE taskdb;


CREATE TABLE Orders
(
	O_Id serial NOT NULL PRIMARY KEY,
	OrderDate date NOT NULL,
	OrderPrice numeric(7) NOT NULL,
	Customer varchar(30) NOT NULL
);


INSERT INTO Orders
VALUES
(1, '2008/11/12', 1000, 'Hansen'),
(2, '2008/10/23', 1600, 'Nilsen'),
(3, '2008/09/02', 700, 'Hansen'),
(4, '2008/09/03', 300, 'Hansen'),
(5, '2008/08/30', 2000, 'Jensen'),
(6, '2008/10/04', 100, 'Nilsen');


SELECT O_Id, to_char(OrderDate, 'YYYY/MM/DD'), OrderPrice, Customer
FROM Orders;


-- Задание 1.А.Как найти общую сумму заказа для каждого клиента?


SELECT Customer, sum(OrderPrice)
FROM Orders
GROUP BY Customer
ORDER BY sum(OrderPrice) DESC;


-- Задание 1.Б. Как найти, какой из клиентов имеет сумму заказа меньшую 2000.


SELECT Customer, sum(OrderPrice)
FROM Orders
GROUP BY Customer
HAVING sum(OrderPrice) < 2000
ORDER BY sum(OrderPrice) DESC;


-- Задание 1.В. Как найти клиентов, которые сделали заказ OrderPrice больше, чем среднее значение колонки "OrderPrice".


SELECT Customer, OrderPrice
FROM Orders
GROUP BY o_id
HAVING OrderPrice > (SELECT avg(OrderPrice)
					 FROM Orders)
ORDER BY o_id ASC;


-- Задание 2.


CREATE SCHEMA SCOTT;


CREATE TABLE SCOTT.DEPT
(
	DEPTNO numeric(2) NOT NULL PRIMARY KEY, -- номер департамента
	DNAME varchar(14) NOT NULL, -- наименование департамента
	LOC varchar(13) NOT NULL -- местонахождение департамента
);


INSERT INTO SCOTT.DEPT
VALUES
(1, 'dept1', 'loc1'),
(2, 'dept2', 'loc2'),
(3, 'dept3', 'loc3'),
(4, 'dept4', 'loc4'),
(5, 'dept5', 'loc5'),
(6, 'dept6', 'loc6'),
(7, 'dept7', 'loc7'),
(8, 'dept8', 'loc8'),
(9, 'dept9', 'loc9');


CREATE TABLE SCOTT.EMP
(
	EMPNO numeric(4) NOT NULL PRIMARY KEY, -- номер по списку
	ENAME varchar(10) NOT NULL, -- имя сотрудника
	JOB varchar(9) NOT NULL, -- должность сотрудника
	MGR numeric(4), -- номер непосредственного начальника
	HIREDATE date NOT NULL, -- дата приёма на работу
	SAL numeric(7,2) NOT NULL, -- зарплата сотрудника
	COMM numeric(7,2), -- комиссионные выплаты
	DEPTNO numeric(2) NOT NULL REFERENCES SCOTT.DEPT (DEPTNO) -- номер департамента
);


INSERT INTO SCOTT.EMP
VALUES
(1, 'Abrams', 'job1', NULL, '2015-02-20', 1500, NULL, 4),
(2, 'Smitters', 'job1', NULL, '2021-03-15', 2000, NULL, 1),
(3, 'Simpson', 'job1', NULL, '2013-04-05', 900, NULL, 1),
(4, 'Flunders', 'job1', NULL, '2003-07-02', 600, NULL, 1),
(5, 'Moriarty', 'job1', NULL, '2007-02-18', 1000, NULL, 7),
(6, 'Biker', 'job1', NULL, '2010-04-01', 752, NULL, 2),
(7, 'Young', 'job1', NULL, '1998-05-26', 800, NULL, 3),
(8, 'Puffenduy', 'job1', NULL, '2016-09-14', 750, NULL, 6),
(9, 'Keller', 'job1', NULL, '2017-08-24', 1010, NULL, 5),
(10, 'Oblomoff', 'job1', NULL, '2021-12-30', 970, NULL, 4),
(11, 'September', 'job1', NULL, '2021-11-20', 950, NULL, 7);


-- Задание 2.А. Перечислить имена и зарплаты всех сотрудников департаментов 1 и 7, с зарплатами меньше 1000, имена которых начинаются на S ('Smith', 'Simpson', ...)


SELECT ENAME, SAL
FROM SCOTT.EMP
WHERE ((DEPTNO = 1) or (DEPTNO = 7))
AND   (SAL < 1000)
AND   (left(ENAME, 1) = 'S')
ORDER BY ENAME ASC;


-- Задание 2.Б. Список имён сотрудников с именами департаментов, в которых они работают, упорядоченный по имени департамента и имени сотрудника


SELECT ENAME, DNAME
FROM SCOTT.EMP
JOIN SCOTT.DEPT
ON SCOTT.EMP.DEPTNO = SCOTT.DEPT.DEPTNO
ORDER BY DNAME ASC, ENAME ASC;


-- Задание 2.В. Список имён департаментов, не имеющих сотрудников


SELECT DNAME
FROM SCOTT.DEPT
WHERE DEPTNO NOT IN(SELECT DEPTNO FROM SCOTT.EMP)
ORDER BY DNAME ASC;


-- Задание 3.


CREATE TABLE tab_product
(
	product_id integer NOT NULL PRIMARY KEY,
	product_name text NOT NULL,
	cost numeric(7)
);


INSERT INTO tab_product
VALUES
(1, 'гитара', 150),
(2, 'барабан', 250),
(3, 'баян', 70),
(4, 'гусли', 20),
(5, 'электрогитара', 200),
(6, 'рояль', 2000),
(7, 'басс-гитара', 180),
(8, 'труба', 120),
(9, 'электрогитара', 200),
(10, 'рояль', 2000),
(11, 'басс-гитара', 180);


-- Задание 3.Что делает этот код?


select product_name,
     sum_cost      
from 
(
select product_id,
     product_name,
     row_number() OVER (PARTITION BY product_id ORDER BY cost DESC) AS rn, 
     sum(cost) OVER (PARTITION BY product_id ORDER BY cost DESC) as sum_cost
from tab_product )t
where rn = 1;


-- e.g.


SELECT product_name, cost AS sum_cost
FROM tab_product;