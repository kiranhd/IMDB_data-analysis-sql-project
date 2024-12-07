--IMDB project

drop table if exists imdb_top_movies;
create table if not exists imdb_top_movies
(
	Poster_Link		varchar(4000),
	Series_Title	varchar(1000),
	Released_Year	varchar(10),
	Certificate		varchar(10),
	Runtime			varchar(20),
	Genre			varchar(50),
	IMDB_Rating		decimal,
	Overview		varchar(4000),
	Meta_score		int,
	Director		varchar(200),
	Star1			varchar(200),
	Star2			varchar(200),
	Star3			varchar(200),
	Star4			varchar(200),
	No_of_Votes		bigint,
	Gross			money
);

select * from imdb_top_movies;


-- Solving the 20 Business problems using IMDB dataset:

1) Fetch all data from imdb table 

select * from imdb_top_movies;


2) Fetch only the name and release year for all movies.

 select series_title as movie_name,released_year
 from imdb_top_movies;


3) Fetch the name, release year and imdb rating of movies which are UA certified.

select series_title as movie_name,released_year,imdb_rating
from imdb_top_movies
where certificate = 'UA';


4) Fetch the name and genre of movies which are UA certified and have a Imdb rating of over 8.

select series_title as movie_name,genre
from imdb_top_movies
where certificate = 'UA' and imdb_rating > 8;


5) Find out how many movies are of Drama genre.

select count(*) as total_movie
from imdb_top_movies
where genre ILIKE '%Drama%';


6) How many movies are directed by "Quentin Tarantino", "Steven Spielberg", "Christopher Nolan" and "Rajkumar Hirani".

select COUNT(*) as count_movies
from imdb_top_movies
where director IN ('Quentin Tarantino','Steven Spielberg','Christopher Nolan','Rajkumar Hirani');


7) What is the highest imdb rating given so far?

select MAX(imdb_rating) as Highest_rating
from imdb_top_movies;


8a) What is the highest and lowest imdb rating given so far?

select MAX(imdb_rating) as Highest_rating,MIN(imdb_rating) as Lowest_rating
from imdb_top_movies;

8b) Solve the above problem but display the results in different rows. 
And have a column which indicates the value as lowest and highest.

select MAX(imdb_rating) as rating, 'Highest Rating' as category
from imdb_top_movies
union all
select MIN(imdb_rating) as rating, 'Lowest Rating' as category
from imdb_top_movies;



9) Find out the total business done by movies staring "Aamir Khan".

SELECT 'Aamir Khan' AS star_name,SUM(gross) as total_business
FROM imdb_top_movies
WHERE star1 ILIKE '%Aamir Khan%'
   OR star2 ILIKE '%Aamir Khan%'
   OR star3 ILIKE '%Aamir Khan%'
   OR star4 ILIKE '%Aamir Khan%';

-- OR

   SELECT 'Aamir Khan' AS star_name,SUM(gross) AS total_business 
FROM imdb_top_movies
WHERE 'Aamir Khan' IN (star1,star2,star3,star4)


10) Find out the average imdb rating of movies which are neither directed 
by "Quentin Tarantino", "Steven Spielberg", "Christopher Nolan" and are not acted 
by any of these stars "Christian Bale", "Liam Neeson", "Heath Ledger", "Leonardo DiCaprio", "Anne Hathaway".

select round(avg(imdb_rating),1) as average_rating
from imdb_top_movies
where director NOT IN ('Quentin Tarantino', 'Steven Spielberg', 'Christopher Nolan')
and (star1) NOT IN ('Christian Bale', 'Liam Neeson', 'Heath Ledger', 'Leonardo DiCaprio', 'Anne Hathaway')
and (star2) NOT IN ('Christian Bale', 'Liam Neeson', 'Heath Ledger', 'Leonardo DiCaprio', 'Anne Hathaway')
and (star3) NOT IN ('Christian Bale', 'Liam Neeson', 'Heath Ledger', 'Leonardo DiCaprio', 'Anne Hathaway')
and (star4) NOT IN ('Christian Bale', 'Liam Neeson', 'Heath Ledger', 'Leonardo DiCaprio', 'Anne Hathaway');


11) Mention the movies involving both "Steven Spielberg" and "Tom Cruise".

select series_title as movie_name
from imdb_top_movies
where 'Steven Spielberg' IN (star1,star2,star3,star4,director)
and 'Tom Cruise' IN (star1,star2,star3,star4);


12) Display the movie name and watch time (in both mins and hours) which have over 9 imdb rating.

select series_title as Movie_name, runtime as runtime_in_mins,
round(cast(replace(runtime, 'min', '') as decimal)/60,2) as runtime_in_hrs
from imdb_top_movies ;


13) What is the average imdb rating of movies which are released in the last 10 years and have less than 2 hrs of runtime.

select round(avg(imdb_rating),1) as avg_rating
from imdb_top_movies
where released_year > (extract(year from current_date)-10)::varchar
and replace(runtime,'min', '')::int <= 120


14) Identify the Batman movie which is not directed by "Christopher Nolan".

select series_title, director
from imdb_top_movies
where director != 'Christopher Nolan' 
and (lower(series_title) like '%batman%' or lower(series_title) like '%dark knight%');


15) Display all the A and UA certified movies which are either directed 
by "Steven Spielberg", "Christopher Nolan" or which are directed by other directors but have a rating of over 8.

select series_title as movie_name
from imdb_top_movies
where (director in ('Steven Spielber', 'Christopher Nolan') or  imdb_rating > 8) 
and (certificate in ('A','UA'));


16) What are the different certificates given to movies?

select certificate
from imdb_top_movies
group by certificate;


17) Display all the movies acted by Tom Cruise in the order of their release. Consider only movies which have a meta score.

select series_title as movie_name,released_year,meta_score
from imdb_top_movies
where 'Tom Cruise' IN (star1,star2,star3,star4) and meta_score is not null
order by released_year;


18) Segregate all the Drama and Comedy movies released in the last 10 years as per their runtime. 
Movies shorter than 1 hour should be termed as short film. Movies longer than 2 hrs should be termed as longer movies. 
All others can be termed as Good watch time.

select series_title as movie_name,
round(cast(replace(runtime,'min','') as decimal)/60,2) as runtime_hrs,
case
     when round(cast(replace(runtime,'min','')as decimal)/60,2) < 1 then 'short flim'
	 when round(cast(replace(runtime,'min','')as decimal)/60,2) > 2 then 'Longer Movies'
	 else 'Good watch time' end as category
from imdb_top_movies
where (lower(genre) like '%drama%' OR lower(genre) like '%comedy%')
and released_year > (extract(year from current_date) - 10)::varchar
order by category;


19) Write a query to display the "Christian Bale" movies which released in odd year and even year. Sort the data as per Odd year at the top.

select series_title as movie_name,released_year,
case
    when released_year::int%2 = 0 then 'Even year'
	else 'Odd year'
	end year_category
from imdb_top_movies
where 'Christian Bale' in (director,star1,star2,star3,star4);


20) Re-write problem #18 without using case statement.

         select series_title as movie_name,
         round(cast(replace(runtime,'min','') as decimal)/60,2) as runtime_hrs,
        'short flim'as category
         from imdb_top_movies
         where (lower(genre) like '%drama%' OR lower(genre) like '%comedy%')
         and released_year > (extract(year from current_date) - 10)::varchar
         and round(cast(replace(runtime,'min','')as decimal)/60,2) < 1
union all
         select series_title as movie_name,
         round(cast(replace(runtime,'min','') as decimal)/60,2) as runtime_hrs,
         'Longer Movies' as category
         from imdb_top_movies
         where (lower(genre) like '%drama%' OR lower(genre) like '%comedy%')
         and released_year > (extract(year from current_date) - 10)::varchar
         and round(cast(replace(runtime,'min','')as decimal)/60,2) > 2
union all
         select series_title as movie_name,
         round(cast(replace(runtime,'min','') as decimal)/60,2) as runtime_hrs,
         'Good watch time' as category
         from imdb_top_movies
         where (lower(genre) like '%drama%' OR lower(genre) like '%comedy%')
         and released_year > (extract(year from current_date) - 10)::varchar
         and round(cast(replace(runtime,'min','')as decimal)/60,2) between 1 and 2;







 
 