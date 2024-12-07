# IMDB Data Analysis using SQL (PostgreSQL).

![IMDB logo]()

## Overview
This project involves a comprehensive analysis of IMDB dataset using SQL. The goal is to extract valuable insights and answer various top 20 business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Content

<a href=" ">Dataset</a>

- Poster_Link   - Link of the poster that imdb using
- Series_Title  - Name of the movie
- Released_Year - Year at which that movie released
- Certificate   - Certificate earned by that movie
- Runtime       - Total runtime of the movie
- Genre         - Genre of the movie
- IMDB_Rating   - Rating of the movie at IMDB site
- Overview      - mini story/ summary
- Meta_score    - Score earned by the movie
- Director      - Name of the Director
- Star1,Star2,  - Name of the Stars
 Star3,Star4 
- No_of_votes   - Total number of votes
- Gross         - Money earned by that movie

## Objectives

- Analyzed movie gross revenue in relation to directors.  
- Examined movie gross revenue based on contributions from different stars.  
- Investigated the relationship between number of votes and directors.  
- Explored the impact of different stars on the number of votes a movie received.  
- Determined which genres are preferred by specific actors.  
- Identified actor combinations that consistently achieve high IMDb ratings.  
- Evaluated actor combinations that generate the highest gross revenue.  

## Schema

```sql
DROP TABLE IF EXISTS imdb_top_movies;
CREATE TABLE IF NOT EXISTS imdb_top_movies
(
	Poster_Link	     varchar(4000),
	Series_Title	     varchar(1000),
	Released_Year	     varchar(10),
	Certificate	     varchar(10),
	Runtime		     varchar(20),
	Genre		     varchar(50),
	IMDB_Rating	     decimal,
	Overview	     varchar(4000),
	Meta_score	     int,
	Director	     varchar(200),
	Star1		     varchar(200),
	Star2		     varchar(200),
	Star3		     varchar(200),
	Star4		     varchar(200),
	No_of_Votes	     bigint,
	Gross		     money
);
```

## Solving The 20 Business Problems Using IMDB Dataset:

### 1) Fetch all data from imdb table 

```sql
SELECT * 
FROM imdb_top_movies;
```


### 2) Fetch only the name and release year for all movies.

```sql
 SELECT series_title as movie_name,released_year
 FROM imdb_top_movies;
```


### 3) Fetch the name, release year and imdb rating of movies which are UA certified.

```sql
SELECT series_title as movie_name,released_year,imdb_rating
FROM imdb_top_movies
WHERE certificate = 'UA';
```


### 4) Fetch the name and genre of movies which are UA certified and have a Imdb rating of over 8.

```sql
SELECT series_title as movie_name,genre
FROM imdb_top_movies
WHERE certificate = 'UA' and imdb_rating > 8;
```


### 5) Find out how many movies are of Drama genre.

```sql
SELECT COUNT(*) as total_movie
FROM imdb_top_movies
WHERE genre ILIKE '%Drama%';
```


### 6) How many movies are directed by "Quentin Tarantino", "Steven Spielberg", "Christopher Nolan" and "Rajkumar Hirani".

```sql
SELECT COUNT(*) as count_movies
FROM imdb_top_movies
WHERE director IN ('Quentin Tarantino','Steven Spielberg','Christopher Nolan','Rajkumar Hirani');
```


### 7) What is the highest imdb rating given so far?

```sql
SELECT MAX(imdb_rating) as Highest_rating
FROM imdb_top_movies;
```


### 8) What is the highest and lowest imdb rating given so far?

```sql
SELECT MAX(imdb_rating) as Highest_rating,
       MIN(imdb_rating) as Lowest_rating
FROM imdb_top_movies;
```


### 9) Solve the above problem but display the results in different rows. And have a column which indicates the value as lowest and highest.

```sql
SELECT MAX(imdb_rating) as rating, 'Highest Rating' as category
FROM imdb_top_movies
UNION ALL
SELECT MIN(imdb_rating) as rating, 'Lowest Rating' as category
FROM imdb_top_movies;
```


### 10) Find out the total business done by movies staring "Aamir Khan".

```sql
SELECT 'Aamir Khan' AS star_name,
       SUM(gross) as total_business
FROM imdb_top_movies
WHERE star1 ILIKE '%Aamir Khan%'
   OR star2 ILIKE '%Aamir Khan%'
   OR star3 ILIKE '%Aamir Khan%'
   OR star4 ILIKE '%Aamir Khan%';

-- OR --

SELECT 'Aamir Khan' AS star_name,
       SUM(gross) AS total_business 
FROM imdb_top_movies
WHERE 'Aamir Khan' IN (star1,star2,star3,star4);
```


### 11) Find out the average imdb rating of movies which are neither directed by "Quentin Tarantino", "Steven Spielberg", "Christopher Nolan" and are not acted by any of these stars "Christian Bale", "Liam Neeson", "Heath Ledger", "Leonardo DiCaprio", "Anne Hathaway".

```sql
SELECT ROUND(AVG(imdb_rating),1) as average_rating
FROM imdb_top_movies
WHERE director NOT IN ('Quentin Tarantino', 'Steven Spielberg', 'Christopher Nolan')
and (star1) NOT IN ('Christian Bale', 'Liam Neeson', 'Heath Ledger', 'Leonardo DiCaprio', 'Anne Hathaway')
and (star2) NOT IN ('Christian Bale', 'Liam Neeson', 'Heath Ledger', 'Leonardo DiCaprio', 'Anne Hathaway')
and (star3) NOT IN ('Christian Bale', 'Liam Neeson', 'Heath Ledger', 'Leonardo DiCaprio', 'Anne Hathaway')
and (star4) NOT IN ('Christian Bale', 'Liam Neeson', 'Heath Ledger', 'Leonardo DiCaprio', 'Anne Hathaway');
```


### 12) Mention the movies involving both "Steven Spielberg" and "Tom Cruise".

```sql
SELECT series_title as movie_name
FROM imdb_top_movies
WHERE 'Steven Spielberg' IN (star1,star2,star3,star4,director)
        and 'Tom Cruise' IN (star1,star2,star3,star4);
```


### 13) Display the movie name and watch time (in both mins and hours) which have over 9 imdb rating.

```sql
SELECT series_title as Movie_name, 
       runtime as runtime_in_mins,
       ROUND(CAST(REPLACE(runtime, 'min', '') as decimal)/60,2) as runtime_in_hrs
FROM imdb_top_movies;
```


### 14) What is the average imdb rating of movies which are released in the last 10 years and have less than 2 hrs of runtime.

```sql
SELECT series_title, 
       director
FROM imdb_top_movies
WHERE director != 'Christopher Nolan' 
      and (lower(series_title) like '%batman%' or lower(series_title) like '%dark knight%');
```


### 15) Identify the Batman movie which is not directed by "Christopher Nolan".

```sql
SELECT series_title, 
       director
FROM imdb_top_movies
WHERE director != 'Christopher Nolan' 
      and (lower(series_title) like '%batman%' or lower(series_title) like '%dark knight%');
```


### 16) Display all the A and UA certified movies which are either directed by "Steven Spielberg", "Christopher Nolan" or which are directed by other directors but have a rating of over 8.

```sql
SELECT series_title as movie_name
FROM imdb_top_movies
WHERE (director in ('Steven Spielber', 'Christopher Nolan') or  imdb_rating > 8) 
      and (certificate in ('A','UA'));
```


### 17) What are the different certificates given to movies?

```sql
SELECT certificate
FROM imdb_top_movies
GROUP BY certificate;

```


### 18) Display all the movies acted by Tom Cruise in the order of their release. Consider only movies which have a meta score.

```sql
SELECT series_title as movie_name,
FROM imdb_top_movies
WHERE 'Tom Cruise' IN (star1,star2,star3,star4) 
      and meta_score is not null
ORDER BY released_year;
```


### 19) Segregate all the Drama and Comedy movies released in the last 10 years as per their runtime. Movies shorter than 1 hour should be termed as short film. Movies longer than 2 hrs should be termed as longer movies. All others can be termed as Good watch time.

```sql
SELECT series_title as movie_name,
       ROUND(CAST(REPLACE(runtime,'min','') as decimal)/60,2) as runtime_hrs,
CASE
     WHEN ROUND(CAST(REPLACE(runtime,'min','')as decimal)/60,2) < 1 then 'short flim'
     WHEN ROUND(CAST(REPLACE(runtime,'min','')as decimal)/60,2) > 2 then 'Longer Movies'
     ELSE 'Good watch time' 
     END as category
FROM imdb_top_movies
WHERE (lower(genre) like '%drama%' OR lower(genre) like '%comedy%')
      and released_year > (extract(year from current_date) - 10)::varchar
ORDER BY category;

--OR--

         SELECT series_title as movie_name,
                ROUND(CAST(REPLACE(runtime,'min','') as decimal)/60,2) as runtime_hrs,
                'short flim' as category
         FROM imdb_top_movies
         WHERE (lower(genre) like '%drama%' OR lower(genre) like '%comedy%')
               and released_year > (extract(year from current_date) - 10)::varchar
               and round(cast(replace(runtime,'min','')as decimal)/60,2) < 1
UNION ALL
         SELECT series_title as movie_name,
                ROUND(CAST(REPLACE(runtime,'min','') as decimal)/60,2) as runtime_hrs,
                'Longer Movies' as category
         FROM imdb_top_movies
         WHERE (lower(genre) like '%drama%' OR lower(genre) like '%comedy%')
               and released_year > (extract(year from current_date) - 10)::varchar
               and round(cast(replace(runtime,'min','')as decimal)/60,2) > 2
UNION ALL
         SELECT series_title as movie_name,
                ROUND(CAST(REPLACE(runtime,'min','') as decimal)/60,2) as runtime_hrs,
                'Good watch time' as category
         FROM imdb_top_movies
         WHERE (lower(genre) like '%drama%' OR lower(genre) like '%comedy%')
               and released_year > (extract(year from current_date) - 10)::varchar
               and round(cast(replace(runtime,'min','')as decimal)/60,2) between 1 and 2;
```


### 20) Write a query to display the "Christian Bale" movies which released in odd year and even year. Sort the data as per Odd year at the top.

```sql
SELECT series_title as movie_name,released_year,
CASE
    WHEN released_year::int%2 = 0 then 'Even year'
    ELSE 'Odd year'
    END year_category
FROM imdb_top_movies
WHERE 'Christian Bale' in (director,star1,star2,star3,star4);
```


