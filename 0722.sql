-- 198p 
-- 서브쿼리
-- SELECT, FROM, WHERE 
-- FROM : 인라인 뷰
-- 메인 쿼리 : 사원테이블에서는 id, name 출력
--                    부서테이블에서는 부서ID, 부서명 출력
--                     사원테이블의 급여가 기획부서의 평균급여보다 높은 사람
--                     a.salary > d.avg_salary
-- 서브쿼리 : 기획부서의 평균급여
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

-- p.199 하단
-- 2000년 이탈리아 평균 매출액(연평균)보다 큰 월의 평균 매출액을 구하는 것
-- 월별 평균 매출액 쿼리
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
    AND c.COUNTRY_NAME = 'Italy' -- 이탈리아
GROUP BY a.sales_month;

-- 연평균 매출액 쿼리
SELECT 
    ROUND(AVG(a.amount_sold)) AS year_avg
FROM 
    sales a
    , customers b
    , countries c
WHERE a.sales_month BETWEEN '20001' AND '200012'
    AND a.cust_id = b.CUST_ID
    AND b.COUNTRY_ID = c.COUNTRY_ID 
    AND c.COUNTRY_NAME = 'Italy'; -- 이탈리아
    
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
                AND c.COUNTRY_NAME = 'Italy' -- 이탈리아
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

-- 계층형 쿼리
-- p.208 부서정보
-- p.211
-- START WITH 조건 & CONNECT BY 조건
-- parent_id == 상위 부서 정보를 가지고 있음. 
-- CONNECT BY PRIOR department_id = parent_id
SELECT 
    department_id
    , LPAD(' ', 3 * (LEVEL - 1)) || department_name, LEVEL 
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id;

-- 사원테이블에 있는 manager_id, employee_id
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

-- 계층형 쿼리 심화학습
-- 쿼리가 나옴. ORDER BY 정렬 가능 
-- ORDER SIBLINGS BY 
SELECT 
    department_id
    , LPAD(' ', 3 * (LEVEL-1)) || department_name
    , LEVEL
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id
ORDER SIBLINGS BY department_name;

-- 연산자
SELECT 
    department_id
    , LPAD(' ', 3 * (LEVEL-1)) || department_name
    , LEVEL
    , CONNECT_BY_ROOT department_name AS root_name 
FROM departments 
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id;

-- p.216 CONNECT_BY_ISLEAF
-- 계층형 쿼리 응용
-- 샘플 데이터 만들기
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

-- WITH절 
-- 서브쿼리의 가독성 향상
-- 연도별, 최종, 월별 

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
---- 분석함수 window 함수
---- 문법
---- 분석함수(매개변수) over(partition by)
---- 분석함수
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
---- WITH 절 응용

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

---- CUME_DIST : 상대적인 누적분포도 값 반환

SELECT
    department_id
    , emp_name
    , salary
    ,CUME_DIST()OVER(PARTITION BY department_id
                    ORDER BY salary)dep_dist
FROM employees;

---- PERCENT_RANK
---- 백분위 순위 반환
---- 60번 부서에 대한 CUME_DIST, PERCENT_RANK 값 조회

---- P.236
---- NTIME(숫자) 함수
---- 5개의 행을 숫자 만큼 담는다

 SELECT 
    department_id
    , emp_name
    , salary
    , NTILE(4) OVER (PARTITION BY department_id ORDER BY salary) NTILES
FROM employees
WHERE department_id IN (30, 60);

---- LAG - 선행 로우 값 반환
---- LEAD - 후행 로우 값 반환
---- 로우가 없을 시 DEFAULT로 명시한 값 반환 

 SELECT 
    emp_name
    , hire_date
    , salary
    , LAG(salary, 1, 0)  OVER (ORDER BY hire_date) AS prev_sal
    , LEAD(salary, 1, 0) OVER (ORDER BY hire_date) AS next_sal
FROM employees
WHERE department_id = 30;

---- WINDOW 함수
---- P.240
---- 정렬은 입사일자 순 처리
---- UNBOUNDED PRECEDING 급여, 부서별 입사일자가 가장 빠른 사원
---- UNBOUNDED FOLLOWING 부서별 입사잊자가 가장 늦은 사원
---- 누적 합계

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
