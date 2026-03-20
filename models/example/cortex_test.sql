SELECT 
    'Is the AI working?' as question,
    SNOWFLAKE.CORTEX.COMPLETE('llama3-70b', 'Confirm if you are online with a short "Yes, I am online!"') as ai_answer