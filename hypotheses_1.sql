-- Hypotheses Testing- 1: Lower Engagement in Editor
-- Null Hypothesis (H0)
-- The average level of engagement is the same for bounce and non-bounce sessions.
-- Alternative Hypothesis (H1)
-- Engagement is much lower during bounce sessions.

WITH sessions AS (
  SELECT
    user_pseudo_id,
    CAST(event_ts AS DATE) AS session_date,
    COUNT(*) AS click_count,
    DATEDIFF(SECOND, MIN(event_ts), MAX(event_ts)) AS duration_sec
  FROM kitegames
  GROUP BY user_pseudo_id, CAST(event_ts AS DATE)
),
hypothesis_1 AS (
  SELECT *,
         CASE
           WHEN click_count <= 2 OR duration_sec < 20 THEN 1
           ELSE 0
         END AS is_bounce
  FROM sessions
)
SELECT
  is_bounce,
  COUNT(*) AS session_count,
  AVG(click_count) AS avg_clicks,
  AVG(duration_sec) AS avg_duration_sec
FROM hypothesis_1
GROUP BY is_bounce;

-- Bounce sessions have lower clicks & duration
-- Fail to reject H0