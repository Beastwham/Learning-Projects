-- Data Importing Script was used to import data

USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT table_name,
       table_rows
FROM   information_schema.tables
WHERE  table_schema = 'imdb'; 

/*	RESULT ->
+------------------+------------+
| TABLE_NAME       | TABLE_ROWS |
+------------------+------------+
| director_mapping |       3867 |
| genre            |      14662 |
| movie            |       8404 |
| names            |      29241 |
| ratings          |       8230 |
| role_mapping     |      16021 |
+------------------+------------+
*/

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT SUM(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           END) AS id_nulls,
       SUM(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           END) AS title_nulls,
       SUM(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           END) AS year_nulls,
       SUM(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           END) AS date_published_nulls,
       SUM(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           END) AS duration_nulls,
       SUM(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           END) AS country_nulls,
       SUM(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           END) AS worlwide_gross_income_nulls,
       SUM(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           END) AS languages_nulls,
       SUM(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           END) AS production_company_nulls
FROM   movie; 

/*	RESULT ->
+----------+-------------+------------+----------------------+----------------+---------------+-----------------------------+-----------------+--------------------------+
| id_nulls | title_nulls | year_nulls | date_published_nulls | duration_nulls | country_nulls | worlwide_gross_income_nulls | languages_nulls | production_company_nulls |
+----------+-------------+------------+----------------------+----------------+---------------+-----------------------------+-----------------+--------------------------+
|        0 |           0 |          0 |                    0 |              0 |            20 |                        3724 |             194 |                      528 |
+----------+-------------+------------+----------------------+----------------+---------------+-----------------------------+-----------------+--------------------------+
*/

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- First Part
SELECT year      AS Year,
       COUNT(id) AS number_of_movies
FROM   movie
GROUP  BY year; 

/*	RESULT ->
+------+------------------+
| Year | number_of_movies |
+------+------------------+
| 2017 |             3052 |
| 2018 |             2944 |
| 2019 |             2001 |
+------+------------------+
*/

-- Second Part
SELECT MONTH(date_published) AS month_num,
       COUNT(id)             AS number_of_movies
FROM   movie
GROUP  BY month_num
ORDER  BY month_num; 

/*	RESULT ->
+-----------+------------------+
| month_num | number_of_movies |
+-----------+------------------+
|         1 |              804 |
|         2 |              640 |
|         3 |              824 |
|         4 |              680 |
|         5 |              625 |
|         6 |              580 |
|         7 |              493 |
|         8 |              678 |
|         9 |              809 |
|        10 |              801 |
|        11 |              625 |
|        12 |              438 |
+-----------+------------------+
*/

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT COUNT(id) AS number_of_movies
FROM   movie
WHERE  ( country LIKE '%USA%'
          OR country LIKE '%India%' )
       AND year = 2019
GROUP  BY year; 

/*	RESULT ->
+------------------+
| number_of_movies |
+------------------+
|             1059 |
+------------------+
*/

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre
FROM   genre; 

/* RESULT ->
+-----------+
| genre     |
+-----------+
| Drama     |
| Fantasy   |
| Thriller  |
| Comedy    |
| Horror    |
| Family    |
| Romance   |
| Adventure |
| Action    |
| Sci-Fi    |
| Crime     |
| Mystery   |
| Others    |
+-----------+
*/

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT G.genre,
       COUNT(M.id) AS number_of_movies
FROM   movie M
       INNER JOIN genre G
               ON M.id = G.movie_id
GROUP  BY G.genre
ORDER  BY number_of_movies DESC
LIMIT  1; 

/*	RESULT ->
+-------+------------------+
| genre | number_of_movies |
+-------+------------------+
| Drama |             4285 |
+-------+------------------+
*/

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH movies_and_count_of_genre
     AS (SELECT movie_id,
                Count(genre) AS count_of_genre
         FROM   genre
         GROUP  BY movie_id)
SELECT Count(movie_id) AS movies_with_one_genre
FROM   movies_and_count_of_genre
WHERE  count_of_genre = 1; 

/*	RESULT ->
+-----------------------+
| movies_with_one_genre |
+-----------------------+
|                  3289 |
+-----------------------+
*/

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT G.genre,
       ROUND(AVG(M.duration), 2) AS avg_duration
FROM   genre G
       INNER JOIN movie M
               ON M.id = G.movie_id
GROUP  BY G.genre; 

/*	RESULT ->
+-----------+--------------+
| genre     | avg_duration |
+-----------+--------------+
| Drama     |       106.77 |
| Fantasy   |       105.14 |
| Thriller  |       101.58 |
| Comedy    |       102.62 |
| Horror    |        92.72 |
| Family    |       100.97 |
| Romance   |       109.53 |
| Adventure |       101.87 |
| Action    |       112.88 |
| Sci-Fi    |        97.94 |
| Crime     |       107.05 |
| Mystery   |       101.80 |
| Others    |       100.16 |
+-----------+--------------+
*/

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
WITH genre_movie_count
     AS (SELECT genre,
                Count(movie_id)                    AS movie_count,
                RANK()
                  OVER (
                    ORDER BY Count(movie_id) DESC) AS genre_rank
         FROM   genre
         GROUP  BY genre)
SELECT *
FROM   genre_movie_count
WHERE  genre = 'Thriller';
/* 	RESULT ->
+----------+-------------+------------+
| genre    | movie_count | genre_rank |
+----------+-------------+------------+
| Thriller |        1484 |          3 |
+----------+-------------+------------+
*/

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT MIN(avg_rating)    AS min_avg_rating,
       MAX(avg_rating)    AS max_avg_rating,
       MIN(total_votes)   AS min_total_votes,
       MAX(total_votes)   AS max_total_votes,
       MIN(median_rating) AS min_median_rating,
       MAX(median_rating) AS max_median_rating
FROM   ratings; 

/*	RESULTS ->
+----------------+----------------+-----------------+-----------------+-------------------+-------------------+
| min_avg_rating | max_avg_rating | min_total_votes | max_total_votes | min_median_rating | max_median_rating |
+----------------+----------------+-----------------+-----------------+-------------------+-------------------+
|            1.0 |           10.0 |             100 |          725138 |                 1 |                10 |
+----------------+----------------+-----------------+-----------------+-------------------+-------------------+
*/

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
WITH movie_rank
     AS (SELECT M.title,
                R.avg_rating,
                RANK()
                  OVER (
                    ORDER BY R.avg_rating DESC) AS movie_rank
         FROM   ratings R
                INNER JOIN movie M
                        ON M.id = R.movie_id)
SELECT *
FROM   movie_rank
WHERE  movie_rank <= 10; 

/*	RESULT ->
+--------------------------------+------------+------------+
| title                          | avg_rating | movie_rank |
+--------------------------------+------------+------------+
| Kirket                         |       10.0 |          1 |
| Love in Kilnerry               |       10.0 |          1 |
| Gini Helida Kathe              |        9.8 |          3 |
| Runam                          |        9.7 |          4 |
| Fan                            |        9.6 |          5 |
| Android Kunjappan Version 5.25 |        9.6 |          5 |
| Yeh Suhaagraat Impossible      |        9.5 |          7 |
| Safe                           |        9.5 |          7 |
| The Brighton Miracle           |        9.5 |          7 |
| Shibu                          |        9.4 |         10 |
| Our Little Haven               |        9.4 |         10 |
| Zana                           |        9.4 |         10 |
| Family of Thakurganj           |        9.4 |         10 |
| Ananthu V/S Nusrath            |        9.4 |         10 |
+--------------------------------+------------+------------+
*/

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
       COUNT(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY movie_count DESC;

/*	RESULTS ->
+---------------+-------------+
| median_rating | movie_count |
+---------------+-------------+
|             7 |        2257 |
|             6 |        1975 |
|             8 |        1030 |
|             5 |         985 |
|             4 |         479 |
|             9 |         429 |
|            10 |         346 |
|             3 |         283 |
|             2 |         119 |
|             1 |          94 |
+---------------+-------------+
*/

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_house_summary
     AS (SELECT M.production_company,
                Count(M.id)                    AS movie_count,
                RANK()
                  OVER (
                    ORDER BY Count(M.id) DESC) AS prod_company_rank
         FROM   movie M
                INNER JOIN ratings R
                        ON M.id = R.movie_id
         WHERE  R.avg_rating > 8
                AND M.production_company IS NOT NULL
         GROUP  BY M.production_company)
SELECT *
FROM   production_house_summary
WHERE  prod_company_rank = 1; 

/*	RESULTS ->
+------------------------+-------------+-------------------+
| production_company     | movie_count | prod_company_rank |
+------------------------+-------------+-------------------+
| Dream Warrior Pictures |           3 |                 1 |
| National Theatre Live  |           3 |                 1 |
+------------------------+-------------+-------------------+
*/

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT G.genre,
       COUNT(M.id) AS movie_count
FROM   ratings R
       INNER JOIN movie M
               ON M.id = R.movie_id
       INNER JOIN genre G
               ON G.movie_id = M.id
WHERE  M.year = 2017
       AND MONTH(M.date_published) = 3
       AND M.country LIKE '%USA%'
       AND R.total_votes > 1000
GROUP  BY G.genre
ORDER  BY movie_count DESC; 

/*	RESULT ->
+-----------+-------------+
| genre     | movie_count |
+-----------+-------------+
| Drama     |          24 |
| Comedy    |           9 |
| Action    |           8 |
| Thriller  |           8 |
| Sci-Fi    |           7 |
| Crime     |           6 |
| Horror    |           6 |
| Mystery   |           4 |
| Romance   |           4 |
| Fantasy   |           3 |
| Adventure |           3 |
| Family    |           1 |
+-----------+-------------+
*/

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT M.title,
       R.avg_rating,
       G.genre
FROM   movie M
       INNER JOIN ratings R
               ON M.id = R.movie_id
       INNER JOIN genre G
               ON M.id = G.movie_id
WHERE  M.title LIKE 'The%'
       AND R.avg_rating > 8
ORDER  BY G.genre; 

/*	RESULT ->
+--------------------------------------+------------+----------+
| title                                | avg_rating | genre    |
+--------------------------------------+------------+----------+
| Theeran Adhigaaram Ondru             |        8.3 | Action   |
| The Irishman                         |        8.7 | Crime    |
| Theeran Adhigaaram Ondru             |        8.3 | Crime    |
| The Gambinos                         |        8.4 | Crime    |
| The Blue Elephant 2                  |        8.8 | Drama    |
| The Brighton Miracle                 |        9.5 | Drama    |
| The Irishman                         |        8.7 | Drama    |
| The Colour of Darkness               |        9.1 | Drama    |
| The Mystery of Godliness: The Sequel |        8.5 | Drama    |
| The Gambinos                         |        8.4 | Drama    |
| The King and I                       |        8.2 | Drama    |
| The Blue Elephant 2                  |        8.8 | Horror   |
| The Blue Elephant 2                  |        8.8 | Mystery  |
| The King and I                       |        8.2 | Romance  |
| Theeran Adhigaaram Ondru             |        8.3 | Thriller |
+--------------------------------------+------------+----------+
*/

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT COUNT(M.id) AS movie_count
FROM   movie M
       INNER JOIN ratings R
               ON M.id = R.movie_id
WHERE  M.date_published BETWEEN '2018-04-01' AND '2019-04-01'
       AND R.median_rating = 8;

/*	RESULTS ->
+-------------+
| movie_count |
+-------------+
|         361 |
+-------------+
*/

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- Based on Country, considering movies only released in one country: either germany or italy
SELECT M.country,
       SUM(R.total_votes) AS votes
FROM   movie M
       INNER JOIN ratings R
               ON M.id = R.movie_id
WHERE  M.country IN ( 'Germany', 'Italy' )
GROUP  BY M.country; 

/*	RESULTS ->
+---------+--------+
| country | votes  |
+---------+--------+
| Germany | 106710 |
| Italy   |  77965 |
+---------+--------+
*/

-- Considering movies released in multiple countries
WITH germanvsitalian
     AS (SELECT R.total_votes,
                M.country,
                CASE
                  WHEN M.country LIKE '%Germany%' THEN 1
                  ELSE 0
                END AS Released_in_Germany,
                CASE
                  WHEN M.country LIKE '%Italy%' THEN 1
                  ELSE 0
                END AS Released_in_Italy
         FROM   movie M
                INNER JOIN ratings R
                        ON M.id = R.movie_id) SELECT
'Germany'        		AS "Country",
       Sum(total_votes) AS votes
FROM   germanvsitalian
WHERE  released_in_germany = 1
UNION
SELECT 'Italy'          AS "Country",
       Sum(total_votes) AS votes
FROM   germanvsitalian
WHERE  released_in_italy = 1; 

/*	RESULTS ->
+---------+---------+
| Country | votes   |
+---------+---------+
| Germany | 2026223 |
| Italy   | 703024  |
+---------+---------+
*/

-- Based On Languages
SELECT M.languages,
       Sum(R.total_votes) AS votes
FROM   movie M
       INNER JOIN ratings R
               ON R.movie_id = M.id
WHERE  M.languages LIKE '%Italian%'
UNION
SELECT M.languages,
       Sum(total_votes)   AS votes
FROM   movie M
       INNER JOIN ratings R
               ON R.movie_id = M.id
WHERE  M.languages LIKE '%GERMAN%'
ORDER  BY votes DESC;

/*	RESULT ->
+------------+---------+
| languages  | votes   |
+------------+---------+
| German     | 4421525 |
| Italian    | 2559540 |
+------------+---------+
*/

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/


-- Segment 3:


-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT SUM(CASE
             WHEN name IS NULL THEN 1
             ELSE 0
           END) AS name_nulls,
       SUM(CASE
             WHEN height IS NULL THEN 1
             ELSE 0
           END) AS height_nulls,
       SUM(CASE
             WHEN date_of_birth IS NULL THEN 1
             ELSE 0
           END) AS date_of_birth_nulls,
       SUM(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
           END) AS known_for_movies_nulls
FROM   names; 

/*	RESULT ->
+------------+--------------+---------------------+------------------------+
| name_nulls | height_nulls | date_of_birth_nulls | known_for_movies_nulls |
+------------+--------------+---------------------+------------------------+
|          0 |        17335 |               13431 |                  15226 |
+------------+--------------+---------------------+------------------------+
*/

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top3genres
AS
  (
             SELECT     G.genre,
                        count(M.id) AS movie_count
             FROM       movie M
             INNER JOIN genre G
             ON         M.id = G.movie_id
             INNER JOIN ratings R
             ON         R.movie_id = m.id
             WHERE      R.avg_rating > 8
             GROUP BY   G.genre
             ORDER BY   movie_count DESC
             LIMIT      3)
  SELECT     N.name      AS director_name,
             count(M.id) AS movie_count
  FROM       names N
  INNER JOIN director_mapping D
  ON         D.name_id = N.id
  INNER JOIN movie M
  ON         M.id = D.movie_id
  INNER JOIN genre G
  ON         G.movie_id = M.id
  INNER JOIN ratings R
  ON         R.movie_id = M.id
  INNER JOIN top3genres T3
  ON         T3.genre = G.genre
  WHERE      R.avg_rating > 8
  GROUP BY   director_name
  ORDER BY   movie_count DESC
  LIMIT      5;

/*	RESULTS ->
Top 3 Genres -> 
+--------+-------------+
| genre  | movie_count |
+--------+-------------+
| Drama  |         175 |
| Action |          46 |
| Comedy |          44 |
+--------+-------------+

Top 5 Directors ->
+---------------+-------------+
| director_name | movie_count |
+---------------+-------------+
| James Mangold |           4 |
| Anthony Russo |           3 |
| Soubin Shahir |           3 |
| Joe Russo     |           3 |
| Manoj K. Jha  |           2 |
+---------------+-------------+

Top 5 have been considered because there's a tie between 2nd, 3rd and 4th position
This considers movies having avg_rating > 8
*/

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT N.name            AS actor_name,
       COUNT(R.movie_id) AS movie_count
FROM   ratings AS R
       INNER JOIN role_mapping AS RM
               ON RM.movie_id = R.movie_id
       INNER JOIN names AS N
               ON RM.name_id = N.id
WHERE  R.median_rating >= 8
       AND RM.category = 'actor'
GROUP  BY N.name
ORDER  BY movie_count DESC
LIMIT  2;  

/*	RESULTS ->
+------------+-------------+
| actor_name | movie_count |
+------------+-------------+
| Mammootty  |           8 |
| Mohanlal   |           5 |
+------------+-------------+
*/

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT     M.production_company,
           SUM(R.total_votes)                             AS vote_count,
           RANK() over (ORDER BY sum(R.total_votes) DESC) AS prod_comp_rank
FROM       movie M
INNER JOIN ratings R
ON         M.id = R.movie_id
GROUP BY   M.production_company
LIMIT      3;

/*	RESULTS->
+-----------------------+------------+----------------+
| production_company    | vote_count | prod_comp_rank |
+-----------------------+------------+----------------+
| Marvel Studios        |    2656967 |              1 |
| Twentieth Century Fox |    2411163 |              2 |
| Warner Bros.          |    2396057 |              3 |
+-----------------------+------------+----------------+
*/

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actor_summary
     AS (SELECT N.NAME
                AS
                actor_name,
                Sum(R.total_votes)
                AS
                   total_votes,
                Count(M.id)
                AS
                   movie_count,
                Round(Sum(R.avg_rating * R.total_votes) / Sum(R.total_votes), 2)
                AS
                actor_avg_rating
         FROM   names N
                INNER JOIN role_mapping RM
                        ON RM.name_id = N.id
                INNER JOIN movie M
                        ON M.id = RM.movie_id
                INNER JOIN ratings R
                        ON R.movie_id = M.id
         WHERE  RM.category = 'actor'
                AND M.country = 'India'
         GROUP  BY actor_name)
SELECT actor_name,
       total_votes,
       movie_count,
       actor_avg_rating,
       RANK()
         OVER (
           ORDER BY actor_avg_rating DESC) AS actor_rank
FROM   actor_summary
WHERE  movie_count >= 5; 

/*	RESULTS ->
+--------------------+-------------+-------------+------------------+------------+
| actor_name         | total_votes | movie_count | actor_avg_rating | actor_rank |
+--------------------+-------------+-------------+------------------+------------+
| Vijay Sethupathi   |       23114 |           5 |             8.42 |          1 |
| Fahadh Faasil      |       13557 |           5 |             7.99 |          2 |
| Yogi Babu          |        8500 |          11 |             7.83 |          3 |
| Joju George        |        3926 |           5 |             7.58 |          4 |
| Ammy Virk          |        2504 |           6 |             7.55 |          5 |
| Dileesh Pothan     |        6235 |           5 |             7.52 |          6 |
| Kunchacko Boban    |        5628 |           6 |             7.48 |          7 |
| Pankaj Tripathi    |       40728 |           5 |             7.44 |          8 |
| Rajkummar Rao      |       42560 |           6 |             7.37 |          9 |
| Dulquer Salmaan    |       17666 |           5 |             7.30 |         10 |
| Amit Sadh          |       13355 |           5 |             7.21 |         11 |
| Tovino Thomas      |       11596 |           8 |             7.15 |         12 |
| Mammootty          |       12613 |           8 |             7.04 |         13 |
| Nassar             |        4016 |           5 |             7.03 |         14 |
| Karamjit Anmol     |        1970 |           6 |             6.91 |         15 |
| Hareesh Kanaran    |        3196 |           5 |             6.58 |         16 |
| Naseeruddin Shah   |       12604 |           5 |             6.54 |         17 |
| Anandraj           |        2750 |           6 |             6.54 |         17 |
| Mohanlal           |       17244 |           6 |             6.51 |         19 |
| Siddique           |        5953 |           7 |             6.43 |         20 |
| Aju Varghese       |        2237 |           5 |             6.43 |         20 |
| Prakash Raj        |        8548 |           6 |             6.37 |         22 |
| Jimmy Sheirgill    |        3826 |           6 |             6.29 |         23 |
| Mahesh Achanta     |        2716 |           6 |             6.21 |         24 |
| Biju Menon         |        1916 |           5 |             6.21 |         24 |
| Suraj Venjaramoodu |        4284 |           6 |             6.19 |         26 |
| Abir Chatterjee    |        1413 |           5 |             5.80 |         27 |
| Sunny Deol         |        4594 |           5 |             5.71 |         28 |
| Radha Ravi         |        1483 |           5 |             5.70 |         29 |
| Prabhu Deva        |        2044 |           5 |             5.68 |         30 |
+--------------------+-------------+-------------+------------------+------------+
*/

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_summary
AS
  (
             SELECT     N.name                                                         AS actress_name,
                        sum(R.total_votes)                                             AS total_votes,
                        count(M.id)                                                    AS movie_count,
                        round(sum(R.avg_rating * R.total_votes)/sum(R.total_votes), 2) AS actress_avg_rating
             FROM       names N
             INNER JOIN role_mapping RM
             ON         RM.name_id = N.id
             INNER JOIN movie M
             ON         M.id = RM.movie_id
             INNER JOIN ratings R
             ON         R.movie_id = M.id
             WHERE      RM.category = 'actress'
             AND        M.country = 'India'
             AND        M.languages LIKE '%Hindi%'
             GROUP BY   actress_name)
  SELECT   actress_name,
           total_votes,
           movie_count,
           actress_avg_rating,
           rank() over (ORDER BY actress_avg_rating DESC) AS actress_rank
  FROM     actress_summary
  WHERE    movie_count >= 3
  LIMIT    5;

/*	RESULTS ->
+-----------------+-------------+-------------+--------------------+--------------+
| actress_name    | total_votes | movie_count | actress_avg_rating | actress_rank |
+-----------------+-------------+-------------+--------------------+--------------+
| Taapsee Pannu   |       18061 |           3 |               7.74 |            1 |
| Kriti Sanon     |       21967 |           3 |               7.05 |            2 |
| Divya Dutta     |        8579 |           3 |               6.88 |            3 |
| Shraddha Kapoor |       26779 |           3 |               6.63 |            4 |
| Kriti Kharbanda |        2549 |           3 |               4.80 |            5 |
+-----------------+-------------+-------------+--------------------+--------------+
*/

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/

/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT M.title,
       R.avg_rating,
       CASE
         WHEN R.avg_rating > 8 THEN 'Superhit movies'
         WHEN R.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN R.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         ELSE 'Flop movies'
       END AS category
FROM   movie M
       INNER JOIN genre G
               ON M.id = G.movie_id
       INNER JOIN ratings R
               ON R.movie_id = M.id
WHERE  G.genre = 'thriller'; 

/* 	RESULT -> (LIMIT 5)
+----------------+------------+-----------------------+
| title          | avg_rating | category   			  |
+----------------+------------+-----------------------+
| Der müde Tod   |        7.7 | Hit movies            |
| Fahrenheit 451 |        4.9 | Flop movies           |
| Pet Sematary   |        5.8 | One-time-watch movies |
| Dukun          |        6.9 | One-time-watch movies |
| Back Roads     |        7.0 | Hit movies            |
+----------------+------------+-----------------------+
*/

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT G.genre,
       ROUND(AVG(M.duration), 2)                         AS avg_duration,
       SUM(ROUND(AVG(M.duration), 2))
         OVER (
           ORDER BY G.genre ROWS unbounded preceding)    AS
       running_total_duration,
       ROUND(AVG(AVG(M.duration))
               OVER (
                 ORDER BY G.genre ROWS 10 preceding), 2) AS moving_avg_duration
FROM   movie M
       inner join genre G
               ON M.id = G.movie_id
GROUP  BY G.genre
ORDER  BY G.genre; 

/*	RESULTS->
+-----------+--------------+------------------------+---------------------+
| genre     | avg_duration | running_total_duration | moving_avg_duration |
+-----------+--------------+------------------------+---------------------+
| Action    |       112.88 |                 112.88 |              112.88 |
| Adventure |       101.87 |                 214.75 |              107.38 |
| Comedy    |       102.62 |                 317.37 |              105.79 |
| Crime     |       107.05 |                 424.42 |              106.11 |
| Drama     |       106.77 |                 531.19 |              106.24 |
| Family    |       100.97 |                 632.16 |              105.36 |
| Fantasy   |       105.14 |                 737.30 |              105.33 |
| Horror    |        92.72 |                 830.02 |              103.75 |
| Mystery   |       101.80 |                 931.82 |              103.54 |
| Others    |       100.16 |                1031.98 |              103.20 |
| Romance   |       109.53 |                1141.51 |              103.78 |
| Sci-Fi    |        97.94 |                1239.45 |              102.42 |
| Thriller  |       101.58 |                1341.03 |              102.39 |
+-----------+--------------+------------------------+---------------------+
*/

-- Round is good to have and not a must have; Same thing applies to sorting

-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH income_movie_summary
AS
  (
  WITH top3genres
AS
  (
           SELECT   genre,
                    count(movie_id)
           FROM     genre
           GROUP BY genre
           ORDER BY count(movie_id) DESC
           LIMIT    3 )
  SELECT     G.genre,
             M.year,
             M.title                                                                       AS movie_name,
             M.worlwide_gross_income                                                       AS worldwide_gross_income,
             dense_rank() over (partition BY m.year ORDER BY m.worlwide_gross_income DESC) AS movie_rank
  FROM       movie M
  INNER JOIN genre G
  ON         M.id = G.movie_id
  INNER JOIN top3genres T3
  ON         T3.genre = G.genre )
SELECT   *
FROM     income_movie_summary
WHERE    movie_rank <=3
ORDER BY year,
         movie_rank;

/* RESULTS -> TOP 3 GENRES
+----------+-----------------+
| genre    | count(movie_id) |
+----------+-----------------+
| Drama    |            4285 |
| Comedy   |            2412 |
| Thriller |            1484 |
+----------+-----------------+

+----------+------+----------------------------+------------------------+------------+
| genre    | year | movie_name                 | worldwide_gross_income | movie_rank |
+----------+------+----------------------------+------------------------+------------+
| Drama    | 2017 | Shatamanam Bhavati         | INR 530500000          |          1 |
| Drama    | 2017 | Winner                     | INR 250000000          |          2 |
| Drama    | 2017 | Thank You for Your Service | $ 9995692              |          3 |
| Thriller | 2018 | The Villain                | INR 1300000000         |          1 |
| Drama    | 2018 | Antony & Cleopatra         | $ 998079               |          2 |
| Comedy   | 2018 | La fuitina sbagliata       | $ 992070               |          3 |
| Thriller | 2019 | Prescience                 | $ 9956                 |          1 |
| Thriller | 2019 | Joker                      | $ 995064593            |          2 |
| Drama    | 2019 | Joker                      | $ 995064593            |          2 |
| Comedy   | 2019 | Eaten by Lions             | $ 99276                |          3 |
+----------+------+----------------------------+------------------------+------------+
*/

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT     M.production_company,
           COUNT(M.id)                            AS movie_count,
           RANK() over(ORDER BY count(M.id) DESC) AS prod_comp_rank
FROM       movie M
INNER JOIN ratings R
ON         M.id=R.movie_id
WHERE      R.median_rating >= 8
AND        M.production_company IS NOT NULL
AND        position(',' IN M.languages)>0
GROUP BY   M.production_company
LIMIT      2;

/*	RESULT ->
+-----------------------+-------------+----------------+
| production_company    | movie_count | prod_comp_rank |
+-----------------------+-------------+----------------+
| Star Cinema           |           7 |              1 |
| Twentieth Century Fox |           4 |              2 |
+-----------------------+-------------+----------------+
*/

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language

-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

/* Weighted Average, similar in previous questions, has been calculated for actress_avg_rating.
Although it isn't mentioned explicitly, we asked Mr. Akash Makkar during the assignment live session.
He mentioned we should be calculating weighted average instead of taking an average of avg_rating
*/

WITH actress_hit_movies
AS
  (
             SELECT     N.name                                                         AS actress_name,
                        sum(R.total_votes)                                             AS total_votes,
                        count(M.id)                                                    AS movie_count,
                        round(sum(R.avg_rating * R.total_votes)/sum(R.total_votes), 2) AS actress_avg_rating
             FROM       movie M
             INNER JOIN ratings R
             ON         M.id = R.movie_id
             INNER JOIN role_mapping rm
             ON         M.id = RM.movie_id
             INNER JOIN names N
             ON         N.id = RM.name_id
             INNER JOIN genre G
             ON         G.movie_id = M.id
             WHERE      RM.category = 'actress'
             AND        R.avg_rating > 8
             AND        G.genre = 'Drama'
             GROUP BY   actress_name
             ORDER BY   movie_count DESC)
  SELECT   *,
           rank() over (ORDER BY movie_count DESC)AS actress_rank
  FROM     actress_hit_movies
  LIMIT    3;

/*	RESULT ->
+---------------------+-------------+-------------+--------------------+--------------+
| actress_name        | total_votes | movie_count | actress_avg_rating | actress_rank |
+---------------------+-------------+-------------+--------------------+--------------+
| Parvathy Thiruvothu |        4974 |           2 |               8.25 |            1 |
| Susan Brown         |         656 |           2 |               8.94 |            1 |
| Amanda Lawrence     |         656 |           2 |               8.94 |            1 |
+---------------------+-------------+-------------+--------------------+--------------+
*/

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH movie_date
AS
  (
           SELECT   D.name_id,
                    N.name,
                    D.movie_id,
                    M.date_published,
                    lead(M.date_published, 1) over(partition BY D.name_id ORDER BY M.date_published, D.movie_id) AS next_movie_date
           FROM     director_mapping D
           JOIN     names AS N
           ON       D.name_id=N.id
           JOIN     movie AS M
           ON       D.movie_id=M.id ),
  date_diff
AS
  (
         SELECT *,
                datediff(next_movie_date, date_published) AS diff
         FROM   movie_date ),
  avg_inter_days
AS
  (
           SELECT   name_id,
                    avg(diff) AS avg_inter_movie_days
           FROM     date_diff
           GROUP BY name_id )
  SELECT   D.name_id                     AS director_id,
           N.name                        AS director_name,
           count(D.movie_id)             AS number_of_movies,
           round(A.avg_inter_movie_days) AS avg_inter_movie_days,
           round(avg(R.avg_rating),2)    AS avg_rating,
           sum(R.total_votes)            AS total_votes,
           min(R.avg_rating)             AS min_rating,
           max(R.avg_rating)             AS max_rating,
           sum(M.duration)               AS total_duration
  FROM     names N
  JOIN     director_mapping D
  ON       N.id=D.name_id
  JOIN     ratings R
  ON       D.movie_id=R.movie_id
  JOIN     movie M
  ON       M.id=R.movie_id
  JOIN     avg_inter_days AS A
  ON       A.name_id=D.name_id
  GROUP BY director_id
  ORDER BY count(D.movie_id) DESC
  LIMIT    9 ;

/*	RESULT ->
+-------------+-------------------+------------------+----------------------+------------+-------------+------------+------------+----------------+
| director_id | director_name     | number_of_movies | avg_inter_movie_days | avg_rating | total_votes | min_rating | max_rating | total_duration |
+-------------+-------------------+------------------+----------------------+------------+-------------+------------+------------+----------------+
| nm1777967   | A.L. Vijay        |                5 |                  177 |       5.42 |        1754 |        3.7 |        6.9 |            613 |
| nm2096009   | Andrew Jones      |                5 |                  191 |       3.02 |        1989 |        2.7 |        3.2 |            432 |
| nm0831321   | Chris Stokes      |                4 |                  198 |       4.33 |        3664 |        4.0 |        4.6 |            352 |
| nm2691863   | Justin Price      |                4 |                  315 |       4.50 |        5343 |        3.0 |        5.8 |            346 |
| nm0425364   | Jesse V. Johnson  |                4 |                  299 |       5.45 |       14778 |        4.2 |        6.5 |            383 |
| nm0001752   | Steven Soderbergh |                4 |                  254 |       6.48 |      171684 |        6.2 |        7.0 |            401 |
| nm0814469   | Sion Sono         |                4 |                  331 |       6.03 |        2972 |        5.4 |        6.4 |            502 |
| nm6356309   | Özgür Bakar       |                4 |                  112 |       3.75 |        1092 |        3.1 |        4.9 |            374 |
| nm0515005   | Sam Liu           |                4 |                  260 |       6.23 |       28557 |        5.8 |        6.7 |            312 |
+-------------+-------------------+------------------+----------------------+------------+-------------+------------+------------+----------------+
*/



