/*
Câu hỏi: những ngành nào có mức lương cao nhất
- xác định 10 ngành nghề có mức lương trung bình cao nhất và cho phép remote
- remove null
- Làm nổi bật các công việc trong job DA, đề xuất insight 
*/

SELECT 
    job_id,
    job_title_short,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
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