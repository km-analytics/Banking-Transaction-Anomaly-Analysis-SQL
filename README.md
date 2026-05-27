# Banking Transaction Anomaly Analysis using SQL

SQL-driven fraud detection and transaction monitoring portfolio project inspired by real-world banking transaction patterns in BFSI environments.

This project simulates fraud monitoring use cases including:

- Velocity Burst Detection
- Structuring / Smurfing Detection
- Account Takeover (ATO)
- Geo / Device Mismatch
- New Beneficiary Risk
- Mule Account Behaviour
- Transaction Risk Scoring

---

# Business Problem

Banks process millions of UPI, IMPS, NEFT, and RTGS transactions daily. Suspicious transaction patterns such as rapid fund transfers, structuring, account takeover attempts, and unusual device/location behaviour must be identified quickly to reduce fraud exposure and operational risk.

This project demonstrates SQL-based anomaly detection logic for transaction monitoring and fraud-risk analysis using synthetic banking datasets.

---

# Fraud Detection Cases

| Case | Fraud Scenario | SQL Concepts Used |
|------|----------------|------------------|
| Case 1 | Velocity Burst Detection | CTE, LAG, DATEDIFF |
| Case 2 | Transaction Spike Detection | Window Aggregation |
| Case 3 | Account Takeover (ATO) | JOIN, CASE |
| Case 4 | Geo / Device Mismatch | EXISTS, CASE |
| Case 5 | New Beneficiary Risk | Aggregation |
| Case 6 | Structuring Detection | CTE, Threshold Logic |
| Case 7 | Mule Account Detection | Self Join |
| Case 8 | Risk Scoring Engine | Multi-CTE |

---

# SQL Techniques Used

- CTEs
- Window Functions
- LAG / LEAD
- CASE Statements
- Aggregations
- ROW_NUMBER
- DATEDIFF
- Threshold Logic
- Self Joins

---

# India BFSI Context

The fraud monitoring scenarios are designed around Indian banking transaction channels such as:

- UPI
- IMPS
- NEFT
- RTGS

The project also incorporates RBI-aligned structuring logic and transaction monitoring concepts commonly used in BFSI environments.

---

# Sample Outputs

Sample alert outputs and risk classifications are available in the `sample_outputs/` folder.

---

# Dashboard & Reporting

Basic operational dashboards and fraud alert summaries are included using Power BI and Excel.

---

# Objective

The goal of this project is to simulate practical SQL-driven transaction monitoring workflows and fraud detection logic used in banking operations and risk-monitoring environments.
