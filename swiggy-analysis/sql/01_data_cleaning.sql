-- ===================================
-- SWIGGY DATA CLEANING SCRIPT
-- Project: Restaurant Performance Analysis
-- Author: Vara Prasad
-- ===================================

-- Remove duplicates and standardize data
WITH cleaned_restaurants AS (
    SELECT 
        restaurant_id,
        TRIM(restaurant_name) AS restaurant_name,
        TRIM(UPPER(city)) AS city,
        
        -- Handle missing prices
        CASE 
            WHEN price_range IS NULL THEN 'Unknown'
            ELSE price_range 
        END AS price_range,
        
        -- Standardize ratings (0-5 scale)
        CASE 
            WHEN rating > 5 THEN 5.0
            WHEN rating < 0 THEN NULL
            ELSE rating 
        END AS clean_rating,
        
        -- Remove delivery time outliers
        CASE 
            WHEN delivery_time > 120 THEN NULL
            WHEN delivery_time < 10 THEN NULL
            ELSE delivery_time 
        END AS delivery_time,
        
        -- Standardize cuisine categories
        CASE 
            WHEN cuisine LIKE '%North Indian%' THEN 'North Indian'
            WHEN cuisine LIKE '%Chinese%' THEN 'Chinese'
            WHEN cuisine LIKE '%South Indian%' THEN 'South Indian'
            WHEN cuisine LIKE '%Fast Food%' THEN 'Fast Food'
            ELSE cuisine
        END AS cuisine_category
        
    FROM raw_restaurant_data
    WHERE restaurant_name IS NOT NULL
)

-- Final cleaned dataset
SELECT * FROM cleaned_restaurants;

-- Data Quality Check
SELECT 
    COUNT(*) AS total_records,
    COUNT(DISTINCT restaurant_id) AS unique_restaurants,
    COUNT(*) - COUNT(clean_rating) AS missing_ratings,
    COUNT(*) - COUNT(delivery_time) AS missing_delivery_time,
    ROUND(AVG(clean_rating), 2) AS avg_rating,
    ROUND(AVG(delivery_time), 0) AS avg_delivery_mins
FROM cleaned_restaurants;
