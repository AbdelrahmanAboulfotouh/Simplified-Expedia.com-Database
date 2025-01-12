--CREATE  DATABASE Expedia ;

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT  ,
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
    total_nights INT NOT NULL,
    cost Decimal(10,2 ) NOT NULL,
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

CREATE VIEW FULL_VIEW AS
SELECT username,arrival_city,hotel_name,car_name FROM Itineraries 
JOIN Users
