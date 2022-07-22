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

---- p231
---- �м��Լ� window �Լ�
---- ����
---- �м��Լ�(�Ű�����) over(partition by)
---- �м��Լ�
---- row_number()/rownum

SELECT
    department_id
    ,emp_name
    ,ROW_NUMBER()OVER(PARTITION BY department_id
                        ORDER BY department_id,emp_name)dep_rows
FROM employees;

SELECT
    department_id
    ,emp_name   
    , RANK()OVER(PARTITION BY department_id ORDER BY salary)dep_rank
FROM employees;

SELECT department_id
        , emp_name
        ,salary
        ,DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary ) dep_rank
      FROM employees;
      
---- p.234
---- WITH �� ����

with temp AS (
SELECT 
    department_id
    , emp_name
    , salary
    -- , RANK () OVER (PARTITION BY department_id ORDER BY salary) dep_rank
    , DENSE_RANK () OVER (PARTITION BY department_id ORDER BY salary) dep_rank
FROM employees)

SELECT * 
FROM (SELECT 
    department_id
    , emp_name
    , salary
    -- , RANK () OVER (PARTITION BY department_id ORDER BY salary) dep_rank
    , DENSE_RANK () OVER (PARTITION BY department_id ORDER BY salary) dep_rank
FROM employees)
WHERE dep_rank <= 3;

---- CUME_DIST : ������� ���������� �� ��ȯ

SELECT
    department_id
    , emp_name
    , salary
    ,CUME_DIST()OVER(PARTITION BY department_id
                    ORDER BY salary)dep_dist
FROM employees;

---- PERCENT_RANK
---- ����� ���� ��ȯ
---- 60�� �μ��� ���� CUME_DIST, PERCENT_RANK �� ��ȸ

---- P.236
---- NTIME(����) �Լ�
---- 5���� ���� ���� ��ŭ ��´�

 SELECT 
    department_id
    , emp_name
    , salary
    , NTILE(4) OVER (PARTITION BY department_id ORDER BY salary) NTILES
FROM employees
WHERE department_id IN (30, 60);

---- LAG - ���� �ο� �� ��ȯ
---- LEAD - ���� �ο� �� ��ȯ
---- �ο찡 ���� �� DEFAULT�� ����� �� ��ȯ 

 SELECT 
    emp_name
    , hire_date
    , salary
    , LAG(salary, 1, 0)  OVER (ORDER BY hire_date) AS prev_sal
    , LEAD(salary, 1, 0) OVER (ORDER BY hire_date) AS next_sal
FROM employees
WHERE department_id = 30;

---- WINDOW �Լ�
---- P.240
---- ������ �Ի����� �� ó��
---- UNBOUNDED PRECEDING �޿�, �μ��� �Ի����ڰ� ���� ���� ���
---- UNBOUNDED FOLLOWING �μ��� �Ի����ڰ� ���� ���� ���
---- ���� �հ�

SELECT
    department_id
    , emp_name
    , hire_date
    , salary
    , SUM(salary)OVER(PARTITION BY department_id ORDER BY hire_date
                    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)AS all_salary
FROM employees
WHERE  department_id IN(30,90);


SELECT
    department_id
    , emp_name
    , hire_date
    , salary
    , SUM(salary)OVER(PARTITION BY department_id ORDER BY hire_date
                    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)AS all_salary
    , SUM(salary)OVER(PARTITION BY department_id ORDER BY hire_date
                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)AS first_current_sal
    , SUM(salary)OVER(PARTITION BY department_id ORDER BY hire_date
                    ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)AS current_end_sal           

FROM employees
WHERE  department_id IN(30,90);
