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
    SNOWFLAKE.CORTEX.COMPLETE(
        'mistral-large',
        CONCAT(
            'You are a senior data engineer. Analyze the following dbt model execution and SQL query.\n\n',

            'Model Name: ', m.NAME, '\n',
            'Runtime: ', m.TOTAL_NODE_RUNTIME, ' seconds\n',
            'Materialization: ', m.MATERIALIZATION, '\n',
            'Rows Affected: ', m.ROWS_AFFECTED, '\n\n',

            'SQL Query:\n', q.QUERY_TEXT, '\n\n',

            'Tasks:\n',
            '1. Identify performance bottlenecks.\n',
            '2. Consider runtime vs data volume.\n',
            '3. Check joins, scans, and window functions.\n',
            '4. Suggest ONE concise, high-impact optimization.\n'
        )
    ),
    SNOWFLAKE.CORTEX.COMPLETE(
        'mistral-large',
        CONCAT(
            'Summarize the main optimization in EXACTLY 2 to 3 words.\n',
            'No explanation. No punctuation. Just words.\n\n',

            'Model Runtime: ', m.TOTAL_NODE_RUNTIME, '\n',
            'Rows: ', m.ROWS_AFFECTED, '\n',
            'SQL:\n', q.QUERY_TEXT, '\n'
        )
    )

FROM DBT_ANALYTICS.DBT.MODEL_EXECUTIONS_STREAM m
JOIN SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY q
    ON m.ADAPTER_RESPONSE:query_id::string = q.QUERY_ID;

ALTER TASK  DBT_ANALYTICS.DBT.RECOMMENDATION_TASK RESUME;
