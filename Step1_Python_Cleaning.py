# =============================================================
#  STEP 1 — DATA CLEANING & PREPARATION
#  Tool : Python (Pandas & NumPy only)
#  Input : netflix_user_behavior_dataset.csv
#  Output: netflix_cleaned.csv  
# =============================================================

import pandas as pd
import numpy as np

# -----------------------------------------------------------
# 1. LOAD DATA
# -----------------------------------------------------------
df = pd.read_csv('netflix_user_behavior_dataset.csv')

print("---RAW DATA SNAPSHOT ---")
print(f"Rows    : {len(df):,}")
print(f"Columns : {df.shape[1]}")
print()
print(df.head(3).to_string())


# -----------------------------------------------------------
# 2. BASIC QUALITY CHECK
# -----------------------------------------------------------
print("\n--- NULL / MISSING VALUES ---")
print(df.isnull().sum())
# Result: 0 nulls — dataset is clean, no rows need to be dropped

print("\n--- DATA TYPES ---")
print(df.dtypes)


# -----------------------------------------------------------
# 3. CLEAN TEXT COLUMNS
# -----------------------------------------------------------
text_cols = ['gender', 'country', 'subscription_type',
             'primary_device', 'favorite_genre',
             'payment_method', 'churned']

for col in text_cols:
    df[col] = df[col].str.strip().str.title()


# -----------------------------------------------------------
# 4. ADD DERIVED COLUMNS
# -----------------------------------------------------------

# 4a. churned_flag — converts Yes/No to 1/0
df['churned_flag'] = (df['churned'] == 'Yes').astype(int)

# 4b. age_group — bucket ages into segments
bins   = [17, 25, 35, 45, 55, 65]
labels = ['18-25', '26-35', '36-45', '46-55', '56-64']
df['age_group'] = pd.cut(df['age'], bins=bins, labels=labels)

# 4c. annual_fee — monthly fee × 12
df['annual_fee'] = df['monthly_fee'] * 12

# 4d. engagement_score — composite score out of 100
#     (weighted: 40% watch time, 30% completion, 30% sessions)
df['engagement_score'] = (
    (df['avg_watch_time_minutes'] / df['avg_watch_time_minutes'].max() * 40) +
    (df['completion_rate'] / 100 * 30) +
    (df['watch_sessions_per_week'] / df['watch_sessions_per_week'].max() * 30)
).round(2)

# 4e. loyalty_segment — based on how long they've been subscribed
df['loyalty_segment'] = pd.cut(
    df['account_age_months'],
    bins=[0, 12, 24, 60, 999],
    labels=['New (0-12m)', 'Growing (1-2yr)', 'Loyal (2-5yr)', 'Champion (5yr+)']
)


# -----------------------------------------------------------
# 5. FINAL CHECK
# -----------------------------------------------------------
print("\n--- CLEANED DATA — FINAL SHAPE ---")
print(f"Rows    : {len(df):,}")
print(f"Columns : {df.shape[1]}  (added 5 new columns)")
print(f"Nulls   : {df.isnull().sum().sum()}")

print("\n--- SAMPLE — NEW COLUMNS ---")
print(df[['user_id', 'age_group', 'churned_flag',
          'annual_fee', 'engagement_score', 'loyalty_segment']].head(8).to_string())


# -----------------------------------------------------------
# 6. EXPORT — ready for MySQL & Excel
# -----------------------------------------------------------
df.to_csv('netflix_cleaned.csv', index=False)

print("\n✓ netflix_cleaned.csv exported successfully.")
print("  Next step: Import this file into MySQL Workbench.")
