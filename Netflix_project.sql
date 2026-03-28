CREATE DATABASE netflix_project;

USE netflix_project;

SELECT COUNT(*)        AS total_rows,
       COUNT(DISTINCT country) AS countries,
       COUNT(DISTINCT subscription_type) AS tiers
FROM netflix_cleaned;

-- =============================================================
--  QUERY 1 — KPI SNAPSHOT
-- =============================================================
SELECT
    COUNT(*)                                      AS total_subscribers,
    ROUND(AVG(churned_flag) * 100, 1)             AS overall_churn_rate_pct,
    ROUND(AVG(monthly_fee), 2)                    AS avg_monthly_fee_usd,
    ROUND(SUM(monthly_fee), 0)                    AS total_monthly_revenue_usd,
    ROUND(SUM(monthly_fee) * 12, 0)               AS estimated_arr_usd,
    ROUND(AVG(avg_watch_time_minutes), 1)         AS avg_daily_watch_min,
    ROUND(AVG(watch_sessions_per_week), 1)        AS avg_sessions_per_week,
    ROUND(AVG(completion_rate), 1)                AS avg_completion_rate_pct
FROM netflix_cleaned;

-- =============================================================
--  QUERY 2 — REVENUE BREAKDOWN BY SUBSCRIPTION TIER
--  Think of this as a segment P&L
-- =============================================================
SELECT
    subscription_type,
    COUNT(*)                                      AS subscribers,
    ROUND(AVG(monthly_fee), 2)                    AS avg_fee_usd,
    ROUND(SUM(monthly_fee), 0)                    AS monthly_revenue_usd,
    ROUND(SUM(monthly_fee) * 12, 0)               AS annual_revenue_usd,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS subscriber_share_pct,
    ROUND(SUM(monthly_fee) * 100.0
          / SUM(SUM(monthly_fee)) OVER(), 1)      AS revenue_share_pct,
    ROUND(AVG(churned_flag) * 100, 1)             AS churn_rate_pct
FROM netflix_cleaned
GROUP BY subscription_type
ORDER BY monthly_revenue_usd DESC;

-- =============================================================
--  QUERY 3 — CHURN RATE BY COUNTRY (with Revenue at Risk)
--  "Revenue at Risk" = what we lose if churned users leave
-- =============================================================
SELECT
    country,
    COUNT(*)                                      AS total_users,
    SUM(churned_flag)                             AS churned_users,
    ROUND(AVG(churned_flag) * 100, 1)             AS churn_rate_pct,
    ROUND(SUM(monthly_fee), 0)                    AS monthly_revenue_usd,
    ROUND(SUM(CASE WHEN churned = 'Yes'
                   THEN monthly_fee ELSE 0 END), 0) AS revenue_at_risk_usd
FROM netflix_cleaned
GROUP BY country
ORDER BY churn_rate_pct DESC;

-- =============================================================
--  QUERY 4 — ENGAGEMENT BY SUBSCRIPTION TIER
--  Do higher-paying users actually use the platform more?
-- =============================================================
SELECT
    subscription_type,
    ROUND(AVG(avg_watch_time_minutes), 1)         AS avg_watch_time_min,
    ROUND(AVG(watch_sessions_per_week), 1)        AS avg_sessions_week,
    ROUND(AVG(binge_watch_sessions), 1)           AS avg_binge_sessions,
    ROUND(AVG(completion_rate), 1)                AS avg_completion_pct,
    ROUND(AVG(recommendation_click_rate), 1)      AS avg_rec_click_rate,
    ROUND(AVG(engagement_score), 1)               AS avg_engagement_score
FROM netflix_cleaned
GROUP BY subscription_type
ORDER BY avg_engagement_score DESC;

-- =============================================================
--  QUERY 5 — GENRE PERFORMANCE SCORECARD
--  Which genres drive the most watch time and lowest churn?
-- =============================================================
SELECT
    favorite_genre,
    COUNT(*)                                      AS users,
    ROUND(AVG(avg_watch_time_minutes), 1)         AS avg_watch_time_min,
    ROUND(AVG(completion_rate), 1)                AS avg_completion_pct,
    ROUND(AVG(binge_watch_sessions), 1)           AS avg_binge_sessions,
    ROUND(AVG(rating_given), 2)                   AS avg_rating,
    ROUND(AVG(churned_flag) * 100, 1)             AS churn_rate_pct
FROM netflix_cleaned
GROUP BY favorite_genre
ORDER BY avg_watch_time_min DESC;

-- =============================================================
--  QUERY 6 — DEVICE ANALYSIS
--  Which device has the most engaged users?
-- =============================================================
SELECT
    primary_device,
    COUNT(*)                                      AS users,
    ROUND(AVG(avg_watch_time_minutes), 1)         AS avg_watch_time_min,
    ROUND(AVG(completion_rate), 1)                AS avg_completion_pct,
    ROUND(AVG(watch_sessions_per_week), 1)        AS avg_sessions_week,
    ROUND(AVG(churned_flag) * 100, 1)             AS churn_rate_pct
FROM netflix_cleaned
GROUP BY primary_device
ORDER BY avg_watch_time_min DESC;

-- =============================================================
--  QUERY 7 — AGE GROUP ANALYSIS
--  Who are our most and least engaged age segments?
-- =============================================================
SELECT
    age_group,
    COUNT(*)                                      AS users,
    ROUND(AVG(monthly_fee), 2)                    AS avg_fee_usd,
    ROUND(AVG(avg_watch_time_minutes), 1)         AS avg_watch_time_min,
    ROUND(AVG(binge_watch_sessions), 1)           AS avg_binge_sessions,
    ROUND(AVG(completion_rate), 1)                AS avg_completion_pct,
    ROUND(AVG(churned_flag) * 100, 1)             AS churn_rate_pct
FROM netflix_cleaned
GROUP BY age_group
ORDER BY age_group;

-- =============================================================
--  QUERY 8 — CHURNED vs ACTIVE: BEHAVIORAL COMPARISON
--  Key insight: what behaviour differs between churned & active?
-- =============================================================
SELECT
    churned                                       AS status,
    COUNT(*)                                      AS users,
    ROUND(AVG(avg_watch_time_minutes), 1)         AS avg_watch_time_min,
    ROUND(AVG(watch_sessions_per_week), 1)        AS avg_sessions_week,
    ROUND(AVG(binge_watch_sessions), 1)           AS avg_binge_sessions,
    ROUND(AVG(completion_rate), 1)                AS avg_completion_pct,
    ROUND(AVG(days_since_last_login), 1)          AS avg_days_inactive,
    ROUND(AVG(recommendation_click_rate), 1)      AS avg_rec_clicks,
    ROUND(AVG(engagement_score), 1)               AS avg_engagement_score
FROM netflix_cleaned
GROUP BY churned; 

-- =============================================================
--  QUERY 9 — LOYALTY SEGMENT ANALYSIS
--  Are long-term subscribers more valuable and less likely to churn?
-- =============================================================
SELECT
    loyalty_segment,
    COUNT(*)                                      AS users,
    ROUND(AVG(monthly_fee), 2)                    AS avg_fee_usd,
    ROUND(SUM(monthly_fee), 0)                    AS monthly_revenue_usd,
    ROUND(AVG(engagement_score), 1)               AS avg_engagement_score,
    ROUND(AVG(churned_flag) * 100, 1)             AS churn_rate_pct
FROM netflix_cleaned
GROUP BY loyalty_segment
ORDER BY FIELD(loyalty_segment,
    'New (0-12m)', 'Growing (1-2yr)',
    'Loyal (2-5yr)', 'Champion (5yr+)');


-- =============================================================
--  QUERY 10 — TOP 5 HIGH-RISK SEGMENTS (CTE)
--  A CTE (Common Table Expression) chains two steps together.
--  Step 1: calculate churn + revenue per country+tier combo
--  Step 2: rank and filter to top 5 highest risk segments
--  This is the kind of query you'd use in a risk report.
-- =============================================================
WITH segment_risk AS (
    SELECT
        country,
        subscription_type,
        COUNT(*)                                  AS users,
        ROUND(AVG(churned_flag) * 100, 1)         AS churn_rate_pct,
        ROUND(SUM(monthly_fee), 0)                AS monthly_revenue_usd,
        ROUND(SUM(CASE WHEN churned = 'Yes'
                       THEN monthly_fee ELSE 0 END), 0) AS revenue_at_risk_usd
    FROM netflix_cleaned
    GROUP BY country, subscription_type
    )
SELECT *
FROM segment_risk
ORDER BY revenue_at_risk_usd DESC
LIMIT 10;


-- =============================================================
--  EXPORT QUERIES FOR EXCEL DASHBOARD
--  Run each of these, then: right-click result → Export → CSV
--  You'll get clean CSVs to build pivot tables in Excel.
-- =============================================================

-- Export 1: Revenue by tier (for pie/bar chart)
SELECT subscription_type, COUNT(*) AS subscribers,
       ROUND(SUM(monthly_fee),0) AS monthly_revenue,
       ROUND(AVG(churned_flag)*100,1) AS churn_rate_pct
FROM netflix_cleaned GROUP BY subscription_type;

-- Export 2: Churn by country (for map or bar chart)
SELECT country,
       ROUND(AVG(churned_flag)*100,1) AS churn_rate_pct,
       ROUND(SUM(monthly_fee),0) AS monthly_revenue
FROM netflix_cleaned GROUP BY country ORDER BY churn_rate_pct DESC;

-- Export 3: Genre scorecard (for bar chart)
SELECT favorite_genre,
       ROUND(AVG(avg_watch_time_minutes),1) AS avg_watch_time,
       ROUND(AVG(completion_rate),1) AS avg_completion,
       ROUND(AVG(churned_flag)*100,1) AS churn_rate_pct
FROM netflix_cleaned GROUP BY favorite_genre ORDER BY avg_watch_time DESC;

-- Export 4: Age group summary (for line chart)
SELECT age_group,
       ROUND(AVG(churned_flag)*100,1) AS churn_rate_pct,
       ROUND(AVG(avg_watch_time_minutes),1) AS avg_watch_time,
       ROUND(AVG(engagement_score),1) AS avg_engagement
FROM netflix_cleaned GROUP BY age_group ORDER BY age_group;

-- Export 5: Full cleaned data (for Excel pivot tables)
SELECT * FROM netflix_cleaned;