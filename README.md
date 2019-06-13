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
  
  #### The total amount spent for those that have been shopping outside the United Kingdom between 12.00 and 18.00
  ```sql
  
  ```
  
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
  ```sql
  
  ```
  
  #### Given that for UK there are 5% and 7% discounts for below and over 150.0 purchases respectively and 8% and 10% for other countries, what are the top 2 counries on discounts for customers
  ```sql
  
  ```
