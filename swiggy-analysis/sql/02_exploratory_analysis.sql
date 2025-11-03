-- ===================================
-- SWIGGY EXPLORATORY ANALYSIS
-- Key Business Insights
-- ===================================

-- 1. CITY-WISE RESTAURANT DISTRIBUTION
SELECT 
    city,
    COUNT(*) AS restaurant_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage,
    AVG(rating) AS avg_rating,
    AVG(avg_price) AS avg_price
FROM cleaned_restaurants
GROUP BY city
ORDER BY restaurant_count DESC
LIMIT 10;

-- 2. TOP CUISINES BY POPULARITY
SELECT 
    cuisine_category,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(rating), 2) AS avg_rating,
    COUNT(CASE WHEN rating >= 4.0 THEN 1 END) AS high_rated_count,
    ROUND(COUNT(CASE WHEN rating >= 4.0 THEN 1 END) * 100.0 / COUNT(*), 2) AS high_rated_percentage
FROM cleaned_restaurants
GROUP BY cuisine_category
ORDER BY restaurant_count DESC
LIMIT 10;

-- 3. PRICE SEGMENT ANALYSIS
SELECT 
    CASE 
        WHEN avg_price < 200 THEN 'Budget'
        WHEN avg_price BETWEEN 200 AND 500 THEN 'Mid-Range'
        ELSE 'Premium'
    END AS price_segment,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(AVG(delivery_time), 0) AS avg_delivery_mins,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS market_share
FROM cleaned_restaurants
GROUP BY price_segment
ORDER BY 
    CASE price_segment
        WHEN 'Budget' THEN 1
        WHEN 'Mid-Range' THEN 2
        WHEN 'Premium' THEN 3
    END;

-- 4. DELIVERY PERFORMANCE VS RATING
SELECT 
    CASE 
        WHEN delivery_time <= 30 THEN 'Fast (<30 min)'
        WHEN delivery_time <= 45 THEN 'Standard (30-45 min)'
        ELSE 'Slow (>45 min)'
    END AS delivery_category,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM cleaned_restaurants
WHERE delivery_time IS NOT NULL
GROUP BY delivery_category
ORDER BY avg_rating DESC;

-- 5. TIER-1 VS TIER-2 CITY COMPARISON
WITH city_tier AS (
    SELECT 
        *,
        CASE 
            WHEN city IN ('BANGALORE', 'MUMBAI', 'DELHI', 'HYDERABAD', 'PUNE', 'CHENNAI') 
            THEN 'Tier-1'
            ELSE 'Tier-2'
        END AS city_tier
    FROM cleaned_restaurants
)
SELECT 
    city_tier,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(AVG(avg_price), 0) AS avg_price,
    ROUND(AVG(delivery_time), 0) AS avg_delivery_mins,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS market_share
FROM city_tier
GROUP BY city_tier;

-- 6. TOP PERFORMING RESTAURANTS
SELECT 
    restaurant_name,
    city,
    cuisine_category,
    rating,
    avg_price,
    delivery_time,
    RANK() OVER (ORDER BY rating DESC, total_ratings DESC) AS performance_rank
FROM cleaned_restaurants
WHERE rating >= 4.5
ORDER BY performance_rank
LIMIT 20;
