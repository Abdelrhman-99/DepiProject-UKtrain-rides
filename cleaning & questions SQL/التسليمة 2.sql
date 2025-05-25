-- This query calculates the total number of trips for each month based on the journey_date_id.
select count([transaction_id]) AS trip_count, [month] 
from date join [dbo].[fact_railway] on [dbo].[fact_railway].journey_date_id = date.date_id
group by [month];



-- This query calculates the total number of trips for each month based on the purchase_date_id.
select count([transaction_id]) AS trip_count, [month] 
from date join [dbo].[fact_railway] on [dbo].[fact_railway].[purchase_date_id] = date.date_id
group by [month];




-- This query calculates the average delay time in minutes for each station per month.
SELECT 
    D.[month],
    station AS arrival_station,
    AVG(DATEDIFF(MINUTE, Scheduled.full_time, Actual.full_time)) AS avg_delay_minutes
FROM 
    fact_railway F
JOIN 
    time Actual ON F.actual_arrival_time_id = Actual.time_id
JOIN 
    time Scheduled ON F.arrival_time_id = Scheduled.time_id
JOIN 
    station ArrivalStation ON F.arrival_station_id = ArrivalStation.station_id
JOIN 
    date D ON F.journey_date_id = D.date_id
WHERE DATEDIFF(MINUTE, Scheduled.full_time, Actual.full_time) > 0
GROUP BY 
    D.[month],
    ArrivalStation.station
ORDER BY 
    D.[month],
    avg_delay_minutes DESC;



-- This query calculates the count of delayed trips for each station.
SELECT S.station AS arrival_station, COUNT(*) AS delay_count
FROM fact_railway F
JOIN time Actual ON F.actual_arrival_time_id = Actual.time_id
JOIN time Scheduled ON F.arrival_time_id = Scheduled.time_id
JOIN station S ON F.arrival_station_id = S.station_id
WHERE DATEDIFF(MINUTE, Scheduled.full_time, Actual.full_time) > 0
GROUP BY S.station
ORDER BY delay_count DESC;




-- This query calculates the journey status counts for delayed and canceled trips.
SELECT 
    J.journey_status,
    COUNT(*) AS journey_count 
FROM fact_railway F
JOIN journey J ON F.journey_id = J.journey_id 
GROUP BY J.journey_status
UNION ALL
SELECT 
    journey_status,
    COUNT(*) AS journey_count 
FROM [dbo].[Canceled_railway_trips]
GROUP BY journey_status;




-- This query calculates the count of trips based on the reason for delay.
SELECT 
    J.[reason_for_delay],
    COUNT(*) AS delay_count 
FROM fact_railway F
JOIN journey J ON F.journey_id = J.journey_id 
GROUP BY [reason_for_delay];




-- This query calculates the count of canceled trips based on the reason for cancellation.
SELECT 
    [reason_for_delay],
    COUNT(*) AS delay_count 
FROM Canceled_railway_trips
GROUP BY [reason_for_delay];




-- This query calculates the count of delayed trips for each date.
SELECT 
    D.full_date,  
    COUNT(*) AS status_count
FROM 
    fact_railway F
JOIN 
    journey J ON F.journey_id = J.journey_id
JOIN 
    [dbo].[date] D ON F.journey_date_id = D.date_id  
WHERE J.journey_status IN ('Delayed') 
GROUP BY  D.full_date
ORDER BY status_count DESC;




-- This query calculates the count of delayed trips for each hour and period.
SELECT [hour],[period], COUNT(*) AS status_count
FROM fact_railway F
JOIN time T ON F.arrival_time_id = T.time_id  
JOIN journey J ON F.journey_id = J.journey_id
GROUP BY T.[hour],[period]
ORDER BY status_count DESC;



-- This query calculates the count of delayed or canceled trips by date.
SELECT 
    D.full_date,  
    COUNT(*) AS status_count
FROM fact_railway F
JOIN journey J ON F.journey_id = J.journey_id
JOIN [dbo].[date] D ON F.journey_date_id = D.date_id  
WHERE J.journey_status IN ('Delayed')  
GROUP BY D.full_date
UNION ALL
SELECT 
    [Date_of_Journey], COUNT(*) AS status_count
FROM [dbo].[Canceled_railway_trips] C  
GROUP BY [Date_of_Journey]
ORDER BY status_count DESC;



-- This query calculates the passenger count based on purchase type and payment method.
SELECT p.[purchase_type], p.[payment_method], COUNT([Transaction_ID]) AS passenger_count
FROM fact_railway F
JOIN [dbo].[payment] p ON F.[payment_id] = p.[payment_id]  
GROUP BY p.[purchase_type], p.[payment_method]
ORDER BY passenger_count DESC;



-- This query calculates the passenger count based on ticket type and class.
SELECT t.[ticket_type], t.[ticket_class], t.[railcard], COUNT([Transaction_ID]) AS passenger_count
FROM fact_railway F
JOIN [dbo].[ticket] t ON F.[ticket_id] = t.[ticket_id]
GROUP BY t.[ticket_type], t.[ticket_class], t.[railcard]
ORDER BY passenger_count DESC;




-- This query calculates the passenger count for each arrival station.
SELECT s.[station], COUNT([Transaction_ID]) AS passenger_count
FROM fact_railway F
JOIN [dbo].[station] s ON f.[arrival_station_id] = s.[station_id]
GROUP BY [station] 
ORDER BY passenger_count DESC;




-- This query calculates the passenger count for each departure station.
SELECT s.[station], COUNT([Transaction_ID]) AS passenger_count
FROM fact_railway F
JOIN [dbo].[station] s ON f.[departure_station_id] = s.[station_id]
GROUP BY [station] 
ORDER BY passenger_count DESC;




-- This query calculates the passenger count based on railcard and arrival station.
SELECT s.[station], t.[railcard], COUNT([Transaction_ID]) AS passenger_count
FROM fact_railway F
JOIN [dbo].[ticket] t ON F.[ticket_id] = t.[ticket_id] 
JOIN [dbo].[station] s ON f.[arrival_station_id] = s.[station_id]
GROUP BY [station], [railcard]
ORDER BY passenger_count DESC;



-- This query calculates the passenger count for each hour based on arrival time.
SELECT t.[hour], COUNT([Transaction_ID]) AS passenger_count
FROM fact_railway F
JOIN time t ON f.[arrival_time_id] = t.[time_id]
GROUP BY t.[hour]
ORDER BY passenger_count DESC;



-- This query calculates the passenger count based on purchase type.
SELECT purchase_type, COUNT([Transaction_ID]) AS passenger_count
FROM fact_railway F
JOIN [dbo].[payment] p ON f.[payment_id] = p.payment_id
GROUP BY purchase_type;




-- This query calculates the passenger count based on payment method.
SELECT [payment_method], COUNT([Transaction_ID]) AS passenger_count
FROM fact_railway F
JOIN [dbo].[payment] p ON f.[payment_id] = p.payment_id
GROUP BY [payment_method];



-- This query calculates the passenger count based on ticket type and class.
SELECT [ticket_type], [ticket_class], COUNT([Transaction_ID]) AS passenger_count
FROM [dbo].[ticket] T
JOIN [dbo].[fact_railway] F ON f.ticket_id = t.ticket_id
GROUP BY [ticket_type], [ticket_class];



-- This query calculates the passenger count based on railcard.
SELECT railcard, COUNT([Transaction_ID]) AS passenger_count
FROM [dbo].[ticket] T
JOIN [dbo].[fact_railway] F ON f.ticket_id = t.ticket_id
GROUP BY [railcard];




-- This query calculates the passenger count based on ticket type and railcard.
SELECT [ticket_type], [railcard], COUNT([Transaction_ID]) AS passenger_count
FROM [dbo].[ticket] T
JOIN [dbo].[fact_railway] F ON f.ticket_id = t.ticket_id
GROUP BY [ticket_type], [railcard];



-- This query calculates the total revenue and passenger count for each departure and arrival station.
SELECT DS.station AS departure_station, xS.station AS arrival_station, SUM(F.price) AS total_revenue, COUNT([Transaction_ID]) AS passenger_count   
FROM fact_railway F
JOIN station DS ON F.departure_station_id = DS.station_id  
JOIN station xS ON F.arrival_station_id = xS.station_id    
GROUP BY DS.station, xS.station
ORDER BY total_revenue DESC;






