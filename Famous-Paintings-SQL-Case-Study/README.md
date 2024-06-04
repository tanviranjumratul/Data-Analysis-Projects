# Famous-Paintings-SQL-Case-Study

# SQL Painting Project

This project involves analyzing a dataset related to paintings, artists, museums, and various attributes associated with them using SQL queries.

## Dataset Overview

The dataset includes the following tables:

- `artist`: Contains information about artists.
- `canvas_size`: Provides details about different canvas sizes.
- `image_link`: Stores links to images of paintings.
- `museum`: Holds information about museums.
- `museum_hours`: Contains museum opening hours.
- `subject`: Contains subjects of paintings.
- `work`: Stores details about paintings.
- `product_size`: Provides details about product sizes associated with paintings.

# If work.csv file didn't shows the accurate result. Delete it on server and import the work.sql query.

## Exploring the dataset 

```sql
SELECT * FROM artist; -- 421
SELECT * FROM canvas_size; -- 200
SELECT * FROM image_link; -- 14775
SELECT * FROM museum; -- 57
SELECT * FROM museum_hours; -- 351
SELECT * FROM  subject; -- 6771
SELECT * FROM work; -- 14776
SELECT * FROM product_size; -- 110347
```

# Here is the Code

/*1) Fetch all the paintings which are not displayed on any museaums?*/
```
SELECT 
    *
FROM
    work
WHERE
    museum_id IS NULL;
```

/*2) Are there museums without any paintings?*/
```
SELECT 
    *
FROM
    museum.museum m
        LEFT JOIN
    work w ON m.museum_id = w.museum_id
WHERE
    w.MUSEUM_ID IS NULL;
```

/*3) How many paintings have an asking price of more than their regular price? */
```
SELECT 
    COUNT(*) AS num_paintings_higher_price
FROM
    museum.product_size
WHERE
    sale_price > regular_price;
```

    
/*4) Identify the paintings whose asking price is less than 50% of its regular price.*/
```
SELECT 
    *
FROM
    museum.product_size
WHERE
    sale_price < 0.5 * regular_price;
 ```   

/*5) Which canvas size costs the most?*/
```
SELECT 
    size_id, width, height, label
FROM
    museum.canvas_size
ORDER BY (SELECT 
        MAX(sale_price)
    FROM
        museum.product_size ps
    WHERE
        ps.size_id = canvas_size.size_id) DESC
LIMIT 1;
```

/*6) Delete duplicate records from work, product_size, subject and image_link tables*/
```
-- DELETING FROM WORK TABLE
DELETE FROM WORK
WHERE WORK_ID IN (
    SELECT WORK_ID
    FROM (
        SELECT 
            WORK_ID, 
            ROW_NUMBER() OVER (PARTITION BY WORK_ID) AS RowNum
        FROM 
            WORK
    ) AS Subquery
    WHERE RowNum > 1
);

-- DELETING FROM PRODUCT_SIZE TABLE
DELETE FROM PRODUCT_SIZE
WHERE (WORK_ID, SIZE_ID) IN (
    SELECT WORK_ID, SIZE_ID
    FROM (
        SELECT 
            WORK_ID, 
            SIZE_ID,
            ROW_NUMBER() OVER (PARTITION BY WORK_ID, SIZE_ID ORDER BY WORK_ID) AS RowNum
        FROM 
            PRODUCT_SIZE
    ) AS Subquery
    WHERE RowNum > 1
);

-- DELETING FROM SUBJECT TABLE
DELETE FROM SUBJECT
WHERE (WORK_ID, SUBJECT) IN (
    SELECT WORK_ID, SUBJECT
    FROM (
        SELECT 
            WORK_ID, 
            SUBJECT,
            ROW_NUMBER() OVER (PARTITION BY WORK_ID, SUBJECT ORDER BY WORK_ID) AS RowNum
        FROM 
            SUBJECT
    ) AS Subquery
    WHERE RowNum > 1
);

-- DELETING FROM IMAGE_LINK TABLE
DELETE FROM IMAGE_LINK
WHERE (WORK_ID, URL, thumbnail_small_url, thumbnail_large_url) IN (
    SELECT WORK_ID, URL, thumbnail_small_url, thumbnail_large_url
    FROM (
        SELECT 
            WORK_ID, 
            URL, 
            thumbnail_small_url, 
            thumbnail_large_url,
            ROW_NUMBER() OVER (PARTITION BY WORK_ID, URL, thumbnail_small_url, thumbnail_large_url ORDER BY WORK_ID) AS RowNum
        FROM 
            IMAGE_LINK
    ) AS Subquery
    WHERE RowNum > 1
);
```

/* 7) Identify the museums with invalid city information in the given dataset */
```
SELECT 
    *
FROM
    museum.museum
WHERE
    city REGEXP '^[0-9]';-- Regular expressions (Regexp)
```


/*8) Museum_Hours table has 1 invalid entry. Identify it and remove it.*/
```
SELECT 
    *
FROM
    museum.museum_hours
WHERE
    day IS NULL OR open IS NULL
        OR close IS NULL;
```
-- Here I didn't find any Invelid Entry.


/* 9) Fetch the top 10 most famous painting subject */
```
SELECT 
    subject, COUNT(*) AS num_paintings
FROM
    museum.subject
GROUP BY subject
ORDER BY num_paintings DESC
LIMIT 10;
```

/* 10) Identify the museums which are open on both Sunday and Monday. Display museum name, city. */
```
SELECT 
    M.name, m.city
FROM
    museum.museum M
        LEFT JOIN
    MUSEUM_HOURS H ON M.MUSEUM_ID = H.MUSEUM_ID
WHERE
    DAY IN ('Sunday' , 'Monday');
```

/*11) How many museums are open every single day?*/
```
SELECT 
    COUNT(*) AS num_museums_open_every_day
FROM
    (SELECT 
        museum_id
    FROM
        museum.museum_hours
    GROUP BY museum_id
    HAVING COUNT(DISTINCT day) = 7) AS museums_open_every_day;
```

/*12) Which are the top 5 most popular museum? (Popularity is defined based on most no of paintings in a museum)*/
```
SELECT 
    m.name AS museum_name,
    m.city,
    COUNT(w.work_id) AS num_paintings
FROM
    museum.museum m
        INNER JOIN
    work w ON m.museum_id = w.museum_id
GROUP BY m.museum_id
ORDER BY num_paintings DESC
LIMIT 5;
```

/*13) Who are the top 5 most popular artist? (Popularity is defined based on most no of paintings done by an artist)*/
```
SELECT 
    a.full_name AS artist_name,
    COUNT(w.work_id) AS num_paintings
FROM
    museum.artist a
        INNER JOIN
    work w ON a.artist_id = w.artist_id
GROUP BY a.artist_id
ORDER BY num_paintings DESC
LIMIT 5;
```

/*14) Display the 3 least popular canva sizes*/
```
SELECT 
    cs.size_id,
    cs.width,
    cs.height,
    cs.label,
    COUNT(ps.work_id) AS num_paintings
FROM
    museum.canvas_size cs
        LEFT JOIN
    product_size ps ON cs.size_id = ps.size_id
GROUP BY cs.size_id
ORDER BY num_paintings ASC
LIMIT 3;
```

/*15) Which museum is open for the longest during a day. Dispay museum name, state and hours open and which day?*/
```
SELECT *
FROM (
    SELECT m.name AS museum_name, m.state, day, open, close,
		str_to_date(close, '%h:%i:%p') as Close_time ,
        STR_TO_DATE(open, '%h:%i:%p') as open_time,
		timediff(STR_TO_DATE(close, '%h:%i:%p'),STR_TO_DATE(open, '%h:%i:%p')) AS duration,
		 row_number() OVER (ORDER BY TIMEDIFF(STR_TO_DATE(close, '%h:%i:%p'), STR_TO_DATE(open, '%h:%i:%p')) DESC) AS rnk
    FROM museum_hours mh
    JOIN museum m ON m.museum_id = mh.museum_id
) x
WHERE x.rnk = 1;
```

/*16) Which museum has the most no of most popular painting style?*/
```
SELECT 
    m.name AS museum_name,
    COUNT(*) AS num_paintings
FROM 
    museum.museum m
JOIN 
    work w ON m.museum_id = w.museum_id
JOIN 
    (
        SELECT 
            style,
            COUNT(*) AS num_paintings
        FROM 
            work
        GROUP BY 
            style
        ORDER BY 
            num_paintings DESC
        LIMIT 1
    ) AS most_popular_style ON w.style = most_popular_style.style
GROUP BY 
    m.museum_id
ORDER BY 
    num_paintings DESC
LIMIT 1;
```


/*17) Identify the artists whose paintings are displayed in multiple countries*/
```
create table  temp (
 SELECT DISTINCT 
        a.full_name AS artist,
        m.country
    FROM 
        work w
    JOIN 
        artist a ON a.artist_id = w.artist_id
    JOIN 
        museum m ON m.museum_id = w.museum_id
);
select 
artist,
count(country) as country
from temp
group by artist
having country > 1
order by country desc;
```


/*18) Display the country and the city with most no of museums. Output 2 seperate columns to mention the city and country. If there are multiple value, seperate them with comma.*/

```
SELECT
    country,
    GROUP_CONCAT(city ORDER BY num_museums DESC SEPARATOR ', ') AS cities
FROM (
    SELECT
        country,
        city,
        COUNT(*) AS num_museums
    FROM museum.museum
    GROUP BY country, city
) AS museum_counts
GROUP BY country
ORDER BY MAX(num_museums) DESC
LIMIT 1;
```

/*19) Identify the artist and the museum where the most expensive and least expensive painting is placed. 
Display the artist name, sale_price, painting name, museum name, museum city and canvas label*/
```
WITH cte AS (
    SELECT 
        w.work_id,
        full_name,
        sale_price,
        w.name AS museum_name,
        m.name,
        m.city,
        c.label,
        MAX(sale_price) OVER () AS max_sale_price,
        MIN(sale_price) OVER () AS min_sale_price
    FROM 
        product_size p 
    JOIN 
        work w ON w.work_id = p.work_id
    JOIN 
        museum m ON m.museum_id = w.museum_id
    JOIN 
        artist a ON a.artist_id = w.artist_id
    JOIN 
        canvas_size c ON c.size_id = p.size_id
)
SELECT 
    *
FROM 
    cte
WHERE 
    sale_price IN (max_sale_price, min_sale_price)
limit 2;
```

/*20) Which country has the 5th highest no of paintings?*/
```
SELECT country
FROM (
    SELECT m.country, COUNT(*) AS num_paintings
    FROM museum m
    JOIN work w ON m.museum_id = w.museum_id
    GROUP BY m.country
    ORDER BY num_paintings DESC
    LIMIT 5
) AS top_countries
ORDER BY num_paintings ASC
LIMIT 1;
```

/*21) Which are the 3 most popular and 3 least popular painting styles?*/
```
USE museum;
WITH style_counts AS (
    SELECT 
        style,
        COUNT(*) AS num_paintings,
        rank() OVER (ORDER BY COUNT(*) DESC) AS popular_rank,
        rank() OVER (ORDER BY COUNT(*) ASC) AS unpopular_rank
    FROM work
    where style is not null
    GROUP BY style
)
SELECT 
    style,
    num_paintings,
    case 
		when popular_rank <= 3 then 'Most Popular'
        when Unpopular_rank <= 3 then 'Least Popular'
        else null 
        End as Popularity_category
FROM style_counts
WHERE popular_rank <= 3 OR unpopular_rank <= 3
order by num_paintings desc;
```

/*22) Which artist has the most no of Portraits paintings outside USA?. Display artist name, no of paintings and the artist nationality.*/
```
SELECT 
    full_name AS artist_name,
    nationality,
    no_of_paintings
FROM (
    SELECT 
        a.full_name,
        a.nationality,
        COUNT(*) AS no_of_paintings,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM 
        work w
    JOIN 
        artist a ON a.artist_id = w.artist_id
    JOIN 
        subject s ON s.work_id = w.work_id
    JOIN 
        museum m ON m.museum_id = w.museum_id
    WHERE 
        s.subject = 'Portraits'
        AND m.country != 'USA'
    GROUP BY 
        a.full_name, a.nationality
) x
WHERE 
    rnk = 1;
```
