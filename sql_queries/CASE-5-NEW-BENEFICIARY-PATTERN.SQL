-- =========================================================
-- CASE 5: NEW BENEFICIARY PATTERN ANALYSIS
-- =========================================================

WITH beneficiary_history AS (

    SELECT DISTINCT

        sender_account,
        beneficiary_account

    FROM transactions

),


beneficiary_analysis AS (

    SELECT

        t.sender_account,
        t.beneficiary_account,
        t.txn_amount,
        t.txn_timestamp,

        CASE

            WHEN NOT EXISTS (

                SELECT 1
                FROM beneficiary_history b
                WHERE b.sender_account = t.sender_account
                  AND b.beneficiary_account = t.beneficiary_account

            )

            THEN 'NEW_BENEFICIARY_ALERT'

            ELSE 'NORMAL'

        END AS alert_status

    FROM transactions t

),


risk_summary AS (

    SELECT

        sender_account,

        COUNT(*) AS beneficiary_alert_count,

        SUM(txn_amount) AS total_transaction_amount,

        CASE

            WHEN COUNT(*) >= 5
            THEN 'HIGH'

            WHEN COUNT(*) >= 3
            THEN 'MEDIUM'

            ELSE 'LOW'

        END AS risk_tier

    FROM beneficiary_analysis

    WHERE alert_status = 'NEW_BENEFICIARY_ALERT'

    GROUP BY sender_account

)


SELECT *

FROM risk_summary

ORDER BY total_transaction_amount DESC;
