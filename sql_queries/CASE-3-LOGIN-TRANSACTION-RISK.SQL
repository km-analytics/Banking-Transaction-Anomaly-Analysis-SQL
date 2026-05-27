-- =========================================================
-- CASE 3: LOGIN & TRANSACTION RISK ANALYSIS
-- =========================================================

WITH failed_logins AS (

    SELECT

        account_id,

        COUNT(*) AS failed_attempts,

        MAX(login_timestamp) AS latest_failed_attempt

    FROM login_events

    WHERE login_status = 'FAILED'

    GROUP BY account_id

),


transaction_analysis AS (

    SELECT

        t.account_id,
        t.txn_id,
        t.txn_amount,
        t.txn_timestamp,
        fl.failed_attempts,

        CASE

            WHEN fl.failed_attempts >= 3
                 AND t.txn_amount > 50000

            THEN 'LOGIN_RISK_ALERT'

            ELSE 'NORMAL'

        END AS alert_status

    FROM transactions t

    INNER JOIN failed_logins fl
    ON t.account_id = fl.account_id

),


risk_summary AS (

    SELECT

        account_id,

        COUNT(*) AS suspicious_transaction_count,

        SUM(txn_amount) AS suspicious_total_amount,

        CASE

            WHEN COUNT(*) >= 5
            THEN 'HIGH'

            WHEN COUNT(*) >= 3
            THEN 'MEDIUM'

            ELSE 'LOW'

        END AS risk_tier

    FROM transaction_analysis

    WHERE alert_status = 'LOGIN_RISK_ALERT'

    GROUP BY account_id

)


SELECT *

FROM risk_summary

ORDER BY suspicious_total_amount DESC;
