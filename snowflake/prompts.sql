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
