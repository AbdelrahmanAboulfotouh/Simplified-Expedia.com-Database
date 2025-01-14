-- sign up query
INSERT INTO Users(username,Password,email,user_type)
VALUES  ("Alex","mine2750%#$",'alex7@gamil.com',"Customer");

INSERT INTO Users(username,Password,email,user_type)
VALUES  ("matelda","%#$7894drgfv",'matelda.me,kia@gamil.com',"Customer");

-- View Profile query Knowing user id (e.g. 1) 
SELECT * FROM User_Profile 
WHERE Name =(SELECT username FROM  Users WHERE user_id = 1);
--Make itinerary query 
INSERT INTO Itineraries(user_id,itinerary_name,total_cost_USD)
VALUES(1,"vACATION TO Egypt",200);
    --Flight-itinerary
    INSERT INTO Flights(itinerary_id,departure_city,arrival_city,departure_date,return_date,cost)
    VALUES(1,"cairo","Mossco",'2025-1-15','2025-1-27',50);

    --Car-itinerary
    INSERT INTO Cars(itinerary_id,car_name,rental_company,pickup_location,dropoff_location,pickup_date,dropoff_date,Cost_per_day,total_days,cost)
    VALUES(1,"mazda","united_cars","50-street-downtowm","75-street-dowmtown",'2025-1-17','2025-1-20',5,3,15);
    --Hotel-itinerary
     INSERT INTO Hotels(itinerary_id,hotel_name,location,check_in_date,check_out_date,price_per_night)
     VALUES(1,"Nile redz","downtown-cairo",'2025-1-16','2025-1-26',5);
--List my Itineraries query 
SELECT itinerary_name,total_cost_USD FROM Itineraries 
WHERE user_id = 1;

SELECT * FROM   Cars  
WHERE itinerary_id =(SELECT itinerary_id FROM Itineraries WHERE user_id = 1);

SELECT * FROM   Flights  
WHERE itinerary_id =(SELECT itinerary_id FROM Itineraries WHERE user_id = 1);

SELECT * FROM   Hotels  
WHERE itinerary_id =(SELECT itinerary_id FROM Itineraries WHERE user_id = 1);
