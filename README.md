# Simplified Expedia.com Database Design 

Video overview: (Normally there would be a URL here, but not for this sample assignment!)

## Scope

The database for the Expedia.com clone includes all entities necessary to facilitate the process of managing user itineraries and booking travel services. As such, included in the database's scope are:

- **Users**, including basic identifying information and roles (Admin or Customer).  
- **Itineraries**, including details such as itinerary name, associated user, and total cost.  
- **Flights**, including departure and arrival cities, dates, and associated costs.  
- **Hotels**, including hotel details, location, check-in and check-out dates, price per night, and total cost.  
- **Car Rentals**, including rental company, pickup/dropoff locations, rental dates, daily rates, and total cost.  

Out of scope are elements like multi-leg transit flights, advanced payment processing, loyalty programs, and detailed service provider management.

## Functional Requirements

 **This Database Will Support**:

  - Creation of customer and admin accounts.
  - Role-based functionalities (e.g., itinerary management for customers, data oversight for admins).
  - Multiple itineraries per user with custom naming.
  - Automatic cost calculation for itineraries based on associated services.
  - **Flights**: Booking flights with details like cities, dates, and costs.
  - **Hotels**: Booking hotels with check-in/out dates, price per night, and total stay cost.
  - **Car Rentals**: Renting cars with details like company, locations, rental dates, and costs.


## Representation

Entities are captured in MySQL tables with the following schema.

### Entities

The database includes the following entities:

#### Users
  
- **Purpose**: Store information about the application's users (both customers and admins).  
- **The `users` table includes**:
  - `user_id` (Primary Key)
  - `username` (Unique, String)
  - `password` (Hashed, String)
  - `email` (Unique, String)
  - `user_type` (Enum: `Admin`, `Customer`)
    
#### Itineraries

- **Purpose**: Store information about each user's itinerary.  
- **The `Itineraries` table includes**:
     - `itinerary_id` (Primary Key)
     - `user_id` (Foreign Key to `Users.user_id`)
     - `itinerary_name` (String, e.g., "Vacation to Hawaii")
     - `created_at` (Timestamp)
     - `total_cost` (Decimal, Auto-calculated)

#### Flights

   - **Purpose**: Store flight information for itinerary items.  
   - **The `Flights` table includes**:
       - `flight_id` (Primary Key)
       - `itinerary_id` (Foreign Key to `Itineraries.itinerary_id`)
       - `departure_city` (String)
       - `arrival_city` (String)
       - `departure_date` (Date)
       - `return_date` (Date, Nullable for one-way flights)
       - `cost` (Decimal)

#### Hotels

   - **Purpose**: Store hotel booking information for itinerary items.  
   - **The `Flights` table includes**:
     - `hotel_id` (Primary Key)
     - `itinerary_id` (Foreign Key to `Itineraries.itinerary_id`)
     - `hotel_name` (String)
     - `location` (String)
     - `check_in_date` (Date)
     - `check_out_date` (Date)
     - `price_per_night` (Decimal)
     - `total_nights` (Integer, Auto-calculated)
     - `cost` (Decimal, Auto-calculated as `total_nights × price_per_night`)

#### Cars
- **Purpose**: Store car rental information as part of an itinerary.
- **The `cars` table includes**:

  - `car_id` (Primary Key): Unique identifier for the car rental entry.
  - `itinerary_id` (Foreign Key): Links the car rental to a specific itinerary.
  - `car_name` (String): Name of the car or model.
  - `rental_company` (String): Name of the car rental company.
  - `pickup_location` (String): Location where the car is picked up.
  - `dropoff_location` (String): Location where the car is returned.
  - `pickup_date` (Date): Date of car pickup.
  - `dropoff_date` (Date): Date of car drop-off.
  - `daily_rate` (Decimal): Cost per day for renting the car.
  - `total_days` (Integer, Auto-calculated): Number of days the car is rented.
  - `cost` (Decimal, Auto-calculated as `total_days × daily_rate`).


### Relationships

The below entity relationship diagram describes the relationships among the entities in the database.

![ER Diagram](https://github.com/user-attachments/assets/2e1fb72e-7e0a-47dd-8af6-136f2cefba5f)


As detailed by the diagram:

   - One user can have multiple itineraries (1-to-Many relationship).  
   - Each itinerary can have multiple flights (1-to-Many relationship).  
   - Each itinerary can have multiple hotel bookings (1-to-Many relationship).  
   - Each itinerary can have multiple car rentals (1-to-Many relationship).
  



## Optimizations

Based on the common queries performed on the database, the following indexes have been created to optimize query performance:

### Indexes on `Users` Table

**Index Created:**
```sql
CREATE INDEX Users_query_optimizing ON Users(user_id, username);
```
**Reasoning:**
Many queries involve looking up users by their `user_id` to retrieve their profile information (e.g., `SELECT username FROM Users WHERE user_id = 1`). This index speeds up such lookups by indexing both the `user_id` and `username` columns.

### Indexes on `Itineraries` Table

**Index Created:**
```sql
CREATE INDEX Itineraries_query_optimizing ON Itineraries(user_id, itinerary_id);
```
**Reasoning:**
Queries frequently retrieve all itineraries for a specific user (e.g., `SELECT * FROM Itineraries WHERE user_id = 1`). By indexing `user_id` and `itinerary_id`, these queries are optimized to quickly locate itineraries belonging to a particular user.

### Index on `Flights` Table

**Index Created:**
```sql
CREATE INDEX Flights_query_optimizing ON Flights(itinerary_id);
```
**Reasoning:**
Queries often retrieve flights associated with a specific itinerary (e.g., `SELECT * FROM Flights WHERE itinerary_id = 1`). This index enables faster lookups of flights linked to a particular `itinerary_id`.

### Index on `Cars` Table

**Index Created:**
```sql
CREATE INDEX Cars_query_optimizing ON Cars(itinerary_id);
```
**Reasoning:**
Similar to flights, queries frequently involve retrieving cars for a specific itinerary (e.g., `SELECT * FROM Cars WHERE itinerary_id = 1`). Indexing `itinerary_id` in the `Cars` table improves these query speeds.

### Index on `Hotels` Table

**Index Created:**
```sql
CREATE INDEX Hotels_query_optimizing ON Hotels(itinerary_id);
```
**Reasoning:**
Queries commonly request hotel details for a given itinerary (e.g., `SELECT * FROM Hotels WHERE itinerary_id = 1`). This index ensures efficient access to hotel data associated with a particular `itinerary_id`.

### Impact of Indexes

The chosen indexes significantly improve query performance for the following scenarios:

1. **User Profile Retrieval:**
   - Queries like `SELECT username FROM Users WHERE user_id = 1` are optimized by the index on `Users`.

2. **Itinerary Listing:**
   - Queries such as `SELECT itinerary_name, total_cost_USD FROM Itineraries WHERE user_id = 1` benefit from the index on `Itineraries`.

3. **Details for Specific Itineraries:**
   - Queries for flights, cars, and hotels (e.g., `SELECT * FROM Flights WHERE itinerary_id = 1`) are accelerated by the respective indexes on `Flights`, `Cars`, and `Hotels`.

By aligning the indexes with the typical query patterns, the database ensures minimal query latency, better resource utilization, and faster response times for end-users.

### Limitations of the Design:
 
   - The schema does not naturally accommodate complex itineraries with multiple destinations or layovers within the same itinerary.

   - Handling dynamic pricing (e.g., seasonal rates, bulk discounts) or flexible costs (e.g., coupons) is not natively supported and would require additional 
     tables or extensive logic.

   - There is no provision to represent user-specific preferences or historical interactions, such as preferred airlines, types of cars, or hotel chains.

   - The schema does not support historical tracking or analytics (e.g., changes in hotel prices over time or itinerary modifications). Adding audit logs or 
     temporal tables would require additional structures. 

