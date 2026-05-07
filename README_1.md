# Phân tích thị trường việc làm Data Analyst

## 1. Giới thiệu

Trong bối cảnh thị trường việc làm ngày càng cạnh tranh và dữ liệu trở thành yếu tố quan trọng trong quá trình ra quyết định, vị trí **Data Analyst** đang được nhiều doanh nghiệp quan tâm. Data Analyst không chỉ cần khả năng xử lý và phân tích dữ liệu, mà còn cần hiểu nghiệp vụ, biết trực quan hóa thông tin và truyền đạt insight một cách rõ ràng.

Dự án này tập trung phân tích các tin tuyển dụng Data Analyst nhằm trả lời các câu hỏi chính:

- Công việc Data Analyst nào có mức lương cao nhất?
- Những kỹ năng nào thường xuất hiện trong các công việc Data Analyst lương cao?
- Kỹ năng nào được yêu cầu nhiều nhất trên thị trường?
- Kỹ năng nào gắn với mức lương trung bình cao nhất?
- Kỹ năng nào vừa phổ biến vừa có mức lương tốt?

Thông qua phân tích bằng **SQL** và trực quan hóa bằng **Python**, dự án giúp xác định những kỹ năng quan trọng mà một Data Analyst nên ưu tiên học tập và phát triển để tăng cơ hội nghề nghiệp cũng như mức thu nhập.

---

## 2. Bối cảnh về dữ liệu

Bộ dữ liệu được sử dụng trong dự án bao gồm thông tin về các tin tuyển dụng trong lĩnh vực dữ liệu, tập trung vào vị trí **Data Analyst**. Một số trường dữ liệu chính bao gồm:

- `company_dim`: thông tin về doanh nghiệp
- `job_posting_fact`: dữ liệu về bài tuyển dụng
- `skills_dim`: thông tin về kỹ năng
- `skills_job_dim`: dữ liệu về kỹ năng tương ứng với bài tuyển dụng


Dựa trên notebook phân tích, dự án tập trung trả lời 5 câu hỏi:

1. **Các công việc Data Analyst nào có mức lương cao nhất?**
2. **Các kỹ năng nào được yêu cầu nhiều trong các công việc lương cao?**
3. **Đâu là kỹ năng cần thiết nhất cho các công việc Data Analyst?**
4. **Kỹ năng nào được trả nhiều tiền nhất?**
5. **Đâu là kỹ năng vừa cần thiết vừa được trả lương cao?**

---

## 3. Các công cụ sử dụng

Dự án sử dụng các công cụ sau:

- **VS Code**: viết, quản lý và tổ chức project.
- **Jupyter Notebook**: phân tích dữ liệu, chạy code Python và trực quan hóa biểu đồ.
- **SQL**: truy vấn, lọc, tổng hợp và xử lý dữ liệu từ database.
- **Python**: phân tích dữ liệu và trực quan hóa.
- **Pandas**: xử lý bảng dữ liệu.
- **Matplotlib**: vẽ biểu đồ.
- **Git & GitHub**: quản lý phiên bản source code và lưu trữ project.

---

## 4. Phân tích dữ liệu

### Câu hỏi 1: Các công việc Data Analyst nào có mức lương cao nhất?

#### Mục tiêu phân tích

Xác định các công ty hoặc công việc Data Analyst có mức lương trung bình năm cao nhất. Phân tích này giúp nhận diện nhóm công việc trả lương tốt nhất và những công ty nổi bật trong thị trường tuyển dụng Data Analyst.

#### SQL Query

```sql
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
```

#### Biểu đồ

```markdown
![Top 10 công ty có mức lương Data Analyst cao nhất](assets/question%201.png)
```

#### Nhận xét

Biểu đồ thể hiện **top 10 công ty có mức lương Data Analyst cao nhất**, trong đó **Mantys** nổi bật với mức lương vượt trội. Các công ty còn lại có mức lương dao động chủ yếu trong khoảng **184K–336K USD/năm**.

Điều này cho thấy trong nhóm công việc Data Analyst lương cao, vẫn có sự chênh lệch đáng kể giữa các công ty. Một số vị trí có thể yêu cầu kỹ năng chuyên sâu hơn, kinh nghiệm cao hơn hoặc thuộc các doanh nghiệp có ngân sách tuyển dụng lớn hơn.

---

### Câu hỏi 2: Các kỹ năng nào được yêu cầu nhiều trong các công việc lương cao?

#### Mục tiêu phân tích

Phân tích các kỹ năng xuất hiện trong nhóm công việc Data Analyst có mức lương cao nhất. Mục tiêu là tìm ra những kỹ năng thường được yêu cầu ở các vị trí có thu nhập tốt.

#### SQL Query

```sql
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
```

#### Biểu đồ


![Top kỹ năng trong các công việc Data Analyst lương cao](assets/question%202.png)


#### Nhận xét

Biểu đồ cho thấy **SQL** và **Python** là hai kỹ năng được yêu cầu nhiều nhất trong các công việc Data Analyst lương cao. Tiếp theo là **Tableau** và **R**.

Điều này phản ánh rằng nhà tuyển dụng đặc biệt ưu tiên các kỹ năng liên quan đến:

- Truy vấn và xử lý dữ liệu
- Lập trình phân tích
- Trực quan hóa dữ liệu
- Hỗ trợ ra quyết định dựa trên dữ liệu

Nhóm kỹ năng này là nền tảng quan trọng nếu muốn ứng tuyển vào các vị trí Data Analyst có mức lương cao.

---

### Câu hỏi 3: Đâu là kỹ năng cần thiết nhất cho các công việc Data Analyst?

#### Mục tiêu phân tích

Xác định các kỹ năng có số lượng nhu cầu tuyển dụng cao nhất trên thị trường Data Analyst. Phân tích này giúp hiểu kỹ năng nào phổ biến và thường xuyên xuất hiện trong mô tả công việc.

#### SQL Query

```sql
SELECT
    skills,
    COUNT(job_postings_fact.job_id) as demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

WHERE job_title_short = 'Data Analyst'
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5
```

#### Biểu đồ
Các kỹ năng cần thiết nhất cho Data Analyst:
| Kỹ năng | Số lượng nhu cầu |
|---|---:|
| SQL | 92,628 |
| Excel | 67,031 |
| Python | 57,326 |
| Tableau | 46,554 |
| Power BI | 39,468 |

#### Nhận xét

Biểu đồ cho thấy **SQL** là kỹ năng được yêu cầu nhiều nhất cho vị trí Data Analyst, tiếp theo là **Excel** và **Python**. Đây là ba kỹ năng nền tảng quan trọng nhất đối với một Data Analyst.

Cụ thể:

- **SQL** giúp truy vấn và thao tác dữ liệu từ cơ sở dữ liệu.
- **Excel** vẫn là công cụ phổ biến trong xử lý, tổng hợp và báo cáo dữ liệu.
- **Python** hỗ trợ phân tích nâng cao, tự động hóa và xử lý dữ liệu lớn hơn.

Ngoài ra, **Tableau** và **Power BI** cũng xuất hiện trong nhóm kỹ năng quan trọng, cho thấy trực quan hóa dữ liệu là một năng lực cần thiết trong công việc Data Analyst.

---

### Câu hỏi 4: Kỹ năng nào được trả nhiều tiền nhất?

#### Mục tiêu phân tích

Tìm ra các kỹ năng có mức lương trung bình cao nhất. Phân tích này giúp nhận diện những kỹ năng có thể tạo ra lợi thế về thu nhập cho Data Analyst.

#### SQL Query

```sql
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
```

#### Biểu đồ

![Top kỹ năng có mức lương trung bình cao nhất](assets/question%204.png)


#### Nhận xét

Biểu đồ cho thấy **SVN** là kỹ năng có mức lương trung bình cao nhất, đạt khoảng **400,000 USD/năm**, cao vượt trội so với các kỹ năng còn lại.

Sau SVN, các kỹ năng như **Solidity**, **Couchbase**, **DataRobot** và **Golang** cũng nằm trong nhóm kỹ năng có mức lương cao.

Tuy nhiên, cần lưu ý rằng một kỹ năng có mức lương trung bình cao chưa chắc là kỹ năng phổ biến. Một số kỹ năng có thể xuất hiện ít nhưng gắn với các vị trí đặc thù, yêu cầu chuyên môn cao hoặc nằm trong những ngành có mức đãi ngộ tốt.

---

### Câu hỏi 5: Đâu là kỹ năng vừa cần thiết vừa được trả lương cao?

#### Mục tiêu phân tích

Kết hợp hai yếu tố:

- `demand_count`: mức độ phổ biến của kỹ năng trên thị trường tuyển dụng
- `avg_salary`: mức lương trung bình gắn với kỹ năng đó

Mục tiêu là xác định những kỹ năng vừa có nhu cầu cao vừa mang lại mức lương tốt.

#### SQL Query

```sql
WITH skills_demand AS (
    SELECT
        skills_dim.skills,
        skills_dim.skill_id,
        COUNT(job_postings_fact.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    
    WHERE 
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY skills_dim.skill_id
), average_salary AS (
    SELECT
        skills_dim.skills,
        skills_dim.skill_id,
        AVG(job_postings_fact.salary_year_avg) as avg_salary
    FROM job_postings_fact

    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

    WHERE salary_year_avg IS NOT NULL
    AND job_title_short = 'Data Analyst'
    GROUP BY skills_dim.skill_id
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id

ORDER BY
    demand_count DESC,
    avg_salary DESC
LIMIT 10
```

#### Biểu đồ

![Kỹ năng phổ biến và được trả lương cao](assets/question%205.png)


#### Nhận xét

Biểu đồ cho thấy **Python** và **Tableau** là hai kỹ năng nổi bật vì vừa có mức độ phổ biến cao vừa có mức lương trung bình cao hơn mặt bằng chung.

Trong khi đó:

- **SQL** là kỹ năng phổ biến nhất nhưng mức lương ở mức trung bình khá.
- **Looker** có mức lương trung bình cao nhất trong nhóm kỹ năng phổ biến, nhưng nhu cầu tuyển dụng thấp hơn nhiều.
- **Excel** có nhu cầu cao nhưng mức lương trung bình thấp hơn so với Python, Tableau và R.

Từ đó có thể thấy, nếu muốn tối ưu cả cơ hội việc làm và thu nhập, người học Data Analyst nên ưu tiên các kỹ năng như **SQL, Python, Tableau**, sau đó mở rộng thêm **Power BI, R, Looker** tùy theo định hướng nghề nghiệp.

---

## 5. Kết luận

### 5.1 Insight chính

Một số insight quan trọng từ quá trình phân tích:

- **SQL** là kỹ năng quan trọng nhất đối với Data Analyst vì xuất hiện nhiều nhất trong các tin tuyển dụng.
- **Python** là kỹ năng có giá trị cao vì vừa phổ biến vừa gắn với mức lương trung bình tốt.
- **Tableau** là kỹ năng trực quan hóa nổi bật, có nhu cầu cao và mức lương tốt.
- **Excel** vẫn là kỹ năng nền tảng quan trọng, dù mức lương trung bình không cao bằng Python hoặc Tableau.
- Một số kỹ năng như **SVN, Solidity, Couchbase, DataRobot, Golang** có mức lương cao, nhưng có thể mang tính chuyên biệt và không phổ biến bằng các kỹ năng cốt lõi của Data Analyst.
- Để phát triển theo hướng Data Analyst, nên tập trung vào bộ kỹ năng nền tảng gồm **SQL, Excel, Python, Tableau/Power BI**, sau đó học thêm các công cụ nâng cao tùy theo lĩnh vực mong muốn.

### 5.2 Cảm nghĩ 

Thông qua dự án này, tôi hiểu rõ hơn về cách sử dụng dữ liệu để phân tích thị trường việc làm và định hướng phát triển kỹ năng cho vị trí Data Analyst. 

Dự án cũng giúp tôi rèn luyện thêm kỹ năng sử dụng **SQL** để truy vấn dữ liệu, **Python** để xử lý và trực quan hóa, cũng như cách trình bày kết quả phân tích một cách rõ ràng trong Jupyter Notebook và README. Đây là một bước thực hành quan trọng giúp tôi kết nối kiến thức phân tích dữ liệu với một bài toán thực tế về định hướng nghề nghiệp.

