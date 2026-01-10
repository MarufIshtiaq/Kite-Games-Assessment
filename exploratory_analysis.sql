-- How many events are there?
SELECT COUNT(*) AS total_events
FROM kitegames;

-- How many users?
SELECT COUNT(DISTINCT user_pseudo_id) AS total_users
FROM kitegames;

-- How many sessions?
SELECT COUNT(*) AS total_sessions
FROM (
  SELECT DISTINCT
    user_pseudo_id,
    CAST(event_ts AS DATE) AS session_date
  FROM kitegames
) s;

-- Before defining bounce, what does click behavior look like?
SELECT
  click_count,
  COUNT(*) AS session_count
FROM (
  SELECT
    user_pseudo_id,
    CAST(event_ts AS DATE) AS session_date,
    COUNT(*) AS click_count
  FROM kitegames
  GROUP BY user_pseudo_id, CAST(event_ts AS DATE)
) t
GROUP BY click_count
ORDER BY click_count;

-- Are clicks skewed?
SELECT
  MIN(click_count) AS min_clicks,
  AVG(click_count * 1.0) AS avg_clicks,
  MAX(click_count) AS max_clicks
FROM (
  SELECT
    user_pseudo_id,
    CAST(event_ts AS DATE) AS session_date,
    COUNT(*) AS click_count
  FROM kitegames
  GROUP BY user_pseudo_id, CAST(event_ts AS DATE)
) t;

-- Are duration skewed?
SELECT
  MIN(duration_sec) AS min_duration_sec,
  AVG(duration_sec * 1.0) AS avg_duration_sec,
  MAX(duration_sec) AS max_duration_sec
FROM (
  SELECT
    user_pseudo_id,
    CAST(event_ts AS DATE) AS session_date,
    DATEDIFF(SECOND, MIN(event_ts), MAX(event_ts)) AS duration_sec
  FROM kitegames
  GROUP BY user_pseudo_id, CAST(event_ts AS DATE)
) t;

-- Which tools are most used?
SELECT
  clicked_option,
  COUNT(*) AS usage_count
FROM kitegames
GROUP BY clicked_option
ORDER BY usage_count DESC;

-- Are there obvious differences by version?
-- Sessions by version
SELECT
  version,
  COUNT(*) AS total_sessions
FROM (
  SELECT DISTINCT
    user_pseudo_id,
    CAST(event_ts AS DATE) AS session_date,
    version
  FROM kitegames
) s
GROUP BY version
ORDER BY total_sessions DESC;

-- Average engagement by version
SELECT
  version,
  AVG(click_count * 1.0) AS avg_clicks,
  AVG(duration_sec * 1.0) AS avg_duration_sec
FROM (
  SELECT
    user_pseudo_id,
    CAST(event_ts AS DATE) AS session_date,
    version,
    COUNT(*) AS click_count,
    DATEDIFF(SECOND, MIN(event_ts), MAX(event_ts)) AS duration_sec
  FROM kitegames
  GROUP BY user_pseudo_id, CAST(event_ts AS DATE), version
) t
GROUP BY version
ORDER BY version;

-- Are there obvious differences by country?
SELECT
  country,
  COUNT(*) AS total_sessions,
  AVG(click_count * 1.0) AS avg_clicks,
  AVG(duration_sec * 1.0) AS avg_duration_sec
FROM (
  SELECT
    user_pseudo_id,
    CAST(event_ts AS DATE) AS session_date,
    country,
    COUNT(*) AS click_count,
    DATEDIFF(SECOND, MIN(event_ts), MAX(event_ts)) AS duration_sec
  FROM kitegames
  GROUP BY user_pseudo_id, CAST(event_ts AS DATE), country
) t
GROUP BY country
ORDER BY total_sessions DESC;