USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- checking table in dataset
show tables;

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:


SELECT COUNT(*) FROM DIRECTOR_MAPPING;
-- Number of rows = 3867

SELECT COUNT(*) FROM GENRE;
-- Number of rows = 14662

SELECT COUNT(*) FROM  MOVIE;
-- Number of rows = 7997

SELECT COUNT(*) FROM  NAMES;
-- Number of rows = 25735

SELECT COUNT(*) FROM  RATINGS;
-- Number of rows = 7997

SELECT COUNT(*) FROM  ROLE_MAPPING; 
-- Number of rows = 15615

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT Sum(CASE
             WHEN Id IS NULL THEN 1
             ELSE 0
           END) AS id_null_count,
       Sum(CASE
             WHEN Title IS NULL THEN 1
             ELSE 0
           END) AS title_null_count,
       Sum(CASE
             WHEN 'year' IS NULL THEN 1
             ELSE 0
           END) AS year_null_count,
       Sum(CASE
             WHEN Date_published IS NULL THEN 1
             ELSE 0
           END) AS date_published_null_count,
       Sum(CASE
             WHEN Duration IS NULL THEN 1
             ELSE 0
           END) AS duration_null_count,
       Sum(CASE
             WHEN Country IS NULL THEN 1
             ELSE 0
           END) AS country_null_count,
       Sum(CASE
             WHEN Worlwide_gross_income IS NULL THEN 1
             ELSE 0
           END) AS worlwide_gross_income_null_count,
       Sum(CASE
             WHEN Languages IS NULL THEN 1
             ELSE 0
           END) AS languages_null_count,
       Sum(CASE
             WHEN Production_company IS NULL THEN 1
             ELSE 0
           END) AS production_company_null_count
FROM   Movie; 

-- country, worlwide_gross_income, languages, and production_company colums are having null values

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

SELECT Year,
       Count(Id) AS number_of_movies
FROM   Movie
GROUP  BY Year; 

-- Number of movies year wise.
-- 2017	= 3052
-- 2018	= 2944
-- 2019	= 2001


SELECT Month(Date_published) AS month_num,
       Count(Id)             AS num_of_movies
FROM   Movie
GROUP  BY Month_num
ORDER  BY Month_num; 

-- number of movies in month wise
-- 1	804
-- 2	640
-- 3	824
-- 4	680
-- 5	625
-- 6	580
-- 7	493
-- 8	678
-- 9	809
-- 10	801
-- 11	625
-- 12	438

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT Count(DISTINCT Id) AS number_of_movies
FROM   Movie
WHERE  Country REGEXP 'usa|india'
       AND Year = 2019; 

-- 1059 movies were produced in the USA or India in the year 2019

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT Genre
FROM   Genre
GROUP  BY Genre
ORDER  BY Genre; 


-- Type of genre are Action Adventure, Comedy, Crime, Drama, Family, Fantasy, Horror, Mystery, Others, Romance, Sci-Fi, Thriller

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT G.Genre,
       Count(M.Id) AS num_of_movies
FROM   Movie AS M
       INNER JOIN Genre AS G
               ON M.Id = G.Movie_id
GROUP  BY Genre
ORDER  BY Num_of_movies DESC
LIMIT  1; 

-- Drama genre has the most number of movies with 4285 movies

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH Movie_with_single_genre
     AS (SELECT Movie_id,
                Count(Movie_id)
         FROM   Genre
         GROUP  BY Movie_id
         HAVING Count(DISTINCT Genre) = 1)
SELECT Count(*) AS Num_of_movies_single_genre
FROM   Movie_with_single_genre; 

-- 3289 movies belongs to only one genre

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

SELECT Genre,
       Round(Avg(Duration), 2) AS avg_duration
FROM   Movie AS M
       INNER JOIN Genre AS G
               ON M.Id = G.Movie_id
GROUP  BY Genre
ORDER  BY Avg_duration DESC; 

-- Action genre has the highest duration of 112.88 seconds followed by romance and crime genres.

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

WITH Number_of_movies_with_genre
     AS (SELECT Genre,
                Count(DISTINCT Movie_id)                    AS movie_count,
                Rank()
                  OVER(
                    ORDER BY Count(DISTINCT Movie_id) DESC) AS genre_rank
         FROM   Genre
         GROUP  BY Genre)
SELECT *
FROM   Number_of_movies_with_genre
WHERE  Genre = 'thriller'; 

-- Thriller genre has rank 3 wirth a count of 1484

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

SELECT Min(Avg_rating)    AS min_avg_rating,
       Max(Avg_rating)    AS max_avg_rating,
       Min(Total_votes)   AS min_total_votes,
       Max(Total_votes)   AS max_total_votes,
       Min(Median_rating) AS min_median_rating,
       Max(Median_rating) AS max_median_rating
FROM   Ratings; 

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

WITH Movie_rank_on_avg_rating
     AS (SELECT M.Title,
                Avg_rating,
                Rank()
                  OVER(
                    ORDER BY Avg_rating DESC) AS movie_rank
         FROM   Ratings AS R
                INNER JOIN Movie AS M
                        ON R.Movie_id = M.Id)
SELECT *
FROM   Movie_rank_on_avg_rating
WHERE  Movie_rank <= 10; 

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

SELECT Median_rating,
       Count(Movie_id) AS movie_count
FROM   Ratings
GROUP  BY Median_rating
ORDER  BY Movie_count DESC; 

-- Movies with a median rating of 7 is highest in the number with a count of 2257. 

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

WITH Prod_company_hitmovie
     AS (SELECT Production_company,
                Count(R.Movie_id)                    AS movie_count,
                Rank ()
                  OVER (
                    ORDER BY Count(R.Movie_id) DESC) AS prod_company_rank
         FROM   Ratings AS R
                INNER JOIN Movie AS M
                        ON M.Id = R.Movie_id
         WHERE  Avg_rating > 8
                AND Production_company IS NOT NULL
         GROUP  BY Production_company)
SELECT *
FROM   Prod_company_hitmovie
WHERE  Prod_company_rank = 1; 

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

SELECT Genre,
       Count(G.Movie_id) AS movie_count
FROM   Genre AS G
       INNER JOIN Movie AS M
               ON G.Movie_id = M.Id
       INNER JOIN Ratings AS R
               ON M.Id = R.Movie_id
WHERE  Month(Date_published) = 3
       AND Year = 2017
       AND Country LIKE '%USA%'
       AND Total_votes > 1000
GROUP  BY Genre
ORDER  BY Movie_count DESC; 

-- 24 Drama movies were released during March 2017 in the USA and had more than 1,000 votes
-- Top 3 genres are drama, comedy and action during March 2017 in the USA and had more than 1,000 votes


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

SELECT Title,
       Avg_rating,
       Genre
FROM   Movie AS M
       INNER JOIN Ratings AS R
               ON M.Id = R.Movie_id
       INNER JOIN Genre AS G
               ON M.Id = G.Movie_id
WHERE  Title LIKE 'the%'
       AND Avg_rating > 8
GROUP  BY Title
ORDER  BY Avg_rating DESC; 

-- The Brighton Miracle has highest average rating of 9.5.

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

select count(m.id) as movie_count
from movie as m
inner join ratings as r
on m.id = r.movie_id
where date_published between '2018-04-01' and '2019-04-01'
and median_rating = 8;

-- 361 movies released between 1 April 2018 and 1 April 2019 with a median rating of 8

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- Approach on language basis

WITH Highest_votes_summary
     AS (SELECT M.Languages,
                Sum(Total_votes) AS Total_num_votes
         FROM   Movie AS M
                INNER JOIN Ratings AS R
                        ON M.Id = R.Movie_id
         WHERE  Languages LIKE '%GERMAN%'
         UNION
         SELECT M.Languages,
                Sum(Total_votes) AS Total_num_votes
         FROM   Movie AS M
                INNER JOIN Ratings AS R
                        ON M.Id = R.Movie_id
         WHERE  Languages LIKE '%Italian%')
SELECT *,
       Rank()
         OVER(
           ORDER BY Total_num_votes DESC) AS rank_based_votes
FROM   Highest_votes_summary; 

-- Approach on country basis

SELECT country,
	sum(total_votes) as total_votes,
    rank() over(order by total_votes desc) as rank_based_votes
FROM movie AS m
	INNER JOIN ratings as r ON m.id=r.movie_id
WHERE country = 'Germany' or country = 'Italy'
GROUP BY country;


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

SELECT Sum(CASE
             WHEN NAME IS NULL THEN 1
             ELSE 0
           END) AS name_nulls,
       Sum(CASE
             WHEN Height IS NULL THEN 1
             ELSE 0
           END) AS height_nulls,
       Sum(CASE
             WHEN Date_of_birth IS NULL THEN 1
             ELSE 0
           END) AS date_of_birth_nulls,
       Sum(CASE
             WHEN Known_for_movies IS NULL THEN 1
             ELSE 0
           END) AS known_for_movies_nulls
FROM   Names; 
        
-- Height, date_of_birth, known_for_movies all 3 columns having NULLS values

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

WITH Top_3_genres AS
(
           SELECT     Genre,
                      Count(M.Id)                            AS Movie_count,
                      Rank() OVER(ORDER BY Count(M.Id) DESC) AS Genre_rank
           FROM       Movie                                  AS M
           INNER JOIN Genre                                  AS G
           ON         M.Id = G.Movie_id
           INNER JOIN Ratings AS R
           ON         M.Id = R.Movie_id
           WHERE      Avg_rating > 8
           GROUP BY   Genre Limit 3 )
SELECT     N.NAME            AS Director_name,
           Count(D.Movie_id) AS Movie_count
FROM       Director_mapping  AS D
INNER JOIN Genre G
Using      (Movie_id)
INNER JOIN Names AS N
ON         N.Id = D.Name_id
INNER JOIN Top_3_genres
Using      (Genre)
INNER JOIN Ratings
Using      (Movie_id)
WHERE      Avg_rating > 8
GROUP BY   NAME
ORDER BY   Movie_count DESC  
limit 2;


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

SELECT N.Name            AS actor_name,
       Count(R.Movie_id) AS movie_count
FROM   Names N
       INNER JOIN Role_mapping Rm
               ON N.Id = Rm.Name_id
       INNER JOIN Ratings R
               ON Rm.Movie_id = R.Movie_id
WHERE  Median_rating >= 8
GROUP  BY N.Name
ORDER  BY Movie_count DESC
LIMIT  2; 


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

SELECT     Production_company,
           Sum(Total_votes)                            AS Vote_count,
           Rank() OVER(ORDER BY Sum(Total_votes) DESC) AS Prod_comp_rank
FROM       Movie                                       AS M
INNER JOIN Ratings                                     AS R
ON         M.Id = R.Movie_id
GROUP BY   Production_company Limit 3;
        

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

SELECT N.NAME
       AS
       actor_name,
       Sum(R.Total_votes)
       AS Total_votes,
       Count(N.Id)
       AS movie_count,
       Round(Sum(Avg_rating * Total_votes) / Sum(Total_votes), 2)
       AS actor_avg_rating,
       Rank()
         OVER(
           ORDER BY Round(Sum(Avg_rating*Total_votes)/Sum(Total_votes), 2)DESC)
       AS
       actor_rank
FROM   Names AS N
       INNER JOIN Role_mapping AS Rm
               ON N.Id = Rm.Name_id
       INNER JOIN Movie AS M
               ON Rm.Movie_id = M.Id
       INNER JOIN Ratings AS R
               ON M.Id = R.Movie_id
WHERE  Category = 'actor'
       AND Country = 'india'
GROUP  BY N.NAME
HAVING Movie_count > 4; 

-- Top actor is Vijay Sethupathi with actor_avg_rating is 8.42 and total voter are 23114

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

SELECT N.NAME
       AS
       actress_name,
       Sum(R.Total_votes)
       AS Total_votes,
       Count(N.Id)
       AS movie_count,
       Round(Sum(Avg_rating * Total_votes) / Sum(Total_votes), 2)
       AS actress_avg_rating,
       Rank()
         OVER(
           ORDER BY Round(Sum(Avg_rating*Total_votes)/Sum(Total_votes), 2)DESC)
       AS
       actress_rank
FROM   Names AS N
       INNER JOIN Role_mapping AS Rm
               ON N.Id = Rm.Name_id
       INNER JOIN Movie AS M
               ON Rm.Movie_id = M.Id
       INNER JOIN Ratings AS R
               ON M.Id = R.Movie_id
WHERE  Category = 'actress'
       AND Country = 'india'
       AND Languages LIKE '%hindi%'
GROUP  BY N.NAME
HAVING Movie_count >= 3
limit 5; 


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/

/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT DISTINCT Title,
                R.Avg_rating,
                CASE
                  WHEN Avg_rating > 8 THEN 'Superhit movie'
                  WHEN Avg_rating BETWEEN 7 AND 8 THEN 'Hit movie'
                  WHEN Avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movie'
                  ELSE 'Flop movie'
                END AS movie_hit_flop_category
FROM   Movie AS M
       INNER JOIN Ratings AS R
               ON M.Id = R.Movie_id
       INNER JOIN Genre AS G Using (Movie_id)
WHERE  Genre LIKE 'thriller'; 


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

SELECT Genre,
       Round(Avg(Duration), 2)                      AS avg_duration,
       SUM(Round(Avg(Duration), 2))
         Over(
           ORDER BY Genre ROWS Unbounded Preceding) AS running_total_duration,
       Avg(Round(Avg(Duration), 2))
         Over(
           ORDER BY Genre ROWS 10 Preceding)        AS moving_avg_duration
FROM   Movie AS M
       Inner Join Genre AS G
               ON M.Id = G.Movie_id
GROUP  BY Genre
ORDER  BY Genre; 


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

-- Top 3 Genres based on most number of movies(most number of movies with >8 avg_rating)
WITH Top_genres AS
(
           SELECT     Genre
           FROM       Genre G
           INNER JOIN Ratings R
           ON         G.Movie_id = R.Movie_id
           GROUP BY   Genre
           ORDER BY   Count(R.Movie_id) DESC Limit 3 ),
-- Converting worldwide_gross_income datatype from 'varchar' to decimal.
-- Converting values in INR to dollars taking average dollar value as 80 INR
Movie_income AS
(
           SELECT     G.Genre,
                      Year,
                      Title AS Movie_name,
                      CASE
                                 WHEN Worlwide_gross_income LIKE 'INR%' THEN Cast(Replace(Worlwide_gross_income, 'INR', '') AS decimal(12)) / 80
                                 WHEN Worlwide_gross_income LIKE '$%' THEN Cast(Replace(Worlwide_gross_income, '$', '') AS     decimal(12))
                                 ELSE Cast(Worlwide_gross_income AS                                                            decimal(12))
                      END Worldwide_gross_income
           FROM       Genre G
           INNER JOIN Movie M
           ON         G.Movie_id = M.Id,
                      Top_genres
           WHERE      G.Genre IN ( Top_genres.Genre )
                      -- group by for distinct movie titles. To avoid repetitions, since one movie can belong to many genres
           GROUP BY   Movie_name
           ORDER BY   Year ),
-- five highest-grossing movies of each year from top 3 genre
Top_movies AS
(
         SELECT   *,
                  Dense_rank() OVER(Partition BY Year ORDER BY Worldwide_gross_income DESC) AS Movie_rank
         FROM     Movie_income )
SELECT *
FROM   Top_movies
WHERE  Movie_rank <= 5;


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

SELECT     Production_company,
           Count(M.Id)                           AS Movie_count,
           Rank() OVER(ORDER BY Count(M.Id)DESC) AS Prod_company_rank
FROM       Movie                                 AS M
INNER JOIN Ratings                               AS R
ON         R.Movie_id = M.Id
WHERE      Production_company IS NOT NULL
AND        Median_rating >= 8
AND        Position(',' IN Languages) > 0
GROUP BY   Production_company Limit 2 ;

-- Star Cinema and Twentieth Century Fox are the top two production house

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
WITH Top_actress AS
(
           SELECT     NAME                                                  AS Actress_name,
                      Sum(Total_votes)                                      AS Total_votes,
                      Count(R.Movie_id)                                     AS Movie_count,
                      Round(Sum(Avg_rating*Total_votes)/Sum(Total_votes),2) AS Actress_avg_rating
           FROM       Ratings                                               AS R
           INNER JOIN Movie                                                 AS M
           ON         R.Movie_id = M.Id
           INNER JOIN Role_mapping AS Rm
           ON         M.Id = Rm.Movie_id
           INNER JOIN Names AS N
           ON         Rm.Name_id = N.Id
           INNER JOIN Genre AS G
           ON         M.Id = G.Movie_id
           WHERE      Category = 'actress'
           AND        Avg_rating > 8
           AND        Genre = 'drama'
           GROUP BY   NAME)
SELECT   *,
         Rank() OVER(ORDER BY Movie_count DESC) AS Actress_rank
FROM     Top_actress Limit 3;

-- The top 3 actresses are Parvathy Thiruvothu, Susan Brown and Amanda Lawrence

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

WITH Next_date_published_summary AS
(
           SELECT     D.Name_id,
                      NAME,
                      D.Movie_id,
                      Duration,
                      R.Avg_rating,
                      Total_votes,
                      M.Date_published,
                      Lead(Date_published,1) OVER(Partition BY D.Name_id ORDER BY Date_published,Movie_id ) AS Next_date_published
           FROM       Director_mapping                                                                      AS D
           INNER JOIN Names                                                                                 AS N
           ON         N.Id = D.Name_id
           INNER JOIN Movie AS M
           ON         M.Id = D.Movie_id
           INNER JOIN Ratings AS R
           ON         R.Movie_id = M.Id ), Top_director_summary AS
(
       SELECT *,
              Datediff(Next_date_published, Date_published) AS Date_difference
       FROM   Next_date_published_summary )
SELECT   Name_id                       AS Director_id,
         NAME                          AS Director_name,
         Count(Movie_id)               AS Number_of_movies,
         Round(Avg(Date_difference),2) AS Avg_inter_movie_days,
         Round(Avg(Avg_rating),2)      AS Avg_rating,
         Sum(Total_votes)              AS Total_votes,
         Min(Avg_rating)               AS Min_rating,
         Max(Avg_rating)               AS Max_rating,
         Sum(Duration)                 AS Total_duration
FROM     Top_director_summary
GROUP BY Director_id
ORDER BY Count(Movie_id) DESC Limit 9;


