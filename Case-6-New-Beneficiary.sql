-- Case 6: New Beneficiary Risk

-- Scenario:
-- Transfer made to a newly added beneficiary

-- Logic:
-- Entity  : Customer_ID
-- Time    : Current vs past history
-- Measure : BeneficiaryID
-- Rule    : Beneficiary NOT seen in past

SELECT a.customerID, a.beneficiaryID, a.amount, a.transactionDT
FROM aml_training_transactions a
WHERE a.transactionDT >= DATEADD(day, -1, GETDATE())
AND NOT EXISTS (
    SELECT 1
    FROM aml_training_transactions b
    WHERE b.customerID = a.customerID
      AND b.beneficiaryID = a.beneficiaryID
      AND b.transactionDT < a.transactionDT
);

-- Explanation:
-- Funds transferred to a new beneficiary not seen in user's history
-- Indicates potential mule account or fraudulent transfer

-- Risk Level: 3 (High)
-- Action: Alert and immediate verification
