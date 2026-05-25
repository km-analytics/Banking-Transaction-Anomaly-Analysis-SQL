-- Case 2: High Amount Spike

-- Scenario:
-- User has spent a high total amount within a short time window

-- Logic:
-- Entity  : Customer_ID
-- Time    : Last 24 hours
-- Measure : SUM(amount)
-- Rule    : SUM(amount) >= 50000

SELECT 
    customerID, 
    SUM(amount) AS total_spend_24hr
FROM aml_training_transactions
WHERE transactionDT >= DATEADD(hour, -24, GETDATE())
GROUP BY customerID
HAVING SUM(amount) >= 50000;

-- Positive Case (Suspicious):
-- User performs high-value transactions within a short period
-- Indicates abnormal financial behavior
-- Risk: 2 (Moderate)

-- Negative Case (Not Fraud):
-- High amount transaction from same device, location, and known beneficiary
-- Likely genuine activity (e.g., planned purchase or transfer)
-- Risk: 1–2 (Low–Moderate)

-- Business Impact:
-- High-value transactions increase financial exposure
-- May result in significant loss if fraudulent

-- Combination Insight:
-- If combined with new device, new location, or new beneficiary → High Risk (Level 3)

-- Final Explanation:
-- User has performed high-value transactions within a short time window
-- Indicates unusual spending behavior but not sufficient alone to confirm fraud

-- Risk Level: 2 (Moderate)
-- Action: Monitor and review
