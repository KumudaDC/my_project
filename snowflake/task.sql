CREATE OR REPLACE TASK DBT_ANALYTICS.DBT.RECOMMENDATION_TASK
WAREHOUSE = COMPUTE_WH
SCHEDULE = '10 MINUTE'
WHEN SYSTEM$STREAM_HAS_DATA('DBT_ANALYTICS.DBT.MODEL_EXECUTIONS_STREAM')
AS
INSERT INTO DBT_ANALYTICS.DBT.MODEL_RECOMMENDATIONS (
    MODEL_NAME,
    QUERY_TEXT,
    RUN_TIME,
    MATERIALIZATION,
    ROWS_AFFECTED,
    RECOMMENDATION,
    RECOMMENDATION_GIST
    )

    SELECT
    m.NAME,
    q.QUERY_TEXT,
    m.TOTAL_NODE_RUNTIME,
    m.MATERIALIZATION,
    m.ROWS_AFFECTED,

    /* ✅ MAIN AI OUTPUT */
    SNOWFLAKE.CORTEX.COMPLETE(
        'mistral-large',
        CASE 
            WHEN LOWER(m.STATUS) = 'success' THEN
                CONCAT(
                    'You are a senior data engineer.\n\n',

                    'Analyze this dbt model for performance optimization.\n\n',

                    'Model: ', m.NAME, '\n',
                    'Runtime: ', m.TOTAL_NODE_RUNTIME, '\n',
                    'Rows: ', m.ROWS_AFFECTED, '\n',
                    'Materialization: ', m.MATERIALIZATION, '\n\n',

                    'SQL Query:\n', q.QUERY_TEXT, '\n\n',

                    'Give ONE high-impact optimization.'
                )

            ELSE
                CONCAT(
                    'You are a senior data engineer debugging a failed dbt model.\n\n',

                    'Model: ', m.NAME, '\n',
                    'Status: FAILED\n',
                    'Error Message: ', m.MESSAGE, '\n\n',

                    'SQL Query:\n', q.QUERY_TEXT, '\n\n',

                    'Identify the root cause and suggest a fix in 1-2 lines.'
                )
        END
    ),

    /* ✅ GIST OUTPUT */
    SNOWFLAKE.CORTEX.COMPLETE(
        'mistral-large',
        CASE 
            WHEN LOWER(m.STATUS) = 'success' THEN
                CONCAT(
                    'Summarize the optimization in EXACTLY 2 to 3 words.\n',
                    'No punctuation.\n\n',
                    'SQL:\n', q.QUERY_TEXT
                )
            ELSE
                CONCAT(
                    'Summarize the failure root cause in EXACTLY 2 to 3 words.\n',
                    'No punctuation.\n\n',
                    'Error: ', m.MESSAGE
                )
        END
    )

FROM DBT_ANALYTICS.DBT.MODEL_EXECUTIONS_STREAM m
LEFT JOIN SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY q
    ON m.ADAPTER_RESPONSE:query_id::string = q.QUERY_ID;

ALTER TASK  DBT_ANALYTICS.DBT.RECOMMENDATION_TASK RESUME;
