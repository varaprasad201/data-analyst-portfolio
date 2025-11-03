# Data Dictionary - Swiggy Restaurant Dataset

## Dataset Overview
- **Total Records**: 8,680 restaurants
- **Time Period**: [Specify]
- **Geographic Coverage**: 15+ major Indian cities

## Field Descriptions

| Column Name | Data Type | Description | Example Values |
|------------|-----------|-------------|----------------|
| `restaurant_id` | Integer | Unique identifier for each restaurant | 1, 2, 3... |
| `restaurant_name` | String | Name of the restaurant | "Domino's Pizza", "KFC" |
| `city` | String | City location | "Bangalore", "Mumbai", "Delhi" |
| `locality` | String | Specific area/neighborhood | "Koramangala", "Andheri" |
| `cuisine` | String | Type of cuisine(s) offered | "North Indian, Chinese", "Fast Food" |
| `avg_price` | Integer | Average price for two people (₹) | 300, 450, 700 |
| `price_range` | String | Categorized price bracket | "Budget", "Mid-Range", "Premium" |
| `rating` | Decimal | Customer rating (0-5 scale) | 3.8, 4.2, 4.5 |
| `total_ratings` | Integer | Number of ratings received | 1250, 3400, 567 |
| `delivery_time` | Integer | Average delivery time (minutes) | 30, 45, 60 |
| `food_type` | String | Category of food items | "Biryani", "Pizza", "Burger" |
| `is_open` | Boolean | Restaurant operational status | TRUE, FALSE |
| `has_online_delivery` | Boolean | Online delivery availability | TRUE, FALSE |
| `latitude` | Decimal | Geographic coordinate | 12.9716 |
| `longitude` | Decimal | Geographic coordinate | 77.5946 |

## Data Quality Notes

### Handled Issues:
- **Missing Values**: Imputed or flagged as "Unknown"
- **Duplicates**: Removed based on restaurant_id
- **Outliers**: Ratings >5 capped at 5.0, delivery time >120 min flagged
- **Inconsistencies**: Cuisine names standardized

### Data Validation Rules:
- Rating must be between 0 and 5
- Delivery time realistic range: 15-120 minutes
- Price must be positive integer
- City names standardized to title case

## Data Sources
- Primary: Swiggy platform data
- Secondary: Public food delivery datasets
- Note: Data anonymized for portfolio purposes
