# SQL questions, small quizzes and anwers

## Introduction

  * Setting up the schema and the tables (schema.sql)

### Getting familiar with SQL 

  * **SELECT**
 
   ```sql
   -- see all customers and their information in the database

   SELECT * from customer;
   ```
  * **WHERE**
  
  ```sql
  -- see all the stores located in the United Kingdom and their information
  
  SELECT * from store where country = "United Kingdom";
  ```
  
  * **JOINS**
  
  ```sql
  -- see all the transactions of customer 5 (Nick Young)
  
  SELECT t.* 
  FROM customer c 
  INNER JOIN transaction t
  ON c.customerId = t.customerId
  WHERE c.customerId = 5;
  ```
  
  * **GROUP BY**
  
  ```sql
  -- see how much every customer has spent
  
  SELECT c.customerId, c.firstName, c.lastName, ROUND(SUM(t.amount),2) AS totalAmountSpent
  FROM customer c
  LEFT JOIN transaction t
  ON c.customerId = t.customerId
  GROUP BY c.customerId, c.firstName, c.lastName; 
  ```
  
  * **HAVING**
  
  ```sql
  -- see ony the name of those that have spent more than 150 ordered by how much they've spent 
  
  SELECT c.customerId, c.firstName, c.lastName, ROUND(SUM(t.amount),2) AS totalAmountSpent
  FROM customer c
  LEFT JOIN transaction t
  ON c.customerId = t.customerId
  GROUP BY 1,2,3
  HAVING SUM(t.amount) > 150.0
  ORDER BY 4 DESC;
  ```
  
## Getting familiar with the example tables

### Customer table

| customerId | firstName | lastName  |
|------------|-----------|-----------|
| 1          | Mary      | Jones     |
| 2          | Paul      | Griffins  |
| 3          | Joel      | Dixon     |
| 4          | Mark      | Gallagher |
| 5          | Nick      | Young     |
| 6          | Helen     | Gray      |
| 7          | Natasha   | May       |
| 8          | Nicole    | White     |
| 9          | Matthew   | Brown     |
| 10         | Barry     | Plant     |

### Store table

| storeId | city       | country        |
|---------|------------|----------------|
| 1       | London     | United Kingdom |
| 2       | Leeds      | United Kingdom |
| 3       | Dublin     | Ireland        |
| 4       | Copenhagen | Denmark        |
| 5       | Stockholm  | Sweden         |

### Transaction table

| transactionId | storeId | customerId | transactionTimestamp | amount |
|---------------|---------|------------|----------------------|--------|
| 1             | 1       | 1          | 1559722518           | 21     |
| 2             | 1       | 1          | 1559682318           | 123.5  |
| 3             | 1       | 2          | 1560105858           | 88.1   |
| 4             | 1       | 2          | 1559515458           | 34.56  |
| 5             | 1       | 3          | 1560030258           | 26.78  |
| 6             | 1       | 3          | 1559935998           | 48.9   |
| 7             | 1       | 3          | 1559930478           | 75.9   |
| 8             | 2       | 4          | 1559565798           | 55.4   |
| 9             | 2       | 4          | 1560012258           | 90.4   |
| 10            | 2       | 4          | 1560081318           | 39.04  |
| 11            | 3       | 4          | 1559655858           | 102.54 |
| 12            | 3       | 4          | 1559924538           | 26.9   |
| 13            | 3       | 5          | 1559596278           | 55.29  |
| 14            | 3       | 5          | 1559751738           | 97.9   |
| 15            | 4       | 6          | 1559936718           | 15.65  |
| 16            | 4       | 7          | 1560133338           | 9.2    |
| 17            | 4       | 7          | 1559989338           | 85.89  |
| 18            | 4       | 7          | 1559715018           | 100.22 |
| 19            | 4       | 7          | 1560093018           | 43.21  |
| 20            | 4       | 8          | 1560081318           | 65.89  |
| 21            | 5       | 8          | 1560070818           | 67.98  |
| 22            | 5       | 9          | 1560192318           | 14.56  |
| 23            | 5       | 10         | 1559559618           | 160.55 |
| 24            | 5       | 10         | 1559563938           | 98.54  |
| 25            | 5       | 10         | 1559743218           | 86.54  |
| 26            | 5       | 10         | 1559744538           | 43.4   |
| 27            | 5       | 10         | 1559931738           | 54.4   |
| 28            | 5       | 10         | 1560105198           | 69.99  |
| 29            | 5       | 10         | 1560192858           | 115.45 |

## More advanced questions and answers

  #### For every day, see the store (city, country) where the biggest transaction occured
  <details>
  <summary>Click to see the solution</summary>
  
  ```sql
  SELECT FROM_UNIXTIME(r.transactionTimestamp, '%Y-%m-%d') as date, 
  s.storeId, 
  s.city, 
  s.country,
  r.amount  
  FROM (
     SELECT  
     *,
     ROW_NUMBER() OVER(PARTITION BY FROM_UNIXTIME(transactionTimestamp, '%Y-%m-%d') ORDER BY amount) rn 
     FROM transaction t) r 
  LEFT JOIN store s
  ON s.storeId = r.storeId
  WHERE r.rn = 1
  ORDER BY 1
  ```
  
  </details>
  
  #### The total amount spent per country for those that have been shopping outside the United Kingdom between 12.00 and 18.00
  <details>
  <summary>Click to see the solution</summary>
  
  ```sql
  SELECT s.country, ROUND(SUM(amount),2) as total_amount 
  FROM transaction t 
  LEFT JOIN store s 
  ON t.storeId = s.storeId 
  WHERE s.country <> "United Kingdom" 
  AND TIME(from_unixtime(t.transactionTimestamp)) BETWEEN TIME("12:00:00") AND TIME("18:00:00")
  GROUP BY 1;
  ```
  
  </details>
  
  #### Average time between two consecutive transactions for each customers
  <details>
  <summary>Click to see the solution</summary>
  
  ```sql
  SELECT a.customerId, ROUND(AVG(a.td),2) AS average_difference_hours 
  FROM (
    SELECT 
    customerId, 
    (transactionTimestamp - LAG(transactionTimestamp) OVER(PARTITION BY customerId ORDER BY transactionTimestamp))/3600 AS td 
    FROM transaction) a
  LEFT JOIN customer c
  ON a.customerId = c.customerId
  WHERE a.td IS NOT NULL
  GROUP BY 1
  ```
  
  </details>
  
  #### First transaction ever of each customer
  <details>
  <summary>Click to see the solution</summary>
 
  ```sql
  SELECT 
  FROM_UNIXTIME(t.transactionTimestamp) as timestamp,
  c.firstName, 
  c.lastName,
  t.amount
  FROM (
    SELECT 
    distinct customerId,
    FIRST_VALUE(transactionId) OVER (PARTITION BY customerID ORDER BY transactionTimestamp) AS ftId
   FROM transaction) f
  LEFT JOIN transaction t
  ON t.transactionId = f.ftId
  LEFT JOIN customer c
  ON c.customerId = f.customerId
  ORDER BY 1
  ```
  
  </details>
  
  #### The total amount spent for each customer if they get a 5% discount for purchases over 150.0 in the UK and 12% for other countries
  <details>
  <summary>Click to see the solution</summary>
  
  ```sql
  SELECT t.customerId, c.firstName, c.lastName,
  ROUND(SUM(CASE 
    WHEN s.country = "United Kingdom" AND t.amount > 150.0 THEN t.amount * 0.95
    WHEN s.country <> "United Kingdom" AND t.amount > 150.0 THEN t.amount * 0.88
    ELSE t.amount
  END),2) as total_amount_with_discount
  FROM transaction t
  LEFT JOIN store s
  ON t.storeId = s.storeId
  LEFT JOIN customer c
  ON t.customerId = c.customerId
  GROUP BY 1,2,3;
  ```
  </details> 
  
  #### Given that for UK there are 5% and 7% discounts for below and over 150.0 purchases respectively and 8% and 10% for other countries, what are the top 2 counries on discounts for customers
  <details>
  <summary>Click to see the solution</summary>
 
  ```sql
  SELECT s.storeId, s.city, s.country,
  ROUND(SUM(CASE 
    WHEN s.country = "United Kingdom" AND t.amount > 150.0 THEN t.amount * 0.07
    WHEN s.country <> "United Kingdom" AND t.amount > 150.0 THEN t.amount * 0.1
    WHEN s.country = "United Kingdom" AND t.amount <= 150.0 THEN t.amount * 0.05
    WHEN s.country <> "United Kingdom" AND t.amount <= 150.0 THEN t.amount * 0.08
  END),2) as total_discounted_amount
  FROM transaction t
  LEFT JOIN store s
  ON t.storeId = s.storeId
  GROUP BY 1,2,3
  ORDER BY 4 DESC
  LIMIT 2;
  ```
  </details> 
