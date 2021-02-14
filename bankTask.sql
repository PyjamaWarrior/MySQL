# 1. Вибрати усіх клієнтів, чиє ім`я має менше ніж 6 символів.
SELECT * FROM client WHERE LENGTH(FirstName) < 6;

# 2. Вибрати львівські відділення банку.
SELECT * FROM department WHERE DepartmentCity = 'Lviv';

# 3. Вибрати клієнтів з вищою освітою та посортувати по прізвищу.
SELECT * FROM client WHERE Education = 'high' ORDER BY LastName;

# 4. Виконати сортування у зворотньому порядку над таблицею Заявка і вивести 5 останніх елементів.
SELECT * FROM application ORDER BY idApplication DESC LIMIT 5 OFFSET 10;

# 5. Вивести усіх клієнтів, чиє прізвище закінчується на IV чи IVA.
SELECT * FROM client WHERE LastName LIKE '%IV' OR LastName LIKE '%IVA';

# 6. Вивести клієнтів банку, які обслуговуються київськими відділеннями.
SELECT * FROM client WHERE Department_idDepartment IN (1, 4);

# 7. Вивести імена клієнтів та їхні номера паспортів, погрупувавши їх за іменами.
SELECT FirstName, Passport FROM client GROUP BY FirstName;

# 8. Вивести дані про клієнтів, які мають кредит більше ніж на 5000 тисяч гривень.
SELECT * FROM client
    JOIN application a ON client.idClient = a.Client_idClient
    WHERE CreditState = 'Not returned' AND Sum > 5000 AND Currency = 'Gryvnia';

# 9. Порахувати кількість клієнтів усіх відділень та лише львівських відділень.
SELECT COUNT(idClient) AS Count FROM client;

SELECT COUNT(idClient) AS Count FROM client WHERE Department_idDepartment IN (2, 5);

# 10. Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.
SELECT Client_idClient, MAX(Sum) AS MaxSum FROM application GROUP BY Client_idClient;

# 11. Визначити кількість заявок на крдеит для кожного клієнта.
SELECT Client_idClient, COUNT(Client_idClient) AS Count FROM application GROUP BY Client_idClient;

SELECT idClient, FirstName, LastName, COUNT(Client_idClient) AS Count FROM application
    JOIN client c on c.idClient = application.Client_idClient
    GROUP BY Client_idClient;

# 12. Визначити найбільший та найменший кредити.
SELECT MAX(Sum) AS MaxCredit, MIN(Sum) AS MinCredit FROM application;

# 13. Порахувати кількість кредитів для клієнтів,які мають вищу освіту.
SELECT FirstName, LastName, Education, COUNT(Client_idClient) AS TotalCredits FROM application
    JOIN client c on c.idClient = application.Client_idClient
    WHERE Education = 'High' GROUP BY idClient;

# 14. Вивести дані про клієнта, в якого середня сума кредитів найвища.
SELECT idClient, FirstName, LastName, AVG(Sum) AS AvgSum FROM application
    JOIN client c on c.idClient = application.Client_idClient
    GROUP BY idClient ORDER BY AvgSum DESC LIMIT 1;

# 15. Вивести відділення, яке видало в кредити найбільше грошей
SELECT Department_idDepartment, SUM(Sum) AS Sum FROM application
    JOIN client c on c.idClient = application.Client_idClient
    GROUP BY Department_idDepartment ORDER BY Sum DESC LIMIT 1;

# 16. Вивести відділення, яке видало найбільший кредит.
SELECT Department_idDepartment, MAX(Sum) MaxSum FROM application
    JOIN client c on c.idClient = application.Client_idClient
    GROUP BY Department_idDepartment ORDER BY MaxSum DESC LIMIT 1;

# 17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.
UPDATE application
    JOIN client c on c.idClient = application.Client_idClient
    SET Sum = 6000, Currency = 'Gryvnia' WHERE Education = 'High';

# 18. Усіх клієнтів київських відділень пересилити до Києва.
UPDATE client SET City = 'Kyiv' WHERE Department_idDepartment IN (1, 4);

# 19. Видалити усі кредити, які є повернені.
DELETE FROM application WHERE CreditState = 'Returned';

# 20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.
DELETE a FROM application a
    JOIN client c on c.idClient = a.Client_idClient
    WHERE LastName LIKE '_A%' OR
          LastName LIKE '_E%' OR
          LastName LIKE '_I%' OR
          LastName LIKE '_O%' OR
          LastName LIKE '_Y%' OR
          LastName LIKE '_U%';

DELETE FROM application WHERE Client_idClient
    IN (SELECT idClient from client WHERE REGEXP_LIKE(LastName, '^.[aeyuio].*$'));

# Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000
SELECT Department_idDepartment, SUM(Sum) AS Sum FROM application
    JOIN client c on c.idClient = application.Client_idClient
    WHERE Department_idDepartment IN (2, 5) AND Sum > 5000 GROUP BY Department_idDepartment;

# Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000
SELECT * FROM client JOIN application a on client.idClient = a.Client_idClient
    WHERE CreditState = 'Returned' AND Sum > 5000;

# /* Знайти максимальний неповернений кредит.*/
SELECT MAX(Sum) AS Max FROM application WHERE CreditState = 'Not returned';

# /*Знайти клієнта, сума кредиту якого найменша*/
SELECT Client_idClient, MIN(Sum) AS Sum FROM application; # клієнт з найменшим кредитом

SELECT Client_idClient, SUM(Sum) AS Sum
    FROM application GROUP BY Client_idClient ORDER BY Sum LIMIT 1; # клієнт з найменшою сумою кредитів

# /*Знайти кредити, сума яких більша за середнє значення усіх кредитів*/
SELECT idApplication, Sum, CreditState FROM application
    WHERE Sum > (SELECT AVG(Sum) FROM application);

# /*Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів*/
SELECT * FROM client WHERE City = (
    SELECT City FROM application
    JOIN client c on Client_idClient = c.idClient
    GROUP BY Client_idClient ORDER BY COUNT(idApplication) DESC LIMIT 1
);

# місто чувака який набрав найбільше кредитів
SELECT Client_idClient, City, COUNT(Client_idClient) AS Count FROM application
    JOIN client c on c.idClient = application.Client_idClient
    GROUP BY Client_idClient ORDER BY Count DESC LIMIT 1;
