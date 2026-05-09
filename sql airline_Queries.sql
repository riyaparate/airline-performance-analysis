create database airlines;
use airlines;
create table maindata (
   Airline_ID INT,
    Unique_Carrier_Code VARCHAR(10),
    Unique_Carrier_Entity_Code VARCHAR(10),
    Region_Code VARCHAR(10),
    Origin_Airport_ID INT,
    OriginAirportSequenceID INT,
    OriginAirportMarketID INT,
    OriginWorldAreaCode INT,
    DestinationAirportID INT,
    DestinationAirportSequenceID INT,
    DestinationAirportMarketID INT,
    DestinationWorldAreaCode INT,
    AircraftGroupID INT,
    AircraftTypeID INT,
    AircraftConfigurationID INT,
    Distance_GroupID INT,
    ServiceClassID INT,
    DatasourceID INT,
    DeparturesScheduled INT,
    DeparturesPerformed INT,
    Payload DECIMAL(10,2),
    Distance DECIMAL(10,2),
    Available_Seats INT,
    TransportedPassengers INT,
    TransportedFreight DECIMAL(10,2),
    TransportedMail DECIMAL(10,2),
    RampToRampTime INT,
    AirTime INT,
    UniqueCarrier VARCHAR(10),
    CarrierCode VARCHAR(10),
    CarrierName VARCHAR(100),
    OriginAirportCode VARCHAR(10),
    OriginCity VARCHAR(100),
    OriginStateCode VARCHAR(10),
    OriginStateFIPS VARCHAR(10),
    OriginState VARCHAR(50),
    OriginCountryCode VARCHAR(10),
    OriginCountry VARCHAR(50),
    DestinationAirportCode VARCHAR(10),
    DestinationCity VARCHAR(100),
    DestinationStateCode VARCHAR(10),
    DestinationStateFIPS VARCHAR(10),
    DestinationState VARCHAR(50),
    DestinationCountryCode VARCHAR(10),
    DestinationCountry VARCHAR(50),
    Year2 INT,
    Month2 INT,
    Day2 INT,
    FromToAirportCode VARCHAR(20),
    FromToAirportID INT,
    FromToCity VARCHAR(100),
    FromToStateCode VARCHAR(10),
    FromToState VARCHAR(50)
);
select*from maindata;
select count(*) from maindata;

# Q1
# Date
SELECT
    DATE(CONCAT(Year2,'-',Month2,'-',Day2)) AS flight_date
FROM maindata;
ALTER TABLE maindata ADD flight_date DATE;
UPDATE maindata SET flight_date = DATE(CONCAT(Year2,'-',Month2,'-',Day2));

# Month name
select monthname(flight_date) as month_name from maindata;
ALTER TABLE maindata ADD month_name varchar(50);
UPDATE maindata SET month_name=monthname(flight_date);
# QUARTER
select concat("Q" ,"-",quarter(flight_date)) as quarter1 from maindata;
alter table	maindata add quarter1 varchar(50);
update maindata set quarter1=quarter(flight_date);
# YEAR MONTH
select date_format(flight_date,"%y-%b") as year1_month1 from maindata;
alter table	maindata add year1_month1 varchar(50);
update maindata set year1_month1=date_format(flight_date,"%y-%b");
# Weekday
select weekday(flight_date)+1 as WeekdayNo from maindata;
alter table maindata add WeekdayNo varchar(50);
update maindata set WeekdayNo =weekday(flight_date)+1;

# weekdayname
select dayname(flight_date) as weekdayname from maindata;
alter table maindata add weekdayname varchar(50);
update maindata set weekdayname =dayname(flight_date);

# Financial Month
select Case  
    WHEN MONTH(flight_date) >= 4 THEN MONTH(flight_date) - 3
    ELSE MONTH(flight_date) + 9
END AS FinancialMonth
from maindata;
alter table maindata add FinancialMonth varchar(50);
update maindata set FinancialMonth = Case  WHEN MONTH(flight_date) >= 4 THEN MONTH(flight_date) - 3 ELSE MONTH(flight_date) + 9
END;

# FinancialQuarter
select Case when month(flight_date) between 4 and 3 THEN "Q1"
      WHEN MONTH(flight_date) between 7 AND 9 THEN "Q2"
      WHEN MONTH (flight_date) between 9 AND 12 THEN "Q3" ELSE "Q4" END AS FinancialQuarter from maindata;
alter table maindata add FinancialQuarter varchar(50);
update maindata set FinancialQuarter = Case when month(flight_date) between 4 and 3 THEN "Q1"
      WHEN MONTH(flight_date) between 7 AND 9 THEN "Q2"
      WHEN MONTH (flight_date) between 9 AND 12 THEN "Q3" ELSE "Q4" END;
select*from maindata;      
# Q2 Load Factor
select (SUM(TransportedPassengers) / SUM(Available_Seats)) * 100  as loadFactor from maindata;

# year wise
select Year2,(SUM(TransportedPassengers) / SUM(Available_Seats)) * 100  as loadFactor from maindata group by Year2;
# quarter
select Year2, quarter1,(SUM(TransportedPassengers) / SUM(Available_Seats)) * 100  as loadFactor from maindata
 group by Year2,quarter1;
 # Month
 select Month2,(SUM(TransportedPassengers) / SUM(Available_Seats)) * 100  as loadFactor from maindata
 group by Month2 order by Month2;
 
 # Load Factor by Carrier
 select CarrierName,(SUM(TransportedPassengers) / SUM(Available_Seats)) * 100  as loadFactor from maindata
 group by CarrierName  ORDER BY LoadFactor DESC;
 
 # Top 10 Carriers (Passenger Preference)
SELECT
    CarrierName,
    SUM(TransportedPassengers) AS TotalPassengers
FROM maindata
GROUP BY CarrierName
ORDER BY TotalPassengers DESC
LIMIT 10;
 # Top Routes
 select FromToCity2 ,count(Airline_ID) as Flight from maindata group by FromToCity2 order by Flight Desc;

# Weekend vs Weekday Load Factor
SELECT
    CASE 
        WHEN WEEKDAY(flight_date) IN (5,6) THEN 'Weekend'
        ELSE 'Weekday'
    END AS DayType,
    (SUM(TransportedPassengers) / SUM(Available_Seats)) * 100  as loadFactor
FROM maindata
GROUP BY DayType;

# Flights by Distance Group
SELECT
   Distance_Group_ID,
    COUNT(Airline_ID) AS NumberOfFlights
FROM maindata
GROUP BY Distance_Group_ID
ORDER BY Distance_Group_ID;
# drop table maindata;


     


