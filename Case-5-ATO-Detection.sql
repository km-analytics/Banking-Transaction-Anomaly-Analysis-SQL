-- Case 5: Account Takeover (ATO) Login Pattern

-- Scenario:
-- Multiple failed login attempts followed by a successful login

-- Logic:
-- Entity  : Customer_ID
-- Time    : Last 30 minutes
-- Measure : Failed + Success login count
-- Rule    : Failed >= 3 AND Success >= 1

SELECT 
    customerID,
    SUM(CASE WHEN login_status = 'FAILED' THEN 1 ELSE 0 END) AS failed_count,
    SUM(CASE WHEN login_status = 'SUCCESS' THEN 1 ELSE 0 END) AS success_count
FROM aml_training_transactions
WHERE transactionDT >= DATEADD(minute, -30, GETDATE())
GROUP BY customerID
HAVING 
    SUM(CASE WHEN login_status = 'FAILED' THEN 1 ELSE 0 END) >= 3
    AND SUM(CASE WHEN login_status = 'SUCCESS' THEN 1 ELSE 0 END) >= 1;

-- Explanation:
-- Multiple failed login attempts followed by a successful login detected
-- Indicates possible password compromise and account takeover attempt

-- Risk Level: 3 (High)
-- Action: Alert, restrict access, and verify user
