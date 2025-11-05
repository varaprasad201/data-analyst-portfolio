# 📖 Data Dictionary - Uber Trip Analysis

## Fact Table: Uber_Trip_Details

| Column Name | Data Type | Description | Example | Constraints |
|------------|-----------|-------------|---------|-------------|
| **Trip_ID** | Integer | Unique identifier for each trip | 93372 | Primary Key, Not Null |
| **Pickup_Date** | Date | Date when trip started | 26 June 2024 | Not Null |
| **Pickup_Hour** | Time | Exact time of pickup (HH:MM:SS) | 00:00:01 | Format: HH:MM:SS |
| **Dropoff_Time** | DateTime | Date and time when trip ended | 26 June 2024 00:22:15 | - |
| **Passenger_Count** | Integer | Number of passengers in the trip | 1, 2, 5 | Range: 1-6 |
| **Trip_Distance** | Decimal | Distance traveled in miles | 2.24, 13.79 | > 0 |
| **PULocationID** | Integer | Pickup location identifier | 79, 226 | Foreign Key → Location |
| **DOLocationID** | Integer | Drop-off location identifier | 226, 79 | Foreign Key → Location |
| **Fare_Amount** | Currency | Base fare charged (USD) | $10.00, $45.26 | > 0 |
| **Surge_Fee** | Currency | Additional surge pricing (USD) | $0, $2.00 | >= 0 |
| **Vehicle_Type** | Text | Type of Uber vehicle | UberX, Uber Comfort, Uber Black | Predefined values |
| **Payment_Type** | Text | Payment method used | Cash, Uber Pay, Card, Wallet | Predefined values |

## Dimension Table: Location

| Column Name | Data Type | Description | Example | Constraints |
|------------|-----------|-------------|---------|-------------|
| **LocationID** | Integer | Unique location identifier | 1, 2, 79 | Primary Key, Not Null |
| **Location** | Text | Name of the location/neighborhood | Newark Airport, Penn Station | Not Null |
| **City** | Text | City name | Newark, New Jersey / New York | Not Null |

## Calculated Columns

| Column Name | Formula/Logic | Description |
|------------|---------------|-------------|
| **Total_Booking_Value** | Fare_Amount + Surge_Fee | Total revenue per trip |
| **Trip_Duration_Minutes** | DATEDIFF(Pickup_Hour, Dropoff_Time, MINUTE) | Time taken for trip in minutes |
| **Trip_Type** | IF(HOUR(Pickup_Hour) >= 6 AND <= 18, "Day", "Night") | Classifies trip as Day or Night |
| **Pickup_Day_Name** | FORMAT(Pickup_Date, "dddd") | Day of week (Monday-Sunday) |
| **Pickup_Hour_Only** | HOUR(Pickup_Hour) | Hour extracted (0-23) |
| **Pickup_10Min_Interval** | Rounded 10-minute time blocks | Groups time into intervals |

## Key Measures (DAX)

| Measure Name | Purpose | Example Output |
|-------------|---------|----------------|
| **Total Bookings** | COUNT of Trip_ID | 104,000 |
| **Total Booking Value** | SUM(Fare_Amount + Surge_Fee) | $1.55M |
| **Average Booking Value** | AVERAGE(Total_Booking_Value) | $14.98 |
| **Total Trip Distance** | SUM(Trip_Distance) | 348.9K miles |
| **Average Trip Distance** | AVERAGE(Trip_Distance) | 3.4 miles |
| **Average Trip Time** | AVERAGE(Trip_Duration_Minutes) | 16 min |
| **Selected Measure** | Dynamic measure based on slicer | Varies |

## Value Lists

### Vehicle Types
- **UberX** - Standard economy option
- **Uber Comfort** - Mid-tier comfort option
- **Uber Black** - Premium luxury sedan
- **UberXL** - SUV for larger groups
- **Uber Green** - Eco-friendly hybrid/electric

### Payment Types
- **Uber Pay** - In-app payment (66%)
- **Cash** - Cash payment (26%)
- **Card** - Credit/Debit card (7%)
- **Wallet** - Digital wallet (1%)

### Trip Types
- **Day** - Trips between 6:00 AM - 5:59 PM
- **Night** - Trips between 6:00 PM - 5:59 AM

## Data Quality Notes

- **Missing Values**: No null values in critical fields (Trip_ID, Dates, Amounts)
- **Outliers**: Trips over 100 miles flagged for review
- **Data Range**: June 1-30, 2024
- **Granularity**: Trip-level (one row per trip)
- **Update Frequency**: Daily batch updates
- **Total Records**: 104,678 trips

## Relationships

```
Uber_Trip_Details [PULocationID] ──(Many-to-One)──► Location [LocationID] (ACTIVE)
Uber_Trip_Details [DOLocationID] ──(Many-to-One)──► Location [LocationID] (INACTIVE)
```

**Note**: The DOLocationID relationship is inactive by default. Use `USERELATIONSHIP()` in DAX to activate for drop-off analysis.

---

*Data Dictionary Version 1.0 | Last Updated: November 2025*
