/*
Kỹ năng nào được trả nhiều tiền nhất?
*/

SELECT
    skills_dim.skills,
    AVG(job_postings_fact.salary_year_avg) as avg_salary
FROM job_postings_fact

INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

WHERE salary_year_avg IS NOT NULL
AND job_title_short = 'Data Analyst'
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 25