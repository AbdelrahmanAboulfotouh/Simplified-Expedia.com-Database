# Simplified-Expedia.com-Database Design Documen

Video overview: (Normally there would be a URL here, but not for this sample assignment!)

## Scope

The database for CS50 SQL includes all entities necessary to facilitate the process of tracking student progress and leaving feedback on student work. As such, included in the database's scope is:

* Students, including basic identifying information
* Instructors, including basic identifying information
* Student submissions, including the time at which the submission was made, the correctness score it received, and the problem to which the submission is related
* Problems, which includes basic information about the course's problems
* Comments from instructors, including the content of the comment and the submission on which the comment was left

Out of scope are elements like certificates, final grades, and other non-core attributes.

## Functional Requirements

 **This Database Will Support**:

- **User Management**:
  - Creation of customer and admin accounts.
  - Role-based functionalities (e.g., itinerary management for customers, data oversight for admins).

- **Itinerary Management**:
  - Multiple itineraries per user with custom naming.
  - Automatic cost calculation for itineraries based on associated services.

- **Travel Services**:
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

Per the typical queries in `queries.sql`, it is common for users of the database to access all submissions submitted by any particular student. For that reason, indexes are created on the `first_name`, `last_name`, and `github_username` columns to speed the identification of students by those columns.

Similarly, it is also common practice for a user of the database to concerned with viewing all students who submitted work to a particular problem. As such, an index is created on the `name` column in the `problems` table to speed the identification of problems by name.

## Limitations

The current schema assumes individual submissions. Collaborative submissions would require a shift to a many-to-many relationship between students and submissions.
