
CREATE TABLE IF NOT EXISTS Customers (
    CUSTOMER_ID INT PRIMARY KEY,
    CUSTOMER_NAME VARCHAR2(100) NOT NULL,
    CITY VARCHAR2(100)
);

CREATE TABLE IF NOT EXISTS Books (
    BOOK_ID INT PRIMARY KEY,
    TITLE VARCHAR2(100) NOT NULL,
    PRICE NUMERIC NOT NULL,
    PUBLISHER VARCHAR2(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Authors (
    AUTHOR_ID INT PRIMARY KEY,
    AUTHOR_NAME VARCHAR2(100) NOT NULL 
);

CREATE TABLE IF NOT EXISTS Book_Authors (
    BOOK_ID INT NOT NULL,
    AUTHOR_ID INT NOT NULL,
    CONSTRAINT fk_book FOREIGN KEY (BOOK_ID) REFERENCES Books(BOOK_ID),
    CONSTRAINT fk_author FOREIGN KEY (AUTHOR_ID) REFERENCES Authors(AUTHOR_ID),
    CONSTRAINT pk_book_authors PRIMARY KEY (BOOK_ID, AUTHOR_ID)
);

CREATE TABLE IF NOT EXISTS Purchases (
    PURCHASE_ID INT PRIMARY KEY,
    CUSTOMER_ID INT NOT NULL,
    CONSTRAINT fk_customer FOREIGN KEY (CUSTOMER_ID) REFERENCES Customers(CUSTOMER_ID),
    PURCHASE_DATE DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS Purchase_Details (
    PURCHASE_ID INT NOT NULL,
    BOOK_ID INT NOT NULL,
    QUANTITY INT NOT NULL,
    CONSTRAINT fk_purchases FOREIGN KEY (PURCHASE_ID) REFERENCES Purchases(PURCHASE_ID),
    CONSTRAINT fk_books FOREIGN KEY (BOOK_ID) REFERENCES Books(BOOK_ID),
    CONSTRAINT pk_purchase_details PRIMARY KEY (PURCHASE_ID, BOOK_ID)
);

INSERT ALL
    INTO Customers VALUES (1, 'Ali Khan', 'Karachi')
    INTO Customers VALUES (2, 'Sara Ahmed', 'Lahore')
    INTO Customers VALUES (3, 'Usman Tariq', 'Islamabad')
    INTO Customers VALUES (4, 'Ayesha Noor', 'Karachi')
    INTO Customers VALUES (5, 'Bilal Raza', 'Lahore')
SELECT * FROM Dual;

INSERT INTO Books VALUES (101, 'Database Systems', 850, 'Oxford');
INSERT INTO Books VALUES (102, 'Operating Systems', 920, 'Pearson');
INSERT INTO Books VALUES (103, 'Data Structures', 780, 'McGraw Hill');
INSERT INTO Books VALUES (104, 'Artificial Intelligence', 1200, 'Springer');
INSERT INTO Books VALUES (105, 'Computer Networks', 950, 'Pearson');

INSERT INTO Authors VALUES (1, 'Andrew Tanenbaum');
INSERT INTO Authors VALUES (2, 'Silberschatz');
INSERT INTO Authors VALUES (3, 'Thomas Cormen');
INSERT INTO Authors VALUES (4, 'Stuart Russell');
INSERT INTO Authors VALUES (5, 'Peter Norvig');

INSERT INTO Book_Authors VALUES (101, 2);
INSERT INTO Book_Authors VALUES (102, 1);
INSERT INTO Book_Authors VALUES (102, 2);
INSERT INTO Book_Authors VALUES (103, 3);
INSERT INTO Book_Authors VALUES (104, 4);
INSERT INTO Book_Authors VALUES (104, 5);
INSERT INTO Book_Authors VALUES (105, 1);

INSERT INTO Purchases VALUES (201, 1, TO_DATE('01-JAN-2024','DD-MON-YYYY'));
INSERT INTO Purchases VALUES (202, 2, TO_DATE('03-JAN-2024','DD-MON-YYYY'));
INSERT INTO Purchases VALUES (203, 1, TO_DATE('05-JAN-2024','DD-MON-YYYY'));
INSERT INTO Purchases VALUES (204, 3, TO_DATE('06-JAN-2024','DD-MON-YYYY'));
INSERT INTO Purchases VALUES (205, 4, TO_DATE('08-JAN-2024','DD-MON-YYYY'));

INSERT INTO Purchase_Details VALUES (201, 101, 1);
INSERT INTO Purchase_Details VALUES (201, 103, 2);
INSERT INTO Purchase_Details VALUES (202, 102, 1);
INSERT INTO Purchase_Details VALUES (202, 104, 1);
INSERT INTO Purchase_Details VALUES (203, 105, 3);
INSERT INTO Purchase_Details VALUES (204, 103, 1);
INSERT INTO Purchase_Details VALUES (204, 104, 2);
INSERT INTO Purchase_Details VALUES (205, 101, 1);


SELECT customer_name FROM customers
WHERE customer_id IN (
    SELECT customer_id FROM purchases
    WHERE purchase_id IN (
        SELECT purchase_id FROM Purchase_Details
        WHERE Book_id IN (
            SELECT Book_id FROM Books
            WHERE price > (
                SELECT AVG(price) FROM Books
            )
        )
    )
);

SELECT title FROM books b
WHERE price > (
    SELECT avg(price) FROM books
    WHERE book_id IN (
        select book_id FROM books
        WHERE publisher = b.publisher
    )
);

SELECT customer_name FROM CUSTOMERS
WHERE customer_id IN (
    SELECT customer_id FROM PURCHASES
) AND customer_id NOT IN (
    SELECT customer_id FROM purchases 
    WHERE purchase_id IN (
        SELECT purchase_id FROM PURCHASE_DETAILS
        WHERE book_id IN (
            SELECT book_id FROM books
            WHERE publisher = 'Pearson'
        )
    )
);

SELECT title FROM books
WHERE book_id NOT IN (
    SELECT book_id FROM purchase_details
);

SELECT author_name FROM authors
WHERE author_id IN (
    SELECT author_id FROM BOOK_AUTHORS
    WHERE book_id IN (
        SELECT book_id FROM books
        WHERE price > (
            SELECT avg(price) FROM books
        )
    )
);

SELECT p.customer_id, (
    SELECT sum(quantity) FROM purchase_details
    WHERE purchase_id IN (
        select purchase_id FROM purchases
        WHERE customer_id = p.customer_id
    )
) AS total_quantity FROM purchases p
WHERE (
    SELECT sum(quantity) FROM PURCHASE_DETAILS
    WHERE purchase_id IN (
        SELECT purchase_id FROM purchases
        WHERE customer_id = p.customer_id
    )
) >= 2;
