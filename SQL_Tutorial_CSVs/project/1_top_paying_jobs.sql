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

/*
Dựa trên dữ liệu mẫu gồm 10 tin tuyển dụng vị trí Data Analyst remote/full-time, mức lương trung bình năm dao động từ 184,000 USD đến 650,000 USD. Trong đó, Mantys là công ty có mức lương cao nhất với 650,000 USD/năm, cao vượt trội so với phần còn lại của dữ liệu.

Mức lương trung bình của toàn bộ mẫu đạt khoảng 264,506 USD/năm, tuy nhiên chỉ số này bị ảnh hưởng mạnh bởi giá trị outlier từ Mantys. Vì vậy, mức lương trung vị 211,000 USD/năm phản ánh tốt hơn mặt bằng chung của nhóm dữ liệu này.

Phần lớn các job còn lại tập trung trong khoảng 184,000 đến 255,829 USD/năm. Điều này cho thấy các vị trí Data Analyst trong mẫu dữ liệu này có mức lương khá cao, đặc biệt do toàn bộ đều là vị trí Anywhere và Full-time. Tuy nhiên, vì số lượng quan sát chỉ có 10 dòng và có sự xuất hiện của outlier, cần mở rộng dữ liệu để đưa ra kết luận đại diện hơn cho thị trường.
*/