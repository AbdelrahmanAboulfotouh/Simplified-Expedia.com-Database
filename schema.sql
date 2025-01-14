
--CREATE  DATABASE Expedia ;

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT,
    username VARCHAR(255) Unique NOT NULL  ,
    Password  VARCHAR(32) NOT NULL,
    email VARCHAR(255) Unique,
    user_type Enum("Admin","Customer") NOT NULL,
    Primary key(user_id)
);

CREATE TABLE Itineraries(
itinerary_id  INT AUTO_INCREMENT,
user_id INT NOT NULL,
itinerary_name  VARCHAR(255) NOT NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
total_cost_USD DECIMAL(10,2) DEFAULT 0 ,
Primary Key(itinerary_id),
FOREIGN KEY (user_id) REFERENCES Users(user_id)

);

CREATE TABLE Flights(

flight_id INT AUTO_INCREMENT,
itinerary_id INT NOT NULL,
departure_city CHAR(255) NOT NULL,
arrival_city CHAR(255) NOT NULL,
departure_date Date NOT NULL,
return_date Date,
cost DECIMAL(10,2) NOT NULL,
Primary Key(flight_id),
FOREIGN KEY (itinerary_id) REFERENCES Itineraries(itinerary_id)
);
CREATE TABLE Hotels
(

    hotel_id INT AUTO_INCREMENT,
    itinerary_id INT NOT NULL,
    hotel_name CHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    check_in_date Date NOT NULL,
    check_out_date Date NOT NULL,
    price_per_night DECIMAL,

    total_nights INT AS (DATEDIFF(check_out_date, check_in_date)) STORED,
    cost DECIMAL(10, 2) AS (price_per_night * total_nights) STORED,

    Primary Key(hotel_id),
    FOREIGN KEY(itinerary_id) REFERENCES Itineraries(itinerary_id)

);



CREATE TABLE Cars
(

car_id INT AUTO_INCREMENT,
itinerary_id INT NOT NULL,
car_name CHAR(255) NOT NULL,
rental_company CHAR(255) NOT NULL,
pickup_location VARCHAR(255) NOT NULL,
dropoff_location VARCHAR(255) NOT NULL,
pickup_date Date NOT NULL ,
dropoff_date Date NOT NULL ,
Cost_per_day Decimal(10,2) NOT NULL ,
total_days INT NOT NULL,
cost  Decimal(10,2) NOT NULL,
Primary Key(car_id),
FOREIGN KEY(itinerary_id) REFERENCES Itineraries(itinerary_id)

);

CREATE VIEW User_Profile AS
    SELECT username as "Name" ,email AS "E-mail",itinerary_name AS "Itinerary",departure_city AS "Departure_city" ,arrival_city AS "Arrival-City",hotel_name AS "Hotel",car_name as "Car-Name" FROM Itineraries 
    INNER  JOIN
        Users on Users.user_id = Itineraries.user_id
    INNER join 
        Cars on Cars.itinerary_id = Itineraries.itinerary_id
    INNER join 
        Hotels on Hotels.itinerary_id = Itineraries.itinerary_id
    INNER JOIN
        Flights on Flights.itinerary_id = Itineraries.itinerary_id;


CREATE INDEX Users_query_optimizing ON Users(user_id,username);
CREATE INDEX Itineraries_query_optimizing ON Itineraries(user_id,itinerary_id);
CREATE INDEX Flights_query_optimizing ON Flights(itinerary_id);
CREATE INDEX Cars_query_optimizing ON Cars(itinerary_id);
CREATE INDEX Hotels_query_optimizing ON Hotels(itinerary_id);
