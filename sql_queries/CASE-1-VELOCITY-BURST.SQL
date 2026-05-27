-- =========================================================
-- CASE 1: VELOCITY BURST DETECTION
-- =========================================================
-- Objective:
-- Detect accounts performing multiple rapid transactions
-- within very short time intervals.
--
-- India BFSI Context:
-- Common in UPI / IMPS fraud scenarios,
-- mule account activity,
-- bot-driven transaction bursts,
-- and suspicious rapid fund transfers.
--
-- SQL Concepts Used:
-- CTE
-- Window Function
-- LAG
-- DATEDIFF
-- CASE
-- Aggregation
-- =========================================================


WITH transaction_history AS (

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


time_gap_analysis AS (

    SELECT

        account_id,
        txn_id,
        txn_amount,
        txn_channel,
        txn_timestamp,
        previous_txn_timestamp,

        DATEDIFF(
            SECOND,
            previous_txn_timestamp,
            txn_timestamp
        ) AS transaction_gap_seconds,

        CASE

            WHEN DATEDIFF(
                    SECOND,
                    previous_txn_timestamp,
                    txn_timestamp
                 ) < 120

            THEN 'VELOCITY_ALERT'

            ELSE 'NORMAL'

        END AS alert_status

    FROM transaction_history

    WHERE previous_txn_timestamp IS NOT NULL

),


risk_classification AS (

    SELECT

        account_id,

        COUNT(*) AS suspicious_transaction_count,

        SUM(txn_amount) AS suspicious_total_amount,

        MIN(transaction_gap_seconds) AS minimum_gap_seconds,

        MAX(transaction_gap_seconds) AS maximum_gap_seconds,

        CASE

            WHEN COUNT(*) >= 5
            THEN 'HIGH'

            WHEN COUNT(*) >= 3
            THEN 'MEDIUM'

            ELSE 'LOW'

        END AS risk_tier

    FROM time_gap_analysis

    WHERE alert_status = 'VELOCITY_ALERT'

    GROUP BY account_id

)


SELECT *

FROM risk_classification

ORDER BY suspicious_transaction_count DESC;



/*
=========================================================
SAMPLE OUTPUT
=========================================================

account_id | suspicious_transaction_count | suspicious_total_amount | minimum_gap_seconds | risk_tier
---------------------------------------------------------------------------------------------------
ACC1001    | 7                            | 48500                   | 35                  | HIGH
ACC2033    | 5                            | 21200                   | 58                  | HIGH
ACC4451    | 3                            | 9200                    | 95                  | MEDIUM


BUSINESS INTERPRETATION
---------------------------------------------------------
- ACC1001:
  Multiple UPI transactions detected within 35 seconds.
  Potential rapid-transfer or mule-account behaviour.
  HIGH risk escalation recommended.

- ACC2033:
  Repeated IMPS transfers within short intervals.
  Requires beneficiary and device review.

- ACC4451:
  Medium-risk rapid transaction activity.
  Recommended for monitoring queue review.

=========================================================
*/
