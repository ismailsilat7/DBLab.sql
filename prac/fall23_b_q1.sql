
CREATE TABLE Movies (
    MOVIE_ID INT PRIMARY KEY,
    TITLE VARCHAR2(100) NOT NULL,
    RELEASE_YEAR NUMBER,
    GENRE VARCHAR2(100),
    CONSTRAINT ck_4digit CHECK (release_year BETWEEN 1000 AND 9999),
    CONSTRAINT ck_genre CHECK (genre IN ('Action', 'Drama', 'Comedy', 'Horror', 'Sci-Fi', 'Fantasy'))
);

CREATE TABLE Customers (
    CUSTOMER_ID INT PRIMARY KEY,
    FIRST_NAME VARCHAR2(100) NOT NULL,
    LAST_NAME VARCHAR2(100) NOT NULL,
    EMAIL VARCHAR2(100) CHECK (REGEXP_LIKE(email, '^[A-Za-z0-9._+-]+@[A-Za-z0-9._+-]+\.[A-Za-z]{2,}$')),
    DATE_OF_BIRTH DATE CHECK (date_of_birth < DATE '2026-04-02')
);

CREATE TABLE rentals (
    RENTAL_ID INT PRIMARY KEY,
    RENTAL_DATE DATE NOT NULL,
    RETURN_DATE DATE NOT NULL,
    CUSTOMER_ID INT REFERENCES customers(customer_id),
    MOVIE_ID INT,
    CONSTRAINT ck_rend CHECK (rental_date < DATE '2026-04-02'),
    CONSTRAINT ck_retd CHECK (return_date > rental_date)
);

CREATE TABLE reviews (
    REVIEW_ID INT PRIMARY KEY,
    REVIEW_TEXT VARCHAR2(4000),
    RATING NUMBER CHECK (rating BETWEEN 1 AND 5),
    MOVIE_ID INT,
    CUSTOMER_ID INT,
    CONSTRAINT fk_mid FOREIGN KEY (MOVIE_ID) REFERENCES movies(movie_id),
    CONSTRAINT fk_cid FOREIGN KEY (CUSTOMER_ID) REFERENCES customers(customer_id)
);

INSERT INTO MOVIES VALUES (1, 'Avengers: Endgame', 2019, 'Action');
INSERT INTO CUSTOMERS VALUES (1, 'Sarah', 'Smith', 'sarah@example.com', TO_DATE('1985-03-10', 'YYYY-MM-DD'));

UPDATE Movies
SET Genre = 'Sci-Fi'
WHERE Title = 'Avengers: Endgame';

UPDATE Customers
SET email = 'sarah.newemail@example.com'
WHERE first_name = 'Sarah';

ALTER TABLE Movies ADD director VARCHAR2(255);
ALTER TABLE Movies ADD Constraint fk_movieid FOREIGN KEY (movie_id) REFERENCES movies(movie_id);

SELECT * FROM movies WHERE genre = 'Action';
SELECT * FROM rentals WHERE customer_id = 1;
