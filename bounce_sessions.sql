-- Bounce by Country
WITH sessions AS (
  SELECT
    event_date,
    user_pseudo_id,
    version,
    country,
    install_source,
    subscription_status_p,
    COUNT(*) AS click_count,
    DATEDIFF(SECOND, MIN(event_ts), MAX(event_ts)) AS duration_sec
  FROM kitegames
  GROUP BY 
    event_date,
    user_pseudo_id,
    version,
    country,
    install_source,
    subscription_status_p
),
calculated_sessions AS (
  SELECT *,
         CASE 
           WHEN click_count <= 2 OR duration_sec < 20 THEN 1
           ELSE 0
         END AS is_bounce
  FROM sessions
)
SELECT country, (AVG(is_bounce * 1.0)) *100 AS bounce_rate
FROM calculated_sessions
GROUP BY country
ORDER BY bounce_rate DESC;

-- Bounce by Version
WITH sessions AS (
  SELECT
    event_date,
    user_pseudo_id,
    version,
    country,
    install_source,
    subscription_status_p,
    COUNT(*) AS click_count,
    DATEDIFF(SECOND, MIN(event_ts), MAX(event_ts)) AS duration_sec
  FROM kitegames
  GROUP BY 
    event_date,
    user_pseudo_id,
    version,
    country,
    install_source,
    subscription_status_p
),
calculated_sessions AS (
  SELECT *,
         CASE 
           WHEN click_count <= 2 OR duration_sec < 20 THEN 1
           ELSE 0
         END AS is_bounce
  FROM sessions
)
SELECT version, (AVG(is_bounce * 1.0)) *100 AS bounce_rate
FROM calculated_sessions
GROUP BY version;

-- Bounce by Installation Source
WITH sessions AS (
  SELECT
    event_date,
    user_pseudo_id,
    version,
    country,
    install_source,
    subscription_status_p,
    COUNT(*) AS click_count,
    DATEDIFF(SECOND, MIN(event_ts), MAX(event_ts)) AS duration_sec
  FROM kitegames
  GROUP BY 
    event_date,
    user_pseudo_id,
    version,
    country,
    install_source,
    subscription_status_p
),
calculated_sessions AS (
  SELECT *,
         CASE 
           WHEN click_count <= 2 OR duration_sec < 20 THEN 1
           ELSE 0
         END AS is_bounce
  FROM sessions
)
SELECT install_source, (AVG(is_bounce * 1.0)) *100 AS bounce_rate
FROM calculated_sessions
GROUP BY install_source;

-- Bounce by Subscription Status
WITH sessions AS (
  SELECT
    event_date,
    user_pseudo_id,
    version,
    country,
    install_source,
    subscription_status_p,
    COUNT(*) AS click_count,
    DATEDIFF(SECOND, MIN(event_ts), MAX(event_ts)) AS duration_sec
  FROM kitegames
  GROUP BY 
    event_date,
    user_pseudo_id,
    version,
    country,
    install_source,
    subscription_status_p
),
calculated_sessions AS (
  SELECT *,
         CASE 
           WHEN click_count <= 2 OR duration_sec < 20 THEN 1
           ELSE 0
         END AS is_bounce
  FROM sessions
)
SELECT subscription_status_p, (AVG(is_bounce * 1.0)) *100 AS bounce_rate
FROM calculated_sessions
GROUP BY subscription_status_p;