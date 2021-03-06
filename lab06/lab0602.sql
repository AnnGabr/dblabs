-- Clean
----------------------------------------------------------------------------------------------------

DROP TABLE RESULTS;
DROP TABLE RACES;
DROP TABLE COMPETITIONS;

DROP TABLE HORSES;

DROP TABLE JOCKEYS;
DROP TABLE OWNERS;

-- Init
----------------------------------------------------------------------------------------------------

CREATE TABLE JOCKEYS
    (
        ID NUMBER(2) PRIMARY KEY,
        NAME VARCHAR2(50) NOT NULL,
        ADDRESS VARCHAR2(50) NOT NULL,
        HEIGHT NUMBER(3) NOT NULL,
        WEIGHT NUMBER(3) NOT NULL,
        BIRTH DATE NOT NULL
    );

CREATE TABLE OWNERS
    (
        ID NUMBER(2) PRIMARY KEY,
        NAME VARCHAR2(50) NOT NULL,
        ADDRESS VARCHAR2(50) NOT NULL
    );

CREATE TABLE HORSES
    (
        ID NUMBER(2) PRIMARY KEY,
        JOCKEY_ID NUMBER(2) REFERENCES JOCKEYS(ID) NOT NULL,
        OWNER_ID NUMBER(2) REFERENCES OWNERS(ID) NOT NULL,
        NICK VARCHAR2(20) NOT NULL,
        BIRTH DATE NOT NULL,
        SEX VARCHAR2(5) NOT NULL
    );

CREATE TABLE COMPETITIONS
    (
        ID NUMBER(2) PRIMARY KEY,
        COMPETITION_DATE DATE NOT NULL,
        PLACE VARCHAR2(50) NOT NULL,
        NAME VARCHAR2(50),
        RACE_COUNT NUMBER(2) NOT NULL
    );

CREATE TABLE RACES
    (
        ID NUMBER(2) PRIMARY KEY,
        COMPETITION_ID NUMBER(2) REFERENCES COMPETITIONS(ID) NOT NULL
    );

CREATE TABLE RESULTS
    (
        RACE_ID NUMBER(2) REFERENCES RACES(ID) NOT NULL,
        HORSE_ID NUMBER(2) REFERENCES HORSES(ID) NOT NULL,
        POSITION NUMBER(2) NOT NULL
    );

COMMIT;
----------------------------------------------------------------------------------------------------

-- Populate
----------------------------------------------------------------------------------------------------
INSERT INTO JOCKEYS VALUES
    (1, 'Dave', '123 Mein ave, MI'      , 181, 70, to_date('01-01-1981', 'dd-mm-yyyy'));
INSERT INTO JOCKEYS VALUES
    (2, 'John', '45 Herz st, CH'        , 179, 75, to_date('10-01-1983', 'dd-mm-yyyy'));
INSERT INTO JOCKEYS VALUES
    (3, 'Jim', '78 Shmidt rd, LA'      , 182, 73, to_date('01-11-1984', 'dd-mm-yyyy'));
INSERT INTO JOCKEYS VALUES
    (4, 'Tom', '89 Hamburg strasse, NY', 178, 68, to_date('11-11-1985', 'dd-mm-yyyy'));


INSERT INTO OWNERS VALUES
    (1, 'Mr Sammers', '23 Abbey rd, London');
INSERT INTO OWNERS VALUES
    (2, 'Mr Goldstein', 'Hyde park 75, NY');


INSERT INTO HORSES VALUES
    (1, 1, 1, 'Donald'      , to_date('01-01-0001', 'dd-mm-yyyy'), 'Male');
INSERT INTO HORSES VALUES
    (2, 2, 1, 'Anton Palych', to_date('01-01-0001', 'dd-mm-yyyy'), 'Male');
INSERT INTO HORSES VALUES
    (3, 3, 2, 'Alan'        , to_date('01-01-0001', 'dd-mm-yyyy'), 'Male');
INSERT INTO HORSES VALUES
    (4, 4, 2, 'Smith'       , to_date('01-01-0001', 'dd-mm-yyyy'), 'Male');


INSERT INTO COMPETITIONS VALUES
    (1, to_date('01-01-0001', 'dd-mm-yyyy'), 'Champton', 'Champton Gran Prx', 2);
INSERT INTO COMPETITIONS VALUES
    (2, to_date('02-01-0001', 'dd-mm-yyyy'), 'Champton', 'Champton Gran Prx', 2);
INSERT INTO COMPETITIONS VALUES
    (3, to_date('03-01-0001', 'dd-mm-yyyy'), 'Bringhton', 'Bringhton Gran Prx', 1);


INSERT INTO RACES VALUES (1, 1);
INSERT INTO RACES VALUES (2, 1);
INSERT INTO RACES VALUES (3, 2);
INSERT INTO RACES VALUES (4, 2);
INSERT INTO RACES VALUES (5, 3);


INSERT INTO RESULTS VALUES (1, 1, 2);
INSERT INTO RESULTS VALUES (1, 2, 1);
INSERT INTO RESULTS VALUES (1, 3, 4);
INSERT INTO RESULTS VALUES (1, 4, 3);

INSERT INTO RESULTS VALUES (2, 4, 1);
INSERT INTO RESULTS VALUES (2, 2, 2);
INSERT INTO RESULTS VALUES (2, 3, 3);
INSERT INTO RESULTS VALUES (2, 1, 4);

INSERT INTO RESULTS VALUES (3, 3, 1);
INSERT INTO RESULTS VALUES (3, 2, 2);
INSERT INTO RESULTS VALUES (3, 4, 3);
INSERT INTO RESULTS VALUES (3, 1, 4);

INSERT INTO RESULTS VALUES (4, 4, 1);
INSERT INTO RESULTS VALUES (4, 3, 2);
INSERT INTO RESULTS VALUES (4, 2, 3);
INSERT INTO RESULTS VALUES (4, 1, 4);

INSERT INTO RESULTS VALUES (4, 1, 1);
INSERT INTO RESULTS VALUES (4, 2, 2);
INSERT INTO RESULTS VALUES (4, 3, 3);
INSERT INTO RESULTS VALUES (4, 4, 4);

----------------------------------------------------------------------------------------------------

-- 1. Создайте последовательность
CREATE SEQUENCE ID_SEQUENCE
    INCREMENT BY 1
    START WITH 1
    NOMAXVALUE
    ORDER
    NOCYCLE;

--2. Добавьте в схему базы данных, разработанную Вами в лабораторной работе №1, новую сущность.
--   Создайте для этой сущности таблицу (таблицы). Причем, поле этой таблицы с ограничением
--   первичного ключа должно заполняться с помощью последовательности. Заполните таблицу данными.

CREATE TABLE HIPPODROME
    (
        ID NUMBER(2) PRIMARY KEY,
        NAME VARCHAR2(30),
        OWNER_ID REFERENCES OWNERS
    );

INSERT INTO HIPPODROME VALUES
    (ID_SEQUENCE.NEXTVAL, 'Champton', 1)
INSERT INTO HIPPODROME VALUES
    (ID_SEQUENCE.NEXTVAL, 'Bringhton', 2)


--3. Создайте индексы для тех полей базы данных, для которых это необходимо
CREATE INDEX JOCKEY_NAME ON JOCKEYS(ADDRESS, NAME)


--4. В одну из таблиц добавьте поле (внешний ключ), значения которого ссылаются на поле –
--   первичный ключ этой таблицы (academy.oracle.com\iLearning\2013-2014 Oracle Academy Database
--   Programming with SQL – Student\Section 8 Working with DDL Statements). Составьте запросы на
--   выборку данных с использованием рефлексивного соединения
--   (academy.oracle.com\iLearning\2013-2014 Oracle Academy Database Programming with SQL –
--   Student\Section 3 Executing Database Joins\Self Joins and Hierarchical Queries).
ALTER TABLE COMPETITIONS
    ADD (HIPPODROME_ID NUMBER(10));

ALTER TABLE COMPETITIONS
    ADD (HIPPODROME_ID NUMBER(10) NOT NULL REFERENCES HIPPODROME(ID));


--   Составьте запросы на выборку данных с использованием следующих операторов, конструкцийи функций
--   языка SQL:
--5. простого оператора CASE ();
SELECT NICK, BIRTH,
    CASE
        WHEN SEX == 'Male'
            THEN 'M'
        WHEN SEX == 'Female'
            THEN 'F'
        ELSE 'N/A'
    END
    FROM HORSES


--6. поискового оператора CASE();
SELECT NAME, WEIGHT, HEIGHT,
    CASE
        WHEN WHEIGHT + HEIGHT < 250
            THEN 'OK'
        ELSE NULL
    END
    FROM JOCKEYS


--7. оператора WITH();
WITH horse AS (SELECT * FROM HORSES)
SELECT * FROM horse WHERE Sex = 'Male'


--8. встроенного представления();
SELECT JOCKEY_NAME, OWNER_NAME, NICK AS HORSE_NICK FROM
    (SELECT OWNER_ID, JOCKEY_ID, NICK FROM HORSES) H
    JOIN (SELECT ID, NAME AS OWNER_NAME FROM OWNERS) O
    ON O.ID = H.OWNER_ID
    JOIN (SELECT ID, NAME AS JOCKEY_NAME FROM JOCKEYS) J
    ON J.ID = H.JOCKEY_ID


--9. некоррелированного запроса((academy.oracle.com\iLearning\2013-2014 Oracle Academy Database
--   Programming with SQL – Student\Section 6 Creating Subqueries).);
----
--   Вывести имена жокеев старше 25 лет
SELECT NAME FROM JOCKEYS WHERE MONTHS_BETWEEN (SYSDATE, BIRTHDATE) / 12 > 25


--10. коррелированного запроса(academy.oracle.com\iLearning\2013-2014 Oracle Academy Database
--    Programming with SQL – Student\Section 6 Creating Subqueries).);
-----
--    Вывести имена жокеев, лошади которых принадлежат 'Mr Sammers'
SELECT NAME FROM JOCKEYS J
    JOIN (SELECT JOCKEY_ID FROM HORSES H
        JOIN (SELECT ID FROM OWNERS WHERE NAME = 'Mr Sammers') O
            ON H.OWNER_ID = O.ID) I
        ON J.ID = I.JOCKEY_ID


--11. функции NULLIF (academy.oracle.com\iLearning\2013-2014 Oracle Academy Database Programming
--    with SQL – Student\Section 2 Using Single-Row Functions);
SELECT NAME, ADDRESS, WEIGHT, HEIGHT, BIRTH, NULLIF(HEIGHT, 182) FROM JOCKEYS


--12. функции NVL2 (academy.oracle.com\iLearning\2013-2014 Oracle Academy Database Programming
--    with SQL – Student\Section 2 Using Single-Row Functions);
SELECT NICK, NVL2(BIRTH, BIRTH, 'N/A') FROM HORSES


--13. TOP-N анализа();
-----
--   Вывести TOP-3 по всем заездам.
SELECT *
    FROM (SELECT *
        FROM RACES
        ORDER BY POSITION DESC)
    WHERE ROWNUM <= 3;


--14. функции ROLLUP().
-- Вывести статистику занимаемых позиций каждой лошадью
SELECT HORSE_ID, POSITION, COUNT(POSITION)
    FROM RESULTS
    GROUP BY ROLLUP(HORSE_ID, POSITION)

--15. Составьте запрос на использование оператора MERGE языка манипулирования данными.

CREATE TABLE
    NEW_RaceAreas
    (
        RaceArea_ID NUMBER(10) PRIMARY KEY,
        RaceArea_Address VARCHAR2(300) NOT NULL,
        RaceArea_MaxNumOfGuests NUMBER(10) NOT NULL
            CHECK (RaceArea_MaxNumOfGuests > 0),
        RaceArea_Square NUMBER(10) --in hectares
            CHECK (RaceArea_Square > 0)
    );

INSERT INTO NEW_RaceAreas VALUES
    (1, 'Knighton, Powys LD7 1DL, United Kingdom', 3000, 5000);

INSERT INTO NEW_RaceAreas VALUES
    (2, 'Ketley Bank, Telford, Telford and Wrekin TF2 0EB, United Kingdom', 12000, 11000);

INSERT INTO NEW_RaceAreas VALUES
    (3, '85 Llanelian Rd, Old Colwyn, Colwyn Bay, Conwy LL29 8UN, Great Bitain', 3000, 4000);

MERGE INTO RaceAreas ra
    USING (SELECT *
        FROM NEW_RaceAreas) newra
        ON (ra.RaceArea_Address = newra.RaceArea_Address)
    WHEN MATCHED THEN
        UPDATE SET ra.RaceArea_MaxNumOfGuests = newra.RaceArea_MaxNumOfGuests
        AND ra.RaceArea_Square = newra.RaceArea_Square
    WHEN NOT MATCHED THEN
        INSERT (ra.RaceArea_ID, ra.RaceArea_Address, ra.RaceArea_MaxNumOfGuests, ra.RaceArea_Square)
        VALUES (RaceArea_ID_Generator.NEXTVAL, newra.RaceArea_Address, newra.RaceArea_MaxNumOfGuests, newra.RaceArea_Square);

SELECT * FROM RaceAreas;
