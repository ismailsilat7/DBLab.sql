
CREATE TABLE passengers (
    PASSENGER_ID INT PRIMARY KEY,
    PASSENGER_NAME VARCHAR2(100) NOT NULL,
    CITY VARCHAR2(100) NOT NULL
);

CREATE TABLE Buses (
    BUS_ID INT PRIMARY KEY,
    BUS_NAME VARCHAR2(100) NOT NULL,
    CAPACITY INT NOT NULL
);

CREATE TABLE Routes (
    ROUTE_ID INT PRIMARY KEY,
    SOURCE_CITY VARCHAR2(100) NOT NULL,
    DESTINATION_CITY VARCHAR2(100) NOT NULL
);

CREATE TABLE Tickets (
    TICKET_ID INT PRIMARY KEY,
    PASSENGER_ID INT NOT NULL,
    BUS_ID INT NOT NULL,
    ROUTE_ID INT NOT NULL,
    TRAVEL_DATE DATE NOT NULL,
    FARE NUMERIC NOT NULL,
    CONSTRAINT fk_passengers FOREIGN KEY (PASSENGER_ID) REFERENCES passengers(PASSENGER_ID),
    CONSTRAINT fk_buses FOREIGN KEY (BUS_ID) REFERENCES Buses(BUS_ID),
    CONSTRAINT fk_routes FOREIGN KEY (ROUTE_ID) REFERENCES Routes(Route_id)
);

INSERT INTO passengers VALUES (1, 'Ali', 'Karachi');
INSERT INTO passengers VALUES (2, 'Ahmed', 'Lahore');
INSERT INTO passengers VALUES (3, 'Sara', 'Islamabad');
INSERT INTO passengers VALUES (4, 'Ayesha', 'Karachi');

INSERT INTO buses VALUES (101, 'Daewoo Express', 50);
INSERT INTO buses VALUES (102, 'Faisal Movers', 45);
INSERT INTO buses VALUES (103, 'Skyways', 40);

INSERT INTO routes VALUES (201, 'Karachi', 'Lahore');
INSERT INTO routes VALUES (202, 'Lahore', 'Islamabad');
INSERT INTO routes VALUES (203, 'Karachi', 'Islamabad');

INSERT INTO tickets VALUES (1001, 1, 101, 201, DATE '2024-04-01', 2500);
INSERT INTO tickets VALUES (1002, 2, 102, 202, DATE '2024-04-02', 1800);
INSERT INTO tickets VALUES (1003, 3, 103, 203, DATE '2024-04-03', 3000);
INSERT INTO tickets VALUES (1004, 1, 102, 202, DATE '2024-04-04', 2000);
INSERT INTO tickets VALUES (1005, 4, 101, 201, DATE '2024-04-05', 2500);
INSERT INTO tickets VALUES (1006, 2, 101, 201, DATE '2024-04-06', 2500);

SELECT p.passenger_name, b.bus_name, t.travel_date, r.route_id, 
r.source_city, r.destination_city FROM passengers p
JOIN tickets t ON t.passenger_id = p.passenger_id
JOIN routes r ON r.route_id = t.route_id
JOIN buses b ON b.bus_id = t.bus_id;

SELECT p.passenger_name, t.travel_date, t.fare 
FROM tickets t
JOIN passengers p ON p.passenger_id = t.passenger_id;

SELECT b.bus_name, COUNT(p.passenger_id) AS number_of_passengers
FROM buses b
JOIN tickets t ON b.bus_id = t.bus_id
JOIN passengers p ON p.passenger_id = t.passenger_id
GROUP BY b.bus_name;

SELECT t.ticket_id, r.source_city, r.destination_city, p.passenger_name
FROM tickets t
JOIN passengers p ON t.passenger_id = p.passenger_id
JOIN routes r ON r.route_id = t.route_id;

CREATE OR REPLACE view PassengerTravelSummary AS
SELECT p.passenger_name, b.bus_name, r.source_city, r.destination_city, t.travel_date
FROM tickets t
JOIN passengers p ON t.passenger_id = p.passenger_id
JOIN routes r ON r.route_id = t.route_id
JOIN buses b ON b.bus_id = t.bus_id;

SELECT * FROM PassengerTravelSummary;

ALTER TABLE passengers ADD contact_number VARCHAR(15);

ALTER TABLE tickets MODIFY fare DECIMAL(10,2);
DESC tickets;

ALTER TABLE buses DROP column capacity;

DROP TABLE routes; -- wouldn't work