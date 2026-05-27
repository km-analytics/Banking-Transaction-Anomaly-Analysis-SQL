-- =========================================================
-- CASE 6: STRUCTURING DETECTION
-- =========================================================

WITH daily_transaction_summary AS (

    SELECT

        account_id,

        CAST(txn_timestamp AS DATE) AS transaction_date,

        COUNT(*) AS transaction_count,

        SUM(txn_amount) AS total_transaction_amount,

        MAX(txn_amount) AS maximum_transaction_amount

    FROM transactions

    GROUP BY
        account_id,
        CAST(txn_timestamp AS DATE)

),


structuring_analysis AS (

    SELECT

        account_id,
        transaction_date,
        transaction_count,
        total_transaction_amount,
        maximum_transaction_amount,

        CASE

            WHEN total_transaction_amount > 800000
                 AND maximum_transaction_amount < 200000
                 AND transaction_count >= 5

            THEN 'STRUCTURING_ALERT'

            ELSE 'NORMAL'

        END AS alert_status

    FROM daily_transaction_summary

)


SELECT *

FROM structuring_analysis

WHERE alert_status = 'STRUCTURING_ALERT'

ORDER BY total_transaction_amount DESC;
