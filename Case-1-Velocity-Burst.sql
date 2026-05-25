-- Case 1: Velocity Detection

-- Scenario:
-- User performs multiple transactions within a short time window

-- Logic:
-- Entity  : Customer_ID
-- Time    : Last 10 minutes
-- Measure : COUNT(transaction)
-- Rule    : COUNT >= 6

SELECT 
    customerID, 
    COUNT(*) AS txn_count_10min
FROM aml_training_transactions
WHERE transactionDT >= DATEADD(minute, -10, GETDATE())
GROUP BY customerID
HAVING COUNT(*) >= 6;

-- Positive Case (Suspicious):
-- User performs multiple transactions in a short time window
-- May indicate automated activity or abnormal usage
-- Risk: 2 (Moderate)

-- Negative Case (Not Fraud):
-- User performs multiple transactions from same device, location, and known beneficiary
-- Likely normal behavior (e.g., multiple bill payments)
-- Risk: 1–2 (Low–Moderate)

-- Business Impact:
-- High transaction frequency may indicate bot-driven activity
-- Can lead to financial loss if combined with other anomalies

-- Combination Insight:
-- If combined with new device or new location → escalates to High Risk (Level 3)

-- Final Explanation:
-- User performed multiple transactions in a short time window
-- Indicates velocity burst and potential abnormal activity
-- Not sufficient alone to confirm fraud

-- Risk Level: 2 (Moderate)
-- Action: Monitor and review
