-- Hypotheses Testing- 1: Version Issue
-- Null Hypothesis (H0)
-- All app versions have the same bounce rate.
-- Alternative Hypothesis (H1)
-- The bounce rates of some versions are significantly higher.

WITH sessions AS (
  SELECT
    user_pseudo_id,
    version,
    CAST(event_ts AS DATE) AS session_date,
    COUNT(*) AS click_count,
    DATEDIFF(SECOND, MIN(event_ts), MAX(event_ts)) AS duration_sec
  FROM kitegames
  GROUP BY user_pseudo_id, version, CAST(event_ts AS DATE)
),
hypothesis_1 AS (
  SELECT *,
         CASE
           WHEN click_count <= 2 OR duration_sec < 20 THEN 1
           ELSE 0
         END AS is_bounce
  FROM sessions
),
version_stats AS (
  SELECT
    version,
    COUNT(*) AS n,
    SUM(is_bounce) AS bounces
  FROM hypothesis_1
  GROUP BY version
),
overall AS (
  SELECT
    SUM(bounces) AS total_bounces,
    SUM(n) AS total_n
  FROM version_stats
)
SELECT
  v.version,
  (v.bounces * 1.0 / v.n -
   o.total_bounces * 1.0 / o.total_n)
  /
  SQRT(
    (o.total_bounces * 1.0 / o.total_n) *
    (1 - o.total_bounces * 1.0 / o.total_n) *
    (1.0 / v.n + 1.0 / o.total_n)
  ) AS z_score
FROM version_stats v
CROSS JOIN overall o;


-- Reject H0 if |z| => 1.96
-- Fail to reject H0 for all versions.
-- But accpect H1 only for version 6.4