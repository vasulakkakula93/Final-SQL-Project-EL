Create database AirLine;
use AirLine;

-- Airports table
create table Airports( AirportId int auto_increment primary key, Code varchar(10) not null, AirportName varchar(100) not null, 
City varchar(100) not null, Country varchar(100) not null);

insert into Airports (Code, AirportName, City, Country) values
('JFK', 'John F. Kennedy International Airport', 'New York', 'United States'),
('LHR', 'London Heathrow Airport', 'London', 'United Kingdom'),
('CDG', 'Charles de Gaulle Airport', 'Paris', 'France'),
('DXB', 'Dubai International Airport', 'Dubai', 'United Arab Emirates'),
('HND', 'Haneda Airport', 'Tokyo', 'Japan'),
('DEL', 'Indira Gandhi International Airport', 'New Delhi', 'India'),
('SYD', 'Sydney Kingsford Smith Airport', 'Sydney', 'Australia'),
('CPT', 'Cape Town International Airport', 'Cape Town', 'South Africa'),
('GRU', 'São Paulo–Guarulhos International Airport', 'São Paulo', 'Brazil'),
('SIN', 'Singapore Changi Airport', 'Singapore', 'Singapore');


select * from Airports;

-- Flights Table
 Create table Flights( FlightId int  auto_increment primary key, Airline varchar(100) not null, SourceAirportId  int not null,
 DestinationAirportId int not null, DepartureTime date not null, ArrivalTime date not null , 
 Price decimal(18,2) not null, TotalSeats int not null, AvailableSeats int not null,
 constraint FK_Flights_Source Foreign key (SourceAirportId) references Airports(AirportId),
 constraint FK_Flights_Destination Foreign key (DestinationAirportId) references Airports(AirportId));
 
 insert into Flights (Airline, SourceAirportId, DestinationAirportId, DepartureTime, ArrivalTime, Price, TotalSeats, AvailableSeats)
  values
  ('Emirates', 4, 6, '2025-11-15', '2025-11-15', 380.00, 350, 350),
  ('Air India', 6, 2, '2025-11-17', '2025-11-17', 220.50, 280, 275),
  ('British Airways', 2, 3, '2025-11-20', '2025-11-20', 450.00, 300, 300),
  ('Qatar Airways', 4, 1, '2025-11-22', '2025-11-22', 500.00, 330, 330),
  ('Singapore Airlines', 10, 5, '2025-11-25', '2025-11-25', 420.75, 320, 320),
  ('Cathay Pacific', 8, 4, '2025-11-28', '2025-11-28', 390.00, 310, 310),
  ('Lufthansa', 3, 9, '2025-12-01', '2025-12-01', 460.00, 340, 340),
  ('Qantas', 7, 10, '2025-12-03', '2025-12-03', 430.00, 300, 300),
  ('South African Airways', 9, 8, '2025-12-05', '2025-12-05', 350.00, 290, 290),
  ('IndiGo', 6, 1, '2025-12-08', '2025-12-08', 280.00, 260, 260);

 select * from Flights
 -- Passengers table
create table Passengers( PassengerId int auto_increment primary key,
 FirstName varchar(50) not null,
 LastName varchar(50) not null,
 Email varchar(40) not null,
 phone varchar(20))
 
 insert into Passengers(FirstName, LastName, Email, phone) values
('John','Smith','johnsmith@example.com','+1 202 555 0143 '),
('Mary','Johnson','maryjohnson@example.com','+1 202 555 0102'),
('Raj','Kumar','rajkumar@example.com','+91 98765 43210'),
('Li','Wei','liwei@example.com','+86 10 8888 1234'),
('Anna','Garcia','annagarcia@example.com','+34 91 123 4567'),
('Michael','Brown','michaelbrown@example.com','+1 202 555 0103'),
('Fatima','Al-Mansour','fatimamansour@example.com','+971 2 555 1234'),
('Sven','Eriksson','sveneriksson@example.com','+46 8 123 4567'),
('Olga','Petrova','olgapetrova@example.com','+7 495 123 4567'),
('Carlos','Silva','carlossilva@example.com','+55 11 1234 5678');

 
 select * from Passengers
 
 
 -- Booking Table
create table Bookings(
  BookingId int not null auto_increment,
  FlightId int not null,
  PassengerId int not null,
  Seats int not null,
  BookingDate datetime not null default current_timestamp,
  UId varchar(450),
  Cancalled_Seats int,
  primary key (BookingId),
  constraint FK_Bookings_Flights
    foreign key (FlightId) references Flights(FlightId),
  constraint FK_Bookings_Passengers
    foreign key (PassengerId) references Passengers(PassengerId)
);

insert into Bookings (FlightId, PassengerId, Seats, UId, Cancalled_Seats) values
(1,  1,  2, 'AB12C3', 0),
(1,  2,  1, 'AB12C4', 0),
(2,  3,  3, 'CD45E6', 1),
(3,  4,  1, 'EF78G9', 0),
(4,  5,  2, 'GH01H2', 0),
(5,  6,  4, 'IJ34K5', 2),
(6,  7,  1, 'KL67L8', 0),
(7,  8,  2, 'MN90M1', 0),
(8,  9,  3, 'OP23N4', 1),
(9, 10,  2, 'QR56P7', 0);


alter table Bookings add Cancalled_Seats int;

select * from Bookings

-- For Available Seats with out cancelled seats
select
  f.FlightId,
  f.Airline,
  f.SourceAirportId,
  f.DestinationAirportId,
  f.TotalSeats,
  coalesce(sum(b.Seats),0) as SeatsBooked,
  f.TotalSeats - coalesce(SUM(b.Seats),0) as SeatsStillAvailable
from Flights f
left join Bookings b
  on b.FlightId = f.FlightId
group by f.FlightId, f.Airline, f.SourceAirportId, f.DestinationAirportId, f.TotalSeats;

-- For Available Seats with cancelled seats

select
  f.FlightId,
  f.Airline,
  f.TotalSeats,
  coalesce(sum(b.Seats) - sum(b.Cancalled_Seats),0) as NetBooked,
  f.TotalSeats - (coalesce(sum(b.Seats) - sum(b.Cancalled_Seats),0)) as SeatsStillAvailable
from Flights f
left join Bookings b
  on b.FlightId = f.FlightId
group by f.FlightId, f.Airline, f.TotalSeats;

-- only flightID and airline and available seats based on condition minimum 1 seat 
 
select FlightId, Airline, AvailableSeats
from Flights
where AvailableSeats > 0;

-- Flight Search by source, destination, date

select
  f.FlightId,
  f.Airline,
  f.DepartureTime,
  f.ArrivalTime,
  f.Price,
  sa.Code as SourceCode,
  da.Code as DestCode,
  sa.City as SourceCity,
  da.City as DestCity
from Flights f
join Airports sa on sa.AirportId = f.SourceAirportId
join Airports da on da.AirportId = f.DestinationAirportId
where sa.Code = 'DEL'   
  and da.Code = 'JFK'      
  and f.DepartureTime = '2025-12-08'  
  and f.AvailableSeats >= 1;
  
  -- Search on a date range, and available price
  
  select
  f.FlightId,
  f.Airline,
  f.DepartureTime,
  f.ArrivalTime,
  f.Price,
  f.AvailableSeats
from Flights f
join Airports sa on sa.AirportId = f.SourceAirportId
join Airports da on da.AirportId = f.DestinationAirportId
where sa.Code = 'DEL'
  and da.Code = 'JFK'
  and f.DepartureTime between '2025-12-01' and '2025-12-10'
  and f.AvailableSeats >= 1
order by f.Price asc
limit 5;


-- search by city

  select
  f.FlightId,
  f.Airline,
  sa.City as SourceCity,
  da.City as DestCity,
  f.DepartureTime,
  f.ArrivalTime,
  f.Price,
  f.AvailableSeats
from Flights f
join Airports sa on sa.AirportId = f.SourceAirportId
join Airports da on da.AirportId = f.DestinationAirportId
where sa.City = 'New Delhi'
  and da.City = 'New York'
  and f.DepartureTime = '2025-12-08'
  and f.AvailableSeats >= 1;
  
  -- triggers --
  
    DELIMITER //
--  After a booking is inserted
create trigger trg_booking_insert
after insert on Bookings
for each row
begin
  -- Subtract seats booked from available seats of the flight
  update Flights
    set AvailableSeats = AvailableSeats - new.Seats
    where FlightId = new.FlightId;
end;
//


create trigger trg_booking_update
after update on Bookings
for each row 
begin
  -- Compute how many seats were newly cancelled in this update
  declare delta_cancel int;
  set delta_cancel = (new.Cancalled_Seats - old.Cancalled_Seats);

  if delta_cancel > 0 then
    -- If cancellation has increased, free up seats
    update Flights
      set AvailableSeats = AvailableSeats + delta_cancel
      where FlightId = new.FlightId;
  end if;
end;
//

-- summary

-- Summary per Flight
select
  f.FlightId,
  f.Airline,
  a1.Code as SourceAirport,
  a2.Code as DestinationAirport,
  count(b.BookingId) as NumBookings,
  sum(b.Seats) as TotalSeatsBooked,
  sum(b.Cancalled_Seats) as TotalCancelledSeats,
  sum(b.Seats) - sum(b.Cancalled_Seats) as NetBookedSeats
from Flights f
left join Bookings b on f.FlightId = b.FlightId
left join Airports a1 on f.SourceAirportId = a1.AirportId
left join Airports a2 on f.DestinationAirportId = a2.AirportId
group by f.FlightId, f.Airline, a1.Code, a2.Code
order by f.FlightId;


-- Revenue Summary per Flight

select
  f.FlightId,
  f.Airline,
  a1.Code as Source,
  a2.Code as Destination,
  sum(b.Seats - b.Cancalled_Seats) * f.Price as EstimatedRevenue,
  sum(b.Seats) as SeatsBooked,
  sum(b.Cancalled_Seats) as SeatsCancelled
from Flights f
left join Bookings b on f.FlightId = b.FlightId
left join Airports a1 on f.SourceAirportId = a1.AirportId
left join Airports a2 on f.DestinationAirportId = a2.AirportId
group by f.FlightId, f.Airline, a1.Code, a2.Code;


-- Monthly Booking Summary

select
  date_format(b.BookingDate, '%Y-%m') as BookingMonth,
  count(b.BookingId) as NumBookings,
  sum(b.Seats) as TotalSeatsBooked,
  sum(b.Cancalled_Seats) as TotalSeatsCancelled
from Bookings b
group by date_format(b.BookingDate, '%Y-%m')
order by BookingMonth;

SELECT
  p.PassengerId,
  p.FirstName,
  p.LastName,
  COUNT(b.BookingId) AS BookingCount,
  SUM(b.Seats) AS SeatsBooked,
  SUM(b.Cancalled_Seats) AS SeatsCancelled,
  SUM(b.Seats) - SUM(b.Cancalled_Seats) AS NetSeats
FROM Passengers p
LEFT JOIN Bookings b ON p.PassengerId = b.PassengerId
GROUP BY p.PassengerId, p.FirstName, p.LastName
ORDER BY p.PassengerId;

-- Passenger-wise Booking Summary

select
  p.PassengerId,
  p.FirstName,
  p.LastName,
  count(b.BookingId) as BookingCount,
  sum(b.Seats) as SeatsBooked,
  sum(b.Cancalled_Seats) as SeatsCancelled,
  sum(b.Seats) - sum(b.Cancalled_Seats) as NetSeats
from Passengers p
left join Bookings b on p.PassengerId = b.PassengerId
group by p.PassengerId, p.FirstName, p.LastName
order by p.PassengerId;
