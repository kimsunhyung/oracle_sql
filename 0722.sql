-- 198p 
-- ��������
-- SELECT, FROM, WHERE 
-- FROM : �ζ��� ��
-- ���� ���� : ������̺����� id, name ���
--                    �μ����̺����� �μ�ID, �μ��� ���
--                     ������̺��� �޿��� ��ȹ�μ��� ��ձ޿����� ���� ���
--                     a.salary > d.avg_salary
-- �������� : ��ȹ�μ��� ��ձ޿�
SELECT 
    a.employee_id
    , a.emp_name
    , b.department_id
    , b.department_name
FROM employees a
            , departments b 
            , (SELECT AVG(c.salary) AS avg_salary
               FROM departments b
                           , employees c
               WHERE b.parent_id = 90
                    AND b.department_id = c.department_id) d
WHERE a.department_id = b.department_id
    AND a.salary > d.avg_salary;

-- p.199 �ϴ�
-- 2000�� ��Ż���� ��� �����(�����)���� ū ���� ��� ������� ���ϴ� ��
-- ���� ��� ����� ����
SELECT 
    a.sales_month
    , ROUND(AVG(a.amount_sold)) AS month_avg 
FROM 
    sales a 
    , customers b
    , countries c
WHERE a.sales_month BETWEEN '200001' AND '200012'
    AND a.cust_id = b.CUST_ID 
    AND b.COUNTRY_ID = c.COUNTRY_ID
    AND c.COUNTRY_NAME = 'Italy' -- ��Ż����
GROUP BY a.sales_month;

-- ����� ����� ����
SELECT 
    ROUND(AVG(a.amount_sold)) AS year_avg
FROM 
    sales a
    , customers b
    , countries c
WHERE a.sales_month BETWEEN '20001' AND '200012'
    AND a.cust_id = b.CUST_ID
    AND b.COUNTRY_ID = c.COUNTRY_ID 
    AND c.COUNTRY_NAME = 'Italy'; -- ��Ż����
    
SELECT a.*
FROM (SELECT 
                 a.sales_month
                , ROUND(AVG(a.amount_sold)) AS month_avg 
            FROM 
                sales a 
                , customers b
                , countries c
            WHERE a.sales_month BETWEEN '200001' AND '200012'
                AND a.cust_id = b.CUST_ID 
                AND b.COUNTRY_ID = c.COUNTRY_ID
                AND c.COUNTRY_NAME = 'Italy' -- ��Ż����
                GROUP BY a.sales_month) a
                , (SELECT 
    ROUND(AVG(a.amount_sold)) AS year_avg
FROM 
    sales a
    , customers b
    , countries c
WHERE a.sales_month BETWEEN '20001' AND '200012'
    AND a.cust_id = b.CUST_ID
    AND b.COUNTRY_ID = c.COUNTRY_ID 
    AND c.COUNTRY_NAME = 'Italy') b
WHERE a.month_avg > b.year_avg;

-- ������ ����
-- p.208 �μ�����
-- p.211
-- START WITH ���� & CONNECT BY ����
-- parent_id == ���� �μ� ������ ������ ����. 
-- CONNECT BY PRIOR department_id = parent_id
SELECT 
    department_id
    , LPAD(' ', 3 * (LEVEL - 1)) || department_name, LEVEL 
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id;

-- ������̺� �ִ� manager_id, employee_id
SELECT 
    a.employee_id
    , LPAD(' ', 3 * (LEVEL-1)) || a.emp_name
    , LEVEL
    , b.department_name 
FROM 
    employees a
    , departments b 
WHERE a.department_id = b.department_id 
START WITH a.manager_id IS NULL
CONNECT BY PRIOR a.employee_id = a.manager_id;

-- p.213
SELECT 
    a.employee_id
    , LPAD(' ', 3 * (LEVEL-1)) || a.emp_name
    , LEVEL
    , b.department_name 
    , a.department_id
FROM 
    employees a
    , departments b 
WHERE a.department_id = b.department_id
START WITH a.manager_id IS NULL
CONNECT BY NOCYCLE PRIOR a.employee_id = a.manager_id
    AND a.department_id = 30;

-- ������ ���� ��ȭ�н�
-- ������ ����. ORDER BY ���� ���� 
-- ORDER SIBLINGS BY 
SELECT 
    department_id
    , LPAD(' ', 3 * (LEVEL-1)) || department_name
    , LEVEL
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id
ORDER SIBLINGS BY department_name;

-- ������
SELECT 
    department_id
    , LPAD(' ', 3 * (LEVEL-1)) || department_name
    , LEVEL
    , CONNECT_BY_ROOT department_name AS root_name 
FROM departments 
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id;

-- p.216 CONNECT_BY_ISLEAF
-- ������ ���� ����
-- ���� ������ �����
CREATE TABLE ex7_1 AS 
SELECT 
    ROWNUM seq
    , '2014' || LPAD(CEIL(ROWNUM/1000), 2, '0') month
    , ROUND(DBMS_RANDOM.VALUE(100, 1000)) amt 
FROM DUAL
CONNECT BY LEVEL <= 12000;

SELECT * FROM ex7_1;

SELECT 
    month
    , SUM(amt)
FROM ex7_1
GROUP BY month
ORDER BY month;

-- WITH�� 
-- ���������� ������ ���
-- ������, ����, ���� 

WITH b2 AS (
    SELECT 
        period
        , region
        , sum(loan_jan_amt) jan_amt
    FROM kor_loan_status
    GROUP BY period, region
)

SELECT b2.* FROM b2;