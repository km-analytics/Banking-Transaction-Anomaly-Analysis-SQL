-- =========================================================
-- CASE 4: GEO / DEVICE MISMATCH MONITORING
-- =========================================================

WITH known_device_history AS (

    SELECT DISTINCT

        account_id,
        device_id,
        location

    FROM login_events

),


mismatch_analysis AS (

    SELECT

        l.account_id,
        l.device_id,
        l.location,
        l.login_timestamp,

        CASE

            WHEN NOT EXISTS (

                SELECT 1
                FROM known_device_history k
                WHERE k.account_id = l.account_id
                  AND k.device_id = l.device_id
                  AND k.location = l.location

            )

            THEN 'GEO_DEVICE_ALERT'

            ELSE 'NORMAL'

        END AS alert_status

    FROM login_events l

),


risk_summary AS (

    SELECT

        account_id,

        COUNT(*) AS mismatch_count,

        CASE

            WHEN COUNT(*) >= 5
            THEN 'HIGH'

            WHEN COUNT(*) >= 3
            THEN 'MEDIUM'

            ELSE 'LOW'

        END AS risk_tier

    FROM mismatch_analysis

    WHERE alert_status = 'GEO_DEVICE_ALERT'

    GROUP BY account_id

)


SELECT *

FROM risk_summary

ORDER BY mismatch_count DESC;
