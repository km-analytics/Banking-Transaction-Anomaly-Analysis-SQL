-- Case 1: Velocity Burst Detection
-- Detect accounts with multiple transactions within short intervals
-- India BFSI context: UPI / IMPS rapid transaction behaviour

WITH txn_with_lag AS (

    SELECT
        account_id,
        txn_id,
        txn_amount,
        txn_channel,
        txn_timestamp,

        LAG(txn_timestamp) OVER (
            PARTITION BY account_id
            ORDER BY txn_timestamp
        ) AS previous_txn_timestamp

    FROM transactions

),

velocity_flags AS (

    SELECT
        account_id,
        txn_id,
        txn_amount,
        txn_channel,
        txn_timestamp,

        DATEDIFF(
            SECOND,
            previous_txn_timestamp,
            txn_timestamp
        ) AS seconds_between_txns,

        CASE
            WHEN DATEDIFF(
                    SECOND,
                    previous_txn_timestamp,
                    txn_timestamp
                 ) < 120
            THEN 'VELOCITY_FLAG'

            ELSE 'NORMAL'

        END AS alert_status

    FROM txn_with_lag

    WHERE previous_txn_timestamp IS NOT NULL

),

final_alerts AS (

    SELECT
        account_id,
        COUNT(*) AS flagged_txn_count,
        SUM(txn_amount) AS total_amount,

        MIN(seconds_between_txns) AS minimum_gap_seconds,

        CASE
            WHEN COUNT(*) >= 5 THEN 'HIGH'
            WHEN COUNT(*) >= 3 THEN 'MEDIUM'
            ELSE 'LOW'
        END AS risk_tier

    FROM velocity_flags

    WHERE alert_status = 'VELOCITY_FLAG'

    GROUP BY account_id

)

SELECT *
FROM final_alerts
ORDER BY flagged_txn_count DESC;


/*
SAMPLE OUTPUT

account_id | flagged_txn_count | total_amount | minimum_gap_seconds | risk_tier
--------------------------------------------------------------------------------
ACC1001    | 7                 | 48500        | 35                  | HIGH
ACC2033    | 5                 | 21200        | 58                  | HIGH
ACC4451    | 3                 | 9200         | 95                  | MEDIUM

Interpretation:
- Multiple UPI / IMPS transactions observed within short intervals.
- Potential automated transfer or mule-account activity.
*/
