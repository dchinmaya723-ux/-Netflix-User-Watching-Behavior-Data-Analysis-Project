<img width="1287" height="1243" alt="image" src="https://github.com/user-attachments/assets/5feb7e5f-9245-483b-82cd-7094baee5440" />

📌 Project Overview
This project simulates a real-world business analytics task — analyzing Netflix's subscriber base to uncover insights on revenue performance, user engagement, and churn risk. The analysis is structured the way a finance or strategy analyst would approach it: clean the data, query it for business answers, and present findings in a dashboard.
Business context: Netflix's subscriber churn rate directly impacts Annual Recurring Revenue (ARR). This project identifies which segments — by country, subscription tier, age group, device, and genre — are at the highest risk of churning, and quantifies the revenue at stake.

📊 Dataset
PropertyDetailsSourceNetflix User Behavior Dataset (CSV)Rows50,000 usersColumns20 original + 5 derivedCountries10 (USA, India, UK, Brazil, Canada, France, Germany, Spain, Australia, Japan)Subscription TiersBasic, Standard, PremiumGenres8 (Action, Comedy, Drama, Documentary, Thriller, Romance, Horror, Sci-Fi)DevicesMobile, Tablet, Laptop, Smart TV
Key Columns
ColumnDescriptionuser_idUnique subscriber identifierage, gender, countryDemographicssubscription_type, monthly_feeSubscription detailsavg_watch_time_minutesDaily average viewing timewatch_sessions_per_weekWeekly engagement frequencybinge_watch_sessionsCount of binge sessionscompletion_rate% of content watched to completiondays_since_last_loginRecency indicator (churn signal)churnedWhether the user churned (Yes/No)churned_flag (derived)Binary churn flag (1 = churned)age_group (derived)Age bucket (18–25, 26–35, etc.)engagement_score (derived)Composite score out of 100loyalty_segment (derived)New / Growing / Loyal / Championannual_fee (derived)Monthly fee × 12

🛠 Tech Stack
ToolPurposePython (Pandas, NumPy)Data cleaning, derived column creation, CSV exportMySQL WorkbenchBusiness queries, aggregations, churn analysis, CTEsMicrosoft Excel 365Interactive dashboard, pivot tables, charts

Note: No machine learning or advanced Python libraries used — this project is intentionally designed for analysts with a business/finance background.


📁 Project Structure
netflix-behavior-analysis/
│
├── data/
│   ├── netflix_user_behavior_dataset.csv   ← Raw dataset
│   └── netflix_cleaned.csv                 ← Cleaned & enriched dataset
│
├── python/
│   └── Step1_Python_Cleaning.py            ← Data cleaning script
│
├── sql/
│   └── Step2_MySQL_Analysis.sql            ← All 10 business queries
│
├── dashboard/
│   ├── Netflix_Dashboard.xlsx              ← Excel dashboard (6 sheets)
│   └── netflix_dashboard.html              ← Interactive HTML dashboard
│
└── README.md

🔄 Workflow
Raw CSV  ──►  Python (Clean)  ──►  MySQL (Analyse)  ──►  Excel (Dashboard)

Python — Load raw CSV, fix data types, strip whitespace, add 5 derived columns, export netflix_cleaned.csv
MySQL — Import cleaned CSV, run 10 business queries covering revenue, churn, engagement, and risk
Excel — Import data, build pivot tables, create 6 charts, design executive dashboard


❓ Key Business Questions

What is our overall churn rate and how much revenue is at risk?
Which subscription tier generates the most revenue?
Do higher-paying subscribers engage more with the platform?
Which country has the highest churn rate?
Which genre drives the most watch time and lowest churn?
Which device produces the most engaged users?
Which age group is most likely to churn?
What behavioral differences exist between churned and active users?
Are long-term subscribers more loyal than newer ones?
Which country–tier combinations represent the highest revenue risk?


📈 Key Findings
Revenue

Total monthly revenue: $616,167 | Estimated ARR: ~$7.4M
Standard tier contributes the highest monthly revenue (~$246K) despite not being the most expensive tier
Premium tier has the highest churn rate (20.4%) — higher price does not equal higher loyalty

Churn

Overall churn rate: 19.9% — approximately 10,000 users churning per month
Australia has the highest churn rate (21.0%); USA has the lowest (19.2%)
36–45 age group churns the most (20.4%); 46–55 age group is the most loyal (19.5%)
Churned users show higher days_since_last_login — recency is the strongest churn signal

Engagement

Comedy genre leads in average watch time (157.4 min/day); Drama has the lowest churn (19.4%)
Tablet users have the highest average watch time (155.3 min/day)
All subscription tiers show similar engagement scores — usage does not scale with price paid

Risk

Revenue at risk per month (from churning users): ~$122,600 across all markets
Highest single-market risk: Australia ($12,885/month at risk)


📊 Dashboard Preview
The Excel dashboard (Netflix_Dashboard.xlsx) contains 6 sheets:
SheetContentsDashboardExecutive summary — KPI cards, 4 charts, key findings tableRevenue AnalysisTier P&L, engagement scorecard, 2 chartsChurn AnalysisCountry churn table, revenue at risk, risk ratings, bar chartGenre & DeviceGenre & device scorecards, 2 chartsAge AnalysisAge segment breakdown, line + bar chartsRaw DataAll 50,000 cleaned rows (pivot-table ready)
The HTML dashboard (netflix_dashboard.html) is an interactive browser-based version with filter pills for subscription tier and country.

🚀 How to Run
Prerequisites

Python 3.8+ with pandas and numpy
MySQL Workbench (any recent version)
Microsoft Excel 365

Step 1 — Clean the Data (Python)
bash# Place the raw CSV in the same folder as the script
python Step1_Python_Cleaning.py
# Output: netflix_cleaned.csv
Step 2 — Load into MySQL
Option A — Wizard (recommended):

Open MySQL Workbench → right-click your schema → Table Data Import Wizard
Select netflix_cleaned.csv → table name: netflix_users → Finish

Option B — Python script:
bashpip install mysql-connector-python
# Update host/user/password in the script, then run:
python import_to_mysql.py
Step 3 — Run SQL Queries
sqlUSE netflix_project;
-- Open Step2_MySQL_Analysis.sql in MySQL Workbench and run all queries
Step 4 — Open the Dashboard

Excel: Open Netflix_Dashboard.xlsx directly in Excel 365
HTML: Open netflix_dashboard.html in any browser (no install needed)


💼 Skills Demonstrated

Data Cleaning — Handling text normalization, type conversion, derived column engineering
Exploratory Data Analysis (EDA) — Distributions, aggregations, cross-segment comparison
SQL — GROUP BY, HAVING, window functions (SUM() OVER()), CTEs, multi-table logic
Business Analysis — Revenue segmentation, churn modeling, revenue-at-risk quantification
Data Visualization — Bar charts, line charts, pie charts, bubble maps in Excel
Dashboard Design — Multi-sheet Excel workbook with KPI cards, color-coded tables, and embedded charts
Storytelling with Data — Translating raw numbers into business recommendations
