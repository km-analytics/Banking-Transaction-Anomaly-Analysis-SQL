-- =========================================================
-- CASE 2: TRANSACTION SPIKE DETECTION
-- =========================================================
-- Objective:
-- Detect accounts showing sudden transaction spikes
-- compared to their historical transaction behaviour.
--
-- BFSI Context:
-- Sudden amount spikes may indicate:
-- unusual transaction activity,
-- operational anomalies,
-- rapid fund movement,
-- or suspicious account behaviour.
--
-- SQL Concepts Used:
-- CTE
-- Window Functions
-- AVG
-- CASE
-- Aggregation
-- =========================================================


WITH transaction_baseline AS (

    SELECT

        account_id,
        txn_id,
        txn_amount,
        txn_timestamp,

        AVG(txn_amount) OVER (

            PARTITION BY account_id

        ) AS average_transaction_amount

    FROM transactions

),


spike_detection AS (

    SELECT

        account_id,
        txn_id,
        txn_amount,
        txn_timestamp,
        average_transaction_amount,

        CASE

            WHEN txn_amount > average_transaction_amount * 3

            THEN 'SPIKE_ALERT'

            ELSE 'NORMAL'

        END AS alert_status

    FROM transaction_baseline

),


risk_summary AS (

    SELECT

        account_id,

        COUNT(*) AS spike_transaction_count,

        SUM(txn_amount) AS spike_total_amount,

        MAX(txn_amount) AS maximum_transaction_amount,

        CASE

            WHEN COUNT(*) >= 5
            THEN 'HIGH'

            WHEN COUNT(*) >= 3
            THEN 'MEDIUM'

            ELSE 'LOW'

        END AS risk_tier

    FROM spike_detection

    WHERE alert_status = 'SPIKE_ALERT'

    GROUP BY account_id

)


SELECT *

FROM risk_summary

ORDER BY spike_total_amount DESC;



/*
=========================================================
SAMPLE OUTPUT
=========================================================

account_id | spike_transaction_count | spike_total_amount | maximum_transaction_amount | risk_tier
------------------------------------------------------------------------------------------------
ACC2211    | 5                       | 850000             | 250000                     | HIGH
ACC8890    | 3                       | 320000             | 150000                     | MEDIUM

=========================================================
*/
