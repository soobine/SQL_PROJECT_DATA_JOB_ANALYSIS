/*
Question: Đâu là những skills được yêu cầu trong các top paying jobs?
- Sử dụng các jobs truy vấn từ query 1
- Thêm các skills cụ thể cho vai trò
- Giúp hiểu thêm các kỹ năng cần thiết để có được mức lương cao
*/

WITH top_paying_jobs AS(
    SELECT 
        job_id,
        job_title_short,
        salary_year_avg,
        company_dim.name AS company_name
    FROM
        job_postings_fact

    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        salary_year_avg IS NOT NULL
        AND job_title_short = 'Data Analyst'
        AND job_location = 'Anywhere'
    ORDER BY salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.job_id,
    top_paying_jobs.job_title_short,
    top_paying_jobs.salary_year_avg,
    top_paying_jobs.company_name,
    skills_dim.skills,
    skills_dim.type

FROM top_paying_jobs

INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

