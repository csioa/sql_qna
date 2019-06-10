# SQL questions, small quizzes and anwers

## Introduction

  * Setting up the schema and the tables 

### Simple and short excerices to get familiar with SQL 

  * **SELECT** statement
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

  #### For every day, see the city where the biggest transaction occured
  ```sql
  
  ```
  
  #### The total amount spent for those that have been shopping outside the United Kingdom between 12.00 and 18.00
  ```sql
  
  ```
  
  #### Average time between two transactions for each customers
  ```sql
  
  ```
  
  #### First transaction ever of each customer
  ```sql
  
  ```
  
  #### The total amount spent for each customer if they get a 5% discount for purchases over 150.0 in the UK and 12% for other countries
  ```sql
  
  ```
  
  #### Given that for UK there are 5% and 7% discounts for below and over 150.0 purchases respectively and 8% and 10% for other countries, what are the top 2 counries on discounts for customers
  ```sql
  
  ```
