-- Hypotheses Testing- 1: Churn is caused by monetization friction (Free vs Pro)
-- Null Hypothesis (H0)
-- Subscription status has no effect on the bounce rate.
-- Alternative Hypothesis (H1)
-- Subscription status affects the bounce rate.

WITH sessions AS (
  SELECT
    user_pseudo_id,
    subscription_status_p,
    CAST(event_ts AS DATE) AS session_date,
    COUNT(*) AS click_count,
    DATEDIFF(SECOND, MIN(event_ts), MAX(event_ts)) AS duration_sec
  FROM kitegames
  GROUP BY user_pseudo_id, subscription_status_p, CAST(event_ts AS DATE)
),
hypothesis_1 AS (
  SELECT *,
         CASE
           WHEN click_count <= 2 OR duration_sec < 20 THEN 1
           ELSE 0
         END AS is_bounce
  FROM sessions
),
sub_stats AS (
  SELECT
    subscription_status_p,
    COUNT(*) AS n,
    SUM(is_bounce) AS b
  FROM hypothesis_1
  GROUP BY subscription_status_p
),
free AS (
  SELECT * FROM sub_stats WHERE subscription_status_p = 'free'
),
pro AS (
  SELECT * FROM sub_stats WHERE subscription_status_p = 'pro'
)
SELECT
  (free.b * 1.0 / free.n - pro.b * 1.0 / pro.n)
  /
  SQRT(
    ((free.b + pro.b) * 1.0 / (free.n + pro.n))
    * (1 - (free.b + pro.b) * 1.0 / (free.n + pro.n))
    * (1.0 / free.n + 1.0 / pro.n)
  ) AS z_score
FROM free
CROSS JOIN pro;


-- Reject H0 if |z| => 1.96
-- Fail to reject H0