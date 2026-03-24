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
