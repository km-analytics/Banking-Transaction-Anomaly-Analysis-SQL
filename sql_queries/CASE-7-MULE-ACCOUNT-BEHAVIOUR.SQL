-- =========================================================
-- CASE 7: MULE ACCOUNT BEHAVIOUR ANALYSIS
-- =========================================================

WITH incoming_transactions AS (

    SELECT

        beneficiary_account AS account_id,
        SUM(txn_amount) AS incoming_amount

    FROM transactions

    GROUP BY beneficiary_account

),


outgoing_transactions AS (

    SELECT

        sender_account AS account_id,
        SUM(txn_amount) AS outgoing_amount

    FROM transactions

    GROUP BY sender_account

),


mule_analysis AS (

    SELECT

        i.account_id,
        i.incoming_amount,
        o.outgoing_amount,

        CASE

            WHEN i.incoming_amount > 500000
                 AND o.outgoing_amount > 500000

            THEN 'MULE_PATTERN_ALERT'

            ELSE 'NORMAL'

        END AS alert_status

    FROM incoming_transactions i

    INNER JOIN outgoing_transactions o
    ON i.account_id = o.account_id

)


SELECT *

FROM mule_analysis

WHERE alert_status = 'MULE_PATTERN_ALERT'

ORDER BY incoming_amount DESC;
