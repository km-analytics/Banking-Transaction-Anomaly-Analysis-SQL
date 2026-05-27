-- =========================================================
-- CASE 8: TRANSACTION RISK SCORING ENGINE
-- =========================================================

WITH transaction_risk_base AS (

    SELECT

        account_id,
        txn_amount,
        txn_channel,

        CASE

            WHEN txn_amount > 200000
            THEN 40

            ELSE 10

        END AS amount_risk_score,

        CASE

            WHEN txn_channel = 'UPI'
            THEN 20

            ELSE 10

        END AS channel_risk_score

    FROM transactions

),


final_risk_score AS (

    SELECT

        account_id,

        SUM(amount_risk_score + channel_risk_score) AS total_risk_score,

        CASE

            WHEN SUM(amount_risk_score + channel_risk_score) >= 300
            THEN 'HIGH'

            WHEN SUM(amount_risk_score + channel_risk_score) >= 150
            THEN 'MEDIUM'

            ELSE 'LOW'

        END AS risk_tier

    FROM transaction_risk_base

    GROUP BY account_id

)


SELECT *

FROM final_risk_score

ORDER BY total_risk_score DESC;
